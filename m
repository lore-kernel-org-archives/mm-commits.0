From: akpm@linux-foundation.org
Subject: [patch 080/126] mm, memcg: use consistent gfp flags during
 readahead
Date: Tue, 26 Jul 2016 15:24:53 -0700
Message-ID: <5797e335.82unwk17I5D2I3i3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439AbcGZWYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, clm@fb.com, cm224.lee@samsung.com, hubcap@omnibond.com, jack@suse.cz, jaegeuk@kernel.org, sfrench@samba.org, tytso@mit.edu, vdavydov@parallels.com, yuchao0@huawei.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, memcg: use consistent gfp flags during readahead

Vladimir has noticed that we might declare memcg oom even during readahead
because read_pages only uses GFP_KERNEL (with mapping_gfp restriction)
while __do_page_cache_readahead uses page_cache_alloc_readahead which adds
__GFP_NORETRY to prevent from OOMs.  This gfp mask discrepancy is really
unfortunate and easily fixable.  Drop page_cache_alloc_readahead() which
only has one user and outsource the gfp_mask logic into readahead_gfp_mask
and propagate this mask from __do_page_cache_readahead down to read_pages.

This alone would have only very limited impact as most filesystems are
implementing ->readpages and the common implementation mpage_readpages
does GFP_KERNEL (with mapping_gfp restriction) again.  We can tell it to
use readahead_gfp_mask instead as this function is called only during
readahead as well.  The same applies to read_cache_pages.

ext4 has its own ext4_mpage_readpages but the path which has pages != NULL
can use the same gfp mask.  Btrfs, cifs, f2fs and orangefs are doing a
very similar pattern to mpage_readpages so the same can be applied to them
as well.

[akpm@linux-foundation.org: coding-style fixes]
[mhocko@suse.com: restrict gfp mask in mpage_alloc]
  Link: http://lkml.kernel.org/r/20160610074223.GC32285@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/1465301556-26431-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Chris Mason <clm@fb.com>
Cc: Steve French <sfrench@samba.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Changman Lee <cm224.lee@samsung.com>
Cc: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/extent_io.c    |    3 ++-
 fs/cifs/file.c          |    2 +-
 fs/ext4/readpage.c      |    2 +-
 fs/f2fs/data.c          |    3 ++-
 fs/mpage.c              |    4 +++-
 fs/orangefs/inode.c     |    2 +-
 include/linux/pagemap.h |    6 +++---
 mm/readahead.c          |   13 ++++++-------
 8 files changed, 19 insertions(+), 16 deletions(-)

diff -puN fs/btrfs/extent_io.c~mm-memcg-use-consistent-gfp-flags-during-readahead fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~mm-memcg-use-consistent-gfp-flags-during-readahead
+++ a/fs/btrfs/extent_io.c
@@ -4180,7 +4180,8 @@ int extent_readpages(struct extent_io_tr
 		prefetchw(&page->flags);
 		list_del(&page->lru);
 		if (add_to_page_cache_lru(page, mapping,
-					page->index, GFP_NOFS)) {
+					page->index,
+					readahead_gfp_mask(mapping))) {
 			put_page(page);
 			continue;
 		}
diff -puN fs/cifs/file.c~mm-memcg-use-consistent-gfp-flags-during-readahead fs/cifs/file.c
--- a/fs/cifs/file.c~mm-memcg-use-consistent-gfp-flags-during-readahead
+++ a/fs/cifs/file.c
@@ -3366,7 +3366,7 @@ readpages_get_pages(struct address_space
 	struct page *page, *tpage;
 	unsigned int expected_index;
 	int rc;
-	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
+	gfp_t gfp = readahead_gfp_mask(mapping);
 
 	INIT_LIST_HEAD(tmplist);
 
diff -puN fs/ext4/readpage.c~mm-memcg-use-consistent-gfp-flags-during-readahead fs/ext4/readpage.c
--- a/fs/ext4/readpage.c~mm-memcg-use-consistent-gfp-flags-during-readahead
+++ a/fs/ext4/readpage.c
@@ -166,7 +166,7 @@ int ext4_mpage_readpages(struct address_
 			page = list_entry(pages->prev, struct page, lru);
 			list_del(&page->lru);
 			if (add_to_page_cache_lru(page, mapping, page->index,
-				  mapping_gfp_constraint(mapping, GFP_KERNEL)))
+				  readahead_gfp_mask(mapping)))
 				goto next_page;
 		}
 
diff -puN fs/f2fs/data.c~mm-memcg-use-consistent-gfp-flags-during-readahead fs/f2fs/data.c
--- a/fs/f2fs/data.c~mm-memcg-use-consistent-gfp-flags-during-readahead
+++ a/fs/f2fs/data.c
@@ -996,7 +996,8 @@ static int f2fs_mpage_readpages(struct a
 			page = list_entry(pages->prev, struct page, lru);
 			list_del(&page->lru);
 			if (add_to_page_cache_lru(page, mapping,
-						  page->index, GFP_KERNEL))
+						  page->index,
+						  readahead_gfp_mask(mapping)))
 				goto next_page;
 		}
 
