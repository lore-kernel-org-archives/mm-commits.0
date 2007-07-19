From: akpm@linux-foundation.org
Subject: + security-convert-lsm-into-a-static-interface.patch added to -mm tree
Date: Wed, 18 Jul 2007 18:35:10 -0700
Message-ID: <200707190135.l6J1ZAlZ007350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934878AbXGSBfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 21:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmorris@namei.org, arjan@infradead.org, chrisw@sous-sol.org, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     security: Convert LSM into a static interface
has been added to the -mm tree.  Its filename is
     security-convert-lsm-into-a-static-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: security: Convert LSM into a static interface
From: James Morris <jmorris@namei.org>

Convert LSM into a static interface, as the ability to unload a security
module is not required by in-tree users and potentially complicates the
overall security architecture.

Needlessly exported LSM symbols have been unexported, to help reduce API
abuse.

Parameters for the capability and root_plug modules are now specified
at boot.

The SECURITY_FRAMEWORK_VERSION macro has also been removed.

Signed-off-by: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Acked-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   17 
 include/linux/security.h            | 1177 ++++----------------------
 security/Kconfig                    |    4 
 security/capability.c               |   24 
 security/commoncap.c                |    3 
 security/dummy.c                    |    1 
 security/root_plug.c                |   31 
 security/security.c                 |  955 ++++++++++++++++++++-
 security/selinux/hooks.c            |    2 
 security/selinux/xfrm.c             |    1 
 10 files changed, 1171 insertions(+), 1044 deletions(-)

diff -puN Documentation/kernel-parameters.txt~security-convert-lsm-into-a-static-interface Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~security-convert-lsm-into-a-static-interface
+++ a/Documentation/kernel-parameters.txt
@@ -73,10 +73,12 @@ parameter is applicable:
 	PPT	Parallel port support is enabled.
 	PS2	Appropriate PS/2 support is enabled.
 	RAM	RAM disk support is enabled.
+	ROOTPLUG The example Root Plug LSM is enabled.
 	S390	S390 architecture is enabled.
 	SCSI	Appropriate SCSI support is enabled.
 			A lot of drivers has their options described inside of
 			Documentation/scsi/.
+	SECURITY Different security models are enabled.
 	SELINUX SELinux support is enabled.
 	SERIAL	Serial support is enabled.
 	SH	SuperH architecture is enabled.
@@ -365,6 +367,12 @@ and is between 256 and 4096 characters. 
 			possible to determine what the correct size should be.
 			This option provides an override for these situations.
 
+	capability.disable=
+			[SECURITY] Disable capabilities.  This would normally
+			be used only if an alternative security model is to be
+			configured.  Potentially dangerous and should only be
+			used if you are entirely sure of the consequences.
+
 	chandev=	[HW,NET] Generic channel device initialisation
 
 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
@@ -1529,6 +1537,15 @@ and is between 256 and 4096 characters. 
 			Useful for devices that are detected asynchronously
 			(e.g. USB and MMC devices).
 
+	root_plug.vendor_id=
+			[ROOTPLUG] Override the default vendor ID
+
+	root_plug.product_id=
+			[ROOTPLUG] Override the default product ID
+
+	root_plug.debug=
+			[ROOTPLUG] Enable debugging output
+
 	rw		[KNL] Mount root device read-write on boot
 
 	S		[KNL] Run init in single mode
diff -puN include/linux/security.h~security-convert-lsm-into-a-static-interface include/linux/security.h
--- a/include/linux/security.h~security-convert-lsm-into-a-static-interface
+++ a/include/linux/security.h
@@ -1400,733 +1400,6 @@ struct security_operations {
 
 };
 
