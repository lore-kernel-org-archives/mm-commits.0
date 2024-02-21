Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9363A1AF
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548696; cv=none; b=LuYC+Vukulm9PF0It0PdI//eijHa55Fe4NzislRUUpILSAg79pAtVU8iqWm+o4GmLkh9tVGnXxn1+RXt/LBIaxJZvpxMfCsaB+cIZ8F6+b5cPpgPXWM4vuWVk5+LZKIh2FPGkbe+ZC5IJ3k0RYcOOXpfAfuYI75I6mXLEY+7ipM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548696; c=relaxed/simple;
	bh=Jtw2vBSlgMcAY99D8OcOf5XN4CN6vP/Wa4m/P3SwNyk=;
	h=Date:To:From:Subject:Message-Id; b=SrA1/wht/aLLoORp9Lbo1JSzfPca7c9FjJrO7dgDHY1ujLs3SloeVmFYQbnyWEa5TP3sQmNFLa397sSXr5bajAbt2XoLsMhObC6pzsczbv+joFx287+EbDwrf90f8nTN9bdkNJRcAmKWGC7f2H/J+OzBSr70PAh0n2eGWnf2oSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CCaA+AFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CCaA+AFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE82C433F1;
	Wed, 21 Feb 2024 20:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548695;
	bh=Jtw2vBSlgMcAY99D8OcOf5XN4CN6vP/Wa4m/P3SwNyk=;
	h=Date:To:From:Subject:From;
	b=CCaA+AFro7upv08nocAu4GM0CTY5x93gZ6dMV1vLiKM7DpUC49C6/8xMpe5DnPiEG
	 WrFzoZD0DLKzlK5iK8Wesy3vMqNHZirIIWqGo6/Zc33pnFf8ux+hWqfwXDRJ4lz4Xd
	 TUnsF43iF5oDxvB0kqlb0vJJVCt/KrJNE/VrR5Xw=
Date: Wed, 21 Feb 2024 12:51:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-add-a-writeback-iterator.patch added to mm-unstable branch
Message-Id: <20240221205135.6CE82C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: add a writeback iterator
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-add-a-writeback-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-add-a-writeback-iterator.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: writeback: add a writeback iterator
Date: Thu, 15 Feb 2024 07:36:48 +0100

Refactor the code left in write_cache_pages into an iterator that the file
system can call to get the next folio for a writeback operation:

	struct folio *folio = NULL;

	while ((folio = writeback_iter(mapping, wbc, folio, &error))) {
		error = <do per-folio writeback>;
	}

The twist here is that the error value is passed by reference, so that the
iterator can restore it when breaking out of the loop.

Handling of the magic AOP_WRITEPAGE_ACTIVATE value stays outside the
iterator and needs is just kept in the write_cache_pages legacy wrapper. 
in preparation for eventually killing it off.

Heavily based on a for_each* based iterator from Matthew Wilcox.

Link: https://lkml.kernel.org/r/20240215063649.2164017-14-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    4 
 mm/page-writeback.c       |  192 +++++++++++++++++++++---------------
 2 files changed, 118 insertions(+), 78 deletions(-)

