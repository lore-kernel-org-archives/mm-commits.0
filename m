From: akpm@linux-foundation.org
Subject: [merged]
 hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:31:42 -0700
Message-ID: <53960b9e.arRyqXVm37cNXXFr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaFITbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:31:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, sougata@tuxera.com, slava@dubeyko.com, hch@infradead.org, anton@tuxera.com, htl10@users.sourceforge.net

Subject: [merged] hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes.patch removed from -mm tree
To: htl10@users.sourceforge.net,anton@tuxera.com,hch@infradead.org,slava@dubeyko.com,sougata@tuxera.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:31:42 -0700


The patch titled
     Subject: hfsplus: correct usage of HFSPLUS_ATTR_MAX_STRLEN for non-English attributes
has been removed from the -mm tree.  Its filename was
     hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: hfsplus: correct usage of HFSPLUS_ATTR_MAX_STRLEN for non-English attributes

HFSPLUS_ATTR_MAX_STRLEN (=127) is the limit of attribute names for the
number of unicode character (UTF-16BE) storable in the HFS+ file system. 
Almost all the current usage of it is wrong, in relation to NLS to on-disk
conversion.

Except for one use calling hfsplus_asc2uni (which should stay the same)
and its uses in calling hfsplus_uni2asc (which was corrected in the
earlier patch in this series concerning usage of hfsplus_uni2asc), all the
other uses are of the forms:

- char buffer[size]

- bound check: "if (namespace_adjusted_input_length > size) return failure;"

Conversion between on-disk unicode representation and NLS char strings (in
whichever direction) always needs to accommodate the worst-case NLS
conversion, so all char buffers of that size need to have a
NLS_MAX_CHARSET_SIZE x .

The bound checks are all wrong, since they compare nls_length derived from
strlen() to a unicode length limit.

It turns out that all the bound-checks do is to protect hfsplus_asc2uni(),
which can fail if the input is too large.  There is only one usage of it
as far as attributes are concerned, in hfsplus_attr_build_key().  It is in
turn used by hfsplus_find_attr(), hfsplus_create_attr(),
hfsplus_delete_attr().  Thus making sure that errors from
hfsplus_asc2uni() is caught in hfsplus_attr_build_key() and propagated is
sufficient to replace all the bound checks.

Unpropagated errors from hfsplus_asc2uni() in the file catalog code was
addressed recently in an independent patch "hfsplus: fix longname handling"
by Sougata Santra.

Before this patch, trying to set a 55 CJK character (in a UTF-8
locale, > 127/3=42) attribute plus user prefix fails with:

    $ setfattr -n user.`cat testing-string` -v `cat testing-string` \
        testing-string
    setfattr: testing-string: Operation not supported

and retrieving a stored long attributes is particular ugly(!):

    find /mnt/* -type f -exec getfattr -d {} \;
    getfattr: /mnt/testing-string: Input/output error

with console log:
    [268008.389781] hfsplus: unicode conversion failed

After the patch, both of the above works.

FYI, the test attribute string is prepared with:

echo -e -n \
"\xe9\x80\x99\xe6\x98\xaf\xe4\xb8\x80\xe5\x80\x8b\xe9\x9d\x9e\xe5" \
"\xb8\xb8\xe6\xbc\xab\xe9\x95\xb7\xe8\x80\x8c\xe6\xa5\xb5\xe5\x85" \
"\xb6\xe4\xb9\x8f\xe5\x91\xb3\xe5\x92\x8c\xe7\x9b\xb8\xe7\x95\xb6" \
"\xe7\x84\xa1\xe8\xb6\xa3\xe3\x80\x81\xe4\xbb\xa5\xe5\x8f\x8a\xe7" \
"\x84\xa1\xe7\x94\xa8\xe7\x9a\x84\xe3\x80\x81\xe5\x86\x8d\xe5\x8a" \
"\xa0\xe4\xb8\x8a\xe6\xaf\xab\xe7\x84\xa1\xe6\x84\x8f\xe7\xbe\xa9" \
"\xe7\x9a\x84\xe6\x93\xb4\xe5\xb1\x95\xe5\xb1\xac\xe6\x80\xa7\xef" \
"\xbc\x8c\xe8\x80\x8c\xe5\x85\xb6\xe5\x94\xaf\xe4\xb8\x80\xe5\x89" \
"\xb5\xe5\xbb\xba\xe7\x9b\xae\xe7\x9a\x84\xe5\x83\x85\xe6\x98\xaf" \
"\xe7\x82\xba\xe4\xba\x86\xe6\xb8\xac\xe8\xa9\xa6\xe4\xbd\x9c\xe7" \
"\x94\xa8\xe3\x80\x82" | tr -d ' '

(= "pointlessly long attribute for testing", elaborate Chinese in
UTF-8 enoding).

However, it is not possible to set double the size (110 + 5 is still
under 127) in a UTF-8 locale:

    $setfattr -n user.`cat testing-string testing-string` -v \
        `cat testing-string testing-string` testing-string
    setfattr: testing-string: Numerical result out of range

110 CJK char in UTF-8 is 330 bytes - the generic get/set attribute system
call code in linux/fs/xattr.c imposes a 255 byte limit.  One can use a
combination of iconv to encode content, changing terminal locale for
viewing, and an nls=cp932/cp936/cp949/cp950 mount option to fully use
127-unicode attribute in a double-byte locale.

Also, as an additional information, it is possible to (mis-)use unicode
half-width/full-width forms (U+FFxx) to write attributes which looks like
english but not actually ascii.

Thanks Anton Altaparmakov for reviewing the earlier ideas behind this
change.

[akpm@linux-foundation.org: fix build]
[akpm@linux-foundation.org: fix build]
Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Sougata Santra <sougata@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/attributes.c     |   11 ++-----
 fs/hfsplus/xattr.c          |   40 ++++++++++++++++-----------
 fs/hfsplus/xattr_security.c |   49 +++++++++++++++++++---------------
 fs/hfsplus/xattr_trusted.c  |   32 +++++++++++++---------
 fs/hfsplus/xattr_user.c     |   32 +++++++++++++---------
 5 files changed, 96 insertions(+), 68 deletions(-)

diff -puN fs/hfsplus/attributes.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes fs/hfsplus/attributes.c
--- a/fs/hfsplus/attributes.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes
+++ a/fs/hfsplus/attributes.c
@@ -54,14 +54,11 @@ int hfsplus_attr_build_key(struct super_
 	memset(key, 0, sizeof(struct hfsplus_attr_key));
 	key->attr.cnid = cpu_to_be32(cnid);
 	if (name) {
-		len = strlen(name);
-		if (len > HFSPLUS_ATTR_MAX_STRLEN) {
-			pr_err("invalid xattr name's length\n");
-			return -EINVAL;
-		}
-		hfsplus_asc2uni(sb,
+		int res = hfsplus_asc2uni(sb,
 				(struct hfsplus_unistr *)&key->attr.key_name,
-				HFSPLUS_ATTR_MAX_STRLEN, name, len);
+				HFSPLUS_ATTR_MAX_STRLEN, name, strlen(name));
+		if (res)
+			return res;
 		len = be16_to_cpu(key->attr.key_name.length);
 	} else {
 		key->attr.key_name.length = 0;
diff -puN fs/hfsplus/xattr.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes
+++ a/fs/hfsplus/xattr.c
@@ -806,47 +806,55 @@ end_removexattr:
 static int hfsplus_osx_getxattr(struct dentry *dentry, const char *name,
 					void *buffer, size_t size, int type)
 {
-	char xattr_name[HFSPLUS_ATTR_MAX_STRLEN +
-				XATTR_MAC_OSX_PREFIX_LEN + 1] = {0};
-	size_t len = strlen(name);
+	char *xattr_name;
+	int res;
 
 	if (!strcmp(name, ""))
 		return -EINVAL;
 
-	if (len > HFSPLUS_ATTR_MAX_STRLEN)
-		return -EOPNOTSUPP;
-
 	/*
 	 * Don't allow retrieving properly prefixed attributes
 	 * by prepending them with "osx."
 	 */
 	if (is_known_namespace(name))
 		return -EOPNOTSUPP;
