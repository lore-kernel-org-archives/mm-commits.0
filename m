From: akpm@linux-foundation.org
Subject: + xattr-add-missing-consts-to-function-arguments.patch added to -mm tree
Date: Thu, 27 Mar 2008 00:50:29 -0700
Message-ID: <200803270750.m2R7oT7M024354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754765AbYC0HvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 03:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, agruen@suse.de


The patch titled
     xattr: add missing consts to function arguments
has been added to the -mm tree.  Its filename is
     xattr-add-missing-consts-to-function-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xattr: add missing consts to function arguments
From: David Howells <dhowells@redhat.com>

Add missing consts to xattr function arguments.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c                          |   41 +++++++++++------------
 include/linux/security.h            |   46 ++++++++++++++------------
 include/linux/syscalls.h            |   30 +++++++++-------
 include/linux/xattr.h               |    6 +--
 security/commoncap.c                |    6 +--
 security/dummy.c                    |   13 +++----
 security/security.c                 |   12 +++---
 security/selinux/hooks.c            |   14 ++++---
 security/selinux/include/security.h |    2 -
 security/selinux/ss/services.c      |    5 +-
 security/smack/smack_lsm.c          |   12 +++---
 11 files changed, 100 insertions(+), 87 deletions(-)

diff -puN fs/xattr.c~xattr-add-missing-consts-to-function-arguments fs/xattr.c
--- a/fs/xattr.c~xattr-add-missing-consts-to-function-arguments
+++ a/fs/xattr.c
@@ -67,7 +67,7 @@ xattr_permission(struct inode *inode, co
 }
 
 int
