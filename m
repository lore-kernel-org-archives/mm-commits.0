From: akpm@linux-foundation.org
Subject: - mm-filemapc-fix-mark_page_accessed-logic.patch removed from -mm tree
Date: Tue, 10 Apr 2007 19:31:28 -0700
Message-ID: <200704110231.l3B2VSWB026136@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56321 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964AbXDKCbe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 22:31:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm/filemap.c: fix mark_page_accessed() logic
has been removed from the -mm tree.  Its filename was
     mm-filemapc-fix-mark_page_accessed-logic.patch

This patch was dropped because an updated version will be merged

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

mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-filemapc-fix-mark_page_accessed-logic.patch
exec-fix-remove_arg_zero.patch
exec-fix-remove_arg_zero-add-comment.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
