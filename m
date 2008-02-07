From: akpm@linux-foundation.org
Subject: - cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:28:28 -0800
Message-ID: <200802070328.m173S9BP013837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759200AbYBGD2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:28:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cpw@sgi.com, menage@google.com, pj@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch

This patch was dropped because it was folded into cgroups-mechanism-to-process-each-task-in-a-cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#40: FILE: include/linux/cgroup.h:214:
+	void (*process_task)(struct task_struct *p, struct cgroup_scanner *scan);

ERROR: use tabs not spaces
#85: FILE: kernel/cgroup.c:1712:
+ ^Ido_each_thread(g, p) {$

ERROR: use tabs not spaces
#90: FILE: kernel/cgroup.c:1717:
+ ^I} while_each_thread(g, p);$

total: 2 errors, 1 warnings, 252 lines checked

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

 include/linux/cgroup.h |    3 ++-
 kernel/cgroup.c        |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes
+++ a/include/linux/cgroup.h
@@ -211,7 +211,8 @@ struct cftype {
 struct cgroup_scanner {
 	struct cgroup *cg;
 	int (*test_task)(struct task_struct *p, struct cgroup_scanner *scan);
-	void (*process_task)(struct task_struct *p, struct cgroup_scanner *scan);
+	void (*process_task)(struct task_struct *p,
+			struct cgroup_scanner *scan);
 	struct ptr_heap *heap;
 };
 
diff -puN kernel/cgroup.c~cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes
+++ a/kernel/cgroup.c
@@ -1709,12 +1709,12 @@ void cgroup_enable_task_cg_lists(void)
 	struct task_struct *p, *g;
 	write_lock(&css_set_lock);
 	use_task_css_set_links = 1;
- 	do_each_thread(g, p) {
+	do_each_thread(g, p) {
 		task_lock(p);
 		if (list_empty(&p->cg_list))
 			list_add(&p->cg_list, &p->cgroups->tasks);
 		task_unlock(p);
- 	} while_each_thread(g, p);
+	} while_each_thread(g, p);
 	write_unlock(&css_set_lock);
 }
 
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
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
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
