From: akpm@linux-foundation.org
Subject: [to-be-updated]
 hfsplus-implement-functionality-of-transactions-block-check.patch removed
 from -mm tree
Date: Wed, 05 Feb 2014 15:49:19 -0800
Message-ID: <52f2cdff.ry6dj+rsWMKVwt3m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbaBEXtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 18:49:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: [to-be-updated] hfsplus-implement-functionality-of-transactions-block-check.patch removed from -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 15:49:19 -0800


The patch titled
     Subject: hfsplus: implement functionality of transaction's block check
has been removed from the -mm tree.  Its filename was
     hfsplus-implement-functionality-of-transactions-block-check.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: implement functionality of transaction's block check

A group of related changes is called a transaction.  When all of the
changes of a transaction have been written to their normal locations on
disk, that transaction has been committed, and is removed from the
journal.  The journal may contain several transactions.  Copying changes
from all transactions to their normal locations on disk is called
replaying the journal.

A single transaction consists of several blocks, including both the data
to be written, and the location where that data is to be written.  This is
represented on disk by a block list header, which describes the number and
sizes of the blocks, immediately followed by the contents of those blocks.

This patch implements method of checking description of transaction's
block before replaying of it.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |  100 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff -puN fs/hfsplus/journal.c~hfsplus-implement-functionality-of-transactions-block-check fs/hfsplus/journal.c
--- a/fs/hfsplus/journal.c~hfsplus-implement-functionality-of-transactions-block-check
+++ a/fs/hfsplus/journal.c
@@ -38,6 +38,11 @@
 	(be64_to_cpu(((struct hfsplus_journal *)(jnl))->jib->offset) >> \
 	 HFSPLUS_SB(sb)->alloc_blksz_shift)
 
+#define JOURNAL_OFF_TO_SEC(sb) \
+	(HFSPLUS_SB(sb)->blockoffset + \
+	 ((be64_to_cpu(HFSPLUS_SB(sb)->jnl->jib->offset) + \
+	   le64_to_cpu(HFSPLUS_SB(sb)->jnl->jh->start)) >> \
+	   HFSPLUS_SECTOR_SHIFT))
 #define BLOCK_TO_SEC(sb, blk) \
 	((sector_t)(blk) << \
 	 (HFSPLUS_SB(sb)->alloc_blksz_shift - HFSPLUS_SECTOR_SHIFT))
@@ -490,6 +495,101 @@ struct hfsplus_block_info *hfsplus_get_b
 	return &desc->binfo[diff];
 }
 
+static int hfsplus_check_transaction_block(struct super_block *sb, int i,
+					   struct hfsplus_blist_desc *desc)
+{
+	struct hfsplus_journal *jnl = HFSPLUS_SB(sb)->jnl;
+	struct hfsplus_journal_header *jh = jnl->jh;
+	struct hfsplus_blhdr *blhdr = &desc->blhdr;
+	struct hfsplus_block_info *binfo;
+	sector_t sec;
+	u32 size;
+	u32 checksum = 0;
+
+	hfs_dbg(JREPLAY, "check binfo[%u]\n", i);
+
+	binfo = hfsplus_get_binfo(sb, i, desc);
+	if (!binfo) {
+		pr_err("unable to get binfo[%u]\n", i);
+		return -EIO;
+	}
+
+	if (BNUM(binfo) == ~(u64)0) {
+		hfs_dbg(JREPLAY, "don't add *killed* block %llu\n",
+			BNUM(binfo));
+		return 0; /* don't add "killed" blocks */
+	}
+
+	BUG_ON(BSIZE(binfo) % HFSPLUS_SECTOR_SIZE);
+
+	if ((BSIZE(binfo) / HFSPLUS_SECTOR_SIZE) == 0) {
+		pr_warn("transaction block size is not aligned\n");
+		return -EINVAL;
+	}
+
+	sec = JOURNAL_OFF_TO_SEC(sb);
+	size = BSIZE(binfo);
+	while (size > 0) {
+		void *block_ptr;
+		size_t check_size = HFSPLUS_SECTOR_SIZE;
+		size_t rest_bytes;
+		int err;
+
+		if (need_to_wrap_journal(jh, TR_START(jh), check_size)) {
+			hfsplus_wrap_journal(sb, TR_START(jh), check_size);
+			sec = JOURNAL_OFF_TO_SEC(sb);
+		}
+
+		err = hfsplus_submit_bio(sb, sec, desc->src_buf,
+					 (void **)&block_ptr,
+					 READA, &rest_bytes);
+		if (err) {
+			pr_err("unable to read sector %lu of blist\n", sec);
+			return err;
+		}
+
+		BUG_ON(rest_bytes < HFSPLUS_SECTOR_SIZE);
+
+		if (TR_START(jh) > LAST_TR_END(jh)) {
+			if ((TR_START(jh) + check_size) > JOURNAL_SIZE(jh))
+				err = -EIO;
+		} else if (TR_START(jh) < LAST_TR_END(jh)) {
+			if ((TR_START(jh) + check_size) > LAST_TR_END(jh))
+				err = -EIO;
+		} else /* start == end */
+			err = -EIO;
+
+		if (err) {
+			pr_err("invalid transaction: start %llu, end %llu, journal size %llu, bsize %zu\n",
+				TR_START(jh), LAST_TR_END(jh),
+				JOURNAL_SIZE(jh), check_size);
+			return err;
+		}
+
+		if (NEED_CHECK_CSUM(blhdr)) {
+			checksum = calc_internal_checksum(checksum,
+							  block_ptr,
+							  check_size);
+		}
+
+		size -= check_size;
+		le64_add_cpu(&jh->start, check_size);
+		sec = JOURNAL_OFF_TO_SEC(sb);
+	}
+
+	if (NEED_CHECK_CSUM(blhdr)) {
+		if (HFSPLUS_CHECKSUM(checksum) != binfo->block.checksum) {
+			pr_err("invalid transaction's checksum\n");
+			hfs_dbg(JREPLAY, "calc checksum: %#x, checksum: %#x\n",
+				le32_to_cpu(HFSPLUS_CHECKSUM(checksum)),
+				le32_to_cpu(binfo->block.checksum));
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 static inline
 bool hfsplus_journal_empty(struct hfsplus_journal_header *jh)
 {
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-implement-replay-transactions-block-functionality.patch
hfsplus-implement-replay-journal-functionality.patch
hfsplus-implement-replay-journal-functionality-fix.patch
hfsplus-integrate-journal-replay-support-into-driver.patch

