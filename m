From: akpm@linux-foundation.org
Subject: [merged] hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:05 -0800
Message-ID: <20130228201106.0BAA95A4242@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:61151 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:07 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so246323yhr.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: add osx.* prefix for handling namespace of Mac OS X extended attributes
has been removed from the -mm tree.  Its filename was
     hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: add osx.* prefix for handling namespace of Mac OS X extended attributes

hfsplus: reworked support of extended attributes.

Current mainline implementation of hfsplus file system driver treats as
extended attributes only two fields (fdType and fdCreator) of user_info
field in file description record (struct hfsplus_cat_file).  It is
possible to get or set only these two fields as extended attributes.  But
HFS+ treats as com.apple.FinderInfo extended attribute an union of
user_info and finder_info fields as for file (struct hfsplus_cat_file) as
for folder (struct hfsplus_cat_folder).  Moreover, current mainline
implementation of hfsplus file system driver doesn't support special
metadata file - attributes tree.

Mac OS X 10.4 and later support extended attributes by making use of the
HFS+ filesystem Attributes file B*-tree feature which allows for named
forks.  Mac OS X supports only inline extended attributes, limiting their
size to 3802 bytes.  Any regular file may have a list of extended
attributes.  HFS+ supports an arbitrary number of named forks.  Each
attribute is denoted by a name and the associated data.  The name is a
null-terminated Unicode string.  It is possible to list, to get, to set,
and to remove extended attributes from files or directories.

It exists some peculiarity during getting of extended attributes list by
means of getfattr utility.  The getfattr utility expects prefix "user."
before any extended attribute's name.  So, it ignores any names that don't
contained such prefix.  Such behavior of getfattr utility results in
unexpected empty output of extended attributes list even in the case when
file (or folder) contains extended attributes.  It needs to use empty
string as regular expression pattern for names matching (getfattr
--match="").  

For support of extended attributes in HFS+:
1. It was added necessary on-disk layout declarations related to Attributes
   tree into hfsplus_raw.h file.
2. It was added attributes.c file with implementation of functionality of
   manipulation by records in Attributes tree.
3. It was reworked hfsplus_listxattr, hfsplus_getxattr, hfsplus_setxattr
   functions in ioctl.c. Moreover, it was added hfsplus_removexattr method.


This patch:

Add osx.* prefix for handling namespace of Mac OS X extended attributes.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/xattr.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN include/uapi/linux/xattr.h~hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes include/uapi/linux/xattr.h
--- a/include/uapi/linux/xattr.h~hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes
+++ a/include/uapi/linux/xattr.h
@@ -15,19 +15,22 @@
 
 /* Namespaces */
 #define XATTR_OS2_PREFIX "os2."
-#define XATTR_OS2_PREFIX_LEN (sizeof (XATTR_OS2_PREFIX) - 1)
+#define XATTR_OS2_PREFIX_LEN (sizeof(XATTR_OS2_PREFIX) - 1)
+
+#define XATTR_MAC_OSX_PREFIX "osx."
+#define XATTR_MAC_OSX_PREFIX_LEN (sizeof(XATTR_MAC_OSX_PREFIX) - 1)
 
 #define XATTR_SECURITY_PREFIX	"security."
-#define XATTR_SECURITY_PREFIX_LEN (sizeof (XATTR_SECURITY_PREFIX) - 1)
+#define XATTR_SECURITY_PREFIX_LEN (sizeof(XATTR_SECURITY_PREFIX) - 1)
 
 #define XATTR_SYSTEM_PREFIX "system."
-#define XATTR_SYSTEM_PREFIX_LEN (sizeof (XATTR_SYSTEM_PREFIX) - 1)
+#define XATTR_SYSTEM_PREFIX_LEN (sizeof(XATTR_SYSTEM_PREFIX) - 1)
 
 #define XATTR_TRUSTED_PREFIX "trusted."
-#define XATTR_TRUSTED_PREFIX_LEN (sizeof (XATTR_TRUSTED_PREFIX) - 1)
+#define XATTR_TRUSTED_PREFIX_LEN (sizeof(XATTR_TRUSTED_PREFIX) - 1)
 
 #define XATTR_USER_PREFIX "user."
-#define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)
+#define XATTR_USER_PREFIX_LEN (sizeof(XATTR_USER_PREFIX) - 1)
 
 /* Security namespace */
 #define XATTR_EVM_SUFFIX "evm"
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch
hfsplus-add-all-necessary-declarations-for-acls-support.patch
hfsplus-add-implementation-of-the-acls-support.patch
hfsplus-integrate-of-implemented-acls-support-into-driver.patch

