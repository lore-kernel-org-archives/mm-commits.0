From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:31 -0700
Message-ID: <5390ca7f.zrQioXR2Nz5bgbWF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaFETwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, stable@vger.kernel.org, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, iamjoonsoo.kim@lge.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: [merged] mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch removed from -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,iamjoonsoo.kim@lge.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,stable@vger.kernel.org,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:31 -0700


The patch titled
     Subject: mm: page_alloc: use word-based accesses for get/set pageblock bitmaps
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


In addition to the performance benefits, this patch closes races that are
possible between:

a) get_ and set_pageblock_migratetype(), where get_pageblock_migratetype()
   reads part of the bits before and other part of the bits after
   set_pageblock_migratetype() has updated them.

b) set_pageblock_migratetype() and set_pageblock_skip(), where the non-atomic
   read-modify-update set bit operation in set_pageblock_skip() will cause
   lost updates to some bits changed in the set_pageblock_migratetype().

Joonsoo Kim first reported the case a) via code inspection.  Vlastimil
Babka's testing with a debug patch showed that either a) or b) occurs
roughly once per mmtests' stress-highalloc benchmark (although not
necessarily in the same pageblock).  Furthermore during development of
unrelated compaction patches, it was observed that frequent calls to
{start,undo}_isolate_page_range() the race occurs several thousands of
times and has resulted in NULL pointer dereferences in move_freepages()
and free_one_page() in places where free_list[migratetype] is
manipulated by e.g.  list_move().  Further debugging confirmed that
migratetype had invalid value of 6, causing out of bounds access to the
free_list array.  

That confirmed that the race exist, although it may be extremely rare,
and currently only fatal where page isolation is performed due to
memory hot remove.  Races on pageblocks being updated by
set_pageblock_migratetype(), where both old and new migratetype are
lower MIGRATE_RESERVE, currently cannot result in an invalid value
being observed, although theoretically they may still lead to
unexpected creation or destruction of MIGRATE_RESERVE pageblocks. 
Furthermore, things could get suddenly worse when memory isolation is
used more, or when new migratetypes are added.

After this patch, the race has no longer been observed in testing.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-and-tested-by: Vlastimil Babka <vbabka@suse.cz>
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
Cc: <stable@vger.kernel.org>
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

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

