From: akpm@linux-foundation.org
Subject: + hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch added to -mm tree
Date: Mon, 26 Nov 2012 16:49:12 -0800
Message-ID: <20121127004913.5F6B682004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62324 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab2K0AtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 19:49:15 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so1393072vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 16:49:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: add osx.* prefix for handling namespace of Mac OS X extended attributes
has been added to the -mm tree.  Its filename is
     hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/xattr.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/uapi/linux/xattr.h~hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes include/uapi/linux/xattr.h
--- a/include/uapi/linux/xattr.h~hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes
+++ a/include/uapi/linux/xattr.h
@@ -17,6 +17,9 @@
 #define XATTR_OS2_PREFIX "os2."
 #define XATTR_OS2_PREFIX_LEN (sizeof (XATTR_OS2_PREFIX) - 1)
 
+#define XATTR_MAC_OSX_PREFIX "osx."
+#define XATTR_MAC_OSX_PREFIX_LEN (sizeof (XATTR_MAC_OSX_PREFIX) - 1)
+
 #define XATTR_SECURITY_PREFIX	"security."
 #define XATTR_SECURITY_PREFIX_LEN (sizeof (XATTR_SECURITY_PREFIX) - 1)
 
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

