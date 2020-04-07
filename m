From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 023/166] mm: adjust shuffle code to allow for
 future coalescing
Date: Mon, 06 Apr 2020 20:04:45 -0700
Message-ID: <20200407030445.HtgtdbUys%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgDGDEr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:04:47 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com, dave.hansen@intel.com, david@redhat.com, konrad.wilk@oracle.com, lcapitulino@redhat.com, linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, nitesh@redhat.com, osalvador@suse.de, pagupta@redhat.com, pbonzini@redhat.com, riel@surriel.com, torvalds@linux-foundation.org, vbabka@suse.cz, wei.w.wang@intel.com, weiqi4@huawei.com, willy@infradead.org, yang.zhang.wz@gmail.com

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: mm: adjust shuffle code to allow for future coalescing

Patch series "mm / virtio: Provide support for free page reporting", v17.

This series provides an asynchronous means of reporting free guest pages
to a hypervisor so that the memory associated with those pages can be
dropped and reused by other processes and/or guests on the host.  Using
this it is possible to avoid unnecessary I/O to disk and greatly improve
performance in the case of memory overcommit on the host.

When enabled we will be performing a scan of free memory every 2 seconds
while pages of sufficiently high order are being freed.  In each pass at
least one sixteenth of each free list will be reported.  By doing this we
avoid racing against other threads that may be causing a high amount of
memory churn.

The lowest page order currently scanned when reporting pages is
pageblock_order so that this feature will not interfere with the use of
Transparent Huge Pages in the case of virtualization.

Currently this is only in use by virtio-balloon however there is the hope
that at some point in the future other hypervisors might be able to make
use of it.  In the virtio-balloon/QEMU implementation the hypervisor is
currently using MADV_DONTNEED to indicate to the host kernel that the page
is currently free.  It will be zeroed and faulted back into the guest the
next time the page is accessed.

To track if a page is reported or not the Uptodate flag was repurposed and
used as a Reported flag for Buddy pages.  We walk though the free list
isolating pages and adding them to the scatterlist until we either
encounter the end of the list or have processed at least one sixteenth of
the pages that were listed in nr_free prior to us starting.  If we fill
the scatterlist before we reach the end of the list we rotate the list so
that the first unreported page we encounter is moved to the head of the
list as that is where we will resume after we have freed the reported
pages back into the tail of the list.

Below are the results from various benchmarks.  I primarily focused on two
tests.  The first is the will-it-scale/page_fault2 test, and the other is
a modified version of will-it-scale/page_fault1 that was enabled to use
THP.  I did this as it allows for better visibility into different parts
of the memory subsystem.  The guest is running with 32G for RAM on one
node of a E5-2630 v3.  The host has had some features such as CPU turbo
disabled in the BIOS.

Test                   page_fault1 (THP)    page_fault2
Name            tasks  Process Iter  STDEV  Process Iter  STDEV
Baseline            1    1012402.50  0.14%     361855.25  0.81%
                   16    8827457.25  0.09%    3282347.00  0.34%

Patches Applied     1    1007897.00  0.23%     361887.00  0.26%
                   16    8784741.75  0.39%    3240669.25  0.48%

Patches Enabled     1    1010227.50  0.39%     359749.25  0.56%
                   16    8756219.00  0.24%    3226608.75  0.97%

Patches Enabled     1    1050982.00  4.26%     357966.25  0.14%
 page shuffle      16    8672601.25  0.49%    3223177.75  0.40%

Patches enabled     1    1003238.00  0.22%     360211.00  0.22%
 shuffle w/ RFC    16    8767010.50  0.32%    3199874.00  0.71%

The results above are for a baseline with a linux-next-20191219 kernel,
that kernel with this patch set applied but page reporting disabled in
virtio-balloon, the patches applied and page reporting fully enabled, the
patches enabled with page shuffling enabled, and the patches applied with
page shuffling enabled and an RFC patch that makes used of MADV_FREE in
QEMU.  These results include the deviation seen between the average value
reported here versus the high and/or low value.  I observed that during
the test memory usage for the first three tests never dropped whereas with
the patches fully enabled the VM would drop to using only a few GB of the
host's memory when switching from memhog to page fault tests.

