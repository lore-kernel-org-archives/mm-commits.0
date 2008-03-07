From: akpm@linux-foundation.org
Subject: - security-introduce-security=-boot-parameter.patch removed from -mm tree
Date: Fri, 07 Mar 2008 15:00:59 -0800
Message-ID: <200803072300.m27N0xEU021734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759425AbYCGXC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 18:02:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, adobriyan@sw.ru, casey@schaufler-ca.com, chrisw@sous-sol.org, eparis@parisplace.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     security: introduce security= boot parameter
has been removed from the -mm tree.  Its filename was
     security-introduce-security=-boot-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security: introduce security= boot parameter
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Add the security= boot parameter.  This is done to avoid LSM registration
clashes in case of more than one bult-in module.

User can choose a security module to enable at boot.  If no security= boot
parameter is specified, only the first LSM asking for registration will be
loaded.  An invalid security module name will be treated as if no module has
been chosen.

LSM modules must check now if they are allowed to register by calling
security_module_enable(ops) first.  Modify SELinux and SMACK to do so.

Do not let SMACK register smackfs if it was not chosen on boot.  Smackfs
assumes that smack hooks are registered and the initial task security setup
(swapper->security) is done.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Paul Moore <paul.moore@hp.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++++
 include/linux/security.h            |   12 ++++++++
 security/dummy.c                    |    4 ++
 security/security.c                 |   38 +++++++++++++++++++++++++-
 security/selinux/hooks.c            |    7 ++++
 security/smack/smack.h              |    2 +
 security/smack/smack_lsm.c          |    7 ++++
 security/smack/smackfs.c            |   11 ++++++-
 8 files changed, 83 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~security-introduce-security=-boot-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~security-introduce-security=-boot-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -374,6 +374,12 @@ and is between 256 and 4096 characters. 
 			possible to determine what the correct size should be.
 			This option provides an override for these situations.
 
+	security=	[SECURITY] Choose a security module to enable at boot.
+			If this boot parameter is not specified, only the first
+			security module asking for security registration will be
+			loaded. An invalid security module name will be treated
+			as if no module has been chosen.
+
 	capability.disable=
 			[SECURITY] Disable capabilities.  This would normally
 			be used only if an alternative security model is to be
diff -puN include/linux/security.h~security-introduce-security=-boot-parameter include/linux/security.h
--- a/include/linux/security.h~security-introduce-security=-boot-parameter
+++ a/include/linux/security.h
@@ -34,6 +34,9 @@
 #include <linux/xfrm.h>
 #include <net/flow.h>
 
+/* Maximum number of letters for an LSM name string */
+#define SECURITY_NAME_MAX	10
+
 struct ctl_table;
 struct audit_krule;
 
@@ -138,6 +141,12 @@ static inline void security_free_mnt_opt
 /**
  * struct security_operations - main security structure
  *
+ * Security module identifier.
+ *
+ * @name:
+ *	A string that acts as a unique identifeir for the LSM with max number
+ *	of characters = SECURITY_NAME_MAX.
+ *
  * Security hooks for program execution operations.
  *
  * @bprm_alloc_security:
@@ -1273,6 +1282,8 @@ static inline void security_free_mnt_opt
  * This is the main security structure.
  */
 struct security_operations {
+	char name[SECURITY_NAME_MAX + 1];
+
 	int (*ptrace) (struct task_struct * parent, struct task_struct * child);
 	int (*capget) (struct task_struct * target,
 		       kernel_cap_t * effective,
@@ -1541,6 +1552,7 @@ struct security_operations {
 
 /* prototypes */
 extern int security_init	(void);
+extern int security_module_enable(struct security_operations *ops);
 extern int register_security	(struct security_operations *ops);
 extern int mod_reg_security	(const char *name, struct security_operations *ops);
 extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
diff -puN security/dummy.c~security-introduce-security=-boot-parameter security/dummy.c
--- a/security/dummy.c~security-introduce-security=-boot-parameter
+++ a/security/dummy.c
@@ -1017,7 +1017,9 @@ static inline void dummy_audit_rule_free
 
 #endif /* CONFIG_AUDIT */
 
-struct security_operations dummy_security_ops;
+struct security_operations dummy_security_ops = {
+	.name = "dummy",
+};
 
 #define set_to_dummy_if_null(ops, function)				\
 	do {								\
diff -puN security/security.c~security-introduce-security=-boot-parameter security/security.c
--- a/security/security.c~security-introduce-security=-boot-parameter
+++ a/security/security.c
@@ -17,6 +17,8 @@
 #include <linux/kernel.h>
 #include <linux/security.h>
 
+/* Boot-time LSM user choice */
+static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1];
 
 /* things that live in dummy.c */
 extern struct security_operations dummy_security_ops;
@@ -67,13 +69,47 @@ int __init security_init(void)
 	return 0;
 }
 
+/* Save user chosen LSM */
+static int __init choose_lsm(char *str)
+{
+	strncpy(chosen_lsm, str, SECURITY_NAME_MAX);
+	return 1;
+}
+__setup("security=", choose_lsm);
+
+/**
+ * security_module_enable - Load given security module on boot ?
+ * @ops: a pointer to the struct security_operations that is to be checked.
+ *
+ * Each LSM must pass this method before registering its own operations
+ * to avoid security registration races. This method may also be used
+ * to check if your LSM is currently loaded.
+ *
+ * Return true if:
+ *	-The passed LSM is the one chosen by user at boot time,
+ *	-or user didsn't specify a specific LSM and we're the first to ask
+ *	 for registeration permissoin,
+ *	-or the passed LSM is currently loaded.
+ * Otherwise, return false.
+ */
+int __init security_module_enable(struct security_operations *ops)
+{
+	if (!*chosen_lsm)
+		strncpy(chosen_lsm, ops->name, SECURITY_NAME_MAX);
+	else if (strncmp(ops->name, chosen_lsm, SECURITY_NAME_MAX))
+		return 0;
+
+	return 1;
+}
+
 /**
  * register_security - registers a security framework with the kernel
  * @ops: a pointer to the struct security_options that is to be registered
  *
  * This function is to allow a security module to register itself with the
  * kernel security subsystem.  Some rudimentary checking is done on the @ops
- * value passed to this function.
+ * value passed to this function. You'll need to check first if your LSM
+ * is allowed to register its @ops by calling security_module_enable(@ops).
  *
  * If there is already a security module registered with the kernel,
  * an error will be returned.  Otherwise 0 is returned on success.
diff -puN security/selinux/hooks.c~security-introduce-security=-boot-parameter security/selinux/hooks.c
--- a/security/selinux/hooks.c~security-introduce-security=-boot-parameter
+++ a/security/selinux/hooks.c
@@ -5267,6 +5267,8 @@ static int selinux_key_permission(key_re
 #endif
 
 static struct security_operations selinux_ops = {
+	.name =				"selinux",
+
 	.ptrace =			selinux_ptrace,
 	.capget =			selinux_capget,
 	.capset_check =			selinux_capset_check,
@@ -5464,6 +5466,11 @@ static __init int selinux_init(void)
 {
 	struct task_security_struct *tsec;
 
+	if (!security_module_enable(&selinux_ops)) {
+		selinux_enabled = 0;
+		return 0;
+	}
+
 	if (!selinux_enabled) {
 		printk(KERN_INFO "SELinux:  Disabled at boot.\n");
 		return 0;
diff -puN security/smack/smack.h~security-introduce-security=-boot-parameter security/smack/smack.h
--- a/security/smack/smack.h~security-introduce-security=-boot-parameter
+++ a/security/smack/smack.h
@@ -15,6 +15,7 @@
 
 #include <linux/capability.h>
 #include <linux/spinlock.h>
+#include <linux/security.h>
 #include <net/netlabel.h>
 
 /*
@@ -195,6 +196,7 @@ extern struct smack_known smack_known_st
 extern struct smack_known smack_known_unset;
 
 extern struct smk_list_entry *smack_list;
+extern struct security_operations smack_ops;
 
 /*
  * Stricly for CIPSO level manipulation.
diff -puN security/smack/smack_lsm.c~security-introduce-security=-boot-parameter security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~security-introduce-security=-boot-parameter
+++ a/security/smack/smack_lsm.c
@@ -2426,7 +2426,9 @@ static void smack_release_secctx(char *s
 {
 }
 
-static struct security_operations smack_ops = {
+struct security_operations smack_ops = {
+	.name =				"smack",
+
 	.ptrace = 			smack_ptrace,
 	.capget = 			cap_capget,
 	.capset_check = 		cap_capset_check,
@@ -2559,6 +2561,9 @@ static struct security_operations smack_
  */
 static __init int smack_init(void)
 {
+	if (!security_module_enable(&smack_ops))
+		return 0;
+
 	printk(KERN_INFO "Smack:  Initializing.\n");
 
 	/*
diff -puN security/smack/smackfs.c~security-introduce-security=-boot-parameter security/smack/smackfs.c
--- a/security/smack/smackfs.c~security-introduce-security=-boot-parameter
+++ a/security/smack/smackfs.c
@@ -986,12 +986,21 @@ static struct vfsmount *smackfs_mount;
  *
  * register the smackfs
  *
- * Returns 0 unless the registration fails.
+ * Do not register smackfs if Smack wasn't enabled
+ * on boot. We can not put this method normally under the
+ * smack_init() code path since the security subsystem get
+ * initialized before the vfs caches.
+ *
+ * Returns true if we were not chosen on boot or if
+ * we were chosen and filesystem registration succeeded.
  */
 static int __init init_smk_fs(void)
 {
 	int err;
 
+	if (!security_module_enable(&smack_ops))
+		return 0;
+
 	err = register_filesystem(&smk_fs_type);
 	if (!err) {
 		smackfs_mount = kern_mount(&smk_fs_type);
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-kvm.patch
git-security-testing.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch

