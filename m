From: akpm@linux-foundation.org
Subject: - file-capabilities-clear-fcaps-on-inode-change.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:37:54 -0700
Message-ID: <200710170137.l9H1bsPH027961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467AbXJQBjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:39:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, morgan@kernel.org, sds@tycho.nsa.gov, trond.myklebust@fys.uio.no, mm-commits@vge


The patch titled
     file capabilities: clear fcaps on inode change
has been removed from the -mm tree.  Its filename was
     file-capabilities-clear-fcaps-on-inode-change.patch

This patch was dropped because it was folded into implement-file-posix-capabilities.patch

------------------------------------------------------
Subject: file capabilities: clear fcaps on inode change
From: Serge E. Hallyn <serue@us.ibm.com>

When a file with posix capabilities is overwritten, the file capabilities,
like a setuid bit, should be removed.

This patch introduces security_inode_killpriv().  This is currently only
defined for capability, and is called when an inode is changed to inform
the security module that it may want to clear out any privilege attached to
that inode.  The capability module checks whether any file capabilities are
defined for the inode, and, if so, clears them.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Acked-by: James Morris <jmorris@namei.org>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/attr.c                |    9 +++++++++
 fs/nfsd/vfs.c            |    4 ++--
 fs/open.c                |    3 ++-
 fs/splice.c              |   13 +++++++++----
 include/linux/fs.h       |    1 +
 include/linux/security.h |   28 ++++++++++++++++++++++++++++
 mm/filemap.c             |   16 +++++++++++-----
 security/capability.c    |    2 ++
 security/commoncap.c     |   35 +++++++++++++++++++++++++++++++++++
 security/dummy.c         |   12 ++++++++++++
 security/security.c      |   10 ++++++++++
 security/selinux/hooks.c |   12 ++++++++++++
 12 files changed, 133 insertions(+), 12 deletions(-)

diff -puN fs/attr.c~file-capabilities-clear-fcaps-on-inode-change fs/attr.c
--- a/fs/attr.c~file-capabilities-clear-fcaps-on-inode-change
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
diff -puN fs/nfsd/vfs.c~file-capabilities-clear-fcaps-on-inode-change fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~file-capabilities-clear-fcaps-on-inode-change
+++ a/fs/nfsd/vfs.c
@@ -368,7 +368,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 
 	/* Revoke setuid/setgid bit on chown/chgrp */
 	if ((iap->ia_valid & ATTR_UID) && iap->ia_uid != inode->i_uid)
-		iap->ia_valid |= ATTR_KILL_SUID;
+		iap->ia_valid |= ATTR_KILL_SUID | ATTR_KILL_PRIV;
 	if ((iap->ia_valid & ATTR_GID) && iap->ia_gid != inode->i_gid)
 		iap->ia_valid |= ATTR_KILL_SGID;
 
