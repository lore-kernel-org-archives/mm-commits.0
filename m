From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-free-unused-dat-file-blocks-during-garbage-collection.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 12:13:06 -0800
Message-ID: <5640fe52.dafD877Vh4PQTzcy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKIUNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: free unused dat file blocks during garbage collection
has been removed from the -mm tree.  Its filename was
     nilfs2-free-unused-dat-file-blocks-during-garbage-collection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: free unused dat file blocks during garbage collection

As a nilfs2 volume ages, the amount of available disk space decreases
little by little due to bloat of DAT (disk address translation) metadata
file.  Even if we delete all files in a file system and free their block
addresses from the DAT file through a garbage collection, empty DAT blocks
are not freed.

This fixes the issue by extending the deallocator of block addresses so
that empty data blocks and empty bitmap blocks of DAT are deleted.

The following comparison shows the effect of this patch.  Each shows disk
amount information of a nilfs2 volume that we cleaned out by deleting all
files and running gc after having filled 90% of its capacity.

Before:
Filesystem     1K-blocks     Used Available Use% Mounted on
/dev/sda1      500105212  3022844 472072192   1% /test

After:
Filesystem     1K-blocks     Used Available Use% Mounted on
/dev/sda1      500105212    16380 475078656   1% /test

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   91 +++++++++++++++++++++++++++++++++++---------
 fs/nilfs2/alloc.h |    1 
 2 files changed, 75 insertions(+), 17 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-free-unused-dat-file-blocks-during-garbage-collection fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-free-unused-dat-file-blocks-during-garbage-collection