Any of the overhead visible with this patch set enabled seems due to page
faults caused by accessing the reported pages and the host zeroing the
page before giving it back to the guest.  This overhead is much more
visible when using THP than with standard 4K pages.  In addition page
shuffling seemed to increase the amount of faults generated due to an
increase in memory churn.  The overehad is reduced when using MADV_FREE as
we can avoid the extra zeroing of the pages when they are reintroduced to
the host, as can be seen when the RFC is applied with shuffling enabled.

The overall guest size is kept fairly small to only a few GB while the
test is running.  If the host memory were oversubscribed this patch set
should result in a performance improvement as swapping memory in the host
can be avoided.

A brief history on the background of free page reporting can be found at:
https://lore.kernel.org/lkml/29f43d5796feed0dec8e8bb98b187d9dac03b900.camel@linux.intel.com/


This patch (of 9):

Move the head/tail adding logic out of the shuffle code and into the
__free_one_page function since ultimately that is where it is really
needed anyway.  By doing this we should be able to reduce the overhead and
can consolidate all of the list addition bits in one spot.

Link: http://lkml.kernel.org/r/20200211224602.29318.84523.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Yang Zhang <yang.zhang.wz@gmail.com>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Wei Wang <wei.w.wang@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: wei qi <weiqi4@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   12 ------
 mm/page_alloc.c        |   71 +++++++++++++++++++++++----------------
 mm/shuffle.c           |   12 +++---
 mm/shuffle.h           |    6 +++
 4 files changed, 54 insertions(+), 47 deletions(-)

--- a/include/linux/mmzone.h~mm-adjust-shuffle-code-to-allow-for-future-coalescing
+++ a/include/linux/mmzone.h
@@ -116,18 +116,6 @@ static inline void add_to_free_area_tail
 	area->nr_free++;
 }
 
-#ifdef CONFIG_SHUFFLE_PAGE_ALLOCATOR
-/* Used to preserve page allocation order entropy */
-void add_to_free_area_random(struct page *page, struct free_area *area,
-		int migratetype);
-#else
-static inline void add_to_free_area_random(struct page *page,
-		struct free_area *area, int migratetype)
-{
-	add_to_free_area(page, area, migratetype);
-}
-#endif
-
 /* Used for pages which are on another list */
 static inline void move_to_free_area(struct page *page, struct free_area *area,
 			     int migratetype)
--- a/mm/page_alloc.c~mm-adjust-shuffle-code-to-allow-for-future-coalescing
+++ a/mm/page_alloc.c
@@ -865,6 +865,36 @@ compaction_capture(struct capture_contro
 #endif /* CONFIG_COMPACTION */
 
 /*
+ * If this is not the largest possible page, check if the buddy
+ * of the next-highest order is free. If it is, it's possible
+ * that pages are being freed that will coalesce soon. In case,
+ * that is happening, add the free page to the tail of the list
+ * so it's less likely to be used soon and more likely to be merged
+ * as a higher order page
+ */
+static inline bool
+buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
+		   struct page *page, unsigned int order)
+{
+	struct page *higher_page, *higher_buddy;
+	unsigned long combined_pfn;
+
+	if (order >= MAX_ORDER - 2)
+		return false;
+
+	if (!pfn_valid_within(buddy_pfn))
+		return false;
+
+	combined_pfn = buddy_pfn & pfn;
+	higher_page = page + (combined_pfn - pfn);
+	buddy_pfn = __find_buddy_pfn(combined_pfn, order + 1);
+	higher_buddy = higher_page + (buddy_pfn - combined_pfn);
+
+	return pfn_valid_within(buddy_pfn) &&
+	       page_is_buddy(higher_page, higher_buddy, order + 1);
+}
+
+/*
  * Freeing function for a buddy system allocator.
  *
  * The concept of a buddy system is to maintain direct-mapped table
@@ -893,11 +923,13 @@ static inline void __free_one_page(struc
 		struct zone *zone, unsigned int order,
 		int migratetype)
 {
-	unsigned long combined_pfn;
+	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
-	struct page *buddy;
+	unsigned long combined_pfn;
+	struct free_area *area;
 	unsigned int max_order;
-	struct capture_control *capc = task_capc(zone);
+	struct page *buddy;
+	bool to_tail;
 
 	max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
 
@@ -966,35 +998,16 @@ continue_merging:
 done_merging:
 	set_page_order(page, order);
 
-	/*
-	 * If this is not the largest possible page, check if the buddy
-	 * of the next-highest order is free. If it is, it's possible
-	 * that pages are being freed that will coalesce soon. In case,
-	 * that is happening, add the free page to the tail of the list
-	 * so it's less likely to be used soon and more likely to be merged
-	 * as a higher order page
-	 */
-	if ((order < MAX_ORDER-2) && pfn_valid_within(buddy_pfn)
-			&& !is_shuffle_order(order)) {
-		struct page *higher_page, *higher_buddy;
-		combined_pfn = buddy_pfn & pfn;
-		higher_page = page + (combined_pfn - pfn);
-		buddy_pfn = __find_buddy_pfn(combined_pfn, order + 1);
-		higher_buddy = higher_page + (buddy_pfn - combined_pfn);
-		if (pfn_valid_within(buddy_pfn) &&
-		    page_is_buddy(higher_page, higher_buddy, order + 1)) {
-			add_to_free_area_tail(page, &zone->free_area[order],
-					      migratetype);
-			return;
-		}
-	}
-
+	area = &zone->free_area[order];
 	if (is_shuffle_order(order))
-		add_to_free_area_random(page, &zone->free_area[order],
-				migratetype);
+		to_tail = shuffle_pick_tail();
 	else
-		add_to_free_area(page, &zone->free_area[order], migratetype);
+		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
 
+	if (to_tail)
+		add_to_free_area_tail(page, area, migratetype);
+	else
+		add_to_free_area(page, area, migratetype);
 }
 
 /*
--- a/mm/shuffle.c~mm-adjust-shuffle-code-to-allow-for-future-coalescing
+++ a/mm/shuffle.c
@@ -183,11 +183,11 @@ void __meminit __shuffle_free_memory(pg_
 		shuffle_zone(z);
 }
 
-void add_to_free_area_random(struct page *page, struct free_area *area,
-		int migratetype)
+bool shuffle_pick_tail(void)
 {
 	static u64 rand;
 	static u8 rand_bits;
+	bool ret;
 
 	/*
 	 * The lack of locking is deliberate. If 2 threads race to
@@ -198,10 +198,10 @@ void add_to_free_area_random(struct page
 		rand = get_random_u64();
 	}
 
-	if (rand & 1)
-		add_to_free_area(page, area, migratetype);
-	else
-		add_to_free_area_tail(page, area, migratetype);
+	ret = rand & 1;
+
 	rand_bits--;
 	rand >>= 1;
+
+	return ret;
 }
--- a/mm/shuffle.h~mm-adjust-shuffle-code-to-allow-for-future-coalescing
+++ a/mm/shuffle.h
@@ -22,6 +22,7 @@ enum mm_shuffle_ctl {
 DECLARE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
 extern void page_alloc_shuffle(enum mm_shuffle_ctl ctl);
 extern void __shuffle_free_memory(pg_data_t *pgdat);
+extern bool shuffle_pick_tail(void);
 static inline void shuffle_free_memory(pg_data_t *pgdat)
 {
 	if (!static_branch_unlikely(&page_alloc_shuffle_key))
@@ -44,6 +45,11 @@ static inline bool is_shuffle_order(int
 	return order >= SHUFFLE_ORDER;
 }
 #else
+static inline bool shuffle_pick_tail(void)
+{
+	return false;
+}
+
 static inline void shuffle_free_memory(pg_data_t *pgdat)
 {
 }
_
