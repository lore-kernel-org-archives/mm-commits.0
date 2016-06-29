From: akpm@linux-foundation.org
Subject: [merged] mm-swapc-flush-lru-pvecs-on-compound-page-arrival.patch
 removed from -mm tree
Date: Tue, 28 Jun 2016 19:02:55 -0700
Message-ID: <57732c4f.Xr+3RR6W3u6mFauX%akpm__23454.3248000138$1467166274$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbcF2CK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lukasz.odzioba@intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mingli199x@qq.com, stable@vger.kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: flush lru pvecs on compound page arrival
has been removed from the -mm tree.  Its filename was
     mm-swapc-flush-lru-pvecs-on-compound-page-arrival.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lukasz Odzioba <lukasz.odzioba@intel.com>
Subject: mm/swap.c: flush lru pvecs on compound page arrival

Currently we can have compound pages held on per cpu pagevecs, which leads
to a lot of memory unavailable for reclaim when needed.  In the systems
with hundreads of processors it can be GBs of memory.

On of the way of reproducing the problem is to not call munmap explicitly
on all mapped regions (i.e.  after receiving SIGTERM).  After that some
pages (with THP enabled also huge pages) may end up on lru_add_pvec,
example below.

void main() {
#pragma omp parallel
{
	size_t size = 55 * 1000 * 1000; // smaller than  MEM/CPUS
	void *p = mmap(NULL, size, PROT_READ | PROT_WRITE,
		MAP_PRIVATE | MAP_ANONYMOUS , -1, 0);
	if (p != MAP_FAILED)
		memset(p, 0, size);
	//munmap(p, size); // uncomment to make the problem go away
}
}

When we run it with THP enabled it will leave significant amount of memory
on lru_add_pvec.  This memory will be not reclaimed if we hit OOM, so when
we run above program in a loop:

	for i in `seq 100`; do ./a.out; done

many processes (95% in my case) will be killed by OOM.

The primary point of the LRU add cache is to save the zone lru_lock
contention with a hope that more pages will belong to the same zone and so
their addition can be batched.  The huge page is already a form of batched
addition (it will add 512 worth of memory in one go) so skipping the
batching seems like a safer option when compared to a potential excess in
the caching which can be quite large and much harder to fix because
lru_add_drain_all is way to expensive and it is not really clear what
would be a good moment to call it.

Similarly we can reproduce the problem on lru_deactivate_pvec by adding:
madvise(p, size, MADV_FREE); after memset.

This patch flushes lru pvecs on compound page arrival making the problem
less severe - after applying it kill rate of above example drops to 0%,
due to reducing maximum amount of memory held on pvec from 28MB (with THP)
to 56kB per CPU.

Suggested-by: Michal Hocko <mhocko@suse.com>
Link: http://lkml.kernel.org/r/1466180198-18854-1-git-send-email-lukasz.odzioba@intel.com
Signed-off-by: Lukasz Odzioba <lukasz.odzioba@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Ming Li <mingli199x@qq.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/swap.c~mm-swapc-flush-lru-pvecs-on-compound-page-arrival mm/swap.c
--- a/mm/swap.c~mm-swapc-flush-lru-pvecs-on-compound-page-arrival
+++ a/mm/swap.c
@@ -242,7 +242,7 @@ void rotate_reclaimable_page(struct page
 		get_page(page);
 		local_irq_save(flags);
 		pvec = this_cpu_ptr(&lru_rotate_pvecs);
-		if (!pagevec_add(pvec, page))
+		if (!pagevec_add(pvec, page) || PageCompound(page))
 			pagevec_move_tail(pvec);
 		local_irq_restore(flags);
 	}
@@ -296,7 +296,7 @@ void activate_page(struct page *page)
 		struct pagevec *pvec = &get_cpu_var(activate_page_pvecs);
 
 		get_page(page);
-		if (!pagevec_add(pvec, page))
+		if (!pagevec_add(pvec, page) || PageCompound(page))
 			pagevec_lru_move_fn(pvec, __activate_page, NULL);
 		put_cpu_var(activate_page_pvecs);
 	}
@@ -391,9 +391,8 @@ static void __lru_cache_add(struct page
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
 
 	get_page(page);
-	if (!pagevec_space(pvec))
+	if (!pagevec_add(pvec, page) || PageCompound(page))
 		__pagevec_lru_add(pvec);
-	pagevec_add(pvec, page);
 	put_cpu_var(lru_add_pvec);
 }
 
@@ -628,7 +627,7 @@ void deactivate_file_page(struct page *p
 	if (likely(get_page_unless_zero(page))) {
 		struct pagevec *pvec = &get_cpu_var(lru_deactivate_file_pvecs);
 
-		if (!pagevec_add(pvec, page))
+		if (!pagevec_add(pvec, page) || PageCompound(page))
 			pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, NULL);
 		put_cpu_var(lru_deactivate_file_pvecs);
 	}
@@ -648,7 +647,7 @@ void deactivate_page(struct page *page)
 		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
 
 		get_page(page);
-		if (!pagevec_add(pvec, page))
+		if (!pagevec_add(pvec, page) || PageCompound(page))
 			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
 		put_cpu_var(lru_deactivate_pvecs);
 	}
_

Patches currently in -mm which might be from lukasz.odzioba@intel.com are


