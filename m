From: akpm@linux-foundation.org
Subject: - memory-hotremove-unset-migrate-type-isolate-after-removal.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:04 -0800
Message-ID: <200711152109.lAFL94q4015414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761892AbXKOVRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memory hotremove: unset migrate type "ISOLATE" after removal
has been removed from the -mm tree.  Its filename was
     memory-hotremove-unset-migrate-type-isolate-after-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: memory hotremove: unset migrate type "ISOLATE" after removal
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

We should unset migrate type "ISOLATE" when we successfully removed memory.
 But current code has BUG and cannot works well.

This patch also includes bugfix?  to change get_pageblock_flags to
get_pageblock_migratetype().

Thanks to Badari Pulavarty for finding this.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 mm/page_isolation.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotremove-unset-migrate-type-isolate-after-removal mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotremove-unset-migrate-type-isolate-after-removal
+++ a/mm/memory_hotplug.c
@@ -574,8 +574,8 @@ repeat:
 	/* Ok, all of our target is islaoted.
 	   We cannot do rollback at this point. */
 	offline_isolated_pages(start_pfn, end_pfn);
-	/* reset pagetype flags */
-	start_isolate_page_range(start_pfn, end_pfn);
+	/* reset pagetype flags and makes migrate type to be MOVABLE */
+	undo_isolate_page_range(start_pfn, end_pfn);
 	/* removal success */
 	zone->present_pages -= offlined_pages;
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
diff -puN mm/page_isolation.c~memory-hotremove-unset-migrate-type-isolate-after-removal mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotremove-unset-migrate-type-isolate-after-removal
+++ a/mm/page_isolation.c
@@ -55,7 +55,7 @@ start_isolate_page_range(unsigned long s
 	return 0;
 undo:
 	for (pfn = start_pfn;
-	     pfn <= undo_pfn;
+	     pfn < undo_pfn;
 	     pfn += pageblock_nr_pages)
 		unset_migratetype_isolate(pfn_to_page(pfn));
 
@@ -76,7 +76,7 @@ undo_isolate_page_range(unsigned long st
 	     pfn < end_pfn;
 	     pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
-		if (!page || get_pageblock_flags(page) != MIGRATE_ISOLATE)
+		if (!page || get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 			continue;
 		unset_migratetype_isolate(page);
 	}
@@ -126,7 +126,7 @@ int test_pages_isolated(unsigned long st
 	 */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
-		if (page && get_pageblock_flags(page) != MIGRATE_ISOLATE)
+		if (page && get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 			break;
 	}
 	if (pfn < end_pfn)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
swapoff-scan-ptes-preemptibly.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
