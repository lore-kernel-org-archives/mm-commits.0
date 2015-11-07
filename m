From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 16:11:12 -0800
Message-ID: <563d41a0.elUIuqli88rI5W93%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbbKGALN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:11:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-fs-introduce-mapping_gfp_constraint.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#46: FILE: drivers/gpu/drm/drm_gem.c:494:
+		BUG_ON(mapping_gfp_constraint(mapping, __GFP_DMA32) &&

WARNING: line over 80 characters
#73: FILE: fs/btrfs/compression.c:485:
+		page = __page_cache_alloc(mapping_gfp_constraint(mapping, ~__GFP_FS));

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#183: FILE: fs/logfs/segment.c:60:
+	BUG_ON(mapping_gfp_constraint(mapping, __GFP_FS));

WARNING: line over 80 characters
#228: FILE: fs/nilfs2/inode.c:359:
+			     mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS));

WARNING: line over 80 characters
#237: FILE: fs/nilfs2/inode.c:525:
+			     mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS));

WARNING: line over 80 characters
#249: FILE: fs/ntfs/file.c:529:
+					mapping_gfp_constraint(mapping, GFP_KERNEL));

WARNING: line over 80 characters
#261: FILE: fs/splice.c:363:
+					mapping_gfp_constraint(mapping, GFP_KERNEL));

WARNING: line over 80 characters
#290: FILE: mm/filemap.c:1725:
+					mapping_gfp_constraint(mapping, GFP_KERNEL));

total: 0 errors, 8 warnings, 205 lines checked

./patches/mm-fs-introduce-mapping_gfp_constraint.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/compression.c |    6 +++---
 fs/nilfs2/inode.c      |    4 ++--
 fs/ntfs/file.c         |    4 ++--
 fs/splice.c            |    2 +-
 mm/filemap.c           |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/btrfs/compression.c~mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes fs/btrfs/compression.c
--- a/fs/btrfs/compression.c~mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes
+++ a/fs/btrfs/compression.c
@@ -482,12 +482,12 @@ static noinline int add_ra_bio_pages(str
 			goto next;
 		}
 
-		page = __page_cache_alloc(mapping_gfp_constraint(mapping, ~__GFP_FS));
+		page = __page_cache_alloc(mapping_gfp_constraint(mapping,
+								 ~__GFP_FS));
 		if (!page)
 			break;
 
-		if (add_to_page_cache_lru(page, mapping, pg_index,
-								GFP_NOFS)) {
+		if (add_to_page_cache_lru(page, mapping, pg_index, GFP_NOFS)) {
 			page_cache_release(page);
 			goto next;
 		}
diff -puN fs/nilfs2/inode.c~mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes
+++ a/fs/nilfs2/inode.c
@@ -356,7 +356,7 @@ struct inode *nilfs_new_inode(struct ino
 		goto failed;
 
 	mapping_set_gfp_mask(inode->i_mapping,
-			     mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS));
+			   mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS));
 
 	root = NILFS_I(dir)->i_root;
 	ii = NILFS_I(inode);
@@ -522,7 +522,7 @@ static int __nilfs_read_inode(struct sup
 	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	nilfs_set_inode_flags(inode);
 	mapping_set_gfp_mask(inode->i_mapping,
-			     mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS));
+			   mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS));
 	return 0;
 
  failed_unmap:
diff -puN fs/ntfs/file.c~mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes fs/ntfs/file.c
--- a/fs/ntfs/file.c~mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes
+++ a/fs/ntfs/file.c
@@ -525,8 +525,8 @@ static inline int __ntfs_grab_cache_page
 				}
 			}
 			err = add_to_page_cache_lru(*cached_page, mapping,
-					index,
-					mapping_gfp_constraint(mapping, GFP_KERNEL));
+				   index,
+				   mapping_gfp_constraint(mapping, GFP_KERNEL));
 			if (unlikely(err)) {
 				if (err == -EEXIST)
 					continue;
diff -puN fs/splice.c~mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes fs/splice.c
--- a/fs/splice.c~mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes
+++ a/fs/splice.c
@@ -360,7 +360,7 @@ __generic_file_splice_read(struct file *
 				break;
 
 			error = add_to_page_cache_lru(page, mapping, index,
-					mapping_gfp_constraint(mapping, GFP_KERNEL));
+				   mapping_gfp_constraint(mapping, GFP_KERNEL));
 			if (unlikely(error)) {
 				page_cache_release(page);
 				if (error == -EEXIST)
diff -puN mm/filemap.c~mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes mm/filemap.c
--- a/mm/filemap.c~mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes
+++ a/mm/filemap.c
@@ -1722,7 +1722,7 @@ no_cached_page:
 			goto out;
 		}
 		error = add_to_page_cache_lru(page, mapping, index,
-					mapping_gfp_constraint(mapping, GFP_KERNEL));
+				mapping_gfp_constraint(mapping, GFP_KERNEL));
 		if (error) {
 			page_cache_release(page);
 			if (error == -EEXIST) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint.patch
mm-memcontrolc-uninline-mem_cgroup_usage.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

