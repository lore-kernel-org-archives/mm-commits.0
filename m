Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB4C57CB6
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247770; cv=none; b=Bbm534rSmeMo61h2iMuMKnv81O3+nCXIXf1DmGAq7pPt076+U5bAnyCydp7CHlTEYTjMPAK+BXcRG9gSZcdW9yHLSO6GiP3tFHNPB3j/XwXjidZhYFob5djfSfwii9KH0+kutB/ObdPm+OEFl5Hqjvvk+ONqIVcyUriIPI+vbr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247770; c=relaxed/simple;
	bh=zYfTm5dyL1wBin1NLX+NchuaE6Dxzxdo5PJ8qAFwkbQ=;
	h=Date:To:From:Subject:Message-Id; b=RLHSthRqkLv4SStF3P59e4Uh8ZepKud0kuzF9K1ztO6sri6ERvdpPtD2Bge1wlxLaxnTuyeUF5PPOj5SXuFXC4RaK6eRU6GvGnIRAE27t02UiUdUWkqZ6wNR464AyP4RgrMYaaa/HpWHcIWPrpDiNLSaR16TJV5mjQxk9HWrUX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A8jTD2A5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A8jTD2A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DB5C4CEC2;
	Mon,  2 Sep 2024 03:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247770;
	bh=zYfTm5dyL1wBin1NLX+NchuaE6Dxzxdo5PJ8qAFwkbQ=;
	h=Date:To:From:Subject:From;
	b=A8jTD2A56CwsiliJNiHpeXlFr/lh/NwFIDk50BlmwvLStg55Lq3/PUN7B7MShBpEO
	 sgZKbjcaMsRzo31h+41BrXU6P8YoHk6t6kQsAOQddgBTgOpB/3YeyjNTXypo0Oerc9
	 lwGKXxF3vJFUkCZk5KLsOOkKEPrQiEe5IuIQrW8U=
Date: Sun, 01 Sep 2024 20:29:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch removed from -mm tree
Message-Id: <20240902032930.03DB5C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: remove calls to set and clear the folio error flag
has been removed from the -mm tree.  Its filename was
     fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: remove calls to set and clear the folio error flag
Date: Wed, 7 Aug 2024 20:35:25 +0100

Nobody checks the folio error flag any more, so we can stop setting and
clearing it.  Also remove the documentation suggesting to not bother
setting the error bit.

Link: https://lkml.kernel.org/r/20240807193528.1865100-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.rst |    3 +--
 mm/filemap.c                      |    8 --------
 mm/migrate.c                      |    2 --
 mm/page_io.c                      |    4 +---
 4 files changed, 2 insertions(+), 15 deletions(-)

--- a/Documentation/filesystems/vfs.rst~fs-remove-calls-to-set-and-clear-the-folio-error-flag
+++ a/Documentation/filesystems/vfs.rst
@@ -913,8 +913,7 @@ cache in your filesystem.  The following
 	stop attempting I/O, it can simply return.  The caller will
 	remove the remaining pages from the address space, unlock them
 	and decrement the page refcount.  Set PageUptodate if the I/O
-	completes successfully.  Setting PageError on any page will be
-	ignored; simply unlock the page if an I/O error occurs.
+	completes successfully.
 
 ``write_begin``
 	Called by the generic buffered write code to ask the filesystem
--- a/mm/filemap.c~fs-remove-calls-to-set-and-clear-the-folio-error-flag
+++ a/mm/filemap.c
@@ -530,7 +530,6 @@ static void __filemap_fdatawait_range(st
 			struct folio *folio = fbatch.folios[i];
 
 			folio_wait_writeback(folio);
-			folio_clear_error(folio);
 		}
 		folio_batch_release(&fbatch);
 		cond_resched();
@@ -2342,13 +2341,6 @@ static int filemap_read_folio(struct fil
 	unsigned long pflags;
 	int error;
 
-	/*
-	 * A previous I/O error may have been due to temporary failures,
-	 * eg. multipath errors.  PG_error will be set again if read_folio
-	 * fails.
-	 */
-	folio_clear_error(folio);
-
 	/* Start the actual read. The read will unlock the page. */
 	if (unlikely(workingset))
 		psi_memstall_enter(&pflags);
--- a/mm/migrate.c~fs-remove-calls-to-set-and-clear-the-folio-error-flag
+++ a/mm/migrate.c
@@ -586,8 +586,6 @@ void folio_migrate_flags(struct folio *n
 {
 	int cpupid;
 
-	if (folio_test_error(folio))
-		folio_set_error(newfolio);
 	if (folio_test_referenced(folio))
 		folio_set_referenced(newfolio);
 	if (folio_test_uptodate(folio))
--- a/mm/page_io.c~fs-remove-calls-to-set-and-clear-the-folio-error-flag
+++ a/mm/page_io.c
@@ -273,9 +273,7 @@ static void sio_write_complete(struct ki
 		 * memory for allocating transmit buffers.
 		 * Mark the page dirty and avoid
 		 * folio_rotate_reclaimable but rate-limit the
-		 * messages but do not flag PageError like
-		 * the normal direct-to-bio case as it could
-		 * be temporary.
+		 * messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
 				   ret, swap_dev_pos(page_swap_entry(page)));
_

Patches currently in -mm which might be from willy@infradead.org are

printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch
mm-remove-pageactive.patch
mm-remove-pageswapbacked.patch
mm-remove-pagereadahead.patch
mm-remove-pageswapcache.patch
mm-remove-pageunevictable.patch
mm-remove-pagemlocked.patch
mm-remove-pageownerpriv1.patch
mm-remove-page_has_private.patch
mm-rename-pg_mappedtodisk-to-pg_owner_2.patch
x86-remove-pg_uncached.patch
swap-convert-swapon-to-use-a-folio.patch

