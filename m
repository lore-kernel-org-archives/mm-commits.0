From: akpm@linux-foundation.org
Subject: + drm-i915-use-shmem_read_mapping_page.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:29 -0700
Message-ID: <201106092242.p59MgTAo005040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756686Ab1FIWtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, airlied@redhat.com, chris@chris-wilson.co.uk, hch@infradead.org, keithp@keithp.com


The patch titled
     drm/i915: use shmem_read_mapping_page
has been added to the -mm tree.  Its filename is
     drm-i915-use-shmem_read_mapping_page.patch

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
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -795,8 +794,7 @@ i915_gem_shmem_pwrite_fast(struct drm_de
 		if ((page_offset + remain) > PAGE_SIZE)
 			page_length = PAGE_SIZE - page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
@@ -905,8 +903,7 @@ i915_gem_shmem_pwrite_slow(struct drm_de
 		if ((data_page_offset + page_length) > PAGE_SIZE)
 			page_length = PAGE_SIZE - data_page_offset;
 
-		page = read_cache_page_gfp(mapping, offset >> PAGE_SHIFT,
-					   GFP_HIGHUSER | __GFP_RECLAIMABLE);
+		page = shmem_read_mapping_page(mapping, offset >> PAGE_SHIFT);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			goto out;
@@ -1556,12 +1553,10 @@ i915_gem_object_get_pages_gtt(struct drm
 
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

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
linux-next.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
prio_tree-debugging-patch.patch