-/* global variables */
-extern struct security_operations *security_ops;
-
-/* inline stuff */
-static inline int security_ptrace (struct task_struct * parent, struct task_struct * child)
-{
-	return security_ops->ptrace (parent, child);
-}
-
-static inline int security_capget (struct task_struct *target,
-				   kernel_cap_t *effective,
-				   kernel_cap_t *inheritable,
-				   kernel_cap_t *permitted)
-{
-	return security_ops->capget (target, effective, inheritable, permitted);
-}
-
-static inline int security_capset_check (struct task_struct *target,
-					 kernel_cap_t *effective,
-					 kernel_cap_t *inheritable,
-					 kernel_cap_t *permitted)
-{
-	return security_ops->capset_check (target, effective, inheritable, permitted);
-}
-
-static inline void security_capset_set (struct task_struct *target,
-					kernel_cap_t *effective,
-					kernel_cap_t *inheritable,
-					kernel_cap_t *permitted)
-{
-	security_ops->capset_set (target, effective, inheritable, permitted);
-}
-
-static inline int security_capable(struct task_struct *tsk, int cap)
-{
-	return security_ops->capable(tsk, cap);
-}
-
-static inline int security_acct (struct file *file)
-{
-	return security_ops->acct (file);
-}
-
-static inline int security_sysctl(struct ctl_table *table, int op)
-{
-	return security_ops->sysctl(table, op);
-}
-
-static inline int security_quotactl (int cmds, int type, int id,
-				     struct super_block *sb)
-{
-	return security_ops->quotactl (cmds, type, id, sb);
-}
-
-static inline int security_quota_on (struct dentry * dentry)
-{
-	return security_ops->quota_on (dentry);
-}
-
-static inline int security_syslog(int type)
-{
-	return security_ops->syslog(type);
-}
-
-static inline int security_settime(struct timespec *ts, struct timezone *tz)
-{
-	return security_ops->settime(ts, tz);
-}
-
-
-static inline int security_vm_enough_memory(long pages)
-{
-	return security_ops->vm_enough_memory(pages);
-}
-
-static inline int security_bprm_alloc (struct linux_binprm *bprm)
-{
-	return security_ops->bprm_alloc_security (bprm);
-}
-static inline void security_bprm_free (struct linux_binprm *bprm)
-{
-	security_ops->bprm_free_security (bprm);
-}
-static inline void security_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
-{
-	security_ops->bprm_apply_creds (bprm, unsafe);
-}
-static inline void security_bprm_post_apply_creds (struct linux_binprm *bprm)
-{
-	security_ops->bprm_post_apply_creds (bprm);
-}
-static inline int security_bprm_set (struct linux_binprm *bprm)
-{
-	return security_ops->bprm_set_security (bprm);
-}
-
-static inline int security_bprm_check (struct linux_binprm *bprm)
-{
-	return security_ops->bprm_check_security (bprm);
-}
-
-static inline int security_bprm_secureexec (struct linux_binprm *bprm)
-{
-	return security_ops->bprm_secureexec (bprm);
-}
-
-static inline int security_sb_alloc (struct super_block *sb)
-{
-	return security_ops->sb_alloc_security (sb);
-}
-
-static inline void security_sb_free (struct super_block *sb)
-{
-	security_ops->sb_free_security (sb);
-}
-
-static inline int security_sb_copy_data (struct file_system_type *type,
-					 void *orig, void *copy)
-{
-	return security_ops->sb_copy_data (type, orig, copy);
-}
-
-static inline int security_sb_kern_mount (struct super_block *sb, void *data)
-{
-	return security_ops->sb_kern_mount (sb, data);
-}
-
-static inline int security_sb_statfs (struct dentry *dentry)
-{
-	return security_ops->sb_statfs (dentry);
-}
-
-static inline int security_sb_mount (char *dev_name, struct nameidata *nd,
-				    char *type, unsigned long flags,
-				    void *data)
-{
-	return security_ops->sb_mount (dev_name, nd, type, flags, data);
-}
-
-static inline int security_sb_check_sb (struct vfsmount *mnt,
-					struct nameidata *nd)
-{
-	return security_ops->sb_check_sb (mnt, nd);
-}
-
-static inline int security_sb_umount (struct vfsmount *mnt, int flags)
-{
-	return security_ops->sb_umount (mnt, flags);
-}
-
-static inline void security_sb_umount_close (struct vfsmount *mnt)
-{
-	security_ops->sb_umount_close (mnt);
-}
-
-static inline void security_sb_umount_busy (struct vfsmount *mnt)
-{
-	security_ops->sb_umount_busy (mnt);
-}
-
-static inline void security_sb_post_remount (struct vfsmount *mnt,
-					     unsigned long flags, void *data)
-{
-	security_ops->sb_post_remount (mnt, flags, data);
-}
-
-static inline void security_sb_post_mountroot (void)
-{
-	security_ops->sb_post_mountroot ();
-}
-
-static inline void security_sb_post_addmount (struct vfsmount *mnt,
-					      struct nameidata *mountpoint_nd)
-{
-	security_ops->sb_post_addmount (mnt, mountpoint_nd);
-}
-
-static inline int security_sb_pivotroot (struct nameidata *old_nd,
-					 struct nameidata *new_nd)
-{
-	return security_ops->sb_pivotroot (old_nd, new_nd);
-}
-
-static inline void security_sb_post_pivotroot (struct nameidata *old_nd,
-					       struct nameidata *new_nd)
-{
-	security_ops->sb_post_pivotroot (old_nd, new_nd);
-}
-
-static inline int security_inode_alloc (struct inode *inode)
-{
-	inode->i_security = NULL;
-	return security_ops->inode_alloc_security (inode);
-}
-
-static inline void security_inode_free (struct inode *inode)
-{
-	security_ops->inode_free_security (inode);
-}
-
-static inline int security_inode_init_security (struct inode *inode,
-						struct inode *dir,
-						char **name,
-						void **value,
-						size_t *len)
-{
-	if (unlikely (IS_PRIVATE (inode)))
-		return -EOPNOTSUPP;
-	return security_ops->inode_init_security (inode, dir, name, value, len);
-}
-	
-static inline int security_inode_create (struct inode *dir,
-					 struct dentry *dentry,
-					 int mode)
-{
-	if (unlikely (IS_PRIVATE (dir)))
-		return 0;
-	return security_ops->inode_create (dir, dentry, mode);
-}
-
-static inline int security_inode_link (struct dentry *old_dentry,
-				       struct inode *dir,
-				       struct dentry *new_dentry)
-{
-	if (unlikely (IS_PRIVATE (old_dentry->d_inode)))
-		return 0;
-	return security_ops->inode_link (old_dentry, dir, new_dentry);
-}
-
-static inline int security_inode_unlink (struct inode *dir,
-					 struct dentry *dentry)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return 0;
-	return security_ops->inode_unlink (dir, dentry);
-}
-
-static inline int security_inode_symlink (struct inode *dir,
-					  struct dentry *dentry,
-					  const char *old_name)
-{
-	if (unlikely (IS_PRIVATE (dir)))
-		return 0;
-	return security_ops->inode_symlink (dir, dentry, old_name);
-}
-
-static inline int security_inode_mkdir (struct inode *dir,
-					struct dentry *dentry,
-					int mode)
-{
-	if (unlikely (IS_PRIVATE (dir)))
-		return 0;
-	return security_ops->inode_mkdir (dir, dentry, mode);
-}
-
-static inline int security_inode_rmdir (struct inode *dir,
-					struct dentry *dentry)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return 0;
-	return security_ops->inode_rmdir (dir, dentry);
-}
-
-static inline int security_inode_mknod (struct inode *dir,
-					struct dentry *dentry,
-					int mode, dev_t dev)
-{
-	if (unlikely (IS_PRIVATE (dir)))
-		return 0;
-	return security_ops->inode_mknod (dir, dentry, mode, dev);
-}
-
-static inline int security_inode_rename (struct inode *old_dir,
-					 struct dentry *old_dentry,
-					 struct inode *new_dir,
-					 struct dentry *new_dentry)
-{
-        if (unlikely (IS_PRIVATE (old_dentry->d_inode) ||
-            (new_dentry->d_inode && IS_PRIVATE (new_dentry->d_inode))))
-		return 0;
-	return security_ops->inode_rename (old_dir, old_dentry,
-					   new_dir, new_dentry);
-}
-
-static inline int security_inode_readlink (struct dentry *dentry)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return 0;
-	return security_ops->inode_readlink (dentry);
-}
-
-static inline int security_inode_follow_link (struct dentry *dentry,
-					      struct nameidata *nd)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return 0;
-	return security_ops->inode_follow_link (dentry, nd);
-}
-
-static inline int security_inode_permission (struct inode *inode, int mask,
-					     struct nameidata *nd)
-{
-	if (unlikely (IS_PRIVATE (inode)))
-		return 0;
-	return security_ops->inode_permission (inode, mask, nd);
-}
-
-static inline int security_inode_setattr (struct dentry *dentry,
-					  struct iattr *attr)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return 0;
-	return security_ops->inode_setattr (dentry, attr);
-}
-
-static inline int security_inode_getattr (struct vfsmount *mnt,
-					  struct dentry *dentry)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return 0;
-	return security_ops->inode_getattr (mnt, dentry);
-}
-
-static inline void security_inode_delete (struct inode *inode)
-{
-	if (unlikely (IS_PRIVATE (inode)))
-		return;
-	security_ops->inode_delete (inode);
-}
-
-static inline int security_inode_setxattr (struct dentry *dentry, char *name,
-					   void *value, size_t size, int flags)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return 0;
-	return security_ops->inode_setxattr (dentry, name, value, size, flags);
-}
-
-static inline void security_inode_post_setxattr (struct dentry *dentry, char *name,
-						void *value, size_t size, int flags)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return;
-	security_ops->inode_post_setxattr (dentry, name, value, size, flags);
-}
-
-static inline int security_inode_getxattr (struct dentry *dentry, char *name)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return 0;
-	return security_ops->inode_getxattr (dentry, name);
-}
-
-static inline int security_inode_listxattr (struct dentry *dentry)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return 0;
-	return security_ops->inode_listxattr (dentry);
-}
-
-static inline int security_inode_removexattr (struct dentry *dentry, char *name)
-{
-	if (unlikely (IS_PRIVATE (dentry->d_inode)))
-		return 0;
-	return security_ops->inode_removexattr (dentry, name);
-}
-
-static inline const char *security_inode_xattr_getsuffix(void)
-{
-	return security_ops->inode_xattr_getsuffix();
-}
-
-static inline int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
-{
-	if (unlikely (IS_PRIVATE (inode)))
-		return 0;
-	return security_ops->inode_getsecurity(inode, name, buffer, size, err);
-}
-
-static inline int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
-{
-	if (unlikely (IS_PRIVATE (inode)))
-		return 0;
-	return security_ops->inode_setsecurity(inode, name, value, size, flags);
-}
-
-static inline int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
-{
-	if (unlikely (IS_PRIVATE (inode)))
-		return 0;
-	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
-}
-
-static inline int security_file_permission (struct file *file, int mask)
-{
-	return security_ops->file_permission (file, mask);
-}
-
-static inline int security_file_alloc (struct file *file)
-{
-	return security_ops->file_alloc_security (file);
-}
-
-static inline void security_file_free (struct file *file)
-{
-	security_ops->file_free_security (file);
-}
-
-static inline int security_file_ioctl (struct file *file, unsigned int cmd,
-				       unsigned long arg)
-{
-	return security_ops->file_ioctl (file, cmd, arg);
-}
-
-static inline int security_file_mmap (struct file *file, unsigned long reqprot,
-				      unsigned long prot,
-				      unsigned long flags,
-				      unsigned long addr,
-				      unsigned long addr_only)
-{
-	return security_ops->file_mmap (file, reqprot, prot, flags, addr,
-					addr_only);
-}
-
-static inline int security_file_mprotect (struct vm_area_struct *vma,
-					  unsigned long reqprot,
-					  unsigned long prot)
-{
-	return security_ops->file_mprotect (vma, reqprot, prot);
-}
-
-static inline int security_file_lock (struct file *file, unsigned int cmd)
-{
-	return security_ops->file_lock (file, cmd);
-}
-
-static inline int security_file_fcntl (struct file *file, unsigned int cmd,
-				       unsigned long arg)
-{
-	return security_ops->file_fcntl (file, cmd, arg);
-}
-
-static inline int security_file_set_fowner (struct file *file)
-{
-	return security_ops->file_set_fowner (file);
-}
-
-static inline int security_file_send_sigiotask (struct task_struct *tsk,
-						struct fown_struct *fown,
-						int sig)
-{
-	return security_ops->file_send_sigiotask (tsk, fown, sig);
-}
-
-static inline int security_file_receive (struct file *file)
-{
-	return security_ops->file_receive (file);
-}
-
-static inline int security_task_create (unsigned long clone_flags)
-{
-	return security_ops->task_create (clone_flags);
-}
-
-static inline int security_task_alloc (struct task_struct *p)
-{
-	return security_ops->task_alloc_security (p);
-}
-
-static inline void security_task_free (struct task_struct *p)
-{
-	security_ops->task_free_security (p);
-}
-
-static inline int security_task_setuid (uid_t id0, uid_t id1, uid_t id2,
-					int flags)
-{
-	return security_ops->task_setuid (id0, id1, id2, flags);
-}
-
-static inline int security_task_post_setuid (uid_t old_ruid, uid_t old_euid,
-					     uid_t old_suid, int flags)
-{
-	return security_ops->task_post_setuid (old_ruid, old_euid, old_suid, flags);
-}
-
-static inline int security_task_setgid (gid_t id0, gid_t id1, gid_t id2,
-					int flags)
-{
-	return security_ops->task_setgid (id0, id1, id2, flags);
-}
-
-static inline int security_task_setpgid (struct task_struct *p, pid_t pgid)
-{
-	return security_ops->task_setpgid (p, pgid);
-}
-
-static inline int security_task_getpgid (struct task_struct *p)
-{
-	return security_ops->task_getpgid (p);
-}
-
-static inline int security_task_getsid (struct task_struct *p)
-{
-	return security_ops->task_getsid (p);
-}
-
-static inline void security_task_getsecid (struct task_struct *p, u32 *secid)
-{
-	security_ops->task_getsecid (p, secid);
-}
-
-static inline int security_task_setgroups (struct group_info *group_info)
-{
-	return security_ops->task_setgroups (group_info);
-}
-
-static inline int security_task_setnice (struct task_struct *p, int nice)
-{
-	return security_ops->task_setnice (p, nice);
-}
-
-static inline int security_task_setioprio (struct task_struct *p, int ioprio)
-{
-	return security_ops->task_setioprio (p, ioprio);
-}
-
-static inline int security_task_getioprio (struct task_struct *p)
-{
-	return security_ops->task_getioprio (p);
-}
-
-static inline int security_task_setrlimit (unsigned int resource,
-					   struct rlimit *new_rlim)
-{
-	return security_ops->task_setrlimit (resource, new_rlim);
-}
-
-static inline int security_task_setscheduler (struct task_struct *p,
-					      int policy,
-					      struct sched_param *lp)
-{
-	return security_ops->task_setscheduler (p, policy, lp);
-}
-
-static inline int security_task_getscheduler (struct task_struct *p)
-{
-	return security_ops->task_getscheduler (p);
-}
-
-static inline int security_task_movememory (struct task_struct *p)
-{
-	return security_ops->task_movememory (p);
-}
-
-static inline int security_task_kill (struct task_struct *p,
-				      struct siginfo *info, int sig,
-				      u32 secid)
-{
-	return security_ops->task_kill (p, info, sig, secid);
-}
-
-static inline int security_task_wait (struct task_struct *p)
-{
-	return security_ops->task_wait (p);
-}
-
-static inline int security_task_prctl (int option, unsigned long arg2,
-				       unsigned long arg3,
-				       unsigned long arg4,
-				       unsigned long arg5)
-{
-	return security_ops->task_prctl (option, arg2, arg3, arg4, arg5);
-}
-
-static inline void security_task_reparent_to_init (struct task_struct *p)
-{
-	security_ops->task_reparent_to_init (p);
-}
-
-static inline void security_task_to_inode(struct task_struct *p, struct inode *inode)
-{
-	security_ops->task_to_inode(p, inode);
-}
-
-static inline int security_ipc_permission (struct kern_ipc_perm *ipcp,
-					   short flag)
-{
-	return security_ops->ipc_permission (ipcp, flag);
-}
-
-static inline int security_msg_msg_alloc (struct msg_msg * msg)
-{
-	return security_ops->msg_msg_alloc_security (msg);
-}
-
-static inline void security_msg_msg_free (struct msg_msg * msg)
-{
-	security_ops->msg_msg_free_security(msg);
-}
-
-static inline int security_msg_queue_alloc (struct msg_queue *msq)
-{
-	return security_ops->msg_queue_alloc_security (msq);
-}
-
-static inline void security_msg_queue_free (struct msg_queue *msq)
-{
-	security_ops->msg_queue_free_security (msq);
-}
-
-static inline int security_msg_queue_associate (struct msg_queue * msq, 
-						int msqflg)
-{
-	return security_ops->msg_queue_associate (msq, msqflg);
-}
-
-static inline int security_msg_queue_msgctl (struct msg_queue * msq, int cmd)
-{
-	return security_ops->msg_queue_msgctl (msq, cmd);
-}
-
-static inline int security_msg_queue_msgsnd (struct msg_queue * msq,
-					     struct msg_msg * msg, int msqflg)
-{
-	return security_ops->msg_queue_msgsnd (msq, msg, msqflg);
-}
-
-static inline int security_msg_queue_msgrcv (struct msg_queue * msq,
-					     struct msg_msg * msg,
-					     struct task_struct * target,
-					     long type, int mode)
-{
-	return security_ops->msg_queue_msgrcv (msq, msg, target, type, mode);
-}
-
-static inline int security_shm_alloc (struct shmid_kernel *shp)
-{
-	return security_ops->shm_alloc_security (shp);
-}
-
-static inline void security_shm_free (struct shmid_kernel *shp)
-{
-	security_ops->shm_free_security (shp);
-}
-
-static inline int security_shm_associate (struct shmid_kernel * shp, 
-					  int shmflg)
-{
-	return security_ops->shm_associate(shp, shmflg);
-}
-
-static inline int security_shm_shmctl (struct shmid_kernel * shp, int cmd)
-{
-	return security_ops->shm_shmctl (shp, cmd);
-}
-
-static inline int security_shm_shmat (struct shmid_kernel * shp, 
-				      char __user *shmaddr, int shmflg)
-{
-	return security_ops->shm_shmat(shp, shmaddr, shmflg);
-}
-
-static inline int security_sem_alloc (struct sem_array *sma)
-{
-	return security_ops->sem_alloc_security (sma);
-}
-
-static inline void security_sem_free (struct sem_array *sma)
-{
-	security_ops->sem_free_security (sma);
-}
-
-static inline int security_sem_associate (struct sem_array * sma, int semflg)
-{
-	return security_ops->sem_associate (sma, semflg);
-}
-
-static inline int security_sem_semctl (struct sem_array * sma, int cmd)
-{
-	return security_ops->sem_semctl(sma, cmd);
-}
-
-static inline int security_sem_semop (struct sem_array * sma, 
-				      struct sembuf * sops, unsigned nsops, 
-				      int alter)
-{
-	return security_ops->sem_semop(sma, sops, nsops, alter);
-}
-
-static inline void security_d_instantiate (struct dentry *dentry, struct inode *inode)
-{
-	if (unlikely (inode && IS_PRIVATE (inode)))
-		return;
-	security_ops->d_instantiate (dentry, inode);
-}
-
-static inline int security_getprocattr(struct task_struct *p, char *name, char **value)
-{
-	return security_ops->getprocattr(p, name, value);
-}
-
-static inline int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size)
-{
-	return security_ops->setprocattr(p, name, value, size);
-}
-
-static inline int security_netlink_send(struct sock *sk, struct sk_buff * skb)
-{
-	return security_ops->netlink_send(sk, skb);
-}
-
-static inline int security_netlink_recv(struct sk_buff * skb, int cap)
-{
-	return security_ops->netlink_recv(skb, cap);
-}
-
-static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
-{
-	return security_ops->secid_to_secctx(secid, secdata, seclen);
-}
-
-static inline void security_release_secctx(char *secdata, u32 seclen)
-{
-	return security_ops->release_secctx(secdata, seclen);
-}
-
 /* prototypes */
 extern int security_init	(void);
 extern int register_security	(struct security_operations *ops);
@@ -2140,6 +1413,155 @@ extern struct dentry *securityfs_create_
 extern void securityfs_remove(struct dentry *dentry);
 
 
+/* Security operations */
+int security_ptrace (struct task_struct * parent, struct task_struct * child);
+int security_capget (struct task_struct *target,
+		     kernel_cap_t *effective,
+		     kernel_cap_t *inheritable,
+		     kernel_cap_t *permitted);
+int security_capset_check (struct task_struct *target,
+			   kernel_cap_t *effective,
+			   kernel_cap_t *inheritable,
+			   kernel_cap_t *permitted);
+void security_capset_set (struct task_struct *target,
+			  kernel_cap_t *effective,
+			  kernel_cap_t *inheritable,
+			  kernel_cap_t *permitted);
+int security_capable(struct task_struct *tsk, int cap);
+int security_acct (struct file *file);
+int security_sysctl(struct ctl_table *table, int op);
+int security_quotactl (int cmds, int type, int id, struct super_block *sb);
+int security_quota_on (struct dentry * dentry);
+int security_syslog(int type);
+int security_settime(struct timespec *ts, struct timezone *tz);
+int security_vm_enough_memory(long pages);
+int security_bprm_alloc (struct linux_binprm *bprm);
+void security_bprm_free (struct linux_binprm *bprm);
+void security_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
+void security_bprm_post_apply_creds (struct linux_binprm *bprm);
+int security_bprm_set (struct linux_binprm *bprm);
+int security_bprm_check (struct linux_binprm *bprm);
+int security_bprm_secureexec (struct linux_binprm *bprm);
+int security_sb_alloc (struct super_block *sb);
+void security_sb_free (struct super_block *sb);
+int security_sb_copy_data (struct file_system_type *type, void *orig, void *copy);
+int security_sb_kern_mount (struct super_block *sb, void *data);
+int security_sb_statfs (struct dentry *dentry);
+int security_sb_mount (char *dev_name, struct nameidata *nd,
+                       char *type, unsigned long flags, void *data);
+int security_sb_check_sb (struct vfsmount *mnt, struct nameidata *nd);
+int security_sb_umount (struct vfsmount *mnt, int flags);
+void security_sb_umount_close (struct vfsmount *mnt);
+void security_sb_umount_busy (struct vfsmount *mnt);
+void security_sb_post_remount (struct vfsmount *mnt, unsigned long flags, void *data);
+void security_sb_post_mountroot (void);
+void security_sb_post_addmount (struct vfsmount *mnt, struct nameidata *mountpoint_nd);
+int security_sb_pivotroot (struct nameidata *old_nd, struct nameidata *new_nd);
+void security_sb_post_pivotroot (struct nameidata *old_nd, struct nameidata *new_nd);
+int security_inode_alloc (struct inode *inode);
+void security_inode_free (struct inode *inode);
+int security_inode_init_security (struct inode *inode, struct inode *dir,
+				  char **name, void **value, size_t *len);
+int security_inode_create (struct inode *dir, struct dentry *dentry, int mode);
+int security_inode_link (struct dentry *old_dentry, struct inode *dir,
+			 struct dentry *new_dentry);
+int security_inode_unlink (struct inode *dir, struct dentry *dentry);
+int security_inode_symlink (struct inode *dir, struct dentry *dentry,
+			    const char *old_name);
+int security_inode_mkdir (struct inode *dir, struct dentry *dentry, int mode);
+int security_inode_rmdir (struct inode *dir, struct dentry *dentry);
+int security_inode_mknod (struct inode *dir, struct dentry *dentry, int mode, dev_t dev);
+int security_inode_rename (struct inode *old_dir, struct dentry *old_dentry,
+			   struct inode *new_dir, struct dentry *new_dentry);
+int security_inode_readlink (struct dentry *dentry);
+int security_inode_follow_link (struct dentry *dentry, struct nameidata *nd);
+int security_inode_permission (struct inode *inode, int mask, struct nameidata *nd);
+int security_inode_setattr (struct dentry *dentry, struct iattr *attr);
+int security_inode_getattr (struct vfsmount *mnt, struct dentry *dentry);
+void security_inode_delete (struct inode *inode);
+int security_inode_setxattr (struct dentry *dentry, char *name,
+			     void *value, size_t size, int flags);
+void security_inode_post_setxattr (struct dentry *dentry, char *name,
+				   void *value, size_t size, int flags);
+int security_inode_getxattr (struct dentry *dentry, char *name);
+int security_inode_listxattr (struct dentry *dentry);
+int security_inode_removexattr (struct dentry *dentry, char *name);
+const char *security_inode_xattr_getsuffix(void);
+int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
+int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
+int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
+int security_file_permission (struct file *file, int mask);
+int security_file_alloc (struct file *file);
+void security_file_free (struct file *file);
+int security_file_ioctl (struct file *file, unsigned int cmd, unsigned long arg);
+int security_file_mmap (struct file *file, unsigned long reqprot,
+			unsigned long prot, unsigned long flags,
+			unsigned long addr, unsigned long addr_only);
+int security_file_mprotect (struct vm_area_struct *vma, unsigned long reqprot,
+			    unsigned long prot);
+int security_file_lock (struct file *file, unsigned int cmd);
+int security_file_fcntl (struct file *file, unsigned int cmd, unsigned long arg);
+int security_file_set_fowner (struct file *file);
+int security_file_send_sigiotask (struct task_struct *tsk,
+				  struct fown_struct *fown, int sig);
+int security_file_receive (struct file *file);
+int security_task_create (unsigned long clone_flags);
+int security_task_alloc (struct task_struct *p);
+void security_task_free (struct task_struct *p);
+int security_task_setuid (uid_t id0, uid_t id1, uid_t id2, int flags);
+int security_task_post_setuid (uid_t old_ruid, uid_t old_euid,
+			       uid_t old_suid, int flags);
+int security_task_setgid (gid_t id0, gid_t id1, gid_t id2, int flags);
+int security_task_setpgid (struct task_struct *p, pid_t pgid);
+int security_task_getpgid (struct task_struct *p);
+int security_task_getsid (struct task_struct *p);
+void security_task_getsecid (struct task_struct *p, u32 *secid);
+int security_task_setgroups (struct group_info *group_info);
+int security_task_setnice (struct task_struct *p, int nice);
+int security_task_setioprio (struct task_struct *p, int ioprio);
+int security_task_getioprio (struct task_struct *p);
+int security_task_setrlimit (unsigned int resource, struct rlimit *new_rlim);
+int security_task_setscheduler (struct task_struct *p,
+				int policy, struct sched_param *lp);
+int security_task_getscheduler (struct task_struct *p);
+int security_task_movememory (struct task_struct *p);
+int security_task_kill (struct task_struct *p, struct siginfo *info,
+			int sig, u32 secid);
+int security_task_wait (struct task_struct *p);
+int security_task_prctl (int option, unsigned long arg2, unsigned long arg3,
+			 unsigned long arg4, unsigned long arg5);
+void security_task_reparent_to_init (struct task_struct *p);
+void security_task_to_inode(struct task_struct *p, struct inode *inode);
+int security_ipc_permission (struct kern_ipc_perm *ipcp, short flag);
+int security_msg_msg_alloc (struct msg_msg * msg);
+void security_msg_msg_free (struct msg_msg * msg);
+int security_msg_queue_alloc (struct msg_queue *msq);
+void security_msg_queue_free (struct msg_queue *msq);
+int security_msg_queue_associate (struct msg_queue * msq, int msqflg);
+int security_msg_queue_msgctl (struct msg_queue * msq, int cmd);
+int security_msg_queue_msgsnd (struct msg_queue * msq,
+			       struct msg_msg * msg, int msqflg);
+int security_msg_queue_msgrcv (struct msg_queue * msq, struct msg_msg * msg,
+			       struct task_struct * target, long type, int mode);
+int security_shm_alloc (struct shmid_kernel *shp);
+void security_shm_free (struct shmid_kernel *shp);
+int security_shm_associate (struct shmid_kernel * shp, int shmflg);
+int security_shm_shmctl (struct shmid_kernel * shp, int cmd);
+int security_shm_shmat (struct shmid_kernel * shp, char __user *shmaddr, int shmflg);
+int security_sem_alloc (struct sem_array *sma);
+void security_sem_free (struct sem_array *sma);
+int security_sem_associate (struct sem_array * sma, int semflg);
+int security_sem_semctl (struct sem_array * sma, int cmd);
+int security_sem_semop (struct sem_array * sma, struct sembuf * sops,
+			unsigned nsops, int alter);
+void security_d_instantiate (struct dentry *dentry, struct inode *inode);
+int security_getprocattr(struct task_struct *p, char *name, char **value);
+int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size);
+int security_netlink_send(struct sock *sk, struct sk_buff * skb);
+int security_netlink_recv(struct sk_buff * skb, int cap);
+int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
+void security_release_secctx(char *secdata, u32 seclen);
+
 #else /* CONFIG_SECURITY */
 
 /*
@@ -2806,170 +2228,43 @@ static inline void security_release_secc
 #endif	/* CONFIG_SECURITY */
 
 #ifdef CONFIG_SECURITY_NETWORK
