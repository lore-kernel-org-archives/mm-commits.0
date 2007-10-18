From: akpm@linux-foundation.org
Subject: - security-cleanups.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:17 -0700
Message-ID: <200710180705.l9I75Hj2031634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762150AbXJRH1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security/ cleanups
has been removed from the -mm tree.  Its filename was
     security-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: security/ cleanups
From: Adrian Bunk <bunk@kernel.org>

This patch contains the following cleanups that are now possible:
- remove the unused security_operations->inode_xattr_getsuffix
- remove the no longer used security_operations->unregister_security
- remove some no longer required exit code
- remove a bunch of no longer used exports

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/usb.c   |    1 
 fs/exec.c                |    2 -
 include/linux/security.h |   15 ---------
 kernel/capability.c      |    4 --
 mm/mmap.c                |    2 -
 mm/nommu.c               |    1 
 security/commoncap.c     |   21 -------------
 security/dummy.c         |   12 -------
 security/inode.c         |    8 -----
 security/security.c      |   58 -------------------------------------
 security/selinux/hooks.c |   20 ------------
 11 files changed, 1 insertion(+), 143 deletions(-)

diff -puN drivers/usb/core/usb.c~security-cleanups drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~security-cleanups
+++ a/drivers/usb/core/usb.c
@@ -982,7 +982,6 @@ EXPORT_SYMBOL(usb_altnum_to_altsetting);
 
 EXPORT_SYMBOL(__usb_get_extra_descriptor);
 
-EXPORT_SYMBOL(usb_find_device);
 EXPORT_SYMBOL(usb_get_current_frame_number);
 
 EXPORT_SYMBOL(usb_buffer_alloc);
diff -puN fs/exec.c~security-cleanups fs/exec.c
--- a/fs/exec.c~security-cleanups
+++ a/fs/exec.c
@@ -64,7 +64,6 @@ int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
 int suid_dumpable = 0;
 
-EXPORT_SYMBOL(suid_dumpable);
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
 static LIST_HEAD(formats);
