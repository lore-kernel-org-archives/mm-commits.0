From: akpm@linux-foundation.org
Subject: [merged] drm-ttm-use-shmem_read_mapping_page.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:54 -0700
Message-ID: <201106282042.p5SKgafb003028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab1F1Umm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, airlied@redhat.com, hch@infradead.org, thellstrom@vmware.com, mm-commits@vger.kernel.org


The patch titled
     drm/ttm: use shmem_read_mapping_page
has been removed from the -mm tree.  Its filename was
     drm-ttm-use-shmem_read_mapping_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/ttm: use shmem_read_mapping_page
From: Hugh Dickins <hughd@google.com>

Soon tmpfs will stop supporting ->readpage and read_mapping_page(): once
"tmpfs: add shmem_read_mapping_page_gfp" has been applied, this patch can
be applied to ease the transition.

ttm_tt_swapin() and ttm_tt_swapout() use shmem_read_mapping_page() in
place of read_mapping_page(), since their swap_space has been created with
shmem_file_setup().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/ttm/ttm_tt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/ttm/ttm_tt.c~drm-ttm-use-shmem_read_mapping_page drivers/gpu/drm/ttm/ttm_tt.c
--- a/drivers/gpu/drm/ttm/ttm_tt.c~drm-ttm-use-shmem_read_mapping_page
+++ a/drivers/gpu/drm/ttm/ttm_tt.c
@@ -31,6 +31,7 @@
 #include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/shmem_fs.h>
 #include <linux/file.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
@@ -484,7 +485,7 @@ static int ttm_tt_swapin(struct ttm_tt *
 	swap_space = swap_storage->f_path.dentry->d_inode->i_mapping;
 
 	for (i = 0; i < ttm->num_pages; ++i) {
-		from_page = read_mapping_page(swap_space, i, NULL);
+		from_page = shmem_read_mapping_page(swap_space, i);
 		if (IS_ERR(from_page)) {
 			ret = PTR_ERR(from_page);
 			goto out_err;
@@ -557,7 +558,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, s
 		from_page = ttm->pages[i];
 		if (unlikely(from_page == NULL))
 			continue;
-		to_page = read_mapping_page(swap_space, i, NULL);
+		to_page = shmem_read_mapping_page(swap_space, i);
 		if (unlikely(IS_ERR(to_page))) {
 			ret = PTR_ERR(to_page);
 			goto out_err;
_

Patches currently in -mm which might be from hughd@google.com are

mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
tmpfs-clone-shmem_file_splice_read.patch
tmpfs-refine-shmem_file_splice_read.patch
tmpfs-pass-gfp-to-shmem_getpage_gfp.patch
tmpfs-remove_shmem_readpage.patch
tmpfs-simplify-prealloc_page.patch
tmpfs-simplify-filepage-swappage.patch
tmpfs-simplify-unuse-and-writepage.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
prio_tree-debugging-patch.patch

