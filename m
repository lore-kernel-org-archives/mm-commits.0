From: akpm@linux-foundation.org
Subject: [to-be-updated]
 hfsplus-implement-replay-journal-functionality.patch removed from -mm tree
Date: Wed, 05 Feb 2014 15:49:23 -0800
Message-ID: <52f2ce03.lydZg+NUT987IJ5h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaBEXtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 18:49:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: [to-be-updated] hfsplus-implement-replay-journal-functionality.patch removed from -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 15:49:23 -0800


The patch titled
     Subject: hfsplus: implement replay journal functionality
has been removed from the -mm tree.  Its filename was
     hfsplus-implement-replay-journal-functionality.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: implement replay journal functionality

Implement functionality of HFS+ journal replay.

If the journal contains valid transaction then it needs to write them to
disk.  In order to replay the journal, an implementation just loops over
the transactions, copying each individual block in the transaction from
the journal to its proper location on the volume.  Once those blocks have
been flushed to the media (not just the driver!), it may update the
journal header to remove the transactions.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |  218 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 217 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/journal.c~hfsplus-implement-replay-journal-functionality fs/hfsplus/journal.c
--- a/fs/hfsplus/journal.c~hfsplus-implement-replay-journal-functionality
+++ a/fs/hfsplus/journal.c
@@ -678,6 +678,30 @@ static int hfsplus_replay_transaction_bl
 }
 
 static inline
+bool hfsplus_journal_placement_valid(struct hfsplus_journal *jnl)
+{
+	if (JOURNAL_SIZE(jnl->jh) != be64_to_cpu(jnl->jib->size)) {
+		pr_err("corrupted journal header\n");
+		hfs_dbg(JOURNAL, "jh_hdr->size %llu, jib_hdr.size %llu\n",
+			JOURNAL_SIZE(jnl->jh),
+			be64_to_cpu(jnl->jib->size));
+		return false;
+	}
+
+	if (TR_START(jnl->jh) > JOURNAL_SIZE(jnl->jh) ||
+	    LAST_TR_END(jnl->jh) > JOURNAL_SIZE(jnl->jh)) {
+		pr_err("corrupted journal header\n");
+		hfs_dbg(JOURNAL, "start %llu, end %llu, size %llu\n",
+			TR_START(jnl->jh),
+			LAST_TR_END(jnl->jh),
+			JOURNAL_SIZE(jnl->jh));
+		return false;
+	}
+
+	return true;
+}
+
+static inline
 bool hfsplus_journal_empty(struct hfsplus_journal_header *jh)
 {
 	return TR_START(jh) == LAST_TR_END(jh);
@@ -742,7 +766,199 @@ int hfsplus_verify_blhdr(u32 prev_seq_nu
 	return 0;
 }
 
-static int hfsplus_replay_journal(struct super_block *sb);
+/*
+ * hfsplus_replay_journal - replay journal
+ *
+ * @sb: superblock
+ *
+ * If the journal contains valid transaction then it needs
+ * to write them to disk. Return success if it brings the
+ * file system into consistent state. Otherwise, it fails.
+ *
+ * Technical Note TN1150
+ *
+ * In order to replay the journal, an implementation just loops over
+ * the transactions, copying each individual block in the transaction
+ * from the journal to its proper location on the volume. Once those
+ * blocks have been flushed to the media (not just the driver!), it may
+ * update the journal header to remove the transactions.
+ *
+ * Here are the steps to replay the journal:
+ *  (1) Read the volume header into variable vhb. The volume may have
+ *      an HFS wrapper; if so, you will need to use it to determine the
+ *      location of the volume header.
+ *  (2) Test the kHFSVolumeJournaledBit in the attributes field of the
+ *      volume header. If it is not set, there is no journal to replay,
+ *      and you are done.
+ *  (3) Read the journal info block from the allocation block number
+ *      vhb.journalInfoBlock, into variable jib.
+ *  (4) If kJIJournalNeedsInitMask is set in jib.flags, the journal was
+ *      never initialized, so there is no journal to replay.
+ *  (5) Verify that kJIJournalInFSMask is set and kJIJournalOnOtherDeviceMask
+ *      is clear in jib.flags.
+ *  (6) Read the journal header at jib.offset bytes from the start of
+ *      the volume, and place it in variable jhdr.
+ *  (7) If jhdr.start equals jhdr.end, the journal does not have any
+ *      transactions, so there is nothing to replay.
+ *  (8) Set the current offset in the journal (typically a local variable)
+ *      to the start of the journal buffer, jhdr.start.
+ *  (9) While jhdr.start does not equal jhdr.end, perform the following steps:
+ *      (a) Read a block list header of jhdr.blhdr_size bytes from the current
+ *          offset in the journal into variable blhdr.
+ *      (b) For each block in bhdr.binfo[1] to bhdr.binfo[blhdr.num_blocks],
+ *          inclusive, copy bsize bytes from the current offset in the journal
+ *          to sector bnum on the volume (to byte offset bnum*jdhr.jhdr_size).
+ *          Remember that jhdr_size is the size of a sector, in bytes.
+ *      (c) If bhdr.binfo[0].next is zero, you have completed the last block
+ *          list of the current transaction; set jhdr.start to the current
+ *          offset in the journal.
+ *
+ * Remember that the journal is a circular buffer. When reading a block list
+ * header or block from the journal buffer (in the loop described above), you
+ * will need to check whether it wraps around the end of the journal buffer.
+ * If it would extend beyond the end of the journal buffer, you must stop
+ * reading at the end of the journal buffer, and resume reading at the start
+ * of the journal buffer (offset jhdr.jhdr_size bytes from the start of
+ * the journal).
+ *
+ * After replaying an entire transaction (all blocks in a block list,
+ * when bhdr.binfo[0] is zero), or after replaying all transactions,
+ * you may update the value of the start field in the journal header
+ * to the current offset in the journal. This will remove those block
+ * lists from the journal since they have been written to their correct
+ * locations on disk.
+ */
+static int hfsplus_replay_journal(struct super_block *sb)
+{
+	struct hfsplus_journal *jnl = HFSPLUS_SB(sb)->jnl;
+	struct hfsplus_journal_header *jh = jnl->jh;
+	struct hfsplus_blist_desc desc;
+	u32 last_seq_num = 0;
+	int err;
+
+	hfs_dbg(JREPLAY, "try to replay journal\n");
+
+	if (hfsplus_journal_empty(jh)) {
+		hfs_dbg(JREPLAY, "journal is empty, nothing to replay\n");
+		return hfsplus_replay_journal_header(sb);
+	}
+
+	if (!hfsplus_journal_placement_valid(jnl)) {
+		pr_err("invalid start/end offset in journal header\n");
+		return -EIO;
+	}
+
+	err = hfsplus_init_block_list_desc(sb, &desc);
+	if (unlikely(err)) {
+		pr_err("unable to initialize block list descriptor\n");
+		return err;
+	}
+
+	mutex_lock(&jnl->jnl_lock);
+
+	/* Go through transactions */
+	while (!hfsplus_journal_empty(jh)) {
+		struct hfsplus_blhdr *blhdr;
+		struct hfsplus_block_info *binfo;
+		__le64 saved_trans_start = 0;
+		u32 really_used = 0;
+		u32 i;
+
+		if (TR_START(jh) == JOURNAL_SIZE(jh))
+			__hfsplus_wrap_journal(sb);
+
+		hfs_dbg(JREPLAY, "start: %llu, start_sector: %llu\n",
+			TR_START(jh), JOURNAL_OFF_TO_SEC(sb));
+
+		blhdr = hfsplus_get_blhdr(sb, JOURNAL_OFF_TO_SEC(sb), &desc);
+		if (!blhdr) {
+			err = -EIO;
+			goto failed_journal_replay;
+		}
+
+		hfs_dbg(JREPLAY, "num_blocks: %u, bytes_used: %u\n",
+			TR_BLOCKS(blhdr), TR_BYTES(blhdr));
+
+		err = hfsplus_verify_blhdr(last_seq_num, blhdr);
+		if (err)
+			goto failed_journal_replay;
+
+		last_seq_num = TR_SEQ_NUM(blhdr);
+
+		if (need_to_wrap_journal(jh, TR_START(jh), BLHDR_SIZE(jh))) {
+			u32 rest;
+
+			rest = hfsplus_wrap_journal(sb, TR_START(jh),
+							BLHDR_SIZE(jh));
+			le64_add_cpu(&jh->start, rest);
+		} else
+			le64_add_cpu(&jh->start, BLHDR_SIZE(jh));
+
+		really_used += BLHDR_SIZE(jh);
+		saved_trans_start = jh->start;
+
+		/* Check transaction */
+		for (i = 1; i < TR_BLOCKS(blhdr); i++) {
+			binfo = hfsplus_get_binfo(sb, i, &desc);
+			if (!binfo) {
+				pr_err("unable to get binfo[%u]\n", i);
+				err = -EIO;
+				goto failed_journal_replay;
+			}
+
+			err = hfsplus_check_transaction_block(sb, i, &desc);
+			if (err) {
+				pr_err("binfo[%u] is corrupted\n", i);
+				goto failed_journal_replay;
+			}
+
+			really_used += BSIZE(binfo);
+		}
+
+		if (really_used != TR_BYTES(blhdr)) {
+			pr_err("transaction is corrupted\n");
+			hfs_dbg(JREPLAY, "bytes_used: %u, really used: %u\n",
+				TR_BYTES(blhdr), really_used);
+			err = -EIO;
+			goto failed_journal_replay;
+		}
+
+		jh->start = saved_trans_start;
+
+		/* Replay transaction */
+		for (i = 1; i < TR_BLOCKS(blhdr); i++) {
+			binfo = hfsplus_get_binfo(sb, i, &desc);
+			if (!binfo) {
+				pr_err("unable to get binfo[%u]\n", i);
+				err = -EIO;
+				goto failed_journal_replay;
+			}
+
+			err = hfsplus_replay_transaction_block(sb, i, &desc);
+			if (err)
+				goto failed_journal_replay;
+		}
+	}
+
+	if (hfsplus_journal_empty(jh))
+		err = hfsplus_replay_journal_header(sb);
+	else {
+		pr_err("journal replay failed\n");
+		err = -EIO;
+	}
+
+	if (unlikely(err))
+		goto failed_journal_replay;
+
+	mutex_unlock(&jnl->jnl_lock);
+	hfsplus_deinit_block_list_desc(&desc);
+	return 0;
+
+failed_journal_replay:
+	mutex_unlock(&jnl->jnl_lock);
+	hfsplus_deinit_block_list_desc(&desc);
+	return err;
+}
 
 static
 int hfsplus_check_journal_info_block(struct hfsplus_journal_info_block *jib)
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-implement-replay-journal-functionality-fix.patch
hfsplus-integrate-journal-replay-support-into-driver.patch

