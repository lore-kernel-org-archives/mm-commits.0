From: akpm@linux-foundation.org
Subject: - hfsplus-convert-the-extents_lock-in-a-mutex.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:06 -0700
Message-ID: <200807252257.m6PMv6GG003153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448AbYGYXGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfsplus: convert the extents_lock in a mutex
has been removed from the -mm tree.  Its filename was
     hfsplus-convert-the-extents_lock-in-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfsplus: convert the extents_lock in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

Apple Extended HFS file system: The semaphore extents lock is used as a
mutex.  Convert it to the mutex API.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c    |   14 +++++++-------
 fs/hfsplus/hfsplus_fs.h |    3 ++-
 fs/hfsplus/inode.c      |    4 ++--
 fs/hfsplus/super.c      |    2 +-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff -puN fs/hfsplus/extents.c~hfsplus-convert-the-extents_lock-in-a-mutex fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-convert-the-extents_lock-in-a-mutex
+++ a/fs/hfsplus/extents.c
@@ -199,16 +199,16 @@ int hfsplus_get_block(struct inode *inod
 		goto done;
 	}
 
-	down(&HFSPLUS_I(inode).extents_lock);
+	mutex_lock(&HFSPLUS_I(inode).extents_lock);
 	res = hfsplus_ext_read_extent(inode, ablock);
 	if (!res) {
 		dblock = hfsplus_ext_find_block(HFSPLUS_I(inode).cached_extents, ablock -
 					     HFSPLUS_I(inode).cached_start);
 	} else {
-		up(&HFSPLUS_I(inode).extents_lock);
+		mutex_unlock(&HFSPLUS_I(inode).extents_lock);
 		return -EIO;
 	}
-	up(&HFSPLUS_I(inode).extents_lock);
+	mutex_unlock(&HFSPLUS_I(inode).extents_lock);
 
 done:
 	dprint(DBG_EXTENT, "get_block(%lu): %llu - %u\n", inode->i_ino, (long long)iblock, dblock);
@@ -355,7 +355,7 @@ int hfsplus_file_extend(struct inode *in
 		return -ENOSPC;
 	}
 
-	down(&HFSPLUS_I(inode).extents_lock);
+	mutex_lock(&HFSPLUS_I(inode).extents_lock);
 	if (HFSPLUS_I(inode).alloc_blocks == HFSPLUS_I(inode).first_blocks)
 		goal = hfsplus_ext_lastblock(HFSPLUS_I(inode).first_extents);
 	else {
@@ -408,7 +408,7 @@ int hfsplus_file_extend(struct inode *in
 			goto insert_extent;
 	}
 out:
-	up(&HFSPLUS_I(inode).extents_lock);
+	mutex_unlock(&HFSPLUS_I(inode).extents_lock);
 	if (!res) {
 		HFSPLUS_I(inode).alloc_blocks += len;
 		mark_inode_dirty(inode);
@@ -465,7 +465,7 @@ void hfsplus_file_truncate(struct inode 
 	if (blk_cnt == alloc_cnt)
 		goto out;
 
-	down(&HFSPLUS_I(inode).extents_lock);
+	mutex_lock(&HFSPLUS_I(inode).extents_lock);
 	hfs_find_init(HFSPLUS_SB(sb).ext_tree, &fd);
 	while (1) {
 		if (alloc_cnt == HFSPLUS_I(inode).first_blocks) {
@@ -492,7 +492,7 @@ void hfsplus_file_truncate(struct inode 
 		hfs_brec_remove(&fd);
 	}
 	hfs_find_exit(&fd);
-	up(&HFSPLUS_I(inode).extents_lock);
+	mutex_unlock(&HFSPLUS_I(inode).extents_lock);
 
 	HFSPLUS_I(inode).alloc_blocks = blk_cnt;
 out:
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-convert-the-extents_lock-in-a-mutex fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-convert-the-extents_lock-in-a-mutex
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -11,6 +11,7 @@
 #define _LINUX_HFSPLUS_FS_H
 
 #include <linux/fs.h>
+#include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include "hfsplus_raw.h"
 
@@ -154,7 +155,7 @@ struct hfsplus_sb_info {
 
 
 struct hfsplus_inode_info {
-	struct semaphore extents_lock;
+	struct mutex extents_lock;
 	u32 clump_blocks, alloc_blocks;
 	sector_t fs_blocks;
 	/* Allocation extents from catalog record or volume header */
diff -puN fs/hfsplus/inode.c~hfsplus-convert-the-extents_lock-in-a-mutex fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-convert-the-extents_lock-in-a-mutex
+++ a/fs/hfsplus/inode.c
@@ -163,7 +163,7 @@ static struct dentry *hfsplus_file_looku
 
 	inode->i_ino = dir->i_ino;
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
-	init_MUTEX(&HFSPLUS_I(inode).extents_lock);
+	mutex_init(&HFSPLUS_I(inode).extents_lock);
 	HFSPLUS_I(inode).flags = HFSPLUS_FLG_RSRC;
 
 	hfs_find_init(HFSPLUS_SB(sb).cat_tree, &fd);
@@ -316,7 +316,7 @@ struct inode *hfsplus_new_inode(struct s
 	inode->i_nlink = 1;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
-	init_MUTEX(&HFSPLUS_I(inode).extents_lock);
+	mutex_init(&HFSPLUS_I(inode).extents_lock);
 	atomic_set(&HFSPLUS_I(inode).opencnt, 0);
 	HFSPLUS_I(inode).flags = 0;
 	memset(HFSPLUS_I(inode).first_extents, 0, sizeof(hfsplus_extent_rec));
diff -puN fs/hfsplus/super.c~hfsplus-convert-the-extents_lock-in-a-mutex fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-convert-the-extents_lock-in-a-mutex
+++ a/fs/hfsplus/super.c
@@ -34,7 +34,7 @@ struct inode *hfsplus_iget(struct super_
 		return inode;
 
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
-	init_MUTEX(&HFSPLUS_I(inode).extents_lock);
+	mutex_init(&HFSPLUS_I(inode).extents_lock);
 	HFSPLUS_I(inode).flags = 0;
 	HFSPLUS_I(inode).rsrc_inode = NULL;
 	atomic_set(&HFSPLUS_I(inode).opencnt, 0);
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

origin.patch
linux-next.patch
affs-convert-s_bmlock-into-a-mutex.patch

