From: akpm@linux-foundation.org
Subject: + mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 05 Oct 2015 12:36:26 -0700
Message-ID: <5612d13a.FSfobECqGNsPv1+g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbbJETg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 15:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

