From: akpm@linux-foundation.org
Subject: [patch 01/20] mm, compaction: prevent VM_BUG_ON when terminating
 freeing scanner
Date: Thu, 14 Jul 2016 12:06:50 -0700
Message-ID: <5787e2ca.ZSoN5FEmKN/9QhG8%akpm__10393.3857907125$1468523236$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcGNTGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, minchan@kernel.org, stable@vger.kernel.org, vbabka@suse.cz

From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: prevent VM_BUG_ON when terminating freeing scanner

It's possible to isolate some freepages in a pageblock and then fail
split_free_page() due to the low watermark check.  In this case, we hit
VM_BUG_ON() because the freeing scanner terminated early without a
contended lock or enough freepages.

This should never have been a VM_BUG_ON() since it's not a fatal
condition.  It should have been a VM_WARN_ON() at best, or even handled
gracefully.

Regardless, we need to terminate anytime the full pageblock scan was not
done.  The logic belongs in isolate_freepages_block(), so handle its state
gracefully by terminating the pageblock loop and making a note to restart
at the same pageblock next time since it was not possible to complete the
scan this time.

[rientjes@google.com: don't rescan pages in a pageblock]
  Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1607111244150.83138@chino.kir.corp.google.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1606291436300.145590@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Tested-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff -puN mm/compaction.c~mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner mm/compaction.c
--- a/mm/compaction.c~mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner
+++ a/mm/compaction.c
@@ -1009,8 +1009,6 @@ static void isolate_freepages(struct com
 				block_end_pfn = block_start_pfn,
 				block_start_pfn -= pageblock_nr_pages,
 				isolate_start_pfn = block_start_pfn) {
-		unsigned long isolated;
-
 		/*
 		 * This can iterate a massively long zone without finding any
 		 * suitable migration targets, so periodically check if we need
@@ -1034,36 +1032,30 @@ static void isolate_freepages(struct com
 			continue;
 
 		/* Found a block suitable for isolating free pages from. */
-		isolated = isolate_freepages_block(cc, &isolate_start_pfn,
-						block_end_pfn, freelist, false);
-		/* If isolation failed early, do not continue needlessly */
-		if (!isolated && isolate_start_pfn < block_end_pfn &&
-		    cc->nr_migratepages > cc->nr_freepages)
-			break;
+		isolate_freepages_block(cc, &isolate_start_pfn, block_end_pfn,
+					freelist, false);
 
 		/*
-		 * If we isolated enough freepages, or aborted due to async
-		 * compaction being contended, terminate the loop.
-		 * Remember where the free scanner should restart next time,
-		 * which is where isolate_freepages_block() left off.
-		 * But if it scanned the whole pageblock, isolate_start_pfn
-		 * now points at block_end_pfn, which is the start of the next
-		 * pageblock.
-		 * In that case we will however want to restart at the start
-		 * of the previous pageblock.
+		 * If we isolated enough freepages, or aborted due to lock
+		 * contention, terminate.
 		 */
 		if ((cc->nr_freepages >= cc->nr_migratepages)
 							|| cc->contended) {
-			if (isolate_start_pfn >= block_end_pfn)
+			if (isolate_start_pfn >= block_end_pfn) {
+				/*
+				 * Restart at previous pageblock if more
+				 * freepages can be isolated next time.
+				 */
 				isolate_start_pfn =
 					block_start_pfn - pageblock_nr_pages;
+			}
 			break;
-		} else {
+		} else if (isolate_start_pfn < block_end_pfn) {
 			/*
-			 * isolate_freepages_block() should not terminate
-			 * prematurely unless contended, or isolated enough
+			 * If isolation failed early, do not continue
+			 * needlessly.
 			 */
-			VM_BUG_ON(isolate_start_pfn < block_end_pfn);
+			break;
 		}
 	}
 
_
