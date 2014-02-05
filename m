From: akpm@linux-foundation.org
Subject: [to-be-updated]
 hfsplus-add-necessary-declarations-for-journal-replay.patch removed from
 -mm tree
Date: Wed, 05 Feb 2014 15:48:57 -0800
Message-ID: <52f2cde9.YKk+tTB4f3nkIewv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaBEXs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 18:48:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: [to-be-updated] hfsplus-add-necessary-declarations-for-journal-replay.patch removed from -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 15:48:57 -0800


The patch titled
     Subject: hfsplus: add necessary declarations for journal replay
has been removed from the -mm tree.  Its filename was
     hfsplus-add-necessary-declarations-for-journal-replay.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: add necessary declarations for journal replay

This second version of patchset that implements journal replay
functionality in HFS+ file system driver.

Technical Note TN1150:
"The purpose of the journal is to ensure that when a group of
 related changes are being made, that either all of those changes
 are actually made, or none of them are made. This is done by
 gathering up all of the changes, and storing them in a separate
 place (in the journal). Once the journal copy of the changes is
 completely written to disk, the changes can actually be written
 to their normal locations on disk. If a failure happens at that
 time, the changes can simply be copied from the journal to their
 normal locations. If a failure happens when the changes are being
 written to the journal, but before they are marked complete, then
 all of those changes are ignored."

"A group of related changes is called a transaction. When all of
 the changes of a transaction have been written to their normal
 locations on disk, that transaction has been committed, and is
 removed from the journal. The journal may contain several
 transactions. Copying changes from all transactions to their
 normal locations on disk is called replaying the journal."

"In order to replay the journal, an implementation just loops
 over the transactions, copying each individual block in the
 transaction from the journal to its proper location on the
 volume. Once those blocks have been flushed to the media
 (not just the driver!), it may update the journal header to
 remove the transactions."

"Here are the steps to replay the journal:
  1. Read the volume header into variable vhb. The volume may
     have an HFS wrapper; if so, you will need to use it to
     determine the location of the volume header.
  2. Test the kHFSVolumeJournaledBit in the attributes field of
     the volume header. If it is not set, there is no journal
     to replay, and you are done.
  3. Read the journal info block from the allocation block number
     vhb.journalInfoBlock, into variable jib.
  4. If kJIJournalNeedsInitMask is set in jib.flags, the journal
     was never initialized, so there is no journal to replay.
  5. Verify that kJIJournalInFSMask is set and kJIJournalOnOtherDeviceMask
     is clear in jib.flags.
  6. Read the journal header at jib.offset bytes from the start
     of the volume, and place it in variable jhdr.
  7. If jhdr.start equals jhdr.end, the journal does not have
     any transactions, so there is nothing to replay.
  8. Set the current offset in the journal (typically a local
     variable) to the start of the journal buffer, jhdr.start.
  9. While jhdr.start does not equal jhdr.end, perform the
     following steps:
       1. Read a block list header of jhdr.blhdr_size bytes from
          the current offset in the journal into variable blhdr.
       2. For each block in bhdr.binfo[1] to bhdr.binfo[blhdr.num_blocks],
          inclusive, copy bsize bytes from the current offset in
          the journal to sector bnum on the volume (to byte offset
          bnum*jdhr.jhdr_size). Remember that jhdr_size is the
          size of a sector, in bytes.
       3. If bhdr.binfo[0].next is zero, you have completed the
          last block list of the current transaction; set jhdr.start
          to the current offset in the journal."

It was reworked concept of "force" mount option. It is used to force
write access to volumes that are marked as locked, only. This option
doesn't work for journaled volumes with non-empty journal. HFS+ drive
tries to replay journal and ignores forcing write access in the case of
journal replay failure. It is possible to access HFS+ volume in
read-only mode only for such case. The "force" option is ignored
for the case of "norecovery" option request also.



This patch (of 15):

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
hfsplus-implement-replay-journal-functionality-fix.patch
hfsplus-integrate-journal-replay-support-into-driver.patch

