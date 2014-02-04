From: akpm@linux-foundation.org
Subject: +
 hfsplus-implement-functionality-of-getting-transactions-block-info.patch
 added to -mm tree
Date: Tue, 04 Feb 2014 14:33:40 -0800
Message-ID: <52f16ac4.bN3Pm7wzsnlzPYue%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936015AbaBDWdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:33:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-functionality-of-getting-transactions-block-info.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:33:40 -0800


The patch titled
     Subject: hfsplus: implement functionality of getting transaction's block info
has been added to the -mm tree.  Its filename is
     hfsplus-implement-functionality-of-getting-transactions-block-info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-functionality-of-getting-transactions-block-info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-functionality-of-getting-transactions-block-info.patch

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
Subject: hfsplus: implement functionality of getting transaction's block info

Implement functionality of getting access to concrete binfo in index.  If
cached portion of block list doesn't contain requested binfo then it will
be read and be cached a sector that it contains binfo for requested index.

The journal log is a circular buffer.  Thereby, block list can be splitted
by journal end on two parts in some situations.  A first part will be
located at end of journal buffer when second one will continue the block
list from journal buffer's begin.  As a result, method of getting binfo by
index wraps around reading from journal buffer in such case.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |  122 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff -puN fs/hfsplus/journal.c~hfsplus-implement-functionality-of-getting-transactions-block-info fs/hfsplus/journal.c
--- a/fs/hfsplus/journal.c~hfsplus-implement-functionality-of-getting-transactions-block-info
+++ a/fs/hfsplus/journal.c
@@ -46,6 +46,10 @@
 	(le64_to_cpu(((struct hfsplus_journal_header *)(jh))->start))
 #define LAST_TR_END(jh) \
 	(le64_to_cpu(((struct hfsplus_journal_header *)(jh))->end))
+#define JOURNAL_SIZE(jh) \
+	(le64_to_cpu(((struct hfsplus_journal_header *)(jh))->size))
+#define BLHDR_SIZE(jh) \
+	(le32_to_cpu(((struct hfsplus_journal_header *)(jh))->blhdr_size))
 #define JHDR_SIZE(jh) \
 	(le32_to_cpu(((struct hfsplus_journal_header *)(jh))->jhdr_size))
 
@@ -61,6 +65,23 @@
 	(le32_to_cpu(((struct hfsplus_blhdr *)(blhdr))->flags) & \
 	 HFSPLUS_BLHDR_CHECK_CHECKSUMS)
 
