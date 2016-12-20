From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key.patch
 added to -mm tree
Date: Tue, 20 Dec 2016 14:14:59 -0800
Message-ID: <5859ad63.5V8732gq+FYTZ/4s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35518 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755591AbcLTWN5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2016 17:13:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, peterz@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: convert page_group_by_mobility_disable to static key
has been added to the -mm tree.  Its filename is
     mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: convert page_group_by_mobility_disable to static key

The flag is rarely enabled or even changed, so it's an ideal static key
candidate. Since it's being checked in the page allocator fastpath via
gfpflags_to_migratetype(), it may actually save some valuable cycles.

Here's a diff excerpt from __alloc_pages_nodemask() assembly:

        -movl    page_group_by_mobility_disabled(%rip), %ecx
	+.byte 0x0f,0x1f,0x44,0x00,0
         movl    %r9d, %eax
         shrl    $3, %eax
         andl    $3, %eax
        -testl   %ecx, %ecx
        -movl    $0, %ecx
        -cmovne  %ecx, %eax

I.e. a NOP instead of test, conditional move and some assisting moves.

Link: http://lkml.kernel.org/r/20161220134312.17332-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    2 +-
 include/linux/mmzone.h |    3 ++-
 mm/page_alloc.c        |   23 +++++++++++++----------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff -puN include/linux/gfp.h~mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key include/linux/gfp.h
--- a/include/linux/gfp.h~mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key
+++ a/include/linux/gfp.h
@@ -270,7 +270,7 @@ static inline int gfpflags_to_migratetyp
 	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
 	BUILD_BUG_ON((___GFP_MOVABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_MOVABLE);
 
-	if (unlikely(page_group_by_mobility_disabled))
+	if (static_branch_unlikely(&page_group_by_mobility_disabled))
 		return MIGRATE_UNMOVABLE;
 
 	/* Group based on mobility */
diff -puN include/linux/mmzone.h~mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key
+++ a/include/linux/mmzone.h
@@ -17,6 +17,7 @@
 #include <linux/pageblock-flags.h>
 #include <linux/page-flags-layout.h>
 #include <linux/atomic.h>
+#include <linux/jump_label.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
@@ -78,7 +79,7 @@ extern char * const migratetype_names[MI
 	for (order = 0; order < MAX_ORDER; order++) \
 		for (type = 0; type < MIGRATE_TYPES; type++)
 
-extern int page_group_by_mobility_disabled;
+extern struct static_key_false page_group_by_mobility_disabled;
 
 #define NR_MIGRATETYPE_BITS (PB_migrate_end - PB_migrate + 1)
 #define MIGRATETYPE_MASK ((1UL << NR_MIGRATETYPE_BITS) - 1)
diff -puN mm/page_alloc.c~mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key
+++ a/mm/page_alloc.c
@@ -281,7 +281,7 @@ EXPORT_SYMBOL(nr_node_ids);
 EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
-int page_group_by_mobility_disabled __read_mostly;
+DEFINE_STATIC_KEY_FALSE(page_group_by_mobility_disabled);
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void reset_deferred_meminit(pg_data_t *pgdat)
@@ -450,9 +450,10 @@ void set_pfnblock_flags_mask(struct page
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
 {
-	if (unlikely(page_group_by_mobility_disabled &&
-		     migratetype < MIGRATE_PCPTYPES))
-		migratetype = MIGRATE_UNMOVABLE;
+	if (static_branch_unlikely(&page_group_by_mobility_disabled)) {
+		if (migratetype < MIGRATE_PCPTYPES)
+			migratetype = MIGRATE_UNMOVABLE;
+	}
 
 	set_pageblock_flags_group(page, (unsigned long)migratetype,
 					PB_migrate, PB_migrate_end);
@@ -1942,8 +1943,10 @@ static bool can_steal_fallback(unsigned
 
 	if (order >= pageblock_order / 2 ||
 		start_mt == MIGRATE_RECLAIMABLE ||
-		start_mt == MIGRATE_UNMOVABLE ||
-		page_group_by_mobility_disabled)
+		start_mt == MIGRATE_UNMOVABLE)
+		return true;
+
+	if (static_branch_unlikely(&page_group_by_mobility_disabled))
 		return true;
 
 	return false;
@@ -1972,7 +1975,7 @@ static void steal_suitable_fallback(stru
 
 	/* Claim the whole block if over half of it is free */
 	if (pages >= (1 << (pageblock_order-1)) ||
-			page_group_by_mobility_disabled)
+	    static_branch_unlikely(&page_group_by_mobility_disabled))
 		set_pageblock_migratetype(page, start_type);
 }
 
@@ -5022,14 +5025,14 @@ void __ref build_all_zonelists(pg_data_t
 	 * disabled and enable it later
 	 */
 	if (vm_total_pages < (pageblock_nr_pages * MIGRATE_TYPES))
-		page_group_by_mobility_disabled = 1;
+		static_branch_enable(&page_group_by_mobility_disabled);
 	else
-		page_group_by_mobility_disabled = 0;
+		static_branch_disable(&page_group_by_mobility_disabled);
 
 	pr_info("Built %i zonelists in %s order, mobility grouping %s.  Total pages: %ld\n",
 		nr_online_nodes,
 		zonelist_order_name[current_zonelist_order],
-		page_group_by_mobility_disabled ? "off" : "on",
+		static_key_enabled(&page_group_by_mobility_disabled) ? "off" : "on",
 		vm_total_pages);
 #ifdef CONFIG_NUMA
 	pr_info("Policy zone: %s\n", zone_names[policy_zone]);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-dont-convert-pfn-to-idx-when-merging.patch
mm-page_alloc-avoid-page_to_pfn-when-merging-buddies.patch
mm-page_alloc-convert-page_group_by_mobility_disable-to-static-key.patch

