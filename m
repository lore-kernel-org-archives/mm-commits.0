From: akpm@linux-foundation.org
Subject: [merged] hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:08 -0800
Message-ID: <20130228201108.BC70B31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:48840 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:09 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so244748yen.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: add on-disk layout declarations related to attributes tree
has been removed from the -mm tree.  Its filename was
     hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: add on-disk layout declarations related to attributes tree

Add all necessary on-disk layout declarations related to attributes file.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_raw.h |   68 +++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/hfsplus_raw.h~hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -52,13 +52,23 @@
 typedef __be32 hfsplus_cnid;
 typedef __be16 hfsplus_unichr;
 
+#define HFSPLUS_MAX_STRLEN 255
+#define HFSPLUS_ATTR_MAX_STRLEN 127
+
 /* A "string" as used in filenames, etc. */
 struct hfsplus_unistr {
 	__be16 length;
-	hfsplus_unichr unicode[255];
+	hfsplus_unichr unicode[HFSPLUS_MAX_STRLEN];
 } __packed;
 
-#define HFSPLUS_MAX_STRLEN 255
+/*
+ * A "string" is used in attributes file
+ * for name of extended attribute
+ */
+struct hfsplus_attr_unistr {
+	__be16 length;
+	hfsplus_unichr unicode[HFSPLUS_ATTR_MAX_STRLEN];
+} __packed;
 
 /* POSIX permissions */
 struct hfsplus_perm {
@@ -291,6 +301,8 @@ struct hfsplus_cat_file {
 /* File attribute bits */
 #define HFSPLUS_FILE_LOCKED		0x0001
 #define HFSPLUS_FILE_THREAD_EXISTS	0x0002
+#define HFSPLUS_XATTR_EXISTS		0x0004
+#define HFSPLUS_ACL_EXISTS		0x0008
 
 /* HFS+ catalog thread (part of a cat_entry) */
 struct hfsplus_cat_thread {
@@ -327,11 +339,63 @@ struct hfsplus_ext_key {
 
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

origin.patch
hfsplus-add-all-necessary-declarations-for-acls-support.patch
hfsplus-add-implementation-of-the-acls-support.patch
hfsplus-integrate-of-implemented-acls-support-into-driver.patch