+#define BNUM(binfo) \
+	(le64_to_cpu(((struct hfsplus_block_info *)(binfo))->bnum))
+#define BSIZE(binfo) \
+	(le32_to_cpu(((struct hfsplus_block_info *)(binfo))->bsize))
+#define BINFO_OFFSET(index) \
+	(offsetof(struct hfsplus_blhdr, binfo) + \
+	 (index * sizeof(struct hfsplus_block_info)))
+
+static inline u16 BINFO_INDEX(size_t offset)
+{
+	if (offset <= offsetof(struct hfsplus_blhdr, binfo))
+		return 0;
+
+	return (offset - offsetof(struct hfsplus_blhdr, binfo)) /
+		sizeof(struct hfsplus_block_info);
+}
+
 /*
  * struct hfsplus_blist_desc - descriptor of block list buffer
  * @start_sec: start sector of block list
@@ -263,6 +284,12 @@ static int hfsplus_create_journal(struct
 	return 0;
 }
 
+static inline bool need_to_wrap_journal(struct hfsplus_journal_header *jh,
+					u64 cur_off, u32 req_size)
+{
+	return (cur_off + req_size) > JOURNAL_SIZE(jh);
+}
+
 static void hfsplus_deinit_block_list_desc(struct hfsplus_blist_desc *desc);
 
 static int hfsplus_init_block_list_desc(struct super_block *sb,
@@ -339,6 +366,101 @@ static struct hfsplus_blhdr *hfsplus_get
 }
 
 static inline
+bool is_binfo_available(u16 index, struct hfsplus_blist_desc *desc)
+{
+	size_t lower_bound;
+	size_t upper_bound;
+	size_t req_off;
+
+	lower_bound = BINFO_OFFSET(desc->cur_index);
+	upper_bound = ((lower_bound >> HFSPLUS_SECTOR_SHIFT) <<
+			HFSPLUS_SECTOR_SHIFT) + desc->available_bytes;
+	req_off = BINFO_OFFSET(index);
+
+	return lower_bound <= req_off && req_off < upper_bound;
+}
+
+static
+struct hfsplus_block_info *hfsplus_get_binfo(struct super_block *sb,
+					     u16 index,
+					     struct hfsplus_blist_desc *desc)
+{
+	u16 diff;
+
+	BUG_ON(!desc->blist_buf || !desc->binfo);
+
+	hfs_dbg(JOURNAL, "get binfo[%u], is_binfo_available %u\n",
+		index, is_binfo_available(index, desc));
+
+	if (index >= TR_MAX_BLOCKS(&desc->blhdr)) {
+		pr_err("invalid block index: index %u, max_blocks %u\n",
+			index, TR_MAX_BLOCKS(&desc->blhdr));
+		return NULL;
+	}
+
+	if (!is_binfo_available(index, desc)) {
+		struct hfsplus_journal *jnl = HFSPLUS_SB(sb)->jnl;
+		struct hfsplus_journal_header *jh = jnl->jh;
+		u64 jh_off;
+		sector_t jh_sec;
+		u64 blhdr_off;
+		sector_t start_sec;
+		size_t secs;
+		size_t secs_size;
+		struct hfsplus_block_info *binfo;
+		int err;
+
+		jh_off = be64_to_cpu(jnl->jib->offset);
+		jh_sec = (jh_off >> HFSPLUS_SECTOR_SHIFT) +
+				HFSPLUS_SB(sb)->blockoffset;
+		blhdr_off = (desc->start_sec - jh_sec) << HFSPLUS_SECTOR_SHIFT;
+
+		secs = BINFO_OFFSET(index) >> HFSPLUS_SECTOR_SHIFT;
+		secs_size = secs << HFSPLUS_SECTOR_SHIFT;
+
+		if (need_to_wrap_journal(jh, blhdr_off,
+					 secs_size + HFSPLUS_SECTOR_SIZE)) {
+			u64 end_bytes;
+			u64 begin_bytes;
+
+			BUG_ON(JOURNAL_SIZE(jh) < blhdr_off);
+			end_bytes = JOURNAL_SIZE(jh) - blhdr_off;
+			BUG_ON(secs_size < end_bytes);
+			begin_bytes = secs_size - end_bytes;
+
+			start_sec = jh_sec;
+			start_sec += JHDR_SIZE(jh) >> HFSPLUS_SECTOR_SHIFT;
+			start_sec += begin_bytes >> HFSPLUS_SECTOR_SHIFT;
+		} else
+			start_sec = desc->start_sec + secs;
+
+		hfs_dbg(JOURNAL, "start sector %lu of blist's part\n",
+			start_sec);
+
+		err = hfsplus_submit_bio(sb, start_sec,
+					 desc->blist_buf, (void **)&binfo,
+					 READ, &desc->available_bytes);
+		if (err) {
+			pr_err("unable to read sector %lu of block list\n",
+				start_sec);
+			return NULL;
+		}
+
+		desc->cur_sec = start_sec;
+		desc->cur_index = BINFO_INDEX((secs << HFSPLUS_SECTOR_SHIFT));
+
+		if (desc->cur_index == 0) {
+			desc->binfo =
+				&((struct hfsplus_blhdr *)binfo)->binfo[0];
+		} else
+			desc->binfo = binfo;
+	}
+
+	diff = (desc->cur_index == 0 ? index : index - desc->cur_index);
+	return &desc->binfo[diff];
+}
+
+static inline
 bool hfsplus_journal_empty(struct hfsplus_journal_header *jh)
 {
 	return TR_START(jh) == LAST_TR_END(jh);
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