-
-	return hfsplus_getxattr(dentry, xattr_name, buffer, size);
+	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN
+		+ XATTR_MAC_OSX_PREFIX_LEN + 1, GFP_KERNEL);
+	if (!xattr_name)
+		return -ENOMEM;
+	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
+	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);
+
+	res = hfsplus_getxattr(dentry, xattr_name, buffer, size);
+	kfree(xattr_name);
+	return res;
 }
 
 static int hfsplus_osx_setxattr(struct dentry *dentry, const char *name,
 		const void *buffer, size_t size, int flags, int type)
 {
-	char xattr_name[HFSPLUS_ATTR_MAX_STRLEN +
-				XATTR_MAC_OSX_PREFIX_LEN + 1] = {0};
-	size_t len = strlen(name);
+	char *xattr_name;
+	int res;
 
 	if (!strcmp(name, ""))
 		return -EINVAL;
 
-	if (len > HFSPLUS_ATTR_MAX_STRLEN)
-		return -EOPNOTSUPP;
-
 	/*
 	 * Don't allow setting properly prefixed attributes
 	 * by prepending them with "osx."
 	 */
 	if (is_known_namespace(name))
 		return -EOPNOTSUPP;
-
-	return hfsplus_setxattr(dentry, xattr_name, buffer, size, flags);
+	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN
+		+ XATTR_MAC_OSX_PREFIX_LEN + 1, GFP_KERNEL);
+	if (!xattr_name)
+		return -ENOMEM;
+	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
+	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);
+
+	res = hfsplus_setxattr(dentry, xattr_name, buffer, size, flags);
+	kfree(xattr_name);
+	return res;
 }
 
 static size_t hfsplus_osx_listxattr(struct dentry *dentry, char *list,
diff -puN fs/hfsplus/xattr_security.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes fs/hfsplus/xattr_security.c
--- a/fs/hfsplus/xattr_security.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes
+++ a/fs/hfsplus/xattr_security.c
@@ -7,6 +7,8 @@
  */
 
 #include <linux/security.h>
+#include <linux/nls.h>
+
 #include "hfsplus_fs.h"
 #include "xattr.h"
 #include "acl.h"
@@ -14,37 +16,43 @@
 static int hfsplus_security_getxattr(struct dentry *dentry, const char *name,
 					void *buffer, size_t size, int type)
 {
-	char xattr_name[HFSPLUS_ATTR_MAX_STRLEN + 1] = {0};
-	size_t len = strlen(name);
+	char *xattr_name;
+	int res;
 
 	if (!strcmp(name, ""))
 		return -EINVAL;
 
-	if (len + XATTR_SECURITY_PREFIX_LEN > HFSPLUS_ATTR_MAX_STRLEN)
-		return -EOPNOTSUPP;
-
+	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
+		GFP_KERNEL);
+	if (!xattr_name)
+		return -ENOMEM;
 	strcpy(xattr_name, XATTR_SECURITY_PREFIX);
 	strcpy(xattr_name + XATTR_SECURITY_PREFIX_LEN, name);
 
-	return hfsplus_getxattr(dentry, xattr_name, buffer, size);
+	res = hfsplus_getxattr(dentry, xattr_name, buffer, size);
+	kfree(xattr_name);
+	return res;
 }
 
 static int hfsplus_security_setxattr(struct dentry *dentry, const char *name,
 		const void *buffer, size_t size, int flags, int type)
 {
-	char xattr_name[HFSPLUS_ATTR_MAX_STRLEN + 1] = {0};
-	size_t len = strlen(name);
+	char *xattr_name;
+	int res;
 
 	if (!strcmp(name, ""))
 		return -EINVAL;
 
-	if (len + XATTR_SECURITY_PREFIX_LEN > HFSPLUS_ATTR_MAX_STRLEN)
-		return -EOPNOTSUPP;
-
+	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
+		GFP_KERNEL);
+	if (!xattr_name)
+		return -ENOMEM;
 	strcpy(xattr_name, XATTR_SECURITY_PREFIX);
 	strcpy(xattr_name + XATTR_SECURITY_PREFIX_LEN, name);
 
-	return hfsplus_setxattr(dentry, xattr_name, buffer, size, flags);
+	res = hfsplus_setxattr(dentry, xattr_name, buffer, size, flags);
+	kfree(xattr_name);
+	return res;
 }
 
 static size_t hfsplus_security_listxattr(struct dentry *dentry, char *list,
@@ -62,31 +70,30 @@ static int hfsplus_initxattrs(struct ino
 				void *fs_info)
 {
 	const struct xattr *xattr;
-	char xattr_name[HFSPLUS_ATTR_MAX_STRLEN + 1] = {0};
-	size_t xattr_name_len;
+	char *xattr_name;
 	int err = 0;
 
+	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
+		GFP_KERNEL);
+	if (!xattr_name)
+		return -ENOMEM;
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
-		xattr_name_len = strlen(xattr->name);
 
-		if (xattr_name_len == 0)
+		if (!strcmp(xattr->name, ""))
 			continue;
 
-		if (xattr_name_len + XATTR_SECURITY_PREFIX_LEN >
-				HFSPLUS_ATTR_MAX_STRLEN)
-			return -EOPNOTSUPP;
-
 		strcpy(xattr_name, XATTR_SECURITY_PREFIX);
 		strcpy(xattr_name +
 			XATTR_SECURITY_PREFIX_LEN, xattr->name);
 		memset(xattr_name +
-			XATTR_SECURITY_PREFIX_LEN + xattr_name_len, 0, 1);
+			XATTR_SECURITY_PREFIX_LEN + strlen(xattr->name), 0, 1);
 
 		err = __hfsplus_setxattr(inode, xattr_name,
 					xattr->value, xattr->value_len, 0);
 		if (err)
 			break;
 	}
+	kfree(xattr_name);
 	return err;
 }
 
