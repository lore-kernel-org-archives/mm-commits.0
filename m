From: akpm@linux-foundation.org
Subject: + mm-page_alloc-make-first_page-visible-before-pagetail.patch
 added to -mm tree
Date: Tue, 04 Feb 2014 16:33:05 -0800
Message-ID: <52f186c1.LTwE9DaIbaUd8JOF%akpm__47605.7834028781$1391560397$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaBEAdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 19:33:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org, mhocko@suse.cz, mgorman@suse.de, cl@linux.com, aquini@redhat.com, Holger.Kiehl@dwd.de, rientjes@google.com

Subject: + mm-page_alloc-make-first_page-visible-before-pagetail.patch added to -mm tree
To: rientjes@google.com,Holger.Kiehl@dwd.de,aquini@redhat.com,cl@linux.com,mgorman@suse.de,mhocko@suse.cz,stable@vger.kernel.org,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 16:33:05 -0800


The patch titled
     Subject: mm, page_alloc: make first_page visible before PageTail
has been added to the -mm tree.  Its filename is
     mm-page_alloc-make-first_page-visible-before-pagetail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-make-first_page-visible-before-pagetail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-make-first_page-visible-before-pagetail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: make first_page visible before PageTail

Commit bf6bddf1924e ("mm: introduce compaction and migration for ballooned
pages") introduces page_count(page) into memory compaction which
dereferences page->first_page if PageTail(page).

This caused Holger to observe a very rare NULL pointer dereference on the
aforementioned page_count(page).

Introduce a store memory barrier to ensure page->first_page is properly
initialized so that code that does page_count(page) on pages off the lru
always have a valid p->first_page.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-make-first_page-visible-before-pagetail mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-make-first_page-visible-before-pagetail
+++ a/mm/page_alloc.c
@@ -369,9 +369,11 @@ void prep_compound_page(struct page *pag
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
-		__SetPageTail(p);
 		set_page_count(p, 0);
 		p->first_page = page;
+		/* Make sure p->first_page is always valid for PageTail() */
+		smp_wmb();
+		__SetPageTail(p);
 	}
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

documentation-kernel-parameterstxt-fix-memmap=-language.patch
mm-__set_page_dirty_nobuffers-uses-spin_lock_irqseve-instead-of-spin_lock_irq.patch
mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch
fs-filec-fdtable-avoid-triggering-ooms-from-alloc_fdmem.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
mm-utilc-add-kstrimdup.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch

