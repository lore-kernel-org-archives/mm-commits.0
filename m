From: akpm@linux-foundation.org
Subject: + swap-prevent-reuse-during-hibernation.patch added to -mm tree
Date: Tue, 07 Sep 2010 13:32:14 -0700
Message-ID: <201009072032.o87KWFbB004435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758114Ab0IGUck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 16:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, andrea.gelmini@gmail.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, linux@rainbow-software.org, nigel@tuxonice.net, rjw@sisk.pl, stable@kernel.org


The patch titled
     swap: prevent reuse during hibernation
has been added to the -mm tree.  Its filename is
     swap-prevent-reuse-during-hibernation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swap: prevent reuse during hibernation
From: Hugh Dickins <hughd@google.com>

Move the hibernation check from scan_swap_map() into try_to_free_swap():
to catch not only the common case when hibernation's allocation itself
triggers swap reuse, but also the less likely case when concurrent page
reclaim (shrink_page_list) might happen to try_to_free_swap from a page.

Hibernation already clears __GFP_IO from the gfp_allowed_mask, to stop
reclaim from going to swap: check that to prevent swap reuse too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ondrej Zary <linux@rainbow-software.org>
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~swap-prevent-reuse-during-hibernation mm/swapfile.c
--- a/mm/swapfile.c~swap-prevent-reuse-during-hibernation
+++ a/mm/swapfile.c
@@ -318,10 +318,8 @@ checks:
 	if (offset > si->highest_bit)
 		scan_base = offset = si->lowest_bit;
 
-	/* reuse swap entry of cache-only swap if not hibernation. */
-	if (vm_swap_full()
-		&& usage == SWAP_HAS_CACHE
-		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
+	/* reuse swap entry of cache-only swap if not busy. */
+	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
 		int swap_was_freed;
 		spin_unlock(&swap_lock);
 		swap_was_freed = __try_to_reclaim_swap(si, offset);
@@ -688,6 +686,24 @@ int try_to_free_swap(struct page *page)
 	if (page_swapcount(page))
 		return 0;
 
+	/*
+	 * Once hibernation has begun to create its image of memory,
+	 * there's a danger that one of the calls to try_to_free_swap()
+	 * - most probably a call from __try_to_reclaim_swap() while
+	 * hibernation is allocating its own swap pages for the image,
+	 * but conceivably even a call from memory reclaim - will free
+	 * the swap from a page which has already been recorded in the
+	 * image as a clean swapcache page, and then reuse its swap for
+	 * another page of the image.  On waking from hibernation, the
+	 * original page might be freed under memory pressure, then
+	 * later read back in from swap, now with the wrong data.
+	 *
+	 * Hibernation clears bits from gfp_allowed_mask to prevent
+	 * memory reclaim from writing to disk, so check that here.
+	 */
+	if (!(gfp_allowed_mask & __GFP_IO))
+		return 0;
+
 	delete_from_swap_cache(page);
 	SetPageDirty(page);
 	return 1;
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-fix-swapin-race-condition.patch
swap-revert-special-hibernation-allocation.patch
swap-prevent-reuse-during-hibernation.patch
swap-do-not-send-discards-as-barriers.patch
swap-discard-while-swapping-only-if-swap_flag_discard.patch
mm-compaction-fix-compactpagefailed-counting.patch
ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm.patch
ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2.patch
prio_tree-debugging-patch.patch

