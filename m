From: akpm@linux-foundation.org
Subject: - fix-read-truncate-race.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:00:30 -0700
Message-ID: <200707172300.l6HN0UVi011304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936019AbXGQXBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, jens.axboe@oracle.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     Fix read/truncate race
has been removed from the -mm tree.  Its filename was
     fix-read-truncate-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix read/truncate race
From: NeilBrown <neilb@suse.de>

do_generic_mapping_read currently samples the i_size at the start and doesn't
do so again unless it needs to call ->readpage to load a page.  After
->readpage it has to re-sample i_size as a truncate may have caused that page
to be filled with zeros, and the read() call should not see these.

However there are other activities that might cause ->readpage to be called on
a page between the time that do_generic_mapping_read samples i_size and when
it finds that it has an uptodate page.  These include at least read-ahead and
possibly another thread performing a read.

So do_generic_mapping_read must sample i_size *after* it has an uptodate page.
 Thus the current sampling at the start and after a read can be replaced with
a sampling before the copy-out.

The same change applied to __generic_file_splice_read.

Note that this fixes any race with truncate_complete_page, but does not fix a
possible race with truncate_partial_page.  If a partial truncate happens after
do_generic_mapping_read samples i_size and before the copy_out, the nuls that
truncate_partial_page place in the page could be copied out incorrectly.

I think the best fix for that is to *not* zero out parts of the page in
truncate_partial_page, but rather to zero out the tail of a page when
increasing i_size.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   72 +++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 44 deletions(-)

diff -puN mm/filemap.c~fix-read-truncate-race mm/filemap.c
--- a/mm/filemap.c~fix-read-truncate-race
+++ a/mm/filemap.c
@@ -867,13 +867,11 @@ void do_generic_mapping_read(struct addr
 {
 	struct inode *inode = mapping->host;
 	unsigned long index;
-	unsigned long end_index;
 	unsigned long offset;
 	unsigned long last_index;
 	unsigned long next_index;
 	unsigned long prev_index;
 	unsigned int prev_offset;
-	loff_t isize;
 	struct page *cached_page;
 	int error;
 	struct file_ra_state ra = *_ra;
@@ -886,27 +884,12 @@ void do_generic_mapping_read(struct addr
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
-	isize = i_size_read(inode);
-	if (!isize)
-		goto out;
-
-	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
 	for (;;) {
 		struct page *page;
+		unsigned long end_index;
+		loff_t isize;
 		unsigned long nr, ret;
 
-		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
-		if (index >= end_index) {
-			if (index > end_index)
-				goto out;
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
-			if (nr <= offset) {
-				goto out;
-			}
-		}
-		nr = nr - offset;
-
 		cond_resched();
 		if (index == next_index)
 			next_index = page_cache_readahead(mapping, &ra, filp,
@@ -921,6 +904,32 @@ find_page:
 		if (!PageUptodate(page))
 			goto page_not_up_to_date;
 page_ok:
+		/*
+		 * i_size must be checked after we know the page is Uptodate.
+		 *
+		 * Checking i_size after the check allows us to calculate
+		 * the correct value for "nr", which means the zero-filled
+		 * part of the page is not copied back to userspace (unless
+		 * another truncate extends the file - this is desired though).
+		 */
+
+		isize = i_size_read(inode);
+		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		if (unlikely(!isize || index > end_index)) {
+			page_cache_release(page);
+			goto out;
+		}
+
+		/* nr is the maximum number of bytes to copy from this page */
+		nr = PAGE_CACHE_SIZE;
+		if (index == end_index) {
+			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			if (nr <= offset) {
+				page_cache_release(page);
+				goto out;
+			}
+		}
+		nr = nr - offset;
 
 		/* If users can be writing to this page using arbitrary
 		 * virtual addresses, take care about potential aliasing
@@ -1007,31 +1016,6 @@ readpage:
 			unlock_page(page);
 		}
 
-		/*
-		 * i_size must be checked after we have done ->readpage.
-		 *
-		 * Checking i_size after the readpage allows us to calculate
-		 * the correct value for "nr", which means the zero-filled
-		 * part of the page is not copied back to userspace (unless
-		 * another truncate extends the file - this is desired though).
-		 */
-		isize = i_size_read(inode);
-		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
-		if (unlikely(!isize || index > end_index)) {
-			page_cache_release(page);
-			goto out;
-		}
-
-		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
-		if (index == end_index) {
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
-			if (nr <= offset) {
-				page_cache_release(page);
-				goto out;
-			}
-		}
-		nr = nr - offset;
 		goto page_ok;
 
 readpage_error:
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
raid5-add-the-stripe_queue-object-for-tracking-raid.patch
raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2.patch
raid5-use-stripe_queues-to-prioritize-the-most.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
