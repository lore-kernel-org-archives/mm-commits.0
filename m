From: akpm@linux-foundation.org
Subject: [failures] hfsplus-add-all-necessary-declarations-for-acls-support.patch removed from -mm tree
Date: Fri, 01 Mar 2013 15:47:41 -0800
Message-ID: <20130301234742.5BF495A40AC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:38927 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3CAXrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 18:47:43 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so399137yhr.2
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 15:47:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: add all necessary declarations for ACLs support
has been removed from the -mm tree.  Its filename was
     hfsplus-add-all-necessary-declarations-for-acls-support.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: add all necessary declarations for ACLs support

tAdd adds declaration of all necessary structures that are necessary for
ACLs support, special ACL-related flag for debug output and
dprint_hexdump() macros.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_fs.h  |   14 ++++++++++++--
 fs/hfsplus/hfsplus_raw.h |   26 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-add-all-necessary-declarations-for-acls-support fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-add-all-necessary-declarations-for-acls-support
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -24,6 +24,7 @@
 #define DBG_EXTENT	0x00000020
 #define DBG_BITMAP	0x00000040
 #define DBG_ATTR_MOD	0x00000080
+#define DBG_ACL_MOD	0x00000100
 
 #if 0
 #define DBG_MASK	(DBG_EXTENT|DBG_INODE|DBG_BNODE_MOD)
@@ -33,8 +34,17 @@
 #define DBG_MASK	(0)
 
 #define dprint(flg, fmt, args...) \
-	if (flg & DBG_MASK) \
-		printk(fmt , ## args)
+	do { \
+		if (flg & DBG_MASK) \
+			printk(fmt , ## args); \
+	} while (0)
+
+#define dprint_hexdump(flg, prefix, ptr, size) \
+	do { \
+		if ((flg) & (DBG_MASK)) \
+			(print_hex_dump_bytes((prefix), \
+				(DUMP_PREFIX_NONE), (ptr), (size))); \
+	} while (0)
 
 /* Runtime config options */
 #define HFSPLUS_DEF_CR_TYPE    0x3F3F3F3F  /* '????' */
diff -puN fs/hfsplus/hfsplus_raw.h~hfsplus-add-all-necessary-declarations-for-acls-support fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-add-all-necessary-declarations-for-acls-support
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -382,6 +382,32 @@ struct hfsplus_attr_inline_data {
 	u8 raw_bytes[HFSPLUS_MAX_INLINE_DATA_SIZE];
 } __packed;
 
+#define HFSPLUS_GUID_SIZE 16 /* 128-bit */
+
+/* Access Control List Entry (ACE) */
+struct hfsplus_acl_entry {
+	u8 ace_applicable[HFSPLUS_GUID_SIZE]; /* Apple-style identifier */
+	__be32 ace_flags;
+	__be32 ace_rights;
+} __packed;
+
+/* Access Control List */
+struct hfsplus_acl_record {
+	__be32 acl_entrycount;
+	__be32 acl_flags;
+	struct hfsplus_acl_entry acl_ace[0];
+} __packed;
+
+#define HFSPLUS_FILESEC_MAGIC 0x012cc16d
+
+/* HFS+ File Security information */
+struct hfsplus_filesec {
+	__be32 fsec_magic;
+	u8 fsec_owner[HFSPLUS_GUID_SIZE];
+	u8 fsec_group[HFSPLUS_GUID_SIZE];
+	struct hfsplus_acl_record fsec_acl;
+} __packed;
+
 /* A data record in the attributes tree */
 typedef union {
 	__be32 record_type;
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch
hfsplus-add-all-necessary-declarations-for-acls-support-fix.patch
hfsplus-add-implementation-of-the-acls-support.patch
hfsplus-integrate-of-implemented-acls-support-into-driver.patch

