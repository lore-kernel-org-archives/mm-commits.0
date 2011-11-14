From: akpm@linux-foundation.org
Subject: + mm-tracepoint-rename-page-free-events.patch added to -mm tree
Date: Mon, 14 Nov 2011 15:31:00 -0800
Message-ID: <201111142331.pAENV0Dm011921@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:56016 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1KNXbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 18:31:06 -0500
Received: by faap16 with SMTP id p16so83070faa.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 15:31:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: mm-tracepoint: rename page-free events
has been added to the -mm tree.  Its filename is
     mm-tracepoint-rename-page-free-events.patch

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
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm-tracepoint: rename page-free events

Rename mm_page_free_direct into mm_page_free and mm_pagevec_free into
mm_page_free_batched

Since v2.6.33-5426-gc475dab the kernel triggers mm_page_free_direct for
all freed pages, not only for directly freed.  So, let's name it properly.
 For pages freed via page-list we also trigger mm_page_free_batched event.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/events-kmem.txt                            |   12 +++---
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl |   20 +++++-----
 include/trace/events/kmem.h                                    |    4 +-
 mm/page_alloc.c                                                |    4 +-
 4 files changed, 20 insertions(+), 20 deletions(-)

diff -puN Documentation/trace/events-kmem.txt~mm-tracepoint-rename-page-free-events Documentation/trace/events-kmem.txt
--- a/Documentation/trace/events-kmem.txt~mm-tracepoint-rename-page-free-events
+++ a/Documentation/trace/events-kmem.txt
@@ -40,8 +40,8 @@ but the call_site can usually be used to
 ==================
 mm_page_alloc		  page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s
 mm_page_alloc_zone_locked page=%p pfn=%lu order=%u migratetype=%d cpu=%d percpu_refill=%d
-mm_page_free_direct	  page=%p pfn=%lu order=%d
-mm_pagevec_free		  page=%p pfn=%lu order=%d cold=%d
+mm_page_free		  page=%p pfn=%lu order=%d
+mm_page_free_batched	  page=%p pfn=%lu order=%d cold=%d
 
 These four events deal with page allocation and freeing. mm_page_alloc is
 a simple indicator of page allocator activity. Pages may be allocated from
@@ -53,13 +53,13 @@ amounts of activity imply high activity 
 impairs performance by disabling interrupts, dirtying cache lines between
 CPUs and serialising many CPUs.
 
-When a page is freed directly by the caller, the mm_page_free_direct event
+When a page is freed directly by the caller, the only mm_page_free event
 is triggered. Significant amounts of activity here could indicate that the
 callers should be batching their activities.
 
-When pages are freed using a pagevec, the mm_pagevec_free is
-triggered. Broadly speaking, pages are taken off the LRU lock in bulk and
-freed in batch with a pagevec. Significant amounts of activity here could
+When pages are freed in batch, the also mm_page_free_batched is triggered.
+Broadly speaking, pages are taken off the LRU lock in bulk and
+freed in batch with a page list. Significant amounts of activity here could
 indicate that the system is under memory pressure and can also indicate
 contention on the zone->lru_lock.
 
diff -puN Documentation/trace/postprocess/trace-pagealloc-postprocess.pl~mm-tracepoint-rename-page-free-events Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
--- a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl~mm-tracepoint-rename-page-free-events
+++ a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
@@ -17,8 +17,8 @@ use Getopt::Long;
 
 # Tracepoint events
 use constant MM_PAGE_ALLOC		=> 1;
-use constant MM_PAGE_FREE_DIRECT 	=> 2;
-use constant MM_PAGEVEC_FREE		=> 3;
+use constant MM_PAGE_FREE		=> 2;
+use constant MM_PAGE_FREE_BATCHED	=> 3;
 use constant MM_PAGE_PCPU_DRAIN		=> 4;
 use constant MM_PAGE_ALLOC_ZONE_LOCKED	=> 5;
 use constant MM_PAGE_ALLOC_EXTFRAG	=> 6;
