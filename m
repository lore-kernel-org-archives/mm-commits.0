Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61121078B
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739464; cv=none; b=S5iqKhNRAPuBs8zyVNe6zOBryCU0iVyRzhbB0yX2jr/Kmlz/+/TC5kJvxzldC0/2ZRyHdM/NSeg7sw0Kuw8im/44MCrjnhTGJHxYYpZWFZfMxgFHx1NeOg2djVLhYwCUkwh0XAbGgwQJfZj8xoNNs7C19HdfW7sCeqRg+TLV+tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739464; c=relaxed/simple;
	bh=DRxbgjuf8RtAgW3Fg9Hc0AhRi11WX8nvve0T4/WVRrU=;
	h=Date:To:From:Subject:Message-Id; b=nMyrvKYhLR28aZByV0J4t1PqB8tTBZ0XbWmzB6pHkHwR8G8P4aIcqGsbUZXlA5aX1MTV60VVpNZzPvu5m69j1RRq+U+p4ilVsY1PRPlo8Bz8aqITHYGiap2WggJyCmrkn4TOmFSVx5yAjFrOw3bTCPmjr4/lLruMsClNYdUCGjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I+YU0d0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I+YU0d0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0EDC433F1;
	Sat, 24 Feb 2024 01:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739464;
	bh=DRxbgjuf8RtAgW3Fg9Hc0AhRi11WX8nvve0T4/WVRrU=;
	h=Date:To:From:Subject:From;
	b=I+YU0d0JkWqrO/YGgdKQpiL1KtnqWqMFItaVnQM6vmwSQPwsBf3jJqBjI/zoaHFaQ
	 IZxJOELEYZ7ZMXfWOHq3aMgQHcrQRpuo08U8oApi+g/Lax+PUkL1ySDSnENRQelD5h
	 1T/qwdHfneoeQ//SXTCOrD2qTn7ukxVE8hvb1hWM=
Date: Fri, 23 Feb 2024 17:51:04 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch removed from -mm tree
Message-Id: <20240224015104.AA0EDC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: factor writeback_get_batch() out of write_cache_pages()
has been removed from the -mm tree.  Its filename was
     writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: factor writeback_get_batch() out of write_cache_pages()
Date: Thu, 15 Feb 2024 07:36:43 +0100

This simple helper will be the basis of the writeback iterator.  To make
this work, we need to remember the current index and end positions in
writeback_control.

[hch@lst.de: heavily rebased, add helpers to get the tag and end index, don't keep the end index in struct writeback_control]
Link: https://lkml.kernel.org/r/20240215063649.2164017-9-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    6 +++
 mm/page-writeback.c       |   60 ++++++++++++++++++++++--------------
 2 files changed, 44 insertions(+), 22 deletions(-)

--- a/include/linux/writeback.h~writeback-factor-writeback_get_batch-out-of-write_cache_pages
+++ a/include/linux/writeback.h
@@ -11,6 +11,7 @@
 #include <linux/flex_proportions.h>
 #include <linux/backing-dev-defs.h>
 #include <linux/blk_types.h>
+#include <linux/pagevec.h>
 
 struct bio;
 
@@ -40,6 +41,7 @@ enum writeback_sync_modes {
  * in a manner such that unspecified fields are set to zero.
  */
 struct writeback_control {
+	/* public fields that can be set and/or consumed by the caller: */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
@@ -77,6 +79,10 @@ struct writeback_control {
 	 */
 	struct swap_iocb **swap_plug;
 
+	/* internal fields used by the ->writepages implementation: */
+	struct folio_batch fbatch;
+	pgoff_t index;
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct bdi_writeback *wb;	/* wb this writeback is issued under */
 	struct inode *inode;		/* inode being written out */
--- a/mm/page-writeback.c~writeback-factor-writeback_get_batch-out-of-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2392,6 +2392,29 @@ static bool folio_prepare_writeback(stru
 	return true;
 }
 
+static xa_mark_t wbc_to_tag(struct writeback_control *wbc)
+{
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
+		return PAGECACHE_TAG_TOWRITE;
+	return PAGECACHE_TAG_DIRTY;
+}
+
+static pgoff_t wbc_end(struct writeback_control *wbc)
+{
+	if (wbc->range_cyclic)
+		return -1;
+	return wbc->range_end >> PAGE_SHIFT;
+}
+
+static void writeback_get_batch(struct address_space *mapping,
+		struct writeback_control *wbc)
+{
+	folio_batch_release(&wbc->fbatch);
+	cond_resched();
+	filemap_get_folios_tag(mapping, &wbc->index, wbc_end(wbc),
+			wbc_to_tag(wbc), &wbc->fbatch);
+}
+
 /**
  * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
  * @mapping: address space structure to write
@@ -2429,38 +2452,32 @@ int write_cache_pages(struct address_spa
 {
 	int ret = 0;
 	int error;
-	struct folio_batch fbatch;
 	struct folio *folio;
-	int nr_folios;
-	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
-	xa_mark_t tag;
 
-	folio_batch_init(&fbatch);
 	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* prev offset */
+		wbc->index = mapping->writeback_index; /* prev offset */
 		end = -1;
 	} else {
-		index = wbc->range_start >> PAGE_SHIFT;
+		wbc->index = wbc->range_start >> PAGE_SHIFT;
 		end = wbc->range_end >> PAGE_SHIFT;
 	}
-	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages) {
-		tag_pages_for_writeback(mapping, index, end);
-		tag = PAGECACHE_TAG_TOWRITE;
-	} else {
-		tag = PAGECACHE_TAG_DIRTY;
-	}
-	while (index <= end) {
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
+		tag_pages_for_writeback(mapping, wbc->index, end);
+
+	folio_batch_init(&wbc->fbatch);
+
+	while (wbc->index <= end) {
 		int i;
 
-		nr_folios = filemap_get_folios_tag(mapping, &index, end,
-				tag, &fbatch);
+		writeback_get_batch(mapping, wbc);
 
-		if (nr_folios == 0)
+		if (wbc->fbatch.nr == 0)
 			break;
 
-		for (i = 0; i < nr_folios; i++) {
-			folio = fbatch.folios[i];
+		for (i = 0; i < wbc->fbatch.nr; i++) {
+			folio = wbc->fbatch.folios[i];
+
 			folio_lock(folio);
 			if (!folio_prepare_writeback(mapping, wbc, folio)) {
 				folio_unlock(folio);
@@ -2498,8 +2515,6 @@ int write_cache_pages(struct address_spa
 					goto done;
 			}
 		}
-		folio_batch_release(&fbatch);
-		cond_resched();
 	}
 
 	/*
@@ -2512,6 +2527,7 @@ int write_cache_pages(struct address_spa
 	 * of the file if we are called again, which can only happen due to
 	 * -ENOMEM from the file system.
 	 */
+	folio_batch_release(&wbc->fbatch);
 	if (wbc->range_cyclic)
 		mapping->writeback_index = 0;
 	return ret;
@@ -2519,7 +2535,7 @@ int write_cache_pages(struct address_spa
 done:
 	if (wbc->range_cyclic)
 		mapping->writeback_index = folio->index + folio_nr_pages(folio);
-	folio_batch_release(&fbatch);
+	folio_batch_release(&wbc->fbatch);
 	return error;
 }
 EXPORT_SYMBOL(write_cache_pages);
_

Patches currently in -mm which might be from willy@infradead.org are


