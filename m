Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800FD81AC7
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708548691; cv=none; b=m1LzVaM1YDtMCz5QWrpjxZwkRfhaIgJclSYCz5hXROJ7T9IISHVjsBxK+oovIhHiFezsox4jiqlVR+7cE82gDKblOKvZ/ykFWLGL7RCL+dODACXwmr5E96c6ZhfJ3VUPupT+8URluLso8bHVT8vnMSGQK/ygDxqe1JffTcBuA0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708548691; c=relaxed/simple;
	bh=H4aYJ0xBPmrhHURyLchyuM2X1cxBWf9NZciovjM1yF0=;
	h=Date:To:From:Subject:Message-Id; b=etKs/EIae2bcAPueLOhMVYz4TiDn1iJMvd/97Tvp4bjOY9lwrkkc9i8ONPBOwOKDRTT7cNjoUT8UJu7cQR+cAH+0OzrGspEcHS5wi3gIHZBL6WITTOHaYDzc4cwfcsESW+76wegWdNfBJHPMT1MF2LZ5lW9CTdEYCjagtKpVBeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G3JHviX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G3JHviX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B8AC433F1;
	Wed, 21 Feb 2024 20:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708548690;
	bh=H4aYJ0xBPmrhHURyLchyuM2X1cxBWf9NZciovjM1yF0=;
	h=Date:To:From:Subject:From;
	b=G3JHviX9+ozZhflc/D+H9+5yrtN0kafOxgABhVRgjXEACZG0DpoBYPJEstJMc4FSS
	 46ltwuL3ZuXT5UV2oAkZdtK8iA7qGzJl6FKrnCOSdjkg3Z8+2JHZWgGmNjvNhWGXE4
	 ppJGX0gXn4OChh1+/Kj48/GEs80lDc/DxREpjuyk=
Date: Wed, 21 Feb 2024 12:51:30 -0800
To: mm-commits@vger.kernel.org,jack@suse.cz,hch@lst.de,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-simplify-the-loops-in-write_cache_pages.patch added to mm-unstable branch
Message-Id: <20240221205130.A6B8AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: simplify the loops in write_cache_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-simplify-the-loops-in-write_cache_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-simplify-the-loops-in-write_cache_pages.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: writeback: simplify the loops in write_cache_pages()
Date: Thu, 15 Feb 2024 07:36:44 +0100

Collapse the two nested loops into one.  This is needed as a step towards
turning this into an iterator.

Note that this drops the "index <= end" check in the previous outer loop
and just relies on filemap_get_folios_tag() to return 0 entries when index
> end.  This actually has a subtle implication when end == -1 because then
the returned index will be -1 as well and thus if there is page present on
index -1, we could be looping indefinitely.  But as the comment in
filemap_get_folios_tag documents this as already broken anyway we should
not worry about it here either.  The fix for that would probably a change
to the filemap_get_folios_tag() calling convention.

[hch@lst.de: update the commit log per Jan]
Link: https://lkml.kernel.org/r/20240215063649.2164017-10-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   83 ++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 43 deletions(-)

--- a/mm/page-writeback.c~writeback-simplify-the-loops-in-write_cache_pages
+++ a/mm/page-writeback.c
@@ -2454,6 +2454,7 @@ int write_cache_pages(struct address_spa
 	int error;
 	struct folio *folio;
 	pgoff_t end;		/* Inclusive */
+	int i = 0;
 
 	if (wbc->range_cyclic) {
 		wbc->index = mapping->writeback_index; /* prev offset */
@@ -2467,53 +2468,49 @@ int write_cache_pages(struct address_spa
 
 	folio_batch_init(&wbc->fbatch);
 
-	while (wbc->index <= end) {
-		int i;
-
-		writeback_get_batch(mapping, wbc);
-
+	for (;;) {
+		if (i == wbc->fbatch.nr) {
+			writeback_get_batch(mapping, wbc);
+			i = 0;
+		}
 		if (wbc->fbatch.nr == 0)
 			break;
 
-		for (i = 0; i < wbc->fbatch.nr; i++) {
-			folio = wbc->fbatch.folios[i];
+		folio = wbc->fbatch.folios[i++];
+
+		folio_lock(folio);
+		if (!folio_prepare_writeback(mapping, wbc, folio)) {
+			folio_unlock(folio);
+			continue;
+		}
+
+		trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
+
+		error = writepage(folio, wbc, data);
+		wbc->nr_to_write -= folio_nr_pages(folio);
+
+		if (error == AOP_WRITEPAGE_ACTIVATE) {
+			folio_unlock(folio);
+			error = 0;
+		}
 
-			folio_lock(folio);
-			if (!folio_prepare_writeback(mapping, wbc, folio)) {
-				folio_unlock(folio);
-				continue;
-			}
-
-			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
-
-			error = writepage(folio, wbc, data);
-			wbc->nr_to_write -= folio_nr_pages(folio);
-
-			if (error == AOP_WRITEPAGE_ACTIVATE) {
-				folio_unlock(folio);
-				error = 0;
-			}
-
-			/*
-			 * For integrity writeback we have to keep going until
-			 * we have written all the folios we tagged for
-			 * writeback above, even if we run past wbc->nr_to_write
-			 * or encounter errors.
-			 * We stash away the first error we encounter in
-			 * wbc->saved_err so that it can be retrieved when we're
-			 * done.  This is because the file system may still have
-			 * state to clear for each folio.
-			 *
-			 * For background writeback we exit as soon as we run
-			 * past wbc->nr_to_write or encounter the first error.
-			 */
-			if (wbc->sync_mode == WB_SYNC_ALL) {
-				if (error && !ret)
-					ret = error;
-			} else {
-				if (error || wbc->nr_to_write <= 0)
-					goto done;
-			}
+		/*
+		 * For integrity writeback we have to keep going until we have
+		 * written all the folios we tagged for writeback above, even if
+		 * we run past wbc->nr_to_write or encounter errors.
+		 * We stash away the first error we encounter in wbc->saved_err
+		 * so that it can be retrieved when we're done.  This is because
+		 * the file system may still have state to clear for each folio.
+		 *
+		 * For background writeback we exit as soon as we run past
+		 * wbc->nr_to_write or encounter the first error.
+		 */
+		if (wbc->sync_mode == WB_SYNC_ALL) {
+			if (error && !ret)
+				ret = error;
+		} else {
+			if (error || wbc->nr_to_write <= 0)
+				goto done;
 		}
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
mm-add-pfn_swap_entry_folio.patch
proc-use-pfn_swap_entry_folio-where-obvious.patch
mprotect-use-pfn_swap_entry_folio.patch
highmem-add-kernel-doc-for-memcpy__folio.patch
rmap-replace-two-calls-to-compound_order-with-folio_order.patch
writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

