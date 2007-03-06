From: akpm@linux-foundation.org
Subject: - reiser4-use-page_offset.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:12 -0800
Message-ID: <200703060200.l2620CB9008712@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46606 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965679AbXCFCAT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zam@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: use page_offset
has been removed from the -mm tree.  Its filename was
     reiser4-use-page_offset.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: use page_offset
From: Alexaner Zarochentsev <zam@namesys.com>

Replace ((loff_t)page->index << PAGE_CACHE_SHIFT) by page_offset(page)

Signed-off-by: Alexander Zarochentsev <zam@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/entd.c                        |    5 +++--
 fs/reiser4/page_cache.c                  |    2 +-
 fs/reiser4/plugin/file/file.c            |   15 +++++----------
 fs/reiser4/plugin/file/tail_conversion.c |    5 +----
 fs/reiser4/plugin/item/extent_file_ops.c |    2 +-
 5 files changed, 11 insertions(+), 18 deletions(-)

diff -puN fs/reiser4/entd.c~reiser4-use-page_offset fs/reiser4/entd.c
--- a/fs/reiser4/entd.c~reiser4-use-page_offset
+++ a/fs/reiser4/entd.c
@@ -232,8 +232,9 @@ static void entd_flush(struct super_bloc
 	ctx.entd = 1;
 	ctx.gfp_mask = GFP_NOFS;
 
-	rq->wbc->range_start = rq->page->index << PAGE_CACHE_SHIFT;
-	rq->wbc->range_end = (rq->page->index + ENTD_CAPTURE_APAGE_BURST) << PAGE_CACHE_SHIFT;
+	rq->wbc->range_start = page_offset(rq->page);
+	rq->wbc->range_end = rq->wbc->range_start +
+		(ENTD_CAPTURE_APAGE_BURST << PAGE_CACHE_SHIFT);
 	tmp = rq->wbc->nr_to_write;
 	rq->mapping->a_ops->writepages(rq->mapping, rq->wbc);
 
diff -puN fs/reiser4/page_cache.c~reiser4-use-page_offset fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-use-page_offset
+++ a/fs/reiser4/page_cache.c
@@ -609,7 +609,7 @@ static void invalidate_unformatted(jnode
 		page_cache_get(page);
 		spin_unlock_jnode(node);
 		/* FIXME: use truncate_complete_page instead */
-		from = (loff_t) page->index << PAGE_CACHE_SHIFT;
+		from = page_offset(page);
 		to = from + PAGE_CACHE_SIZE - 1;
 		truncate_inode_pages_range(page->mapping, from, to);
 		page_cache_release(page);
diff -puN fs/reiser4/plugin/file/file.c~reiser4-use-page_offset fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-use-page_offset
+++ a/fs/reiser4/plugin/file/file.c
@@ -796,8 +796,7 @@ int find_or_create_extent(struct page *p
 
 	if (node->blocknr == 0) {
 		plugged_hole = 0;
-		result = reiser4_update_extent(inode, node,
-					(loff_t)page->index << PAGE_CACHE_SHIFT,
+		result = reiser4_update_extent(inode, node, page_offset(page),
 					       &plugged_hole);
 		if (result) {
  			JF_CLR(node, JNODE_WRITE_PREPARED);
@@ -865,7 +864,7 @@ static int capture_page_and_create_exten
 	       unix_file_inode_data(inode)->container == UF_CONTAINER_EXTENTS);
 	/* page belongs to file */
 	assert("vs-1393",
-	       inode->i_size > ((loff_t) page->index << PAGE_CACHE_SHIFT));
+	       inode->i_size > page_offset(page));
 
 	/* page capture may require extent creation (if it does not exist yet)
 	   and stat data's update (number of blocks changes on extent
@@ -1428,8 +1427,7 @@ int readpage_unix_file(struct file *file
 	assert("vs-976", !PageUptodate(page));
 	assert("vs-1061", page->mapping && page->mapping->host);
 
-	if ((page->mapping->host->i_size <=
-	     ((loff_t) page->index << PAGE_CACHE_SHIFT))) {
+	if (page->mapping->host->i_size <= page_offset(page)) {
 		/* page is out of file already */
 		unlock_page(page);
 		return -EINVAL;
@@ -1459,9 +1457,7 @@ int readpage_unix_file(struct file *file
 	lh = &hint->lh;
 
 	/* get key of first byte of the page */
-	key_by_inode_and_offset_common(inode,
-				       (loff_t) page->index << PAGE_CACHE_SHIFT,
-				       &key);
+	key_by_inode_and_offset_common(inode, page_offset(page), &key);
 
 	/* look for file metadata corresponding to first byte of page */
 	page_cache_get(page);
@@ -1520,8 +1516,7 @@ int readpage_unix_file(struct file *file
 		return result;
 	}
 
-	validate_extended_coord(&hint->ext_coord,
-				(loff_t) page->index << PAGE_CACHE_SHIFT);
+	validate_extended_coord(&hint->ext_coord, page_offset(page));
 
 	if (!coord_is_existing_unit(coord)) {
 		/* this indicates corruption */
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-use-page_offset fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-use-page_offset
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -159,10 +159,7 @@ static int replace(struct inode *inode, 
 	assert("vs-596", pages[0]);
 
 	/* cut copied items */
-	result =
-	    cut_formatting_items(inode,
-				 (loff_t) pages[0]->index << PAGE_CACHE_SHIFT,
-				 count);
+	result = cut_formatting_items(inode, page_offset(pages[0]), count);
 	if (result)
 		return result;
 
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-page_offset fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-page_offset
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1017,7 +1017,7 @@ ssize_t reiser4_write_extent(struct file
 		if (to_page > left)
 			to_page = left;
 		page = jnode_page(jnodes[i]);
-		if (((loff_t)page->index << PAGE_CACHE_SHIFT) < inode->i_size &&
+		if (page_offset(page) < inode->i_size &&
 		    !PageUptodate(page) && to_page != PAGE_CACHE_SIZE) {
 			/*
 			 * the above is not optimal for partial write to last
_

Patches currently in -mm which might be from zam@namesys.com are

reiser4.patch
reiser4-use-page_offset.patch
reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch
reiser4-re-add-page_count-check-to-reiser4_releasepage.patch
reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
