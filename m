From: akpm@linux-foundation.org
Subject: + mm-swapc-split-put_compound_page-function.patch added to -mm
 tree
Date: Wed, 30 Apr 2014 13:36:05 -0700
Message-ID: <53615eb5.QOhSsv6pMZLU0/rt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759493AbaD3UgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 16:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, peterz@infradead.org, mgorman@suse.de, liwanp@linux.vnet.ibm.com, liuj97@gmail.com, kirill.shutemov@linux.intel.com, hughd@google.com, hannes@cmpxchg.org, aarcange@redhat.com, nasa4836@gmail.com

Subject: + mm-swapc-split-put_compound_page-function.patch added to -mm tree
To: nasa4836@gmail.com,aarcange@redhat.com,hannes@cmpxchg.org,hughd@google.com,kirill.shutemov@linux.intel.com,liuj97@gmail.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,peterz@infradead.org,riel@redhat.com,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 13:36:05 -0700


The patch titled
     Subject: mm/swap.c: split put_compound_page()
has been added to the -mm tree.  Its filename is
     mm-swapc-split-put_compound_page-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapc-split-put_compound_page-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapc-split-put_compound_page-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm/swap.c: split put_compound_page()

Currently, put_compound_page() carefully handles tricky cases to avoid
racing with compound page releasing or splitting, which makes it quite
lenthy (about 200+ lines) and needs deep tab indention, which makes it
quite hard to follow and maintain.

