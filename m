From: akpm@linux-foundation.org
Subject: [to-be-updated]
 hfsplus-implement-replay-transactions-block-functionality.patch removed
 from -mm tree
Date: Wed, 05 Feb 2014 15:49:21 -0800
Message-ID: <52f2ce01.wZHUiD91UAbt5fmU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaBEXtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 18:49:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: [to-be-updated] hfsplus-implement-replay-transactions-block-functionality.patch removed from -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 15:49:21 -0800


The patch titled
     Subject: hfsplus: implement replay transaction's block functionality
has been removed from the -mm tree.  Its filename was
     hfsplus-implement-replay-transactions-block-functionality.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: implement replay transaction's block functionality

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

This patch implements replaying of transaction's block in location is
described by binfo in block list.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |   87 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff -puN fs/hfsplus/journal.c~hfsplus-implement-replay-transactions-block-functionality fs/hfsplus/journal.c
--- a/fs/hfsplus/journal.c~hfsplus-implement-replay-transactions-block-functionality
+++ a/fs/hfsplus/journal.c
@@ -590,6 +590,93 @@ static int hfsplus_check_transaction_blo
 	return 0;
 }
 
+static int hfsplus_replay_transaction_block(struct super_block *sb, int i,
+					    struct hfsplus_blist_desc *desc)
+{
+	struct hfsplus_journal *jnl = HFSPLUS_SB(sb)->jnl;
+	struct hfsplus_journal_header *jh = jnl->jh;
+	struct hfsplus_block_info *binfo;
+	u64 bnum;
+	u32 bsize;
+	sector_t src_sec, dst_sec;
+
+	hfs_dbg(JREPLAY, "replay binfo[%u]\n", i);
+
+	binfo = hfsplus_get_binfo(sb, i, desc);
+	if (!binfo) {
+		pr_err("unable to get binfo[%u]\n", i);
+		return -EIO;
+	}
+
+	bnum = BNUM(binfo);
+	bsize = BSIZE(binfo);
+
+	hfs_dbg(JREPLAY, "bnum: %llu, bsize: %u\n", bnum, bsize);
+
+	if (bnum == ~(u64)0) {
+		hfs_dbg(JREPLAY, "don't add *killed* block %llu\n", bnum);
+		return 0; /* don't add "killed" blocks */
+	}
+
+	src_sec = JOURNAL_OFF_TO_SEC(sb);
+	dst_sec = HFSPLUS_SB(sb)->blockoffset + bnum;
+
+	hfs_dbg(JREPLAY, "dst_sec: %lu, bsize: %u\n",
+		dst_sec, bsize);
+
+	while (bsize > 0) {
+		size_t buf_size = hfsplus_min_io_size(sb);
+		size_t dst_off = 0;
+		size_t rest_bytes;
+		int err;
+
+		if (dst_sec >= HFSPLUS_SB(sb)->sect_count) {
+			pr_err("replay out of volume %lu\n", dst_sec);
+			return -EIO;
+		}
+
+		while (dst_off < buf_size) {
+			void *src_ptr;
+			size_t copy_size = HFSPLUS_SECTOR_SIZE;
+
+			if (need_to_wrap_journal(jh, TR_START(jh), copy_size)) {
+				hfsplus_wrap_journal(sb, TR_START(jh),
+							copy_size);
+				src_sec = JOURNAL_OFF_TO_SEC(sb);
+			}
+
+			err = hfsplus_submit_bio(sb, src_sec, desc->src_buf,
+						 &src_ptr, READ, &rest_bytes);
+			if (err) {
+				pr_err("unable to read sector %lu of blist\n",
+					src_sec);
+				return err;
+			}
+
+			BUG_ON(rest_bytes < HFSPLUS_SECTOR_SIZE);
+
+			memcpy((void *)((u8 *)desc->dst_buf + dst_off),
+				desc->src_buf, copy_size);
+
+			dst_off += copy_size;
+			bsize -= copy_size;
+			le64_add_cpu(&jh->start, copy_size);
+			src_sec = JOURNAL_OFF_TO_SEC(sb);
+		}
+
+		err = hfsplus_submit_bio(sb, dst_sec, desc->dst_buf, NULL,
+					 WRITE_SYNC, NULL);
+		if (err) {
+			pr_err("unable to replay sector %lu\n", dst_sec);
+			return err;
+		}
+
+		dst_sec += buf_size >> HFSPLUS_SECTOR_SHIFT;
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

hfsplus-implement-replay-journal-functionality.patch
hfsplus-implement-replay-journal-functionality-fix.patch
hfsplus-integrate-journal-replay-support-into-driver.patch

