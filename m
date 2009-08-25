From: akpm@linux-foundation.org
Subject: + mm-vmscan-remove-page_queue_congested-comment.patch added to -mm tree
Date: Tue, 25 Aug 2009 13:38:59 -0700
Message-ID: <200908252038.n7PKcxfX022996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755274AbZHYUkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Aug 2009 16:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macli@brc.ubc.ca


The patch titled
     mm/vmscan: remove page_queue_congested() comment
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-page_queue_congested-comment.patch

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
Subject: mm/vmscan: remove page_queue_congested() comment
From: Vincent Li <macli@brc.ubc.ca>

Commit 084f71ae5c(kill page_queue_congested()) removed
page_queue_congested().  Remove the page_queue_congested() comment in
vmscan pageout() too.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-page_queue_congested-comment mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-page_queue_congested-comment
+++ a/mm/vmscan.c
@@ -366,7 +366,6 @@ static pageout_t pageout(struct page *pa
 	 * block, for some throttling. This happens by accident, because
 	 * swap_backing_dev_info is bust: it doesn't reflect the
 	 * congestion state of the swapdevs.  Easy to fix, if needed.
-	 * See swapfile.c:page_queue_congested().
 	 */
 	if (!is_page_cache_freeable(page))
 		return PAGE_KEEP;
_

Patches currently in -mm which might be from macli@brc.ubc.ca are

mm-count-only-reclaimable-lru-pages-v2.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
mm-vmscan-remove-page_queue_congested-comment.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch

