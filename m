From: akpm@linux-foundation.org
Subject: - use-page_cache_xxx-for-fs-xfs.patch removed from -mm tree
Date: Tue, 04 Mar 2008 11:47:35 -0800
Message-ID: <200803041947.m24JlZLj025678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbYCDTsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 14:48:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dgc@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Use page_cache_xxx for fs/xfs
has been removed from the -mm tree.  Its filename was
     use-page_cache_xxx-for-fs-xfs.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use page_cache_xxx for fs/xfs
From: Christoph Lameter <clameter@sgi.com>

Use page_cache_xxx for fs/xfs

Reviewed-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_aops.c |   58 +++++++++++++++++-----------------
 fs/xfs/linux-2.6/xfs_lrw.c  |    4 +-
 2 files changed, 32 insertions(+), 30 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_aops.c~use-page_cache_xxx-for-fs-xfs fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~use-page_cache_xxx-for-fs-xfs
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -75,7 +75,7 @@ xfs_page_trace(
 	xfs_inode_t	*ip;
 	bhv_vnode_t	*vp = vn_from_inode(inode);
 	loff_t		isize = i_size_read(inode);
-	loff_t		offset = page_offset(page);
+	loff_t		offset = page_cache_pos(inode->i_mapping, page->index, 0);
 	int		delalloc = -1, unmapped = -1, unwritten = -1;
 
 	if (page_has_buffers(page))
@@ -599,11 +599,12 @@ xfs_probe_page(
 	int			mapped)
 {
 	int			ret = 0;
+	struct address_space	*mapping = page->mapping;
 
 	if (PageWriteback(page))
 		return 0;
 
-	if (page->mapping && PageDirty(page)) {
+	if (mapping && PageDirty(page)) {
 		if (page_has_buffers(page)) {
 			struct buffer_head	*bh, *head;
 
@@ -618,7 +619,7 @@ xfs_probe_page(
 					break;
 			} while ((bh = bh->b_this_page) != head);
 		} else
-			ret = mapped ? 0 : PAGE_CACHE_SIZE;
+			ret = mapped ? 0 : page_cache_size(mapping);
 	}
 
 	return ret;
@@ -645,7 +646,7 @@ xfs_probe_cluster(
 	} while ((bh = bh->b_this_page) != head);
 
 	/* if we reached the end of the page, sum forwards in following pages */
-	tlast = i_size_read(inode) >> PAGE_CACHE_SHIFT;
+	tlast = page_cache_index(inode->i_mapping, i_size_read(inode));
 	tindex = startpage->index + 1;
 
 	/* Prune this back to avoid pathological behavior */
@@ -663,14 +664,14 @@ xfs_probe_cluster(
 			size_t pg_offset, pg_len = 0;
 
 			if (tindex == tlast) {
-				pg_offset =
-				    i_size_read(inode) & (PAGE_CACHE_SIZE - 1);
+				pg_offset = page_cache_offset(inode->i_mapping,
+							i_size_read(inode));
 				if (!pg_offset) {
 					done = 1;
 					break;
 				}
 			} else
-				pg_offset = PAGE_CACHE_SIZE;
+				pg_offset = page_cache_size(inode->i_mapping);
 
 			if (page->index == tindex && !TestSetPageLocked(page)) {
 				pg_len = xfs_probe_page(page, pg_offset, mapped);
@@ -752,7 +753,8 @@ xfs_convert_page(
 	int			bbits = inode->i_blkbits;
 	int			len, page_dirty;
 	int			count = 0, done = 0, uptodate = 1;
- 	xfs_off_t		offset = page_offset(page);
+	struct address_space	*map = inode->i_mapping;
+	xfs_off_t		offset = page_cache_pos(map, page->index, 0);
 
 	if (page->index != tindex)
 		goto fail;
@@ -760,7 +762,7 @@ xfs_convert_page(
 		goto fail;
 	if (PageWriteback(page))
 		goto fail_unlock_page;
-	if (page->mapping != inode->i_mapping)
+	if (page->mapping != map)
 		goto fail_unlock_page;
 	if (!xfs_is_delayed_page(page, (*ioendp)->io_type))
 		goto fail_unlock_page;
@@ -772,20 +774,19 @@ xfs_convert_page(
 	 * Derivation:
 	 *
 	 * End offset is the highest offset that this page should represent.
-	 * If we are on the last page, (end_offset & (PAGE_CACHE_SIZE - 1))
-	 * will evaluate non-zero and be less than PAGE_CACHE_SIZE and
+	 * If we are on the last page, (end_offset & page_cache_mask())
+	 * will evaluate non-zero and be less than page_cache_size() and
 	 * hence give us the correct page_dirty count. On any other page,
 	 * it will be zero and in that case we need page_dirty to be the
 	 * count of buffers on the page.
 	 */
 	end_offset = min_t(unsigned long long,
-			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
+			(xfs_off_t)page_cache_pos(map, page->index + 1, 0),
 			i_size_read(inode));
 
 	len = 1 << inode->i_blkbits;
-	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
-					PAGE_CACHE_SIZE);
-	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
+	p_offset = page_cache_offset(map, end_offset);
+	p_offset = p_offset ? roundup(p_offset, len) : page_cache_size(map);
 	page_dirty = p_offset / len;
 
 	bh = head = page_buffers(page);
@@ -941,6 +942,7 @@ xfs_page_state_convert(
 	int			page_dirty, count = 0;
 	int			trylock = 0;
 	int			all_bh = unmapped;
+	struct address_space	*map = inode->i_mapping;
 
 	if (startio) {
 		if (wbc->sync_mode == WB_SYNC_NONE && wbc->nonblocking)
@@ -949,11 +951,11 @@ xfs_page_state_convert(
 
 	/* Is this page beyond the end of the file? */
 	offset = i_size_read(inode);
-	end_index = offset >> PAGE_CACHE_SHIFT;
-	last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
+	end_index = page_cache_index(map, offset);
+	last_index = page_cache_index(map, (offset - 1));
 	if (page->index >= end_index) {
 		if ((page->index >= end_index + 1) ||
-		    !(i_size_read(inode) & (PAGE_CACHE_SIZE - 1))) {
+		    !(page_cache_offset(map, i_size_read(inode)))) {
 			if (startio)
 				unlock_page(page);
 			return 0;
@@ -967,22 +969,22 @@ xfs_page_state_convert(
 	 * Derivation:
 	 *
 	 * End offset is the highest offset that this page should represent.
-	 * If we are on the last page, (end_offset & (PAGE_CACHE_SIZE - 1))
-	 * will evaluate non-zero and be less than PAGE_CACHE_SIZE and
-	 * hence give us the correct page_dirty count. On any other page,
+	 * If we are on the last page, (page_cache_offset(mapping, end_offset))
+	 * will evaluate non-zero and be less than page_cache_size(mapping)
+	 * and hence give us the correct page_dirty count. On any other page,
 	 * it will be zero and in that case we need page_dirty to be the
 	 * count of buffers on the page.
  	 */
 	end_offset = min_t(unsigned long long,
-			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT, offset);
+			(xfs_off_t)page_cache_pos(map, page->index + 1, 0), offset);
 	len = 1 << inode->i_blkbits;
-	p_offset = min_t(unsigned long, end_offset & (PAGE_CACHE_SIZE - 1),
-					PAGE_CACHE_SIZE);
-	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
+	p_offset = page_cache_offset(map, end_offset);
+	p_offset = p_offset ? roundup(p_offset, len) : page_cache_size(map);
+
 	page_dirty = p_offset / len;
 
 	bh = head = page_buffers(page);
-	offset = page_offset(page);
+	offset = page_cache_pos(map, page->index, 0);
 	flags = BMAPI_READ;
 	type = IOMAP_NEW;
 
@@ -1129,8 +1131,8 @@ xfs_page_state_convert(
 		xfs_start_page_writeback(page, wbc, 1, count);
 
 	if (ioend && iomap_valid) {
-		offset = (iomap.iomap_offset + iomap.iomap_bsize - 1) >>
-					PAGE_CACHE_SHIFT;
+		offset = page_cache_index(map,
+			(iomap.iomap_offset + iomap.iomap_bsize - 1));
 		tlast = min_t(pgoff_t, offset, last_index);
 		xfs_cluster_write(inode, page->index + 1, &iomap, &ioend,
 					wbc, startio, all_bh, tlast);
diff -puN fs/xfs/linux-2.6/xfs_lrw.c~use-page_cache_xxx-for-fs-xfs fs/xfs/linux-2.6/xfs_lrw.c
--- a/fs/xfs/linux-2.6/xfs_lrw.c~use-page_cache_xxx-for-fs-xfs
+++ a/fs/xfs/linux-2.6/xfs_lrw.c
@@ -141,8 +141,8 @@ xfs_iozero(
 		unsigned offset, bytes;
 		void *fsdata;
 
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		bytes = PAGE_CACHE_SIZE - offset;
+		offset = page_cache_offset(mapping, pos);
+		bytes = page_cache_size(mapping) - offset;
 		if (bytes > count)
 			bytes = count;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
use-page_cache_xxx-for-fs-xfs.patch
git-slub.patch
hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
ntfs-fix-nommu-build.patch
slub-fix-possible-null-pointer-dereference.patch
slub-fix-possible-null-pointer-dereference-fix.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
use-page_cache_xxx-functions-in-mm-filemapc.patch
use-page_cache_xxx-in-mm-page-writebackc.patch
use-page_cache_xxx-in-mm-truncatec.patch
use-page_cache_xxx-in-mm-rmapc.patch
use-page_cache_xxx-in-mm-filemap_xipc.patch
use-page_cache_xxx-in-mm-migratec.patch
use-page_cache_xxx-in-fs-libfsc.patch
use-page_cache_xxx-in-fs-sync.patch
use-page_cache_xxx-in-fs-bufferc.patch
use-page_cache_xxx-in-mm-mpagec.patch
use-page_cache_xxx-in-mm-fadvisec.patch
mm-move-cache_line_size-to-linux-cacheh.patch
use-page_cache_xxx-in-ext2.patch
use-page_cache_xxx-in-ext2-fix.patch
use-page_cache_xxx-in-ext2-fix-2.patch
use-page_cache_xxx-in-fs-ext3.patch
use-page_cache_xxx-in-fs-reiserfs.patch
use-page_cache_xxx-in-fs-ext4.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

