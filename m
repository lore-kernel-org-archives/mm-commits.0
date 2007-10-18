From: akpm@linux-foundation.org
Subject: + capabilities-implement-64-bit-capabilities.patch added to -mm tree
Date: Wed, 17 Oct 2007 18:00:09 -0700
Message-ID: <200710180100.l9I109kL017133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758874AbXJRBBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 21:01:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, sds@tycho.nsa.gov


The patch titled
     capabilities: implement 64-bit capabilities
has been added to the -mm tree.  Its filename is
     capabilities-implement-64-bit-capabilities.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: capabilities: implement 64-bit capabilities
From: "Serge E. Hallyn" <serue@us.ibm.com>

We are out of capabilities in the 32-bit capability fields, and several
users could make use of additional capabilities.  Convert the capabilities
to 64-bits, change the capability version number accordingly, and convert
the file capability code to handle both 32-bit and 64-bit file capability
xattrs.

It might seem desirable to also implement back-compatibility to read 32-bit
caps from userspace, but that becomes problematic with capget, as capget
could return valid info for processes not using high bits, but would have
to return -EINVAL for those which were.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c            |    6 ++---
 include/linux/capability.h |   31 +++++++++++++++++++----------
 security/commoncap.c       |   37 +++++++++++++++++++++++++++--------
 3 files changed, 53 insertions(+), 21 deletions(-)

diff -puN fs/proc/array.c~capabilities-implement-64-bit-capabilities fs/proc/array.c
--- a/fs/proc/array.c~capabilities-implement-64-bit-capabilities
+++ a/fs/proc/array.c
@@ -281,9 +281,9 @@ static inline char *task_sig(struct task
 
 static inline char *task_cap(struct task_struct *p, char *buffer)
 {
-    return buffer + sprintf(buffer, "CapInh:\t%016x\n"
-			    "CapPrm:\t%016x\n"
-			    "CapEff:\t%016x\n",
+    return buffer + sprintf(buffer, "CapInh:\t%016lx\n"
+			    "CapPrm:\t%016lx\n"
+			    "CapEff:\t%016lx\n",
 			    cap_t(p->cap_inheritable),
 			    cap_t(p->cap_permitted),
 			    cap_t(p->cap_effective));
diff -puN include/linux/capability.h~capabilities-implement-64-bit-capabilities include/linux/capability.h
--- a/include/linux/capability.h~capabilities-implement-64-bit-capabilities
+++ a/include/linux/capability.h
@@ -29,7 +29,7 @@ struct task_struct;
    library since the draft standard requires the use of malloc/free
    etc.. */
 
-#define _LINUX_CAPABILITY_VERSION  0x19980330
+#define _LINUX_CAPABILITY_VERSION  0x20071015
 
 typedef struct __user_cap_header_struct {
 	__u32 version;
@@ -37,29 +37,40 @@ typedef struct __user_cap_header_struct 
 } __user *cap_user_header_t;
 
 typedef struct __user_cap_data_struct {
-        __u32 effective;
-        __u32 permitted;
-        __u32 inheritable;
+        __u64 effective;
+        __u64 permitted;
+        __u64 inheritable;
 } __user *cap_user_data_t;
 
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
 
-#define XATTR_CAPS_SZ (3*sizeof(__le32))
+#define XATTR_CAPS_SZ_1 (3*sizeof(__le32))
+#define XATTR_CAPS_SZ_2 (2*sizeof(__le64) + sizeof(__le32))
 #define VFS_CAP_REVISION_MASK	0xFF000000
 #define VFS_CAP_REVISION_1	0x01000000
+#define VFS_CAP_REVISION_2	0x02000000
 
-#define VFS_CAP_REVISION	VFS_CAP_REVISION_1
+#define VFS_CAP_REVISION	VFS_CAP_REVISION_2
+#define XATTR_CAPS_SZ		XATTR_CAPS_SZ_2
 
 #define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
 #define VFS_CAP_FLAGS_EFFECTIVE	0x000001
 
-struct vfs_cap_data {
+struct vfs_cap_data_v1 {
 	__u32 magic_etc;  /* Little endian */
 	__u32 permitted;    /* Little endian */
 	__u32 inheritable;  /* Little endian */
 };
 
+struct vfs_cap_data_v2 {
+	__u32 magic_etc;  /* Little endian */
+	__u64 permitted;    /* Little endian */
+	__u64 inheritable;  /* Little endian */
+};
+
+typedef struct vfs_cap_data_v2 vfs_cap_data;
+
 #ifdef __KERNEL__
 
 /* #define STRICT_CAP_T_TYPECHECKS */
@@ -67,12 +78,12 @@ struct vfs_cap_data {
 #ifdef STRICT_CAP_T_TYPECHECKS
 
 typedef struct kernel_cap_struct {
-	__u32 cap;
+	__u64 cap;
 } kernel_cap_t;
 
 #else
 
-typedef __u32 kernel_cap_t;
+typedef __u64 kernel_cap_t;
 
 #endif
 
@@ -334,7 +345,7 @@ extern kernel_cap_t cap_bset;
 #define CAP_INIT_EFF_SET    to_cap_t(~0 & ~CAP_TO_MASK(CAP_SETPCAP))
 #define CAP_INIT_INH_SET    to_cap_t(0)
 
-#define CAP_TO_MASK(x) (1 << (x))
+#define CAP_TO_MASK(x) (1ULL << (x))
 #define cap_raise(c, flag)   (cap_t(c) |=  CAP_TO_MASK(flag))
 #define cap_lower(c, flag)   (cap_t(c) &= ~CAP_TO_MASK(flag))
 #define cap_raised(c, flag)  (cap_t(c) & CAP_TO_MASK(flag))
diff -puN security/commoncap.c~capabilities-implement-64-bit-capabilities security/commoncap.c
--- a/security/commoncap.c~capabilities-implement-64-bit-capabilities
+++ a/security/commoncap.c
@@ -140,25 +140,46 @@ int cap_inode_killpriv(struct dentry *de
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
 
-static inline int cap_from_disk(struct vfs_cap_data *caps,
+union vfs_cap_union {
+	struct vfs_cap_data_v1 v1;
+	struct vfs_cap_data_v2 v2;
+};
+
+static inline int cap_from_disk(union vfs_cap_union *caps,
 				struct linux_binprm *bprm,
 				int size)
 {
 	__u32 magic_etc;
 
-	if (size != XATTR_CAPS_SZ)
+	if (size != XATTR_CAPS_SZ_1 && size != XATTR_CAPS_SZ_2)
 		return -EINVAL;
 
-	magic_etc = le32_to_cpu(caps->magic_etc);
+	magic_etc = le32_to_cpu(caps->v1.magic_etc);
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
-	case VFS_CAP_REVISION:
+	case VFS_CAP_REVISION_1:
+		if (size != XATTR_CAPS_SZ_1)
+			return -EINVAL;
+		if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
+			bprm->cap_effective = true;
+		else
+			bprm->cap_effective = false;
+		bprm->cap_permitted = to_cap_t(
+			(__u64) le32_to_cpu(caps->v1.permitted) );
+		bprm->cap_inheritable = to_cap_t(
+			(__u64) le32_to_cpu(caps->v1.inheritable) );
+		return 0;
+	case VFS_CAP_REVISION_2:
+		if (size != XATTR_CAPS_SZ_2)
+			return -EINVAL;
 		if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
 			bprm->cap_effective = true;
 		else
 			bprm->cap_effective = false;
-		bprm->cap_permitted = to_cap_t(le32_to_cpu(caps->permitted));
-		bprm->cap_inheritable = to_cap_t(le32_to_cpu(caps->inheritable));
+		bprm->cap_permitted = to_cap_t(
+			le64_to_cpu(caps->v2.permitted) );
+		bprm->cap_inheritable = to_cap_t(
+			le64_to_cpu(caps->v2.inheritable) );
 		return 0;
 	default:
 		return -EINVAL;
@@ -170,7 +191,7 @@ static int get_file_caps(struct linux_bi
 {
 	struct dentry *dentry;
 	int rc = 0;
-	struct vfs_cap_data incaps;
+	union vfs_cap_union incaps;
 	struct inode *inode;
 
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
@@ -185,7 +206,7 @@ static int get_file_caps(struct linux_bi
 
 	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
 	if (rc > 0) {
-		if (rc == XATTR_CAPS_SZ)
+		if (rc == XATTR_CAPS_SZ_2 || rc == XATTR_CAPS_SZ_1)
 			rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS,
 						&incaps, XATTR_CAPS_SZ);
 		else
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
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
capabilities-implement-64-bit-capabilities.patch
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
