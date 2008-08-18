From: akpm@linux-foundation.org
Subject: + mm-unlockless-reclaim.patch added to -mm tree
Date: Mon, 18 Aug 2008 16:29:53 -0700
Message-ID: <200808182329.m7INTrab019435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbYHRX36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 19:29:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: unlockless reclaim
has been added to the -mm tree.  Its filename is
     mm-unlockless-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: unlockless reclaim
From: Nick Piggin <npiggin@suse.de>

unlock_page is fairly expensive.  It can be avoided in page reclaim
success path.  By definition if we have any other references to the page
it would be a bug anyway.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-unlockless-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-unlockless-reclaim
+++ a/mm/vmscan.c
@@ -781,7 +781,14 @@ static unsigned long shrink_page_list(st
 		if (!mapping || !__remove_mapping(mapping, page))
 			goto keep_locked;
 
-		unlock_page(page);
+		/*
+		 * At this point, we have no other references and there is
+		 * no way to pick any more up (removed from LRU, removed
+		 * from pagecache). Can use non-atomic bitops now (and
+		 * we obviously don't have to worry about waking up a process
+		 * waiting on the page lock, because there are no references.
+		 */
+		__clear_page_locked(page);
 free_it:
 		nr_reclaimed++;
 		if (!pagevec_add(&freed_pvec, page)) {
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mm-dirty-page-tracking-race-fix.patch
mm-dirty-page-tracking-race-fix-fix.patch
mm-xip-fix-fault-vs-sparse-page-invalidate-race.patch
mm-xip-ext2-fix-block-allocation-race.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
mm-pagecache-insertion-fewer-atomics.patch
mm-unlockless-reclaim.patch
mm-page-lock-use-lock-bitops.patch
fs-buffer-lock-use-lock-bitops.patch
mm-page-allocator-minor-speedup.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

