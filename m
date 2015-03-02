From: akpm@linux-foundation.org
Subject: + fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr.patch added to -mm tree
Date: Mon, 02 Mar 2015 14:22:22 -0800
Message-ID: <54f4e29e.p025/VG+wiLLnYZF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbbCBWWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 17:22:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfsplus: move xattr_name allocation in hfsplus_setxattr()
has been added to the -mm tree.  Its filename is
     fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus: move xattr_name allocation in hfsplus_setxattr()

security/trusted/user/osx setxattr did the same
xattr_name initialization. Move that operation in hfsplus_setxattr().

Tested with security/trusted/user getfattr/setfattr

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c          |   37 ++++++++++++++++++++++------------
 fs/hfsplus/xattr.h          |    8 ++-----
 fs/hfsplus/xattr_security.c |   19 ++---------------
 fs/hfsplus/xattr_trusted.c  |   18 +---------------
 fs/hfsplus/xattr_user.c     |   18 +---------------
 5 files changed, 35 insertions(+), 65 deletions(-)

diff -puN fs/hfsplus/xattr.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr
+++ a/fs/hfsplus/xattr.c
@@ -424,6 +424,28 @@ static int copy_name(char *buffer, const
 	return len;
 }
 
+int hfsplus_setxattr(struct dentry *dentry, const char *name,
+		     const void *value, size_t size, int flags,
+		     const char *prefix, size_t prefixlen)
+{
+	char *xattr_name;
+	int res;
+
+	if (!strcmp(name, ""))
+		return -EINVAL;
+
+	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
+		GFP_KERNEL);
+	if (!xattr_name)
+		return -ENOMEM;
+	strcpy(xattr_name, prefix);
+	strcpy(xattr_name + prefixlen, name);
+	res = __hfsplus_setxattr(dentry->d_inode, xattr_name, value, size,
+				 flags);
+	kfree(xattr_name);
+	return res;
+}
+
 static ssize_t hfsplus_getxattr_finder_info(struct inode *inode,
 						void *value, size_t size)
 {
@@ -847,9 +869,6 @@ static int hfsplus_osx_getxattr(struct d
 static int hfsplus_osx_setxattr(struct dentry *dentry, const char *name,
 		const void *buffer, size_t size, int flags, int type)
 {
-	char *xattr_name;
-	int res;
-
 	if (!strcmp(name, ""))
 		return -EINVAL;
 
@@ -859,16 +878,10 @@ static int hfsplus_osx_setxattr(struct d
 	 */
 	if (is_known_namespace(name))
 		return -EOPNOTSUPP;
-	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN
-		+ XATTR_MAC_OSX_PREFIX_LEN + 1, GFP_KERNEL);
-	if (!xattr_name)
-		return -ENOMEM;
-	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
-	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);
 
-	res = hfsplus_setxattr(dentry, xattr_name, buffer, size, flags);
-	kfree(xattr_name);
-	return res;
+	return hfsplus_setxattr(dentry, name, buffer, size, flags,
+				XATTR_MAC_OSX_PREFIX,
+				XATTR_MAC_OSX_PREFIX_LEN);
 }
 
 static size_t hfsplus_osx_listxattr(struct dentry *dentry, char *list,
diff -puN fs/hfsplus/xattr.h~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr fs/hfsplus/xattr.h
--- a/fs/hfsplus/xattr.h~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr
+++ a/fs/hfsplus/xattr.h
@@ -21,11 +21,9 @@ extern const struct xattr_handler *hfspl
 int __hfsplus_setxattr(struct inode *inode, const char *name,
 			const void *value, size_t size, int flags);
 
-static inline int hfsplus_setxattr(struct dentry *dentry, const char *name,
-			const void *value, size_t size, int flags)
-{
-	return __hfsplus_setxattr(dentry->d_inode, name, value, size, flags);
-}
+int hfsplus_setxattr(struct dentry *dentry, const char *name,
+				   const void *value, size_t size, int flags,
+				   const char *prefix, size_t prefixlen);
 
 ssize_t __hfsplus_getxattr(struct inode *inode, const char *name,
 			   void *value, size_t size);
diff -puN fs/hfsplus/xattr_security.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr fs/hfsplus/xattr_security.c
--- a/fs/hfsplus/xattr_security.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr
+++ a/fs/hfsplus/xattr_security.c
@@ -24,22 +24,9 @@ static int hfsplus_security_getxattr(str
 static int hfsplus_security_setxattr(struct dentry *dentry, const char *name,
 		const void *buffer, size_t size, int flags, int type)
 {
-	char *xattr_name;
-	int res;
-
-	if (!strcmp(name, ""))
-		return -EINVAL;
-
-	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
-		GFP_KERNEL);
-	if (!xattr_name)
-		return -ENOMEM;
-	strcpy(xattr_name, XATTR_SECURITY_PREFIX);
-	strcpy(xattr_name + XATTR_SECURITY_PREFIX_LEN, name);
-
-	res = hfsplus_setxattr(dentry, xattr_name, buffer, size, flags);
-	kfree(xattr_name);
-	return res;
+	return hfsplus_setxattr(dentry, name, buffer, size, flags,
+				XATTR_SECURITY_PREFIX,
+				XATTR_SECURITY_PREFIX_LEN);
 }
 
 static size_t hfsplus_security_listxattr(struct dentry *dentry, char *list,
diff -puN fs/hfsplus/xattr_trusted.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr fs/hfsplus/xattr_trusted.c
--- a/fs/hfsplus/xattr_trusted.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr
+++ a/fs/hfsplus/xattr_trusted.c
@@ -22,22 +22,8 @@ static int hfsplus_trusted_getxattr(stru
 static int hfsplus_trusted_setxattr(struct dentry *dentry, const char *name,
 		const void *buffer, size_t size, int flags, int type)
 {
-	char *xattr_name;
-	int res;
-
-	if (!strcmp(name, ""))
-		return -EINVAL;
-
-	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
-		GFP_KERNEL);
-	if (!xattr_name)
-		return -ENOMEM;
-	strcpy(xattr_name, XATTR_TRUSTED_PREFIX);
-	strcpy(xattr_name + XATTR_TRUSTED_PREFIX_LEN, name);
-
-	res = hfsplus_setxattr(dentry, xattr_name, buffer, size, flags);
-	kfree(xattr_name);
-	return res;
+	return hfsplus_setxattr(dentry, name, buffer, size, flags,
+				XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN);
 }
 
 static size_t hfsplus_trusted_listxattr(struct dentry *dentry, char *list,
diff -puN fs/hfsplus/xattr_user.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr fs/hfsplus/xattr_user.c
--- a/fs/hfsplus/xattr_user.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_setxattr
+++ a/fs/hfsplus/xattr_user.c
@@ -22,22 +22,8 @@ static int hfsplus_user_getxattr(struct
 static int hfsplus_user_setxattr(struct dentry *dentry, const char *name,
 		const void *buffer, size_t size, int flags, int type)
 {
-	char *xattr_name;
-	int res;
-
-	if (!strcmp(name, ""))
-		return -EINVAL;
-
-	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
-		GFP_KERNEL);
-	if (!xattr_name)
-		return -ENOMEM;
-	strcpy(xattr_name, XATTR_USER_PREFIX);
-	strcpy(xattr_name + XATTR_USER_PREFIX_LEN, name);
