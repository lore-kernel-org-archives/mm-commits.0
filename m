From: akpm@linux-foundation.org
Subject: - proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:58 -0800
Message-ID: <200711152108.lAFL8wJL015402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932832AbXKOVS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@sw.ru, sukadev@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     proc: fix proc_kill_inodes to kill dentries on all proc superblocks
has been removed from the -mm tree.  Its filename was
     proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: proc: fix proc_kill_inodes to kill dentries on all proc superblocks
From: Eric W. Biederman <ebiederm@xmission.com>

It appears we overlooked support for removing generic proc files
when we added support for multiple proc super blocks.  Handle
that now.

[akpm@linux-foundation.org: coding-style cleanups]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |   39 ++++++++++++++++++++++-----------------
 fs/proc/internal.h |    2 ++
 fs/proc/root.c     |    2 +-
 3 files changed, 25 insertions(+), 18 deletions(-)

diff -puN fs/proc/generic.c~proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks fs/proc/generic.c
--- a/fs/proc/generic.c~proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks
+++ a/fs/proc/generic.c
@@ -561,28 +561,33 @@ static int proc_register(struct proc_dir
 static void proc_kill_inodes(struct proc_dir_entry *de)
 {
 	struct list_head *p;
-	struct super_block *sb = proc_mnt->mnt_sb;
+	struct super_block *sb;
 
 	/*
 	 * Actually it's a partial revoke().
 	 */
-	file_list_lock();
-	list_for_each(p, &sb->s_files) {
-		struct file * filp = list_entry(p, struct file, f_u.fu_list);
-		struct dentry * dentry = filp->f_path.dentry;
-		struct inode * inode;
-		const struct file_operations *fops;
-
-		if (dentry->d_op != &proc_dentry_operations)
-			continue;
-		inode = dentry->d_inode;
-		if (PDE(inode) != de)
-			continue;
-		fops = filp->f_op;
-		filp->f_op = NULL;
-		fops_put(fops);
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &proc_fs_type.fs_supers, s_instances) {
+		file_list_lock();
+		list_for_each(p, &sb->s_files) {
+			struct file *filp = list_entry(p, struct file,
+							f_u.fu_list);
+			struct dentry *dentry = filp->f_path.dentry;
+			struct inode *inode;
+			const struct file_operations *fops;
+
+			if (dentry->d_op != &proc_dentry_operations)
+				continue;
+			inode = dentry->d_inode;
+			if (PDE(inode) != de)
+				continue;
+			fops = filp->f_op;
+			filp->f_op = NULL;
+			fops_put(fops);
+		}
+		file_list_unlock();
 	}
-	file_list_unlock();
+	spin_unlock(&sb_lock);
 }
 
 static struct proc_dir_entry *proc_create(struct proc_dir_entry **parent,
diff -puN fs/proc/internal.h~proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks fs/proc/internal.h
--- a/fs/proc/internal.h~proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks
+++ a/fs/proc/internal.h
@@ -78,3 +78,5 @@ static inline int proc_fd(struct inode *
 {
 	return PROC_I(inode)->fd;
 }
+
+extern struct file_system_type proc_fs_type;
diff -puN fs/proc/root.c~proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks fs/proc/root.c
--- a/fs/proc/root.c~proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks
+++ a/fs/proc/root.c
@@ -98,7 +98,7 @@ static void proc_kill_sb(struct super_bl
 	put_pid_ns(ns);
 }
 
-static struct file_system_type proc_fs_type = {
+struct file_system_type proc_fs_type = {
 	.name		= "proc",
 	.get_sb		= proc_get_sb,
 	.kill_sb	= proc_kill_sb,
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
git-s390.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
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
introduce-flags-for-reserve_bootmem.patch
use-bootmem_exclusive-for-kdump.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
