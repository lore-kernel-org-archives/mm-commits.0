Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37207148857
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723064815; cv=none; b=NNGGjg8g4DIvmjPTe5QEo6DavCn96781KP0bOH4dv3M3rotUZTv3TppYTiOxSHw0vp9raPifc6pvBVqx56S3EZLIr2xEPvXtatWM2vpuTYtFg0WuAkzRTU9Uxu6IPtm+CU75/VmNXVON5jo2iHLbBBdSNPhA888F0ieVc2OJ+5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723064815; c=relaxed/simple;
	bh=agf5jtKMuMqD55f802AmFn+OCZ5kAJ6i10iMo6Ayd4E=;
	h=Date:To:From:Subject:Message-Id; b=IbSbAzAVuOt3zp5lOvsThM93m2fCB2UfkLJG5UBVgZ5ZKn3jfarLPruqH7uj2jjvScRauGlegdHsZHTNUOIqwFOxM7fNTp/EAB4Tl1agaiVysJt+BtGl0p1h8K3jwukkt6E0e8TJvfAuXcQBSJcJVSdUpcrpS/dsxT4fIEQG46w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zwgQaXVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zwgQaXVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FEBC32781;
	Wed,  7 Aug 2024 21:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723064814;
	bh=agf5jtKMuMqD55f802AmFn+OCZ5kAJ6i10iMo6Ayd4E=;
	h=Date:To:From:Subject:From;
	b=zwgQaXVfm4zDWUB4CxsixKdSJGC/UCpNbVZr4DBQp/pl1a2qjuOVOhVH8kMPhrx9R
	 LSrlpVJG1EmFu/bXDQClhTf/SYKtv5FZQQIeajTmExmt+p95BR0P+Zn+pRglqcC3+f
	 J3OEq4ZVKkfw35kJo7IJ7bIcXb58QQJCyJrqNvK4=
Date: Wed, 07 Aug 2024 14:06:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch added to mm-unstable branch
Message-Id: <20240807210654.83FEBC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: remove calls to set and clear the folio error flag
has been added to the -mm mm-unstable branch.  Its filename is
     fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch

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
@@ -2346,13 +2345,6 @@ static int filemap_read_folio(struct fil
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
@@ -640,8 +640,6 @@ void folio_migrate_flags(struct folio *n
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

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch

