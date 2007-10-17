From: akpm@linux-foundation.org
Subject: - file-capabilities-change-xattr-format-v2.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:37:42 -0700
Message-ID: <200710170137.l9H1bgVw027946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33760 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbXJQBiQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:38:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     file capabilities: change xattr format (v2)
has been removed from the -mm tree.  Its filename was
     file-capabilities-change-xattr-format-v2.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

------------------------------------------------------
Subject: file capabilities: change xattr format (v2)
From: Serge E. Hallyn <serue@us.ibm.com>

This patch implements three suggestions by Andrew Morgan.  The first is to
change the on disk format.  The __le32 version, is renamed 'magic_etc', and
contains a revision number (starting at 1), and a bit representing Fe.  The
Fe capset is no longer stored, so the xattr is now 3 ints instead of 4.

The Fe was previously a full capset which was masked with the calculated
new_permitted to get the process' new effective set.  It is now a single
bit in the xattr.  Soon, the bprm->cap_effective will also be changed to a
boolean.  When that boolean is false, the P'e will be the empty set.  When
the boolean is true, then P'e will be set equal to P'p (new_permitted). 
The rationale for this is that either the application does not know about
capabilities, and needs to start with all permitted caps in its effective
set, or it does know about capabilities, and can start with an empty
effective set and enable the caps it wants when it wants.

Finally, future format compatibility is reduced.  If a security.capability
xattr is found with too new a version, don't run the binary.

(I can send an ltp patch to test this to anyone who asks.)

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |   35 +++++-------------
 security/commoncap.c       |   65 ++++++++++++-----------------------
 2 files changed, 34 insertions(+), 66 deletions(-)

diff -puN include/linux/capability.h~file-capabilities-change-xattr-format-v2 include/linux/capability.h
--- a/include/linux/capability.h~file-capabilities-change-xattr-format-v2
+++ a/include/linux/capability.h
@@ -45,38 +45,23 @@ typedef struct __user_cap_data_struct {
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
 
-/* size of caps that we work with */
-#define XATTR_CAPS_SZ (4*sizeof(__le32))
+#define XATTR_CAPS_SZ (3*sizeof(__le32))
+#define VFS_CAP_REVISION_MASK	0xFF000000
+#define VFS_CAP_REVISION	0x01000000
 
-/*
- * data[] is organized as:
- *   effective[0]
- *   permitted[0]
- *   inheritable[0]
- *   effective[1]
- *   ...
- * this way we can just read as much of the on-disk capability as
- * we know should exist and know we'll get the data we'll need.
- */
-struct vfs_cap_data_disk {
-	__le32 version;
-	__le32 data[];  /* eff[0], perm[0], inh[0], eff[1], ... */
-};
-
-struct vfs_cap_data_disk_v1 {
-	__le32 version;
-	__le32 data[3];  /* eff[0], perm[0], inh[0] */
-};
+#define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
+#define VFS_CAP_FLAGS_EFFECTIVE	0x000001
 
 #ifdef __KERNEL__
 
 #include <asm/current.h>
 
 struct vfs_cap_data {
-	__u32 version;
-	__u32 effective;
-	__u32 permitted;
-	__u32 inheritable;
+	__u32 magic_etc;  /* Little endian */
+	struct {
+		__u32 permitted;    /* Little endian */
+		__u32 inheritable;  /* Little endian */
+	} data[1];
 };
 
 /* #define STRICT_CAP_T_TYPECHECKS */
diff -puN security/commoncap.c~file-capabilities-change-xattr-format-v2 security/commoncap.c
--- a/security/commoncap.c~file-capabilities-change-xattr-format-v2
+++ a/security/commoncap.c
@@ -118,27 +118,26 @@ static inline void bprm_clear_caps(struc
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
-static inline int cap_from_disk(struct vfs_cap_data_disk *dcap,
-					struct linux_binprm *bprm, int size)
+static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
+				int size)
 {
-	int version;
+	__u32 magic_etc;
 
-	version = le32_to_cpu(dcap->version);
-	if (version != _LINUX_CAPABILITY_VERSION)
+	if (size != XATTR_CAPS_SZ)
 		return -EINVAL;
 
-	size /= sizeof(u32);
-	if ((size-1)%3) {
-		printk(KERN_WARNING "%s: size is an invalid size %d for %s\n",
-						__FUNCTION__, size, bprm->filename);
+	magic_etc = le32_to_cpu(caps[0]);
+
+	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
+	case VFS_CAP_REVISION:
+		bprm->cap_effective = (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
+					? CAP_FULL_SET : CAP_EMPTY_SET;
+		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps[1]) );
+		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps[2]) );
+		return 0;
+	default:
 		return -EINVAL;
 	}
-
-	bprm->cap_effective = le32_to_cpu(dcap->data[0]);
-	bprm->cap_permitted = le32_to_cpu(dcap->data[1]);
-	bprm->cap_inheritable = le32_to_cpu(dcap->data[2]);
-
-	return 0;
 }
 
 /* Locate any VFS capabilities: */
@@ -146,11 +145,9 @@ static int get_file_caps(struct linux_bi
 {
 	struct dentry *dentry;
 	int rc = 0;
-	struct vfs_cap_data_disk_v1 v1caps;
-	struct vfs_cap_data_disk *dcaps;
+	__le32 v1caps[XATTR_CAPS_SZ];
 	struct inode *inode;
 
-	dcaps = (struct vfs_cap_data_disk *)&v1caps;
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
 		bprm_clear_caps(bprm);
 		return 0;
@@ -161,40 +158,23 @@ static int get_file_caps(struct linux_bi
 	if (!inode->i_op || !inode->i_op->getxattr)
 		goto out;
 
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, dcaps,
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &v1caps,
 							XATTR_CAPS_SZ);
 	if (rc == -ENODATA || rc == -EOPNOTSUPP) {
+		/* no data, that's ok */
 		rc = 0;
 		goto out;
 	}
-	if (rc == -ERANGE) {
-		int size;
-		size = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
-		if (size <= 0) {  /* shouldn't ever happen */
-			rc = -EINVAL;
-			goto out;
-		}
-		dcaps = kmalloc(size, GFP_KERNEL);
-		if (!dcaps) {
-			rc = -ENOMEM;
-			goto out;
-		}
-		rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, dcaps,
-							size);
-	}
 	if (rc < 0)
 		goto out;
-	if (rc < sizeof(struct vfs_cap_data_disk_v1)) {
-		rc = -EINVAL;
-		goto out;
-	}
 
-	rc = cap_from_disk(dcaps, bprm, rc);
+	rc = cap_from_disk(v1caps, bprm, rc);
+	if (rc)
+		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
+			__FUNCTION__, rc, bprm->filename);
 
 out:
 	dput(dentry);
-	if ((void *)dcaps != (void *)&v1caps)
-		kfree(dcaps);
 	if (rc)
 		bprm_clear_caps(bprm);
 
@@ -214,6 +194,9 @@ int cap_bprm_set_security (struct linux_
 	int ret;
 
 	ret = get_file_caps(bprm);
+	if (ret)
+		printk(KERN_NOTICE "%s: get_file_caps returned %d for %s\n",
+			__FUNCTION__, ret, bprm->filename);
 
 	/*  To support inheritance of root-permissions and suid-root
 	 *  executables under compatibility mode, we raise all three
_

Patches currently in -mm which might be from serue@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
security-convert-lsm-into-a-static-interface.patch
implement-file-posix-capabilities.patch
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
