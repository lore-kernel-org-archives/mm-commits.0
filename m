From: akpm@linux-foundation.org
Subject: [merged] mm-fix-for-infinite-churning-of-mlocked-pages.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:18 -0700
Message-ID: <200908271918.n7RJIIIo010005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbZH0TSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix for infinite churning of mlocked pages
has been removed from the -mm tree.  Its filename was
     mm-fix-for-infinite-churning-of-mlocked-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix for infinite churning of mlocked pages
From: Minchan Kim <minchan.kim@gmail.com>

An mlocked page might lose the isolatation race.  This causes the page to
clear PG_mlocked while it remains in a VM_LOCKED vma.  This means it can
be put onto the [in]active list.  We can rescue it by using try_to_unmap()
in shrink_page_list().

But now, As Wu Fengguang pointed out, vmscan has a bug.  If the page has
PG_referenced, it can't reach try_to_unmap() in shrink_page_list() but is
put into the active list.  If the page is referenced repeatedly, it can
remain on the [in]active list without being moving to the unevictable
list.

This patch fixes it.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <<kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c   |    1 +
 mm/vmscan.c |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-fix-for-infinite-churning-of-mlocked-pages mm/rmap.c
--- a/mm/rmap.c~mm-fix-for-infinite-churning-of-mlocked-pages
+++ a/mm/rmap.c
@@ -358,6 +358,7 @@ static int page_referenced_one(struct pa
 	 */
 	if (vma->vm_flags & VM_LOCKED) {
 		*mapcount = 1;	/* break early from loop */
+		*vm_flags |= VM_LOCKED;
 		goto out_unmap;
 	}
 
diff -puN mm/vmscan.c~mm-fix-for-infinite-churning-of-mlocked-pages mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-for-infinite-churning-of-mlocked-pages
+++ a/mm/vmscan.c
@@ -630,9 +630,14 @@ static unsigned long shrink_page_list(st
 
 		referenced = page_referenced(page, 1,
 						sc->mem_cgroup, &vm_flags);
-		/* In active use or really unfreeable?  Activate it. */
+		/*
+		 * In active use or really unfreeable?  Activate it.
+		 * If page which have PG_mlocked lost isoltation race,
+		 * try_to_unmap moves it to unevictable list
+		 */
 		if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
-					referenced && page_mapping_inuse(page))
+					referenced && page_mapping_inuse(page)
+					&& !(vm_flags & VM_LOCKED))
 			goto activate_locked;
 
 		/*
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-introduce-page_lru_base_type.patch
mm-introduce-page_lru_base_type-fix.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-do-batched-scans-for-mem_cgroup.patch

