From: akpm@linux-foundation.org
Subject: + xattr-constify-name-member-of-struct-xattr.patch added to -mm
 tree
Date: Thu, 08 Aug 2013 14:21:40 -0700
Message-ID: <52040be4.naVz34BhIwiNKV4E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966594Ab3HHVVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 17:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, serge.hallyn@ubuntu.com, paul@paul-moore.com, penguin-kernel@I-love.SAKURA.ne.jp

Subject: + xattr-constify-name-member-of-struct-xattr.patch added to -mm tree
To: penguin-kernel@I-love.SAKURA.ne.jp,paul@paul-moore.com,serge.hallyn@ubuntu.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 14:21:40 -0700


The patch titled
     Subject: xattr: constify ->name member of "struct xattr"
has been added to the -mm tree.  Its filename is
     xattr-constify-name-member-of-struct-xattr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xattr-constify-name-member-of-struct-xattr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xattr-constify-name-member-of-struct-xattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: xattr: constify ->name member of "struct xattr"

Since everybody sets kstrdup()ed constant string to "struct xattr"->name
but nobody modifies "struct xattr"->name , we can omit kstrdup() and its
failure checking by constifying ->name member of "struct xattr".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Tested-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.h                    |    2 +-
 include/linux/security.h            |    8 ++++----
 include/linux/xattr.h               |    2 +-
 include/uapi/linux/reiserfs_xattr.h |    2 +-
 security/capability.c               |    2 +-
 security/integrity/evm/evm_main.c   |    2 +-
 security/security.c                 |    8 +++-----
 security/selinux/hooks.c            |   17 ++++++-----------
 security/smack/smack_lsm.c          |    9 +++------
 9 files changed, 21 insertions(+), 31 deletions(-)

diff -puN fs/ocfs2/xattr.h~xattr-constify-name-member-of-struct-xattr fs/ocfs2/xattr.h
--- a/fs/ocfs2/xattr.h~xattr-constify-name-member-of-struct-xattr
+++ a/fs/ocfs2/xattr.h
@@ -32,7 +32,7 @@ enum ocfs2_xattr_type {
 
 struct ocfs2_security_xattr_info {
 	int enable;
-	char *name;
+	const char *name;
 	void *value;
 	size_t value_len;
 };
diff -puN include/linux/security.h~xattr-constify-name-member-of-struct-xattr include/linux/security.h
--- a/include/linux/security.h~xattr-constify-name-member-of-struct-xattr
+++ a/include/linux/security.h
@@ -1492,7 +1492,7 @@ struct security_operations {
 	int (*inode_alloc_security) (struct inode *inode);
 	void (*inode_free_security) (struct inode *inode);
 	int (*inode_init_security) (struct inode *inode, struct inode *dir,
-				    const struct qstr *qstr, char **name,
+				    const struct qstr *qstr, const char **name,
 				    void **value, size_t *len);
 	int (*inode_create) (struct inode *dir,
 			     struct dentry *dentry, umode_t mode);
@@ -1770,7 +1770,7 @@ int security_inode_init_security(struct
 				 const struct qstr *qstr,
 				 initxattrs initxattrs, void *fs_data);
 int security_old_inode_init_security(struct inode *inode, struct inode *dir,
-				     const struct qstr *qstr, char **name,
+				     const struct qstr *qstr, const char **name,
 				     void **value, size_t *len);
 int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode);
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
@@ -2094,8 +2094,8 @@ static inline int security_inode_init_se
 static inline int security_old_inode_init_security(struct inode *inode,
 						   struct inode *dir,
 						   const struct qstr *qstr,
-						   char **name, void **value,
-						   size_t *len)
+						   const char **name,
+						   void **value, size_t *len)
 {
 	return -EOPNOTSUPP;
 }
diff -puN include/linux/xattr.h~xattr-constify-name-member-of-struct-xattr include/linux/xattr.h
--- a/include/linux/xattr.h~xattr-constify-name-member-of-struct-xattr
+++ a/include/linux/xattr.h
@@ -31,7 +31,7 @@ struct xattr_handler {
 };
 
 struct xattr {
-	char *name;
+	const char *name;
 	void *value;
 	size_t value_len;
 };
diff -puN include/uapi/linux/reiserfs_xattr.h~xattr-constify-name-member-of-struct-xattr include/uapi/linux/reiserfs_xattr.h
--- a/include/uapi/linux/reiserfs_xattr.h~xattr-constify-name-member-of-struct-xattr
+++ a/include/uapi/linux/reiserfs_xattr.h
@@ -16,7 +16,7 @@ struct reiserfs_xattr_header {
 };
 
 struct reiserfs_security_handle {
-	char *name;
+	const char *name;
 	void *value;
 	size_t length;
 };
