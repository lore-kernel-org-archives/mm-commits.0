From: akpm@linux-foundation.org
Subject: [merged] minix-zmap-block-counts-calculation-fix.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:38:58 -0700
Message-ID: <53ea6d52.7L+4pw8cjfltCEH7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:49854 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbaHLTi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:59 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1068371igi.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiyong@fc-cn.com, jwboyer@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: minix zmap block counts calculation fix
has been removed from the -mm tree.  Its filename was
     minix-zmap-block-counts-calculation-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qi Yong <qiyong@fc-cn.com>
Subject: minix zmap block counts calculation fix

The original minix zmap blocks calculation was correct, in the formula of:

	sbi->s_nzones - sbi->s_firstdatazone + 1
	
It is

	sp->s_zones - (sp->s_firstdatazone - 1)

in the minix3 source code.

But a later patch 016e8d44bc06dd ("fs/minix: Verify bitmap block counts
before mounting") has changed it unfortunately as:

  sbi->s_nzones - (sbi->s_firstdatazone + 1)

This would show free blocks one block less than the real when the total
data blocks are in "full zmap blocks plus one".

This patch corrects that zmap blocks calculation and tidy a printk message
while at it.

Signed-off-by: Qi Yong <qiyong@fc-cn.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/bitmap.c |    2 +-
 fs/minix/inode.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/minix/bitmap.c~minix-zmap-block-counts-calculation-fix fs/minix/bitmap.c
--- a/fs/minix/bitmap.c~minix-zmap-block-counts-calculation-fix
+++ a/fs/minix/bitmap.c
@@ -96,7 +96,7 @@ int minix_new_block(struct inode * inode
 unsigned long minix_count_free_blocks(struct super_block *sb)
 {
 	struct minix_sb_info *sbi = minix_sb(sb);
-	u32 bits = sbi->s_nzones - (sbi->s_firstdatazone + 1);
+	u32 bits = sbi->s_nzones - sbi->s_firstdatazone + 1;
 
 	return (count_free(sbi->s_zmap, sb->s_blocksize, bits)
 		<< sbi->s_log_zone_size);
diff -puN fs/minix/inode.c~minix-zmap-block-counts-calculation-fix fs/minix/inode.c
--- a/fs/minix/inode.c~minix-zmap-block-counts-calculation-fix
+++ a/fs/minix/inode.c
@@ -267,12 +267,12 @@ static int minix_fill_super(struct super
 	block = minix_blocks_needed(sbi->s_ninodes, s->s_blocksize);
 	if (sbi->s_imap_blocks < block) {
 		printk("MINIX-fs: file system does not have enough "
-				"imap blocks allocated.  Refusing to mount\n");
+				"imap blocks allocated.  Refusing to mount.\n");
 		goto out_no_bitmap;
 	}
 
 	block = minix_blocks_needed(
-			(sbi->s_nzones - (sbi->s_firstdatazone + 1)),
+			(sbi->s_nzones - sbi->s_firstdatazone + 1),
 			s->s_blocksize);
 	if (sbi->s_zmap_blocks < block) {
 		printk("MINIX-fs: file system does not have enough "
_

Patches currently in -mm which might be from qiyong@fc-cn.com are

origin.patch