@@ -930,7 +930,7 @@ out:
 static void kill_suid(struct dentry *dentry)
 {
 	struct iattr	ia;
-	ia.ia_valid = ATTR_KILL_SUID | ATTR_KILL_SGID;
+	ia.ia_valid = ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	notify_change(dentry, &ia);
diff -puN fs/open.c~file-capabilities-clear-fcaps-on-inode-change fs/open.c
--- a/fs/open.c~file-capabilities-clear-fcaps-on-inode-change
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
diff -puN fs/splice.c~file-capabilities-clear-fcaps-on-inode-change fs/splice.c
--- a/fs/splice.c~file-capabilities-clear-fcaps-on-inode-change
+++ a/fs/splice.c
@@ -831,13 +831,18 @@ generic_file_splice_write(struct pipe_in
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
diff -puN include/linux/fs.h~file-capabilities-clear-fcaps-on-inode-change include/linux/fs.h
--- a/include/linux/fs.h~file-capabilities-clear-fcaps-on-inode-change
+++ a/include/linux/fs.h
@@ -330,6 +330,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_KILL_SUID	2048
 #define ATTR_KILL_SGID	4096
 #define ATTR_FILE	8192
+#define ATTR_KILL_PRIV	16384
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
diff -puN include/linux/security.h~file-capabilities-clear-fcaps-on-inode-change include/linux/security.h
--- a/include/linux/security.h~file-capabilities-clear-fcaps-on-inode-change
+++ a/include/linux/security.h
@@ -51,6 +51,8 @@ extern void cap_bprm_apply_creds (struct
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
 extern int cap_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags);
 extern int cap_inode_removexattr(struct dentry *dentry, char *name);
+extern int cap_inode_need_killpriv(struct dentry *dentry);
+extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
 extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
@@ -417,6 +419,18 @@ struct request_sock;
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
@@ -1243,6 +1257,8 @@ struct security_operations {
 	int (*inode_getxattr) (struct dentry *dentry, char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
+	int (*inode_need_killpriv) (struct dentry *dentry);
+	int (*inode_killpriv) (struct dentry *dentry);
 	const char *(*inode_xattr_getsuffix) (void);
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
@@ -1500,6 +1516,8 @@ void security_inode_post_setxattr(struct
 int security_inode_getxattr(struct dentry *dentry, char *name);
 int security_inode_listxattr(struct dentry *dentry);
 int security_inode_removexattr(struct dentry *dentry, char *name);
+int security_inode_need_killpriv(struct dentry *dentry);
+int security_inode_killpriv(struct dentry *dentry);
 const char *security_inode_xattr_getsuffix(void);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
@@ -1895,6 +1913,16 @@ static inline int security_inode_removex
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
diff -puN mm/filemap.c~file-capabilities-clear-fcaps-on-inode-change mm/filemap.c
--- a/mm/filemap.c~file-capabilities-clear-fcaps-on-inode-change
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
 
diff -puN security/capability.c~file-capabilities-clear-fcaps-on-inode-change security/capability.c
--- a/security/capability.c~file-capabilities-clear-fcaps-on-inode-change
+++ a/security/capability.c
@@ -37,6 +37,8 @@ static struct security_operations capabi
 
 	.inode_setxattr =		cap_inode_setxattr,
 	.inode_removexattr =		cap_inode_removexattr,
+	.inode_need_killpriv =		cap_inode_need_killpriv,
+	.inode_killpriv =		cap_inode_killpriv,
 
 	.task_kill =			cap_task_kill,
 	.task_setscheduler =		cap_task_setscheduler,
diff -puN security/commoncap.c~file-capabilities-clear-fcaps-on-inode-change security/commoncap.c
--- a/security/commoncap.c~file-capabilities-clear-fcaps-on-inode-change
+++ a/security/commoncap.c
@@ -118,6 +118,30 @@ static inline void bprm_clear_caps(struc
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
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
 static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
 				int size)
 {
@@ -184,6 +208,16 @@ out:
 }
 
 #else
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
 static inline int get_file_caps(struct linux_binprm *bprm)
 {
 	bprm_clear_caps(bprm);
@@ -508,6 +542,7 @@ EXPORT_SYMBOL(cap_bprm_apply_creds);
 EXPORT_SYMBOL(cap_bprm_secureexec);
 EXPORT_SYMBOL(cap_inode_setxattr);
 EXPORT_SYMBOL(cap_inode_removexattr);
+EXPORT_SYMBOL(cap_inode_killpriv);
 EXPORT_SYMBOL(cap_task_post_setuid);
 EXPORT_SYMBOL(cap_task_kill);
 EXPORT_SYMBOL(cap_task_setscheduler);
diff -puN security/dummy.c~file-capabilities-clear-fcaps-on-inode-change security/dummy.c
--- a/security/dummy.c~file-capabilities-clear-fcaps-on-inode-change
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
diff -puN security/security.c~file-capabilities-clear-fcaps-on-inode-change security/security.c
--- a/security/security.c~file-capabilities-clear-fcaps-on-inode-change
+++ a/security/security.c
@@ -519,6 +519,16 @@ int security_inode_removexattr(struct de
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
diff -puN security/selinux/hooks.c~file-capabilities-clear-fcaps-on-inode-change security/selinux/hooks.c
--- a/security/selinux/hooks.c~file-capabilities-clear-fcaps-on-inode-change
+++ a/security/selinux/hooks.c
@@ -2460,6 +2460,16 @@ static int selinux_inode_listsecurity(st
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
@@ -4839,6 +4849,8 @@ static struct security_operations selinu
 	.inode_getsecurity =            selinux_inode_getsecurity,
 	.inode_setsecurity =            selinux_inode_setsecurity,
 	.inode_listsecurity =           selinux_inode_listsecurity,
+	.inode_need_killpriv =		selinux_inode_need_killpriv,
+	.inode_killpriv =		selinux_inode_killpriv,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,
_

Patches currently in -mm which might be from serue@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
security-convert-lsm-into-a-static-interface.patch
implement-file-posix-capabilities.patch
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