@@ -223,10 +223,10 @@ EVENT_PROCESS:
 		# Perl Switch() sucks majorly
 		if ($tracepoint eq "mm_page_alloc") {
 			$perprocesspid{$process_pid}->{MM_PAGE_ALLOC}++;
-		} elsif ($tracepoint eq "mm_page_free_direct") {
-			$perprocesspid{$process_pid}->{MM_PAGE_FREE_DIRECT}++;
-		} elsif ($tracepoint eq "mm_pagevec_free") {
-			$perprocesspid{$process_pid}->{MM_PAGEVEC_FREE}++;
+		} elsif ($tracepoint eq "mm_page_free") {
+			$perprocesspid{$process_pid}->{MM_PAGE_FREE}++
+		} elsif ($tracepoint eq "mm_page_free_batched") {
+			$perprocesspid{$process_pid}->{MM_PAGE_FREE_BATCHED}++;
 		} elsif ($tracepoint eq "mm_page_pcpu_drain") {
 			$perprocesspid{$process_pid}->{MM_PAGE_PCPU_DRAIN}++;
 			$perprocesspid{$process_pid}->{STATE_PCPU_PAGES_DRAINED}++;
@@ -336,8 +336,8 @@ sub dump_stats {
 			$process_pid,
 			$stats{$process_pid}->{MM_PAGE_ALLOC},
 			$stats{$process_pid}->{MM_PAGE_ALLOC_ZONE_LOCKED},
-			$stats{$process_pid}->{MM_PAGE_FREE_DIRECT},
-			$stats{$process_pid}->{MM_PAGEVEC_FREE},
+			$stats{$process_pid}->{MM_PAGE_FREE},
+			$stats{$process_pid}->{MM_PAGE_FREE_BATCHED},
 			$stats{$process_pid}->{MM_PAGE_PCPU_DRAIN},
 			$stats{$process_pid}->{HIGH_PCPU_DRAINS},
 			$stats{$process_pid}->{HIGH_PCPU_REFILLS},
@@ -364,8 +364,8 @@ sub aggregate_perprocesspid() {
 
 		$perprocess{$process}->{MM_PAGE_ALLOC} += $perprocesspid{$process_pid}->{MM_PAGE_ALLOC};
 		$perprocess{$process}->{MM_PAGE_ALLOC_ZONE_LOCKED} += $perprocesspid{$process_pid}->{MM_PAGE_ALLOC_ZONE_LOCKED};
-		$perprocess{$process}->{MM_PAGE_FREE_DIRECT} += $perprocesspid{$process_pid}->{MM_PAGE_FREE_DIRECT};
-		$perprocess{$process}->{MM_PAGEVEC_FREE} += $perprocesspid{$process_pid}->{MM_PAGEVEC_FREE};
+		$perprocess{$process}->{MM_PAGE_FREE} += $perprocesspid{$process_pid}->{MM_PAGE_FREE};
+		$perprocess{$process}->{MM_PAGE_FREE_BATCHED} += $perprocesspid{$process_pid}->{MM_PAGE_FREE_BATCHED};
 		$perprocess{$process}->{MM_PAGE_PCPU_DRAIN} += $perprocesspid{$process_pid}->{MM_PAGE_PCPU_DRAIN};
 		$perprocess{$process}->{HIGH_PCPU_DRAINS} += $perprocesspid{$process_pid}->{HIGH_PCPU_DRAINS};
 		$perprocess{$process}->{HIGH_PCPU_REFILLS} += $perprocesspid{$process_pid}->{HIGH_PCPU_REFILLS};
diff -puN include/trace/events/kmem.h~mm-tracepoint-rename-page-free-events include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~mm-tracepoint-rename-page-free-events
+++ a/include/trace/events/kmem.h
@@ -147,7 +147,7 @@ DEFINE_EVENT(kmem_free, kmem_cache_free,
 	TP_ARGS(call_site, ptr)
 );
 
-TRACE_EVENT(mm_page_free_direct,
+TRACE_EVENT(mm_page_free,
 
 	TP_PROTO(struct page *page, unsigned int order),
 
@@ -169,7 +169,7 @@ TRACE_EVENT(mm_page_free_direct,
 			__entry->order)
 );
 
-TRACE_EVENT(mm_pagevec_free,
+TRACE_EVENT(mm_page_free_batched,
 
 	TP_PROTO(struct page *page, int cold),
 
diff -puN mm/page_alloc.c~mm-tracepoint-rename-page-free-events mm/page_alloc.c
--- a/mm/page_alloc.c~mm-tracepoint-rename-page-free-events
+++ a/mm/page_alloc.c
@@ -654,7 +654,7 @@ static bool free_pages_prepare(struct pa
 	int i;
 	int bad = 0;
 
-	trace_mm_page_free_direct(page, order);
+	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
 
 	if (PageAnon(page))
@@ -1218,7 +1218,7 @@ void free_hot_cold_page_list(struct list
 	struct page *page, *next;
 
 	list_for_each_entry_safe(page, next, list, lru) {
-		trace_mm_pagevec_free(page, cold);
+		trace_mm_page_free_batched(page, cold);
 		free_hot_cold_page(page, cold);
 	}
 }
_
Subject: Subject: mm-tracepoint: rename page-free events

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
vmscan-fix-initial-shrinker-size-handling.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch

