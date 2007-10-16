From: akpm@linux-foundation.org
Subject: - fs-fix-nobh-error-handling.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:40 -0700
Message-ID: <200710162031.l9GKVeBR014521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965833AbXJPVkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: fix nobh error handling
has been removed from the -mm tree.  Its filename was
     fs-fix-nobh-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: fix nobh error handling
From: Nick Piggin <npiggin@suse.de>

nobh mode error handling is not just pretty slack, it's wrong.

One cannot zero out the whole page to ensure new blocks are zeroed, because
it just brings the whole page "uptodate" with zeroes even if that may not
be the correct uptodate data.  Also, other parts of the page may already
contain dirty data which would get lost by zeroing it out.  Thirdly, the
writeback of zeroes to the new blocks will also erase existing blocks.  All
these conditions are pagecache and/or filesystem corruption.

The problem comes about because we didn't keep track of which buffers
actually are new or old.  However it is not enough just to keep only this
state, because at the point we start dirtying parts of the page (new
blocks, with zeroes), the handling of IO errors becomes impossible without
buffers because the page may only be partially uptodate, in which case the
page flags allone cannot capture the state of the parts of the page.

So allocate all buffers for the page upfront, but leave them unattached so
that they don't pick up any other references and can be freed when we're
done.  If the error path is hit, then zero the new buffers as the regular
buffer path does, then attach the buffers to the page so that it can
actually be written out correctly and be subject to the normal IO error
handling paths.

As an upshot, we save 1K of kernel stack on ia64 or powerpc 64K page
systems.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |  138 +++++++++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 56 deletions(-)

