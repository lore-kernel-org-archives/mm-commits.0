From: akpm@linux-foundation.org
Subject: [merged] gcc-46-btrfs-clean-up-unused-variables-bugs.patch removed from -mm tree
Date: Fri, 05 Nov 2010 11:29:14 -0700
Message-ID: <201011051830.oA5IUuAk025683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183Ab0KESbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 14:31:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, chris.mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     gcc-4.6: btrfs: clean up unused variables -- bugs
has been removed from the -mm tree.  Its filename was
     gcc-46-btrfs-clean-up-unused-variables-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcc-4.6: btrfs: clean up unused variables -- bugs
From: Andi Kleen <andi@firstfloor.org>

These are all the cases where a variable is set, but not
read which are really bugs.

- Couple of incorrect error handling fixed.
- One incorrect use of a allocation policy
- Some other things

Still needs more review.

Found by gcc 4.6's new warnings.

[akpm@linux-foundation.org: fix build.  Might have been bitrot]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/dir-item.c    |    2 +-
 fs/btrfs/extent-tree.c |    3 +--
 fs/btrfs/extent_io.c   |    2 ++
 fs/btrfs/inode.c       |    6 +++---
 fs/btrfs/relocation.c  |    4 +++-
 fs/btrfs/tree-log.c    |    2 +-
 6 files changed, 11 insertions(+), 8 deletions(-)

diff -puN fs/btrfs/dir-item.c~gcc-46-btrfs-clean-up-unused-variables-bugs fs/btrfs/dir-item.c
--- a/fs/btrfs/dir-item.c~gcc-46-btrfs-clean-up-unused-variables-bugs
+++ a/fs/btrfs/dir-item.c
@@ -427,5 +427,5 @@ int btrfs_delete_one_dir_name(struct btr
 		ret = btrfs_truncate_item(trans, root, path,
 					  item_len - sub_item_len, 1);
 	}
-	return 0;
+	return ret;
 }
diff -puN fs/btrfs/extent-tree.c~gcc-46-btrfs-clean-up-unused-variables-bugs fs/btrfs/extent-tree.c
--- a/fs/btrfs/extent-tree.c~gcc-46-btrfs-clean-up-unused-variables-bugs
+++ a/fs/btrfs/extent-tree.c
@@ -3336,8 +3336,7 @@ struct btrfs_block_rsv *btrfs_alloc_bloc
 	btrfs_init_block_rsv(block_rsv);
 
 	alloc_target = btrfs_get_alloc_profile(root, 0);
-	block_rsv->space_info = __find_space_info(fs_info,
-						  BTRFS_BLOCK_GROUP_METADATA);
+	block_rsv->space_info = __find_space_info(fs_info, alloc_target);
 
 	return block_rsv;
 }
diff -puN fs/btrfs/extent_io.c~gcc-46-btrfs-clean-up-unused-variables-bugs fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~gcc-46-btrfs-clean-up-unused-variables-bugs
+++ a/fs/btrfs/extent_io.c
@@ -2832,6 +2832,8 @@ int extent_prepare_write(struct extent_i
 					 NULL, 1,
 					 end_bio_extent_preparewrite, 0,
 					 0, 0);
+			if (ret && !err)
+				err = ret;
 			iocount++;
 			block_start = block_start + iosize;
 		} else {
diff -puN fs/btrfs/inode.c~gcc-46-btrfs-clean-up-unused-variables-bugs fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~gcc-46-btrfs-clean-up-unused-variables-bugs
+++ a/fs/btrfs/inode.c
@@ -1372,7 +1372,7 @@ int btrfs_merge_bio_hook(struct page *pa
 
 	if (map_length < length + size)
 		return 1;
-	return 0;
+	return ret;
 }
 
 /*
@@ -2672,8 +2672,8 @@ static int check_path_shared(struct btrf
 {
 	struct extent_buffer *eb;
 	int level;
-	int ret;
 	u64 refs = 1;
+	int uninitialized_var(ret);
 
 	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
 		if (!path->nodes[level])
@@ -2686,7 +2686,7 @@ static int check_path_shared(struct btrf
 		if (refs > 1)
 			return 1;
 	}
-	return 0;
+	return ret; /* XXX callers? */
 }
 
 /*
diff -puN fs/btrfs/relocation.c~gcc-46-btrfs-clean-up-unused-variables-bugs fs/btrfs/relocation.c
--- a/fs/btrfs/relocation.c~gcc-46-btrfs-clean-up-unused-variables-bugs
+++ a/fs/btrfs/relocation.c
@@ -3099,6 +3099,8 @@ static int add_tree_block(struct reloc_c
 		BUG_ON(item_size != sizeof(struct btrfs_extent_item_v0));
 		ret = get_ref_objectid_v0(rc, path, extent_key,
 					  &ref_owner, NULL);
+		if (ret < 0)
+			return ret;
 		BUG_ON(ref_owner >= BTRFS_MAX_LEVEL);
 		level = (int)ref_owner;
 		/* FIXME: get real generation */
@@ -4143,7 +4145,7 @@ int btrfs_reloc_clone_csums(struct inode
 		btrfs_add_ordered_sum(inode, ordered, sums);
 	}
 	btrfs_put_ordered_extent(ordered);
-	return 0;
+	return ret;
 }
 
 void btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
diff -puN fs/btrfs/tree-log.c~gcc-46-btrfs-clean-up-unused-variables-bugs fs/btrfs/tree-log.c
--- a/fs/btrfs/tree-log.c~gcc-46-btrfs-clean-up-unused-variables-bugs
+++ a/fs/btrfs/tree-log.c
@@ -2273,7 +2273,7 @@ fail:
 	}
 	btrfs_end_log_trans(root);
 
-	return 0;
+	return err;
 }
 
 /* see comments for btrfs_del_dir_entries_in_log */
_

Patches currently in -mm which might be from andi@firstfloor.org are


