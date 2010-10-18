From: akpm@linux-foundation.org
Subject: + mm-page-allocator-do-not-check-the-state-of-a-non-existant-buddy-during-free.patch added to -mm tree
Date: Mon, 18 Oct 2010 12:38:01 -0700
Message-ID: <201010181938.o9IJc1R0030012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933144Ab0JRTjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 15:39:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, czoccolo@gmail.com, kosaki.motohiro@jp.fujitsu.com, pacman@kosh.dhis.org, riel@redhat.com, stable@kernel.org


The patch titled
     mm, page-allocator: do not check the state of a non-existant buddy during free
has been added to the -mm tree.  Its filename is
     mm-page-allocator-do-not-check-the-state-of-a-non-existant-buddy-during-free.patch

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
Subject: mm, page-allocator: do not check the state of a non-existant buddy during free
From: Mel Gorman <mel@csn.ul.ie>

There is a bug in commit 6dda9d55 ("page allocator: reduce fragmentation
in buddy allocator by adding buddies that are merging to the tail of the
free lists") that means a buddy at order MAX_ORDER is checked for merging.
 A page of this order never exists so at times, an effectively random
piece of memory is being checked.

Alan Curry has reported that this is causing memory corruption in
userspace data on a PPC32 platform (http://lkml.org/lkml/2010/10/9/32). 
It is not clear why this is happening.  It could be a cache coherency
problem where pages mapped in both user and kernel space are getting
different cache lines due to the bad read from kernel space
(http://lkml.org/lkml/2010/10/13/179).  It could also be that there are
some special registers being io-remapped at the end of the memmap array
and that a read has special meaning on them.  Compiler bugs have been
ruled out because the assembly before and after the patch looks relatively
harmless.

This patch fixes the problem by ensuring we are not reading a possibly
invalid location of memory.  It's not clear why the read causes corruption
but one way or the other it is a buggy read.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Corrado Zoccolo <czoccolo@gmail.com>
Reported-by: Alan Curry <pacman@kosh.dhis.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page-allocator-do-not-check-the-state-of-a-non-existant-buddy-during-free mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-do-not-check-the-state-of-a-non-existant-buddy-during-free
+++ a/mm/page_alloc.c
@@ -530,7 +530,7 @@ static inline void __free_one_page(struc
 	 * so it's less likely to be used soon and more likely to be merged
 	 * as a higher order page
 	 */
-	if ((order < MAX_ORDER-1) && pfn_valid_within(page_to_pfn(buddy))) {
+	if ((order < MAX_ORDER-2) && pfn_valid_within(page_to_pfn(buddy))) {
 		struct page *higher_page, *higher_buddy;
 		combined_idx = __find_combined_index(page_idx, order);
 		higher_page = page + combined_idx - page_idx;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-page-allocator-do-not-check-the-state-of-a-non-existant-buddy-during-free.patch
linux-next.patch
include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton.patch
mm-compaction-fix-compactpagefailed-counting.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
mm-fix-typo-in-mmh-when-node_not_in_page_flags.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

