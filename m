From: akpm@linux-foundation.org
Subject: [merged] nilfs2-do-not-call-nilfs_mdt_bgl_lock-needlessly.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:00 -0800
Message-ID: <5640fe4c.kD3GwmKb11meUZPh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKIUNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: do not call nilfs_mdt_bgl_lock() needlessly
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-call-nilfs_mdt_bgl_lock-needlessly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: do not call nilfs_mdt_bgl_lock() needlessly

In the bitmap based allocator implementation, nilfs_mdt_bgl_lock() helper
is frequently used to get a spinlock protecting a target block group. 
This reduces its usage and simplifies arguments of some related functions
by directly passing a pointer to the spinlock.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   84 ++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 44 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-do-not-call-nilfs_mdt_bgl_lock-needlessly fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-do-not-call-nilfs_mdt_bgl_lock-needlessly
+++ a/fs/nilfs2/alloc.c
@@ -133,38 +133,34 @@ nilfs_palloc_bitmap_blkoff(const struct
 
 /**
  * nilfs_palloc_group_desc_nfrees - get the number of free entries in a group
- * @inode: inode of metadata file using this allocator
- * @group: group number
  * @desc: pointer to descriptor structure for the group
+ * @lock: spin lock protecting @desc
  */
 static unsigned long
-nilfs_palloc_group_desc_nfrees(struct inode *inode, unsigned long group,
-			       const struct nilfs_palloc_group_desc *desc)
+nilfs_palloc_group_desc_nfrees(const struct nilfs_palloc_group_desc *desc,
+			       spinlock_t *lock)
 {
 	unsigned long nfree;
 
-	spin_lock(nilfs_mdt_bgl_lock(inode, group));
+	spin_lock(lock);
 	nfree = le32_to_cpu(desc->pg_nfrees);
-	spin_unlock(nilfs_mdt_bgl_lock(inode, group));
+	spin_unlock(lock);
 	return nfree;
 }
 
 /**
  * nilfs_palloc_group_desc_add_entries - adjust count of free entries
- * @inode: inode of metadata file using this allocator
- * @group: group number
  * @desc: pointer to descriptor structure for the group
+ * @lock: spin lock protecting @desc
  * @n: delta to be added
  */
 static void
-nilfs_palloc_group_desc_add_entries(struct inode *inode,
-				    unsigned long group,
-				    struct nilfs_palloc_group_desc *desc,
-				    u32 n)
+nilfs_palloc_group_desc_add_entries(struct nilfs_palloc_group_desc *desc,
+				    spinlock_t *lock, u32 n)
 {
-	spin_lock(nilfs_mdt_bgl_lock(inode, group));
+	spin_lock(lock);
 	le32_add_cpu(&desc->pg_nfrees, n);
-	spin_unlock(nilfs_mdt_bgl_lock(inode, group));
+	spin_unlock(lock);
 }
 
 /**
@@ -332,17 +328,15 @@ void *nilfs_palloc_block_get_entry(const
 
 /**
  * nilfs_palloc_find_available_slot - find available slot in a group
- * @inode: inode of metadata file using this allocator
- * @group: group number
- * @target: offset number of an entry in the group (start point)
  * @bitmap: bitmap of the group
+ * @target: offset number of an entry in the group (start point)
  * @bsize: size in bits
+ * @lock: spin lock protecting @bitmap
  */
-static int nilfs_palloc_find_available_slot(struct inode *inode,
-					    unsigned long group,
+static int nilfs_palloc_find_available_slot(unsigned char *bitmap,
 					    unsigned long target,
-					    unsigned char *bitmap,
-					    int bsize)
+					    int bsize,
+					    spinlock_t *lock)
 {
 	int curr, pos, end, i;
 
@@ -351,12 +345,11 @@ static int nilfs_palloc_find_available_s
 		if (end > bsize)
 			end = bsize;
 		pos = nilfs_find_next_zero_bit(bitmap, end, target);
-		if (pos < end &&
-		    !nilfs_set_bit_atomic(
-			    nilfs_mdt_bgl_lock(inode, group), pos, bitmap))
+		if (pos < end && !nilfs_set_bit_atomic(lock, pos, bitmap))
 			return pos;
-	} else
+	} else {
 		end = 0;
+	}
 
 	for (i = 0, curr = end;
 	     i < bsize;
@@ -370,10 +363,8 @@ static int nilfs_palloc_find_available_s
 			if (end > bsize)
 				end = bsize;
 			pos = nilfs_find_next_zero_bit(bitmap, end, curr);
-			if ((pos < end) &&
-			    !nilfs_set_bit_atomic(
-				    nilfs_mdt_bgl_lock(inode, group), pos,
-				    bitmap))
+			if (pos < end &&
+			    !nilfs_set_bit_atomic(lock, pos, bitmap))
 				return pos;
 		}
 	}
@@ -477,6 +468,7 @@ int nilfs_palloc_prepare_alloc_entry(str
 	unsigned long group_offset, maxgroup_offset;
 	unsigned long n, entries_per_group, groups_per_desc_block;
 	unsigned long i, j;
+	spinlock_t *lock;
 	int pos, ret;
 
 	ngroups = nilfs_palloc_groups_count(inode);
@@ -501,8 +493,8 @@ int nilfs_palloc_prepare_alloc_entry(str
 		n = nilfs_palloc_rest_groups_in_desc_block(inode, group,
 							   maxgroup);
 		for (j = 0; j < n; j++, desc++, group++) {
-			if (nilfs_palloc_group_desc_nfrees(inode, group, desc)
-			    > 0) {
+			lock = nilfs_mdt_bgl_lock(inode, group);
+			if (nilfs_palloc_group_desc_nfrees(desc, lock) > 0) {
 				ret = nilfs_palloc_get_bitmap_block(
 					inode, group, 1, &bitmap_bh);
 				if (ret < 0)
@@ -510,12 +502,12 @@ int nilfs_palloc_prepare_alloc_entry(str
 				bitmap_kaddr = kmap(bitmap_bh->b_page);
 				bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 				pos = nilfs_palloc_find_available_slot(
-					inode, group, group_offset, bitmap,
-					entries_per_group);
+					bitmap, group_offset,
+					entries_per_group, lock);
 				if (pos >= 0) {
 					/* found a free entry */
 					nilfs_palloc_group_desc_add_entries(
-						inode, group, desc, -1);
+						desc, lock, -1);
 					req->pr_entry_nr =
 						entries_per_group * group + pos;
 					kunmap(desc_bh->b_page);
@@ -573,6 +565,7 @@ void nilfs_palloc_commit_free_entry(stru
 	unsigned long group, group_offset;
 	unsigned char *bitmap;
 	void *desc_kaddr, *bitmap_kaddr;
+	spinlock_t *lock;
 
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
 	desc_kaddr = kmap(req->pr_desc_bh->b_page);
@@ -580,15 +573,15 @@ void nilfs_palloc_commit_free_entry(stru
 						 req->pr_desc_bh, desc_kaddr);
 	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
+	lock = nilfs_mdt_bgl_lock(inode, group);
 
-	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
-				    group_offset, bitmap))
+	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
 		nilfs_warning(inode->i_sb, __func__,
 			      "entry number %llu already freed: ino=%lu\n",
 			      (unsigned long long)req->pr_entry_nr,
 			      (unsigned long)inode->i_ino);
 	else
-		nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
+		nilfs_palloc_group_desc_add_entries(desc, lock, 1);
 
 	kunmap(req->pr_bitmap_bh->b_page);
 	kunmap(req->pr_desc_bh->b_page);
@@ -613,6 +606,7 @@ void nilfs_palloc_abort_alloc_entry(stru
 	void *desc_kaddr, *bitmap_kaddr;
 	unsigned char *bitmap;
 	unsigned long group, group_offset;
+	spinlock_t *lock;
 
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
 	desc_kaddr = kmap(req->pr_desc_bh->b_page);
@@ -620,14 +614,15 @@ void nilfs_palloc_abort_alloc_entry(stru
 						 req->pr_desc_bh, desc_kaddr);
 	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
-	if (!nilfs_clear_bit_atomic(nilfs_mdt_bgl_lock(inode, group),
-				    group_offset, bitmap))
+	lock = nilfs_mdt_bgl_lock(inode, group);
+
+	if (!nilfs_clear_bit_atomic(lock, group_offset, bitmap))
 		nilfs_warning(inode->i_sb, __func__,
 			      "entry number %llu already freed: ino=%lu\n",
 			      (unsigned long long)req->pr_entry_nr,
 			      (unsigned long)inode->i_ino);
 	else
-		nilfs_palloc_group_desc_add_entries(inode, group, desc, 1);
+		nilfs_palloc_group_desc_add_entries(desc, lock, 1);
 
 	kunmap(req->pr_bitmap_bh->b_page);
 	kunmap(req->pr_desc_bh->b_page);
@@ -712,6 +707,7 @@ int nilfs_palloc_freev(struct inode *ino
 	unsigned char *bitmap;
 	void *desc_kaddr, *bitmap_kaddr;
 	unsigned long group, group_offset;
+	spinlock_t *lock;
 	int i, j, n, ret;
 
 	for (i = 0; i < nitems; i = j) {
@@ -730,14 +726,14 @@ int nilfs_palloc_freev(struct inode *ino
 			inode, group, desc_bh, desc_kaddr);
 		bitmap_kaddr = kmap(bitmap_bh->b_page);
 		bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
+		lock = nilfs_mdt_bgl_lock(inode, group);
 		for (j = i, n = 0;
 		     (j < nitems) && nilfs_palloc_group_is_in(inode, group,
 							      entry_nrs[j]);
 		     j++) {
 			nilfs_palloc_group(inode, entry_nrs[j], &group_offset);
-			if (!nilfs_clear_bit_atomic(
-				    nilfs_mdt_bgl_lock(inode, group),
-				    group_offset, bitmap)) {
+			if (!nilfs_clear_bit_atomic(lock, group_offset,
+						    bitmap)) {
 				nilfs_warning(inode->i_sb, __func__,
 					      "entry number %llu already freed: ino=%lu\n",
 					      (unsigned long long)entry_nrs[j],
@@ -746,7 +742,7 @@ int nilfs_palloc_freev(struct inode *ino
 				n++;
 			}
 		}
-		nilfs_palloc_group_desc_add_entries(inode, group, desc, n);
+		nilfs_palloc_group_desc_add_entries(desc, lock, n);
 
 		kunmap(bitmap_bh->b_page);
 		kunmap(desc_bh->b_page);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


