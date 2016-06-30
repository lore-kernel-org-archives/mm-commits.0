From: akpm@linux-foundation.org
Subject: +
 mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner.patch
 added to -mm tree
Date: Wed, 29 Jun 2016 23:52:10 -0700
Message-ID: <5774c19a.gAJTmqlCL/HlCAdB%akpm__9314.06577951766$1467269546$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbcF3GwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jun 2016 02:52:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, minchan@kernel.org, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: prevent VM_BUG_ON when terminating freeing scanner
has been added to the -mm tree.  Its filename is
     mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1606291436300.145590@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

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
@@ -1034,36 +1032,31 @@ static void isolate_freepages(struct com
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
+			isolate_start_pfn = block_start_pfn;
+			break;
 		}
 	}
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-prevent-vm_bug_on-when-terminating-freeing-scanner.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix.patch