+++ a/fs/nilfs2/alloc.c
@@ -154,13 +154,17 @@ nilfs_palloc_group_desc_nfrees(const str
  * @lock: spin lock protecting @desc
  * @n: delta to be added
  */
-static void
+static u32
 nilfs_palloc_group_desc_add_entries(struct nilfs_palloc_group_desc *desc,
 				    spinlock_t *lock, u32 n)
 {
+	u32 nfree;
+
 	spin_lock(lock);
 	le32_add_cpu(&desc->pg_nfrees, n);
+	nfree = le32_to_cpu(desc->pg_nfrees);
 	spin_unlock(lock);
+	return nfree;
 }
 
 /**
@@ -735,12 +739,18 @@ int nilfs_palloc_freev(struct inode *ino
 	unsigned char *bitmap;
 	void *desc_kaddr, *bitmap_kaddr;
 	unsigned long group, group_offset;
-	__u64 group_min_nr;
+	__u64 group_min_nr, last_nrs[8];
 	const unsigned long epg = nilfs_palloc_entries_per_group(inode);
+	const unsigned epb = NILFS_MDT(inode)->mi_entries_per_block;
+	unsigned entry_start, end, pos;
 	spinlock_t *lock;
-	int i, j, n, ret;
+	int i, j, k, ret;
+	u32 nfree;
 
 	for (i = 0; i < nitems; i = j) {
+		int change_group = false;
+		int nempties = 0, n = 0;
+
 		group = nilfs_palloc_group(inode, entry_nrs[i], &group_offset);
 		ret = nilfs_palloc_get_desc_block(inode, group, 0, &desc_bh);
 		if (ret < 0)
@@ -755,17 +765,13 @@ int nilfs_palloc_freev(struct inode *ino
 		/* Get the first entry number of the group */
 		group_min_nr = (__u64)group * epg;
 
-		desc_kaddr = kmap(desc_bh->b_page);
-		desc = nilfs_palloc_block_get_group_desc(
-			inode, group, desc_bh, desc_kaddr);
 		bitmap_kaddr = kmap(bitmap_bh->b_page);
 		bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 		lock = nilfs_mdt_bgl_lock(inode, group);
-		for (j = i, n = 0;
-		     j < nitems && entry_nrs[j] >= group_min_nr &&
-			     entry_nrs[j] < group_min_nr + epg;
-		     j++) {
-			group_offset = entry_nrs[j] - group_min_nr;
+
+		j = i;
+		entry_start = rounddown(group_offset, epb);
+		do {
 			if (!nilfs_clear_bit_atomic(lock, group_offset,
 						    bitmap)) {
 				nilfs_warning(inode->i_sb, __func__,
@@ -775,18 +781,69 @@ int nilfs_palloc_freev(struct inode *ino
 			} else {
 				n++;
 			}
-		}
-		nilfs_palloc_group_desc_add_entries(desc, lock, n);
+
+			j++;
+			if (j >= nitems || entry_nrs[j] < group_min_nr ||
+			    entry_nrs[j] >= group_min_nr + epg) {
+				change_group = true;
+			} else {
+				group_offset = entry_nrs[j] - group_min_nr;
+				if (group_offset >= entry_start &&
+				    group_offset < entry_start + epb) {
+					/* This entry is in the same block */
+					continue;
+				}
+			}
+
+			/* Test if the entry block is empty or not */
+			end = entry_start + epb;
+			pos = nilfs_find_next_bit(bitmap, end, entry_start);
+			if (pos >= end) {
+				last_nrs[nempties++] = entry_nrs[j - 1];
+				if (nempties >= ARRAY_SIZE(last_nrs))
+					break;
+			}
+
+			if (change_group)
+				break;
+
+			/* Go on to the next entry block */
+			entry_start = rounddown(group_offset, epb);
+		} while (true);
 
 		kunmap(bitmap_bh->b_page);
-		kunmap(desc_bh->b_page);
+		mark_buffer_dirty(bitmap_bh);
+		brelse(bitmap_bh);
+
+		for (k = 0; k < nempties; k++) {
+			ret = nilfs_palloc_delete_entry_block(inode,
+							      last_nrs[k]);
+			if (ret && ret != -ENOENT) {
+				nilfs_warning(inode->i_sb, __func__,
+					      "failed to delete block of entry %llu: ino=%lu, err=%d\n",
+					      (unsigned long long)last_nrs[k],
+					      (unsigned long)inode->i_ino, ret);
+			}
+		}
 
+		desc_kaddr = kmap_atomic(desc_bh->b_page);
+		desc = nilfs_palloc_block_get_group_desc(
+			inode, group, desc_bh, desc_kaddr);
+		nfree = nilfs_palloc_group_desc_add_entries(desc, lock, n);
+		kunmap_atomic(desc_kaddr);
 		mark_buffer_dirty(desc_bh);
-		mark_buffer_dirty(bitmap_bh);
 		nilfs_mdt_mark_dirty(inode);
-
-		brelse(bitmap_bh);
 		brelse(desc_bh);
+
+		if (nfree == nilfs_palloc_entries_per_group(inode)) {
+			ret = nilfs_palloc_delete_bitmap_block(inode, group);
+			if (ret && ret != -ENOENT) {
+				nilfs_warning(inode->i_sb, __func__,
+					      "failed to delete bitmap block of group %lu: ino=%lu, err=%d\n",
+					      group,
+					      (unsigned long)inode->i_ino, ret);
+			}
+		}
 	}
 	return 0;
 }
diff -puN fs/nilfs2/alloc.h~nilfs2-free-unused-dat-file-blocks-during-garbage-collection fs/nilfs2/alloc.h
--- a/fs/nilfs2/alloc.h~nilfs2-free-unused-dat-file-blocks-during-garbage-collection
+++ a/fs/nilfs2/alloc.h
@@ -77,6 +77,7 @@ int nilfs_palloc_freev(struct inode *, _
 #define nilfs_set_bit_atomic		ext2_set_bit_atomic
 #define nilfs_clear_bit_atomic		ext2_clear_bit_atomic
 #define nilfs_find_next_zero_bit	find_next_zero_bit_le
+#define nilfs_find_next_bit		find_next_bit_le
 
 /**
  * struct nilfs_bh_assoc - block offset and buffer head association
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


