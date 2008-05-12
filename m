From: akpm@linux-foundation.org
Subject: + hfs-convert-bitmap_lock-in-a-mutex.patch added to -mm tree
Date: Mon, 12 May 2008 16:30:22 -0700
Message-ID: <200805122330.m4CNUMNF014623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311AbYELXam (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:30:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net, zippel@linux-m68k.org


The patch titled
     hfs: convert bitmap_lock in a mutex
has been added to the -mm tree.  Its filename is
     hfs-convert-bitmap_lock-in-a-mutex.patch

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
Subject: hfs: convert bitmap_lock in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

Apple Macintosh file system: The semaphore bitmap_lock is used as a mutex.
Convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/bitmap.c |    8 ++++----
 fs/hfs/hfs_fs.h |    3 ++-
 fs/hfs/super.c  |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/hfs/bitmap.c~hfs-convert-bitmap_lock-in-a-mutex fs/hfs/bitmap.c
--- a/fs/hfs/bitmap.c~hfs-convert-bitmap_lock-in-a-mutex
+++ a/fs/hfs/bitmap.c
@@ -145,7 +145,7 @@ u32 hfs_vbm_search_free(struct super_blo
 	if (!*num_bits)
 		return 0;
 
-	down(&HFS_SB(sb)->bitmap_lock);
+	mutex_lock(&HFS_SB(sb)->bitmap_lock);
 	bitmap = HFS_SB(sb)->bitmap;
 
 	pos = hfs_find_set_zero_bits(bitmap, HFS_SB(sb)->fs_ablocks, goal, num_bits);
@@ -162,7 +162,7 @@ u32 hfs_vbm_search_free(struct super_blo
 	HFS_SB(sb)->free_ablocks -= *num_bits;
 	hfs_bitmap_dirty(sb);
 out:
-	up(&HFS_SB(sb)->bitmap_lock);
+	mutex_unlock(&HFS_SB(sb)->bitmap_lock);
 	return pos;
 }
 
@@ -205,7 +205,7 @@ int hfs_clear_vbm_bits(struct super_bloc
 	if ((start + count) > HFS_SB(sb)->fs_ablocks)
 		return -2;
 
-	down(&HFS_SB(sb)->bitmap_lock);
+	mutex_lock(&HFS_SB(sb)->bitmap_lock);
 	/* bitmap is always on a 32-bit boundary */
 	curr = HFS_SB(sb)->bitmap + (start / 32);
 	len = count;
@@ -236,7 +236,7 @@ int hfs_clear_vbm_bits(struct super_bloc
 	}
 out:
 	HFS_SB(sb)->free_ablocks += len;
-	up(&HFS_SB(sb)->bitmap_lock);
+	mutex_unlock(&HFS_SB(sb)->bitmap_lock);
 	hfs_bitmap_dirty(sb);
 
 	return 0;
diff -puN fs/hfs/hfs_fs.h~hfs-convert-bitmap_lock-in-a-mutex fs/hfs/hfs_fs.h
--- a/fs/hfs/hfs_fs.h~hfs-convert-bitmap_lock-in-a-mutex
+++ a/fs/hfs/hfs_fs.h
@@ -11,6 +11,7 @@
 
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
 
@@ -139,7 +140,7 @@ struct hfs_sb_info {
 
 	struct nls_table *nls_io, *nls_disk;
 
-	struct semaphore bitmap_lock;
+	struct mutex bitmap_lock;
 
 	unsigned long flags;
 
diff -puN fs/hfs/super.c~hfs-convert-bitmap_lock-in-a-mutex fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-convert-bitmap_lock-in-a-mutex
+++ a/fs/hfs/super.c
@@ -372,7 +372,7 @@ static int hfs_fill_super(struct super_b
 
 	sb->s_op = &hfs_super_operations;
 	sb->s_flags |= MS_NODIRATIME;
-	init_MUTEX(&sbi->bitmap_lock);
+	mutex_init(&sbi->bitmap_lock);
 
 	res = hfs_mdb_get(sb);
 	if (res) {
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
dlm-convert-connections_lock-in-a-mutex.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
pxafb-convert-ctrlr_sem-in-a-mutex.patch
sa1100fb-convert-ctrlr_sem-in-a-mutex.patch
hfs-convert-bitmap_lock-in-a-mutex.patch
hfs-convert-extents_lock-in-a-mutex.patch
affs-convert-s_bmlock-into-a-mutex.patch

