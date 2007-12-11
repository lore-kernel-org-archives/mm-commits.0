From: akpm@linux-foundation.org
Subject: + update-documentation-controller-memorytxt.patch added to -mm tree
Date: Tue, 11 Dec 2007 15:59:59 -0800
Message-ID: <200712112359.lBBNxx81015687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbXLLABK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 19:01:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com


The patch titled
     update Documentation/controller/memory.txt
has been added to the -mm tree.  Its filename is
     update-documentation-controller-memorytxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update Documentation/controller/memory.txt
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Documentation updates for memory controller.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |   33 ++++++++++++-------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff -puN Documentation/controllers/memory.txt~update-documentation-controller-memorytxt Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~update-documentation-controller-memorytxt
+++ a/Documentation/controllers/memory.txt
@@ -9,8 +9,7 @@ d. Provides a double LRU: global memory 
    global LRU; a cgroup on hitting a limit, reclaims from the per
    cgroup LRU
 
-NOTE: Page Cache (unmapped) also includes Swap Cache pages as a subset
-and will not be referred to explicitly in the rest of the documentation.
+NOTE: Swap Cache (unmapped) is not accounted now.
 
 Benefits and Purpose of the memory controller
 
@@ -144,7 +143,7 @@ list.
 The memory controller uses the following hierarchy
 
 1. zone->lru_lock is used for selecting pages to be isolated
-2. mem->lru_lock protects the per cgroup LRU
+2. mem->per_zone->lru_lock protects the per cgroup LRU (per zone)
 3. lock_page_cgroup() is used to protect page->page_cgroup
 
 3. User Interface
@@ -193,6 +192,15 @@ this file after a write to guarantee the
 The memory.failcnt field gives the number of times that the cgroup limit was
 exceeded.
 
+The memory.stat file gives accounting information. Now, the number of
+caches, RSS and Active pages/Inactive pages are shown.
+
+The memory.force_empty gives an interface to drop *all* charges by force.
+
+# echo -n 1 > memory.force_empty
+
+will drop all charges in cgroup. Currently, this is maintained for test.
+
 4. Testing
 
 Balbir posted lmbench, AIM9, LTP and vmmstress results [10] and [11].
@@ -222,11 +230,8 @@ reclaimed.
 
 A cgroup can be removed by rmdir, but as discussed in sections 4.1 and 4.2, a
 cgroup might have some charge associated with it, even though all
-tasks have migrated away from it. If some pages are still left, after following
-the steps listed in sections 4.1 and 4.2, check the Swap Cache usage in
-/proc/meminfo to see if the Swap Cache usage is showing up in the
-cgroups memory.usage_in_bytes counter. A simple test of swapoff -a and
-swapon -a should free any pending Swap Cache usage.
+tasks have migrated away from it. Such charges are automatically dropped at
+rmdir() if there are no tasks.
 
 4.4 Choosing what to account  -- Page Cache (unmapped) vs RSS (mapped)?
 
@@ -238,15 +243,11 @@ echo -n 1 > memory.control_type
 5. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
-2. Improve the user interface to accept/display memory limits in KB or MB
-   rather than pages (since page sizes can differ across platforms/machines).
-3. Make cgroup lists per-zone
-4. Make per-cgroup scanner reclaim not-shared pages first
-5. Teach controller to account for shared-pages
-6. Start reclamation when the limit is lowered
-7. Start reclamation in the background when the limit is
+2. Make per-cgroup scanner reclaim not-shared pages first
+3. Teach controller to account for shared-pages
+4. Start reclamation when the limit is lowered
+5. Start reclamation in the background when the limit is
    not yet hit but the usage is getting closer
-8. Create per zone LRU lists per cgroup
 
 Summary
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

git-x86.patch
swapoff-scan-ptes-preemptibly.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
mm-dont-waste-swap-on-locked-pages.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-improve-user-interface-memory-controller-enhancements-for-reclaiming-take2-possible-race-fix-in-res_counter.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page-warning-fix.patch
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
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter-memory-controller-enhancements-for-reclaiming-take2-clean-up-remove-unused-variable.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter-memory-controller-enhancements-for-reclaiming-take2-add-bug_on-in-mem_cgroup_zoneinfo.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-memory-controller-enhancements-for-reclaiming-take2-define-free_mem_cgroup_per_zone_info.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
update-documentation-controller-memorytxt.patch
