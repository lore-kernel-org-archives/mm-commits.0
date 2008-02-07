From: akpm@linux-foundation.org
Subject: - hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:29:03 -0800
Message-ID: <200802070328.m173SieR013869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759203AbYBGD3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:29:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cpw@sgi.com, menage@google.com, pj@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch

This patch was dropped because it was folded into hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#317: FILE: kernel/cpuset.c:1823:
+^I^I        /* Move tasks from the empty cpuset to a parent */$

total: 1 errors, 0 warnings, 303 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Cliff Wickman <cpw@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes kernel/cpuset.c
--- a/kernel/cpuset.c~hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes
+++ a/kernel/cpuset.c
@@ -1733,8 +1733,8 @@ static void move_member_tasks_to_cpuset(
 	scan.to = to->css.cgroup;
 
 	if (cgroup_scan_tasks((struct cgroup_scanner *)&scan))
-		printk(
-		"move_member_tasks_to_cpuset: cgroup_scan_tasks failed\n");
+		printk(KERN_ERR "move_member_tasks_to_cpuset: "
+				"cgroup_scan_tasks failed\n");
 }
 
 /*
@@ -1820,7 +1820,7 @@ static void scan_for_empty_cpusets(const
 		nodes_and(cp->mems_allowed, cp->mems_allowed, node_online_map);
 		if ((cpus_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))) {
-		        /* Move tasks from the empty cpuset to a parent */
+			/* Move tasks from the empty cpuset to a parent */
 			mutex_unlock(&callback_mutex);
 			remove_tasks_in_empty_cpuset(cp);
 			mutex_lock(&callback_mutex);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
cgroup-simplify-space-stripping.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
