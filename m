From: akpm@linux-foundation.org
Subject: + gcc-46-btrfs-clean-up-unused-variables-bugs.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:29 -0700
Message-ID: <201006182331.o5INVTFd029537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab0FRXbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, chris.mason@oracle.com


The patch titled
     gcc-4.6: btrfs: clean up unused variables -- bugs
has been added to the -mm tree.  Its filename is
     gcc-46-btrfs-clean-up-unused-variables-bugs.patch

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
Subject: gcc-4.6: btrfs: clean up unused variables -- bugs
From: Andi Kleen <andi@firstfloor.org>

These are all the cases where a variable is set, but not
read which are really bugs.

- Couple of incorrect error handling fixed.
- One incorrect use of a allocation policy
- Some other things

Still needs more review.

Found by gcc 4.6's new warnings.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/dir-item.c    |    2 +-
 fs/btrfs/extent-tree.c |    3 +--
 fs/btrfs/extent_io.c   |    2 ++
 fs/btrfs/inode.c       |    5 ++---
 fs/btrfs/relocation.c  |    4 +++-
 fs/btrfs/tree-log.c    |    2 +-
 6 files changed, 10 insertions(+), 8 deletions(-)

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
@@ -3337,8 +3337,7 @@ struct btrfs_block_rsv *btrfs_alloc_bloc
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
@@ -2823,6 +2823,8 @@ int extent_prepare_write(struct extent_i
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
@@ -2672,7 +2672,6 @@ static int check_path_shared(struct btrf
 {
 	struct extent_buffer *eb;
 	int level;
-	int ret;
 	u64 refs = 1;
 
 	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
@@ -2686,7 +2685,7 @@ static int check_path_shared(struct btrf
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

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

