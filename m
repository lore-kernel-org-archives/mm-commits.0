From: akpm@linux-foundation.org
Subject: + security-cleanups.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:07:47 -0700
Message-ID: <200708162107.l7GL7l6b006794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757120AbXHPVI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:08:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     security/ cleanups
has been added to the -mm tree.  Its filename is
     security-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -980,7 +980,6 @@ EXPORT_SYMBOL(usb_altnum_to_altsetting);
 
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
 
 static struct linux_binfmt *formats;
@@ -1700,7 +1699,6 @@ void set_dumpable(struct mm_struct *mm, 
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(set_dumpable);
 
 int get_dumpable(struct mm_struct *mm)
 {
diff -puN include/linux/security.h~security-cleanups include/linux/security.h
--- a/include/linux/security.h~security-cleanups
+++ a/include/linux/security.h
@@ -1151,10 +1151,6 @@ struct request_sock;
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
@@ -1252,7 +1248,6 @@ struct security_operations {
 	int (*inode_removexattr) (struct dentry *dentry, char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
-	const char *(*inode_xattr_getsuffix) (void);
   	int (*inode_getsecurity)(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
   	int (*inode_listsecurity)(struct inode *inode, char *buffer, size_t buffer_size);
@@ -1342,8 +1337,6 @@ struct security_operations {
 	/* allow module stacking */
 	int (*register_security) (const char *name,
 	                          struct security_operations *ops);
-	int (*unregister_security) (const char *name,
-	                            struct security_operations *ops);
 
 	void (*d_instantiate) (struct dentry *dentry, struct inode *inode);
 
@@ -1424,9 +1417,7 @@ struct security_operations {
 /* prototypes */
 extern int security_init	(void);
 extern int register_security	(struct security_operations *ops);
-extern int unregister_security	(struct security_operations *ops);
 extern int mod_reg_security	(const char *name, struct security_operations *ops);
-extern int mod_unreg_security	(const char *name, struct security_operations *ops);
 extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
 					     struct dentry *parent, void *data,
 					     const struct file_operations *fops);
@@ -1509,7 +1500,6 @@ int security_inode_listxattr(struct dent
 int security_inode_removexattr(struct dentry *dentry, char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
-const char *security_inode_xattr_getsuffix(void);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void *buffer, size_t size, int err);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
@@ -1913,11 +1903,6 @@ static inline int security_inode_killpri
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
@@ -180,8 +180,6 @@ error:
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
@@ -531,22 +529,3 @@ int cap_vm_enough_memory(struct mm_struc
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
@@ -910,11 +905,6 @@ static int dummy_register_security (cons
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
@@ -1029,7 +1019,6 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, inode_removexattr);
 	set_to_dummy_if_null(ops, inode_need_killpriv);
 	set_to_dummy_if_null(ops, inode_killpriv);
-	set_to_dummy_if_null(ops, inode_xattr_getsuffix);
 	set_to_dummy_if_null(ops, inode_getsecurity);
 	set_to_dummy_if_null(ops, inode_setsecurity);
 	set_to_dummy_if_null(ops, inode_listsecurity);
@@ -1089,7 +1078,6 @@ void security_fixup_ops (struct security
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
@@ -525,11 +475,6 @@ int security_inode_killpriv(struct dentr
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
@@ -851,7 +796,6 @@ int security_netlink_send(struct sock *s
 {
 	return security_ops->netlink_send(sk, skb);
 }
-EXPORT_SYMBOL(security_netlink_send);
 
 int security_netlink_recv(struct sk_buff *skb, int cap)
 {
diff -puN security/selinux/hooks.c~security-cleanups security/selinux/hooks.c
--- a/security/selinux/hooks.c~security-cleanups
+++ a/security/selinux/hooks.c
@@ -2402,11 +2402,6 @@ static int selinux_inode_removexattr (st
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
@@ -4496,19 +4491,6 @@ static int selinux_register_security (co
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
@@ -4786,7 +4768,6 @@ static struct security_operations selinu
 	.inode_getxattr =		selinux_inode_getxattr,
 	.inode_listxattr =		selinux_inode_listxattr,
 	.inode_removexattr =		selinux_inode_removexattr,
-	.inode_xattr_getsuffix =        selinux_inode_xattr_getsuffix,
 	.inode_getsecurity =            selinux_inode_getsecurity,
 	.inode_setsecurity =            selinux_inode_setsecurity,
 	.inode_listsecurity =           selinux_inode_listsecurity,
@@ -4854,7 +4835,6 @@ static struct security_operations selinu
 	.sem_semop =			selinux_sem_semop,
 
 	.register_security =		selinux_register_security,
-	.unregister_security =		selinux_unregister_security,
 
 	.d_instantiate =                selinux_d_instantiate,
 
_

Patches currently in -mm which might be from bunk@kernel.org are

pass-g-to-assembler-under-config_debug_info-fix.patch
alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
