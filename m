From: akpm@linux-foundation.org
Subject: +
 hfsplus-implement-get-and-verify-block-list-header-functionality.patch
 added to -mm tree
Date: Tue, 04 Feb 2014 14:33:39 -0800
Message-ID: <52f16ac3.K7hTjMLCSRlOkBZL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936014AbaBDWdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:33:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-get-and-verify-block-list-header-functionality.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:33:39 -0800


The patch titled
     Subject: hfsplus: implement get and verify block list header functionality
has been added to the -mm tree.  Its filename is
     hfsplus-implement-get-and-verify-block-list-header-functionality.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-get-and-verify-block-list-header-functionality.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-get-and-verify-block-list-header-functionality.patch

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
Subject: hfsplus: implement get and verify block list header functionality

Implement functionality of reading of block list's header from journal log
and veryfing of it.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |  102 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff -puN fs/hfsplus/journal.c~hfsplus-implement-get-and-verify-block-list-header-functionality fs/hfsplus/journal.c
--- a/fs/hfsplus/journal.c~hfsplus-implement-get-and-verify-block-list-header-functionality
+++ a/fs/hfsplus/journal.c
@@ -49,6 +49,18 @@
 #define JHDR_SIZE(jh) \
 	(le32_to_cpu(((struct hfsplus_journal_header *)(jh))->jhdr_size))
 
+#define TR_MAX_BLOCKS(blhdr) \
+	(le16_to_cpu(((struct hfsplus_blhdr *)(blhdr))->max_blocks))
+#define TR_BLOCKS(blhdr) \
+	(le16_to_cpu(((struct hfsplus_blhdr *)(blhdr))->num_blocks))
+#define TR_BYTES(blhdr) \
+	(le32_to_cpu(((struct hfsplus_blhdr *)(blhdr))->bytes_used))
+#define TR_SEQ_NUM(blhdr) \
+	(le32_to_cpu(((struct hfsplus_blhdr *)(blhdr))->binfo[0].block.seq_num))
+#define NEED_CHECK_CSUM(blhdr) \
+	(le32_to_cpu(((struct hfsplus_blhdr *)(blhdr))->flags) & \
+	 HFSPLUS_BLHDR_CHECK_CHECKSUMS)
+
 /*
  * struct hfsplus_blist_desc - descriptor of block list buffer
  * @start_sec: start sector of block list
@@ -295,12 +307,102 @@ static void hfsplus_deinit_block_list_de
 	kfree(desc->dst_buf);
 }
 
+static struct hfsplus_blhdr *hfsplus_get_blhdr(struct super_block *sb,
+						sector_t start_sector,
+						struct hfsplus_blist_desc *desc)
+{
+	struct hfsplus_blhdr *blhdr;
+	int err;
+
+	hfs_dbg(JREPLAY, "get block list header: start_sector %lu\n",
+		start_sector);
+
+	BUG_ON(!desc->blist_buf);
+
+	if (desc->start_sec == start_sector && desc->cur_sec == start_sector)
+		return &desc->blhdr;
+
+	err = hfsplus_submit_bio(sb, start_sector,
+				 desc->blist_buf, (void **)&blhdr, READA,
+				 &desc->available_bytes);
+	if (err) {
+		pr_err("unable to read block list header\n");
+		return NULL;
+	}
+
+	desc->start_sec = start_sector;
+	desc->cur_sec = start_sector;
+	memcpy((void *)&desc->blhdr, (const void *)blhdr, sizeof(*blhdr));
+	desc->binfo = &blhdr->binfo[0];
+
+	return &desc->blhdr;
+}
+
 static inline
 bool hfsplus_journal_empty(struct hfsplus_journal_header *jh)
 {
 	return TR_START(jh) == LAST_TR_END(jh);
 }
 
+static inline
+bool hfsplus_transaction_seq_num_valid(u32 prev_seq_num,
+					struct hfsplus_blhdr *blhdr)
+{
+	if (prev_seq_num != 0) {
+		u32 seq = TR_SEQ_NUM(blhdr);
+
+		if ((seq != 0) && (seq != prev_seq_num) &&
+		    (seq != (prev_seq_num + 1))) {
+			pr_err("transaction seq number %u is invalid\n",
+				TR_SEQ_NUM(blhdr));
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static
+int hfsplus_verify_blhdr(u32 prev_seq_num, struct hfsplus_blhdr *blhdr)
+{
+	__le32 blhdr_checksum, cksum;
+
+	if (!hfsplus_transaction_seq_num_valid(prev_seq_num, blhdr))
+		return -EIO;
+
+	if (TR_BLOCKS(blhdr) == 0 || TR_BYTES(blhdr) == 0) {
+		pr_err("corrupted block list header\n");
+		hfs_dbg(JOURNAL, "num_blocks %u, max_blocks %u\n",
+			TR_BLOCKS(blhdr), TR_BYTES(blhdr));
+		return -EIO;
+	}
+
+	if (TR_BLOCKS(blhdr) > TR_MAX_BLOCKS(blhdr)) {
+		pr_err("corrupted block list header\n");
+		hfs_dbg(JOURNAL, "num_blocks %u, max_blocks %u\n",
+			TR_BLOCKS(blhdr), TR_MAX_BLOCKS(blhdr));
+		return -EIO;
+	}
+
+	if (!NEED_CHECK_CSUM(blhdr))
+		return 0; /* don't check checksums */
+
+	blhdr_checksum = blhdr->checksum;
+	blhdr->checksum = 0;
+
+	cksum = HFSPLUS_CALC_CHECKSUM((unsigned char *)blhdr, sizeof(*blhdr));
+	if (le32_to_cpu(cksum) != le32_to_cpu(blhdr_checksum)) {
+		blhdr->checksum = blhdr_checksum;
+		pr_err("corrupted block list header\n");
+		hfs_dbg(JOURNAL, "calculated CRC %#x, blhdr_checksum %#x\n",
+			cksum, be32_to_cpu(blhdr_checksum));
+		return -EIO;
+	}
+
+	blhdr->checksum = blhdr_checksum;
+	return 0;
+}
+
 static int hfsplus_replay_journal(struct super_block *sb);
 
 static
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

