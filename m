From: akpm@linux-foundation.org
Subject: + mm-add-tracepoints-for-lru-activation-and-insertions.patch
 added to -mm tree
Date: Tue, 28 May 2013 13:06:00 -0700
Message-ID: <51a50e28.cSo5M+lO1TwmVdQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3E1UGC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 16:06:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, sanbai@taobao.com, riel@redhat.com, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dhowells@redhat.com, bernd.schubert@fastmail.fm, anserper@ya.ru, alexey.lyashkov@gmail.com, Trond.Myklebust@netapp.com, mgorman@suse.de

Subject: + mm-add-tracepoints-for-lru-activation-and-insertions.patch added to -mm tree
To: mgorman@suse.de,Trond.Myklebust@netapp.com,alexey.lyashkov@gmail.com,anserper@ya.ru,bernd.schubert@fastmail.fm,dhowells@redhat.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,riel@redhat.com,sanbai@taobao.com,tytso@mit.edu
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 13:06:00 -0700


The patch titled
     Subject: mm: add tracepoints for LRU activation and insertions
has been added to the -mm tree.  Its filename is
     mm-add-tracepoints-for-lru-activation-and-insertions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: add tracepoints for LRU activation and insertions

Andrew Perepechko reported a problem whereby pages are being prematurely
evicted as the mark_page_accessed() hint is ignored for pages that are
currently on a pagevec --
http://www.spinics.net/lists/linux-ext4/msg37340.html .  Alexey Lyahkov
and Robin Dong have also reported problems recently that could be due to
hot pages reaching the end of the inactive list too quickly and be
reclaimed.

Rather than addressing this on a per-filesystem basis, this series aims to
fix the mark_page_accessed() interface by deferring what LRU a page is
added to pagevec drain time and allowing mark_page_accessed() to call
SetPageActive on a pagevec page.

Patch 1 adds two tracepoints for LRU page activation and insertion. Using
	these processes it's possible to build a model of pages in the
	LRU that can be processed offline.

Patch 2 defers making the decision on what LRU to add a page to until when
	the pagevec is drained.

Patch 3 searches the local pagevec for pages to mark PageActive on
	mark_page_accessed. The changelog explains why only the local
	pagevec is examined.

Patches 4 and 5 tidy up the API.

postmark, a dd-based test and fs-mark both single and threaded mode were
run but none of them showed any performance degradation or gain as a
result of the patch.

Using patch 1, I built a *very* basic model of the LRU to examine offline
what the average age of different page types on the LRU were in
milliseconds.  Of course, capturing the trace distorts the test as it's
written to local disk but it does not matter for the purposes of this
test.  The average age of pages in milliseconds were

				    vanilla deferdrain
Average age mapped anon:               1454       1250
Average age mapped file:             127841     155552
Average age unmapped anon:               85        235
Average age unmapped file:            73633      38884
Average age unmapped buffers:         74054     116155

The LRU activity was mostly files which you'd expect for a dd-based
workload.  Note that the average age of buffer pages is increased by the
series and it is expected this is due to the fact that the buffer pages
are now getting added to the active list when drained from the pagevecs. 
Note that the average age of the unmapped file data is decreased as they
are still added to the inactive list and are reclaimed before the buffers.
 There is no guarantee this is a universal win for all workloads and it
would be nice if the filesystem people gave some thought as to whether
this decision is generally a win or a loss.



This patch:

Using these tracepoints it is possible to model LRU activity and the
average residency of pages of different types.  This can be used to debug
problems related to premature reclaim of pages of particular types.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Lyahkov <alexey.lyashkov@gmail.com>
Cc: Andrew Perepechko <anserper@ya.ru>
Cc: Robin Dong <sanbai@taobao.com>
Cc: Theodore Tso <tytso@mit.edu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/pagemap.h |   89 +++++++++++++++++++++++++++++++
 mm/swap.c                      |    5 +
 2 files changed, 94 insertions(+)

