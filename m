From: akpm@linux-foundation.org
Subject: - introduce-new-lsm-hooks-where-vfsmount-is-available-update.patch removed from -mm tree
Date: Wed, 29 Oct 2008 14:26:58 -0700
Message-ID: <200810292126.m9TLQw2s022150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679AbYJ2V2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 17:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takedakn@nttdata.co.jp, casey@schaufler-ca.com, crispin@crispincowan.com, haradats@nttdata.co.jp, hch@lst.de, jmorris@namei.org, penguin-kernel@I-love.SAKURA.ne.jp, sds@tycho.nsa.gov


The patch titled
     introduce-new-lsm-hooks-where-vfsmount-is-available update
has been removed from the -mm tree.  Its filename was
     introduce-new-lsm-hooks-where-vfsmount-is-available-update.patch

This patch was dropped because it was folded into introduce-new-lsm-hooks-where-vfsmount-is-available.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce-new-lsm-hooks-where-vfsmount-is-available update
From: Kentaro Takeda <takedakn@nttdata.co.jp>

James Morris wrote:
> I don't see any technical errors in this patch.
Thanks for your review.

> If it is going to be merged, please make a new config option for
> path-based hooks (similar to that for the network hooks), so they can be
> compiled out.
I see, here it is.

Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Toshiharu Harada <haradats@nttdata.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Crispin Cowan <crispin@crispincowan.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |  132 +++++++++++++++++++------------------
 security/Kconfig         |    9 ++
 security/capability.c    |    4 +
 security/security.c      |    2 
 4 files changed, 83 insertions(+), 64 deletions(-)

diff -puN include/linux/security.h~introduce-new-lsm-hooks-where-vfsmount-is-available-update include/linux/security.h
--- a/include/linux/security.h~introduce-new-lsm-hooks-where-vfsmount-is-available-update
+++ a/include/linux/security.h
@@ -1384,6 +1384,7 @@ struct security_operations {
 				   struct super_block *newsb);
 	int (*sb_parse_opts_str) (char *options, struct security_mnt_opts *opts);
 
+#ifdef CONFIG_SECURITY_PATH
 	int (*path_unlink) (struct path *dir, struct dentry *dentry);
 	int (*path_mkdir) (struct path *dir, struct dentry *dentry, int mode);
 	int (*path_rmdir) (struct path *dir, struct dentry *dentry);
@@ -1397,6 +1398,7 @@ struct security_operations {
 			  struct dentry *new_dentry);
 	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
 			    struct path *new_dir, struct dentry *new_dentry);
+#endif
 
 	int (*inode_alloc_security) (struct inode *inode);
 	void (*inode_free_security) (struct inode *inode);
@@ -1659,20 +1661,6 @@ void security_sb_clone_mnt_opts(const st
 				struct super_block *newsb);
 int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts);
 
-int security_path_unlink(struct path *dir, struct dentry *dentry);
-int security_path_mkdir(struct path *dir, struct dentry *dentry, int mode);
-int security_path_rmdir(struct path *dir, struct dentry *dentry);
-int security_path_mknod(struct path *dir, struct dentry *dentry, int mode,
-			unsigned int dev);
-int security_path_truncate(struct path *path, loff_t length,
-			   unsigned int time_attrs, struct file *filp);
-int security_path_symlink(struct path *dir, struct dentry *dentry,
-			  const char *old_name);
-int security_path_link(struct dentry *old_dentry, struct path *new_dir,
-		       struct dentry *new_dentry);
-int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
-			 struct path *new_dir, struct dentry *new_dentry);
-
 int security_inode_alloc(struct inode *inode);
 void security_inode_free(struct inode *inode);
 int security_inode_init_security(struct inode *inode, struct inode *dir,
@@ -1994,56 +1982,6 @@ static inline int security_sb_parse_opts
 	return 0;
 }
 
