From: akpm@linux-foundation.org
Subject: + hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch added to -mm tree
Date: Mon, 26 Nov 2012 16:50:09 -0800
Message-ID: <20121127005010.9F07520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50144 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab2K0AuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 19:50:13 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so679713bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 16:50:12 -0800 (PST)
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

hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

