From: akpm@linux-foundation.org
Subject: + tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch added to -mm tree
Date: Mon, 10 Aug 2009 15:10:08 -0700
Message-ID: <200908102210.n7AMA8YC014150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754023AbZHJWMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 18:12:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, lwoodman@redhat.com, macli@brc.ubc.ca, mingo@elte.hu, peterz@infradead.org, riel@redhat.com


The patch titled
     tracing, documentation: Add a document on the kmem tracepoints
has been added to the -mm tree.  Its filename is
     tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch

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
Subject: tracing, documentation: Add a document on the kmem tracepoints
From: Mel Gorman <mel@csn.ul.ie>

Knowing tracepoints exist is not quite the same as knowing what they
should be used for.  This patch adds a document giving a basic description
of the kmem tracepoints and why they might be useful to a performance
analyst.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Ming Chun <macli@brc.ubc.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/events-kmem.txt |  107 ++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff -puN /dev/null Documentation/trace/events-kmem.txt
--- /dev/null
+++ a/Documentation/trace/events-kmem.txt
@@ -0,0 +1,107 @@
+			Subsystem Trace Points: kmem
+
+The tracing system kmem captures events related to object and page allocation
+within the kernel. Broadly speaking there are four major subheadings.
+
+  o Slab allocation of small objects of unknown type (kmalloc)
+  o Slab allocation of small objects of known type
+  o Page allocation
+  o Per-CPU Allocator Activity
+  o External Fragmentation
+
+This document will describe what each of the tracepoints are and why they
+might be useful.
+
+1. Slab allocation of small objects of unknown type
+===================================================
+kmalloc		call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s
+kmalloc_node	call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d
+kfree		call_site=%lx ptr=%p
+
+Heavy activity for these events may indicate that a specific cache is
+justified, particularly if kmalloc slab pages are getting significantly
+internal fragmented as a result of the allocation pattern. By correlating
+kmalloc with kfree, it may be possible to identify memory leaks and where
+the allocation sites were.
+
+
+2. Slab allocation of small objects of known type
+=================================================
+kmem_cache_alloc	call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s
+kmem_cache_alloc_node	call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d
+kmem_cache_free		call_site=%lx ptr=%p
+
+These events are similar in usage to the kmalloc-related events except that
+it is likely easier to pin the event down to a specific cache. At the time
+of writing, no information is available on what slab is being allocated from,
+but the call_site can usually be used to extrapolate that information
+
+3. Page allocation
+==================
+mm_page_alloc		  page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s
+mm_page_alloc_zone_locked page=%p pfn=%lu order=%u migratetype=%d cpu=%d percpu_refill=%d
+mm_page_free_direct	  page=%p pfn=%lu order=%d
+mm_pagevec_free		  page=%p pfn=%lu order=%d cold=%d
+
+These four events deal with page allocation and freeing. mm_page_alloc is
+a simple indicator of page allocator activity. Pages may be allocated from
+the per-CPU allocator (high performance) or the buddy allocator.
+
+If pages are allocated directly from the buddy allocator, the
+mm_page_alloc_zone_locked event is triggered. This event is important as high
+amounts of activity imply high activity on the zone->lock. Taking this lock
+impairs performance by disabling interrupts, dirtying cache lines between
+CPUs and serialising many CPUs.
+
+When a page is freed directly by the caller, the mm_page_free_direct event
+is triggered. Significant amounts of activity here could indicate that the
+callers should be batching their activities.
+
+When pages are freed using a pagevec, the mm_pagevec_free is
+triggered. Broadly speaking, pages are taken off the LRU lock in bulk and
+freed in batch with a pagevec. Significant amounts of activity here could
+indicate that the system is under memory pressure and can also indicate
+contention on the zone->lru_lock.
+
+4. Per-CPU Allocator Activity
+=============================
+mm_page_alloc_zone_locked	page=%p pfn=%lu order=%u migratetype=%d cpu=%d percpu_refill=%d
+mm_page_pcpu_drain		page=%p pfn=%lu order=%d cpu=%d migratetype=%d
+
+In front of the page allocator is a per-cpu page allocator. It exists only
+for order-0 pages, reduces contention on the zone->lock and reduces the
+amount of writing on struct page.
+
+When a per-CPU list is empty or pages of the wrong type are allocated,
+the zone->lock will be taken once and the per-CPU list refilled. The event
+triggered is mm_page_alloc_zone_locked for each page allocated with the
+event indicating whether it is for a percpu_refill or not.
+
+When the per-CPU list is too full, a number of pages are freed, each one
+which triggers a mm_page_pcpu_drain event.
+
+The individual nature of the events are so that pages can be tracked
+between allocation and freeing. A number of drain or refill pages that occur
+consecutively imply the zone->lock being taken once. Large amounts of PCP
+refills and drains could imply an imbalance between CPUs where too much work
+is being concentrated in one place. It could also indicate that the per-CPU
+lists should be a larger size. Finally, large amounts of refills on one CPU
+and drains on another could be a factor in causing large amounts of cache
+line bounces due to writes between CPUs and worth investigating if pages
+can be allocated and freed on the same CPU through some algorithm change.
+
+5. External Fragmentation
+=========================
+mm_page_alloc_extfrag		page=%p pfn=%lu alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d
+
+External fragmentation affects whether a high-order allocation will be
+successful or not. For some types of hardware, this is important although
+it is avoided where possible. If the system is using huge pages and needs
+to be able to resize the pool over the lifetime of the system, this value
+is important.
+
+Large numbers of this event implies that memory is fragmenting and
+high-order allocations will start failing at some time in the future. One
+means of reducing the occurange of this event is to increase the size of
+min_free_kbytes in increments of 3*pageblock_size*nr_online_nodes where
+pageblock_size is usually the size of the default hugepage size.
_

Patches currently in -mm which might be from mel@csn.ul.ie are

memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
mm-clean-up-page_remove_rmap.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch
page-allocator-remove-dead-function-free_cold_page.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
add-debugging-aid-for-memory-initialisation-problems.patch