diff -puN fs/hfsplus/xattr_trusted.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes fs/hfsplus/xattr_trusted.c
--- a/fs/hfsplus/xattr_trusted.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes
+++ a/fs/hfsplus/xattr_trusted.c
@@ -6,43 +6,51 @@
  * Handler for trusted extended attributes.
  */
 
+#include <linux/nls.h>
+
 #include "hfsplus_fs.h"
 #include "xattr.h"
 
 static int hfsplus_trusted_getxattr(struct dentry *dentry, const char *name,
 					void *buffer, size_t size, int type)
 {
-	char xattr_name[HFSPLUS_ATTR_MAX_STRLEN + 1] = {0};
-	size_t len = strlen(name);
+	char *xattr_name;
+	int res;
 
 	if (!strcmp(name, ""))
 		return -EINVAL;
 
-	if (len + XATTR_TRUSTED_PREFIX_LEN > HFSPLUS_ATTR_MAX_STRLEN)
-		return -EOPNOTSUPP;
-
+	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
+		GFP_KERNEL);
+	if (!xattr_name)
+		return -ENOMEM;
 	strcpy(xattr_name, XATTR_TRUSTED_PREFIX);
 	strcpy(xattr_name + XATTR_TRUSTED_PREFIX_LEN, name);
 
-	return hfsplus_getxattr(dentry, xattr_name, buffer, size);
+	res = hfsplus_getxattr(dentry, xattr_name, buffer, size);
+	kfree(xattr_name);
+	return res;
 }
 
 static int hfsplus_trusted_setxattr(struct dentry *dentry, const char *name,
 		const void *buffer, size_t size, int flags, int type)
 {
-	char xattr_name[HFSPLUS_ATTR_MAX_STRLEN + 1] = {0};
-	size_t len = strlen(name);
+	char *xattr_name;
+	int res;
 
 	if (!strcmp(name, ""))
 		return -EINVAL;
 
-	if (len + XATTR_TRUSTED_PREFIX_LEN > HFSPLUS_ATTR_MAX_STRLEN)
-		return -EOPNOTSUPP;
-
+	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
+		GFP_KERNEL);
+	if (!xattr_name)
+		return -ENOMEM;
 	strcpy(xattr_name, XATTR_TRUSTED_PREFIX);
 	strcpy(xattr_name + XATTR_TRUSTED_PREFIX_LEN, name);
 
-	return hfsplus_setxattr(dentry, xattr_name, buffer, size, flags);
+	res = hfsplus_setxattr(dentry, xattr_name, buffer, size, flags);
+	kfree(xattr_name);
+	return res;
 }
 
 static size_t hfsplus_trusted_listxattr(struct dentry *dentry, char *list,
diff -puN fs/hfsplus/xattr_user.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes fs/hfsplus/xattr_user.c
--- a/fs/hfsplus/xattr_user.c~hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes
+++ a/fs/hfsplus/xattr_user.c
@@ -6,43 +6,51 @@
  * Handler for user extended attributes.
  */
 
+#include <linux/nls.h>
+
 #include "hfsplus_fs.h"
 #include "xattr.h"
 
 static int hfsplus_user_getxattr(struct dentry *dentry, const char *name,
 					void *buffer, size_t size, int type)
 {
-	char xattr_name[HFSPLUS_ATTR_MAX_STRLEN + 1] = {0};
-	size_t len = strlen(name);
+	char *xattr_name;
+	int res;
 
 	if (!strcmp(name, ""))
 		return -EINVAL;
 
-	if (len + XATTR_USER_PREFIX_LEN > HFSPLUS_ATTR_MAX_STRLEN)
-		return -EOPNOTSUPP;
-
+	xattr_name = kmalloc(NLS_MAX_CHARSET_SIZE * HFSPLUS_ATTR_MAX_STRLEN + 1,
+		GFP_KERNEL);
+	if (!xattr_name)
+		return -ENOMEM;
 	strcpy(xattr_name, XATTR_USER_PREFIX);
 	strcpy(xattr_name + XATTR_USER_PREFIX_LEN, name);
 
-	return hfsplus_getxattr(dentry, xattr_name, buffer, size);
+	res = hfsplus_getxattr(dentry, xattr_name, buffer, size);
+	kfree(xattr_name);
+	return res;
 }
 
 static int hfsplus_user_setxattr(struct dentry *dentry, const char *name,
 		const void *buffer, size_t size, int flags, int type)
 {
-	char xattr_name[HFSPLUS_ATTR_MAX_STRLEN + 1] = {0};
-	size_t len = strlen(name);
+	char *xattr_name;
+	int res;
 
 	if (!strcmp(name, ""))
 		return -EINVAL;
 
-	if (len + XATTR_USER_PREFIX_LEN > HFSPLUS_ATTR_MAX_STRLEN)
-		return -EOPNOTSUPP;
