From: akpm@linux-foundation.org
Subject: + hfsplus-implement-replay-transactions-block-functionality.patch added to -mm tree
Date: Tue, 04 Feb 2014 14:33:43 -0800
Message-ID: <52f16ac7.yFN3TbcK5EcEAs5N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936014AbaBDWdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:33:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-replay-transactions-block-functionality.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:33:43 -0800


The patch titled
     Subject: hfsplus: implement replay transaction's block functionality
has been added to the -mm tree.  Its filename is
     hfsplus-implement-replay-transactions-block-functionality.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-replay-transactions-block-functionality.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-replay-transactions-block-functionality.patch

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