diff -puN security/capability.c~xattr-constify-name-member-of-struct-xattr security/capability.c
--- a/security/capability.c~xattr-constify-name-member-of-struct-xattr
+++ a/security/capability.c
@@ -129,7 +129,7 @@ static void cap_inode_free_security(stru
 }
 
 static int cap_inode_init_security(struct inode *inode, struct inode *dir,
-				   const struct qstr *qstr, char **name,
+				   const struct qstr *qstr, const char **name,
 				   void **value, size_t *len)
 {
 	return -EOPNOTSUPP;
diff -puN security/integrity/evm/evm_main.c~xattr-constify-name-member-of-struct-xattr security/integrity/evm/evm_main.c
--- a/security/integrity/evm/evm_main.c~xattr-constify-name-member-of-struct-xattr
+++ a/security/integrity/evm/evm_main.c
@@ -418,7 +418,7 @@ int evm_inode_init_security(struct inode
 
 	evm_xattr->value = xattr_data;
 	evm_xattr->value_len = sizeof(*xattr_data);
-	evm_xattr->name = kstrdup(XATTR_EVM_SUFFIX, GFP_NOFS);
+	evm_xattr->name = XATTR_EVM_SUFFIX;
 	return 0;
 out:
 	kfree(xattr_data);
diff -puN security/security.c~xattr-constify-name-member-of-struct-xattr security/security.c
--- a/security/security.c~xattr-constify-name-member-of-struct-xattr
+++ a/security/security.c
@@ -348,10 +348,10 @@ int security_inode_init_security(struct
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 
-	memset(new_xattrs, 0, sizeof new_xattrs);
 	if (!initxattrs)
 		return security_ops->inode_init_security(inode, dir, qstr,
 							 NULL, NULL, NULL);
+	memset(new_xattrs, 0, sizeof(new_xattrs));
 	lsm_xattr = new_xattrs;
 	ret = security_ops->inode_init_security(inode, dir, qstr,
 						&lsm_xattr->name,
@@ -366,16 +366,14 @@ int security_inode_init_security(struct
 		goto out;
 	ret = initxattrs(inode, new_xattrs, fs_data);
 out:
-	for (xattr = new_xattrs; xattr->name != NULL; xattr++) {
-		kfree(xattr->name);
+	for (xattr = new_xattrs; xattr->value != NULL; xattr++)
 		kfree(xattr->value);
-	}
 	return (ret == -EOPNOTSUPP) ? 0 : ret;
 }
 EXPORT_SYMBOL(security_inode_init_security);
 
 int security_old_inode_init_security(struct inode *inode, struct inode *dir,
-				     const struct qstr *qstr, char **name,
+				     const struct qstr *qstr, const char **name,
 				     void **value, size_t *len)
 {
 	if (unlikely(IS_PRIVATE(inode)))
diff -puN security/selinux/hooks.c~xattr-constify-name-member-of-struct-xattr security/selinux/hooks.c
--- a/security/selinux/hooks.c~xattr-constify-name-member-of-struct-xattr
+++ a/security/selinux/hooks.c
@@ -2587,7 +2587,8 @@ static int selinux_dentry_init_security(
 }
 
 static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
-				       const struct qstr *qstr, char **name,
+				       const struct qstr *qstr,
+				       const char **name,
 				       void **value, size_t *len)
 {
 	const struct task_security_struct *tsec = current_security();
@@ -2595,7 +2596,7 @@ static int selinux_inode_init_security(s
 	struct superblock_security_struct *sbsec;
 	u32 sid, newsid, clen;
 	int rc;
-	char *namep = NULL, *context;
+	char *context;
 
 	dsec = dir->i_security;
 	sbsec = dir->i_sb->s_security;
@@ -2631,19 +2632,13 @@ static int selinux_inode_init_security(s
 	if (!ss_initialized || !(sbsec->flags & SE_SBLABELSUPP))
 		return -EOPNOTSUPP;
 
-	if (name) {
-		namep = kstrdup(XATTR_SELINUX_SUFFIX, GFP_NOFS);
-		if (!namep)
-			return -ENOMEM;
-		*name = namep;
-	}
+	if (name)
+		*name = XATTR_SELINUX_SUFFIX;
 
 	if (value && len) {
 		rc = security_sid_to_context_force(newsid, &context, &clen);
-		if (rc) {
-			kfree(namep);
+		if (rc)
 			return rc;
-		}
 		*value = context;
 		*len = clen;
 	}
diff -puN security/smack/smack_lsm.c~xattr-constify-name-member-of-struct-xattr security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~xattr-constify-name-member-of-struct-xattr
+++ a/security/smack/smack_lsm.c
@@ -582,7 +582,7 @@ static void smack_inode_free_security(st
  * Returns 0 if it all works out, -ENOMEM if there's no memory
  */
 static int smack_inode_init_security(struct inode *inode, struct inode *dir,
-				     const struct qstr *qstr, char **name,
+				     const struct qstr *qstr, const char **name,
 				     void **value, size_t *len)
 {
 	struct inode_smack *issp = inode->i_security;
@@ -591,11 +591,8 @@ static int smack_inode_init_security(str
 	char *dsp = smk_of_inode(dir);
 	int may;
 
-	if (name) {
-		*name = kstrdup(XATTR_SMACK_SUFFIX, GFP_NOFS);
-		if (*name == NULL)
-			return -ENOMEM;
-	}
+	if (name)
+		*name = XATTR_SMACK_SUFFIX;
 
 	if (value) {
 		rcu_read_lock();
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

xattr-constify-name-member-of-struct-xattr.patch
linux-next.patch

