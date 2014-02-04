From: akpm@linux-foundation.org
Subject: + hfsplus-add-necessary-declarations-for-journal-replay.patch
 added to -mm tree
Date: Tue, 04 Feb 2014 14:33:31 -0800
Message-ID: <52f16abb.P67rXmvvoTgbe2px%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933745AbaBDWdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:33:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-add-necessary-declarations-for-journal-replay.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:33:31 -0800


The patch titled
     Subject: hfsplus: add necessary declarations for journal replay
has been added to the -mm tree.  Its filename is
     hfsplus-add-necessary-declarations-for-journal-replay.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-add-necessary-declarations-for-journal-replay.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-add-necessary-declarations-for-journal-replay.patch

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
Subject: hfsplus: add necessary declarations for journal replay

Add necessary declarations of HFS+ journal's on-disk structures,
declaration of structure for journal's object in memory and different
journal related flags.

If HFSPLUS_VOL_JOURNALED is set in the volume header's attributes field,
the volume has a journal.  The journal data stuctures consist of a journal
info block, journal header, and journal buffer.  The journal info block
indicates the location and size of the journal header and journal buffer. 
The journal buffer is the space set aside to hold transactions.  The
journal header describes which part of the journal buffer is active and
contains transactions waiting to be committed.

A single transaction consists of several blocks, including both the data
to be written, and the location where that data is to be written.  This is
represented on disk by a block list header, which describes the number and
sizes of the blocks, immediately followed by the contents of those blocks.

The journal info block (struct hfsplus_journal_info_block) is big-endian
structure.  The rest structures of HFS+ journal (struct
hfsplus_journal_header, struct hfsplus_blhdr, struct hfsplus_block_info)
are little-endian.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_fs.h  |   23 ++++++++++++++++
 fs/hfsplus/hfsplus_raw.h |   53 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-add-necessary-declarations-for-journal-replay fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-add-necessary-declarations-for-journal-replay
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -31,6 +31,11 @@
 #define DBG_BITMAP	0x00000040
 #define DBG_ATTR_MOD	0x00000080
 #define DBG_ACL_MOD	0x00000100
+#define DBG_JOURNAL	0x00000200
+#define DBG_JREPLAY	0x00000400
+#define DBG_JTRANS	0x00000800
+#define DBG_JCOMMIT	0x00001000
+#define DBG_JCHKPT	0x00002000
 
 #if 0
 #define DBG_MASK	(DBG_EXTENT|DBG_INODE|DBG_BNODE_MOD)
@@ -126,6 +131,23 @@ struct hfs_bnode {
 #define HFS_BNODE_DIRTY		3
 #define HFS_BNODE_DELETED	4
 
+/* An HFS+ Journal held in memory */
+struct hfsplus_journal {
+	struct mutex jnl_lock;
+
+	/* Journal info block specific */
+	void *jib_buf;
+	struct hfsplus_journal_info_block *jib;
+
+	/* Journal header specific */
+	void *jh_buf;
+	struct hfsplus_journal_header *jh;
+
+	/* TODO: Pointer of JBD */
+
+	struct super_block *sbp;
+};
+
 /*
  * Attributes file states
  */
@@ -146,6 +168,7 @@ struct hfsplus_sb_info {
 	struct hfsplus_vh *s_vhdr;
 	void *s_backup_vhdr_buf;
 	struct hfsplus_vh *s_backup_vhdr;
+	struct hfsplus_journal *jnl;
 	struct hfs_btree *ext_tree;
 	struct hfs_btree *cat_tree;
 	struct hfs_btree *attr_tree;
diff -puN fs/hfsplus/hfsplus_raw.h~hfsplus-add-necessary-declarations-for-journal-replay fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-add-necessary-declarations-for-journal-replay
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -46,6 +46,7 @@
 #define HFSP_SYMLINK_CREATOR	0x72686170	/* 'rhap' */
 
 #define HFSP_MOUNT_VERSION	0x482b4c78	/* 'H+Lx' */
+#define HFSP_MOUNT_JOURNALED_VERSION 0x4846534A	/* 'HFSJ' */
 
 /* Structures used on disk */
 
@@ -105,7 +106,7 @@ struct hfsplus_vh {
 	__be16 version;
 	__be32 attributes;
 	__be32 last_mount_vers;
-	u32 reserved;
+	__be32 journal_info_block;
 
 	__be32 create_date;
 	__be32 modify_date;
@@ -401,4 +402,54 @@ typedef union {
 	struct hfsplus_attr_key attr;
 } __packed hfsplus_btree_key;
 
+/* HFS+ on-disk journal structures */
+struct hfsplus_journal_info_block {
+#define HFSPLUS_JOURNAL_IN_FS		0x01
+#define HFSPLUS_JOURNAL_ON_OTHER_DEVICE	0x02
+#define HFSPLUS_JOURNAL_NEED_INIT	0x04
+	__be32 flags;
+	__be32 device_signature[8];
+	__be64 offset;
+	__be64 size;
+	u32 reserved[32];
+} __packed;
+
+/* Valid magic and endian value */
+#define HFSPLUS_JOURNAL_HEADER_MAGIC	0x4A4E4C78
+#define HFSPLUS_JOURNAL_HEADER_ENDIAN	0x12345678
+
+/* !!! Litle-endian structure !!! */
+struct hfsplus_journal_header {
+	__le32 magic;
+	__le32 endian;
+	__le64 start;
+	__le64 end;
+	__le64 size; /* Includes the header and the buffer */
+	__le32 blhdr_size;
+	__le32 checksum;
+	__le32 jhdr_size;
+} __packed;
+
+/* !!! Litle-endian structure !!! */
+struct hfsplus_block_info {
+	__le64 bnum;
+	__le32 bsize;
+	union {
+		__le32 checksum;
+		__le32 seq_num; /* only used in binfo[0] */
+	} block;
+} __packed;
+
+/* !!! Litle-endian structure !!! */
+struct hfsplus_blhdr {
+	__le16 max_blocks;
+	__le16 num_blocks;
+	__le32 bytes_used;
+	__le32 checksum;
+#define HFSPLUS_BLHDR_CHECK_CHECKSUMS	0x0001
+#define HFSPLUS_BLHDR_FIRST_HEADER	0x0002
+	__le32 flags;
+	struct hfsplus_block_info binfo[1];
+} __packed;
+
 #endif
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-add-necessary-declarations-for-journal-replay.patch
hfsplus-rework-hfsplus_submit_bio-method.patch
hfsplus-implement-init-destroy-journal-object-functionality.patch
hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag.patch
hfsplus-implement-norecovery-mount-option-support.patch
hfsplus-fix-remount-issue.patch
hfsplus-implement-check-consistency-of-journal-log-file.patch
hfsplus-introduce-descriptor-of-block-list-buffer.patch
hfsplus-implement-get-and-verify-block-list-header-functionality.patch
hfsplus-implement-functionality-of-getting-transactions-block-info.patch
hfsplus-implement-functionality-of-journal-log-wrapping.patch
hfsplus-implement-functionality-of-transactions-block-check.patch
hfsplus-implement-replay-transactions-block-functionality.patch
hfsplus-implement-replay-journal-functionality.patch
hfsplus-integrate-journal-replay-support-into-driver.patch