Now based on two helpers introduced in the previous patch ("mm/swap.c:
introduce put_[un]refcounted_compound_page helpers for spliting
put_compound_page"), this patch replaces those two lengthy code paths with
these two helpers, respectively.  Also, it has some comment rephrasing.

After this patch, the put_compound_page() is very compact, thus easy to
read and maintain.

After splitting, the object file is of same size as the original one. 
Actually, I've diff'ed put_compound_page()'s orginal disassemble code and
the patched disassemble code, the are 100% the same!

This fact shows that this splitting has no functional change, but it
brings readability.

This patch and the previous one blow the code by 32 lines, mostly due to
comments.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |  142 +++++-----------------------------------------------
 1 file changed, 16 insertions(+), 126 deletions(-)

diff -puN mm/swap.c~mm-swapc-split-put_compound_page-function mm/swap.c
--- a/mm/swap.c~mm-swapc-split-put_compound_page-function
+++ a/mm/swap.c
@@ -225,6 +225,11 @@ static void put_compound_page(struct pag
 {
 	struct page *page_head;
 
+	/*
+	 * We see the PageCompound set and PageTail not set, so @page maybe:
+	 *  1. hugetlbfs head page, or
+	 *  2. THP head page.
+	 */
 	if (likely(!PageTail(page))) {
 		if (put_page_testzero(page)) {
 			/*
@@ -239,135 +244,20 @@ static void put_compound_page(struct pag
 		return;
 	}
 
-	/* __split_huge_page_refcount can run under us */
-	page_head = compound_head(page);
-
 	/*
-	 * THP can not break up slab pages so avoid taking
-	 * compound_lock() and skip the tail page refcounting (in
-	 * _mapcount) too. Slab performs non-atomic bit ops on
-	 * page->flags for better performance. In particular
-	 * slab_unlock() in slub used to be a hot path. It is still
-	 * hot on arches that do not support
-	 * this_cpu_cmpxchg_double().
+	 * We see the PageCompound set and PageTail set, so @page maybe:
+	 *  1. a tail hugetlbfs page, or
+	 *  2. a tail THP page, or
+	 *  3. a split THP page.
 	 *
-	 * If "page" is part of a slab or hugetlbfs page it cannot be
-	 * splitted and the head page cannot change from under us. And
-	 * if "page" is part of a THP page under splitting, if the
-	 * head page pointed by the THP tail isn't a THP head anymore,
-	 * we'll find PageTail clear after smp_rmb() and we'll treat
-	 * it as a single page.
+	 *  Case 3 is possible, as we may race with
+	 *  __split_huge_page_refcount tearing down a THP page.
 	 */
-	if (!__compound_tail_refcounted(page_head)) {
-		/*
-		 * If "page" is a THP tail, we must read the tail page
-		 * flags after the head page flags. The
-		 * split_huge_page side enforces write memory barriers
-		 * between clearing PageTail and before the head page
-		 * can be freed and reallocated.
-		 */
-		smp_rmb();
-		if (likely(PageTail(page))) {
-			/*
-			 * __split_huge_page_refcount cannot race
-			 * here.
-			 */
-			VM_BUG_ON_PAGE(!PageHead(page_head), page_head);
-			VM_BUG_ON_PAGE(page_mapcount(page) != 0, page);
-			if (put_page_testzero(page_head)) {
-				/*
-				 * If this is the tail of a slab
-				 * compound page, the tail pin must
-				 * not be the last reference held on
-				 * the page, because the PG_slab
-				 * cannot be cleared before all tail
-				 * pins (which skips the _mapcount
-				 * tail refcounting) have been
-				 * released. For hugetlbfs the tail
-				 * pin may be the last reference on
-				 * the page instead, because
-				 * PageHeadHuge will not go away until
-				 * the compound page enters the buddy
-				 * allocator.
-				 */
-				VM_BUG_ON_PAGE(PageSlab(page_head), page_head);
-				__put_compound_page(page_head);
-			}
-			return;
-		} else
-			/*
-			 * __split_huge_page_refcount run before us,
-			 * "page" was a THP tail. The split page_head
-			 * has been freed and reallocated as slab or
-			 * hugetlbfs page of smaller order (only
-			 * possible if reallocated as slab on x86).
-			 */
-			goto out_put_single;
-	}
-
-	if (likely(page != page_head && get_page_unless_zero(page_head))) {
-		unsigned long flags;
-
-		/*
-		 * page_head wasn't a dangling pointer but it may not
-		 * be a head page anymore by the time we obtain the
-		 * lock. That is ok as long as it can't be freed from
-		 * under us.
-		 */
-		flags = compound_lock_irqsave(page_head);
-		if (unlikely(!PageTail(page))) {
-			/* __split_huge_page_refcount run before us */
-			compound_unlock_irqrestore(page_head, flags);
-			if (put_page_testzero(page_head)) {
-				/*
-				 * The head page may have been freed
-				 * and reallocated as a compound page
-				 * of smaller order and then freed
-				 * again.  All we know is that it
-				 * cannot have become: a THP page, a
-				 * compound page of higher order, a
-				 * tail page.  That is because we
-				 * still hold the refcount of the
-				 * split THP tail and page_head was
-				 * the THP head before the split.
-				 */
-				if (PageHead(page_head))
-					__put_compound_page(page_head);
-				else
-					__put_single_page(page_head);
-			}
-out_put_single:
-			if (put_page_testzero(page))
-				__put_single_page(page);
-			return;
-		}
-		VM_BUG_ON_PAGE(page_head != page->first_page, page);
-		/*
-		 * We can release the refcount taken by
-		 * get_page_unless_zero() now that
-		 * __split_huge_page_refcount() is blocked on the
-		 * compound_lock.
-		 */
-		if (put_page_testzero(page_head))
-			VM_BUG_ON_PAGE(1, page_head);
-		/* __split_huge_page_refcount will wait now */
-		VM_BUG_ON_PAGE(page_mapcount(page) <= 0, page);
-		atomic_dec(&page->_mapcount);
-		VM_BUG_ON_PAGE(atomic_read(&page_head->_count) <= 0, page_head);
-		VM_BUG_ON_PAGE(atomic_read(&page->_count) != 0, page);
-		compound_unlock_irqrestore(page_head, flags);
-
-		if (put_page_testzero(page_head)) {
-			if (PageHead(page_head))
-				__put_compound_page(page_head);
-			else
-				__put_single_page(page_head);
-		}
-	} else {
-		/* page_head is a dangling pointer */
-		VM_BUG_ON_PAGE(PageTail(page), page);
-		goto out_put_single;
-	}
+	page_head = compound_head(page);
+	if (!__compound_tail_refcounted(page_head))
+		put_unrefcounted_compound_page(page_head, page);
+	else
+		put_refcounted_compound_page(page_head, page);
 }
 
 void put_page(struct page *page)
_

Patches currently in -mm which might be from nasa4836@gmail.com are

mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
linux-next.patch

