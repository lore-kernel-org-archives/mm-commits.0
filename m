From: akpm@linux-foundation.org
Subject: + mm-filemapc-fix-mark_page_accessed-logic.patch added to -mm tree
Date: Thu, 15 Mar 2007 20:21:57 -0800
Message-ID: <200703160421.l2G4LvNb002375@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53576 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbXCPEWG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 00:22:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm/filemap.c: fix mark_page_accessed() logic
has been added to the -mm tree.  Its filename is
     mm-filemapc-fix-mark_page_accessed-logic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/filemap.c: fix mark_page_accessed() logic
From: Nick Piggin <npiggin@suse.de>

A change to make database style random read() workloads perform better, by
calling mark_page_accessed for some non-page-aligned reads broke the case
of < PAGE_CACHE_SIZE files, which will not get their prev_index moved past
the first page.

Combine both heuristics for marking the page accessed.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-filemapc-fix-mark_page_accessed-logic mm/filemap.c
--- a/mm/filemap.c~mm-filemapc-fix-mark_page_accessed-logic
+++ a/mm/filemap.c
@@ -928,7 +928,7 @@ page_ok:
 		 * When (part of) the same page is read multiple times
 		 * in succession, only mark it as accessed the first time.
 		 */
-		if (prev_index != index)
+		if (prev_index != index || !offset)
 			mark_page_accessed(page);
 		prev_index = index;
 
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-madvise-infinine-loop.patch
oom-fix-prevent-oom-from-killing-a-process-with-children-sibling-unkillable.patch
splice-dont-steal.patch
splice-dont-readpage.patch
mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-filemapc-fix-mark_page_accessed-logic.patch
exec-fix-remove_arg_zero.patch
exec-fix-remove_arg_zero-add-comment.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
