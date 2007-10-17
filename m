From: akpm@linux-foundation.org
Subject: - file-capabilities-clear-caps-cleanup.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:37:36 -0700
Message-ID: <200710170137.l9H1baU4027940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56550 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbXJQBiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     file capabilities: clear caps cleanup
has been removed from the -mm tree.  Its filename was
     file-capabilities-clear-caps-cleanup.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

------------------------------------------------------
Subject: file capabilities: clear caps cleanup
From: "Serge E. Hallyn" <serue@us.ibm.com>

As suggested by Steve Beattie, rather than jump into a conditional block in
certain cases, define and use a static inline bprm_clear_caps().

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Andrew Morgan <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Acked-by: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff -puN security/commoncap.c~file-capabilities-clear-caps-cleanup security/commoncap.c
--- a/security/commoncap.c~file-capabilities-clear-caps-cleanup
+++ a/security/commoncap.c
@@ -109,6 +109,13 @@ void cap_capset_set (struct task_struct 
 	target->cap_permitted = *permitted;
 }
 
+static inline void bprm_clear_caps(struct linux_binprm *bprm)
+{
+	cap_clear (bprm->cap_inheritable);
+	cap_clear (bprm->cap_permitted);
+	cap_clear (bprm->cap_effective);
+}
+
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
 static inline int cap_from_disk(struct vfs_cap_data_disk *dcap,
@@ -144,8 +151,10 @@ static int get_file_caps(struct linux_bi
 	struct inode *inode;
 
 	dcaps = (struct vfs_cap_data_disk *)&v1caps;
-	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
-		goto clear_caps;
+	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
+		bprm_clear_caps(bprm);
+		return 0;
+	}
 
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;
@@ -186,21 +195,16 @@ out:
 	dput(dentry);
 	if ((void *)dcaps != (void *)&v1caps)
 		kfree(dcaps);
-	if (rc) {
-clear_caps:
-		cap_clear (bprm->cap_inheritable);
-		cap_clear (bprm->cap_permitted);
-		cap_clear (bprm->cap_effective);
-	}
+	if (rc)
+		bprm_clear_caps(bprm);
+
 	return rc;
 }
 
 #else
 static inline int get_file_caps(struct linux_binprm *bprm)
 {
-	cap_clear (bprm->cap_inheritable);
-	cap_clear (bprm->cap_permitted);
-	cap_clear (bprm->cap_effective);
+	bprm_clear_caps(bprm);
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from serue@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
security-convert-lsm-into-a-static-interface.patch
implement-file-posix-capabilities.patch
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
