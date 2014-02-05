From: akpm@linux-foundation.org
Subject: [to-be-updated]
 hfsplus-implement-init-destroy-journal-object-functionality.patch removed
 from -mm tree
Date: Wed, 05 Feb 2014 15:49:01 -0800
Message-ID: <52f2cded.bedzv8td/mNQWisp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaBEXtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 18:49:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: [to-be-updated] hfsplus-implement-init-destroy-journal-object-functionality.patch removed from -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 15:49:01 -0800


The patch titled
     Subject: hfsplus: implement init/destroy journal object functionality
has been removed from the -mm tree.  Its filename was
     hfsplus-implement-init-destroy-journal-object-functionality.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: implement init/destroy journal object functionality

Implement functionality of initialization (hfsplus_init_journal() method)
and destruction (hfsplus_destroy_journal() method) of HFS+ journal object
in memory.

The hfsplus_init_journal():
(1) checks that HFS+ has journal;
(2) allocate memory for main incapsulated objects;
(3) check that journal is located inside file system's volume;
(4) initialize journal's on-disk structures (in the case of necessity).

The hfsplus_destroy_journal() method frees allocated memory.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |  168 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 168 insertions(+)

diff -puN /dev/null fs/hfsplus/journal.c
--- /dev/null
+++ a/fs/hfsplus/journal.c
@@ -0,0 +1,168 @@
+/*
+ * linux/fs/hfsplus/journal.c
+ *
+ * Vyacheslav Dubeyko <slava@dubeyko.com>
+ *
+ * Logic of HFS+ journalling
+ */
+
+#include "hfsplus_fs.h"
+
+#define HFSPLUS_HAS_JOURNAL(sb) \
+	(HFSPLUS_SB(sb)->s_vhdr->attributes & \
+	 cpu_to_be32(HFSPLUS_VOL_JOURNALED))
+
+#define JIB_BLOCK(sb) \
+	(be32_to_cpu(HFSPLUS_SB(sb)->s_vhdr->journal_info_block))
+#define JIB_FLAGS(jnl) \
+	(be32_to_cpu(((struct hfsplus_journal *)(jnl))->jib->flags))
+
+#define JH_BLOCK(sb, jnl) \
+	(be64_to_cpu(((struct hfsplus_journal *)(jnl))->jib->offset) >> \
+	 HFSPLUS_SB(sb)->alloc_blksz_shift)
+
+#define BLOCK_TO_SEC(sb, blk) \
+	((sector_t)(blk) << \
+	 (HFSPLUS_SB(sb)->alloc_blksz_shift - HFSPLUS_SECTOR_SHIFT))
+
+static int hfsplus_create_journal(struct super_block *sb,
+				  struct hfsplus_journal *jnl);
+
+/*
+ * hfsplus_init_journal - initialize journal object
+ *
+ * @sb: superblock
+ *
+ * Check presence of journal on volume and initialize journal object.
+ * It is assumed that superblock and volume header are initialized yet.
+ */
+int hfsplus_init_journal(struct super_block *sb)
+{
+	struct hfsplus_journal *jnl;
+	sector_t jib_blk;
+	sector_t jh_blk;
+	int err = 0;
+
+	HFSPLUS_SB(sb)->jnl = NULL;
+
+	if (!HFSPLUS_HAS_JOURNAL(sb))
+		return 0; /* journal absent */
+
+	hfs_dbg(JOURNAL, "try to init journal subsystem\n");
+
+	jnl = kzalloc(sizeof(*jnl), GFP_KERNEL);
+	if (unlikely(!jnl))
+		return -ENOMEM;
+
+	hfs_dbg(JOURNAL, "HFS+ filesystem has journal\n");
+
+	jnl->jib_buf = kmalloc(hfsplus_min_io_size(sb), GFP_KERNEL);
+	if (unlikely(!jnl->jib_buf)) {
+		pr_err("unable to allocate jib_buf\n");
+		err = -ENOMEM;
+		goto init_failed;
+	}
+
+	jnl->jh_buf = kmalloc(hfsplus_min_io_size(sb), GFP_KERNEL);
+	if (unlikely(!jnl->jh_buf)) {
+		pr_err("unable to allocate jh_buf\n");
+		err = -ENOMEM;
+		goto free_jib_buf;
+	}
+
+	jib_blk = HFSPLUS_SB(sb)->blockoffset + JIB_BLOCK(sb);
+
+	err = hfsplus_submit_bio(sb, BLOCK_TO_SEC(sb, jib_blk),
+				 jnl->jib_buf, (void **)&jnl->jib, READ, NULL);
+	if (err) {
+		pr_err("unable to read journal info block %lu\n", jib_blk);
+		goto free_jh_buf;
+	}
+
+	hfs_dbg(JOURNAL, "jib_flags %#x\n", JIB_FLAGS(jnl));
+	hfs_dbg(JOURNAL, "journal size %u\n", be32_to_cpu(jnl->jib->size));
+
+	if ((JIB_FLAGS(jnl) & HFSPLUS_JOURNAL_ON_OTHER_DEVICE) &&
+	    !(JIB_FLAGS(jnl) & HFSPLUS_JOURNAL_IN_FS)) {
+		err = -EOPNOTSUPP;
+		goto free_jh_buf;
+	}
+
+	jh_blk = JH_BLOCK(sb, jnl);
+
+	hfs_dbg(JOURNAL, "read journal header: jh_bkl %lu\n", jh_blk);
+
+	err = hfsplus_submit_bio(sb, BLOCK_TO_SEC(sb, jh_blk),
+				 jnl->jh_buf, (void **)&jnl->jh, READ, NULL);
+	if (err) {
+		pr_err("unable to read journal header block %lu\n", jh_blk);
+		goto free_jh_buf;
+	}
+
+	if (JIB_FLAGS(jnl) & HFSPLUS_JOURNAL_NEED_INIT) {
+		hfs_dbg(JOURNAL, "create HFS+ journal\n");
+
+		err = hfsplus_create_journal(sb, jnl);
+		if (unlikely(err)) {
+			pr_err("fail to create HFS+ journal\n");
+			goto free_jh_buf;
+		}
+
+		jnl->jib->flags &= be32_to_cpu(~HFSPLUS_JOURNAL_NEED_INIT);
+
+		err = hfsplus_submit_bio(sb, BLOCK_TO_SEC(sb, jh_blk),
+					 jnl->jh_buf, NULL, WRITE_SYNC, NULL);
+		if (err) {
+			pr_err("unable to write journal header block %lu\n",
+				jh_blk);
+			goto free_jh_buf;
+		}
+
+		err = hfsplus_submit_bio(sb, BLOCK_TO_SEC(sb, jib_blk),
+					 jnl->jib_buf, NULL, WRITE_SYNC, NULL);
+		if (err) {
+			pr_err("unable to write journal info block %lu\n",
+				jib_blk);
+			goto free_jh_buf;
+		}
+	}
+
+	mutex_init(&jnl->jnl_lock);
+	jnl->sbp = sb;
+	HFSPLUS_SB(sb)->jnl = jnl;
+
+	return err;
+
+free_jh_buf:
+	kfree(jnl->jh_buf);
+
+free_jib_buf:
+	kfree(jnl->jib_buf);
+
+init_failed:
+	kfree(jnl);
+
+	return err;
+}
+
+/*
+ * hfsplus_destroy_journal - deinitialize journal (if it is present).
+ *
+ * @sb: superblock
+ */
+void hfsplus_destroy_journal(struct super_block *sb)
+{
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
+	struct hfsplus_journal *jnl = sbi->jnl;
+
+	if (!jnl)
+		return;
+
+	hfs_dbg(JOURNAL, "destroy journal subsystem\n");
+
+	/* TODO: stop journal thread */
+
+	kfree(jnl->jh_buf);
+	kfree(jnl->jib_buf);
+	kfree(jnl);
+}
_

Patches currently in -mm which might be from slava@dubeyko.com are

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

