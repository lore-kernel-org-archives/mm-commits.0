From: akpm@linux-foundation.org
Subject: + fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr.patch added to -mm tree
Date: Mon, 02 Mar 2015 14:22:20 -0800
Message-ID: <54f4e29c.NNtPfFtvJObQDqSZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbbCBWWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 17:22:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfsplus: move xattr_name allocation in hfsplus_getxattr()
has been added to the -mm tree.  Its filename is
     fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr.patch

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
Subject: fs/hfsplus: move xattr_name allocation in hfsplus_getxattr()

security/trusted/user/osx getxattr did the same
xattr_name initialization. Move that operation in hfsplus_getxattr().

Tested with security/trusted/user getfattr/setfattr

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c          |   38 +++++++++++++++++++++++-----------
 fs/hfsplus/xattr.h          |   12 +++-------
 fs/hfsplus/xattr_security.c |   19 ++---------------
 fs/hfsplus/xattr_trusted.c  |   19 ++---------------
 fs/hfsplus/xattr_user.c     |   17 +--------------
 5 files changed, 38 insertions(+), 67 deletions(-)

diff -puN fs/hfsplus/xattr.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr
+++ a/fs/hfsplus/xattr.c
@@ -560,6 +560,30 @@ failed_getxattr_init:
 	return res;
 }
 
+ssize_t hfsplus_getxattr(struct dentry *dentry, const char *name,
+			 void *value, size_t size,
+			 const char *prefix, size_t prefixlen)
+{
+	int res;
+	char *xattr_name;
+
+	if (!strcmp(name, ""))
+		return -EINVAL;
+
+	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
+			     GFP_KERNEL);
+	if (!xattr_name)
+		return -ENOMEM;
+
+	strcpy(xattr_name, prefix);
+	strcpy(xattr_name + prefixlen, name);
+
+	res = __hfsplus_getxattr(dentry->d_inode, xattr_name, value, size);
+	kfree(xattr_name);
+	return res;
+
+}
+
 static inline int can_list(const char *xattr_name)
 {
 	if (!xattr_name)
@@ -806,9 +830,6 @@ end_removexattr:
 static int hfsplus_osx_getxattr(struct dentry *dentry, const char *name,
 					void *buffer, size_t size, int type)
 {
-	char *xattr_name;
-	int res;
-
 	if (!strcmp(name, ""))
 		return -EINVAL;
 
@@ -818,16 +839,9 @@ static int hfsplus_osx_getxattr(struct d
 	 */
 	if (is_known_namespace(name))
 		return -EOPNOTSUPP;
-	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN
-		+ XATTR_MAC_OSX_PREFIX_LEN + 1, GFP_KERNEL);
-	if (!xattr_name)
-		return -ENOMEM;
-	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
-	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);
 
-	res = hfsplus_getxattr(dentry, xattr_name, buffer, size);
-	kfree(xattr_name);
-	return res;
+	return hfsplus_getxattr(dentry, name, buffer, size,
+				XATTR_MAC_OSX_PREFIX, XATTR_MAC_OSX_PREFIX_LEN);
 }
 
 static int hfsplus_osx_setxattr(struct dentry *dentry, const char *name,
diff -puN fs/hfsplus/xattr.h~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr fs/hfsplus/xattr.h
--- a/fs/hfsplus/xattr.h~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr
+++ a/fs/hfsplus/xattr.h
@@ -28,15 +28,11 @@ static inline int hfsplus_setxattr(struc
 }
 
 ssize_t __hfsplus_getxattr(struct inode *inode, const char *name,
-			void *value, size_t size);
+			   void *value, size_t size);
 
-static inline ssize_t hfsplus_getxattr(struct dentry *dentry,
-					const char *name,
-					void *value,
-					size_t size)
-{
-	return __hfsplus_getxattr(dentry->d_inode, name, value, size);
-}
+ssize_t hfsplus_getxattr(struct dentry *dentry, const char *name,
+			 void *value, size_t size,
+			 const char *prefix, size_t prefixlen);
 
 ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
diff -puN fs/hfsplus/xattr_security.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr fs/hfsplus/xattr_security.c
--- a/fs/hfsplus/xattr_security.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr
+++ a/fs/hfsplus/xattr_security.c
@@ -16,22 +16,9 @@
 static int hfsplus_security_getxattr(struct dentry *dentry, const char *name,
 					void *buffer, size_t size, int type)
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
-	res = hfsplus_getxattr(dentry, xattr_name, buffer, size);
-	kfree(xattr_name);
-	return res;
+	return hfsplus_getxattr(dentry, name, buffer, size,
+				XATTR_SECURITY_PREFIX,
+				XATTR_SECURITY_PREFIX_LEN);
 }
 
 static int hfsplus_security_setxattr(struct dentry *dentry, const char *name,
diff -puN fs/hfsplus/xattr_trusted.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr fs/hfsplus/xattr_trusted.c
--- a/fs/hfsplus/xattr_trusted.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr
+++ a/fs/hfsplus/xattr_trusted.c
@@ -14,22 +14,9 @@
 static int hfsplus_trusted_getxattr(struct dentry *dentry, const char *name,
 					void *buffer, size_t size, int type)
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
-	res = hfsplus_getxattr(dentry, xattr_name, buffer, size);
-	kfree(xattr_name);
-	return res;
+	return hfsplus_getxattr(dentry, name, buffer, size,
+				XATTR_TRUSTED_PREFIX,
+				XATTR_TRUSTED_PREFIX_LEN);
 }
 
 static int hfsplus_trusted_setxattr(struct dentry *dentry, const char *name,
diff -puN fs/hfsplus/xattr_user.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr fs/hfsplus/xattr_user.c
--- a/fs/hfsplus/xattr_user.c~fs-hfsplus-move-xattr_name-allocation-in-hfsplus_getxattr
+++ a/fs/hfsplus/xattr_user.c
@@ -14,22 +14,9 @@
 static int hfsplus_user_getxattr(struct dentry *dentry, const char *name,
 					void *buffer, size_t size, int type)
 {
-	char *xattr_name;
-	int res;
 
-	if (!strcmp(name, ""))
-		return -EINVAL;
-
-	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
-		GFP_KERNEL);
-	if (!xattr_name)
-		return -ENOMEM;
-	strcpy(xattr_name, XATTR_USER_PREFIX);
-	strcpy(xattr_name + XATTR_USER_PREFIX_LEN, name);
