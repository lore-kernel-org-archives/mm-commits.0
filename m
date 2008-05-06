From: akpm@linux-foundation.org
Subject: + affs-convert-s_bmlock-into-a-mutex.patch added to -mm tree
Date: Tue, 06 May 2008 13:33:53 -0700
Message-ID: <200805062033.m46KXrBT025917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764066AbYEFUeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:34:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net, zippel@linux-m68k.org


The patch titled
     affs: convert s_bmlock into a mutex
has been added to the -mm tree.  Its filename is
     affs-convert-s_bmlock-into-a-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: affs: convert s_bmlock into a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore s_bmlock is used as a mutex.  Convert it to the mutex API.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h   |    3 ++-
 fs/affs/bitmap.c |   18 +++++++++---------
 fs/affs/super.c  |    2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

diff -puN fs/affs/affs.h~affs-convert-s_bmlock-into-a-mutex fs/affs/affs.h
--- a/fs/affs/affs.h~affs-convert-s_bmlock-into-a-mutex
+++ a/fs/affs/affs.h
@@ -2,6 +2,7 @@
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/amigaffs.h>
+#include <linux/mutex.h>
 
 /* AmigaOS allows file names with up to 30 characters length.
  * Names longer than that will be silently truncated. If you
@@ -98,7 +99,7 @@ struct affs_sb_info {
 	gid_t s_gid;			/* gid to override */
 	umode_t s_mode;			/* mode to override */
 	struct buffer_head *s_root_bh;	/* Cached root block. */
-	struct semaphore s_bmlock;	/* Protects bitmap access. */
+	struct mutex s_bmlock;		/* Protects bitmap access. */
 	struct affs_bm_info *s_bitmap;	/* Bitmap infos. */
 	u32 s_bmap_count;		/* # of bitmap blocks. */
 	u32 s_bmap_bits;		/* # of bits in one bitmap blocks */
diff -puN fs/affs/bitmap.c~affs-convert-s_bmlock-into-a-mutex fs/affs/bitmap.c
--- a/fs/affs/bitmap.c~affs-convert-s_bmlock-into-a-mutex
+++ a/fs/affs/bitmap.c
@@ -45,14 +45,14 @@ affs_count_free_blocks(struct super_bloc
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
-	down(&AFFS_SB(sb)->s_bmlock);
+	mutex_lock(&AFFS_SB(sb)->s_bmlock);
 
 	bm = AFFS_SB(sb)->s_bitmap;
 	free = 0;
 	for (i = AFFS_SB(sb)->s_bmap_count; i > 0; bm++, i--)
 		free += bm->bm_free;
 
-	up(&AFFS_SB(sb)->s_bmlock);
+	mutex_unlock(&AFFS_SB(sb)->s_bmlock);
 
 	return free;
 }
@@ -76,7 +76,7 @@ affs_free_block(struct super_block *sb, 
 	bit     = blk % sbi->s_bmap_bits;
 	bm      = &sbi->s_bitmap[bmap];
 
-	down(&sbi->s_bmlock);
+	mutex_lock(&sbi->s_bmlock);
 
 	bh = sbi->s_bmap_bh;
 	if (sbi->s_last_bmap != bmap) {
@@ -105,19 +105,19 @@ affs_free_block(struct super_block *sb, 
 	sb->s_dirt = 1;
 	bm->bm_free++;
 
-	up(&sbi->s_bmlock);
+	mutex_unlock(&sbi->s_bmlock);
 	return;
 
 err_free:
 	affs_warning(sb,"affs_free_block","Trying to free block %u which is already free", block);
-	up(&sbi->s_bmlock);
+	mutex_unlock(&sbi->s_bmlock);
 	return;
 
 err_bh_read:
 	affs_error(sb,"affs_free_block","Cannot read bitmap block %u", bm->bm_key);
 	sbi->s_bmap_bh = NULL;
 	sbi->s_last_bmap = ~0;
-	up(&sbi->s_bmlock);
+	mutex_unlock(&sbi->s_bmlock);
 	return;
 
 err_range:
@@ -168,7 +168,7 @@ affs_alloc_block(struct inode *inode, u3
 	bmap = blk / sbi->s_bmap_bits;
 	bm = &sbi->s_bitmap[bmap];
 
-	down(&sbi->s_bmlock);
+	mutex_lock(&sbi->s_bmlock);
 
 	if (bm->bm_free)
 		goto find_bmap_bit;
@@ -249,7 +249,7 @@ find_bit:
 	mark_buffer_dirty(bh);
 	sb->s_dirt = 1;
 
-	up(&sbi->s_bmlock);
+	mutex_unlock(&sbi->s_bmlock);
 
 	pr_debug("%d\n", blk);
 	return blk;
@@ -259,7 +259,7 @@ err_bh_read:
 	sbi->s_bmap_bh = NULL;
 	sbi->s_last_bmap = ~0;
 err_full:
-	up(&sbi->s_bmlock);
+	mutex_unlock(&sbi->s_bmlock);
 	pr_debug("failed\n");
 	return 0;
 }
diff -puN fs/affs/super.c~affs-convert-s_bmlock-into-a-mutex fs/affs/super.c
--- a/fs/affs/super.c~affs-convert-s_bmlock-into-a-mutex
+++ a/fs/affs/super.c
@@ -290,7 +290,7 @@ static int affs_fill_super(struct super_
 	if (!sbi)
 		return -ENOMEM;
 	sb->s_fs_info = sbi;
-	init_MUTEX(&sbi->s_bmlock);
+	mutex_init(&sbi->s_bmlock);
 
 	if (!parse_options(data,&uid,&gid,&i,&reserved,&root_block,
 				&blocksize,&sbi->s_prefix,
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
pxafb-convert-ctrlr_sem-in-a-mutex.patch
sa1100fb-convert-ctrlr_sem-in-a-mutex.patch
affs-convert-s_bmlock-into-a-mutex.patch

