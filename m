From: akpm@linux-foundation.org
Subject: - update-documentation-controller-memorytxt.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:05:09 -0800
Message-ID: <200802080804.m1884oRZ014286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761168AbYBHITy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     update Documentation/controller/memory.txt
has been removed from the -mm tree.  Its filename was
     update-documentation-controller-memorytxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
