From: akpm@linux-foundation.org
Subject: [merged] drm-i915-use-shmem_read_mapping_page.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:56 -0700
Message-ID: <201106282042.p5SKgcld003031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab1F1Umx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, airlied@redhat.com, chris@chris-wilson.co.uk, hch@infradead.org, keithp@keithp.com, mm-commits@vger.kernel.org


The patch titled
     drm/i915: use shmem_read_mapping_page
has been removed from the -mm tree.  Its filename was
     drm-i915-use-shmem_read_mapping_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/i915: use shmem_read_mapping_page
From: Hugh Dickins <hughd@google.com>

Soon tmpfs will stop supporting ->readpage and read_cache_page_gfp(): once
"tmpfs: add shmem_read_mapping_page_gfp" has been applied, this patch can
be applied to ease the transition.

Make i915_gem_object_get_pages_gtt() use shmem_read_mapping_page_gfp() in
the one place it's needed; elsewhere use shmem_read_mapping_page(), with
the mapping's gfp_mask properly initialized.

Forget about __GFP_COLD: since tmpfs initializes its pages with memset,
asking for a cold page is counter-productive.

Include linux/shmem_fs.h also in drm_gem.c: with shmem_file_setup() now
declared there too, we shall remove the prototype from linux/mm.h later.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c       |    1 
 drivers/gpu/drm/i915/i915_gem.c |   31 +++++++++++++-----------------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff -puN drivers/gpu/drm/drm_gem.c~drm-i915-use-shmem_read_mapping_page drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~drm-i915-use-shmem_read_mapping_page
+++ a/drivers/gpu/drm/drm_gem.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
+#include <linux/shmem_fs.h>
 #include "drmP.h"
 
 /** @file drm_gem.c
diff -puN drivers/gpu/drm/i915/i915_gem.c~drm-i915-use-shmem_read_mapping_page drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~drm-i915-use-shmem_read_mapping_page
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -31,6 +31,7 @@
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include "intel_drv.h"
+#include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/pci.h>
@@ -359,8 +360,7 @@ i915_gem_shmem_pread_fast(struct drm_dev
 		if ((page_offset + remain) > PAGE_SIZE)
 			page_length = PAGE_SIZE - page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -463,8 +463,7 @@ i915_gem_shmem_pread_slow(struct drm_dev
 		if ((data_page_offset + page_length) > PAGE_SIZE)
 			page_length = PAGE_SIZE - data_page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			goto out;
@@ -797,8 +796,7 @@ i915_gem_shmem_pwrite_fast(struct drm_de
 		if ((page_offset + remain) > PAGE_SIZE)
 			page_length = PAGE_SIZE - page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -907,8 +905,7 @@ i915_gem_shmem_pwrite_slow(struct drm_de
 		if ((data_page_offset + page_length) > PAGE_SIZE)
 			page_length = PAGE_SIZE - data_page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			goto out;
@@ -1558,12 +1555,10 @@ i915_gem_object_get_pages_gtt(struct drm
 
 	inode = obj->base.filp->f_path.dentry->d_inode;
 	mapping = inode->i_mapping;
+	gfpmask |= mapping_gfp_mask(mapping);
+
 	for (i = 0; i < page_count; i++) {
-		page = read_cache_page_gfp(mapping, i,
-					   GFP_HIGHUSER |
-					   __GFP_COLD |
-					   __GFP_RECLAIMABLE |
-					   gfpmask);
+		page = shmem_read_mapping_page_gfp(mapping, i, gfpmask);
 		if (IS_ERR(page))
 			goto err_pages;
 
@@ -3565,6 +3560,7 @@ struct drm_i915_gem_object *i915_gem_all
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_i915_gem_object *obj;
+	struct address_space *mapping;
 
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
 	if (obj == NULL)
@@ -3575,6 +3571,9 @@ struct drm_i915_gem_object *i915_gem_all
 		return NULL;
 	}
 
+	mapping = obj->base.filp->f_path.dentry->d_inode->i_mapping;
+	mapping_set_gfp_mask(mapping, GFP_HIGHUSER | __GFP_RECLAIMABLE);
+
 	i915_gem_info_add_obj(dev_priv, size);
 
 	obj->base.write_domain = I915_GEM_DOMAIN_CPU;
@@ -3950,8 +3949,7 @@ void i915_gem_detach_phys_object(struct 
 
 	page_count = obj->base.size / PAGE_SIZE;
 	for (i = 0; i < page_count; i++) {
-		struct page *page = read_cache_page_gfp(mapping, i,
-							GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		struct page *page = shmem_read_mapping_page(mapping, i);
 		if (!IS_ERR(page)) {
 			char *dst = kmap_atomic(page);
 			memcpy(dst, vaddr + i*PAGE_SIZE, PAGE_SIZE);
@@ -4012,8 +4010,7 @@ i915_gem_attach_phys_object(struct drm_d
 		struct page *page;
 		char *dst, *src;
 
-		page = read_cache_page_gfp(mapping, i,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, i);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
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