diff -puN /dev/null include/trace/events/pagemap.h
--- /dev/null
+++ a/include/trace/events/pagemap.h
@@ -0,0 +1,89 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM pagemap
+
+#if !defined(_TRACE_PAGEMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PAGEMAP_H
+
+#include <linux/tracepoint.h>
+#include <linux/mm.h>
+
+#define	PAGEMAP_MAPPED		0x0001u
+#define PAGEMAP_ANONYMOUS	0x0002u
+#define PAGEMAP_FILE		0x0004u
+#define PAGEMAP_SWAPCACHE	0x0008u
+#define PAGEMAP_SWAPBACKED	0x0010u
+#define PAGEMAP_MAPPEDDISK	0x0020u
+#define PAGEMAP_BUFFERS		0x0040u
+
+#define trace_pagemap_flags(page) ( \
+	(PageAnon(page)		? PAGEMAP_ANONYMOUS  : PAGEMAP_FILE) | \
+	(page_mapped(page)	? PAGEMAP_MAPPED     : 0) | \
+	(PageSwapCache(page)	? PAGEMAP_SWAPCACHE  : 0) | \
+	(PageSwapBacked(page)	? PAGEMAP_SWAPBACKED : 0) | \
+	(PageMappedToDisk(page)	? PAGEMAP_MAPPEDDISK : 0) | \
+	(page_has_private(page) ? PAGEMAP_BUFFERS    : 0) \
+	)
+
+TRACE_EVENT(mm_lru_insertion,
+
+	TP_PROTO(
+		struct page *page,
+		unsigned long pfn,
+		int lru,
+		unsigned long flags
+	),
+
+	TP_ARGS(page, pfn, lru, flags),
+
+	TP_STRUCT__entry(
+		__field(struct page *,	page	)
+		__field(unsigned long,	pfn	)
+		__field(int,		lru	)
+		__field(unsigned long,	flags	)
+	),
+
+	TP_fast_assign(
+		__entry->page	= page;
+		__entry->pfn	= pfn;
+		__entry->lru	= lru;
+		__entry->flags	= flags;
+	),
+
+	/* Flag format is based on page-types.c formatting for pagemap */
+	TP_printk("page=%p pfn=%lu lru=%d flags=%s%s%s%s%s%s",
+			__entry->page,
+			__entry->pfn,
+			__entry->lru,
+			__entry->flags & PAGEMAP_MAPPED		? "M" : " ",
+			__entry->flags & PAGEMAP_ANONYMOUS	? "a" : "f",
+			__entry->flags & PAGEMAP_SWAPCACHE	? "s" : " ",
+			__entry->flags & PAGEMAP_SWAPBACKED	? "b" : " ",
+			__entry->flags & PAGEMAP_MAPPEDDISK	? "d" : " ",
+			__entry->flags & PAGEMAP_BUFFERS	? "B" : " ")
+);
+
+TRACE_EVENT(mm_lru_activate,
+
+	TP_PROTO(struct page *page, unsigned long pfn),
+
+	TP_ARGS(page, pfn),
+
+	TP_STRUCT__entry(
+		__field(struct page *,	page	)
+		__field(unsigned long,	pfn	)
+	),
+
+	TP_fast_assign(
+		__entry->page	= page;
+		__entry->pfn	= pfn;
+	),
+
+	/* Flag format is based on page-types.c formatting for pagemap */
+	TP_printk("page=%p pfn=%lu", __entry->page, __entry->pfn)
+
+);
+
+#endif /* _TRACE_PAGEMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff -puN mm/swap.c~mm-add-tracepoints-for-lru-activation-and-insertions mm/swap.c
--- a/mm/swap.c~mm-add-tracepoints-for-lru-activation-and-insertions
+++ a/mm/swap.c
@@ -34,6 +34,9 @@
 
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/pagemap.h>
+
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
@@ -384,6 +387,7 @@ static void __activate_page(struct page
 		SetPageActive(page);
 		lru += LRU_ACTIVE;
 		add_page_to_lru_list(page, lruvec, lru);
+		trace_mm_lru_activate(page, page_to_pfn(page));
 
 		__count_vm_event(PGACTIVATE);
 		update_page_reclaim_stat(lruvec, file, 1);
@@ -808,6 +812,7 @@ static void __pagevec_lru_add_fn(struct
 		SetPageActive(page);
 	add_page_to_lru_list(page, lruvec, lru);
 	update_page_reclaim_stat(lruvec, file, active);
+	trace_mm_lru_insertion(page, page_to_pfn(page), lru, trace_pagemap_flags(page));
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-memmap_init_zone-performance-improvement.patch

