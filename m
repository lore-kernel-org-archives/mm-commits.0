From: akpm@linux-foundation.org
Subject: - readahead-split-ondemand-readahead-interface-into-two-functions.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:29 -0700
Message-ID: <200707192001.l6JK1Tlp019540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336AbXGSUZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: split ondemand readahead interface into two functions
has been removed from the -mm tree.  Its filename was
     readahead-split-ondemand-readahead-interface-into-two-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: split ondemand readahead interface into two functions
From: Rusty Russell <rusty@rustcorp.com.au>

Split ondemand readahead interface into two functions.  I think this makes it
a little clearer for non-readahead experts (like Rusty).

Internally they both call ondemand_readahead(), but the page argument is
changed to an obvious boolean flag.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c      |    4 -
 fs/ext4/dir.c      |    4 -
 fs/splice.c        |    6 +-
 include/linux/mm.h |   20 ++++++---
 mm/filemap.c       |   10 ++--
 mm/readahead.c     |   95 ++++++++++++++++++++++++++-----------------
 6 files changed, 84 insertions(+), 55 deletions(-)

diff -puN fs/ext3/dir.c~readahead-split-ondemand-readahead-interface-into-two-functions fs/ext3/dir.c
--- a/fs/ext3/dir.c~readahead-split-ondemand-readahead-interface-into-two-functions
+++ a/fs/ext3/dir.c
@@ -139,10 +139,10 @@ static int ext3_readdir(struct file * fi
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
-				page_cache_readahead_ondemand(
+				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
-					NULL, index, 1);
+					index, 1);
 			filp->f_ra.prev_index = index;
 			bh = ext3_bread(NULL, inode, blk, 0, &err);
 		}
diff -puN fs/ext4/dir.c~readahead-split-ondemand-readahead-interface-into-two-functions fs/ext4/dir.c
--- a/fs/ext4/dir.c~readahead-split-ondemand-readahead-interface-into-two-functions
+++ a/fs/ext4/dir.c
@@ -138,10 +138,10 @@ static int ext4_readdir(struct file * fi
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
-				page_cache_readahead_ondemand(
+				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
-					NULL, index, 1);
+					index, 1);
 			filp->f_ra.prev_index = index;
 			bh = ext4_bread(NULL, inode, blk, 0, &err);
 		}
