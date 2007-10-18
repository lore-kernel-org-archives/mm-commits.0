From: akpm@linux-foundation.org
Subject: - implement-file-posix-capabilities.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:13 -0700
Message-ID: <200710180705.l9I75Dbm031631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761225AbXJRHiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, bunk@kernel.org, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     Implement file posix capabilities
has been removed from the -mm tree.  Its filename was
     implement-file-posix-capabilities.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Implement file posix capabilities
From: Serge E. Hallyn <serue@us.ibm.com>

Implement file posix capabilities.  This allows programs to be given a
subset of root's powers regardless of who runs them, without having to use
setuid and giving the binary all of root's powers.

This version works with Kaigai Kohei's userspace tools, found at
http://www.kaigai.gr.jp/index.php.  For more information on how to use this
patch, Chris Friedhoff has posted a nice page at
http://www.friedhoff.org/fscaps.html.

Changelog:
	Nov 27:
	Incorporate fixes from Andrew Morton
	(security-introduce-file-caps-tweaks and
	security-introduce-file-caps-warning-fix)
	Fix Kconfig dependency.
	Fix change signaling behavior when file caps are not compiled in.

	Nov 13:
	Integrate comments from Alexey: Remove CONFIG_ ifdef from
	capability.h, and use %zd for printing a size_t.

	Nov 13:
	Fix endianness warnings by sparse as suggested by Alexey
	Dobriyan.

	Nov 09:
	Address warnings of unused variables at cap_bprm_set_security
	when file capabilities are disabled, and simultaneously clean
	up the code a little, by pulling the new code into a helper
	function.

	Nov 08:
	For pointers to required userspace tools and how to use
	them, see http://www.friedhoff.org/fscaps.html.

	Nov 07:
	Fix the calculation of the highest bit checked in
	check_cap_sanity().

	Nov 07:
	Allow file caps to be enabled without CONFIG_SECURITY, since
	capabilities are the default.
	Hook cap_task_setscheduler when !CONFIG_SECURITY.
	Move capable(TASK_KILL) to end of cap_task_kill to reduce
	audit messages.

	Nov 05:
	Add secondary calls in selinux/hooks.c to task_setioprio and
	task_setscheduler so that selinux and capabilities with file
	cap support can be stacked.

	Sep 05:
	As Seth Arnold points out, uid checks are out of place
	for capability code.

	Sep 01:
	Define task_setscheduler, task_setioprio, cap_task_kill, and
	task_setnice to make sure a user cannot affect a process in which
	they called a program with some fscaps.

	One remaining question is the note under task_setscheduler: are we
	ok with CAP_SYS_NICE being sufficient to confine a process to a
	cpuset?

	It is a semantic change, as without fsccaps, attach_task doesn't
	allow CAP_SYS_NICE to override the uid equivalence check.  But since
	it uses security_task_setscheduler, which elsewhere is used where
	CAP_SYS_NICE can be used to override the uid equivalence check,
	fixing it might be tough.

	     task_setscheduler
		 note: this also controls cpuset:attach_task.  Are we ok with
		     CAP_SYS_NICE being used to confine to a cpuset?
	     task_setioprio
	     task_setnice
		 sys_setpriority uses this (through set_one_prio) for another
		 process.  Need same checks as setrlimit

	Aug 21:
	Updated secureexec implementation to reflect the fact that
	euid and uid might be the same and nonzero, but the process
	might still have elevated caps.

	Aug 15:
	Handle endianness of xattrs.
	Enforce capability version match between kernel and disk.
	Enforce that no bits beyond the known max capability are
	set, else return -EPERM.
	With this extra processing, it may be worth reconsidering
	doing all the work at bprm_set_security rather than
	d_instantiate.

	Aug 10:
	Always call getxattr at bprm_set_security, rather than
	caching it at d_instantiate.

[morgan@kernel.org: file-caps clean up for linux/capability.h]
[bunk@kernel.org: unexport cap_inode_killpriv]
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morgan <morgan@kernel.org>
Signed-off-by: Andrew Morgan <morgan@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/attr.c                  |    9 +
 fs/nfsd/vfs.c              |    4 
 fs/open.c                  |    3 
 fs/splice.c                |   13 +
 include/linux/binfmts.h    |    3 
 include/linux/capability.h |   48 ++++--
 include/linux/fs.h         |    1 
 include/linux/security.h   |   40 +++++
 mm/filemap.c               |   16 +-
 security/Kconfig           |   10 +
 security/capability.c      |    6 
 security/commoncap.c       |  244 ++++++++++++++++++++++++++++++++---
 security/dummy.c           |   12 +
 security/security.c        |   10 +
 security/selinux/hooks.c   |   74 ++++++----
 15 files changed, 419 insertions(+), 74 deletions(-)

diff -puN fs/attr.c~implement-file-posix-capabilities fs/attr.c
--- a/fs/attr.c~implement-file-posix-capabilities
+++ a/fs/attr.c
@@ -116,6 +116,15 @@ int notify_change(struct dentry * dentry
 		attr->ia_atime = now;
 	if (!(ia_valid & ATTR_MTIME_SET))
 		attr->ia_mtime = now;
+	if (ia_valid & ATTR_KILL_PRIV) {
+		attr->ia_valid &= ~ATTR_KILL_PRIV;
+		ia_valid &= ~ATTR_KILL_PRIV;
+		error = security_inode_need_killpriv(dentry);
+		if (error > 0)
+			error = security_inode_killpriv(dentry);
+		if (error)
+			return error;
+	}
 	if (ia_valid & ATTR_KILL_SUID) {
 		attr->ia_valid &= ~ATTR_KILL_SUID;
 		if (mode & S_ISUID) {
diff -puN fs/nfsd/vfs.c~implement-file-posix-capabilities fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~implement-file-posix-capabilities
+++ a/fs/nfsd/vfs.c
@@ -368,7 +368,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 
 	/* Revoke setuid/setgid bit on chown/chgrp */
 	if ((iap->ia_valid & ATTR_UID) && iap->ia_uid != inode->i_uid)
-		iap->ia_valid |= ATTR_KILL_SUID;
+		iap->ia_valid |= ATTR_KILL_SUID | ATTR_KILL_PRIV;
 	if ((iap->ia_valid & ATTR_GID) && iap->ia_gid != inode->i_gid)
 		iap->ia_valid |= ATTR_KILL_SGID;
 
@@ -937,7 +937,7 @@ out:
 static void kill_suid(struct dentry *dentry)
 {
 	struct iattr	ia;
-	ia.ia_valid = ATTR_KILL_SUID | ATTR_KILL_SGID;
+	ia.ia_valid = ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	notify_change(dentry, &ia);
diff -puN fs/open.c~implement-file-posix-capabilities fs/open.c
--- a/fs/open.c~implement-file-posix-capabilities
+++ a/fs/open.c
@@ -658,7 +658,8 @@ static int chown_common(struct dentry * 
 		newattrs.ia_gid = group;
 	}
 	if (!S_ISDIR(inode->i_mode))
-		newattrs.ia_valid |= ATTR_KILL_SUID|ATTR_KILL_SGID;
+		newattrs.ia_valid |=
+			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
diff -puN fs/splice.c~implement-file-posix-capabilities fs/splice.c
--- a/fs/splice.c~implement-file-posix-capabilities
+++ a/fs/splice.c
@@ -824,13 +824,18 @@ generic_file_splice_write(struct pipe_in
 {
 	struct address_space *mapping = out->f_mapping;
 	struct inode *inode = mapping->host;
+	int killsuid, killpriv;
 	ssize_t ret;
-	int err;
+	int err = 0;
 
-	err = should_remove_suid(out->f_path.dentry);
-	if (unlikely(err)) {
+	killpriv = security_inode_need_killpriv(out->f_path.dentry);
+	killsuid = should_remove_suid(out->f_path.dentry);
+	if (unlikely(killsuid || killpriv)) {
 		mutex_lock(&inode->i_mutex);
-		err = __remove_suid(out->f_path.dentry, err);
+		if (killpriv)
+			err = security_inode_killpriv(out->f_path.dentry);
+		if (!err && killsuid)
+			err = __remove_suid(out->f_path.dentry, killsuid);
 		mutex_unlock(&inode->i_mutex);
 		if (err)
 			return err;
diff -puN include/linux/binfmts.h~implement-file-posix-capabilities include/linux/binfmts.h
--- a/include/linux/binfmts.h~implement-file-posix-capabilities
+++ a/include/linux/binfmts.h
@@ -37,7 +37,8 @@ struct linux_binprm{
 	int sh_bang;
 	struct file * file;
 	int e_uid, e_gid;
-	kernel_cap_t cap_inheritable, cap_permitted, cap_effective;
+	kernel_cap_t cap_inheritable, cap_permitted;
+	bool cap_effective;
 	void *security;
 	int argc, envc;
 	char * filename;	/* Name of binary as seen by procps */
diff -puN include/linux/capability.h~implement-file-posix-capabilities include/linux/capability.h
--- a/include/linux/capability.h~implement-file-posix-capabilities
+++ a/include/linux/capability.h
@@ -1,14 +1,14 @@
 /*
  * This is <linux/capability.h>
  *
- * Andrew G. Morgan <morgan@transmeta.com>
+ * Andrew G. Morgan <morgan@kernel.org>
  * Alexander Kjeldaas <astor@guardian.no>
  * with help from Aleph1, Roland Buresund and Andrew Main.
  *
  * See here for the libcap library ("POSIX draft" compliance):
  *
- * ftp://linux.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.2/
- */ 
+ * ftp://linux.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/
+ */
 
 #ifndef _LINUX_CAPABILITY_H
 #define _LINUX_CAPABILITY_H
@@ -28,23 +28,41 @@ struct task_struct;
    following structure to such a composite is better handled in a user
    library since the draft standard requires the use of malloc/free
    etc.. */
- 
+
 #define _LINUX_CAPABILITY_VERSION  0x19980330
 
 typedef struct __user_cap_header_struct {
 	__u32 version;
 	int pid;
 } __user *cap_user_header_t;
- 
+
 typedef struct __user_cap_data_struct {
         __u32 effective;
         __u32 permitted;
         __u32 inheritable;
 } __user *cap_user_data_t;
-  
-#ifdef __KERNEL__
 
-#include <asm/current.h>
+#define XATTR_CAPS_SUFFIX "capability"
+#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
+
+#define XATTR_CAPS_SZ (3*sizeof(__le32))
+#define VFS_CAP_REVISION_MASK	0xFF000000
+#define VFS_CAP_REVISION_1	0x01000000
+
+#define VFS_CAP_REVISION	VFS_CAP_REVISION_1
+
+#define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
+#define VFS_CAP_FLAGS_EFFECTIVE	0x000001
+
+struct vfs_cap_data {
+	__u32 magic_etc;  /* Little endian */
+	struct {
+		__u32 permitted;    /* Little endian */
+		__u32 inheritable;  /* Little endian */
+	} data[1];
+};
+
+#ifdef __KERNEL__
 
 /* #define STRICT_CAP_T_TYPECHECKS */
 
@@ -59,7 +77,7 @@ typedef struct kernel_cap_struct {
 typedef __u32 kernel_cap_t;
 
 #endif
-  
+
 #define _USER_CAP_HEADER_SIZE  (2*sizeof(__u32))
 #define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
 
@@ -67,7 +85,7 @@ typedef __u32 kernel_cap_t;
 
 
 /**
- ** POSIX-draft defined capabilities. 
+ ** POSIX-draft defined capabilities.
  **/
 
 /* In a system with the [_POSIX_CHOWN_RESTRICTED] option defined, this
@@ -87,7 +105,7 @@ typedef __u32 kernel_cap_t;
    defined. Excluding DAC access covered by CAP_LINUX_IMMUTABLE. */
 
 #define CAP_DAC_READ_SEARCH  2
-    
+
 /* Overrides all restrictions about allowed operations on files, where
    file owner ID must be equal to the user ID, except where CAP_FSETID
    is applicable. It doesn't override MAC and DAC restrictions. */
@@ -257,7 +275,7 @@ typedef __u32 kernel_cap_t;
 /* Override reserved space on ext2 filesystem */
 /* Modify data journaling mode on ext3 filesystem (uses journaling
    resources) */
-/* NOTE: ext2 honors fsuid when checking for resource overrides, so 
+/* NOTE: ext2 honors fsuid when checking for resource overrides, so
    you can override using fsuid too */
 /* Override size restrictions on IPC message queues */
 /* Allow more than 64hz interrupts from the real-time clock */
@@ -289,8 +307,10 @@ typedef __u32 kernel_cap_t;
 
 #define CAP_AUDIT_CONTROL    30
 
+#define CAP_SETFCAP	     31
+
 #ifdef __KERNEL__
-/* 
+/*
  * Bounding set
  */
 extern kernel_cap_t cap_bset;
@@ -298,7 +318,7 @@ extern kernel_cap_t cap_bset;
 /*
  * Internal kernel functions only
  */
- 
+
 #ifdef STRICT_CAP_T_TYPECHECKS
 
 #define to_cap_t(x) { x }
diff -puN include/linux/fs.h~implement-file-posix-capabilities include/linux/fs.h
--- a/include/linux/fs.h~implement-file-posix-capabilities
+++ a/include/linux/fs.h
@@ -329,6 +329,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_KILL_SUID	2048
 #define ATTR_KILL_SGID	4096
 #define ATTR_FILE	8192
+#define ATTR_KILL_PRIV	16384
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
diff -puN include/linux/security.h~implement-file-posix-capabilities include/linux/security.h
--- a/include/linux/security.h~implement-file-posix-capabilities
+++ a/include/linux/security.h
@@ -51,8 +51,14 @@ extern void cap_bprm_apply_creds (struct
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
 extern int cap_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags);
 extern int cap_inode_removexattr(struct dentry *dentry, char *name);
+extern int cap_inode_need_killpriv(struct dentry *dentry);
+extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
+extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
+extern int cap_task_setscheduler (struct task_struct *p, int policy, struct sched_param *lp);
+extern int cap_task_setioprio (struct task_struct *p, int ioprio);
+extern int cap_task_setnice (struct task_struct *p, int nice);
 extern int cap_syslog (int type);
 extern int cap_vm_enough_memory(struct mm_struct *mm, long pages);
 
@@ -413,6 +419,18 @@ struct request_sock;
  *	is specified by @buffer_size.  @buffer may be NULL to request
  *	the size of the buffer required.
  *	Returns number of bytes used/required on success.
+ * @inode_need_killpriv:
+ *	Called when an inode has been changed.
+ *	@dentry is the dentry being changed.
+ *	Return <0 on error to abort the inode change operation.
+ *	Return 0 if inode_killpriv does not need to be called.
+ *	Return >0 if inode_killpriv does need to be called.
+ * @inode_killpriv:
+ *	The setuid bit is being removed.  Remove similar security labels.
+ *	Called with the dentry->d_inode->i_mutex held.
+ *	@dentry is the dentry being changed.
+ *	Return 0 on success.  If error is returned, then the operation
+ *	causing setuid bit removal is failed.
  *
  * Security hooks for file operations
  *
@@ -1239,6 +1257,8 @@ struct security_operations {
 	int (*inode_getxattr) (struct dentry *dentry, char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
+	int (*inode_need_killpriv) (struct dentry *dentry);
+	int (*inode_killpriv) (struct dentry *dentry);
 	const char *(*inode_xattr_getsuffix) (void);
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
@@ -1496,6 +1516,8 @@ void security_inode_post_setxattr(struct
 int security_inode_getxattr(struct dentry *dentry, char *name);
 int security_inode_listxattr(struct dentry *dentry);
 int security_inode_removexattr(struct dentry *dentry, char *name);
+int security_inode_need_killpriv(struct dentry *dentry);
+int security_inode_killpriv(struct dentry *dentry);
 const char *security_inode_xattr_getsuffix(void);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
@@ -1891,6 +1913,16 @@ static inline int security_inode_removex
 	return cap_inode_removexattr(dentry, name);
 }
 
+static inline int security_inode_need_killpriv(struct dentry *dentry)
+{
+	return cap_inode_need_killpriv(dentry);
+}
+
+static inline int security_inode_killpriv(struct dentry *dentry)
+{
+	return cap_inode_killpriv(dentry);
+}
+
 static inline const char *security_inode_xattr_getsuffix (void)
 {
 	return NULL ;
@@ -2035,12 +2067,12 @@ static inline int security_task_setgroup
 
 static inline int security_task_setnice (struct task_struct *p, int nice)
 {
-	return 0;
+	return cap_task_setnice(p, nice);
 }
 
 static inline int security_task_setioprio (struct task_struct *p, int ioprio)
 {
-	return 0;
+	return cap_task_setioprio(p, ioprio);
 }
 
 static inline int security_task_getioprio (struct task_struct *p)
@@ -2058,7 +2090,7 @@ static inline int security_task_setsched
 					      int policy,
 					      struct sched_param *lp)
 {
-	return 0;
+	return cap_task_setscheduler(p, policy, lp);
 }
 
 static inline int security_task_getscheduler (struct task_struct *p)
@@ -2075,7 +2107,7 @@ static inline int security_task_kill (st
 				      struct siginfo *info, int sig,
 				      u32 secid)
 {
-	return 0;
+	return cap_task_kill(p, info, sig, secid);
 }
 
 static inline int security_task_wait (struct task_struct *p)
diff -puN mm/filemap.c~implement-file-posix-capabilities mm/filemap.c
--- a/mm/filemap.c~implement-file-posix-capabilities
+++ a/mm/filemap.c
@@ -1627,12 +1627,18 @@ int __remove_suid(struct dentry *dentry,
 
 int remove_suid(struct dentry *dentry)
 {
-	int kill = should_remove_suid(dentry);
+	int killsuid = should_remove_suid(dentry);
+	int killpriv = security_inode_need_killpriv(dentry);
+	int error = 0;
+
+	if (killpriv < 0)
+		return killpriv;
+	if (killpriv)
+		error = security_inode_killpriv(dentry);
+	if (!error && killsuid)
+		error = __remove_suid(dentry, killsuid);
 
-	if (unlikely(kill))
-		return __remove_suid(dentry, kill);
-
-	return 0;
+	return error;
 }
 EXPORT_SYMBOL(remove_suid);
 
diff -puN security/Kconfig~implement-file-posix-capabilities security/Kconfig
--- a/security/Kconfig~implement-file-posix-capabilities
+++ a/security/Kconfig
@@ -80,6 +80,16 @@ config SECURITY_CAPABILITIES
 	  This enables the "default" Linux capabilities functionality.
 	  If you are unsure how to answer this question, answer Y.
 
+config SECURITY_FILE_CAPABILITIES
+	bool "File POSIX Capabilities (EXPERIMENTAL)"
+	depends on (SECURITY=n || SECURITY_CAPABILITIES!=n) && EXPERIMENTAL
+	default n
+	help
+	  This enables filesystem capabilities, allowing you to give
+	  binaries a subset of root's powers without using setuid 0.
+
+	  If in doubt, answer N.
+
 config SECURITY_ROOTPLUG
 	bool "Root Plug Support"
 	depends on USB=y && SECURITY
diff -puN security/capability.c~implement-file-posix-capabilities security/capability.c
--- a/security/capability.c~implement-file-posix-capabilities
+++ a/security/capability.c
@@ -37,7 +37,13 @@ static struct security_operations capabi
 
 	.inode_setxattr =		cap_inode_setxattr,
 	.inode_removexattr =		cap_inode_removexattr,
+	.inode_need_killpriv =		cap_inode_need_killpriv,
+	.inode_killpriv =		cap_inode_killpriv,
 
+	.task_kill =			cap_task_kill,
+	.task_setscheduler =		cap_task_setscheduler,
+	.task_setioprio =		cap_task_setioprio,
+	.task_setnice =			cap_task_setnice,
 	.task_post_setuid =		cap_task_post_setuid,
 	.task_reparent_to_init =	cap_task_reparent_to_init,
 
diff -puN security/commoncap.c~implement-file-posix-capabilities security/commoncap.c
--- a/security/commoncap.c~implement-file-posix-capabilities
+++ a/security/commoncap.c
@@ -22,6 +22,7 @@
 #include <linux/ptrace.h>
 #include <linux/xattr.h>
 #include <linux/hugetlb.h>
+#include <linux/mount.h>
 
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
@@ -108,14 +109,130 @@ void cap_capset_set (struct task_struct 
 	target->cap_permitted = *permitted;
 }
 
+static inline void bprm_clear_caps(struct linux_binprm *bprm)
+{
+	cap_clear(bprm->cap_inheritable);
+	cap_clear(bprm->cap_permitted);
+	bprm->cap_effective = false;
+}
+
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+
+int cap_inode_need_killpriv(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	if (!inode->i_op || !inode->i_op->getxattr)
+	       return 0;
+
+	error = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
+	if (error <= 0)
+		return 0;
+	return 1;
+}
+
+int cap_inode_killpriv(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+
+	if (!inode->i_op || !inode->i_op->removexattr)
+	       return 0;
+
+	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
+}
+
+static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
+				int size)
+{
+	__u32 magic_etc;
+
+	if (size != XATTR_CAPS_SZ)
+		return -EINVAL;
+
+	magic_etc = le32_to_cpu(caps[0]);
+
+	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
+	case VFS_CAP_REVISION:
+		if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
+			bprm->cap_effective = true;
+		else
+			bprm->cap_effective = false;
+		bprm->cap_permitted = to_cap_t( le32_to_cpu(caps[1]) );
+		bprm->cap_inheritable = to_cap_t( le32_to_cpu(caps[2]) );
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+/* Locate any VFS capabilities: */
+static int get_file_caps(struct linux_binprm *bprm)
+{
+	struct dentry *dentry;
+	int rc = 0;
+	__le32 v1caps[XATTR_CAPS_SZ];
+	struct inode *inode;
+
+	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
+		bprm_clear_caps(bprm);
+		return 0;
+	}
+
+	dentry = dget(bprm->file->f_dentry);
+	inode = dentry->d_inode;
+	if (!inode->i_op || !inode->i_op->getxattr)
+		goto out;
+
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &v1caps,
+							XATTR_CAPS_SZ);
+	if (rc == -ENODATA || rc == -EOPNOTSUPP) {
+		/* no data, that's ok */
+		rc = 0;
+		goto out;
+	}
+	if (rc < 0)
+		goto out;
+
+	rc = cap_from_disk(v1caps, bprm, rc);
+	if (rc)
+		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
+			__FUNCTION__, rc, bprm->filename);
+
+out:
+	dput(dentry);
+	if (rc)
+		bprm_clear_caps(bprm);
+
+	return rc;
+}
+
+#else
+int cap_inode_need_killpriv(struct dentry *dentry)
+{
+	return 0;
+}
+
+int cap_inode_killpriv(struct dentry *dentry)
+{
+	return 0;
+}
+
+static inline int get_file_caps(struct linux_binprm *bprm)
+{
+	bprm_clear_caps(bprm);
+	return 0;
+}
+#endif
+
 int cap_bprm_set_security (struct linux_binprm *bprm)
 {
-	/* Copied from fs/exec.c:prepare_binprm. */
+	int ret;
 
-	/* We don't have VFS support for capabilities yet */
-	cap_clear (bprm->cap_inheritable);
-	cap_clear (bprm->cap_permitted);
-	cap_clear (bprm->cap_effective);
+	ret = get_file_caps(bprm);
+	if (ret)
+		printk(KERN_NOTICE "%s: get_file_caps returned %d for %s\n",
+			__FUNCTION__, ret, bprm->filename);
 
 	/*  To support inheritance of root-permissions and suid-root
 	 *  executables under compatibility mode, we raise all three
@@ -131,9 +248,10 @@ int cap_bprm_set_security (struct linux_
 			cap_set_full (bprm->cap_permitted);
 		}
 		if (bprm->e_uid == 0)
-			cap_set_full (bprm->cap_effective);
+			bprm->cap_effective = true;
 	}
-	return 0;
+
+	return ret;
 }
 
 void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
@@ -149,6 +267,7 @@ void cap_bprm_apply_creds (struct linux_
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
 	    !cap_issubset (new_permitted, current->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
+		current->pdeath_signal = 0;
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
@@ -170,8 +289,8 @@ void cap_bprm_apply_creds (struct linux_
 	 * capability rules */
 	if (!is_init(current)) {
 		current->cap_permitted = new_permitted;
-		current->cap_effective =
-		    cap_intersect (new_permitted, bprm->cap_effective);
+		current->cap_effective = bprm->cap_effective ?
+				new_permitted : 0;
 	}
 
 	/* AUD: Audit candidate if current->cap_effective is set */
@@ -181,11 +300,15 @@ void cap_bprm_apply_creds (struct linux_
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
 {
-	/* If/when this module is enhanced to incorporate capability
-	   bits on files, the test below should be extended to also perform a 
-	   test between the old and new capability sets.  For now,
-	   it simply preserves the legacy decision algorithm used by
-	   the old userland. */
+	if (current->uid != 0) {
+		if (bprm->cap_effective)
+			return 1;
+		if (!cap_isclear(bprm->cap_permitted))
+			return 1;
+		if (!cap_isclear(bprm->cap_inheritable))
+			return 1;
+	}
+
 	return (current->euid != current->uid ||
 		current->egid != current->gid);
 }
@@ -193,7 +316,11 @@ int cap_bprm_secureexec (struct linux_bi
 int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
 		       size_t size, int flags)
 {
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (!capable(CAP_SETFCAP))
+			return -EPERM;
+		return 0;
+	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -202,7 +329,11 @@ int cap_inode_setxattr(struct dentry *de
 
 int cap_inode_removexattr(struct dentry *dentry, char *name)
 {
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (!capable(CAP_SETFCAP))
+			return -EPERM;
+		return 0;
+	} else if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1)  &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -299,6 +430,83 @@ int cap_task_post_setuid (uid_t old_ruid
 	return 0;
 }
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+/*
+ * Rationale: code calling task_setscheduler, task_setioprio, and
+ * task_setnice, assumes that
+ *   . if capable(cap_sys_nice), then those actions should be allowed
+ *   . if not capable(cap_sys_nice), but acting on your own processes,
+ *   	then those actions should be allowed
+ * This is insufficient now since you can call code without suid, but
+ * yet with increased caps.
+ * So we check for increased caps on the target process.
+ */
+static inline int cap_safe_nice(struct task_struct *p)
+{
+	if (!cap_issubset(p->cap_permitted, current->cap_permitted) &&
+	    !__capable(current, CAP_SYS_NICE))
+		return -EPERM;
+	return 0;
+}
+
+int cap_task_setscheduler (struct task_struct *p, int policy,
+			   struct sched_param *lp)
+{
+	return cap_safe_nice(p);
+}
+
+int cap_task_setioprio (struct task_struct *p, int ioprio)
+{
+	return cap_safe_nice(p);
+}
+
+int cap_task_setnice (struct task_struct *p, int nice)
+{
+	return cap_safe_nice(p);
+}
+
+int cap_task_kill(struct task_struct *p, struct siginfo *info,
+				int sig, u32 secid)
+{
+	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
+		return 0;
+
+	if (secid)
+		/*
+		 * Signal sent as a particular user.
+		 * Capabilities are ignored.  May be wrong, but it's the
+		 * only thing we can do at the moment.
+		 * Used only by usb drivers?
+		 */
+		return 0;
+	if (cap_issubset(p->cap_permitted, current->cap_permitted))
+		return 0;
+	if (capable(CAP_KILL))
+		return 0;
+
+	return -EPERM;
+}
+#else
+int cap_task_setscheduler (struct task_struct *p, int policy,
+			   struct sched_param *lp)
+{
+	return 0;
+}
+int cap_task_setioprio (struct task_struct *p, int ioprio)
+{
+	return 0;
+}
+int cap_task_setnice (struct task_struct *p, int nice)
+{
+	return 0;
+}
+int cap_task_kill(struct task_struct *p, struct siginfo *info,
+				int sig, u32 secid)
+{
+	return 0;
+}
+#endif
+
 void cap_task_reparent_to_init (struct task_struct *p)
 {
 	p->cap_effective = CAP_INIT_EFF_SET;
@@ -336,6 +544,10 @@ EXPORT_SYMBOL(cap_bprm_secureexec);
 EXPORT_SYMBOL(cap_inode_setxattr);
 EXPORT_SYMBOL(cap_inode_removexattr);
 EXPORT_SYMBOL(cap_task_post_setuid);
+EXPORT_SYMBOL(cap_task_kill);
+EXPORT_SYMBOL(cap_task_setscheduler);
+EXPORT_SYMBOL(cap_task_setioprio);
+EXPORT_SYMBOL(cap_task_setnice);
 EXPORT_SYMBOL(cap_task_reparent_to_init);
 EXPORT_SYMBOL(cap_syslog);
 EXPORT_SYMBOL(cap_vm_enough_memory);
diff -puN security/dummy.c~implement-file-posix-capabilities security/dummy.c
--- a/security/dummy.c~implement-file-posix-capabilities
+++ a/security/dummy.c
@@ -376,6 +376,16 @@ static int dummy_inode_removexattr (stru
 	return 0;
 }
 
+static int dummy_inode_need_killpriv(struct dentry *dentry)
+{
+	return 0;
+}
+
+static int dummy_inode_killpriv(struct dentry *dentry)
+{
+	return 0;
+}
+
 static int dummy_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
 {
 	return -EOPNOTSUPP;
@@ -1022,6 +1032,8 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, inode_getxattr);
 	set_to_dummy_if_null(ops, inode_listxattr);
 	set_to_dummy_if_null(ops, inode_removexattr);
+	set_to_dummy_if_null(ops, inode_need_killpriv);
+	set_to_dummy_if_null(ops, inode_killpriv);
 	set_to_dummy_if_null(ops, inode_xattr_getsuffix);
 	set_to_dummy_if_null(ops, inode_getsecurity);
 	set_to_dummy_if_null(ops, inode_setsecurity);
diff -puN security/security.c~implement-file-posix-capabilities security/security.c
--- a/security/security.c~implement-file-posix-capabilities
+++ a/security/security.c
@@ -518,6 +518,16 @@ int security_inode_removexattr(struct de
 	return security_ops->inode_removexattr(dentry, name);
 }
 
+int security_inode_need_killpriv(struct dentry *dentry)
+{
+	return security_ops->inode_need_killpriv(dentry);
+}
+
+int security_inode_killpriv(struct dentry *dentry)
+{
+	return security_ops->inode_killpriv(dentry);
+}
+
 const char *security_inode_xattr_getsuffix(void)
 {
 	return security_ops->inode_xattr_getsuffix();
diff -puN security/selinux/hooks.c~implement-file-posix-capabilities security/selinux/hooks.c
--- a/security/selinux/hooks.c~implement-file-posix-capabilities
+++ a/security/selinux/hooks.c
@@ -2297,6 +2297,25 @@ static int selinux_inode_getattr(struct 
 	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
 }
 
+static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
+{
+	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+		     sizeof XATTR_SECURITY_PREFIX - 1)) {
+		if (!strcmp(name, XATTR_NAME_CAPS)) {
+			if (!capable(CAP_SETFCAP))
+				return -EPERM;
+		} else if (!capable(CAP_SYS_ADMIN)) {
+			/* A different attribute in the security namespace.
+			   Restrict to administrator. */
+			return -EPERM;
+		}
+	}
+
+	/* Not an attribute we recognize, so just check the
+	   ordinary setattr permission. */
+	return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
+}
+
 static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
 {
 	struct task_security_struct *tsec = current->security;
@@ -2307,19 +2326,8 @@ static int selinux_inode_setxattr(struct
 	u32 newsid;
 	int rc = 0;
 
-	if (strcmp(name, XATTR_NAME_SELINUX)) {
-		if (!strncmp(name, XATTR_SECURITY_PREFIX,
-			     sizeof XATTR_SECURITY_PREFIX - 1) &&
-		    !capable(CAP_SYS_ADMIN)) {
-			/* A different attribute in the security namespace.
-			   Restrict to administrator. */
-			return -EPERM;
-		}
-
-		/* Not an attribute we recognize, so just check the
-		   ordinary setattr permission. */
-		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
-	}
+	if (strcmp(name, XATTR_NAME_SELINUX))
+		return selinux_inode_setotherxattr(dentry, name);
 
 	sbsec = inode->i_sb->s_security;
 	if (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)
@@ -2393,20 +2401,8 @@ static int selinux_inode_listxattr (stru
 
 static int selinux_inode_removexattr (struct dentry *dentry, char *name)
 {
-	if (strcmp(name, XATTR_NAME_SELINUX)) {
-		if (!strncmp(name, XATTR_SECURITY_PREFIX,
-			     sizeof XATTR_SECURITY_PREFIX - 1) &&
-		    !capable(CAP_SYS_ADMIN)) {
-			/* A different attribute in the security namespace.
-			   Restrict to administrator. */
-			return -EPERM;
-		}
-
-		/* Not an attribute we recognize, so just check the
-		   ordinary setattr permission. Might want a separate
-		   permission for removexattr. */
-		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
-	}
+	if (strcmp(name, XATTR_NAME_SELINUX))
+		return selinux_inode_setotherxattr(dentry, name);
 
 	/* No one is allowed to remove a SELinux security label.
 	   You can change the label, but all data must be labeled. */
@@ -2464,6 +2460,16 @@ static int selinux_inode_listsecurity(st
 	return len;
 }
 
+static int selinux_inode_need_killpriv(struct dentry *dentry)
+{
+	return secondary_ops->inode_need_killpriv(dentry);
+}
+
+static int selinux_inode_killpriv(struct dentry *dentry)
+{
+	return secondary_ops->inode_killpriv(dentry);
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -2882,6 +2888,12 @@ static int selinux_task_setnice(struct t
 
 static int selinux_task_setioprio(struct task_struct *p, int ioprio)
 {
+	int rc;
+
+	rc = secondary_ops->task_setioprio(p, ioprio);
+	if (rc)
+		return rc;
+
 	return task_has_perm(current, p, PROCESS__SETSCHED);
 }
 
@@ -2911,6 +2923,12 @@ static int selinux_task_setrlimit(unsign
 
 static int selinux_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp)
 {
+	int rc;
+
+	rc = secondary_ops->task_setscheduler(p, policy, lp);
+	if (rc)
+		return rc;
+
 	return task_has_perm(current, p, PROCESS__SETSCHED);
 }
 
@@ -4830,6 +4848,8 @@ static struct security_operations selinu
 	.inode_getsecurity =            selinux_inode_getsecurity,
 	.inode_setsecurity =            selinux_inode_setsecurity,
 	.inode_listsecurity =           selinux_inode_listsecurity,
+	.inode_need_killpriv =		selinux_inode_need_killpriv,
+	.inode_killpriv =		selinux_inode_killpriv,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
capabilities-clean-up-file-capability-reading.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
v3-file-capabilities-alter-behavior-of-cap_setpcap.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
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