-static inline int security_unix_stream_connect(struct socket * sock,
-					       struct socket * other, 
-					       struct sock * newsk)
-{
-	return security_ops->unix_stream_connect(sock, other, newsk);
-}
-
-
-static inline int security_unix_may_send(struct socket * sock, 
-					 struct socket * other)
-{
-	return security_ops->unix_may_send(sock, other);
-}
-
-static inline int security_socket_create (int family, int type,
-					  int protocol, int kern)
-{
-	return security_ops->socket_create(family, type, protocol, kern);
-}
-
-static inline int security_socket_post_create(struct socket * sock,
-					      int family,
-					      int type,
-					      int protocol, int kern)
-{
-	return security_ops->socket_post_create(sock, family, type,
-						protocol, kern);
-}
-
-static inline int security_socket_bind(struct socket * sock, 
-				       struct sockaddr * address, 
-				       int addrlen)
-{
-	return security_ops->socket_bind(sock, address, addrlen);
-}
-
-static inline int security_socket_connect(struct socket * sock, 
-					  struct sockaddr * address, 
-					  int addrlen)
-{
-	return security_ops->socket_connect(sock, address, addrlen);
-}
-
-static inline int security_socket_listen(struct socket * sock, int backlog)
-{
-	return security_ops->socket_listen(sock, backlog);
-}
-
-static inline int security_socket_accept(struct socket * sock, 
-					 struct socket * newsock)
-{
-	return security_ops->socket_accept(sock, newsock);
-}
-
-static inline void security_socket_post_accept(struct socket * sock, 
-					       struct socket * newsock)
-{
-	security_ops->socket_post_accept(sock, newsock);
-}
-
-static inline int security_socket_sendmsg(struct socket * sock, 
-					  struct msghdr * msg, int size)
-{
-	return security_ops->socket_sendmsg(sock, msg, size);
-}
-
-static inline int security_socket_recvmsg(struct socket * sock, 
-					  struct msghdr * msg, int size, 
-					  int flags)
-{
-	return security_ops->socket_recvmsg(sock, msg, size, flags);
-}
-
-static inline int security_socket_getsockname(struct socket * sock)
-{
-	return security_ops->socket_getsockname(sock);
-}
-
-static inline int security_socket_getpeername(struct socket * sock)
-{
-	return security_ops->socket_getpeername(sock);
-}
-
-static inline int security_socket_getsockopt(struct socket * sock, 
-					     int level, int optname)
-{
-	return security_ops->socket_getsockopt(sock, level, optname);
-}
-
-static inline int security_socket_setsockopt(struct socket * sock, 
-					     int level, int optname)
-{
-	return security_ops->socket_setsockopt(sock, level, optname);
-}
-
-static inline int security_socket_shutdown(struct socket * sock, int how)
-{
-	return security_ops->socket_shutdown(sock, how);
-}
-
-static inline int security_sock_rcv_skb (struct sock * sk, 
-					 struct sk_buff * skb)
-{
-	return security_ops->socket_sock_rcv_skb (sk, skb);
-}
-
-static inline int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
-						    int __user *optlen, unsigned len)
-{
-	return security_ops->socket_getpeersec_stream(sock, optval, optlen, len);
-}
-
-static inline int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
-{
-	return security_ops->socket_getpeersec_dgram(sock, skb, secid);
-}
-
-static inline int security_sk_alloc(struct sock *sk, int family, gfp_t priority)
-{
-	return security_ops->sk_alloc_security(sk, family, priority);
-}
-
-static inline void security_sk_free(struct sock *sk)
-{
-	return security_ops->sk_free_security(sk);
-}
-
-static inline void security_sk_clone(const struct sock *sk, struct sock *newsk)
-{
-	return security_ops->sk_clone_security(sk, newsk);
-}
-
-static inline void security_sk_classify_flow(struct sock *sk, struct flowi *fl)
-{
-	security_ops->sk_getsecid(sk, &fl->secid);
-}
-
-static inline void security_req_classify_flow(const struct request_sock *req, struct flowi *fl)
-{
-	security_ops->req_classify_flow(req, fl);
-}
-
-static inline void security_sock_graft(struct sock* sk, struct socket *parent)
-{
-	security_ops->sock_graft(sk, parent);
-}
-
-static inline int security_inet_conn_request(struct sock *sk,
-			struct sk_buff *skb, struct request_sock *req)
-{
-	return security_ops->inet_conn_request(sk, skb, req);
-}
 
-static inline void security_inet_csk_clone(struct sock *newsk,
-			const struct request_sock *req)
-{
-	security_ops->inet_csk_clone(newsk, req);
-}
+int security_unix_stream_connect(struct socket * sock, struct socket * other,
+				 struct sock * newsk);
+int security_unix_may_send(struct socket * sock,  struct socket * other);
+int security_socket_create (int family, int type, int protocol, int kern);
+int security_socket_post_create(struct socket * sock, int family,
+				int type, int protocol, int kern);
+int security_socket_bind(struct socket * sock, struct sockaddr * address, int addrlen);
+int security_socket_connect(struct socket * sock, struct sockaddr * address, int addrlen);
+int security_socket_listen(struct socket * sock, int backlog);
+int security_socket_accept(struct socket * sock, struct socket * newsock);
+void security_socket_post_accept(struct socket * sock, struct socket * newsock);
+int security_socket_sendmsg(struct socket * sock, struct msghdr * msg, int size);
+int security_socket_recvmsg(struct socket * sock, struct msghdr * msg,
+			    int size, int flags);
+int security_socket_getsockname(struct socket * sock);
+int security_socket_getpeername(struct socket * sock);
+int security_socket_getsockopt(struct socket * sock, int level, int optname);
+int security_socket_setsockopt(struct socket * sock, int level, int optname);
+int security_socket_shutdown(struct socket * sock, int how);
+int security_sock_rcv_skb (struct sock * sk, struct sk_buff * skb);
+int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
+				      int __user *optlen, unsigned len);
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
+int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
+void security_sk_free(struct sock *sk);
+void security_sk_clone(const struct sock *sk, struct sock *newsk);
+void security_sk_classify_flow(struct sock *sk, struct flowi *fl);
+void security_req_classify_flow(const struct request_sock *req, struct flowi *fl);
+void security_sock_graft(struct sock* sk, struct socket *parent);
+int security_inet_conn_request(struct sock *sk,
+			struct sk_buff *skb, struct request_sock *req);
+void security_inet_csk_clone(struct sock *newsk,
+			const struct request_sock *req);
+void security_inet_conn_established(struct sock *sk,
+			struct sk_buff *skb);
 
-static inline void security_inet_conn_established(struct sock *sk,
-			struct sk_buff *skb)
-{
-	security_ops->inet_conn_established(sk, skb);
-}
 #else	/* CONFIG_SECURITY_NETWORK */
 static inline int security_unix_stream_connect(struct socket * sock,
 					       struct socket * other,
@@ -3127,77 +2422,24 @@ static inline void security_inet_conn_es
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
-static inline int security_xfrm_policy_alloc(struct xfrm_policy *xp, struct xfrm_user_sec_ctx *sec_ctx)
-{
-	return security_ops->xfrm_policy_alloc_security(xp, sec_ctx);
-}
-
-static inline int security_xfrm_policy_clone(struct xfrm_policy *old, struct xfrm_policy *new)
-{
-	return security_ops->xfrm_policy_clone_security(old, new);
-}
-
-static inline void security_xfrm_policy_free(struct xfrm_policy *xp)
-{
-	security_ops->xfrm_policy_free_security(xp);
-}
-
-static inline int security_xfrm_policy_delete(struct xfrm_policy *xp)
-{
-	return security_ops->xfrm_policy_delete_security(xp);
-}
-
-static inline int security_xfrm_state_alloc(struct xfrm_state *x,
-			struct xfrm_user_sec_ctx *sec_ctx)
-{
-	return security_ops->xfrm_state_alloc_security(x, sec_ctx, 0);
-}
-
-static inline int security_xfrm_state_alloc_acquire(struct xfrm_state *x,
-				struct xfrm_sec_ctx *polsec, u32 secid)
-{
-	if (!polsec)
-		return 0;
-	/*
-	 * We want the context to be taken from secid which is usually
-	 * from the sock.
-	 */
-	return security_ops->xfrm_state_alloc_security(x, NULL, secid);
-}
-
-static inline int security_xfrm_state_delete(struct xfrm_state *x)
-{
-	return security_ops->xfrm_state_delete_security(x);
-}
-
-static inline void security_xfrm_state_free(struct xfrm_state *x)
-{
-	security_ops->xfrm_state_free_security(x);
-}
-
-static inline int security_xfrm_policy_lookup(struct xfrm_policy *xp, u32 fl_secid, u8 dir)
-{
-	return security_ops->xfrm_policy_lookup(xp, fl_secid, dir);
-}
-
-static inline int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
-			struct xfrm_policy *xp, struct flowi *fl)
-{
-	return security_ops->xfrm_state_pol_flow_match(x, xp, fl);
-}
-
-static inline int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid)
-{
-	return security_ops->xfrm_decode_session(skb, secid, 1);
-}
 
-static inline void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl)
-{
-	int rc = security_ops->xfrm_decode_session(skb, &fl->secid, 0);
+int security_xfrm_policy_alloc(struct xfrm_policy *xp, struct xfrm_user_sec_ctx *sec_ctx);
+int security_xfrm_policy_clone(struct xfrm_policy *old, struct xfrm_policy *new);
+void security_xfrm_policy_free(struct xfrm_policy *xp);
+int security_xfrm_policy_delete(struct xfrm_policy *xp);
+int security_xfrm_state_alloc(struct xfrm_state *x, struct xfrm_user_sec_ctx *sec_ctx);
+int security_xfrm_state_alloc_acquire(struct xfrm_state *x,
+				      struct xfrm_sec_ctx *polsec, u32 secid);
+int security_xfrm_state_delete(struct xfrm_state *x);
+void security_xfrm_state_free(struct xfrm_state *x);
+int security_xfrm_policy_lookup(struct xfrm_policy *xp, u32 fl_secid, u8 dir);
+int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
+				       struct xfrm_policy *xp, struct flowi *fl);
+int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid);
+void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl);
 
-	BUG_ON(rc);
-}
 #else	/* CONFIG_SECURITY_NETWORK_XFRM */
