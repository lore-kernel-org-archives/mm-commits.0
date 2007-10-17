From: akpm@linux-foundation.org
Subject: - file-capabilities-get_file_caps-cleanups.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:37:32 -0700
Message-ID: <200710170137.l9H1bWuC027934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbXJQBiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:38:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     file capabilities: get_file_caps cleanups
has been removed from the -mm tree.  Its filename was
     file-capabilities-get_file_caps-cleanups.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

------------------------------------------------------
Subject: file capabilities: get_file_caps cleanups
From: Serge E. Hallyn <serue@us.ibm.com>

Two cleanups relating to set_file caps.

Rename set_file_caps to get_file_caps, since we are getting
the file capabilities, and setting the bprm caps to them.

Move the clearing of bprm caps into get_file_caps, and do it
only when we don't copy them from the capability xattr.

Changelog:
	Fix location of 'clear_caps' label.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff -puN security/commoncap.c~file-capabilities-get_file_caps-cleanups security/commoncap.c
--- a/security/commoncap.c~file-capabilities-get_file_caps-cleanups
+++ a/security/commoncap.c
@@ -135,21 +135,20 @@ static inline int cap_from_disk(struct v
 }
 
 /* Locate any VFS capabilities: */
-static int set_file_caps(struct linux_binprm *bprm)
+static int get_file_caps(struct linux_binprm *bprm)
 {
 	struct dentry *dentry;
-	int rc;
+	int rc = 0;
 	struct vfs_cap_data_disk_v1 v1caps;
 	struct vfs_cap_data_disk *dcaps;
 	struct inode *inode;
 
 	dcaps = (struct vfs_cap_data_disk *)&v1caps;
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
-		return 0;
+		goto clear_caps;
 
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;
-	rc = 0;
 	if (!inode->i_op || !inode->i_op->getxattr)
 		goto out;
 
@@ -187,12 +186,21 @@ out:
 	dput(dentry);
 	if ((void *)dcaps != (void *)&v1caps)
 		kfree(dcaps);
+	if (rc) {
+clear_caps:
+		cap_clear (bprm->cap_inheritable);
+		cap_clear (bprm->cap_permitted);
+		cap_clear (bprm->cap_effective);
+	}
 	return rc;
 }
 
 #else
-static inline int set_file_caps(struct linux_binprm *bprm)
+static inline int get_file_caps(struct linux_binprm *bprm)
 {
+	cap_clear (bprm->cap_inheritable);
+	cap_clear (bprm->cap_permitted);
+	cap_clear (bprm->cap_effective);
 	return 0;
 }
 #endif
@@ -201,13 +209,7 @@ int cap_bprm_set_security (struct linux_
 {
 	int ret;
 
-	/* Copied from fs/exec.c:prepare_binprm. */
-
-	cap_clear (bprm->cap_inheritable);
-	cap_clear (bprm->cap_permitted);
-	cap_clear (bprm->cap_effective);
-
-	ret = set_file_caps(bprm);
+	ret = get_file_caps(bprm);
 
 	/*  To support inheritance of root-permissions and suid-root
 	 *  executables under compatibility mode, we raise all three
_

Patches currently in -mm which might be from serue@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
security-convert-lsm-into-a-static-interface.patch
implement-file-posix-capabilities.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
file-caps-clean-up-for-linux-capabilityh.patch
capabilityh-remove-include-of-currenth.patch
file-capabilities-clear-fcaps-on-inode-change.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
capabilities-reset-current-pdeath_signal-when-increasing-capabilities.patch
security-cleanups.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
v3-file-capabilities-alter-behavior-of-cap_setpcap.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
containers-implement-namespace-tracking-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
ipc-cleanup-some-code-and-wrong-comments-about-semundo.patch
virtualization-of-sysv-msg-queues-is-incomplete.patch
