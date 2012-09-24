From: akpm@linux-foundation.org
Subject: + hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch added to -mm tree
Date: Mon, 24 Sep 2012 15:49:18 -0700
Message-ID: <20120924224919.5676C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:38684 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2IXWtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 18:49:20 -0400
Received: by yenr11 with SMTP id r11so438826yen.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 15:49:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: add on-disk layout declarations related to attributes tree
has been added to the -mm tree.  Its filename is
     hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch

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
Subject: hfsplus: add on-disk layout declarations related to attributes tree

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

1. It was added necessary on-disk layout declarations related to
   Attributes tree into hfsplus_raw.h file.

2. It was added attributes.c file with implementation of functionality
   of manipulation by records in Attributes tree.

3. It was reworked hfsplus_listxattr, hfsplus_getxattr,
   hfsplus_setxattr functions in ioctl.c.  Moreover, it was added
   hfsplus_removexattr method.


This patch:

Add all neccessary on-disk layout declarations related to attributes
file.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_raw.h |   72 ++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 5 deletions(-)

diff -puN fs/hfsplus/hfsplus_raw.h~hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -52,13 +52,21 @@
 typedef __be32 hfsplus_cnid;
 typedef __be16 hfsplus_unichr;
 
+#define HFSPLUS_MAX_STRLEN 255
+#define HFSPLUS_ATTR_MAX_STRLEN 127
+
+#define HFSPLUS_STRING(name, max_len)		\
+struct hfsplus_##name {				\
+	__be16 length;				\
+	hfsplus_unichr unicode[max_len];	\
+} __packed;					\
+
 /* A "string" as used in filenames, etc. */
-struct hfsplus_unistr {
-	__be16 length;
-	hfsplus_unichr unicode[255];
-} __packed;
+HFSPLUS_STRING(unistr, HFSPLUS_MAX_STRLEN)
 
-#define HFSPLUS_MAX_STRLEN 255
+/* A "string" is used in attributes file
+   for name of extended attribute */
+HFSPLUS_STRING(attr_unistr, HFSPLUS_ATTR_MAX_STRLEN)
 
 /* POSIX permissions */
 struct hfsplus_perm {
@@ -291,6 +299,8 @@ struct hfsplus_cat_file {
 /* File attribute bits */
 #define HFSPLUS_FILE_LOCKED		0x0001
 #define HFSPLUS_FILE_THREAD_EXISTS	0x0002
+#define HFSPLUS_XATTR_EXISTS		0x0004
+#define HFSPLUS_ACL_EXISTS		0x0008
 
 /* HFS+ catalog thread (part of a cat_entry) */
 struct hfsplus_cat_thread {
@@ -327,11 +337,63 @@ struct hfsplus_ext_key {
 
 #define HFSPLUS_EXT_KEYLEN	sizeof(struct hfsplus_ext_key)
 
+#define HFSPLUS_XATTR_FINDER_INFO_NAME "com.apple.FinderInfo"
+#define HFSPLUS_XATTR_ACL_NAME "com.apple.system.Security"
+
+#define HFSPLUS_ATTR_INLINE_DATA 0x10
+#define HFSPLUS_ATTR_FORK_DATA   0x20
+#define HFSPLUS_ATTR_EXTENTS     0x30
+
+/* HFS+ attributes tree key */
+struct hfsplus_attr_key {
+	__be16 key_len;
+	__be16 pad;
+	hfsplus_cnid cnid;
+	__be32 start_block;
+	struct hfsplus_attr_unistr key_name;
+} __packed;
+
+#define HFSPLUS_ATTR_KEYLEN	sizeof(struct hfsplus_attr_key)
+
+/* HFS+ fork data attribute */
+struct hfsplus_attr_fork_data {
+	__be32 record_type;
+	__be32 reserved;
+	struct hfsplus_fork_raw the_fork;
+} __packed;
+
+/* HFS+ extension attribute */
+struct hfsplus_attr_extents {
+	__be32 record_type;
+	__be32 reserved;
+	struct hfsplus_extent extents;
+} __packed;
+
+#define HFSPLUS_MAX_INLINE_DATA_SIZE 3802
+
+/* HFS+ attribute inline data */
+struct hfsplus_attr_inline_data {
+	__be32 record_type;
+	__be32 reserved1;
+	u8 reserved2[6];
+	__be16 length;
+	u8 raw_bytes[HFSPLUS_MAX_INLINE_DATA_SIZE];
+} __packed;
+
+/* A data record in the attributes tree */
+typedef union {
+	__be32 record_type;
+	struct hfsplus_attr_fork_data fork_data;
+	struct hfsplus_attr_extents extents;
+	struct hfsplus_attr_inline_data inline_data;
+} __packed hfsplus_attr_entry;
+
 /* HFS+ generic BTree key */
 typedef union {
 	__be16 key_len;
 	struct hfsplus_cat_key cat;
 	struct hfsplus_ext_key ext;
+	struct hfsplus_attr_key attr;
 } __packed hfsplus_btree_key;
 
 #endif
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

