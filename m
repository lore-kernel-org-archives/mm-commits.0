From: akpm@linux-foundation.org
Subject: - shmem-factor-out-sbi-free_inodes-manipulations.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:19 -0800
Message-ID: <200802052230.m15MU0EJ012022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932238AbYBEWnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     shmem: factor out sbi->free_inodes manipulations
has been removed from the -mm tree.  Its filename was
     shmem-factor-out-sbi-free_inodes-manipulations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shmem: factor out sbi->free_inodes manipulations
From: Pavel Emelyanov <xemul@openvz.org>

The shmem_sb_info structure has a number of free_inodes. This
value is altered in appropriate places under spinlock and with
the sbi->max_inodes != 0 check.

Consolidate these manipulations into two helpers.

This is minus 42 bytes of shmem.o and minus 4 :) lines of code.

[akpm@linux-foundation.org: fix error return values]
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   77 +++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

diff -puN mm/shmem.c~shmem-factor-out-sbi-free_inodes-manipulations mm/shmem.c
--- a/mm/shmem.c~shmem-factor-out-sbi-free_inodes-manipulations
+++ a/mm/shmem.c
@@ -205,6 +205,31 @@ static void shmem_free_blocks(struct ino
 	}
 }
 
+static int shmem_reserve_inode(struct super_block *sb)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+	if (sbinfo->max_inodes) {
+		spin_lock(&sbinfo->stat_lock);
+		if (!sbinfo->free_inodes) {
+			spin_unlock(&sbinfo->stat_lock);
+			return -ENOSPC;
+		}
+		sbinfo->free_inodes--;
+		spin_unlock(&sbinfo->stat_lock);
+	}
+	return 0;
+}
+
+static void shmem_free_inode(struct super_block *sb)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+	if (sbinfo->max_inodes) {
+		spin_lock(&sbinfo->stat_lock);
+		sbinfo->free_inodes++;
+		spin_unlock(&sbinfo->stat_lock);
+	}
+}
+
 /*
  * shmem_recalc_inode - recalculate the size of an inode
  *
@@ -762,7 +787,6 @@ static int shmem_notify_change(struct de
 
 static void shmem_delete_inode(struct inode *inode)
 {
-	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
 	if (inode->i_op->truncate == shmem_truncate) {
@@ -777,11 +801,7 @@ static void shmem_delete_inode(struct in
 		}
 	}
 	BUG_ON(inode->i_blocks);
-	if (sbinfo->max_inodes) {
-		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_inodes++;
-		spin_unlock(&sbinfo->stat_lock);
-	}
+	shmem_free_inode(inode->i_sb);
 	clear_inode(inode);
 }
 
@@ -1371,15 +1391,8 @@ shmem_get_inode(struct super_block *sb, 
 	struct shmem_inode_info *info;
 	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
 
-	if (sbinfo->max_inodes) {
-		spin_lock(&sbinfo->stat_lock);
-		if (!sbinfo->free_inodes) {
-			spin_unlock(&sbinfo->stat_lock);
-			return NULL;
-		}
-		sbinfo->free_inodes--;
-		spin_unlock(&sbinfo->stat_lock);
-	}
+	if (shmem_reserve_inode(sb))
+		return NULL;
 
 	inode = new_inode(sb);
 	if (inode) {
@@ -1423,11 +1436,8 @@ shmem_get_inode(struct super_block *sb, 
 						NULL);
 			break;
 		}
-	} else if (sbinfo->max_inodes) {
-		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_inodes++;
-		spin_unlock(&sbinfo->stat_lock);
-	}
+	} else
+		shmem_free_inode(sb);
 	return inode;
 }
 
@@ -1670,22 +1680,16 @@ static int shmem_create(struct inode *di
 static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
-	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	int ret;
 
 	/*
 	 * No ordinary (disk based) filesystem counts links as inodes;
 	 * but each new link needs a new dentry, pinning lowmem, and
 	 * tmpfs dentries cannot be pruned until they are unlinked.
 	 */
-	if (sbinfo->max_inodes) {
-		spin_lock(&sbinfo->stat_lock);
-		if (!sbinfo->free_inodes) {
-			spin_unlock(&sbinfo->stat_lock);
-			return -ENOSPC;
-		}
-		sbinfo->free_inodes--;
-		spin_unlock(&sbinfo->stat_lock);
-	}
+	ret = shmem_reserve_inode(inode->i_sb);
+	if (ret)
+		goto out;
 
 	dir->i_size += BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
@@ -1693,21 +1697,16 @@ static int shmem_link(struct dentry *old
 	atomic_inc(&inode->i_count);	/* New dentry reference */
 	dget(dentry);		/* Extra pinning count for the created dentry */
 	d_instantiate(dentry, inode);
-	return 0;
+out:
+	return ret;
 }
 
 static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)) {
-		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-		if (sbinfo->max_inodes) {
-			spin_lock(&sbinfo->stat_lock);
-			sbinfo->free_inodes++;
-			spin_unlock(&sbinfo->stat_lock);
-		}
-	}
+	if (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode))
+		shmem_free_inode(inode->i_sb);
 
 	dir->i_size -= BOGO_DIRENT_SIZE;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
use-find_task_by_vpid-in-audit-code.patch
gfs2-make-gfs2_glockgl_owner_pid-be-a-struct-pid.patch
gfs2-make-gfs2_holdergh_owner_pid-be-a-struct-pid.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
handle-pid-namespaces-in-cgroups-code.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
ipc-uninline-some-code-from-utilh.patch
ipc-make-struct-ipc_ids-static-in-ipc_namespace.patch
ipc-consolidate-sem_exit_ns-msg_exit_ns-and-shm_exit_ns.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
pid-sys_wait-fixes-v2.patch
pid-extend-fix-pid_vnr.patch
sys_getsid-dont-use-nsproxy-directly.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
pidns-make-full-use-of-xxx_vnr-calls.patch
pidns-fix-badly-converted-mqueues-pid-handling.patch
clean-up-the-kill_something_info.patch
get-rid-of-the-kill_pgrp_info-function.patch
use-find_task_by_vpid-in-posix-timers.patch
use-find_task_by_vpid-in-taskstats.patch
dont-operate-with-pid_t-in-rtmutex-tester.patch
deprecate-find_task_by_pid.patch
reiser4.patch
