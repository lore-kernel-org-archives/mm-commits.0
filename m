From: akpm@linux-foundation.org
Subject: [merged] mm-fs-introduce-mapping_gfp_constraint.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:44:42 -0800
Message-ID: <5640f7aa.KkF5OdpY/ao0MzwW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbbKITom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, fs: introduce mapping_gfp_constraint()
has been removed from the -mm tree.  Its filename was
     mm-fs-introduce-mapping_gfp_constraint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, fs: introduce mapping_gfp_constraint()

There are many places which use mapping_gfp_mask to restrict a more
generic gfp mask which would be used for allocations which are not
directly related to the page cache but they are performed in the same
context.

Let's introduce a helper function which makes the restriction explicit and
easier to track.  This patch doesn't introduce any functional changes.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c       |    2 +-
 drivers/gpu/drm/i915/i915_gem.c |    3 +--
 fs/btrfs/compression.c          |    7 +++----
 fs/btrfs/ctree.h                |    2 +-
 fs/btrfs/free-space-cache.c     |    4 ++--
 fs/buffer.c                     |    2 +-
 fs/ceph/addr.c                  |    7 ++++---
 fs/cifs/file.c                  |    2 +-
 fs/ext4/inode.c                 |    2 +-
 fs/ext4/readpage.c              |    2 +-
 fs/logfs/segment.c              |    2 +-
 fs/mpage.c                      |    4 ++--
 fs/namei.c                      |    2 +-
 fs/nilfs2/inode.c               |    4 ++--
 fs/ntfs/file.c                  |    4 ++--
 fs/splice.c                     |    2 +-
 include/linux/pagemap.h         |    7 +++++++
 mm/filemap.c                    |    4 ++--
 mm/readahead.c                  |    4 ++--
 19 files changed, 36 insertions(+), 30 deletions(-)

diff -puN drivers/gpu/drm/drm_gem.c~mm-fs-introduce-mapping_gfp_constraint drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/drivers/gpu/drm/drm_gem.c
@@ -491,7 +491,7 @@ struct page **drm_gem_get_pages(struct d
 		 * __GFP_DMA32 to be set in mapping_gfp_mask(inode->i_mapping)
 		 * so shmem can relocate pages during swapin if required.
 		 */
-		BUG_ON((mapping_gfp_mask(mapping) & __GFP_DMA32) &&
+		BUG_ON(mapping_gfp_constraint(mapping, __GFP_DMA32) &&
 				(page_to_pfn(p) >= 0x00100000UL));
 	}
 
diff -puN drivers/gpu/drm/i915/i915_gem.c~mm-fs-introduce-mapping_gfp_constraint drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -2214,9 +2214,8 @@ i915_gem_object_get_pages_gtt(struct drm
 	 * Fail silently without starting the shrinker
 	 */
 	mapping = file_inode(obj->base.filp)->i_mapping;
-	gfp = mapping_gfp_mask(mapping);
+	gfp = mapping_gfp_constraint(mapping, ~(__GFP_IO | __GFP_RECLAIM));
 	gfp |= __GFP_NORETRY | __GFP_NOWARN;
-	gfp &= ~(__GFP_IO | __GFP_RECLAIM);
 	sg = st->sgl;
 	st->nents = 0;
 	for (i = 0; i < page_count; i++) {
diff -puN fs/btrfs/compression.c~mm-fs-introduce-mapping_gfp_constraint fs/btrfs/compression.c
--- a/fs/btrfs/compression.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/btrfs/compression.c
@@ -482,13 +482,12 @@ static noinline int add_ra_bio_pages(str
 			goto next;
 		}
 
-		page = __page_cache_alloc(mapping_gfp_mask(mapping) &
-								~__GFP_FS);
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
diff -puN fs/btrfs/ctree.h~mm-fs-introduce-mapping_gfp_constraint fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/btrfs/ctree.h
@@ -3316,7 +3316,7 @@ static inline bool btrfs_mixed_space_inf
 
 static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 {
-	return mapping_gfp_mask(mapping) & ~__GFP_FS;
+	return mapping_gfp_constraint(mapping, ~__GFP_FS);
 }
 
 /* extent-tree.c */
diff -puN fs/btrfs/free-space-cache.c~mm-fs-introduce-mapping_gfp_constraint fs/btrfs/free-space-cache.c
--- a/fs/btrfs/free-space-cache.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/btrfs/free-space-cache.c
@@ -85,8 +85,8 @@ static struct inode *__lookup_free_space
 	}
 
 	mapping_set_gfp_mask(inode->i_mapping,
-			mapping_gfp_mask(inode->i_mapping) &
-			~(__GFP_FS | __GFP_HIGHMEM));
+			mapping_gfp_constraint(inode->i_mapping,
+			~(__GFP_FS | __GFP_HIGHMEM)));
 
 	return inode;
 }
