From: akpm@linux-foundation.org
Subject: + readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch added to -mm tree
Date: Fri, 10 Apr 2009 16:39:17 -0700
Message-ID: <200904102339.n3ANdIZJ021263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbZDJXnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 19:43:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: torvalds@linux-foundation.org, fengguang.wu@intel.com, lpk@581.spb.su, npiggin@suse.de, wli@movementarian.org


The patch titled
     readahead: clean up and simplify the code for filemap page fault readahead
has been added to the -mm tree.  Its filename is
     readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch

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
Subject: readahead: clean up and simplify the code for filemap page fault readahead
From: Linus Torvalds <torvalds@linux-foundation.org>

This shouldn't really change behavior all that much, but the single rather
complex function with read-ahead inside a loop etc is broken up into more
manageable pieces.

The behaviour is also less subtle, with the read-ahead being done up-front
rather than inside some subtle loop and thus avoiding the now unnecessary
extra state variables (ie "did_readaround" is gone).

Fengguang: the code split in fact fixed a bug reported by Pavel Levshin:
the PGMAJFAULT accounting used to be bypassed when MADV_RANDOM is set, in
which case the original code will directly jump to no_cached_page reading.

Cc: Pavel Levshin <lpk@581.spb.su>
Cc: <wli@movementarian.org>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |  156 +++++++++++++++++++++++++++----------------------
 1 file changed, 89 insertions(+), 67 deletions(-)

diff -puN mm/filemap.c~readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead mm/filemap.c
--- a/mm/filemap.c~readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead
+++ a/mm/filemap.c
@@ -1455,6 +1455,68 @@ static int page_cache_read(struct file *
 
 #define MMAP_LOTSAMISS  (100)
 
+/*
+ * Synchronous readahead happens when we don't even find
+ * a page in the page cache at all.
+ */
+static void do_sync_mmap_readahead(struct vm_area_struct *vma,
+				   struct file_ra_state *ra,
+				   struct file *file,
+				   pgoff_t offset)
+{
+	unsigned long ra_pages;
+	struct address_space *mapping = file->f_mapping;
+
+	/* If we don't want any read-ahead, don't bother */
+	if (VM_RandomReadHint(vma))
+		return;
+
+	if (VM_SequentialReadHint(vma)) {
+		page_cache_sync_readahead(mapping, ra, file, offset, 1);
+		return;
+	}
+
+	if (ra->mmap_miss < INT_MAX)
+		ra->mmap_miss++;
+
+	/*
+	 * Do we miss much more than hit in this file? If so,
+	 * stop bothering with read-ahead. It will only hurt.
+	 */
+	if (ra->mmap_miss > MMAP_LOTSAMISS)
+		return;
+
+	ra_pages = max_sane_readahead(ra->ra_pages);
+	if (ra_pages) {
+		pgoff_t start = 0;
+
+		if (offset > ra_pages / 2)
+			start = offset - ra_pages / 2;
+		do_page_cache_readahead(mapping, file, start, ra_pages);
+	}
+}
+
+/*
+ * Asynchronous readahead happens when we find the page and PG_readahead,
+ * so we want to possibly extend the readahead further..
+ */
+static void do_async_mmap_readahead(struct vm_area_struct *vma,
+				    struct file_ra_state *ra,
+				    struct file *file,
+				    struct page *page,
+				    pgoff_t offset)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	/* If we don't want any read-ahead, don't bother */
+	if (VM_RandomReadHint(vma))
+		return;
+	if (ra->mmap_miss > 0)
+		ra->mmap_miss--;
+	if (PageReadahead(page))
+		page_cache_async_readahead(mapping, ra, file, page, offset, 1);
+}
+
 /**
  * filemap_fault - read in file data for page fault handling
  * @vma:	vma in which the fault was taken
@@ -1474,78 +1536,44 @@ int filemap_fault(struct vm_area_struct 
 	struct address_space *mapping = file->f_mapping;
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
+	pgoff_t offset = vmf->pgoff;
 	struct page *page;
 	pgoff_t size;
-	int did_readaround = 0;
 	int ret = 0;
 
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (vmf->pgoff >= size)
+	if (offset >= size)
 		return VM_FAULT_SIGBUS;
 
-	/* If we don't want any read-ahead, don't bother */
-	if (VM_RandomReadHint(vma))
-		goto no_cached_page;
-
 	/*
 	 * Do we have something in the page cache already?
 	 */
