From: akpm@linux-foundation.org
Subject: + hfsplus-implement-check-consistency-of-journal-log-file.patch
 added to -mm tree
Date: Tue, 04 Feb 2014 14:33:37 -0800
Message-ID: <52f16ac1.xYzabX1UYD1TmgC6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936006AbaBDWdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:33:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-check-consistency-of-journal-log-file.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:33:37 -0800


The patch titled
     Subject: hfsplus: implement check consistency of journal log file
has been added to the -mm tree.  Its filename is
     hfsplus-implement-check-consistency-of-journal-log-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-check-consistency-of-journal-log-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-check-consistency-of-journal-log-file.patch

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
Subject: hfsplus: implement check consistency of journal log file

Implement functionality of checking main HFS+ journal structures (journal
info block and journal header) before replaying of journal buffer's
transactions.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |  156 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

diff -puN fs/hfsplus/journal.c~hfsplus-implement-check-consistency-of-journal-log-file fs/hfsplus/journal.c
--- a/fs/hfsplus/journal.c~hfsplus-implement-check-consistency-of-journal-log-file
+++ a/fs/hfsplus/journal.c
@@ -42,6 +42,13 @@
 	((sector_t)(blk) << \
 	 (HFSPLUS_SB(sb)->alloc_blksz_shift - HFSPLUS_SECTOR_SHIFT))
 
+#define TR_START(jh) \
+	(le64_to_cpu(((struct hfsplus_journal_header *)(jh))->start))
+#define LAST_TR_END(jh) \
+	(le64_to_cpu(((struct hfsplus_journal_header *)(jh))->end))
+#define JHDR_SIZE(jh) \
+	(le32_to_cpu(((struct hfsplus_journal_header *)(jh))->jhdr_size))
+
 /*
  * We want at least 8 megs of journal for each 100 gigs of
  * disk space.  We cap the size at 512 megs (64x default), unless
@@ -120,6 +127,32 @@ static u32 calc_internal_checksum(u32 se
 #define HFSPLUS_CALC_CHECKSUM(ptr, len) \
 	HFSPLUS_CHECKSUM(calc_internal_checksum(0, ptr, len))
 
+static int hfsplus_replay_journal_header(struct super_block *sb)
+{
+	struct hfsplus_journal *jnl = HFSPLUS_SB(sb)->jnl;
+	struct hfsplus_journal_header *jh = jnl->jh;
+	sector_t jh_blk = JH_BLOCK(sb, jnl);
+	int err;
+
+	hfs_dbg(JOURNAL, "replay journal header\n");
+
+	jh->start = cpu_to_le64((u64)JHDR_SIZE(jh));
+	jh->end = cpu_to_le64((u64)JHDR_SIZE(jh));
+
+	jh->checksum = 0;
+	jh->checksum = HFSPLUS_CALC_CHECKSUM((unsigned char *)jh, sizeof(*jh));
+
+	err = hfsplus_submit_bio(sb, BLOCK_TO_SEC(sb, jh_blk),
+				 jnl->jh_buf, NULL, WRITE_SYNC, NULL);
+	if (err) {
+		pr_err("unable to write journal header block %lu\n",
+			jh_blk);
+		return err;
+	}
+
+	return 0;
+}
+
 /*
  * hfsplus_create_journal - create journal
  *
@@ -194,6 +227,121 @@ static int hfsplus_create_journal(struct
 	return 0;
 }
 
+static inline
+bool hfsplus_journal_empty(struct hfsplus_journal_header *jh)
+{
+	return TR_START(jh) == LAST_TR_END(jh);
+}
+
+static int hfsplus_replay_journal(struct super_block *sb);
+
+static
+int hfsplus_check_journal_info_block(struct hfsplus_journal_info_block *jib)
+{
+	u32 jib_flags;
+
+	jib_flags = be32_to_cpu(jib->flags);
+	hfs_dbg(JOURNAL, "jib->flags: %#x\n", jib_flags);
+
+	/* Check that journal is on another volume */
+	if (jib_flags & HFSPLUS_JOURNAL_ON_OTHER_DEVICE &&
+	    !(jib_flags & HFSPLUS_JOURNAL_IN_FS)) {
+		pr_err("unable to access the HFS+ journal\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* Check that journal is created yet */
+	if (jib_flags & HFSPLUS_JOURNAL_NEED_INIT) {
+		pr_err("HFS+ journal is not created\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int hfsplus_verify_journal_header(struct hfsplus_journal_header *jh)
+{
+	__le32 jh_checksum;
+	__le32 checksum;
+
+	if (jh->magic != cpu_to_le32(HFSPLUS_JOURNAL_HEADER_MAGIC) ||
+	    jh->endian != cpu_to_le32(HFSPLUS_JOURNAL_HEADER_ENDIAN)) {
+		pr_err("invalid journal header\n");
+		return -EIO;
+	}
+
+	jh_checksum = jh->checksum;
+	jh->checksum = 0;
+
+	checksum = HFSPLUS_CALC_CHECKSUM((unsigned char *)jh, sizeof(*jh));
+
+	if (le32_to_cpu(checksum) != le32_to_cpu(jh_checksum)) {
+		jh->checksum = jh_checksum;
+		pr_err("invalid journal header\n");
+		hfs_dbg(JOURNAL, "calculated CRC %#x, jh_checksum %#x\n",
+			checksum, le32_to_cpu(jh_checksum));
+		return -EIO;
+	}
+
+	jh->checksum = jh_checksum;
+
+	return 0;
+}
+
+/*
+ * hfsplus_check_journal - check consistency of journal log file.
+ *
+ * @sb: superblock
+ */
+int hfsplus_check_journal(struct super_block *sb)
+{
+	struct hfsplus_journal_header *jh;
+	int err;
+
+	if (!HFSPLUS_SB(sb)->jnl) {
+		hfs_dbg(JOURNAL, "HFS+ journal absent");
+		return 0;
+	}
+
+	hfs_dbg(JOURNAL, "check HFS+ journal\n");
+
+	err = hfsplus_check_journal_info_block(HFSPLUS_SB(sb)->jnl->jib);
+	if (err)
+		return err;
+
+	jh = HFSPLUS_SB(sb)->jnl->jh;
+	err = hfsplus_verify_journal_header(jh);
+	if (err)
+		return err;
+
+	if (test_and_clear_bit(HFSPLUS_SB_NORECOVERY, &HFSPLUS_SB(sb)->flags)) {
+		pr_info("journal replay is skiped, mounting read-only.\n");
+		sb->s_flags |= MS_RDONLY;
+		return -EROFS;
+	}
+
+	if (hfsplus_journal_empty(jh)) {
+		err = hfsplus_replay_journal_header(sb);
+		if (unlikely(err)) {
+			pr_err("journal replay failed, please run fsck.hfsplus\n");
+			return err;
+		}
+		/* If they're the same, we can mount, it's clean */
+		hfs_dbg(JOURNAL, "journal is empty\n");
+		return 0;
+	} else {
+		/* Try to replay journal */
+		err = hfsplus_replay_journal(sb);
+		if (unlikely(err)) {
+			pr_err("journal replay failed, please run fsck.hfsplus\n");
+			return err;
+		}
+		hfs_dbg(JOURNAL, "journal replay is done\n");
+	}
+
+	return 0;
+}
+
 /*
  * hfsplus_init_journal - initialize journal object
  *
@@ -266,6 +414,13 @@ int hfsplus_init_journal(struct super_bl
 	}
 
 	if (JIB_FLAGS(jnl) & HFSPLUS_JOURNAL_NEED_INIT) {
+		if (test_and_clear_bit(HFSPLUS_SB_NORECOVERY,
+					&HFSPLUS_SB(sb)->flags)) {
+			sb->s_flags |= MS_RDONLY;
+			err = -EROFS;
+			goto finish_journal_init;
+		}
+
 		hfs_dbg(JOURNAL, "create HFS+ journal\n");
 
 		err = hfsplus_create_journal(sb, jnl);
@@ -293,6 +448,7 @@ int hfsplus_init_journal(struct super_bl
 		}
 	}
 
+finish_journal_init:
 	mutex_init(&jnl->jnl_lock);
 	jnl->sbp = sb;
 	HFSPLUS_SB(sb)->jnl = jnl;
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

