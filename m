From: akpm@linux-foundation.org
Subject: + fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch added to -mm
 tree
Date: Thu, 12 Jun 2014 14:08:38 -0700
Message-ID: <539a16d6.X0Eu5gZoOucFy3Po%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaFLVIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jun 2014 17:08:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, joe@perches.com, chaosman@ontika.net, fabf@skynet.be

Subject: + fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch added to -mm tree
To: fabf@skynet.be,chaosman@ontika.net,joe@perches.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 12 Jun 2014 14:08:38 -0700


The patch titled
     Subject: fs/qnx6: use pr_fmt and __func__ in logging
has been added to the -mm tree.  Its filename is
     fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/qnx6: use pr_fmt and __func__ in logging

Remove "qnx6:" and "qnx6: " from each logging instruction.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Cc: Kai Bankett <chaosman@ontika.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx6/dir.c       |   12 +++++------
 fs/qnx6/inode.c     |   44 +++++++++++++++++++++---------------------
 fs/qnx6/qnx6.h      |    6 +++++
 fs/qnx6/super_mmi.c |   20 +++++++++----------
 4 files changed, 44 insertions(+), 38 deletions(-)

diff -puN fs/qnx6/dir.c~fs-qnx6-use-pr_fmt-and-__func__-in-logging fs/qnx6/dir.c
--- a/fs/qnx6/dir.c~fs-qnx6-use-pr_fmt-and-__func__-in-logging
+++ a/fs/qnx6/dir.c
@@ -77,12 +77,12 @@ static int qnx6_dir_longfilename(struct
 	if (de->de_size != 0xff) {
 		/* error - long filename entries always have size 0xff
 		   in direntry */
-		pr_err("qnx6: invalid direntry size (%i).\n", de->de_size);
+		pr_err("invalid direntry size (%i).\n", de->de_size);
 		return 0;
 	}
 	lf = qnx6_longname(s, de, &page);
 	if (IS_ERR(lf)) {
-		pr_err("qnx6:Error reading longname\n");
+		pr_err("Error reading longname\n");
 		return 0;
 	}
 
@@ -90,7 +90,7 @@ static int qnx6_dir_longfilename(struct
 
 	if (lf_size > QNX6_LONG_NAME_MAX) {
 		QNX6DEBUG((KERN_INFO "file %s\n", lf->lf_fname));
-		pr_err("qnx6:Filename too long (%i)\n", lf_size);
+		pr_err("Filename too long (%i)\n", lf_size);
 		qnx6_put_page(page);
 		return 0;
 	}
@@ -99,7 +99,7 @@ static int qnx6_dir_longfilename(struct
 	   mmi 3g filesystem does not have that checksum */
 	if (!test_opt(s, MMI_FS) && fs32_to_cpu(sbi, de->de_checksum) !=
 			qnx6_lfile_checksum(lf->lf_fname, lf_size))
-		pr_info("qnx6: long filename checksum error.\n");
+		pr_info("long filename checksum error.\n");
 
 	QNX6DEBUG((KERN_INFO "qnx6_readdir:%.*s inode:%u\n",
 					lf_size, lf->lf_fname, de_inode));
@@ -135,7 +135,7 @@ static int qnx6_readdir(struct file *fil
 		int i = start;
 
 		if (IS_ERR(page)) {
-			pr_err("qnx6_readdir: read failed\n");
+			pr_err("%s(): read failed\n", __func__);
 			ctx->pos = (n + 1) << PAGE_CACHE_SHIFT;
 			return PTR_ERR(page);
 		}
@@ -258,7 +258,7 @@ unsigned qnx6_find_entry(int len, struct
 					if (ino)
 						goto found;
 				} else
-					pr_err("qnx6: undefined filename size in inode.\n");
+					pr_err("undefined filename size in inode.\n");
 			}
 			qnx6_put_page(page);
 		}
diff -puN fs/qnx6/inode.c~fs-qnx6-use-pr_fmt-and-__func__-in-logging fs/qnx6/inode.c
--- a/fs/qnx6/inode.c~fs-qnx6-use-pr_fmt-and-__func__-in-logging
+++ a/fs/qnx6/inode.c
@@ -87,7 +87,7 @@ static int qnx6_get_block(struct inode *
 static int qnx6_check_blockptr(__fs32 ptr)
 {
 	if (ptr == ~(__fs32)0) {
-		pr_err("qnx6: hit unused blockpointer.\n");
+		pr_err("hit unused blockpointer.\n");
 		return 0;
 	}
 	return 1;
@@ -127,7 +127,7 @@ static unsigned qnx6_block_map(struct in
 	levelptr = no >> bitdelta;
 
 	if (levelptr > QNX6_NO_DIRECT_POINTERS - 1) {
-		pr_err("qnx6:Requested file block number (%u) too big.", no);
+		pr_err("Requested file block number (%u) too big.", no);
 		return 0;
 	}
 
@@ -136,7 +136,7 @@ static unsigned qnx6_block_map(struct in
 	for (i = 0; i < depth; i++) {
 		bh = sb_bread(s, block);
 		if (!bh) {
-			pr_err("qnx6:Error reading block (%u)\n", block);
+			pr_err("Error reading block (%u)\n", block);
 			return 0;
 		}
 		bitdelta -= ptrbits;
@@ -275,7 +275,7 @@ static struct buffer_head *qnx6_check_fi
 	   start with the first superblock */
 	bh = sb_bread(s, offset);
 	if (!bh) {
-		pr_err("qnx6: unable to read the first superblock\n");
+		pr_err("unable to read the first superblock\n");
 		return NULL;
 	}
 	sb = (struct qnx6_super_block *)bh->b_data;
@@ -290,9 +290,9 @@ static struct buffer_head *qnx6_check_fi
 			sbi->s_bytesex = BYTESEX_LE;
 		if (!silent) {
 			if (offset == 0) {
-				pr_err("qnx6: wrong signature (magic) in superblock #1.\n");
+				pr_err("wrong signature (magic) in superblock #1.\n");
 			} else {
-				pr_info("qnx6: wrong signature (magic) at position (0x%lx) - will try alternative position (0x0000).\n",
+				pr_info("wrong signature (magic) at position (0x%lx) - will try alternative position (0x0000).\n",
 					offset * s->s_blocksize);
 			}
 		}
@@ -324,13 +324,13 @@ static int qnx6_fill_super(struct super_
 
 	/* Superblock always is 512 Byte long */
 	if (!sb_set_blocksize(s, QNX6_SUPERBLOCK_SIZE)) {
-		pr_err("qnx6: unable to set blocksize\n");
+		pr_err("unable to set blocksize\n");
 		goto outnobh;
 	}
 
 	/* parse the mount-options */
 	if (!qnx6_parse_options((char *) data, s)) {
-		pr_err("qnx6: invalid mount options.\n");
+		pr_err("invalid mount options.\n");
 		goto outnobh;
 	}
 	if (test_opt(s, MMI_FS)) {
@@ -350,7 +350,7 @@ static int qnx6_fill_super(struct super_
 		/* try again without bootblock offset */
 		bh1 = qnx6_check_first_superblock(s, 0, silent);
 		if (!bh1) {
-			pr_err("qnx6: unable to read the first superblock\n");
+			pr_err("unable to read the first superblock\n");
 			goto outnobh;
 		}
 		/* seems that no bootblock at partition start */
@@ -365,13 +365,13 @@ static int qnx6_fill_super(struct super_
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb1->sb_checksum) !=
 			crc32_be(0, (char *)(bh1->b_data + 8), 504)) {
-		pr_err("qnx6: superblock #1 checksum error\n");
+		pr_err("superblock #1 checksum error\n");
 		goto out;
 	}
 
 	/* set new blocksize */
 	if (!sb_set_blocksize(s, fs32_to_cpu(sbi, sb1->sb_blocksize))) {
-		pr_err("qnx6: unable to set blocksize\n");
+		pr_err("unable to set blocksize\n");
 		goto out;
 	}
 	/* blocksize invalidates bh - pull it back in */
@@ -393,20 +393,20 @@ static int qnx6_fill_super(struct super_
 	/* next the second superblock */
 	bh2 = sb_bread(s, offset);
 	if (!bh2) {
-		pr_err("qnx6: unable to read the second superblock\n");
+		pr_err("unable to read the second superblock\n");
 		goto out;
 	}
 	sb2 = (struct qnx6_super_block *)bh2->b_data;
 	if (fs32_to_cpu(sbi, sb2->sb_magic) != QNX6_SUPER_MAGIC) {
 		if (!silent)
-			pr_err("qnx6: wrong signature (magic) in superblock #2.\n");
+			pr_err("wrong signature (magic) in superblock #2.\n");
 		goto out;
 	}
 
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb2->sb_checksum) !=
 				crc32_be(0, (char *)(bh2->b_data + 8), 504)) {
-		pr_err("qnx6: superblock #2 checksum error\n");
+		pr_err("superblock #2 checksum error\n");
 		goto out;
 	}
 
@@ -416,23 +416,23 @@ static int qnx6_fill_super(struct super_
 		sbi->sb_buf = bh1;
 		sbi->sb = (struct qnx6_super_block *)bh1->b_data;
 		brelse(bh2);
-		pr_info("qnx6: superblock #1 active\n");
+		pr_info("superblock #1 active\n");
 	} else {
 		/* superblock #2 active */
 		sbi->sb_buf = bh2;
 		sbi->sb = (struct qnx6_super_block *)bh2->b_data;
 		brelse(bh1);
-		pr_info("qnx6: superblock #2 active\n");
+		pr_info("superblock #2 active\n");
 	}
 mmi_success:
 	/* sanity check - limit maximum indirect pointer levels */
 	if (sb1->Inode.levels > QNX6_PTR_MAX_LEVELS) {
-		pr_err("qnx6: too many inode levels (max %i, sb %i)\n",
+		pr_err("too many inode levels (max %i, sb %i)\n",
 		       QNX6_PTR_MAX_LEVELS, sb1->Inode.levels);
 		goto out;
 	}
 	if (sb1->Longfile.levels > QNX6_PTR_MAX_LEVELS) {
-		pr_err("qnx6: too many longfilename levels (max %i, sb %i)\n",
+		pr_err("too many longfilename levels (max %i, sb %i)\n",
 		       QNX6_PTR_MAX_LEVELS, sb1->Longfile.levels);
 		goto out;
 	}
@@ -453,7 +453,7 @@ mmi_success:
 	/* prefetch root inode */
 	root = qnx6_iget(s, QNX6_ROOT_INO);
 	if (IS_ERR(root)) {
-		pr_err("qnx6: get inode failed\n");
+		pr_err("get inode failed\n");
 		ret = PTR_ERR(root);
 		goto out2;
 	}
@@ -467,7 +467,7 @@ mmi_success:
 	errmsg = qnx6_checkroot(s);
 	if (errmsg != NULL) {
 		if (!silent)
-			pr_err("qnx6: %s\n", errmsg);
+			pr_err("%s\n", errmsg);
 		goto out3;
 	}
 	return 0;
@@ -548,7 +548,7 @@ struct inode *qnx6_iget(struct super_blo
 	inode->i_mode = 0;
 
 	if (ino == 0) {
-		pr_err("qnx6: bad inode number on dev %s: %u is out of range\n",
+		pr_err("bad inode number on dev %s: %u is out of range\n",
 		       sb->s_id, ino);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
@@ -558,7 +558,7 @@ struct inode *qnx6_iget(struct super_blo
 	mapping = sbi->inodes->i_mapping;
 	page = read_mapping_page(mapping, n, NULL);
 	if (IS_ERR(page)) {
-		pr_err("qnx6: major problem: unable to read inode from dev %s\n",
+		pr_err("major problem: unable to read inode from dev %s\n",
 		       sb->s_id);
 		iget_failed(inode);
 		return ERR_CAST(page);
diff -puN fs/qnx6/qnx6.h~fs-qnx6-use-pr_fmt-and-__func__-in-logging fs/qnx6/qnx6.h
--- a/fs/qnx6/qnx6.h~fs-qnx6-use-pr_fmt-and-__func__-in-logging
+++ a/fs/qnx6/qnx6.h
@@ -10,6 +10,12 @@
  *
  */
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 
diff -puN fs/qnx6/super_mmi.c~fs-qnx6-use-pr_fmt-and-__func__-in-logging fs/qnx6/super_mmi.c
--- a/fs/qnx6/super_mmi.c~fs-qnx6-use-pr_fmt-and-__func__-in-logging
+++ a/fs/qnx6/super_mmi.c
@@ -44,14 +44,14 @@ struct qnx6_super_block *qnx6_mmi_fill_s
 	   start with the first superblock */
 	bh1 = sb_bread(s, 0);
 	if (!bh1) {
-		pr_err("qnx6: Unable to read first mmi superblock\n");
+		pr_err("Unable to read first mmi superblock\n");
 		return NULL;
 	}
 	sb1 = (struct qnx6_mmi_super_block *)bh1->b_data;
 	sbi = QNX6_SB(s);
 	if (fs32_to_cpu(sbi, sb1->sb_magic) != QNX6_SUPER_MAGIC) {
 		if (!silent) {
-			pr_err("qnx6: wrong signature (magic) in superblock #1.\n");
+			pr_err("wrong signature (magic) in superblock #1.\n");
 			goto out;
 		}
 	}
@@ -59,7 +59,7 @@ struct qnx6_super_block *qnx6_mmi_fill_s
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb1->sb_checksum) !=
 				crc32_be(0, (char *)(bh1->b_data + 8), 504)) {
-		pr_err("qnx6: superblock #1 checksum error\n");
+		pr_err("superblock #1 checksum error\n");
 		goto out;
 	}
 
@@ -69,7 +69,7 @@ struct qnx6_super_block *qnx6_mmi_fill_s
 
 	/* set new blocksize */
 	if (!sb_set_blocksize(s, fs32_to_cpu(sbi, sb1->sb_blocksize))) {
-		pr_err("qnx6: unable to set blocksize\n");
+		pr_err("unable to set blocksize\n");
 		goto out;
 	}
 	/* blocksize invalidates bh - pull it back in */
@@ -82,26 +82,26 @@ struct qnx6_super_block *qnx6_mmi_fill_s
 	/* read second superblock */
 	bh2 = sb_bread(s, offset);
 	if (!bh2) {
-		pr_err("qnx6: unable to read the second superblock\n");
+		pr_err("unable to read the second superblock\n");
 		goto out;
 	}
 	sb2 = (struct qnx6_mmi_super_block *)bh2->b_data;
 	if (fs32_to_cpu(sbi, sb2->sb_magic) != QNX6_SUPER_MAGIC) {
 		if (!silent)
-			pr_err("qnx6: wrong signature (magic) in superblock #2.\n");
+			pr_err("wrong signature (magic) in superblock #2.\n");
 		goto out;
 	}
 
 	/* checksum check - start at byte 8 and end at byte 512 */
 	if (fs32_to_cpu(sbi, sb2->sb_checksum)
 			!= crc32_be(0, (char *)(bh2->b_data + 8), 504)) {
-		pr_err("qnx6: superblock #1 checksum error\n");
+		pr_err("superblock #1 checksum error\n");
 		goto out;
 	}
 
 	qsb = kmalloc(sizeof(*qsb), GFP_KERNEL);
 	if (!qsb) {
-		pr_err("qnx6: unable to allocate memory.\n");
+		pr_err("unable to allocate memory.\n");
 		goto out;
 	}
 
@@ -117,7 +117,7 @@ struct qnx6_super_block *qnx6_mmi_fill_s
 		sbi->sb_buf = bh1;
 		sbi->sb = (struct qnx6_super_block *)bh1->b_data;
 		brelse(bh2);
-		pr_info("qnx6: superblock #1 active\n");
+		pr_info("superblock #1 active\n");
 	} else {
 		/* superblock #2 active */
 		qnx6_mmi_copy_sb(qsb, sb2);
@@ -129,7 +129,7 @@ struct qnx6_super_block *qnx6_mmi_fill_s
 		sbi->sb_buf = bh2;
 		sbi->sb = (struct qnx6_super_block *)bh2->b_data;
 		brelse(bh1);
-		pr_info("qnx6: superblock #2 active\n");
+		pr_info("superblock #2 active\n");
 	}
 	kfree(qsb);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