diff -puN fs/buffer.c~mm-fs-introduce-mapping_gfp_constraint fs/buffer.c
--- a/fs/buffer.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/buffer.c
@@ -999,7 +999,7 @@ grow_dev_page(struct block_device *bdev,
 	int ret = 0;		/* Will call free_more_memory() */
 	gfp_t gfp_mask;
 
-	gfp_mask = (mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS) | gfp;
+	gfp_mask = mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS) | gfp;
 
 	/*
 	 * XXX: __getblk_slow() can not really deal with failure and
diff -puN fs/ceph/addr.c~mm-fs-introduce-mapping_gfp_constraint fs/ceph/addr.c
--- a/fs/ceph/addr.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/ceph/addr.c
@@ -1283,8 +1283,8 @@ static int ceph_filemap_fault(struct vm_
 		int ret1;
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page = find_or_create_page(mapping, 0,
-						mapping_gfp_mask(mapping) &
-						~__GFP_FS);
+						mapping_gfp_constraint(mapping,
+						~__GFP_FS));
 		if (!page) {
 			ret = VM_FAULT_OOM;
 			goto out;
@@ -1428,7 +1428,8 @@ void ceph_fill_inline_data(struct inode
 		if (i_size_read(inode) == 0)
 			return;
 		page = find_or_create_page(mapping, 0,
-					   mapping_gfp_mask(mapping) & ~__GFP_FS);
+					   mapping_gfp_constraint(mapping,
+					   ~__GFP_FS));
 		if (!page)
 			return;
 		if (PageUptodate(page)) {
diff -puN fs/cifs/file.c~mm-fs-introduce-mapping_gfp_constraint fs/cifs/file.c
--- a/fs/cifs/file.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/cifs/file.c
@@ -3380,7 +3380,7 @@ readpages_get_pages(struct address_space
 	struct page *page, *tpage;
 	unsigned int expected_index;
 	int rc;
-	gfp_t gfp = GFP_KERNEL & mapping_gfp_mask(mapping);
+	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 
 	INIT_LIST_HEAD(tmplist);
 
diff -puN fs/ext4/inode.c~mm-fs-introduce-mapping_gfp_constraint fs/ext4/inode.c
--- a/fs/ext4/inode.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/ext4/inode.c
@@ -3344,7 +3344,7 @@ static int __ext4_block_zero_page_range(
 	int err = 0;
 
 	page = find_or_create_page(mapping, from >> PAGE_CACHE_SHIFT,
-				   mapping_gfp_mask(mapping) & ~__GFP_FS);
+				   mapping_gfp_constraint(mapping, ~__GFP_FS));
 	if (!page)
 		return -ENOMEM;
 
diff -puN fs/ext4/readpage.c~mm-fs-introduce-mapping_gfp_constraint fs/ext4/readpage.c
--- a/fs/ext4/readpage.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/ext4/readpage.c
@@ -166,7 +166,7 @@ int ext4_mpage_readpages(struct address_
 			page = list_entry(pages->prev, struct page, lru);
 			list_del(&page->lru);
 			if (add_to_page_cache_lru(page, mapping, page->index,
-					GFP_KERNEL & mapping_gfp_mask(mapping)))
+				  mapping_gfp_constraint(mapping, GFP_KERNEL)))
 				goto next_page;
 		}
 
diff -puN fs/logfs/segment.c~mm-fs-introduce-mapping_gfp_constraint fs/logfs/segment.c
--- a/fs/logfs/segment.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/logfs/segment.c
@@ -57,7 +57,7 @@ static struct page *get_mapping_page(str
 	filler_t *filler = super->s_devops->readpage;
 	struct page *page;
 
-	BUG_ON(mapping_gfp_mask(mapping) & __GFP_FS);
+	BUG_ON(mapping_gfp_constraint(mapping, __GFP_FS));
 	if (use_filler)
 		page = read_cache_page(mapping, index, filler, sb);
 	else {
diff -puN fs/mpage.c~mm-fs-introduce-mapping_gfp_constraint fs/mpage.c
--- a/fs/mpage.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/mpage.c
@@ -361,7 +361,7 @@ mpage_readpages(struct address_space *ma
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
-	gfp_t gfp = GFP_KERNEL & mapping_gfp_mask(mapping);
+	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
@@ -397,7 +397,7 @@ int mpage_readpage(struct page *page, ge
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
-	gfp_t gfp = GFP_KERNEL & mapping_gfp_mask(page->mapping);
+	gfp_t gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
diff -puN fs/namei.c~mm-fs-introduce-mapping_gfp_constraint fs/namei.c
--- a/fs/namei.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/namei.c
@@ -4604,7 +4604,7 @@ EXPORT_SYMBOL(__page_symlink);
 int page_symlink(struct inode *inode, const char *symname, int len)
 {
 	return __page_symlink(inode, symname, len,
-			!(mapping_gfp_mask(inode->i_mapping) & __GFP_FS));
+			!mapping_gfp_constraint(inode->i_mapping, __GFP_FS));
 }
 EXPORT_SYMBOL(page_symlink);
 
diff -puN fs/nilfs2/inode.c~mm-fs-introduce-mapping_gfp_constraint fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/nilfs2/inode.c
@@ -356,7 +356,7 @@ struct inode *nilfs_new_inode(struct ino
 		goto failed;
 
 	mapping_set_gfp_mask(inode->i_mapping,
-			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
+			   mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS));
 
 	root = NILFS_I(dir)->i_root;
 	ii = NILFS_I(inode);
@@ -522,7 +522,7 @@ static int __nilfs_read_inode(struct sup
 	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
 	nilfs_set_inode_flags(inode);
 	mapping_set_gfp_mask(inode->i_mapping,
-			     mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
+			   mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS));
 	return 0;
 
  failed_unmap:
diff -puN fs/ntfs/file.c~mm-fs-introduce-mapping_gfp_constraint fs/ntfs/file.c
--- a/fs/ntfs/file.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/ntfs/file.c
@@ -525,8 +525,8 @@ static inline int __ntfs_grab_cache_page
 				}
 			}
 			err = add_to_page_cache_lru(*cached_page, mapping,
-					index,
-					GFP_KERNEL & mapping_gfp_mask(mapping));
+				   index,
+				   mapping_gfp_constraint(mapping, GFP_KERNEL));
 			if (unlikely(err)) {
 				if (err == -EEXIST)
 					continue;
diff -puN fs/splice.c~mm-fs-introduce-mapping_gfp_constraint fs/splice.c
--- a/fs/splice.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/fs/splice.c
@@ -360,7 +360,7 @@ __generic_file_splice_read(struct file *
 				break;
 
 			error = add_to_page_cache_lru(page, mapping, index,
-					GFP_KERNEL & mapping_gfp_mask(mapping));
+				   mapping_gfp_constraint(mapping, GFP_KERNEL));
 			if (unlikely(error)) {
 				page_cache_release(page);
 				if (error == -EEXIST)
diff -puN include/linux/pagemap.h~mm-fs-introduce-mapping_gfp_constraint include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-fs-introduce-mapping_gfp_constraint
+++ a/include/linux/pagemap.h
@@ -69,6 +69,13 @@ static inline gfp_t mapping_gfp_mask(str
 	return (__force gfp_t)mapping->flags & __GFP_BITS_MASK;
 }
 
+/* Restricts the given gfp_mask to what the mapping allows. */
+static inline gfp_t mapping_gfp_constraint(struct address_space *mapping,
+		gfp_t gfp_mask)
+{
+	return mapping_gfp_mask(mapping) & gfp_mask;
+}
+
 /*
  * This is non-atomic.  Only to be used before the mapping is activated.
  * Probably needs a barrier...
diff -puN mm/filemap.c~mm-fs-introduce-mapping_gfp_constraint mm/filemap.c
--- a/mm/filemap.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/mm/filemap.c
@@ -1722,7 +1722,7 @@ no_cached_page:
 			goto out;
 		}
 		error = add_to_page_cache_lru(page, mapping, index,
-					GFP_KERNEL & mapping_gfp_mask(mapping));
+				mapping_gfp_constraint(mapping, GFP_KERNEL));
 		if (error) {
 			page_cache_release(page);
 			if (error == -EEXIST) {
@@ -1824,7 +1824,7 @@ static int page_cache_read(struct file *
 			return -ENOMEM;
 
 		ret = add_to_page_cache_lru(page, mapping, offset,
-				GFP_KERNEL & mapping_gfp_mask(mapping));
+				mapping_gfp_constraint(mapping, GFP_KERNEL));
 		if (ret == 0)
 			ret = mapping->a_ops->readpage(file, page);
 		else if (ret == -EEXIST)
diff -puN mm/readahead.c~mm-fs-introduce-mapping_gfp_constraint mm/readahead.c
--- a/mm/readahead.c~mm-fs-introduce-mapping_gfp_constraint
+++ a/mm/readahead.c
@@ -90,7 +90,7 @@ int read_cache_pages(struct address_spac
 		page = list_to_page(pages);
 		list_del(&page->lru);
 		if (add_to_page_cache_lru(page, mapping, page->index,
-				GFP_KERNEL & mapping_gfp_mask(mapping))) {
+				mapping_gfp_constraint(mapping, GFP_KERNEL))) {
 			read_cache_pages_invalidate_page(mapping, page);
 			continue;
 		}
@@ -128,7 +128,7 @@ static int read_pages(struct address_spa
 		struct page *page = list_to_page(pages);
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping, page->index,
-				GFP_KERNEL & mapping_gfp_mask(mapping))) {
+				mapping_gfp_constraint(mapping, GFP_KERNEL))) {
 			mapping->a_ops->readpage(filp, page);
 		}
 		page_cache_release(page);
_

Patches currently in -mm which might be from mhocko@suse.com are


