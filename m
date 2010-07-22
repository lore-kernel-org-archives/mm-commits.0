From: akpm@linux-foundation.org
Subject: + fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems.patch added to -mm tree
Date: Thu, 22 Jul 2010 16:06:59 -0700
Message-ID: <201007222306.o6MN6x4S017478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059Ab0GVXHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 19:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkundrak@v3.sk, hch@lst.de


The patch titled
     fs/sysv: v7: add support for non-PDP11 v7 filesystems
has been added to the -mm tree.  Its filename is
     fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/sysv: v7: add support for non-PDP11 v7 filesystems
From: Lubomir Rintel <lkundrak@v3.sk>

A mount-time option is added that makes it possible to override the
endianness and an attempt is made to autodetect it (which seems easy,
given the disk addresses are 3-byte.

No attempt is made to detect big-endian filesystems -- were there any? 
Tested with PDP-11 v7 filesystems and PC-IX maintenance floppy.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/super.c |   51 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

diff -puN fs/sysv/super.c~fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems fs/sysv/super.c
--- a/fs/sysv/super.c~fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems
+++ a/fs/sysv/super.c
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
+#include <linux/parser.h>
 #include "sysv.h"
 
 /*
@@ -435,12 +436,55 @@ Ebadsize:
 	goto failed;
 }
 
-static int v7_fill_super(struct super_block *sb, void *data, int silent)
+static int v7_sanity_check(struct super_block *sb, struct buffer_head *bh)
 {
-	struct sysv_sb_info *sbi;
-	struct buffer_head *bh, *bh2 = NULL;
 	struct v7_super_block *v7sb;
 	struct sysv_inode *v7i;
+	struct buffer_head *bh2;
+	struct sysv_sb_info *sbi;
+
+	sbi = sb->s_fs_info;
+
+	/* plausibility check on superblock */
+	v7sb = (struct v7_super_block *) bh->b_data;
+	if (fs16_to_cpu(sbi, v7sb->s_nfree) > V7_NICFREE ||
+	    fs16_to_cpu(sbi, v7sb->s_ninode) > V7_NICINOD ||
+	    fs32_to_cpu(sbi, v7sb->s_fsize) > V7_MAXSIZE)
+		return 0;
+
+	/* plausibility check on root inode: it is a directory,
+	   with a nonzero size that is a multiple of 16 */
+	if ((bh2 = sb_bread(sb, 2)) == NULL) {
+		return 0;
+	}
+
+	v7i = (struct sysv_inode *)(bh2->b_data + 64);
+	if ((fs16_to_cpu(sbi, v7i->i_mode) & ~0777) != S_IFDIR ||
+	    (fs32_to_cpu(sbi, v7i->i_size) == 0) ||
+	    (fs32_to_cpu(sbi, v7i->i_size) & 017) ||
+	    (fs32_to_cpu(sbi, v7i->i_size) > V7_NFILES *
+             sizeof (struct sysv_dir_entry))) {
+		brelse(bh2);
+		return 0;
+	}
+
+	brelse(bh2);
+	return 1;
+}
+
+enum { Opt_err, Opt_bytesex_pdp, Opt_bytesex_le, Opt_bytesex_be };
+
+static const match_table_t v7_tokens = {
+	{Opt_bytesex_pdp, "bytesex=pdp"},
+	{Opt_bytesex_le, "bytesex=le"},
+	{Opt_bytesex_be, "bytesex=be"},
+	{Opt_err, NULL}
+};
+
+static int v7_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct sysv_sb_info *sbi;
+	struct buffer_head *bh;
 
 	if (440 != sizeof (struct v7_super_block))
 		panic("V7 FS: bad super-block size");
@@ -454,7 +498,6 @@ static int v7_fill_super(struct super_bl
 	sbi->s_sb = sb;
 	sbi->s_block_base = 0;
 	sbi->s_type = FSTYPE_V7;
-	sbi->s_bytesex = BYTESEX_PDP;
 	sb->s_fs_info = sbi;
 	
 	sb_set_blocksize(sb, 512);
_

Patches currently in -mm which might be from lkundrak@v3.sk are

fs-sysv-add-v7-alias.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes-checkpatch-fixes.patch
fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems.patch