-static inline int security_path_unlink(struct path *dir, struct dentry *dentry)
-{
-	return 0;
-}
-
-static inline int security_path_mkdir(struct path *dir, struct dentry *dentry,
-				      int mode)
-{
-	return 0;
-}
-
-static inline int security_path_rmdir(struct path *dir, struct dentry *dentry)
-{
-	return 0;
-}
-
-static inline int security_path_mknod(struct path *dir, struct dentry *dentry,
-				      int mode, unsigned int dev)
-{
-	return 0;
-}
-
-static inline int security_path_truncate(struct path *path, loff_t length,
-					 unsigned int time_attrs,
-					 struct file *filp)
-{
-	return 0;
-}
-
-static inline int security_path_symlink(struct path *dir, struct dentry *dentry,
-					const char *old_name)
-{
-	return 0;
-}
-
-static inline int security_path_link(struct dentry *old_dentry,
-				     struct path *new_dir,
-				     struct dentry *new_dentry)
-{
-	return 0;
-}
-
-static inline int security_path_rename(struct path *old_dir,
-				       struct dentry *old_dentry,
-				       struct path *new_dir,
-				       struct dentry *new_dentry)
-{
-	return 0;
-}
-
 static inline int security_inode_alloc(struct inode *inode)
 {
 	return 0;
@@ -2826,6 +2764,72 @@ static inline void security_skb_classify
 
 #endif	/* CONFIG_SECURITY_NETWORK_XFRM */
 
+#ifdef CONFIG_SECURITY_PATH
+int security_path_unlink(struct path *dir, struct dentry *dentry);
+int security_path_mkdir(struct path *dir, struct dentry *dentry, int mode);
+int security_path_rmdir(struct path *dir, struct dentry *dentry);
+int security_path_mknod(struct path *dir, struct dentry *dentry, int mode,
+			unsigned int dev);
+int security_path_truncate(struct path *path, loff_t length,
+			   unsigned int time_attrs, struct file *filp);
+int security_path_symlink(struct path *dir, struct dentry *dentry,
+			  const char *old_name);
+int security_path_link(struct dentry *old_dentry, struct path *new_dir,
+		       struct dentry *new_dentry);
+int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
+			 struct path *new_dir, struct dentry *new_dentry);
+#else	/* CONFIG_SECURITY_PATH */
+static inline int security_path_unlink(struct path *dir, struct dentry *dentry)
+{
+	return 0;
+}
+
+static inline int security_path_mkdir(struct path *dir, struct dentry *dentry,
+				      int mode)
+{
+	return 0;
+}
+
+static inline int security_path_rmdir(struct path *dir, struct dentry *dentry)
+{
+	return 0;
+}
+
+static inline int security_path_mknod(struct path *dir, struct dentry *dentry,
+				      int mode, unsigned int dev)
+{
+	return 0;
+}
+
+static inline int security_path_truncate(struct path *path, loff_t length,
+					 unsigned int time_attrs,
+					 struct file *filp)
+{
+	return 0;
+}
+
+static inline int security_path_symlink(struct path *dir, struct dentry *dentry,
+					const char *old_name)
+{
+	return 0;
+}
+
+static inline int security_path_link(struct dentry *old_dentry,
+				     struct path *new_dir,
+				     struct dentry *new_dentry)
+{
+	return 0;
+}
+
+static inline int security_path_rename(struct path *old_dir,
+				       struct dentry *old_dentry,
+				       struct path *new_dir,
+				       struct dentry *new_dentry)
+{
+	return 0;
+}
+#endif	/* CONFIG_SECURITY_PATH */
+
 #ifdef CONFIG_KEYS
 #ifdef CONFIG_SECURITY
 
diff -puN security/Kconfig~introduce-new-lsm-hooks-where-vfsmount-is-available-update security/Kconfig
--- a/security/Kconfig~introduce-new-lsm-hooks-where-vfsmount-is-available-update
+++ a/security/Kconfig
@@ -81,6 +81,15 @@ config SECURITY_NETWORK_XFRM
 	  IPSec.
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_PATH
+	bool "Security hooks for pathname based access control"
+	depends on SECURITY
+	help
+	  This enables the security hooks for pathname based access control.
+	  If enabled, a security module can use these hooks to
+	  implement pathname based access controls.
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY_FILE_CAPABILITIES
 	bool "File POSIX Capabilities"
 	default n
diff -puN security/capability.c~introduce-new-lsm-hooks-where-vfsmount-is-available-update security/capability.c
--- a/security/capability.c~introduce-new-lsm-hooks-where-vfsmount-is-available-update
+++ a/security/capability.c
@@ -263,6 +263,7 @@ static void cap_inode_getsecid(const str
 	*secid = 0;
 }
 
+#ifdef CONFIG_SECURITY_PATH
 static int cap_path_mknod(struct path *dir, struct dentry *dentry, int mode,
 			  unsigned int dev)
 {
@@ -307,6 +308,7 @@ static int cap_path_truncate(struct path
 {
 	return 0;
 }
+#endif
 
 static int cap_file_permission(struct file *file, int mask)
 {
@@ -928,6 +930,7 @@ void security_fixup_ops(struct security_
 	set_to_cap_if_null(ops, inode_setsecurity);
 	set_to_cap_if_null(ops, inode_listsecurity);
 	set_to_cap_if_null(ops, inode_getsecid);
+#ifdef CONFIG_SECURITY_PATH
 	set_to_cap_if_null(ops, path_mknod);
 	set_to_cap_if_null(ops, path_mkdir);
 	set_to_cap_if_null(ops, path_rmdir);
@@ -936,6 +939,7 @@ void security_fixup_ops(struct security_
 	set_to_cap_if_null(ops, path_link);
 	set_to_cap_if_null(ops, path_rename);
 	set_to_cap_if_null(ops, path_truncate);
+#endif
 	set_to_cap_if_null(ops, file_permission);
 	set_to_cap_if_null(ops, file_alloc_security);
 	set_to_cap_if_null(ops, file_free_security);
diff -puN security/security.c~introduce-new-lsm-hooks-where-vfsmount-is-available-update security/security.c
--- a/security/security.c~introduce-new-lsm-hooks-where-vfsmount-is-available-update
+++ a/security/security.c
@@ -350,6 +350,7 @@ int security_inode_init_security(struct 
 }
 EXPORT_SYMBOL(security_inode_init_security);
 
+#ifdef CONFIG_SECURITY_PATH
 int security_path_mknod(struct path *path, struct dentry *dentry, int mode,
 			unsigned int dev)
 {
@@ -413,6 +414,7 @@ int security_path_truncate(struct path *
 		return 0;
 	return security_ops->path_truncate(path, length, time_attrs, filp);
 }
+#endif
 
 int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
 {
_

Patches currently in -mm which might be from takedakn@nttdata.co.jp are

introduce-new-lsm-hooks-where-vfsmount-is-available.patch
introduce-new-lsm-hooks-where-vfsmount-is-available-update.patch