-vfs_setxattr(struct dentry *dentry, char *name, void *value,
+vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;
@@ -131,7 +131,7 @@ out_noalloc:
 EXPORT_SYMBOL_GPL(xattr_getsecurity);
 
 ssize_t
-vfs_getxattr(struct dentry *dentry, char *name, void *value, size_t size)
+vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -187,7 +187,7 @@ vfs_listxattr(struct dentry *d, char *li
 EXPORT_SYMBOL_GPL(vfs_listxattr);
 
 int
-vfs_removexattr(struct dentry *dentry, char *name)
+vfs_removexattr(struct dentry *dentry, const char *name)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -218,7 +218,7 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  * Extended attribute SET operations
  */
 static long
-setxattr(struct dentry *d, char __user *name, void __user *value,
+setxattr(struct dentry *d, const char __user *name, const void __user *value,
 	 size_t size, int flags)
 {
 	int error;
@@ -252,8 +252,8 @@ setxattr(struct dentry *d, char __user *
 }
 
 asmlinkage long
-sys_setxattr(char __user *path, char __user *name, void __user *value,
-	     size_t size, int flags)
+sys_setxattr(const char __user *path, const char __user *name,
+	     const void __user *value, size_t size, int flags)
 {
 	struct nameidata nd;
 	int error;
@@ -271,8 +271,8 @@ sys_setxattr(char __user *path, char __u
 }
 
 asmlinkage long
-sys_lsetxattr(char __user *path, char __user *name, void __user *value,
-	      size_t size, int flags)
+sys_lsetxattr(const char __user *path, const char __user *name,
+	      const void __user *value, size_t size, int flags)
 {
 	struct nameidata nd;
 	int error;
@@ -290,7 +290,7 @@ sys_lsetxattr(char __user *path, char __
 }
 
 asmlinkage long
-sys_fsetxattr(int fd, char __user *name, void __user *value,
+sys_fsetxattr(int fd, const char __user *name, const void __user *value,
 	      size_t size, int flags)
 {
 	struct file *f;
@@ -316,7 +316,8 @@ out_fput:
  * Extended attribute GET operations
  */
 static ssize_t
-getxattr(struct dentry *d, char __user *name, void __user *value, size_t size)
+getxattr(struct dentry *d, const char __user *name, void __user *value,
+	 size_t size)
 {
 	ssize_t error;
 	void *kvalue = NULL;
@@ -350,8 +351,8 @@ getxattr(struct dentry *d, char __user *
 }
 
 asmlinkage ssize_t
-sys_getxattr(char __user *path, char __user *name, void __user *value,
-	     size_t size)
+sys_getxattr(const char __user *path, const char __user *name,
+	     void __user *value, size_t size)
 {
 	struct nameidata nd;
 	ssize_t error;
@@ -365,7 +366,7 @@ sys_getxattr(char __user *path, char __u
 }
 
 asmlinkage ssize_t
-sys_lgetxattr(char __user *path, char __user *name, void __user *value,
+sys_lgetxattr(const char __user *path, const char __user *name, void __user *value,
 	      size_t size)
 {
 	struct nameidata nd;
@@ -380,7 +381,7 @@ sys_lgetxattr(char __user *path, char __
 }
 
 asmlinkage ssize_t
-sys_fgetxattr(int fd, char __user *name, void __user *value, size_t size)
+sys_fgetxattr(int fd, const char __user *name, void __user *value, size_t size)
 {
 	struct file *f;
 	ssize_t error = -EBADF;
@@ -425,7 +426,7 @@ listxattr(struct dentry *d, char __user 
 }
 
 asmlinkage ssize_t
-sys_listxattr(char __user *path, char __user *list, size_t size)
+sys_listxattr(const char __user *path, char __user *list, size_t size)
 {
 	struct nameidata nd;
 	ssize_t error;
@@ -439,7 +440,7 @@ sys_listxattr(char __user *path, char __
 }
 
 asmlinkage ssize_t
-sys_llistxattr(char __user *path, char __user *list, size_t size)
+sys_llistxattr(const char __user *path, char __user *list, size_t size)
 {
 	struct nameidata nd;
 	ssize_t error;
@@ -471,7 +472,7 @@ sys_flistxattr(int fd, char __user *list
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(struct dentry *d, char __user *name)
+removexattr(struct dentry *d, const char __user *name)
 {
 	int error;
 	char kname[XATTR_NAME_MAX + 1];
@@ -486,7 +487,7 @@ removexattr(struct dentry *d, char __use
 }
 
 asmlinkage long
-sys_removexattr(char __user *path, char __user *name)
+sys_removexattr(const char __user *path, const char __user *name)
 {
 	struct nameidata nd;
 	int error;
@@ -500,7 +501,7 @@ sys_removexattr(char __user *path, char 
 }
 
 asmlinkage long
-sys_lremovexattr(char __user *path, char __user *name)
+sys_lremovexattr(const char __user *path, const char __user *name)
 {
 	struct nameidata nd;
 	int error;
@@ -514,7 +515,7 @@ sys_lremovexattr(char __user *path, char
 }
 
 asmlinkage long
-sys_fremovexattr(int fd, char __user *name)
+sys_fremovexattr(int fd, const char __user *name)
 {
 	struct file *f;
 	struct dentry *dentry;
diff -puN include/linux/security.h~xattr-add-missing-consts-to-function-arguments include/linux/security.h
--- a/include/linux/security.h~xattr-add-missing-consts-to-function-arguments
+++ a/include/linux/security.h
@@ -55,8 +55,9 @@ extern void cap_capset_set (struct task_
 extern int cap_bprm_set_security (struct linux_binprm *bprm);
 extern void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
-extern int cap_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags);
-extern int cap_inode_removexattr(struct dentry *dentry, char *name);
+extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
+			      const void *value, size_t size, int flags);
+extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
@@ -1360,13 +1361,13 @@ struct security_operations {
 	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
 	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
         void (*inode_delete) (struct inode *inode);
-	int (*inode_setxattr) (struct dentry *dentry, char *name, void *value,
-			       size_t size, int flags);
-	void (*inode_post_setxattr) (struct dentry *dentry, char *name, void *value,
-				     size_t size, int flags);
-	int (*inode_getxattr) (struct dentry *dentry, char *name);
+	int (*inode_setxattr) (struct dentry *dentry, const char *name,
+			       const void *value, size_t size, int flags);
+	void (*inode_post_setxattr) (struct dentry *dentry, const char *name,
+				     const void *value, size_t size, int flags);
+	int (*inode_getxattr) (struct dentry *dentry, const char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
-	int (*inode_removexattr) (struct dentry *dentry, char *name);
+	int (*inode_removexattr) (struct dentry *dentry, const char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
 	int (*inode_getsecurity)(const struct inode *inode, const char *name, void **buffer, bool alloc);
@@ -1631,13 +1632,13 @@ int security_inode_permission(struct ino
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr);
 int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry);
 void security_inode_delete(struct inode *inode);
-int security_inode_setxattr(struct dentry *dentry, char *name,
-			     void *value, size_t size, int flags);
-void security_inode_post_setxattr(struct dentry *dentry, char *name,
-				   void *value, size_t size, int flags);
-int security_inode_getxattr(struct dentry *dentry, char *name);
+int security_inode_setxattr(struct dentry *dentry, const char *name,
+			    const void *value, size_t size, int flags);
+void security_inode_post_setxattr(struct dentry *dentry, const char *name,
+				  const void *value, size_t size, int flags);
+int security_inode_getxattr(struct dentry *dentry, const char *name);
 int security_inode_listxattr(struct dentry *dentry);
-int security_inode_removexattr(struct dentry *dentry, char *name);
+int security_inode_removexattr(struct dentry *dentry, const char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
@@ -2039,17 +2040,21 @@ static inline int security_inode_getattr
 static inline void security_inode_delete (struct inode *inode)
 { }
 
-static inline int security_inode_setxattr (struct dentry *dentry, char *name,
-					   void *value, size_t size, int flags)
+static inline int security_inode_setxattr (struct dentry *dentry,
+					   const char *name, const void *value,
+					   size_t size, int flags)
 {
 	return cap_inode_setxattr(dentry, name, value, size, flags);
 }
 
-static inline void security_inode_post_setxattr (struct dentry *dentry, char *name,
-						 void *value, size_t size, int flags)
+static inline void security_inode_post_setxattr (struct dentry *dentry,
+						 const char *name,
+						 const void *value, size_t size,
+						 int flags)
 { }
 
-static inline int security_inode_getxattr (struct dentry *dentry, char *name)
+static inline int security_inode_getxattr (struct dentry *dentry,
+					   const char *name)
 {
 	return 0;
 }
@@ -2059,7 +2064,8 @@ static inline int security_inode_listxat
 	return 0;
 }
 
-static inline int security_inode_removexattr (struct dentry *dentry, char *name)
+static inline int security_inode_removexattr (struct dentry *dentry,
+					      const char *name)
 {
 	return cap_inode_removexattr(dentry, name);
 }
diff -puN include/linux/syscalls.h~xattr-add-missing-consts-to-function-arguments include/linux/syscalls.h
--- a/include/linux/syscalls.h~xattr-add-missing-consts-to-function-arguments
+++ a/include/linux/syscalls.h
@@ -240,26 +240,28 @@ asmlinkage long sys_truncate64(const cha
 asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length);
 #endif
 
-asmlinkage long sys_setxattr(char __user *path, char __user *name,
-				void __user *value, size_t size, int flags);
-asmlinkage long sys_lsetxattr(char __user *path, char __user *name,
-				void __user *value, size_t size, int flags);
-asmlinkage long sys_fsetxattr(int fd, char __user *name, void __user *value,
-				size_t size, int flags);
-asmlinkage ssize_t sys_getxattr(char __user *path, char __user *name,
+asmlinkage long sys_setxattr(const char __user *path, const char __user *name,
+			     const void __user *value, size_t size, int flags);
+asmlinkage long sys_lsetxattr(const char __user *path, const char __user *name,
+			      const void __user *value, size_t size, int flags);
+asmlinkage long sys_fsetxattr(int fd, const char __user *name,
+			      const void __user *value, size_t size, int flags);
+asmlinkage ssize_t sys_getxattr(const char __user *path, const char __user *name,
 				void __user *value, size_t size);
-asmlinkage ssize_t sys_lgetxattr(char __user *path, char __user *name,
+asmlinkage ssize_t sys_lgetxattr(const char __user *path, const char __user *name,
 				void __user *value, size_t size);
-asmlinkage ssize_t sys_fgetxattr(int fd, char __user *name,
+asmlinkage ssize_t sys_fgetxattr(int fd, const char __user *name,
 				void __user *value, size_t size);
-asmlinkage ssize_t sys_listxattr(char __user *path, char __user *list,
+asmlinkage ssize_t sys_listxattr(const char __user *path, char __user *list,
 				size_t size);
-asmlinkage ssize_t sys_llistxattr(char __user *path, char __user *list,
+asmlinkage ssize_t sys_llistxattr(const char __user *path, char __user *list,
 				size_t size);
 asmlinkage ssize_t sys_flistxattr(int fd, char __user *list, size_t size);
-asmlinkage long sys_removexattr(char __user *path, char __user *name);
-asmlinkage long sys_lremovexattr(char __user *path, char __user *name);
-asmlinkage long sys_fremovexattr(int fd, char __user *name);
+asmlinkage long sys_removexattr(const char __user *path,
+				const char __user *name);
+asmlinkage long sys_lremovexattr(const char __user *path,
+				 const char __user *name);
+asmlinkage long sys_fremovexattr(int fd, const char __user *name);
 
 asmlinkage unsigned long sys_brk(unsigned long brk);
 asmlinkage long sys_mprotect(unsigned long start, size_t len,
diff -puN include/linux/xattr.h~xattr-add-missing-consts-to-function-arguments include/linux/xattr.h
--- a/include/linux/xattr.h~xattr-add-missing-consts-to-function-arguments
+++ a/include/linux/xattr.h
@@ -47,10 +47,10 @@ struct xattr_handler {
 };
 
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
-ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
+ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
-int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
-int vfs_removexattr(struct dentry *, char *);
+int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
+int vfs_removexattr(struct dentry *, const char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
diff -puN security/commoncap.c~xattr-add-missing-consts-to-function-arguments security/commoncap.c
--- a/security/commoncap.c~xattr-add-missing-consts-to-function-arguments
+++ a/security/commoncap.c
@@ -386,8 +386,8 @@ int cap_bprm_secureexec (struct linux_bi
 		current->egid != current->gid);
 }
 
-int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
-		       size_t size, int flags)
+int cap_inode_setxattr(struct dentry *dentry, const char *name,
+		       const void *value, size_t size, int flags)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))
@@ -400,7 +400,7 @@ int cap_inode_setxattr(struct dentry *de
 	return 0;
 }
 
-int cap_inode_removexattr(struct dentry *dentry, char *name)
+int cap_inode_removexattr(struct dentry *dentry, const char *name)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))
diff -puN security/dummy.c~xattr-add-missing-consts-to-function-arguments security/dummy.c
--- a/security/dummy.c~xattr-add-missing-consts-to-function-arguments
+++ a/security/dummy.c
@@ -365,8 +365,8 @@ static void dummy_inode_delete (struct i
 	return;
 }
 
-static int dummy_inode_setxattr (struct dentry *dentry, char *name, void *value,
-				size_t size, int flags)
+static int dummy_inode_setxattr (struct dentry *dentry, const char *name,
+				 const void *value, size_t size, int flags)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
@@ -375,12 +375,13 @@ static int dummy_inode_setxattr (struct 
 	return 0;
 }
 
-static void dummy_inode_post_setxattr (struct dentry *dentry, char *name, void *value,
-				       size_t size, int flags)
+static void dummy_inode_post_setxattr (struct dentry *dentry, const char *name,
+				       const void *value, size_t size,
+				       int flags)
 {
 }
 
-static int dummy_inode_getxattr (struct dentry *dentry, char *name)
+static int dummy_inode_getxattr (struct dentry *dentry, const char *name)
 {
 	return 0;
 }
@@ -390,7 +391,7 @@ static int dummy_inode_listxattr (struct
 	return 0;
 }
 
-static int dummy_inode_removexattr (struct dentry *dentry, char *name)
+static int dummy_inode_removexattr (struct dentry *dentry, const char *name)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
diff -puN security/security.c~xattr-add-missing-consts-to-function-arguments security/security.c
--- a/security/security.c~xattr-add-missing-consts-to-function-arguments
+++ a/security/security.c
@@ -491,23 +491,23 @@ void security_inode_delete(struct inode 
 	security_ops->inode_delete(inode);
 }
 
-int security_inode_setxattr(struct dentry *dentry, char *name,
-			     void *value, size_t size, int flags)
+int security_inode_setxattr(struct dentry *dentry, const char *name,
+			    const void *value, size_t size, int flags)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
 	return security_ops->inode_setxattr(dentry, name, value, size, flags);
 }
 
-void security_inode_post_setxattr(struct dentry *dentry, char *name,
-				   void *value, size_t size, int flags)
+void security_inode_post_setxattr(struct dentry *dentry, const char *name,
+				  const void *value, size_t size, int flags)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return;
 	security_ops->inode_post_setxattr(dentry, name, value, size, flags);
 }
 
-int security_inode_getxattr(struct dentry *dentry, char *name)
+int security_inode_getxattr(struct dentry *dentry, const char *name)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
@@ -521,7 +521,7 @@ int security_inode_listxattr(struct dent
 	return security_ops->inode_listxattr(dentry);
 }
 
-int security_inode_removexattr(struct dentry *dentry, char *name)
+int security_inode_removexattr(struct dentry *dentry, const char *name)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
diff -puN security/selinux/hooks.c~xattr-add-missing-consts-to-function-arguments security/selinux/hooks.c
--- a/security/selinux/hooks.c~xattr-add-missing-consts-to-function-arguments
+++ a/security/selinux/hooks.c
@@ -2610,7 +2610,7 @@ static int selinux_inode_getattr(struct 
 	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
+static int selinux_inode_setotherxattr(struct dentry *dentry, const char *name)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof XATTR_SECURITY_PREFIX - 1)) {
@@ -2629,7 +2629,8 @@ static int selinux_inode_setotherxattr(s
 	return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
 }
 
-static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
+static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
+				  const void *value, size_t size, int flags)
 {
 	struct task_security_struct *tsec = current->security;
 	struct inode *inode = dentry->d_inode;
@@ -2678,8 +2679,9 @@ static int selinux_inode_setxattr(struct
 			    &ad);
 }
 
-static void selinux_inode_post_setxattr(struct dentry *dentry, char *name,
-                                        void *value, size_t size, int flags)
+static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
+                                        const void *value, size_t size,
+					int flags)
 {
 	struct inode *inode = dentry->d_inode;
 	struct inode_security_struct *isec = inode->i_security;
@@ -2702,7 +2704,7 @@ static void selinux_inode_post_setxattr(
 	return;
 }
 
-static int selinux_inode_getxattr (struct dentry *dentry, char *name)
+static int selinux_inode_getxattr (struct dentry *dentry, const char *name)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
@@ -2712,7 +2714,7 @@ static int selinux_inode_listxattr (stru
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_removexattr (struct dentry *dentry, char *name)
+static int selinux_inode_removexattr (struct dentry *dentry, const char *name)
 {
 	if (strcmp(name, XATTR_NAME_SELINUX))
 		return selinux_inode_setotherxattr(dentry, name);
diff -puN security/selinux/include/security.h~xattr-add-missing-consts-to-function-arguments security/selinux/include/security.h
--- a/security/selinux/include/security.h~xattr-add-missing-consts-to-function-arguments
+++ a/security/selinux/include/security.h
@@ -85,7 +85,7 @@ int security_change_sid(u32 ssid, u32 ts
 int security_sid_to_context(u32 sid, char **scontext,
 	u32 *scontext_len);
 
-int security_context_to_sid(char *scontext, u32 scontext_len,
+int security_context_to_sid(const char *scontext, u32 scontext_len,
 	u32 *out_sid);
 
 int security_context_to_sid_default(char *scontext, u32 scontext_len, u32 *out_sid, u32 def_sid);
diff -puN security/selinux/ss/services.c~xattr-add-missing-consts-to-function-arguments security/selinux/ss/services.c
--- a/security/selinux/ss/services.c~xattr-add-missing-consts-to-function-arguments
+++ a/security/selinux/ss/services.c
@@ -682,7 +682,8 @@ out:
 
 }
 
-static int security_context_to_sid_core(char *scontext, u32 scontext_len, u32 *sid, u32 def_sid)
+static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
+					u32 *sid, u32 def_sid)
 {
 	char *scontext2;
 	struct context context;
@@ -808,7 +809,7 @@ out:
  * Returns -%EINVAL if the context is invalid, -%ENOMEM if insufficient
  * memory is available, or 0 on success.
  */
-int security_context_to_sid(char *scontext, u32 scontext_len, u32 *sid)
+int security_context_to_sid(const char *scontext, u32 scontext_len, u32 *sid)
 {
 	return security_context_to_sid_core(scontext, scontext_len,
 	                                    sid, SECSID_NULL);
diff -puN security/smack/smack_lsm.c~xattr-add-missing-consts-to-function-arguments security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~xattr-add-missing-consts-to-function-arguments
+++ a/security/smack/smack_lsm.c
@@ -574,8 +574,8 @@ static int smack_inode_getattr(struct vf
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_setxattr(struct dentry *dentry, char *name,
-				void *value, size_t size, int flags)
+static int smack_inode_setxattr(struct dentry *dentry, const char *name,
+				const void *value, size_t size, int flags)
 {
 	int rc = 0;
 
@@ -604,8 +604,8 @@ static int smack_inode_setxattr(struct d
  * Set the pointer in the inode blob to the entry found
  * in the master label list.
  */
-static void smack_inode_post_setxattr(struct dentry *dentry, char *name,
-				      void *value, size_t size, int flags)
+static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
+				      const void *value, size_t size, int flags)
 {
 	struct inode_smack *isp;
 	char *nsp;
@@ -641,7 +641,7 @@ static void smack_inode_post_setxattr(st
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_getxattr(struct dentry *dentry, char *name)
+static int smack_inode_getxattr(struct dentry *dentry, const char *name)
 {
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
 }
@@ -655,7 +655,7 @@ static int smack_inode_getxattr(struct d
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_removexattr(struct dentry *dentry, char *name)
+static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 {
 	int rc = 0;
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

afs-add-a-maintainers-record-for-afs.patch
afs-prevent-double-cell-registration.patch
git-unionfs.patch
remove-the-macro-get_personality.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
mutex-subsystem-synchro-test-module.patch
xattr-add-missing-consts-to-function-arguments.patch

