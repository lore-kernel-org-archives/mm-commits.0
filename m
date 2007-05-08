From: akpm@linux-foundation.org
Subject: - mm-simplify-filemap_nopage.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:15 -0700
Message-ID: <200705080002.l4802Fm0008829@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967320AbXEHACs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: simplify filemap_nopage
has been removed from the -mm tree.  Its filename was
     mm-simplify-filemap_nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: simplify filemap_nopage
From: Nick Piggin <npiggin@suse.de>

Identical block is duplicated twice: contrary to the comment, we have been
re-reading the page *twice* in filemap_nopage rather than once.

If any retry logic or anything is needed, it belongs in lower levels anyway. 
Only retry once.  Linus agrees.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff -puN mm/filemap.c~mm-simplify-filemap_nopage mm/filemap.c
--- a/mm/filemap.c~mm-simplify-filemap_nopage
+++ a/mm/filemap.c
@@ -1446,30 +1446,6 @@ page_not_uptodate:
 		majmin = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
 	}
-	lock_page(page);
-
-	/* Did it get unhashed while we waited for it? */
-	if (!page->mapping) {
-		unlock_page(page);
-		page_cache_release(page);
-		goto retry_all;
-	}
-
-	/* Did somebody else get it up-to-date? */
-	if (PageUptodate(page)) {
-		unlock_page(page);
-		goto success;
-	}
-
-	error = mapping->a_ops->readpage(file, page);
-	if (!error) {
-		wait_on_page_locked(page);
-		if (PageUptodate(page))
-			goto success;
-	} else if (error == AOP_TRUNCATED_PAGE) {
-		page_cache_release(page);
-		goto retry_find;
-	}
 
 	/*
 	 * Umm, take care of errors if the page isn't up-to-date.
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-more-rmap-checking.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-document-fault_data-and-flags.patch
exec-fix-remove_arg_zero.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
