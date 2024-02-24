Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2F9BA5E
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739462; cv=none; b=CLOhvySraVxG5kFGTVMk0mg/fKRmU4QJ7Q+6StAzfa1S8RvwgPMM4K+A1azbhc5jADnkCvYblJq9sLlFhBprbzjgyQr7hqVL9UVwcGiumMur49YpssbVFBuPHyWnH0lo5T+B2RxC5Xz133SqxFma45bVkAhXHqPcH8eer+4+yck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739462; c=relaxed/simple;
	bh=qF24BhlE0IWQpnxnGtuPXTg1lNsGCmgZwJt++3Rv5pw=;
	h=Date:To:From:Subject:Message-Id; b=ga11oBXvoWBbtMEdJ9TSb9xYlyGmeJNjy7QXfyuHBfqX6JzgO7tU4ffnwZdZVb/HKNUPqyP9QZhcPEU3j8Y3gxmX+zfZ13m2i0aYfl2Di7GO24CBoRx+qm1IfuDCyxNL3pRBDpj6S4VfC4ADLobdwwf4Q9uYmwROaruIpq+PrZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2YbMKJy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2YbMKJy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BF8C433F1;
	Sat, 24 Feb 2024 01:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739461;
	bh=qF24BhlE0IWQpnxnGtuPXTg1lNsGCmgZwJt++3Rv5pw=;
	h=Date:To:From:Subject:From;
	b=2YbMKJy2iljSI2GpLta/s10pm/2E//vx0zrBaWaL1/uGABDZhGpSteX2+IGkkVhSI
	 mxJ1w3kfhOV4fQQTxUoJ21bxiHgXmv7jyyGDoOpZW9+7DfwHbnnHkMCIgfly8Cj5AU
	 gzAEl7ivxJAGQwSXp5sI9RKkUvT/FjTdj/TDU7Y4=
Date: Fri, 23 Feb 2024 17:51:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch removed from -mm tree
Message-Id: <20240224015101.C2BF8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: rework the loop termination condition in write_cache_pages
has been removed from the -mm tree.  Its filename was
     writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: writeback: rework the loop termination condition in write_cache_pages
Date: Thu, 15 Feb 2024 07:36:41 +0100

Rework the way we deal with the cleanup after the writepage call.

First handle the magic AOP_WRITEPAGE_ACTIVATE separately from real error
returns to get it out of the way of the actual error handling path.

The split the handling on intgrity vs non-integrity branches first, and
return early using a goto for the non-ingegrity early loop condition to
remove the need for the done and done_index local variables, and for
assigning the error to ret when we can just return error directly.

Link: https://lkml.kernel.org/r/20240215063649.2164017-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   84 ++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 51 deletions(-)

--- a/mm/page-writeback.c~writeback-rework-the-loop-termination-condition-in-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2396,13 +2396,12 @@ int write_cache_pages(struct address_spa
 		      void *data)
 {
 	int ret = 0;
-	int done = 0;
 	int error;
 	struct folio_batch fbatch;
+	struct folio *folio;
 	int nr_folios;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
-	pgoff_t done_index;
 	xa_mark_t tag;
 
 	folio_batch_init(&fbatch);
@@ -2419,8 +2418,7 @@ int write_cache_pages(struct address_spa
 	} else {
 		tag = PAGECACHE_TAG_DIRTY;
 	}
-	done_index = index;
-	while (!done && (index <= end)) {
+	while (index <= end) {
 		int i;
 
 		nr_folios = filemap_get_folios_tag(mapping, &index, end,
@@ -2430,11 +2428,7 @@ int write_cache_pages(struct address_spa
 			break;
 
 		for (i = 0; i < nr_folios; i++) {
-			struct folio *folio = fbatch.folios[i];
-			unsigned long nr;
-
-			done_index = folio->index;
-
+			folio = fbatch.folios[i];
 			folio_lock(folio);
 
 			/*
@@ -2469,45 +2463,32 @@ continue_unlock:
 
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
 			error = writepage(folio, wbc, data);
-			nr = folio_nr_pages(folio);
-			wbc->nr_to_write -= nr;
-			if (unlikely(error)) {
-				/*
-				 * Handle errors according to the type of
-				 * writeback. There's no need to continue for
-				 * background writeback. Just push done_index
-				 * past this page so media errors won't choke
-				 * writeout for the entire file. For integrity
-				 * writeback, we must process the entire dirty
-				 * set regardless of errors because the fs may
-				 * still have state to clear for each page. In
-				 * that case we continue processing and return
-				 * the first error.
-				 */
-				if (error == AOP_WRITEPAGE_ACTIVATE) {
-					folio_unlock(folio);
-					error = 0;
-				} else if (wbc->sync_mode != WB_SYNC_ALL) {
-					ret = error;
-					done_index = folio->index + nr;
-					done = 1;
-					break;
-				}
-				if (!ret)
-					ret = error;
+			wbc->nr_to_write -= folio_nr_pages(folio);
+
+			if (error == AOP_WRITEPAGE_ACTIVATE) {
+				folio_unlock(folio);
+				error = 0;
 			}
 
 			/*
-			 * We stop writing back only if we are not doing
-			 * integrity sync. In case of integrity sync we have to
-			 * keep going until we have written all the pages
-			 * we tagged for writeback prior to entering this loop.
+			 * For integrity writeback we have to keep going until
+			 * we have written all the folios we tagged for
+			 * writeback above, even if we run past wbc->nr_to_write
+			 * or encounter errors.
+			 * We stash away the first error we encounter in
+			 * wbc->saved_err so that it can be retrieved when we're
+			 * done.  This is because the file system may still have
+			 * state to clear for each folio.
+			 *
+			 * For background writeback we exit as soon as we run
+			 * past wbc->nr_to_write or encounter the first error.
 			 */
-			done_index = folio->index + nr;
-			if (wbc->nr_to_write <= 0 &&
-			    wbc->sync_mode == WB_SYNC_NONE) {
-				done = 1;
-				break;
+			if (wbc->sync_mode == WB_SYNC_ALL) {
+				if (error && !ret)
+					ret = error;
+			} else {
+				if (error || wbc->nr_to_write <= 0)
+					goto done;
 			}
 		}
 		folio_batch_release(&fbatch);
@@ -2524,14 +2505,15 @@ continue_unlock:
 	 * of the file if we are called again, which can only happen due to
 	 * -ENOMEM from the file system.
 	 */
-	if (wbc->range_cyclic) {
-		if (done)
-			mapping->writeback_index = done_index;
-		else
-			mapping->writeback_index = 0;
-	}
-
+	if (wbc->range_cyclic)
+		mapping->writeback_index = 0;
 	return ret;
+
+done:
+	if (wbc->range_cyclic)
+		mapping->writeback_index = folio->index + folio_nr_pages(folio);
+	folio_batch_release(&fbatch);
+	return error;
 }
 EXPORT_SYMBOL(write_cache_pages);
 
_

Patches currently in -mm which might be from hch@lst.de are


