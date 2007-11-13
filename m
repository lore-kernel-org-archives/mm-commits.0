From: akpm@linux-foundation.org
Subject: - mm-unlockless-reclaim.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:31:08 -0800
Message-ID: <200711130438.lAD4c8fv026275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbXKMEiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:38:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: unlockless reclaim
has been removed from the -mm tree.  Its filename was
     mm-unlockless-reclaim.patch

This patch was dropped because it doesn't compile

------------------------------------------------------
Subject: mm: unlockless reclaim
From: Nick Piggin <npiggin@suse.de>

unlock_page() is fairly expensive.  It can be avoided in page reclaim.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-unlockless-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-unlockless-reclaim
+++ a/mm/vmscan.c
@@ -589,7 +589,14 @@ static unsigned long shrink_page_list(st
 			goto keep_locked;
 
 free_it:
-		unlock_page(page);
+		/*
+		 * At this point, we have no other references and there is
+		 * no way to pick any more up (removed from LRU, removed
+		 * from pagecache). Can use non-atomic bitops now (and
+		 * we obviously don't have to worry about waking up a process
+		 * waiting on the page lock, because there are no references.
+		 */
+		__clear_page_locked(page);
 		nr_reclaimed++;
 		if (!pagevec_add(&freed_pvec, page))
 			__pagevec_release_nonlru(&freed_pvec);
_

Patches currently in -mm which might be from npiggin@suse.de are

nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
rd-fix-data-corruption-on-memory-pressure.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-page-trylock-rename.patch
fs-buffer-trylock-rename.patch
mm-unlockless-reclaim.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4.patch
