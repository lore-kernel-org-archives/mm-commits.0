From: akpm@linux-foundation.org
Subject: + fix-read-truncate-race.patch added to -mm tree
Date: Thu, 07 Jun 2007 18:19:20 -0700
Message-ID: <200706080119.l581JLRp014688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965545AbXFHBUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 21:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, jens.axboe@oracle.com, npiggin@suse.de


The patch titled
     Fix read/truncate race
has been added to the -mm tree.  Its filename is
     fix-read-truncate-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 fs/splice.c  |   43 ++++++++++++++---------------
 mm/filemap.c |   72 +++++++++++++++++++------------------------------
 2 files changed, 50 insertions(+), 65 deletions(-)

diff -puN fs/splice.c~fix-read-truncate-race fs/splice.c
--- a/fs/splice.c~fix-read-truncate-race
+++ a/fs/splice.c
@@ -417,31 +417,32 @@ __generic_file_splice_read(struct file *
 				break;
 			}
 
-			/*
-			 * i_size must be checked after ->readpage().
-			 */
-			isize = i_size_read(mapping->host);
-			end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
-			if (unlikely(!isize || index > end_index))
-				break;
+		}
+	fill_it:
+		/*
+		 * i_size must be checked after PageUptodate.
+		 */
+		isize = i_size_read(mapping->host);
+		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		if (unlikely(!isize || index > end_index))
+			break;
 
+		/*
+		 * if this is the last page, see if we need to shrink
+		 * the length and stop
+		 */
+		if (end_index == index) {
+			loff = PAGE_CACHE_SIZE - (isize & ~PAGE_CACHE_MASK);
+			if (total_len + loff > isize)
+				break;
 			/*
-			 * if this is the last page, see if we need to shrink
-			 * the length and stop
+			 * force quit after adding this page
 			 */
-			if (end_index == index) {
-				loff = PAGE_CACHE_SIZE - (isize & ~PAGE_CACHE_MASK);
-				if (total_len + loff > isize)
-					break;
-				/*
-				 * force quit after adding this page
-				 */
-				len = this_len;
-				this_len = min(this_len, loff);
-				loff = 0;
-			}
+			len = this_len;
+			this_len = min(this_len, loff);
+			loff = 0;
 		}
-fill_it:
+
 		partial[page_nr].offset = loff;
 		partial[page_nr].len = this_len;
 		len -= this_len;
diff -puN mm/filemap.c~fix-read-truncate-race mm/filemap.c
--- a/mm/filemap.c~fix-read-truncate-race
+++ a/mm/filemap.c
@@ -862,13 +862,11 @@ void do_generic_mapping_read(struct addr
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
 	int error;
 	struct file_ra_state ra = *_ra;
 
@@ -879,27 +877,12 @@ void do_generic_mapping_read(struct addr
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
@@ -914,6 +897,32 @@ find_page:
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
@@ -1000,31 +1009,6 @@ readpage:
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

git-md-accel.patch
block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
fix-read-truncate-race.patch
make-sure-readv-stops-reading-when-it-hits-end-of-file.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
nfsd-warning-fix.patch
use-menuconfig-objects-ii-md.patch
md-improve-message-about-invalid-superblock-during-autodetect.patch
md-improve-the-is_mddev_idle-test-fix.patch
md-check-that-internal-bitmap-does-not-overlap-other-data.patch
md-change-bitmap_unplug-and-others-to-void-functions.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
