From: akpm@linux-foundation.org
Subject: [merged] mm-oom-rename-zonelist-locking-functions.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:06:17 -0700
Message-ID: <53e3dc39.Q2jNvo1WbC6NuJfF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:58254 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaHGUGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:18 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so613547qap.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: rename zonelist locking functions
has been removed from the -mm tree.  Its filename was
     mm-oom-rename-zonelist-locking-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: rename zonelist locking functions

try_set_zonelist_oom() and clear_zonelist_oom() are not named properly to
imply that they require locking semantics to avoid out_of_memory() being
reordered.

zone_scan_lock is required for both functions to ensure that there is
proper locking synchronization.

Rename try_set_zonelist_oom() to oom_zonelist_trylock() and rename
clear_zonelist_oom() to oom_zonelist_unlock() to imply there is proper
locking semantics.

At the same time, convert oom_zonelist_trylock() to return bool instead of
int since only success and failure are tested.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    4 ++--
 mm/oom_kill.c       |   30 +++++++++++++-----------------
 mm/page_alloc.c     |    6 +++---
 3 files changed, 18 insertions(+), 22 deletions(-)

diff -puN include/linux/oom.h~mm-oom-rename-zonelist-locking-functions include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-rename-zonelist-locking-functions
+++ a/include/linux/oom.h
@@ -55,8 +55,8 @@ extern void oom_kill_process(struct task
 			     struct mem_cgroup *memcg, nodemask_t *nodemask,
 			     const char *message);
 
-extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
-extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
+extern bool oom_zonelist_trylock(struct zonelist *zonelist, gfp_t gfp_flags);
+extern void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_flags);
 
 extern void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
 			       int order, const nodemask_t *nodemask);
diff -puN mm/oom_kill.c~mm-oom-rename-zonelist-locking-functions mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-rename-zonelist-locking-functions
+++ a/mm/oom_kill.c
@@ -559,28 +559,25 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifie
  * if a parallel OOM killing is already taking place that includes a zone in
  * the zonelist.  Otherwise, locks all zones in the zonelist and returns 1.
  */
-int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
+bool oom_zonelist_trylock(struct zonelist *zonelist, gfp_t gfp_mask)
 {
 	struct zoneref *z;
 	struct zone *zone;
-	int ret = 1;
+	bool ret = true;
 
 	spin_lock(&zone_scan_lock);
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
+	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
 		if (zone_is_oom_locked(zone)) {
-			ret = 0;
+			ret = false;
 			goto out;
 		}
-	}
 
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
-		/*
-		 * Lock each zone in the zonelist under zone_scan_lock so a
-		 * parallel invocation of try_set_zonelist_oom() doesn't succeed
-		 * when it shouldn't.
-		 */
+	/*
+	 * Lock each zone in the zonelist under zone_scan_lock so a parallel
+	 * call to oom_zonelist_trylock() doesn't succeed when it shouldn't.
+	 */
+	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
 		zone_set_flag(zone, ZONE_OOM_LOCKED);
-	}
 
 out:
 	spin_unlock(&zone_scan_lock);
@@ -592,15 +589,14 @@ out:
  * allocation attempts with zonelists containing them may now recall the OOM
  * killer, if necessary.
  */
-void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
+void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_mask)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
 	spin_lock(&zone_scan_lock);
-	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
+	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
 		zone_clear_flag(zone, ZONE_OOM_LOCKED);
-	}
 	spin_unlock(&zone_scan_lock);
 }
 
@@ -695,8 +691,8 @@ void pagefault_out_of_memory(void)
 		return;
 
 	zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
-	if (try_set_zonelist_oom(zonelist, GFP_KERNEL)) {
+	if (oom_zonelist_trylock(zonelist, GFP_KERNEL)) {
 		out_of_memory(NULL, 0, 0, NULL, false);
-		clear_zonelist_oom(zonelist, GFP_KERNEL);
+		oom_zonelist_unlock(zonelist, GFP_KERNEL);
 	}
 }
diff -puN mm/page_alloc.c~mm-oom-rename-zonelist-locking-functions mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-rename-zonelist-locking-functions
+++ a/mm/page_alloc.c
@@ -2246,8 +2246,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 {
 	struct page *page;
 
-	/* Acquire the OOM killer lock for the zones in zonelist */
-	if (!try_set_zonelist_oom(zonelist, gfp_mask)) {
+	/* Acquire the per-zone oom lock for each zone */
+	if (!oom_zonelist_trylock(zonelist, gfp_mask)) {
 		schedule_timeout_uninterruptible(1);
 		return NULL;
 	}
@@ -2285,7 +2285,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	out_of_memory(zonelist, gfp_mask, order, nodemask, false);
 
 out:
-	clear_zonelist_oom(zonelist, gfp_mask);
+	oom_zonelist_unlock(zonelist, gfp_mask);
 	return page;
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

