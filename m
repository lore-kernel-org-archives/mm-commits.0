Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204113C488
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548687; cv=none; b=n8PwxTK2YNJK9boLc1VeEahCDeIBGoPCOLWQuz/FUXLVvPQ663Nd9STJBH40YDUoXq2N5D4zahJYof5UARzKXKJBk9rrcUGPp8Ct8Xxzs5dSfku7MY64pl91JNARDeyQaZ0hciUE6jM5oNaOaz1XfGYb2ewW+fqlV1ARStQ9Gzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548687; c=relaxed/simple;
	bh=tCdSTec7Y4tsiUx6KpVPmpRCZL5nDrOw1DP7kdCncfA=;
	h=Date:To:From:Subject:Message-Id; b=mE6qr8ndtwNzE2a8nvE8kRTmMsIFNbDIekSeclUvX3xDElbfr72wksooCd5dOs6V5T8MPoEV7xzDDeAdmeyyuDhVNqpDVSGJeocEVu7ALlGMsJGODBdH2pqxJLlJu2EogPX8BgUIrhOyK0rlUYGS273jj+umDPDrwUvIxwLjdAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MPmVYJGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MPmVYJGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ACAC433F1;
	Wed, 21 Feb 2024 20:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548687;
	bh=tCdSTec7Y4tsiUx6KpVPmpRCZL5nDrOw1DP7kdCncfA=;
	h=Date:To:From:Subject:From;
	b=MPmVYJGJFOY9kNXLzsJ+jCEi3r+KMaV+qSONFSEgnTpbdnmfl40CzGxUFMraVQgNc
	 VnkVnGRTZ35SQRkBsDkEEHu6ix6fO2LYoPoV/pdwo7YvJssb4AbCkK9iJdcfpHdmug
	 HA40br/YSIXOO0nAN4LM9sLpnI7qOrLPTqx8jZMg=
Date: Wed, 21 Feb 2024 12:51:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch added to mm-unstable branch
Message-Id: <20240221205126.E0ACAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: rework the loop termination condition in write_cache_pages
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch

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

writeback-dont-call-mapping_set_error-on-aop_writepage_activate.patch
writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch
writeback-also-update-wbc-nr_to_write-on-writeback-failure.patch
writeback-only-update-writeback_index-for-range_cyclic-writeback.patch
writeback-rework-the-loop-termination-condition-in-write_cache_pages.patch
writeback-add-a-writeback-iterator.patch

