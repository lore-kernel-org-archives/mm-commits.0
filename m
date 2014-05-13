From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
 added to -mm tree
Date: Tue, 13 May 2014 15:40:56 -0700
Message-ID: <53729f78.bxM0ThenKSdJY6Om%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbaEMWk5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 18:40:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: + mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch added to -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 15:40:56 -0700


The patch titled
     Subject: mm: page_alloc: use word-based accesses for get/set pageblock bitmaps
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch

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
Subject: mm: page_alloc: use word-based accesses for get/set pageblock bitmaps

The test_bit operations in get/set pageblock flags are expensive.  This
patch reads the bitmap on a word basis and use shifts and masks to isolate
the bits of interest.  Similarly masks are used to set a local copy of the
bitmap and then use cmpxchg to update the bitmap if there have been no
other changes made in parallel.

In a test running dd onto tmpfs the overhead of the pageblock-related
functions went from 1.27% in profiles to 0.5%.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |    6 ++-
 include/linux/pageblock-flags.h |   37 +++++++++++++++++----
 mm/page_alloc.c                 |   52 ++++++++++++++++++------------
 3 files changed, 68 insertions(+), 27 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps
+++ a/include/linux/mmzone.h
@@ -75,9 +75,13 @@ enum {
 
 extern int page_group_by_mobility_disabled;
 
+#define NR_MIGRATETYPE_BITS (PB_migrate_end - PB_migrate + 1)
+#define MIGRATETYPE_MASK ((1UL << NR_MIGRATETYPE_BITS) - 1)
+
 static inline int get_pageblock_migratetype(struct page *page)
 {
-	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
+	BUILD_BUG_ON(PB_migrate_end - PB_migrate != 2);
+	return get_pageblock_flags_mask(page, PB_migrate_end, MIGRATETYPE_MASK);
 }
 
 struct free_area {
diff -puN include/linux/pageblock-flags.h~mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps
+++ a/include/linux/pageblock-flags.h
@@ -30,9 +30,12 @@ enum pageblock_bits {
 	PB_migrate,
 	PB_migrate_end = PB_migrate + 3 - 1,
 			/* 3 bits required for migrate types */
-#ifdef CONFIG_COMPACTION
 	PB_migrate_skip,/* If set the block is skipped by compaction */
-#endif /* CONFIG_COMPACTION */
+
+	/*
+	 * Assume the bits will always align on a word. If this assumption
+	 * changes then get/set pageblock needs updating.
+	 */
 	NR_PAGEBLOCK_BITS
 };
 
@@ -62,11 +65,33 @@ extern int pageblock_order;
 /* Forward declaration */
 struct page;
 
+unsigned long get_pageblock_flags_mask(struct page *page,
+				unsigned long end_bitidx,
+				unsigned long mask);
+void set_pageblock_flags_mask(struct page *page,
+				unsigned long flags,
+				unsigned long end_bitidx,
+				unsigned long mask);
+
 /* Declarations for getting and setting flags. See mm/page_alloc.c */
-unsigned long get_pageblock_flags_group(struct page *page,
-					int start_bitidx, int end_bitidx);
-void set_pageblock_flags_group(struct page *page, unsigned long flags,
-					int start_bitidx, int end_bitidx);
+static inline unsigned long get_pageblock_flags_group(struct page *page,
+					int start_bitidx, int end_bitidx)
+{
+	unsigned long nr_flag_bits = end_bitidx - start_bitidx + 1;
+	unsigned long mask = (1 << nr_flag_bits) - 1;
+
+	return get_pageblock_flags_mask(page, end_bitidx, mask);
+}
+
+static inline void set_pageblock_flags_group(struct page *page,
+					unsigned long flags,
+					int start_bitidx, int end_bitidx)
+{
+	unsigned long nr_flag_bits = end_bitidx - start_bitidx + 1;
+	unsigned long mask = (1 << nr_flag_bits) - 1;
+
+	set_pageblock_flags_mask(page, flags, end_bitidx, mask);
+}
 
 #ifdef CONFIG_COMPACTION
 #define get_pageblock_skip(page) \
diff -puN mm/page_alloc.c~mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps
+++ a/mm/page_alloc.c
@@ -6028,53 +6028,65 @@ static inline int pfn_to_bitidx(struct z
  * @end_bitidx: The last bit of interest
  * returns pageblock_bits flags
  */
-unsigned long get_pageblock_flags_group(struct page *page,
-					int start_bitidx, int end_bitidx)
+unsigned long get_pageblock_flags_mask(struct page *page,
+					unsigned long end_bitidx,
+					unsigned long mask)
 {
 	struct zone *zone;
 	unsigned long *bitmap;
-	unsigned long pfn, bitidx;
-	unsigned long flags = 0;
-	unsigned long value = 1;
+	unsigned long pfn, bitidx, word_bitidx;
+	unsigned long word;
 
 	zone = page_zone(page);
 	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
+	word_bitidx = bitidx / BITS_PER_LONG;
+	bitidx &= (BITS_PER_LONG-1);
 
-	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
-		if (test_bit(bitidx + start_bitidx, bitmap))
-			flags |= value;
-
-	return flags;
+	word = bitmap[word_bitidx];
+	bitidx += end_bitidx;
+	return (word >> (BITS_PER_LONG - bitidx - 1)) & mask;
 }
 
 /**
- * set_pageblock_flags_group - Set the requested group of flags for a pageblock_nr_pages block of pages
+ * set_pageblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
  * @page: The page within the block of interest
  * @start_bitidx: The first bit of interest
  * @end_bitidx: The last bit of interest
  * @flags: The flags to set
  */
-void set_pageblock_flags_group(struct page *page, unsigned long flags,
-					int start_bitidx, int end_bitidx)
+void set_pageblock_flags_mask(struct page *page, unsigned long flags,
+					unsigned long end_bitidx,
+					unsigned long mask)
 {
 	struct zone *zone;
 	unsigned long *bitmap;
-	unsigned long pfn, bitidx;
-	unsigned long value = 1;
+	unsigned long pfn, bitidx, word_bitidx;
+	unsigned long old_word, word;
+
+	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 
 	zone = page_zone(page);
 	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
+	word_bitidx = bitidx / BITS_PER_LONG;
+	bitidx &= (BITS_PER_LONG-1);
+
 	VM_BUG_ON_PAGE(!zone_spans_pfn(zone, pfn), page);
 
-	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
-		if (flags & value)
-			__set_bit(bitidx + start_bitidx, bitmap);
-		else
-			__clear_bit(bitidx + start_bitidx, bitmap);
+	bitidx += end_bitidx;
+	mask <<= (BITS_PER_LONG - bitidx - 1);
+	flags <<= (BITS_PER_LONG - bitidx - 1);
+
+	word = ACCESS_ONCE(bitmap[word_bitidx]);
+	for (;;) {
+		old_word = cmpxchg(&bitmap[word_bitidx], word, (word & ~mask) | flags);
+		if (word == old_word)
+			break;
+		word = old_word;
+	}
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@suse.de are

x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-fix.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-x86-pgtable-drop-unneeded-preprocessor-ifdef.patch
mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active.patch
mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch
linux-next.patch

