From: akpm@linux-foundation.org
Subject: - securityfs-do-not-depend-on-config_security.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:42:00 -0700
Message-ID: <200809022042.m82Kg0gU011679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbYIBUnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, chrisw@sous-sol.org, debora@linux.vnet.ibm.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     securityfs: do not depend on CONFIG_SECURITY
has been removed from the -mm tree.  Its filename was
     securityfs-do-not-depend-on-config_security.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: securityfs: do not depend on CONFIG_SECURITY
From: Eric Paris <eparis@redhat.com>

Add a new Kconfig option SECURITYFS which will build securityfs support
but does not require CONFIG_SECURITY.  The only current user of securityfs
does not depend on CONFIG_SECURITY and there is no reason the full LSM
needs to be built to build this fs.

Signed-off-by: Eric Paris <eparis@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/Kconfig |    1 
 include/linux/security.h |   54 ++++++++++++++++++++-----------------
 security/Kconfig         |    8 +++++
 security/Makefile        |    3 +-
 4 files changed, 41 insertions(+), 25 deletions(-)

diff -puN drivers/char/tpm/Kconfig~securityfs-do-not-depend-on-config_security drivers/char/tpm/Kconfig
--- a/drivers/char/tpm/Kconfig~securityfs-do-not-depend-on-config_security
+++ a/drivers/char/tpm/Kconfig
@@ -6,6 +6,7 @@ menuconfig TCG_TPM
 	tristate "TPM Hardware Support"
 	depends on HAS_IOMEM
 	depends on EXPERIMENTAL
+	select SECURITYFS
 	---help---
 	  If you have a TPM security chip in your system, which
 	  implements the Trusted Computing Group's specification,
diff -puN include/linux/security.h~securityfs-do-not-depend-on-config_security include/linux/security.h
--- a/include/linux/security.h~securityfs-do-not-depend-on-config_security
+++ a/include/linux/security.h
@@ -1540,11 +1540,6 @@ struct security_operations {
 extern int security_init(void);
 extern int security_module_enable(struct security_operations *ops);
 extern int register_security(struct security_operations *ops);
-extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
-					     struct dentry *parent, void *data,
-					     const struct file_operations *fops);
-extern struct dentry *securityfs_create_dir(const char *name, struct dentry *parent);
-extern void securityfs_remove(struct dentry *dentry);
 
 /* Security operations */
 int security_ptrace_may_access(struct task_struct *child, unsigned int mode);
@@ -2398,25 +2393,6 @@ static inline int security_netlink_recv(
 	return cap_netlink_recv(skb, cap);
 }
 
-static inline struct dentry *securityfs_create_dir(const char *name,
-					struct dentry *parent)
-{
-	return ERR_PTR(-ENODEV);
-}
-
-static inline struct dentry *securityfs_create_file(const char *name,
-						mode_t mode,
-						struct dentry *parent,
-						void *data,
-						const struct file_operations *fops)
-{
-	return ERR_PTR(-ENODEV);
-}
-
-static inline void securityfs_remove(struct dentry *dentry)
-{
-}
-
 static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 {
 	return -EOPNOTSUPP;
@@ -2780,5 +2756,35 @@ static inline void security_audit_rule_f
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_AUDIT */
 
+#ifdef CONFIG_SECURITYFS
+
+extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
+					     struct dentry *parent, void *data,
+					     const struct file_operations *fops);
+extern struct dentry *securityfs_create_dir(const char *name, struct dentry *parent);
+extern void securityfs_remove(struct dentry *dentry);
+
+#else /* CONFIG_SECURITYFS */
+
+static inline struct dentry *securityfs_create_dir(const char *name,
+						   struct dentry *parent)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct dentry *securityfs_create_file(const char *name,
+						    mode_t mode,
+						    struct dentry *parent,
+						    void *data,
+						    const struct file_operations *fops)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void securityfs_remove(struct dentry *dentry)
+{}
+
+#endif
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff -puN security/Kconfig~securityfs-do-not-depend-on-config_security security/Kconfig
--- a/security/Kconfig~securityfs-do-not-depend-on-config_security
+++ a/security/Kconfig
@@ -51,6 +51,14 @@ config SECURITY
 
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITYFS
+	bool "Enable the securityfs filesystem"
+	help
+	  This will build the securityfs filesystem.  It is currently used by
+	  the TPM bios character driver.  It is not used by SELinux or SMACK.
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY_NETWORK
 	bool "Socket and Networking Security Hooks"
 	depends on SECURITY
diff -puN security/Makefile~securityfs-do-not-depend-on-config_security security/Makefile
--- a/security/Makefile~securityfs-do-not-depend-on-config_security
+++ a/security/Makefile
@@ -10,7 +10,8 @@ subdir-$(CONFIG_SECURITY_SMACK)		+= smac
 obj-y		+= commoncap.o
 
 # Object file lists
-obj-$(CONFIG_SECURITY)			+= security.o capability.o inode.o
+obj-$(CONFIG_SECURITY)			+= security.o capability.o
+obj-$(CONFIG_SECURITYFS)		+= inode.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch

