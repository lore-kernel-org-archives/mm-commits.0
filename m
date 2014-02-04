From: akpm@linux-foundation.org
Subject: +
 hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag.patch
 added to -mm tree
Date: Tue, 04 Feb 2014 14:33:34 -0800
Message-ID: <52f16abe.0wUYPzEYJoquwra2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154AbaBDWdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:33:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:33:34 -0800


The patch titled
     Subject: hfsplus: implement functionality for HFSPLUS_JOURNAL_NEED_INIT flag
has been added to the -mm tree.  Its filename is
     hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag.patch

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
Subject: hfsplus: implement functionality for HFSPLUS_JOURNAL_NEED_INIT flag

Implement functionality of creation of journal header, journal buffer and
initialization of them.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |  168 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 167 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/journal.c~hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag fs/hfsplus/journal.c
--- a/fs/hfsplus/journal.c~hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag
+++ a/fs/hfsplus/journal.c
@@ -8,6 +8,23 @@
 
 #include "hfsplus_fs.h"
 
+#define HFSPLUS_1KB_SHIFT		10
+#define HFSPLUS_1MB_SHIFT		20
+#define HFSPLUS_1GB_SHIFT		30
+#define HFSPLUS_1TB_SHIFT		40
+
+#define HFSPLUS_JOURNAL_MIN_SIZE	(512 * 1024)
+#define HFSPLUS_JOURNAL_DEFAULT_SIZE	(8 * (1 << HFSPLUS_1MB_SHIFT))
+#define HFSPLUS_JOURNAL_MAX_SIZE	(512 * (1 << HFSPLUS_1MB_SHIFT))
+
+#define HFSPLUS_VOLUME_GRAIN		100 /* 100 GB*/
+#define HFSPLUS_JSCALE_MAX		64
+
+#define HFSPLUS_VOLUME_MIN_THRESHOLD	(128 * (1 << HFSPLUS_1MB_SHIFT))
+#define HFSPLUS_DEFAULT_JHDR_SIZE	(4 * 1024)
+#define HFSPLUS_BLHDR_SIZE_MIN		(4 * 1024)
+#define HFSPLUS_BLHDR_SIZE_MAX		(16 * 1024)
+
 #define HFSPLUS_HAS_JOURNAL(sb) \
 	(HFSPLUS_SB(sb)->s_vhdr->attributes & \
 	 cpu_to_be32(HFSPLUS_VOL_JOURNALED))
@@ -25,8 +42,157 @@
 	((sector_t)(blk) << \
 	 (HFSPLUS_SB(sb)->alloc_blksz_shift - HFSPLUS_SECTOR_SHIFT))
 
+/*
+ * We want at least 8 megs of journal for each 100 gigs of
+ * disk space.  We cap the size at 512 megs (64x default), unless
+ * the allocation block size is larger, in which case we use one
+ * allocation block.
+ *
+ * Volumes that are 128 megs or less in size have such
+ * a small bitmap (one 4k-block) and inherhently such
+ * a small btree that we can get by with a much smaller
+ * journal. Even in a worst case scenario of a catalog
+ * filled with very long korean file names we should
+ * never touch more than 256k of meta-data for a single
+ * transaction.  therefore we'll make the journal 512k
+ * which is safe and doesn't waste much space.
+ */
+static u64 calc_journal_size(struct super_block *sb)
+{
+	u64 journal_size;
+	u64 jscale;
+	u64 volume_size = (u64)HFSPLUS_SB(sb)->sect_count *
+				HFSPLUS_SECTOR_SIZE;
+	u64 volume_grain = (u64)HFSPLUS_VOLUME_GRAIN *
+				((u64)1 << HFSPLUS_1GB_SHIFT);
+
+	jscale = volume_size / volume_grain;
+
+	if (jscale > HFSPLUS_JSCALE_MAX)
+		jscale = HFSPLUS_JSCALE_MAX;
+
+	journal_size = HFSPLUS_JOURNAL_DEFAULT_SIZE * (jscale + 1);
+
+	if (journal_size > HFSPLUS_JOURNAL_MAX_SIZE)
+		journal_size = HFSPLUS_JOURNAL_MAX_SIZE;
+
+	if (volume_size < HFSPLUS_VOLUME_MIN_THRESHOLD)
+		journal_size = HFSPLUS_JOURNAL_MIN_SIZE;
+
+	return journal_size;
+}
+
+/*
+ * Technical Note TN1150
+ *
+ * Checksums can be verified as part of a basic consistency check.
+ * To verify the checksum, temporarily set the checksum field to zero
+ * and then call the calc_checksum routine with the address and size of
+ * the header being checksummed. The function result should equal the
+ * original value of the checksum field.
+ *
+ * static int
+ * calc_checksum(unsigned char *ptr, int len)
+ * {
+ *    int i, cksum=0;
+ *
+ *    for(i=0; i < len; i++, ptr++) {
+ *        cksum = (cksum << 8) ^ (cksum + *ptr);
+ *    }
+ *
+ *    return (~cksum);
+ * }
+*/
+static u32 calc_internal_checksum(u32 seed, unsigned char *ptr, int len)
+{
+	int i;
+	u32 chksum = seed;
+
+	for (i = 0; i < len; i++, ptr++)
+		chksum = (chksum << 8) ^ (chksum + *ptr);
+
+	return chksum;
+}
+
+#define HFSPLUS_CHECKSUM(internal_checksum) \
+	(cpu_to_le32(~(u32)(internal_checksum)))
+
+#define HFSPLUS_CALC_CHECKSUM(ptr, len) \
+	HFSPLUS_CHECKSUM(calc_internal_checksum(0, ptr, len))
+
+/*
+ * hfsplus_create_journal - create journal
+ *
+ * @sb: superblock
+ *
+ * Create journal header, journal buffer and initialize them.
+ * It is assumed that presence of journal is already verified.
+ */
 static int hfsplus_create_journal(struct super_block *sb,
-				  struct hfsplus_journal *jnl);
+				  struct hfsplus_journal *jnl)
+{
+	u64 offset = be64_to_cpu(jnl->jib->offset);
+	int blksz_bits = HFSPLUS_SB(sb)->alloc_blksz_shift;
+	u32 blksz = HFSPLUS_SB(sb)->alloc_blksz;
+	u64 journal_size = be64_to_cpu(jnl->jib->size);
+	u64 calculated_journal_size;
+
+	hfs_dbg(JOURNAL, "create HFS+ journal: blocksize %u, jib_hdr->offset %llu\n",
+		blksz, offset);
+
+	if (((offset >> blksz_bits) << blksz_bits) != offset) {
+		pr_err("journal size is not aligned\n");
+		return -EIO;
+	}
+
+	if (journal_size < HFSPLUS_JOURNAL_MIN_SIZE ||
+	    journal_size > HFSPLUS_JOURNAL_MAX_SIZE) {
+		pr_err("journal size %llu looks bogus\n", journal_size);
+		return -EIO;
+	}
+
+	if ((journal_size % blksz) != 0) {
+		pr_err("journal size %llu is not an even multiple of block size %u\n",
+			journal_size, blksz);
+		return -EIO;
+	}
+
+	calculated_journal_size = calc_journal_size(sb);
+	if (journal_size != calculated_journal_size) {
+		pr_warn("journal size %llu is different from calculated journal size %llu\n",
+			journal_size, calculated_journal_size);
+	}
+
+	jnl->jh->magic = cpu_to_le32(HFSPLUS_JOURNAL_HEADER_MAGIC);
+	jnl->jh->endian = cpu_to_le32(HFSPLUS_JOURNAL_HEADER_ENDIAN);
+
+	/*
+	 * The jhdr_size is a 512 byte for volumes are less than 1TB.
+	 * Otherwise, jhdr_size is 4096 bytes for 1+TB volumes.
+	 */
+	if (HFSPLUS_SB(sb)->sect_count >
+	    (((u64)1 << HFSPLUS_1TB_SHIFT) >> HFSPLUS_SECTOR_SHIFT))
+		jnl->jh->jhdr_size = cpu_to_le32(HFSPLUS_DEFAULT_JHDR_SIZE);
+	else
+		jnl->jh->jhdr_size = cpu_to_le32(HFSPLUS_SECTOR_SIZE);
+
+	if (blksz < HFSPLUS_BLHDR_SIZE_MIN)
+		jnl->jh->blhdr_size = cpu_to_le32(HFSPLUS_BLHDR_SIZE_MIN);
+	else if (blksz > HFSPLUS_BLHDR_SIZE_MAX)
+		jnl->jh->blhdr_size = cpu_to_le32(HFSPLUS_BLHDR_SIZE_MAX);
+	else
+		jnl->jh->blhdr_size = cpu_to_le32(sb->s_blocksize);
+
+	jnl->jh->start = cpu_to_le64(JHDR_SIZE(jnl->jh));
+	jnl->jh->end = cpu_to_le64(JHDR_SIZE(jnl->jh));
+	jnl->jh->size = cpu_to_le64(journal_size);
+
+	jnl->jh->checksum = 0;
+	jnl->jh->checksum = HFSPLUS_CALC_CHECKSUM((unsigned char *)(jnl->jh),
+						  sizeof(*(jnl->jh)));
+
+	return 0;
+}
 
 /*
  * hfsplus_init_journal - initialize journal object
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