diff -puN fs/buffer.c~fs-fix-nobh-error-handling fs/buffer.c
--- a/fs/buffer.c~fs-fix-nobh-error-handling
+++ a/fs/buffer.c
@@ -2274,51 +2274,64 @@ int nobh_prepare_write(struct page *page
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocksize = 1 << blkbits;
-	struct buffer_head map_bh;
-	struct buffer_head *read_bh[MAX_BUF_PER_PAGE];
+	struct buffer_head *head, *bh;
 	unsigned block_in_page;
-	unsigned block_start;
+	unsigned block_start, block_end;
 	sector_t block_in_file;
 	char *kaddr;
 	int nr_reads = 0;
-	int i;
 	int ret = 0;
 	int is_mapped_to_disk = 1;
 
+	if (page_has_buffers(page))
+		return block_prepare_write(page, from, to, get_block);
+
 	if (PageMappedToDisk(page))
 		return 0;
 
+	/*
+	 * Allocate buffers so that we can keep track of state, and potentially
+	 * attach them to the page if an error occurs. In the common case of
+	 * no error, they will just be freed again without ever being attached
+	 * to the page (which is all OK, because we're under the page lock).
+	 *
+	 * Be careful: the buffer linked list is a NULL terminated one, rather
+	 * than the circular one we're used to.
+	 */
+	head = alloc_page_buffers(page, blocksize, 0);
+	if (!head)
+		return -ENOMEM;
+
 	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
-	map_bh.b_page = page;
 
 	/*
 	 * We loop across all blocks in the page, whether or not they are
 	 * part of the affected region.  This is so we can discover if the
 	 * page is fully mapped-to-disk.
 	 */
-	for (block_start = 0, block_in_page = 0;
+	for (block_start = 0, block_in_page = 0, bh = head;
 		  block_start < PAGE_CACHE_SIZE;
-		  block_in_page++, block_start += blocksize) {
-		unsigned block_end = block_start + blocksize;
+		  block_in_page++, block_start += blocksize, bh = bh->b_this_page) {
 		int create;
 
-		map_bh.b_state = 0;
+		block_end = block_start + blocksize;
+		bh->b_state = 0;
 		create = 1;
 		if (block_start >= to)
 			create = 0;
-		map_bh.b_size = blocksize;
 		ret = get_block(inode, block_in_file + block_in_page,
-					&map_bh, create);
+					bh, create);
 		if (ret)
 			goto failed;
-		if (!buffer_mapped(&map_bh))
+		if (!buffer_mapped(bh))
 			is_mapped_to_disk = 0;
-		if (buffer_new(&map_bh))
-			unmap_underlying_metadata(map_bh.b_bdev,
-							map_bh.b_blocknr);
-		if (PageUptodate(page))
+		if (buffer_new(bh))
+			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
+		if (PageUptodate(page)) {
+			set_buffer_uptodate(bh);
 			continue;
-		if (buffer_new(&map_bh) || !buffer_mapped(&map_bh)) {
+		}
+		if (buffer_new(bh) || !buffer_mapped(bh)) {
 			kaddr = kmap_atomic(page, KM_USER0);
 			if (block_start < from)
 				memset(kaddr+block_start, 0, from-block_start);
@@ -2328,49 +2341,26 @@ int nobh_prepare_write(struct page *page
 			kunmap_atomic(kaddr, KM_USER0);
 			continue;
 		}
-		if (buffer_uptodate(&map_bh))
+		if (buffer_uptodate(bh))
 			continue;	/* reiserfs does this */
 		if (block_start < from || block_end > to) {
-			struct buffer_head *bh = alloc_buffer_head(GFP_NOFS);
-
-			if (!bh) {
-				ret = -ENOMEM;
-				goto failed;
-			}
-			bh->b_state = map_bh.b_state;
-			atomic_set(&bh->b_count, 0);
-			bh->b_this_page = NULL;
-			bh->b_page = page;
-			bh->b_blocknr = map_bh.b_blocknr;
-			bh->b_size = blocksize;
-			bh->b_data = (char *)(long)block_start;
-			bh->b_bdev = map_bh.b_bdev;
-			bh->b_private = NULL;
-			read_bh[nr_reads++] = bh;
+			lock_buffer(bh);
+			bh->b_end_io = end_buffer_read_nobh;
+			submit_bh(READ, bh);
+			nr_reads++;
 		}
 	}
 
 	if (nr_reads) {
-		struct buffer_head *bh;
-
 		/*
 		 * The page is locked, so these buffers are protected from
 		 * any VM or truncate activity.  Hence we don't need to care
 		 * for the buffer_head refcounts.
 		 */
-		for (i = 0; i < nr_reads; i++) {
-			bh = read_bh[i];
-			lock_buffer(bh);
-			bh->b_end_io = end_buffer_read_nobh;
-			submit_bh(READ, bh);
-		}
-		for (i = 0; i < nr_reads; i++) {
-			bh = read_bh[i];
+		for (bh = head; bh; bh = bh->b_this_page) {
 			wait_on_buffer(bh);
 			if (!buffer_uptodate(bh))
 				ret = -EIO;
-			free_buffer_head(bh);
-			read_bh[i] = NULL;
 		}
 		if (ret)
 			goto failed;
@@ -2379,21 +2369,54 @@ int nobh_prepare_write(struct page *page
 	if (is_mapped_to_disk)
 		SetPageMappedToDisk(page);
 
+	do {
+		bh = head;
+		head = head->b_this_page;
+		free_buffer_head(bh);
+	} while (head);
+
 	return 0;
 
 failed:
-	for (i = 0; i < nr_reads; i++) {
-		if (read_bh[i])
-			free_buffer_head(read_bh[i]);
-	}
-
 	/*
-	 * Error recovery is pretty slack.  Clear the page and mark it dirty
-	 * so we'll later zero out any blocks which _were_ allocated.
+	 * Error recovery is a bit difficult. We need to zero out blocks that
+	 * were newly allocated, and dirty them to ensure they get written out.
+	 * Buffers need to be attached to the page at this point, otherwise
+	 * the handling of potential IO errors during writeout would be hard
+	 * (could try doing synchronous writeout, but what if that fails too?)
 	 */
-	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
-	SetPageUptodate(page);
-	set_page_dirty(page);
+	spin_lock(&page->mapping->private_lock);
+	bh = head;
+	block_start = 0;
+	do {
+		if (PageUptodate(page))
+			set_buffer_uptodate(bh);
+		if (PageDirty(page))
+			set_buffer_dirty(bh);
+
+		block_end = block_start+blocksize;
+		if (block_end <= from)
+			goto next;
+		if (block_start >= to)
+			goto next;
+
+		if (buffer_new(bh)) {
+			clear_buffer_new(bh);
+			if (!buffer_uptodate(bh)) {
+				zero_user_page(page, block_start, bh->b_size, KM_USER0);
+				set_buffer_uptodate(bh);
+			}
+			mark_buffer_dirty(bh);
+		}
+next:
+		block_start = block_end;
+		if (!bh->b_this_page)
+			bh->b_this_page = head;
+		bh = bh->b_this_page;
+	} while (bh != head);
+	attach_page_buffers(page, head);
+	spin_unlock(&page->mapping->private_lock);
+
 	return ret;
 }
 EXPORT_SYMBOL(nobh_prepare_write);
@@ -2408,6 +2431,9 @@ int nobh_commit_write(struct file *file,
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
 
+	if (page_has_buffers(page))
+		return generic_commit_write(file, page, from, to);
+
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	if (pos > inode->i_size) {
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