diff -puN fs/splice.c~readahead-split-ondemand-readahead-interface-into-two-functions fs/splice.c
--- a/fs/splice.c~readahead-split-ondemand-readahead-interface-into-two-functions
+++ a/fs/splice.c
@@ -295,8 +295,8 @@ __generic_file_splice_read(struct file *
 	 * readahead/allocate the rest and fill in the holes.
 	 */
 	if (spd.nr_pages < nr_pages)
-		page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-				NULL, index, req_pages - spd.nr_pages);
+		page_cache_sync_readahead(mapping, &in->f_ra, in,
+				index, req_pages - spd.nr_pages);
 
 	error = 0;
 	while (spd.nr_pages < nr_pages) {
@@ -352,7 +352,7 @@ __generic_file_splice_read(struct file *
 		page = pages[page_nr];
 
 		if (PageReadahead(page))
-			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+			page_cache_async_readahead(mapping, &in->f_ra, in,
 					page, index, req_pages - page_nr);
 
 		/*
diff -puN include/linux/mm.h~readahead-split-ondemand-readahead-interface-into-two-functions include/linux/mm.h
--- a/include/linux/mm.h~readahead-split-ondemand-readahead-interface-into-two-functions
+++ a/include/linux/mm.h
@@ -1138,12 +1138,20 @@ int do_page_cache_readahead(struct addre
 			pgoff_t offset, unsigned long nr_to_read);
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
-unsigned long page_cache_readahead_ondemand(struct address_space *mapping,
-			  struct file_ra_state *ra,
-			  struct file *filp,
-			  struct page *page,
-			  pgoff_t offset,
-			  unsigned long size);
+
+void page_cache_sync_readahead(struct address_space *mapping,
+			       struct file_ra_state *ra,
+			       struct file *filp,
+			       pgoff_t offset,
+			       unsigned long size);
+
+void page_cache_async_readahead(struct address_space *mapping,
+				struct file_ra_state *ra,
+				struct file *filp,
+				struct page *pg,
+				pgoff_t offset,
+				unsigned long size);
+
 unsigned long max_sane_readahead(unsigned long nr);
 
 /* Do stack extension */
diff -puN mm/filemap.c~readahead-split-ondemand-readahead-interface-into-two-functions mm/filemap.c
--- a/mm/filemap.c~readahead-split-ondemand-readahead-interface-into-two-functions
+++ a/mm/filemap.c
@@ -894,15 +894,15 @@ void do_generic_mapping_read(struct addr
 find_page:
 		page = find_get_page(mapping, index);
 		if (!page) {
-			page_cache_readahead_ondemand(mapping,
-					&ra, filp, page,
+			page_cache_sync_readahead(mapping,
+					&ra, filp,
 					index, last_index - index);
 			page = find_get_page(mapping, index);
 			if (unlikely(page == NULL))
 				goto no_cached_page;
 		}
 		if (PageReadahead(page)) {
-			page_cache_readahead_ondemand(mapping,
+			page_cache_async_readahead(mapping,
 					&ra, filp, page,
 					index, last_index - index);
 		}
@@ -1348,14 +1348,14 @@ retry_find:
 	 */
 	if (VM_SequentialReadHint(vma)) {
 		if (!page) {
-			page_cache_readahead_ondemand(mapping, ra, file, page,
+			page_cache_sync_readahead(mapping, ra, file,
 							   vmf->pgoff, 1);
 			page = find_lock_page(mapping, vmf->pgoff);
 			if (!page)
 				goto no_cached_page;
 		}
 		if (PageReadahead(page)) {
-			page_cache_readahead_ondemand(mapping, ra, file, page,
+			page_cache_async_readahead(mapping, ra, file, page,
 							   vmf->pgoff, 1);
 		}
 	}
diff -puN mm/readahead.c~readahead-split-ondemand-readahead-interface-into-two-functions mm/readahead.c
--- a/mm/readahead.c~readahead-split-ondemand-readahead-interface-into-two-functions
+++ a/mm/readahead.c
@@ -359,7 +359,7 @@ static unsigned long get_next_ra_size(st
 static unsigned long
 ondemand_readahead(struct address_space *mapping,
 		   struct file_ra_state *ra, struct file *filp,
-		   struct page *page, pgoff_t offset,
+		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
 	unsigned long max;	/* max readahead pages */
@@ -387,7 +387,7 @@ ondemand_readahead(struct address_space 
 	 * Standalone, small read.
 	 * Read as is, and do not pollute the readahead state.
 	 */
-	if (!page && !sequential) {
+	if (!hit_readahead_marker && !sequential) {
 		return __do_page_cache_readahead(mapping, filp,
 						offset, req_size, 0);
 	}
@@ -408,7 +408,7 @@ ondemand_readahead(struct address_space 
 	 * E.g. interleaved reads.
 	 * Not knowing its readahead pos/size, bet on the minimal possible one.
 	 */
-	if (page) {
+	if (hit_readahead_marker) {
 		ra_index++;
 		ra_size = min(4 * ra_size, max);
 	}
@@ -421,50 +421,71 @@ fill_ra:
 }
 
 /**
- * page_cache_readahead_ondemand - generic file readahead
+ * page_cache_sync_readahead - generic file readahead
  * @mapping: address_space which holds the pagecache and I/O vectors
  * @ra: file_ra_state which holds the readahead state
  * @filp: passed on to ->readpage() and ->readpages()
- * @page: the page at @offset, or NULL if non-present
- * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
+ * @offset: start offset into @mapping, in pagecache page-sized units
  * @req_size: hint: total size of the read which the caller is performing in
- *            PAGE_CACHE_SIZE units
+ *            pagecache pages
  *
- * page_cache_readahead_ondemand() is the entry point of readahead logic.
- * This function should be called when it is time to perform readahead:
- * 1) @page == NULL
- *    A cache miss happened, time for synchronous readahead.
- * 2) @page != NULL && PageReadahead(@page)
- *    A look-ahead hit occured, time for asynchronous readahead.
+ * page_cache_sync_readahead() should be called when a cache miss happened:
+ * it will submit the read.  The readahead logic may decide to piggyback more
+ * pages onto the read request if access patterns suggest it will improve
+ * performance.
  */
-unsigned long
-page_cache_readahead_ondemand(struct address_space *mapping,
-				struct file_ra_state *ra, struct file *filp,
-				struct page *page, pgoff_t offset,
-				unsigned long req_size)
+void page_cache_sync_readahead(struct address_space *mapping,
+			       struct file_ra_state *ra, struct file *filp,
+			       pgoff_t offset, unsigned long req_size)
 {
 	/* no read-ahead */
 	if (!ra->ra_pages)
-		return 0;
+		return;
 
-	if (page) {
-		/*
-		 * It can be PG_reclaim.
-		 */
-		if (PageWriteback(page))
-			return 0;
-
-		ClearPageReadahead(page);
-
-		/*
-		 * Defer asynchronous read-ahead on IO congestion.
-		 */
-		if (bdi_read_congested(mapping->backing_dev_info))
-			return 0;
-	}
+	/* do read-ahead */
+	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
+}
+EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
+
+/**
+ * page_cache_async_readahead - file readahead for marked pages
+ * @mapping: address_space which holds the pagecache and I/O vectors
+ * @ra: file_ra_state which holds the readahead state
+ * @filp: passed on to ->readpage() and ->readpages()
+ * @page: the page at @offset which has the PG_readahead flag set
+ * @offset: start offset into @mapping, in pagecache page-sized units
+ * @req_size: hint: total size of the read which the caller is performing in
+ *            pagecache pages
+ *
+ * page_cache_async_ondemand() should be called when a page is used which
+ * has the PG_readahead flag: this is a marker to suggest that the application
+ * has used up enough of the readahead window that we should start pulling in
+ * more pages. */
+void
+page_cache_async_readahead(struct address_space *mapping,
+			   struct file_ra_state *ra, struct file *filp,
+			   struct page *page, pgoff_t offset,
+			   unsigned long req_size)
+{
+	/* no read-ahead */
+	if (!ra->ra_pages)
+		return;
+
+	/*
+	 * Same bit is used for PG_readahead and PG_reclaim.
+	 */
+	if (PageWriteback(page))
+		return;
+
+	ClearPageReadahead(page);
+
+	/*
+	 * Defer asynchronous read-ahead on IO congestion.
+	 */
+	if (bdi_read_congested(mapping->backing_dev_info))
+		return;
 
 	/* do read-ahead */
-	return ondemand_readahead(mapping, ra, filp, page,
-					offset, req_size);
+	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
 }
-EXPORT_SYMBOL_GPL(page_cache_readahead_ondemand);
+EXPORT_SYMBOL_GPL(page_cache_async_readahead);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
git-kvm.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
