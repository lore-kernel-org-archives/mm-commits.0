From: akpm@linux-foundation.org
Subject: - security-add-fix-security-kernel-doc.patch removed from -mm tree
Date: Tue, 19 Aug 2008 15:40:20 -0700
Message-ID: <200808192240.m7JMeKdY010639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbYHSWkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 18:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     security: add/fix security kernel-doc
has been removed from the -mm tree.  Its filename was
     security-add-fix-security-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security: add/fix security kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Add security/inode.c functions to the kernel-api docbook.
Use '%' on constants in kernel-doc notation.
Fix several typos/spellos in security function descriptions.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    1 
 security/inode.c                      |   33 +++++++++++-------------
 security/security.c                   |    8 ++---
 3 files changed, 21 insertions(+), 21 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~security-add-fix-security-kernel-doc Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~security-add-fix-security-kernel-doc
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -283,6 +283,7 @@ X!Earch/x86/kernel/mca_32.c
   <chapter id="security">
      <title>Security Framework</title>
 !Isecurity/security.c
+!Esecurity/inode.c
   </chapter>
 
   <chapter id="audit">
diff -puN security/inode.c~security-add-fix-security-kernel-doc security/inode.c
--- a/security/inode.c~security-add-fix-security-kernel-doc
+++ a/security/inode.c
@@ -190,7 +190,7 @@ static int create_by_name(const char *na
  * @name: a pointer to a string containing the name of the file to create.
  * @mode: the permission that the file should have
  * @parent: a pointer to the parent dentry for this file.  This should be a
- *          directory dentry if set.  If this paramater is NULL, then the
+ *          directory dentry if set.  If this parameter is %NULL, then the
  *          file will be created in the root of the securityfs filesystem.
  * @data: a pointer to something that the caller will want to get to later
  *        on.  The inode.i_private pointer will point to this value on
@@ -199,18 +199,18 @@ static int create_by_name(const char *na
  *        this file.
  *
  * This is the basic "create a file" function for securityfs.  It allows for a
- * wide range of flexibility in createing a file, or a directory (if you
+ * wide range of flexibility in creating a file, or a directory (if you
  * want to create a directory, the securityfs_create_dir() function is
- * recommended to be used instead.)
+ * recommended to be used instead).
  *
- * This function will return a pointer to a dentry if it succeeds.  This
+ * This function returns a pointer to a dentry if it succeeds.  This
  * pointer must be passed to the securityfs_remove() function when the file is
  * to be removed (no automatic cleanup happens if your module is unloaded,
- * you are responsible here.)  If an error occurs, NULL will be returned.
+ * you are responsible here).  If an error occurs, %NULL is returned.
  *
- * If securityfs is not enabled in the kernel, the value -ENODEV will be
+ * If securityfs is not enabled in the kernel, the value %-ENODEV is
  * returned.  It is not wise to check for this value, but rather, check for
- * NULL or !NULL instead as to eliminate the need for #ifdef in the calling
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
  * code.
  */
 struct dentry *securityfs_create_file(const char *name, mode_t mode,
@@ -252,19 +252,19 @@ EXPORT_SYMBOL_GPL(securityfs_create_file
  * @name: a pointer to a string containing the name of the directory to
  *        create.
  * @parent: a pointer to the parent dentry for this file.  This should be a
- *          directory dentry if set.  If this paramater is NULL, then the
+ *          directory dentry if set.  If this parameter is %NULL, then the
  *          directory will be created in the root of the securityfs filesystem.
  *
- * This function creates a directory in securityfs with the given name.
+ * This function creates a directory in securityfs with the given @name.
  *
- * This function will return a pointer to a dentry if it succeeds.  This
+ * This function returns a pointer to a dentry if it succeeds.  This
  * pointer must be passed to the securityfs_remove() function when the file is
  * to be removed (no automatic cleanup happens if your module is unloaded,
- * you are responsible here.)  If an error occurs, NULL will be returned.
+ * you are responsible here).  If an error occurs, %NULL will be returned.
  *
- * If securityfs is not enabled in the kernel, the value -ENODEV will be
+ * If securityfs is not enabled in the kernel, the value %-ENODEV is
  * returned.  It is not wise to check for this value, but rather, check for
- * NULL or !NULL instead as to eliminate the need for #ifdef in the calling
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
  * code.
  */
 struct dentry *securityfs_create_dir(const char *name, struct dentry *parent)
@@ -278,16 +278,15 @@ EXPORT_SYMBOL_GPL(securityfs_create_dir)
 /**
  * securityfs_remove - removes a file or directory from the securityfs filesystem
  *
- * @dentry: a pointer to a the dentry of the file or directory to be
- *          removed.
+ * @dentry: a pointer to a the dentry of the file or directory to be removed.
  *
  * This function removes a file or directory in securityfs that was previously
  * created with a call to another securityfs function (like
  * securityfs_create_file() or variants thereof.)
  *
  * This function is required to be called in order for the file to be
- * removed, no automatic cleanup of files will happen when a module is
- * removed, you are responsible here.
+ * removed. No automatic cleanup of files will happen when a module is
+ * removed; you are responsible here.
  */
 void securityfs_remove(struct dentry *dentry)
 {
diff -puN security/security.c~security-add-fix-security-kernel-doc security/security.c
--- a/security/security.c~security-add-fix-security-kernel-doc
+++ a/security/security.c
@@ -82,8 +82,8 @@ __setup("security=", choose_lsm);
  *
  * Return true if:
  *	-The passed LSM is the one chosen by user at boot time,
- *	-or user didsn't specify a specific LSM and we're the first to ask
- *	 for registeration permissoin,
+ *	-or user didn't specify a specific LSM and we're the first to ask
+ *	 for registration permission,
  *	-or the passed LSM is currently loaded.
  * Otherwise, return false.
  */
@@ -101,13 +101,13 @@ int __init security_module_enable(struct
  * register_security - registers a security framework with the kernel
  * @ops: a pointer to the struct security_options that is to be registered
  *
- * This function is to allow a security module to register itself with the
+ * This function allows a security module to register itself with the
  * kernel security subsystem.  Some rudimentary checking is done on the @ops
  * value passed to this function. You'll need to check first if your LSM
  * is allowed to register its @ops by calling security_module_enable(@ops).
  *
  * If there is already a security module registered with the kernel,
- * an error will be returned.  Otherwise 0 is returned on success.
+ * an error will be returned.  Otherwise %0 is returned on success.
  */
 int register_security(struct security_operations *ops)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

documentation-describe-bootmem_debug-kernel-parameter.patch
linux-next.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

