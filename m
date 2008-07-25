From: akpm@linux-foundation.org
Subject: - hfs-convert-extents_lock-in-a-mutex.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:04 -0700
Message-ID: <200807252257.m6PMv47F003150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986AbYGYW5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs: convert extents_lock in a mutex
has been removed from the -mm tree.  Its filename was
     hfs-convert-extents_lock-in-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs: convert extents_lock in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

Apple Macintosh file system: The semaphore extens_lock is used as a mutex.
Convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/btree.c  |    2 +-
 fs/hfs/extent.c |   14 +++++++-------
 fs/hfs/hfs_fs.h |    2 +-
 fs/hfs/inode.c  |    4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/hfs/btree.c~hfs-convert-extents_lock-in-a-mutex fs/hfs/btree.c
--- a/fs/hfs/btree.c~hfs-convert-extents_lock-in-a-mutex
+++ a/fs/hfs/btree.c
@@ -40,7 +40,7 @@ struct hfs_btree *hfs_btree_open(struct 
 	{
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 	HFS_I(tree->inode)->flags = 0;
-	init_MUTEX(&HFS_I(tree->inode)->extents_lock);
+	mutex_init(&HFS_I(tree->inode)->extents_lock);
 	switch (id) {
 	case HFS_EXT_CNID:
 		hfs_inode_read_fork(tree->inode, mdb->drXTExtRec, mdb->drXTFlSize,
diff -puN fs/hfs/extent.c~hfs-convert-extents_lock-in-a-mutex fs/hfs/extent.c
--- a/fs/hfs/extent.c~hfs-convert-extents_lock-in-a-mutex
+++ a/fs/hfs/extent.c
@@ -343,16 +343,16 @@ int hfs_get_block(struct inode *inode, s
 		goto done;
 	}
 
-	down(&HFS_I(inode)->extents_lock);
+	mutex_lock(&HFS_I(inode)->extents_lock);
 	res = hfs_ext_read_extent(inode, ablock);
 	if (!res)
 		dblock = hfs_ext_find_block(HFS_I(inode)->cached_extents,
 					    ablock - HFS_I(inode)->cached_start);
 	else {
-		up(&HFS_I(inode)->extents_lock);
+		mutex_unlock(&HFS_I(inode)->extents_lock);
 		return -EIO;
 	}
-	up(&HFS_I(inode)->extents_lock);
+	mutex_unlock(&HFS_I(inode)->extents_lock);
 
 done:
 	map_bh(bh_result, sb, HFS_SB(sb)->fs_start +
@@ -375,7 +375,7 @@ int hfs_extend_file(struct inode *inode)
 	u32 start, len, goal;
 	int res;
 
-	down(&HFS_I(inode)->extents_lock);
+	mutex_lock(&HFS_I(inode)->extents_lock);
 	if (HFS_I(inode)->alloc_blocks == HFS_I(inode)->first_blocks)
 		goal = hfs_ext_lastblock(HFS_I(inode)->first_extents);
 	else {
@@ -425,7 +425,7 @@ int hfs_extend_file(struct inode *inode)
 			goto insert_extent;
 	}
 out:
-	up(&HFS_I(inode)->extents_lock);
+	mutex_unlock(&HFS_I(inode)->extents_lock);
 	if (!res) {
 		HFS_I(inode)->alloc_blocks += len;
 		mark_inode_dirty(inode);
@@ -487,7 +487,7 @@ void hfs_file_truncate(struct inode *ino
 	if (blk_cnt == alloc_cnt)
 		goto out;
 
-	down(&HFS_I(inode)->extents_lock);
+	mutex_lock(&HFS_I(inode)->extents_lock);
 	hfs_find_init(HFS_SB(sb)->ext_tree, &fd);
 	while (1) {
 		if (alloc_cnt == HFS_I(inode)->first_blocks) {
@@ -514,7 +514,7 @@ void hfs_file_truncate(struct inode *ino
 		hfs_brec_remove(&fd);
 	}
 	hfs_find_exit(&fd);
-	up(&HFS_I(inode)->extents_lock);
+	mutex_unlock(&HFS_I(inode)->extents_lock);
 
 	HFS_I(inode)->alloc_blocks = blk_cnt;
 out:
diff -puN fs/hfs/hfs_fs.h~hfs-convert-extents_lock-in-a-mutex fs/hfs/hfs_fs.h
--- a/fs/hfs/hfs_fs.h~hfs-convert-extents_lock-in-a-mutex
+++ a/fs/hfs/hfs_fs.h
@@ -54,7 +54,7 @@ struct hfs_inode_info {
 	struct list_head open_dir_list;
 	struct inode *rsrc_inode;
 
-	struct semaphore extents_lock;
+	struct mutex extents_lock;
 
 	u16 alloc_blocks, clump_blocks;
 	sector_t fs_blocks;
diff -puN fs/hfs/inode.c~hfs-convert-extents_lock-in-a-mutex fs/hfs/inode.c
--- a/fs/hfs/inode.c~hfs-convert-extents_lock-in-a-mutex
+++ a/fs/hfs/inode.c
@@ -150,7 +150,7 @@ struct inode *hfs_new_inode(struct inode
 	if (!inode)
 		return NULL;
 
-	init_MUTEX(&HFS_I(inode)->extents_lock);
+	mutex_init(&HFS_I(inode)->extents_lock);
 	INIT_LIST_HEAD(&HFS_I(inode)->open_dir_list);
 	hfs_cat_build_key(sb, (btree_key *)&HFS_I(inode)->cat_key, dir->i_ino, name);
 	inode->i_ino = HFS_SB(sb)->next_id++;
@@ -281,7 +281,7 @@ static int hfs_read_inode(struct inode *
 
 	HFS_I(inode)->flags = 0;
 	HFS_I(inode)->rsrc_inode = NULL;
-	init_MUTEX(&HFS_I(inode)->extents_lock);
+	mutex_init(&HFS_I(inode)->extents_lock);
 	INIT_LIST_HEAD(&HFS_I(inode)->open_dir_list);
 
 	/* Initialize the inode */
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

origin.patch
linux-next.patch
affs-convert-s_bmlock-into-a-mutex.patch