@@ -1662,7 +1661,6 @@ void set_dumpable(struct mm_struct *mm, 
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(set_dumpable);
 
 int get_dumpable(struct mm_struct *mm)
 {
diff -puN include/linux/security.h~security-cleanups include/linux/security.h
--- a/include/linux/security.h~security-cleanups
+++ a/include/linux/security.h
@@ -1158,10 +1158,6 @@ struct request_sock;
  * 	allow module stacking.
  * 	@name contains the name of the security module being stacked.
  * 	@ops contains a pointer to the struct security_operations of the module to stack.
- * @unregister_security:
- *	remove a stacked module.
- *	@name contains the name of the security module being unstacked.
- *	@ops contains a pointer to the struct security_operations of the module to unstack.
  * 
  * @secid_to_secctx:
  *	Convert secid to security context.
@@ -1259,7 +1255,6 @@ struct security_operations {
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
-	const char *(*inode_xattr_getsuffix) (void);
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
   	int (*inode_listsecurity)(struct inode *inode, char *buffer, size_t buffer_size);
@@ -1350,8 +1345,6 @@ struct security_operations {
 	/* allow module stacking */
 	int (*register_security) (const char *name,
 	                          struct security_operations *ops);
-	int (*unregister_security) (const char *name,
-	                            struct security_operations *ops);
 
 	void (*d_instantiate) (struct dentry *dentry, struct inode *inode);
 
@@ -1432,9 +1425,7 @@ struct security_operations {
 /* prototypes */
 extern int security_init	(void);
 extern int register_security	(struct security_operations *ops);
-extern int unregister_security	(struct security_operations *ops);
 extern int mod_reg_security	(const char *name, struct security_operations *ops);
-extern int mod_unreg_security	(const char *name, struct security_operations *ops);
 extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
 					     struct dentry *parent, void *data,
 					     const struct file_operations *fops);
@@ -1518,7 +1509,6 @@ int security_inode_listxattr(struct dent
 int security_inode_removexattr(struct dentry *dentry, char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
-const char *security_inode_xattr_getsuffix(void);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
@@ -1923,11 +1913,6 @@ static inline int security_inode_killpri
 	return cap_inode_killpriv(dentry);
 }
 
-static inline const char *security_inode_xattr_getsuffix (void)
-{
-	return NULL ;
-}
-
 static inline int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
 {
 	return -EOPNOTSUPP;
diff -puN kernel/capability.c~security-cleanups kernel/capability.c
--- a/kernel/capability.c~security-cleanups
+++ a/kernel/capability.c
@@ -17,9 +17,6 @@
 unsigned securebits = SECUREBITS_DEFAULT; /* systemwide security settings */
 kernel_cap_t cap_bset = CAP_INIT_EFF_SET;
 
-EXPORT_SYMBOL(securebits);
-EXPORT_SYMBOL(cap_bset);
-
 /*
  * This lock protects task->cap_* for all tasks including current.
  * Locking rule: acquire this prior to tasklist_lock.
@@ -244,7 +241,6 @@ int __capable(struct task_struct *t, int
 	}
 	return 0;
 }
-EXPORT_SYMBOL(__capable);
 
 int capable(int cap)
 {
diff -puN mm/mmap.c~security-cleanups mm/mmap.c
--- a/mm/mmap.c~security-cleanups
+++ a/mm/mmap.c
@@ -181,8 +181,6 @@ error:
 	return -ENOMEM;
 }
 
-EXPORT_SYMBOL(__vm_enough_memory);
-
 /*
  * Requires inode->i_mapping->i_mmap_lock
  */
diff -puN mm/nommu.c~security-cleanups mm/nommu.c
--- a/mm/nommu.c~security-cleanups
+++ a/mm/nommu.c
@@ -44,7 +44,6 @@ int sysctl_max_map_count = DEFAULT_MAX_M
 int heap_stack_gap = 0;
 
 EXPORT_SYMBOL(mem_map);
-EXPORT_SYMBOL(__vm_enough_memory);
 EXPORT_SYMBOL(num_physpages);
 
 /* list of shareable VMAs */
diff -puN security/commoncap.c~security-cleanups security/commoncap.c
--- a/security/commoncap.c~security-cleanups
+++ a/security/commoncap.c
@@ -30,8 +30,6 @@ int cap_netlink_send(struct sock *sk, st
 	return 0;
 }
 
-EXPORT_SYMBOL(cap_netlink_send);
-
 int cap_netlink_recv(struct sk_buff *skb, int cap)
 {
 	if (!cap_raised(NETLINK_CB(skb).eff_cap, cap))
@@ -532,22 +530,3 @@ int cap_vm_enough_memory(struct mm_struc
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
-EXPORT_SYMBOL(cap_capable);
-EXPORT_SYMBOL(cap_settime);
-EXPORT_SYMBOL(cap_ptrace);
-EXPORT_SYMBOL(cap_capget);
-EXPORT_SYMBOL(cap_capset_check);
-EXPORT_SYMBOL(cap_capset_set);
-EXPORT_SYMBOL(cap_bprm_set_security);
-EXPORT_SYMBOL(cap_bprm_apply_creds);
-EXPORT_SYMBOL(cap_bprm_secureexec);
-EXPORT_SYMBOL(cap_inode_setxattr);
-EXPORT_SYMBOL(cap_inode_removexattr);
-EXPORT_SYMBOL(cap_task_post_setuid);
-EXPORT_SYMBOL(cap_task_kill);
-EXPORT_SYMBOL(cap_task_setscheduler);
-EXPORT_SYMBOL(cap_task_setioprio);
-EXPORT_SYMBOL(cap_task_setnice);
-EXPORT_SYMBOL(cap_task_reparent_to_init);
-EXPORT_SYMBOL(cap_syslog);
-EXPORT_SYMBOL(cap_vm_enough_memory);
diff -puN security/dummy.c~security-cleanups security/dummy.c
--- a/security/dummy.c~security-cleanups
+++ a/security/dummy.c
@@ -401,11 +401,6 @@ static int dummy_inode_listsecurity(stru
 	return 0;
 }
 
-static const char *dummy_inode_xattr_getsuffix(void)
-{
-	return NULL;
-}
-
 static int dummy_file_permission (struct file *file, int mask)
 {
 	return 0;
@@ -915,11 +910,6 @@ static int dummy_register_security (cons
 	return -EINVAL;
 }
 
-static int dummy_unregister_security (const char *name, struct security_operations *ops)
-{
-	return -EINVAL;
-}
-
 static void dummy_d_instantiate (struct dentry *dentry, struct inode *inode)
 {
 	return;
@@ -1034,7 +1024,6 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, inode_removexattr);
 	set_to_dummy_if_null(ops, inode_need_killpriv);
 	set_to_dummy_if_null(ops, inode_killpriv);
-	set_to_dummy_if_null(ops, inode_xattr_getsuffix);
 	set_to_dummy_if_null(ops, inode_getsecurity);
 	set_to_dummy_if_null(ops, inode_setsecurity);
 	set_to_dummy_if_null(ops, inode_listsecurity);
@@ -1095,7 +1084,6 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, netlink_send);
 	set_to_dummy_if_null(ops, netlink_recv);
 	set_to_dummy_if_null(ops, register_security);
-	set_to_dummy_if_null(ops, unregister_security);
 	set_to_dummy_if_null(ops, d_instantiate);
  	set_to_dummy_if_null(ops, getprocattr);
  	set_to_dummy_if_null(ops, setprocattr);
diff -puN security/inode.c~security-cleanups security/inode.c
--- a/security/inode.c~security-cleanups
+++ a/security/inode.c
@@ -332,14 +332,6 @@ static int __init securityfs_init(void)
 	return retval;
 }
 
-static void __exit securityfs_exit(void)
-{
-	simple_release_fs(&mount, &mount_count);
-	unregister_filesystem(&fs_type);
-	subsystem_unregister(&security_subsys);
-}
-
 core_initcall(securityfs_init);
-module_exit(securityfs_exit);
 MODULE_LICENSE("GPL");
 
diff -puN security/security.c~security-cleanups security/security.c
--- a/security/security.c~security-cleanups
+++ a/security/security.c
@@ -71,8 +71,7 @@ int __init security_init(void)
  *
  * This function is to allow a security module to register itself with the
  * kernel security subsystem.  Some rudimentary checking is done on the @ops
- * value passed to this function.  A call to unregister_security() should be
- * done to remove this security_options structure from the kernel.
+ * value passed to this function.
  *
  * If there is already a security module registered with the kernel,
  * an error will be returned.  Otherwise 0 is returned on success.
@@ -94,31 +93,6 @@ int register_security(struct security_op
 }
 
 /**
- * unregister_security - unregisters a security framework with the kernel
- * @ops: a pointer to the struct security_options that is to be registered
- *
- * This function removes a struct security_operations variable that had
- * previously been registered with a successful call to register_security().
- *
- * If @ops does not match the valued previously passed to register_security()
- * an error is returned.  Otherwise the default security options is set to the
- * the dummy_security_ops structure, and 0 is returned.
- */
-int unregister_security(struct security_operations *ops)
-{
-	if (ops != security_ops) {
-		printk(KERN_INFO "%s: trying to unregister "
-		       "a security_opts structure that is not "
-		       "registered, failing.\n", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	security_ops = &dummy_security_ops;
-
-	return 0;
-}
-
-/**
  * mod_reg_security - allows security modules to be "stacked"
  * @name: a pointer to a string with the name of the security_options to be registered
  * @ops: a pointer to the struct security_options that is to be registered
@@ -147,30 +121,6 @@ int mod_reg_security(const char *name, s
 	return security_ops->register_security(name, ops);
 }
 
-/**
- * mod_unreg_security - allows a security module registered with mod_reg_security() to be unloaded
- * @name: a pointer to a string with the name of the security_options to be removed
- * @ops: a pointer to the struct security_options that is to be removed
- *
- * This function allows security modules that have been successfully registered
- * with a call to mod_reg_security() to be unloaded from the system.
- * This calls the currently loaded security module's unregister_security() call
- * with the @name and @ops variables.
- *
- * The return value depends on the currently loaded security module, with 0 as
- * success.
- */
-int mod_unreg_security(const char *name, struct security_operations *ops)
-{
-	if (ops == security_ops) {
-		printk(KERN_INFO "%s invalid attempt to unregister "
-		       " primary security ops.\n", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	return security_ops->unregister_security(name, ops);
-}
-
 /* Security operations */
 
 int security_ptrace(struct task_struct *parent, struct task_struct *child)
@@ -528,11 +478,6 @@ int security_inode_killpriv(struct dentr
 	return security_ops->inode_killpriv(dentry);
 }
 
-const char *security_inode_xattr_getsuffix(void)
-{
-	return security_ops->inode_xattr_getsuffix();
-}
-
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err)
 {
 	if (unlikely(IS_PRIVATE(inode)))
@@ -858,7 +803,6 @@ int security_netlink_send(struct sock *s
 {
 	return security_ops->netlink_send(sk, skb);
 }
-EXPORT_SYMBOL(security_netlink_send);
 
 int security_netlink_recv(struct sk_buff *skb, int cap)
 {
diff -puN security/selinux/hooks.c~security-cleanups security/selinux/hooks.c
--- a/security/selinux/hooks.c~security-cleanups
+++ a/security/selinux/hooks.c
@@ -2409,11 +2409,6 @@ static int selinux_inode_removexattr (st
 	return -EACCES;
 }
 
-static const char *selinux_inode_xattr_getsuffix(void)
-{
-      return XATTR_SELINUX_SUFFIX;
-}
-
 /*
  * Copy the in-core inode security context value to the user.  If the
  * getxattr() prior to this succeeded, check to see if we need to
@@ -4554,19 +4549,6 @@ static int selinux_register_security (co
 	return 0;
 }
 
-static int selinux_unregister_security (const char *name, struct security_operations *ops)
-{
-	if (ops != secondary_ops) {
-		printk(KERN_ERR "%s:  trying to unregister a security module "
-		        "that is not registered.\n", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	secondary_ops = original_ops;
-
-	return 0;
-}
-
 static void selinux_d_instantiate (struct dentry *dentry, struct inode *inode)
 {
 	if (inode)
@@ -4844,7 +4826,6 @@ static struct security_operations selinu
 	.inode_getxattr =		selinux_inode_getxattr,
 	.inode_listxattr =		selinux_inode_listxattr,
 	.inode_removexattr =		selinux_inode_removexattr,
-	.inode_xattr_getsuffix =        selinux_inode_xattr_getsuffix,
 	.inode_getsecurity =            selinux_inode_getsecurity,
 	.inode_setsecurity =            selinux_inode_setsecurity,
 	.inode_listsecurity =           selinux_inode_listsecurity,
@@ -4914,7 +4895,6 @@ static struct security_operations selinu
 	.sem_semop =			selinux_sem_semop,
 
 	.register_security =		selinux_register_security,
-	.unregister_security =		selinux_unregister_security,
 
 	.d_instantiate =                selinux_d_instantiate,
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