--- a/include/linux/writeback.h~writeback-add-a-writeback-iterator
+++ a/include/linux/writeback.h
@@ -82,6 +82,7 @@ struct writeback_control {
 	/* internal fields used by the ->writepages implementation: */
 	struct folio_batch fbatch;
 	pgoff_t index;
+	int saved_err;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct bdi_writeback *wb;	/* wb this writeback is issued under */
@@ -366,6 +367,9 @@ int balance_dirty_pages_ratelimited_flag
 
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
 
+struct folio *writeback_iter(struct address_space *mapping,
+		struct writeback_control *wbc, struct folio *folio, int *error);
+
 typedef int (*writepage_t)(struct folio *folio, struct writeback_control *wbc,
 				void *data);
 
--- a/mm/page-writeback.c~writeback-add-a-writeback-iterator
+++ a/mm/page-writeback.c
@@ -2325,18 +2325,18 @@ void __init page_writeback_init(void)
 }
 
 /**
- * tag_pages_for_writeback - tag pages to be written by write_cache_pages
+ * tag_pages_for_writeback - tag pages to be written by writeback
  * @mapping: address space structure to write
  * @start: starting page index
  * @end: ending page index (inclusive)
  *
  * This function scans the page range from @start to @end (inclusive) and tags
- * all pages that have DIRTY tag set with a special TOWRITE tag. The idea is
- * that write_cache_pages (or whoever calls this function) will then use
- * TOWRITE tag to identify pages eligible for writeback.  This mechanism is
- * used to avoid livelocking of writeback by a process steadily creating new
- * dirty pages in the file (thus it is important for this function to be quick
- * so that it can tag pages faster than a dirtying process can create them).
+ * all pages that have DIRTY tag set with a special TOWRITE tag.  The caller
+ * can then use the TOWRITE tag to identify pages eligible for writeback.
+ * This mechanism is used to avoid livelocking of writeback by a process
+ * steadily creating new dirty pages in the file (thus it is important for this
+ * function to be quick so that it can tag pages faster than a dirtying process
+ * can create them).
  */
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end)
@@ -2434,69 +2434,68 @@ retry:
 }
 
 /**
- * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
+ * writeback_iter - iterate folio of a mapping for writeback
  * @mapping: address space structure to write
- * @wbc: subtract the number of written pages from *@wbc->nr_to_write
- * @writepage: function called for each page
- * @data: data passed to writepage function
+ * @wbc: writeback context
+ * @folio: previously iterated folio (%NULL to start)
+ * @error: in-out pointer for writeback errors (see below)
  *
- * If a page is already under I/O, write_cache_pages() skips it, even
- * if it's dirty.  This is desirable behaviour for memory-cleaning writeback,
- * but it is INCORRECT for data-integrity system calls such as fsync().  fsync()
- * and msync() need to guarantee that all the data which was dirty at the time
- * the call was made get new I/O started against them.  If wbc->sync_mode is
- * WB_SYNC_ALL then we were called for data integrity and we must wait for
- * existing IO to complete.
- *
- * To avoid livelocks (when other process dirties new pages), we first tag
- * pages which should be written back with TOWRITE tag and only then start
- * writing them. For data-integrity sync we have to be careful so that we do
- * not miss some pages (e.g., because some other process has cleared TOWRITE
- * tag we set). The rule we follow is that TOWRITE tag can be cleared only
- * by the process clearing the DIRTY tag (and submitting the page for IO).
- *
- * To avoid deadlocks between range_cyclic writeback and callers that hold
- * pages in PageWriteback to aggregate IO until write_cache_pages() returns,
- * we do not loop back to the start of the file. Doing so causes a page
- * lock/page writeback access order inversion - we should only ever lock
- * multiple pages in ascending page->index order, and looping back to the start
- * of the file violates that rule and causes deadlocks.
+ * This function returns the next folio for the writeback operation described by
+ * @wbc on @mapping and  should be called in a while loop in the ->writepages
+ * implementation.
  *
- * Return: %0 on success, negative error code otherwise
+ * To start the writeback operation, %NULL is passed in the @folio argument, and
+ * for every subsequent iteration the folio returned previously should be passed
+ * back in.
+ *
+ * If there was an error in the per-folio writeback inside the writeback_iter()
+ * loop, @error should be set to the error value.
+ *
+ * Once the writeback described in @wbc has finished, this function will return
+ * %NULL and if there was an error in any iteration restore it to @error.
+ *
+ * Note: callers should not manually break out of the loop using break or goto
+ * but must keep calling writeback_iter() until it returns %NULL.
+ *
+ * Return: the folio to write or %NULL if the loop is done.
  */
-int write_cache_pages(struct address_space *mapping,
-		      struct writeback_control *wbc, writepage_t writepage,
-		      void *data)
+struct folio *writeback_iter(struct address_space *mapping,
+		struct writeback_control *wbc, struct folio *folio, int *error)
 {
-	int ret = 0;
-	int error;
-	struct folio *folio;
-	pgoff_t end;		/* Inclusive */
-
-	if (wbc->range_cyclic) {
-		wbc->index = mapping->writeback_index; /* prev offset */
-		end = -1;
-	} else {
-		wbc->index = wbc->range_start >> PAGE_SHIFT;
-		end = wbc->range_end >> PAGE_SHIFT;
-	}
-	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
-		tag_pages_for_writeback(mapping, wbc->index, end);
-
-	folio_batch_init(&wbc->fbatch);
+	if (!folio) {
+		folio_batch_init(&wbc->fbatch);
+		wbc->saved_err = *error = 0;
 
-	for (;;) {
-		folio = writeback_get_folio(mapping, wbc);
-		if (!folio)
-			break;
+		/*
+		 * For range cyclic writeback we remember where we stopped so
+		 * that we can continue where we stopped.
+		 *
+		 * For non-cyclic writeback we always start at the beginning of
+		 * the passed in range.
+		 */
+		if (wbc->range_cyclic)
+			wbc->index = mapping->writeback_index;
+		else
+			wbc->index = wbc->range_start >> PAGE_SHIFT;
 
-		error = writepage(folio, wbc, data);
+		/*
+		 * To avoid livelocks when other processes dirty new pages, we
+		 * first tag pages which should be written back and only then
+		 * start writing them.
+		 *
+		 * For data-integrity writeback we have to be careful so that we
+		 * do not miss some pages (e.g., because some other process has
+		 * cleared the TOWRITE tag we set).  The rule we follow is that
+		 * TOWRITE tag can be cleared only by the process clearing the
+		 * DIRTY tag (and submitting the page for I/O).
+		 */
+		if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
+			tag_pages_for_writeback(mapping, wbc->index,
+					wbc_end(wbc));
+	} else {
 		wbc->nr_to_write -= folio_nr_pages(folio);
 
-		if (error == AOP_WRITEPAGE_ACTIVATE) {
-			folio_unlock(folio);
-			error = 0;
-		}
+		WARN_ON_ONCE(*error > 0);
 
 		/*
 		 * For integrity writeback we have to keep going until we have
@@ -2510,33 +2509,70 @@ int write_cache_pages(struct address_spa
 		 * wbc->nr_to_write or encounter the first error.
 		 */
 		if (wbc->sync_mode == WB_SYNC_ALL) {
-			if (error && !ret)
-				ret = error;
+			if (*error && !wbc->saved_err)
+				wbc->saved_err = *error;
 		} else {
-			if (error || wbc->nr_to_write <= 0)
+			if (*error || wbc->nr_to_write <= 0)
 				goto done;
 		}
 	}
 
-	/*
-	 * For range cyclic writeback we need to remember where we stopped so
-	 * that we can continue there next time we are called.  If  we hit the
-	 * last page and there is more work to be done, wrap back to the start
-	 * of the file.
-	 *
-	 * For non-cyclic writeback we always start looking up at the beginning
-	 * of the file if we are called again, which can only happen due to
-	 * -ENOMEM from the file system.
-	 */
-	folio_batch_release(&wbc->fbatch);
-	if (wbc->range_cyclic)
-		mapping->writeback_index = 0;
-	return ret;
+	folio = writeback_get_folio(mapping, wbc);
+	if (!folio) {
+		/*
+		 * To avoid deadlocks between range_cyclic writeback and callers
+		 * that hold pages in PageWriteback to aggregate I/O until
+		 * the writeback iteration finishes, we do not loop back to the
+		 * start of the file.  Doing so causes a page lock/page
+		 * writeback access order inversion - we should only ever lock
+		 * multiple pages in ascending page->index order, and looping
+		 * back to the start of the file violates that rule and causes
+		 * deadlocks.
+		 */
+		if (wbc->range_cyclic)
+			mapping->writeback_index = 0;
+
+		/*
+		 * Return the first error we encountered (if there was any) to
+		 * the caller.
+		 */
+		*error = wbc->saved_err;
+	}
+	return folio;
 
 done:
 	if (wbc->range_cyclic)
 		mapping->writeback_index = folio->index + folio_nr_pages(folio);
 	folio_batch_release(&wbc->fbatch);
+	return NULL;
+}
+
+/**
+ * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
+ * @mapping: address space structure to write
+ * @wbc: subtract the number of written pages from *@wbc->nr_to_write
+ * @writepage: function called for each page
+ * @data: data passed to writepage function
+ *
+ * Return: %0 on success, negative error code otherwise
+ *
+ * Note: please use writeback_iter() instead.
+ */
+int write_cache_pages(struct address_space *mapping,
+		      struct writeback_control *wbc, writepage_t writepage,
+		      void *data)
+{
+	struct folio *folio = NULL;
+	int error;
+
+	while ((folio = writeback_iter(mapping, wbc, folio, &error))) {
+		error = writepage(folio, wbc, data);
+		if (error == AOP_WRITEPAGE_ACTIVATE) {
+			folio_unlock(folio);
+			error = 0;
+		}
+	}
+
 	return error;
 }
 EXPORT_SYMBOL(write_cache_pages);
_

Patches currently in -mm which might be from hch@lst.de are

writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch
writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch
writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch
writeback-only-update-writeback_index-for-range_cyclic-writeback.patch
writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch
writeback-add-a-writeback-iterator.patch

