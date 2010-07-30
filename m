From: akpm@linux-foundation.org
Subject: + vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-correct-units-in-post-processing-script.patch added to -mm tree
Date: Fri, 30 Jul 2010 14:48:27 -0700
Message-ID: <201007302148.o6ULmRRa002440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107Ab0G3VuA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 17:50:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: tracing: Correct units in post-processing script
has been added to the -mm tree.  Its filename is
     vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-correct-units-in-post-processing-script.patch

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
Subject: vmscan: tracing: Correct units in post-processing script
From: Mel Gorman <mel@csn.ul.ie>

The post-processing script is reporting the wrong units. Correct it.  This
patch updates vmscan-tracing-add-trace-event-when-a-page-is-written.patch
to include that information. The patches can be merged together.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/trace/postprocess/trace-vmscan-postprocess.pl~vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-correct-units-in-post-processing-script Documentation/trace/postprocess/trace-vmscan-postprocess.pl
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-correct-units-in-post-processing-script
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -584,7 +584,7 @@ sub dump_stats {
 	print "Direct reclaim write file async I/O:	$total_direct_writepage_file_async\n";
 	print "Direct reclaim write anon async I/O:	$total_direct_writepage_anon_async\n";
 	print "Wake kswapd requests:			$total_wakeup_kswapd\n";
-	printf "Time stalled direct reclaim: 		%-1.2f ms\n", $total_direct_latency;
+	printf "Time stalled direct reclaim: 		%-1.2f seconds\n", $total_direct_latency;
 	print "\n";
 	print "Kswapd wakeups:				$total_kswapd_wake\n";
 	print "Kswapd pages scanned:			$total_kswapd_nr_scanned\n";
@@ -592,7 +592,7 @@ sub dump_stats {
 	print "Kswapd reclaim write anon sync I/O:	$total_kswapd_writepage_anon_sync\n";
 	print "Kswapd reclaim write file async I/O:	$total_kswapd_writepage_file_async\n";
 	print "Kswapd reclaim write anon async I/O:	$total_kswapd_writepage_anon_async\n";
-	printf "Time kswapd awake:			%-1.2f ms\n", $total_kswapd_latency;
+	printf "Time kswapd awake:			%-1.2f seconds\n", $total_kswapd_latency;
 }
 
 sub aggregate_perprocesspid() {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-call-mmu-notifiers-on-hugepage-cow.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-update-post-processing-script-to-distinguish-between-anon-and-file-io-from-page-reclaim.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-correct-units-in-post-processing-script.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
vmscan-avoid-subtraction-of-unsigned-types.patch
vmscan-convert-direct-reclaim-tracepoint-to-define_trace.patch
memcg-vmscan-add-memcg-reclaim-tracepoint.patch
vmscan-convert-mm_vmscan_lru_isolate-to-define_event.patch
memcg-add-mm_vmscan_memcg_isolate-tracepoint.patch
memcg-scnr_to_reclaim-should-be-initialized.patch
memcg-kill-unnecessary-initialization-in-mem_cgroup_shrink_node_zone.patch
memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask.patch
memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim.patch
memcg-convert-to-use-zone_to_nid-from-bare-zone-zone_pgdat-node_id.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

