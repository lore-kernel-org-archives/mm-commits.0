From: akpm@linux-foundation.org
Subject: + capabilities-clean-up-file-capability-reading.patch added to -mm tree
Date: Wed, 17 Oct 2007 17:55:09 -0700
Message-ID: <200710180055.l9I0t9P7016869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757503AbXJRAzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 20:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, chrisw@sous-sol.org, morgan@kernel.org


The patch titled
     capabilities: clean up file capability reading
has been added to the -mm tree.  Its filename is
     capabilities-clean-up-file-capability-reading.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: capabilities: clean up file capability reading
From: "Serge E. Hallyn" <serue@us.ibm.com>

Simplify the vfs_cap_data structure.

Also fix get_file_caps which was declaring
__le32 v1caps[XATTR_CAPS_SZ] on the stack, but
XATTR_CAPS_SZ is already * sizeof(__le32).

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    6 ++----
 security/commoncap.c       |   23 +++++++++++++++--------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff -puN include/linux/capability.h~capabilities-clean-up-file-capability-reading include/linux/capability.h
--- a/include/linux/capability.h~capabilities-clean-up-file-capability-reading
+++ a/include/linux/capability.h
@@ -56,10 +56,8 @@ typedef struct __user_cap_data_struct {
 
 struct vfs_cap_data {
 	__u32 magic_etc;  /* Little endian */
-	struct {
-		__u32 permitted;    /* Little endian */
-		__u32 inheritable;  /* Little endian */
-	} data[1];
+	__u32 permitted;    /* Little endian */
+	__u32 inheritable;  /* Little endian */
 };
 
 #ifdef __KERNEL__
diff -puN security/commoncap.c~capabilities-clean-up-file-capability-reading security/commoncap.c
--- a/security/commoncap.c~capabilities-clean-up-file-capability-reading
+++ a/security/commoncap.c
@@ -140,7 +140,8 @@ int cap_inode_killpriv(struct dentry *de
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
 
-static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
+static inline int cap_from_disk(struct vfs_cap_data *caps,
+				struct linux_binprm *bprm,
 				int size)
 {
 	__u32 magic_etc;
@@ -148,7 +149,7 @@ static inline int cap_from_disk(__le32 *
 	if (size != XATTR_CAPS_SZ)
 		return -EINVAL;
 
-	magic_etc = le32_to_cpu(caps[0]);
+	magic_etc = le32_to_cpu(caps->magic_etc);
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
 	case VFS_CAP_REVISION:
@@ -156,8 +157,8 @@ static inline int cap_from_disk(__le32 *
 			bprm->cap_effective = true;
 		else
 			bprm->cap_effective = false;
-		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps[1]) );
-		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps[2]) );
+		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps->permitted) );
+		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps->inheritable) );
 		return 0;
 	default:
 		return -EINVAL;
@@ -169,7 +170,7 @@ static int get_file_caps(struct linux_bi
 {
 	struct dentry *dentry;
 	int rc = 0;
-	__le32 v1caps[XATTR_CAPS_SZ];
+	struct vfs_cap_data incaps;
 	struct inode *inode;
 
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
@@ -182,8 +183,14 @@ static int get_file_caps(struct linux_bi
 	if (!inode->i_op || !inode->i_op->getxattr)
 		goto out;
 
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &v1caps,
-							XATTR_CAPS_SZ);
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
+	if (rc > 0) {
+		if (rc == XATTR_CAPS_SZ)
+			rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS,
+						&incaps, XATTR_CAPS_SZ);
+		else
+			rc = -EINVAL;
+	}
 	if (rc == -ENODATA || rc == -EOPNOTSUPP) {
 		/* no data, that's ok */
 		rc = 0;
@@ -192,7 +199,7 @@ static int get_file_caps(struct linux_bi
 	if (rc < 0)
 		goto out;
 
-	rc = cap_from_disk(v1caps, bprm, rc);
+	rc = cap_from_disk(&incaps, bprm, rc);
 	if (rc)
 		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
 			__FUNCTION__, rc, bprm->filename);
_

Patches currently in -mm which might be from serue@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
security-convert-lsm-into-a-static-interface.patch
implement-file-posix-capabilities.patch
security-cleanups.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
capabilities-clean-up-file-capability-reading.patch
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
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
ipc-cleanup-some-code-and-wrong-comments-about-semundo.patch
virtualization-of-sysv-msg-queues-is-incomplete.patch