diff -puN fs/mpage.c~mm-memcg-use-consistent-gfp-flags-during-readahead fs/mpage.c
--- a/fs/mpage.c~mm-memcg-use-consistent-gfp-flags-during-readahead
+++ a/fs/mpage.c
@@ -71,6 +71,8 @@ mpage_alloc(struct block_device *bdev,
 {
 	struct bio *bio;
 
+	/* Restrict the given (page cache) mask for slab allocations */
+	gfp_flags &= GFP_KERNEL;
 	bio = bio_alloc(gfp_flags, nr_vecs);
 
 	if (bio == NULL && (current->flags & PF_MEMALLOC)) {
@@ -362,7 +364,7 @@ mpage_readpages(struct address_space *ma
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
-	gfp_t gfp = mapping_gfp_constraint(mapping, GFP_KERNEL);
+	gfp_t gfp = readahead_gfp_mask(mapping);
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
diff -puN fs/orangefs/inode.c~mm-memcg-use-consistent-gfp-flags-during-readahead fs/orangefs/inode.c
--- a/fs/orangefs/inode.c~mm-memcg-use-consistent-gfp-flags-during-readahead
+++ a/fs/orangefs/inode.c
@@ -80,7 +80,7 @@ static int orangefs_readpages(struct fil
 		if (!add_to_page_cache(page,
 				       mapping,
 				       page->index,
-				       GFP_KERNEL)) {
+				       readahead_gfp_mask(mapping))) {
 			ret = read_one_page(page);
 			gossip_debug(GOSSIP_INODE_DEBUG,
 				"failure adding page to cache, read_one_page returned: %d\n",
diff -puN include/linux/pagemap.h~mm-memcg-use-consistent-gfp-flags-during-readahead include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-memcg-use-consistent-gfp-flags-during-readahead
+++ a/include/linux/pagemap.h
@@ -209,10 +209,10 @@ static inline struct page *page_cache_al
 	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
 }
 
-static inline struct page *page_cache_alloc_readahead(struct address_space *x)
+static inline gfp_t readahead_gfp_mask(struct address_space *x)
 {
-	return __page_cache_alloc(mapping_gfp_mask(x) |
-				  __GFP_COLD | __GFP_NORETRY | __GFP_NOWARN);
+	return mapping_gfp_mask(x) |
+				  __GFP_COLD | __GFP_NORETRY | __GFP_NOWARN;
 }
 
 typedef int filler_t(void *, struct page *);
diff -puN mm/readahead.c~mm-memcg-use-consistent-gfp-flags-during-readahead mm/readahead.c
--- a/mm/readahead.c~mm-memcg-use-consistent-gfp-flags-during-readahead
+++ a/mm/readahead.c
@@ -89,7 +89,7 @@ int read_cache_pages(struct address_spac
 		page = lru_to_page(pages);
 		list_del(&page->lru);
 		if (add_to_page_cache_lru(page, mapping, page->index,
-				mapping_gfp_constraint(mapping, GFP_KERNEL))) {
+				readahead_gfp_mask(mapping))) {
 			read_cache_pages_invalidate_page(mapping, page);
 			continue;
 		}
@@ -108,7 +108,7 @@ int read_cache_pages(struct address_spac
 EXPORT_SYMBOL(read_cache_pages);
 
 static int read_pages(struct address_space *mapping, struct file *filp,
-		struct list_head *pages, unsigned nr_pages)
+		struct list_head *pages, unsigned int nr_pages, gfp_t gfp)
 {
 	struct blk_plug plug;
 	unsigned page_idx;
@@ -126,10 +126,8 @@ static int read_pages(struct address_spa
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = lru_to_page(pages);
 		list_del(&page->lru);
-		if (!add_to_page_cache_lru(page, mapping, page->index,
-				mapping_gfp_constraint(mapping, GFP_KERNEL))) {
+		if (!add_to_page_cache_lru(page, mapping, page->index, gfp))
 			mapping->a_ops->readpage(filp, page);
-		}
 		put_page(page);
 	}
 	ret = 0;
@@ -159,6 +157,7 @@ int __do_page_cache_readahead(struct add
 	int page_idx;
 	int ret = 0;
 	loff_t isize = i_size_read(inode);
+	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 
 	if (isize == 0)
 		goto out;
@@ -180,7 +179,7 @@ int __do_page_cache_readahead(struct add
 		if (page && !radix_tree_exceptional_entry(page))
 			continue;
 
-		page = page_cache_alloc_readahead(mapping);
+		page = __page_cache_alloc(gfp_mask);
 		if (!page)
 			break;
 		page->index = page_offset;
@@ -196,7 +195,7 @@ int __do_page_cache_readahead(struct add
 	 * will then handle the error.
 	 */
 	if (ret)
-		read_pages(mapping, filp, &page_pool, ret);
+		read_pages(mapping, filp, &page_pool, ret, gfp_mask);
 	BUG_ON(!list_empty(&page_pool));
 out:
 	return ret;
_