+
 static inline int security_xfrm_policy_alloc(struct xfrm_policy *xp, struct xfrm_user_sec_ctx *sec_ctx)
 {
 	return 0;
@@ -3262,24 +2504,11 @@ static inline void security_skb_classify
 
 #ifdef CONFIG_KEYS
 #ifdef CONFIG_SECURITY
-static inline int security_key_alloc(struct key *key,
-				     struct task_struct *tsk,
-				     unsigned long flags)
-{
-	return security_ops->key_alloc(key, tsk, flags);
-}
-
-static inline void security_key_free(struct key *key)
-{
-	security_ops->key_free(key);
-}
 
-static inline int security_key_permission(key_ref_t key_ref,
-					  struct task_struct *context,
-					  key_perm_t perm)
-{
-	return security_ops->key_permission(key_ref, context, perm);
-}
+int security_key_alloc(struct key *key, struct task_struct *tsk, unsigned long flags);
+void security_key_free(struct key *key);
+int security_key_permission(key_ref_t key_ref,
+			    struct task_struct *context, key_perm_t perm);
 
 #else
 
diff -puN security/Kconfig~security-convert-lsm-into-a-static-interface security/Kconfig
--- a/security/Kconfig~security-convert-lsm-into-a-static-interface
+++ a/security/Kconfig
@@ -74,14 +74,14 @@ config SECURITY_NETWORK_XFRM
 	  If you are unsure how to answer this question, answer N.
 
 config SECURITY_CAPABILITIES
-	tristate "Default Linux Capabilities"
+	bool "Default Linux Capabilities"
 	depends on SECURITY
 	help
 	  This enables the "default" Linux capabilities functionality.
 	  If you are unsure how to answer this question, answer Y.
 
 config SECURITY_ROOTPLUG
-	tristate "Root Plug Support"
+	bool "Root Plug Support"
 	depends on USB && SECURITY
 	help
 	  This is a sample LSM module that should only be used as such.
diff -puN security/capability.c~security-convert-lsm-into-a-static-interface security/capability.c
--- a/security/capability.c~security-convert-lsm-into-a-static-interface
+++ a/security/capability.c
@@ -8,7 +8,6 @@
  *
  */
 
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
@@ -52,7 +51,6 @@ static int secondary;
 
 static int capability_disable;
 module_param_named(disable, capability_disable, int, 0);
-MODULE_PARM_DESC(disable, "To disable capabilities module set disable = 1");
 
 static int __init capability_init (void)
 {
@@ -75,26 +73,4 @@ static int __init capability_init (void)
 	return 0;
 }
 
-static void __exit capability_exit (void)
-{
-	if (capability_disable)
-		return;
-	/* remove ourselves from the security framework */
-	if (secondary) {
-		if (mod_unreg_security (KBUILD_MODNAME, &capability_ops))
-			printk (KERN_INFO "Failure unregistering capabilities "
-				"with primary module.\n");
-		return;
-	}
-
-	if (unregister_security (&capability_ops)) {
-		printk (KERN_INFO
-			"Failure unregistering capabilities with the kernel\n");
-	}
-}
-
 security_initcall (capability_init);
-module_exit (capability_exit);
-
-MODULE_DESCRIPTION("Standard Linux Capabilities Security Module");
-MODULE_LICENSE("GPL");
diff -puN security/commoncap.c~security-convert-lsm-into-a-static-interface security/commoncap.c
--- a/security/commoncap.c~security-convert-lsm-into-a-static-interface
+++ a/security/commoncap.c
@@ -339,6 +339,3 @@ EXPORT_SYMBOL(cap_task_post_setuid);
 EXPORT_SYMBOL(cap_task_reparent_to_init);
 EXPORT_SYMBOL(cap_syslog);
 EXPORT_SYMBOL(cap_vm_enough_memory);
-
-MODULE_DESCRIPTION("Standard Linux Common Capabilities Security Module");
-MODULE_LICENSE("GPL");
diff -puN security/dummy.c~security-convert-lsm-into-a-static-interface security/dummy.c
--- a/security/dummy.c~security-convert-lsm-into-a-static-interface
+++ a/security/dummy.c
@@ -15,7 +15,6 @@
 #undef DEBUG
 
 #include <linux/capability.h>
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
diff -puN security/root_plug.c~security-convert-lsm-into-a-static-interface security/root_plug.c
--- a/security/root_plug.c~security-convert-lsm-into-a-static-interface
+++ a/security/root_plug.c
@@ -22,11 +22,11 @@
  *	License.
  */
 
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/security.h>
 #include <linux/usb.h>
+#include <linux/moduleparam.h>
 
 /* flag to keep track of how we were registered */
 static int secondary;
@@ -36,22 +36,14 @@ static int vendor_id = 0x0557;
 static int product_id = 0x2008;
 
 module_param(vendor_id, uint, 0400);
-MODULE_PARM_DESC(vendor_id, "USB Vendor ID of device to look for");
-
 module_param(product_id, uint, 0400);
-MODULE_PARM_DESC(product_id, "USB Product ID of device to look for");
 
 /* should we print out debug messages */
 static int debug = 0;
 
 module_param(debug, bool, 0600);
-MODULE_PARM_DESC(debug, "Debug enabled or not");
 
-#if defined(CONFIG_SECURITY_ROOTPLUG_MODULE)
-#define MY_NAME THIS_MODULE->name
-#else
 #define MY_NAME "root_plug"
-#endif
 
 #define root_dbg(fmt, arg...)					\
 	do {							\
@@ -117,25 +109,4 @@ static int __init rootplug_init (void)
 	return 0;
 }
 
-static void __exit rootplug_exit (void)
-{
-	/* remove ourselves from the security framework */
-	if (secondary) {
-		if (mod_unreg_security (MY_NAME, &rootplug_security_ops))
-			printk (KERN_INFO "Failure unregistering Root Plug "
-				" module with primary module.\n");
-	} else { 
-		if (unregister_security (&rootplug_security_ops)) {
-			printk (KERN_INFO "Failure unregistering Root Plug "
-				"module with the kernel\n");
-		}
-	}
-	printk (KERN_INFO "Root Plug module removed\n");
-}
-
 security_initcall (rootplug_init);
-module_exit (rootplug_exit);
-
-MODULE_DESCRIPTION("Root Plug sample LSM module, written for Linux Journal article");
-MODULE_LICENSE("GPL");
-
diff -puN security/security.c~security-convert-lsm-into-a-static-interface security/security.c
--- a/security/security.c~security-convert-lsm-into-a-static-interface
+++ a/security/security.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/security.h>
 
-#define SECURITY_FRAMEWORK_VERSION	"1.0.0"
 
 /* things that live in dummy.c */
 extern struct security_operations dummy_security_ops;
@@ -52,8 +51,7 @@ static void __init do_security_initcalls
  */
 int __init security_init(void)
 {
-	printk(KERN_INFO "Security Framework v" SECURITY_FRAMEWORK_VERSION
-	       " initialized\n");
+	printk(KERN_INFO "Security Framework initialized\n");
 
 	if (verify(&dummy_security_ops)) {
 		printk(KERN_ERR "%s could not verify "
@@ -173,8 +171,949 @@ int mod_unreg_security(const char *name,
 	return security_ops->unregister_security(name, ops);
 }
 
-EXPORT_SYMBOL_GPL(register_security);
-EXPORT_SYMBOL_GPL(unregister_security);
-EXPORT_SYMBOL_GPL(mod_reg_security);
-EXPORT_SYMBOL_GPL(mod_unreg_security);
-EXPORT_SYMBOL(security_ops);
+/* Security operations */
+
+int security_ptrace (struct task_struct * parent, struct task_struct * child)
+{
+	return security_ops->ptrace (parent, child);
+}
+
+int security_capget (struct task_struct *target,
+		     kernel_cap_t *effective,
+		     kernel_cap_t *inheritable,
+		     kernel_cap_t *permitted)
+{
+	return security_ops->capget (target, effective, inheritable, permitted);
+}
+
+int security_capset_check (struct task_struct *target,
+			   kernel_cap_t *effective,
+			   kernel_cap_t *inheritable,
+			   kernel_cap_t *permitted)
+{
+	return security_ops->capset_check (target, effective, inheritable, permitted);
+}
+
+void security_capset_set (struct task_struct *target,
+			  kernel_cap_t *effective,
+			  kernel_cap_t *inheritable,
+			  kernel_cap_t *permitted)
+{
+	security_ops->capset_set (target, effective, inheritable, permitted);
+}
+
+int security_capable(struct task_struct *tsk, int cap)
+{
+	return security_ops->capable(tsk, cap);
+}
+
+int security_acct (struct file *file)
+{
+	return security_ops->acct (file);
+}
+
+int security_sysctl(struct ctl_table *table, int op)
+{
+	return security_ops->sysctl(table, op);
+}
+
+int security_quotactl (int cmds, int type, int id, struct super_block *sb)
+{
+	return security_ops->quotactl (cmds, type, id, sb);
+}
+
+int security_quota_on (struct dentry * dentry)
+{
+	return security_ops->quota_on (dentry);
+}
+
+int security_syslog(int type)
+{
+	return security_ops->syslog(type);
+}
+
+int security_settime(struct timespec *ts, struct timezone *tz)
+{
+	return security_ops->settime(ts, tz);
+}
+
+
+int security_vm_enough_memory(long pages)
+{
+	return security_ops->vm_enough_memory(pages);
+}
+
+int security_bprm_alloc (struct linux_binprm *bprm)
+{
+	return security_ops->bprm_alloc_security (bprm);
+}
+
+void security_bprm_free (struct linux_binprm *bprm)
+{
+	security_ops->bprm_free_security (bprm);
+}
+
+void security_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
+{
+	security_ops->bprm_apply_creds (bprm, unsafe);
+}
+
+void security_bprm_post_apply_creds (struct linux_binprm *bprm)
+{
+	security_ops->bprm_post_apply_creds (bprm);
+}
+
+int security_bprm_set (struct linux_binprm *bprm)
+{
+	return security_ops->bprm_set_security (bprm);
+}
+
+int security_bprm_check (struct linux_binprm *bprm)
+{
+	return security_ops->bprm_check_security (bprm);
+}
+
+int security_bprm_secureexec (struct linux_binprm *bprm)
+{
+	return security_ops->bprm_secureexec (bprm);
+}
+
+int security_sb_alloc (struct super_block *sb)
+{
+	return security_ops->sb_alloc_security (sb);
+}
+
+void security_sb_free (struct super_block *sb)
+{
+	security_ops->sb_free_security (sb);
+}
+
+int security_sb_copy_data (struct file_system_type *type, void *orig, void *copy)
+{
+	return security_ops->sb_copy_data (type, orig, copy);
+}
+
+int security_sb_kern_mount (struct super_block *sb, void *data)
+{
+	return security_ops->sb_kern_mount (sb, data);
+}
+
+int security_sb_statfs (struct dentry *dentry)
+{
+	return security_ops->sb_statfs (dentry);
+}
+
+int security_sb_mount (char *dev_name, struct nameidata *nd,
+                       char *type, unsigned long flags, void *data)
+{
+	return security_ops->sb_mount (dev_name, nd, type, flags, data);
+}
+
+int security_sb_check_sb (struct vfsmount *mnt, struct nameidata *nd)
+{
+	return security_ops->sb_check_sb (mnt, nd);
+}
+
+int security_sb_umount (struct vfsmount *mnt, int flags)
+{
+	return security_ops->sb_umount (mnt, flags);
+}
+
+void security_sb_umount_close (struct vfsmount *mnt)
+{
+	security_ops->sb_umount_close (mnt);
+}
+
+void security_sb_umount_busy (struct vfsmount *mnt)
+{
+	security_ops->sb_umount_busy (mnt);
+}
+
+void security_sb_post_remount (struct vfsmount *mnt, unsigned long flags, void *data)
+{
+	security_ops->sb_post_remount (mnt, flags, data);
+}
+
+void security_sb_post_mountroot (void)
+{
+	security_ops->sb_post_mountroot ();
+}
+
+void security_sb_post_addmount (struct vfsmount *mnt, struct nameidata *mountpoint_nd)
+{
+	security_ops->sb_post_addmount (mnt, mountpoint_nd);
+}
+
+int security_sb_pivotroot (struct nameidata *old_nd, struct nameidata *new_nd)
+{
+	return security_ops->sb_pivotroot (old_nd, new_nd);
+}
+
+void security_sb_post_pivotroot (struct nameidata *old_nd, struct nameidata *new_nd)
+{
+	security_ops->sb_post_pivotroot (old_nd, new_nd);
+}
+
+int security_inode_alloc (struct inode *inode)
+{
+	inode->i_security = NULL;
+	return security_ops->inode_alloc_security (inode);
+}
+
+void security_inode_free (struct inode *inode)
+{
+	security_ops->inode_free_security (inode);
+}
+
+int security_inode_init_security (struct inode *inode, struct inode *dir,
+				  char **name, void **value, size_t *len)
+{
+	if (unlikely (IS_PRIVATE (inode)))
+		return -EOPNOTSUPP;
+	return security_ops->inode_init_security (inode, dir, name, value, len);
+}
+EXPORT_SYMBOL(security_inode_init_security);
+
+int security_inode_create (struct inode *dir, struct dentry *dentry, int mode)
+{
+	if (unlikely (IS_PRIVATE (dir)))
+		return 0;
+	return security_ops->inode_create (dir, dentry, mode);
+}
+
+int security_inode_link (struct dentry *old_dentry, struct inode *dir,
+			 struct dentry *new_dentry)
+{
+	if (unlikely (IS_PRIVATE (old_dentry->d_inode)))
+		return 0;
+	return security_ops->inode_link (old_dentry, dir, new_dentry);
+}
+
+int security_inode_unlink (struct inode *dir, struct dentry *dentry)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return security_ops->inode_unlink (dir, dentry);
+}
+
+int security_inode_symlink (struct inode *dir, struct dentry *dentry,
+			    const char *old_name)
+{
+	if (unlikely (IS_PRIVATE (dir)))
+		return 0;
+	return security_ops->inode_symlink (dir, dentry, old_name);
+}
+
+int security_inode_mkdir (struct inode *dir, struct dentry *dentry, int mode)
+{
+	if (unlikely (IS_PRIVATE (dir)))
+		return 0;
+	return security_ops->inode_mkdir (dir, dentry, mode);
+}
+
+int security_inode_rmdir (struct inode *dir, struct dentry *dentry)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return security_ops->inode_rmdir (dir, dentry);
+}
+
+int security_inode_mknod (struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+{
+	if (unlikely (IS_PRIVATE (dir)))
+		return 0;
+	return security_ops->inode_mknod (dir, dentry, mode, dev);
+}
+
+int security_inode_rename (struct inode *old_dir, struct dentry *old_dentry,
+			   struct inode *new_dir, struct dentry *new_dentry)
+{
+        if (unlikely (IS_PRIVATE (old_dentry->d_inode) ||
+            (new_dentry->d_inode && IS_PRIVATE (new_dentry->d_inode))))
+		return 0;
+	return security_ops->inode_rename (old_dir, old_dentry,
+					   new_dir, new_dentry);
+}
+
+int security_inode_readlink (struct dentry *dentry)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return security_ops->inode_readlink (dentry);
+}
+
+int security_inode_follow_link (struct dentry *dentry, struct nameidata *nd)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return security_ops->inode_follow_link (dentry, nd);
+}
+
+int security_inode_permission (struct inode *inode, int mask, struct nameidata *nd)
+{
+	if (unlikely (IS_PRIVATE (inode)))
+		return 0;
+	return security_ops->inode_permission (inode, mask, nd);
+}
+
+int security_inode_setattr (struct dentry *dentry, struct iattr *attr)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return security_ops->inode_setattr (dentry, attr);
+}
+
+int security_inode_getattr (struct vfsmount *mnt, struct dentry *dentry)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return security_ops->inode_getattr (mnt, dentry);
+}
+
+void security_inode_delete (struct inode *inode)
+{
+	if (unlikely (IS_PRIVATE (inode)))
+		return;
+	security_ops->inode_delete (inode);
+}
+
+int security_inode_setxattr (struct dentry *dentry, char *name,
+			     void *value, size_t size, int flags)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return security_ops->inode_setxattr (dentry, name, value, size, flags);
+}
+
+void security_inode_post_setxattr (struct dentry *dentry, char *name,
+				   void *value, size_t size, int flags)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return;
+	security_ops->inode_post_setxattr (dentry, name, value, size, flags);
+}
+
+int security_inode_getxattr (struct dentry *dentry, char *name)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return security_ops->inode_getxattr (dentry, name);
+}
+
+int security_inode_listxattr (struct dentry *dentry)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return security_ops->inode_listxattr (dentry);
+}
+
+int security_inode_removexattr (struct dentry *dentry, char *name)
+{
+	if (unlikely (IS_PRIVATE (dentry->d_inode)))
+		return 0;
+	return security_ops->inode_removexattr (dentry, name);
+}
+
+const char *security_inode_xattr_getsuffix(void)
+{
+	return security_ops->inode_xattr_getsuffix();
+}
+
+int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
+{
+	if (unlikely (IS_PRIVATE (inode)))
+		return 0;
+	return security_ops->inode_getsecurity(inode, name, buffer, size, err);
+}
+
+int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
+{
+	if (unlikely (IS_PRIVATE (inode)))
+		return 0;
+	return security_ops->inode_setsecurity(inode, name, value, size, flags);
+}
+
+int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
+{
+	if (unlikely (IS_PRIVATE (inode)))
+		return 0;
+	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
+}
+
+int security_file_permission (struct file *file, int mask)
+{
+	return security_ops->file_permission (file, mask);
+}
+
+int security_file_alloc (struct file *file)
+{
+	return security_ops->file_alloc_security (file);
+}
+
+void security_file_free (struct file *file)
+{
+	security_ops->file_free_security (file);
+}
+
+int security_file_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return security_ops->file_ioctl (file, cmd, arg);
+}
+
+int security_file_mmap (struct file *file, unsigned long reqprot,
+			unsigned long prot, unsigned long flags,
+			unsigned long addr, unsigned long addr_only)
+{
+	return security_ops->file_mmap (file, reqprot, prot, flags, addr, addr_only);
+}
+
+int security_file_mprotect (struct vm_area_struct *vma, unsigned long reqprot,
+			    unsigned long prot)
+{
+	return security_ops->file_mprotect (vma, reqprot, prot);
+}
+
+int security_file_lock (struct file *file, unsigned int cmd)
+{
+	return security_ops->file_lock (file, cmd);
+}
+
+int security_file_fcntl (struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return security_ops->file_fcntl (file, cmd, arg);
+}
+
+int security_file_set_fowner (struct file *file)
+{
+	return security_ops->file_set_fowner (file);
+}
+
+int security_file_send_sigiotask (struct task_struct *tsk,
+				  struct fown_struct *fown, int sig)
+{
+	return security_ops->file_send_sigiotask (tsk, fown, sig);
+}
+
+int security_file_receive (struct file *file)
+{
+	return security_ops->file_receive (file);
+}
+
+int security_task_create (unsigned long clone_flags)
+{
+	return security_ops->task_create (clone_flags);
+}
+
+int security_task_alloc (struct task_struct *p)
+{
+	return security_ops->task_alloc_security (p);
+}
+
+void security_task_free (struct task_struct *p)
+{
+	security_ops->task_free_security (p);
+}
+
+int security_task_setuid (uid_t id0, uid_t id1, uid_t id2, int flags)
+{
+	return security_ops->task_setuid (id0, id1, id2, flags);
+}
+
+int security_task_post_setuid (uid_t old_ruid, uid_t old_euid,
+			       uid_t old_suid, int flags)
+{
+	return security_ops->task_post_setuid (old_ruid, old_euid, old_suid, flags);
+}
+
+int security_task_setgid (gid_t id0, gid_t id1, gid_t id2, int flags)
+{
+	return security_ops->task_setgid (id0, id1, id2, flags);
+}
+
+int security_task_setpgid (struct task_struct *p, pid_t pgid)
+{
+	return security_ops->task_setpgid (p, pgid);
+}
+
+int security_task_getpgid (struct task_struct *p)
+{
+	return security_ops->task_getpgid (p);
+}
+
+int security_task_getsid (struct task_struct *p)
+{
+	return security_ops->task_getsid (p);
+}
+
+void security_task_getsecid (struct task_struct *p, u32 *secid)
+{
+	security_ops->task_getsecid (p, secid);
+}
+EXPORT_SYMBOL(security_task_getsecid);
+
+int security_task_setgroups (struct group_info *group_info)
+{
+	return security_ops->task_setgroups (group_info);
+}
+
+int security_task_setnice (struct task_struct *p, int nice)
+{
+	return security_ops->task_setnice (p, nice);
+}
+
+int security_task_setioprio (struct task_struct *p, int ioprio)
+{
+	return security_ops->task_setioprio (p, ioprio);
+}
+
+int security_task_getioprio (struct task_struct *p)
+{
+	return security_ops->task_getioprio (p);
+}
+
+int security_task_setrlimit (unsigned int resource, struct rlimit *new_rlim)
+{
+	return security_ops->task_setrlimit (resource, new_rlim);
+}
+
+int security_task_setscheduler (struct task_struct *p,
+				int policy, struct sched_param *lp)
+{
+	return security_ops->task_setscheduler (p, policy, lp);
+}
+
+int security_task_getscheduler (struct task_struct *p)
+{
+	return security_ops->task_getscheduler (p);
+}
+
+int security_task_movememory (struct task_struct *p)
+{
+	return security_ops->task_movememory (p);
+}
+
+int security_task_kill (struct task_struct *p, struct siginfo *info,
+			int sig, u32 secid)
+{
+	return security_ops->task_kill (p, info, sig, secid);
+}
+
+int security_task_wait (struct task_struct *p)
+{
+	return security_ops->task_wait (p);
+}
+
+int security_task_prctl (int option, unsigned long arg2, unsigned long arg3,
+			 unsigned long arg4, unsigned long arg5)
+{
+	return security_ops->task_prctl (option, arg2, arg3, arg4, arg5);
+}
+
+void security_task_reparent_to_init (struct task_struct *p)
+{
+	security_ops->task_reparent_to_init (p);
+}
+
+void security_task_to_inode(struct task_struct *p, struct inode *inode)
+{
+	security_ops->task_to_inode(p, inode);
+}
+
+int security_ipc_permission (struct kern_ipc_perm *ipcp, short flag)
+{
+	return security_ops->ipc_permission (ipcp, flag);
+}
+
+int security_msg_msg_alloc (struct msg_msg * msg)
+{
+	return security_ops->msg_msg_alloc_security (msg);
+}
+
+void security_msg_msg_free (struct msg_msg * msg)
+{
+	security_ops->msg_msg_free_security(msg);
+}
+
+int security_msg_queue_alloc (struct msg_queue *msq)
+{
+	return security_ops->msg_queue_alloc_security (msq);
+}
+
+void security_msg_queue_free (struct msg_queue *msq)
+{
+	security_ops->msg_queue_free_security (msq);
+}
+
+int security_msg_queue_associate (struct msg_queue * msq, int msqflg)
+{
+	return security_ops->msg_queue_associate (msq, msqflg);
+}
+
+int security_msg_queue_msgctl (struct msg_queue * msq, int cmd)
+{
+	return security_ops->msg_queue_msgctl (msq, cmd);
+}
+
+int security_msg_queue_msgsnd (struct msg_queue * msq,
+			       struct msg_msg * msg, int msqflg)
+{
+	return security_ops->msg_queue_msgsnd (msq, msg, msqflg);
+}
+
+int security_msg_queue_msgrcv (struct msg_queue * msq, struct msg_msg * msg,
+			       struct task_struct * target, long type, int mode)
+{
+	return security_ops->msg_queue_msgrcv (msq, msg, target, type, mode);
+}
+
+int security_shm_alloc (struct shmid_kernel *shp)
+{
+	return security_ops->shm_alloc_security (shp);
+}
+
+void security_shm_free (struct shmid_kernel *shp)
+{
+	security_ops->shm_free_security (shp);
+}
+
+int security_shm_associate (struct shmid_kernel * shp, int shmflg)
+{
+	return security_ops->shm_associate(shp, shmflg);
+}
+
+int security_shm_shmctl (struct shmid_kernel * shp, int cmd)
+{
+	return security_ops->shm_shmctl (shp, cmd);
+}
+
+int security_shm_shmat (struct shmid_kernel * shp, char __user *shmaddr, int shmflg)
+{
+	return security_ops->shm_shmat(shp, shmaddr, shmflg);
+}
+
+int security_sem_alloc (struct sem_array *sma)
+{
+	return security_ops->sem_alloc_security (sma);
+}
+
+void security_sem_free (struct sem_array *sma)
+{
+	security_ops->sem_free_security (sma);
+}
+
+int security_sem_associate (struct sem_array * sma, int semflg)
+{
+	return security_ops->sem_associate (sma, semflg);
+}
+
+int security_sem_semctl (struct sem_array * sma, int cmd)
+{
+	return security_ops->sem_semctl(sma, cmd);
+}
+
+int security_sem_semop (struct sem_array * sma, struct sembuf * sops,
+			unsigned nsops, int alter)
+{
+	return security_ops->sem_semop(sma, sops, nsops, alter);
+}
+
+void security_d_instantiate (struct dentry *dentry, struct inode *inode)
+{
+	if (unlikely (inode && IS_PRIVATE (inode)))
+		return;
+	security_ops->d_instantiate (dentry, inode);
+}
+EXPORT_SYMBOL(security_d_instantiate);
+
+int security_getprocattr(struct task_struct *p, char *name, char **value)
+{
+	return security_ops->getprocattr(p, name, value);
+}
+
+int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size)
+{
+	return security_ops->setprocattr(p, name, value, size);
+}
+
+int security_netlink_send(struct sock *sk, struct sk_buff * skb)
+{
+	return security_ops->netlink_send(sk, skb);
+}
+EXPORT_SYMBOL(security_netlink_send);
+
+int security_netlink_recv(struct sk_buff * skb, int cap)
+{
+	return security_ops->netlink_recv(skb, cap);
+}
+EXPORT_SYMBOL(security_netlink_recv);
+
+int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+{
+	return security_ops->secid_to_secctx(secid, secdata, seclen);
+}
+EXPORT_SYMBOL(security_secid_to_secctx);
+
+void security_release_secctx(char *secdata, u32 seclen)
+{
+	return security_ops->release_secctx(secdata, seclen);
+}
+EXPORT_SYMBOL(security_release_secctx);
+
+#ifdef CONFIG_SECURITY_NETWORK
+
+int security_unix_stream_connect(struct socket * sock, struct socket * other,
+				 struct sock * newsk)
+{
+	return security_ops->unix_stream_connect(sock, other, newsk);
+}
+EXPORT_SYMBOL(security_unix_stream_connect);
+
+int security_unix_may_send(struct socket * sock,  struct socket * other)
+{
+	return security_ops->unix_may_send(sock, other);
+}
+EXPORT_SYMBOL(security_unix_may_send);
+
+int security_socket_create (int family, int type, int protocol, int kern)
+{
+	return security_ops->socket_create(family, type, protocol, kern);
+}
+
+int security_socket_post_create(struct socket * sock, int family,
+				int type, int protocol, int kern)
+{
+	return security_ops->socket_post_create(sock, family, type,
+						protocol, kern);
+}
+
+int security_socket_bind(struct socket * sock, struct sockaddr * address, int addrlen)
+{
+	return security_ops->socket_bind(sock, address, addrlen);
+}
+
+int security_socket_connect(struct socket * sock, struct sockaddr * address, int addrlen)
+{
+	return security_ops->socket_connect(sock, address, addrlen);
+}
+
+int security_socket_listen(struct socket * sock, int backlog)
+{
+	return security_ops->socket_listen(sock, backlog);
+}
+
+int security_socket_accept(struct socket * sock, struct socket * newsock)
+{
+	return security_ops->socket_accept(sock, newsock);
+}
+
+void security_socket_post_accept(struct socket * sock, struct socket * newsock)
+{
+	security_ops->socket_post_accept(sock, newsock);
+}
+
+int security_socket_sendmsg(struct socket * sock, struct msghdr * msg, int size)
+{
+	return security_ops->socket_sendmsg(sock, msg, size);
+}
+
+int security_socket_recvmsg(struct socket * sock, struct msghdr * msg,
+			    int size, int flags)
+{
+	return security_ops->socket_recvmsg(sock, msg, size, flags);
+}
+
+int security_socket_getsockname(struct socket * sock)
+{
+	return security_ops->socket_getsockname(sock);
+}
+
+int security_socket_getpeername(struct socket * sock)
+{
+	return security_ops->socket_getpeername(sock);
+}
+
+int security_socket_getsockopt(struct socket * sock, int level, int optname)
+{
+	return security_ops->socket_getsockopt(sock, level, optname);
+}
+
+int security_socket_setsockopt(struct socket * sock, int level, int optname)
+{
+	return security_ops->socket_setsockopt(sock, level, optname);
+}
+
+int security_socket_shutdown(struct socket * sock, int how)
+{
+	return security_ops->socket_shutdown(sock, how);
+}
+
+int security_sock_rcv_skb (struct sock * sk, struct sk_buff * skb)
+{
+	return security_ops->socket_sock_rcv_skb (sk, skb);
+}
+EXPORT_SYMBOL(security_sock_rcv_skb);
+
+int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
+				      int __user *optlen, unsigned len)
+{
+	return security_ops->socket_getpeersec_stream(sock, optval, optlen, len);
+}
+
+int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
+{
+	return security_ops->socket_getpeersec_dgram(sock, skb, secid);
+}
+EXPORT_SYMBOL(security_socket_getpeersec_dgram);
+
+int security_sk_alloc(struct sock *sk, int family, gfp_t priority)
+{
+	return security_ops->sk_alloc_security(sk, family, priority);
+}
+
+void security_sk_free(struct sock *sk)
+{
+	return security_ops->sk_free_security(sk);
+}
+
+void security_sk_clone(const struct sock *sk, struct sock *newsk)
+{
+	return security_ops->sk_clone_security(sk, newsk);
+}
+
+void security_sk_classify_flow(struct sock *sk, struct flowi *fl)
+{
+	security_ops->sk_getsecid(sk, &fl->secid);
+}
+EXPORT_SYMBOL(security_sk_classify_flow);
+
+void security_req_classify_flow(const struct request_sock *req, struct flowi *fl)
+{
+	security_ops->req_classify_flow(req, fl);
+}
+EXPORT_SYMBOL(security_req_classify_flow);
+
+void security_sock_graft(struct sock* sk, struct socket *parent)
+{
+	security_ops->sock_graft(sk, parent);
+}
+EXPORT_SYMBOL(security_sock_graft);
+
+int security_inet_conn_request(struct sock *sk,
+			struct sk_buff *skb, struct request_sock *req)
+{
+	return security_ops->inet_conn_request(sk, skb, req);
+}
+EXPORT_SYMBOL(security_inet_conn_request);
+
+void security_inet_csk_clone(struct sock *newsk,
+			const struct request_sock *req)
+{
+	security_ops->inet_csk_clone(newsk, req);
+}
+
+void security_inet_conn_established(struct sock *sk,
+			struct sk_buff *skb)
+{
+	security_ops->inet_conn_established(sk, skb);
+}
+
+#endif	/* CONFIG_SECURITY_NETWORK */
+
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+
+int security_xfrm_policy_alloc(struct xfrm_policy *xp, struct xfrm_user_sec_ctx *sec_ctx)
+{
+	return security_ops->xfrm_policy_alloc_security(xp, sec_ctx);
+}
+EXPORT_SYMBOL(security_xfrm_policy_alloc);
+
+int security_xfrm_policy_clone(struct xfrm_policy *old, struct xfrm_policy *new)
+{
+	return security_ops->xfrm_policy_clone_security(old, new);
+}
+
+void security_xfrm_policy_free(struct xfrm_policy *xp)
+{
+	security_ops->xfrm_policy_free_security(xp);
+}
+EXPORT_SYMBOL(security_xfrm_policy_free);
+
+int security_xfrm_policy_delete(struct xfrm_policy *xp)
+{
+	return security_ops->xfrm_policy_delete_security(xp);
+}
+
+int security_xfrm_state_alloc(struct xfrm_state *x, struct xfrm_user_sec_ctx *sec_ctx)
+{
+	return security_ops->xfrm_state_alloc_security(x, sec_ctx, 0);
+}
+EXPORT_SYMBOL(security_xfrm_state_alloc);
+
+int security_xfrm_state_alloc_acquire(struct xfrm_state *x,
+				      struct xfrm_sec_ctx *polsec, u32 secid)
+{
+	if (!polsec)
+		return 0;
+	/*
+	 * We want the context to be taken from secid which is usually
+	 * from the sock.
+	 */
+	return security_ops->xfrm_state_alloc_security(x, NULL, secid);
+}
+
+int security_xfrm_state_delete(struct xfrm_state *x)
+{
+	return security_ops->xfrm_state_delete_security(x);
+}
+EXPORT_SYMBOL(security_xfrm_state_delete);
+
+void security_xfrm_state_free(struct xfrm_state *x)
+{
+	security_ops->xfrm_state_free_security(x);
+}
+
+int security_xfrm_policy_lookup(struct xfrm_policy *xp, u32 fl_secid, u8 dir)
+{
+	return security_ops->xfrm_policy_lookup(xp, fl_secid, dir);
+}
+
+int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
+				       struct xfrm_policy *xp, struct flowi *fl)
+{
+	return security_ops->xfrm_state_pol_flow_match(x, xp, fl);
+}
+
+int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid)
+{
+	return security_ops->xfrm_decode_session(skb, secid, 1);
+}
+
+void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl)
+{
+	int rc = security_ops->xfrm_decode_session(skb, &fl->secid, 0);
+
+	BUG_ON(rc);
+}
+EXPORT_SYMBOL(security_skb_classify_flow);
+
+#endif	/* CONFIG_SECURITY_NETWORK_XFRM */
+
+#ifdef CONFIG_KEYS
+
+int security_key_alloc(struct key *key, struct task_struct *tsk, unsigned long flags)
+{
+	return security_ops->key_alloc(key, tsk, flags);
+}
+
+void security_key_free(struct key *key)
+{
+	security_ops->key_free(key);
+}
+
+int security_key_permission(key_ref_t key_ref,
+			    struct task_struct *context, key_perm_t perm)
+{
+	return security_ops->key_permission(key_ref, context, perm);
+}
+
+#endif	/* CONFIG_KEYS */
diff -puN security/selinux/hooks.c~security-convert-lsm-into-a-static-interface security/selinux/hooks.c
--- a/security/selinux/hooks.c~security-convert-lsm-into-a-static-interface
+++ a/security/selinux/hooks.c
@@ -20,7 +20,6 @@
  *      as published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
@@ -84,6 +83,7 @@
 extern unsigned int policydb_loaded_version;
 extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
 extern int selinux_compat_net;
+extern struct security_operations *security_ops;
 
 #ifdef CONFIG_SECURITY_SELINUX_DEVELOP
 int selinux_enforcing = 0;
diff -puN security/selinux/xfrm.c~security-convert-lsm-into-a-static-interface security/selinux/xfrm.c
--- a/security/selinux/xfrm.c~security-convert-lsm-into-a-static-interface
+++ a/security/selinux/xfrm.c
@@ -31,7 +31,6 @@
  *   2. Emulating a reasonable SO_PEERSEC across machines
  *   3. Testing addition of sk_policy's with security context via setsockopt
  */
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/security.h>
_

Patches currently in -mm which might be from jmorris@namei.org are

origin.patch
git-selinux.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
lguest-the-documentation-example-launcher.patch