-retry_find:
-	page = find_lock_page(mapping, vmf->pgoff);
-	/*
-	 * For sequential accesses, we use the generic readahead logic.
-	 */
-	if (VM_SequentialReadHint(vma)) {
-		if (!page) {
-			page_cache_sync_readahead(mapping, ra, file,
-							   vmf->pgoff, 1);
-			page = find_lock_page(mapping, vmf->pgoff);
-			if (!page)
-				goto no_cached_page;
-		}
-		if (PageReadahead(page)) {
-			page_cache_async_readahead(mapping, ra, file, page,
-							   vmf->pgoff, 1);
-		}
-	}
-
-	if (!page) {
-		unsigned long ra_pages;
-
-		ra->mmap_miss++;
-
+	page = find_get_page(mapping, offset);
+	if (likely(page)) {
 		/*
-		 * Do we miss much more than hit in this file? If so,
-		 * stop bothering with read-ahead. It will only hurt.
+		 * We found the page, so try async readahead before
+		 * waiting for the lock.
 		 */
-		if (ra->mmap_miss > MMAP_LOTSAMISS)
-			goto no_cached_page;
+		do_async_mmap_readahead(vma, ra, file, page, offset);
+		lock_page(page);
 
-		/*
-		 * To keep the pgmajfault counter straight, we need to
-		 * check did_readaround, as this is an inner loop.
-		 */
-		if (!did_readaround) {
-			ret = VM_FAULT_MAJOR;
-			count_vm_event(PGMAJFAULT);
-		}
-		did_readaround = 1;
-		ra_pages = max_sane_readahead(file->f_ra.ra_pages);
-		if (ra_pages) {
-			pgoff_t start = 0;
-
-			if (vmf->pgoff > ra_pages / 2)
-				start = vmf->pgoff - ra_pages / 2;
-			do_page_cache_readahead(mapping, file, start, ra_pages);
+		/* Did it get truncated? */
+		if (unlikely(page->mapping != mapping)) {
+			unlock_page(page);
+			put_page(page);
+			goto no_cached_page;
 		}
-		page = find_lock_page(mapping, vmf->pgoff);
+	} else {
+		/* No page in the page cache at all */
+		do_sync_mmap_readahead(vma, ra, file, offset);
+		count_vm_event(PGMAJFAULT);
+		ret = VM_FAULT_MAJOR;
+retry_find:
+		page = find_lock_page(mapping, offset);
 		if (!page)
 			goto no_cached_page;
 	}
 
-	if (!did_readaround)
-		ra->mmap_miss--;
-
 	/*
 	 * We have a locked page in the page cache, now we need to check
 	 * that it's up-to-date. If not, it is going to be due to an error.
@@ -1553,18 +1581,18 @@ retry_find:
 	if (unlikely(!PageUptodate(page)))
 		goto page_not_uptodate;
 
-	/* Must recheck i_size under page lock */
+	/*
+	 * Found the page and have a reference on it.
+	 * We must recheck i_size under page lock.
+	 */
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (unlikely(vmf->pgoff >= size)) {
+	if (unlikely(offset >= size)) {
 		unlock_page(page);
 		page_cache_release(page);
 		return VM_FAULT_SIGBUS;
 	}
 
-	/*
-	 * Found the page and have a reference on it.
-	 */
-	ra->prev_pos = (loff_t)page->index << PAGE_CACHE_SHIFT;
+	ra->prev_pos = (loff_t)offset << PAGE_CACHE_SHIFT;
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
 
@@ -1573,7 +1601,7 @@ no_cached_page:
 	 * We're only likely to ever get here if MADV_RANDOM is in
 	 * effect.
 	 */
-	error = page_cache_read(file, vmf->pgoff);
+	error = page_cache_read(file, offset);
 
 	/*
 	 * The page we want has now been added to the page cache.
@@ -1593,12 +1621,6 @@ no_cached_page:
 	return VM_FAULT_SIGBUS;
 
 page_not_uptodate:
-	/* IO error path */
-	if (!did_readaround) {
-		ret = VM_FAULT_MAJOR;
-		count_vm_event(PGMAJFAULT);
-	}
