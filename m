From: akpm@linux-foundation.org
Subject: [merged] mm-reduce-try_to_compact_pages-parameters.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:36:38 -0800
Message-ID: <54dd00c6.uV29yOPSWVZ/Y2L/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbbBLTgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reduce try_to_compact_pages parameters
has been removed from the -mm tree.  Its filename was
     mm-reduce-try_to_compact_pages-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: reduce try_to_compact_pages parameters

Expand the usage of the struct alloc_context introduced in the previous
patch also for calling try_to_compact_pages(), to reduce the number of its
parameters.  Since the function is in different compilation unit, we need
to move alloc_context definition in the shared mm/internal.h header.

With this change we get simpler code and small savings of code size and stack
usage:

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-27 (-27)
function                                     old     new   delta
__alloc_pages_direct_compact                 283     256     -27
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-13 (-13)
function                                     old     new   delta
try_to_compact_pages                         582     569     -13

Stack usage of __alloc_pages_direct_compact goes from 24 to none (per
scripts/checkstack.pl).

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   17 +++++++++--------
 mm/compaction.c            |   23 +++++++++++------------
 mm/internal.h              |   22 ++++++++++++++++++++++
 mm/page_alloc.c            |   27 ++-------------------------
 4 files changed, 44 insertions(+), 45 deletions(-)

diff -puN include/linux/compaction.h~mm-reduce-try_to_compact_pages-parameters include/linux/compaction.h
--- a/include/linux/compaction.h~mm-reduce-try_to_compact_pages-parameters
+++ a/include/linux/compaction.h
@@ -21,6 +21,8 @@
 /* Zone lock or lru_lock was contended in async compaction */
 #define COMPACT_CONTENDED_LOCK	2
 
+struct alloc_context; /* in mm/internal.h */
+
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
@@ -30,10 +32,9 @@ extern int sysctl_extfrag_handler(struct
 			void __user *buffer, size_t *length, loff_t *ppos);
 
 extern int fragmentation_index(struct zone *zone, unsigned int order);
-extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
-			int order, gfp_t gfp_mask, nodemask_t *mask,
-			enum migrate_mode mode, int *contended,
-			int alloc_flags, int classzone_idx);
+extern unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
+			int alloc_flags, const struct alloc_context *ac,
+			enum migrate_mode mode, int *contended);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order,
@@ -101,10 +102,10 @@ static inline bool compaction_restarting
 }
 
 #else
-static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
-			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			enum migrate_mode mode, int *contended,
-			int alloc_flags, int classzone_idx)
+static inline unsigned long try_to_compact_pages(gfp_t gfp_mask,
+			unsigned int order, int alloc_flags,
+			const struct alloc_context *ac,
+			enum migrate_mode mode, int *contended)
 {
 	return COMPACT_CONTINUE;
 }
diff -puN mm/compaction.c~mm-reduce-try_to_compact_pages-parameters mm/compaction.c
--- a/mm/compaction.c~mm-reduce-try_to_compact_pages-parameters
+++ a/mm/compaction.c
@@ -1335,22 +1335,20 @@ int sysctl_extfrag_threshold = 500;
 
 /**
  * try_to_compact_pages - Direct compact to satisfy a high-order allocation
- * @zonelist: The zonelist used for the current allocation
- * @order: The order of the current allocation
  * @gfp_mask: The GFP mask of the current allocation
- * @nodemask: The allowed nodes to allocate from
+ * @order: The order of the current allocation
+ * @alloc_flags: The allocation flags of the current allocation
+ * @ac: The context of current allocation
  * @mode: The migration mode for async, sync light, or sync migration
  * @contended: Return value that determines if compaction was aborted due to
  *	       need_resched() or lock contention
  *
  * This is the main entry point for direct page compaction.
  */
-unsigned long try_to_compact_pages(struct zonelist *zonelist,
-			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			enum migrate_mode mode, int *contended,
-			int alloc_flags, int classzone_idx)
+unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
+			int alloc_flags, const struct alloc_context *ac,
+			enum migrate_mode mode, int *contended)
 {
-	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	int may_enter_fs = gfp_mask & __GFP_FS;
 	int may_perform_io = gfp_mask & __GFP_IO;
 	struct zoneref *z;
@@ -1365,8 +1363,8 @@ unsigned long try_to_compact_pages(struc
 		return COMPACT_SKIPPED;
 
 	/* Compact each zone in the list */
-	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
-								nodemask) {
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
+								ac->nodemask) {
 		int status;
 		int zone_contended;
 
@@ -1374,7 +1372,8 @@ unsigned long try_to_compact_pages(struc
 			continue;
 
 		status = compact_zone_order(zone, order, gfp_mask, mode,
-				&zone_contended, alloc_flags, classzone_idx);
+				&zone_contended, alloc_flags,
+				ac->classzone_idx);
 		rc = max(status, rc);
 		/*
 		 * It takes at least one zone that wasn't lock contended
@@ -1384,7 +1383,7 @@ unsigned long try_to_compact_pages(struc
 
 		/* If a normal allocation would succeed, stop compacting */
 		if (zone_watermark_ok(zone, order, low_wmark_pages(zone),
-					classzone_idx, alloc_flags)) {
+					ac->classzone_idx, alloc_flags)) {
 			/*
 			 * We think the allocation will succeed in this zone,
 			 * but it is not certain, hence the false. The caller
diff -puN mm/internal.h~mm-reduce-try_to_compact_pages-parameters mm/internal.h
--- a/mm/internal.h~mm-reduce-try_to_compact_pages-parameters
+++ a/mm/internal.h
@@ -110,6 +110,28 @@ extern pmd_t *mm_find_pmd(struct mm_stru
  */
 
 /*
+ * Structure for holding the mostly immutable allocation parameters passed
+ * between functions involved in allocations, including the alloc_pages*
+ * family of functions.
+ *
+ * nodemask, migratetype and high_zoneidx are initialized only once in
+ * __alloc_pages_nodemask() and then never change.
+ *
+ * zonelist, preferred_zone and classzone_idx are set first in
+ * __alloc_pages_nodemask() for the fast path, and might be later changed
+ * in __alloc_pages_slowpath(). All other functions pass the whole strucure
+ * by a const pointer.
+ */
+struct alloc_context {
+	struct zonelist *zonelist;
+	nodemask_t *nodemask;
+	struct zone *preferred_zone;
+	int classzone_idx;
+	int migratetype;
+	enum zone_type high_zoneidx;
+};
+
+/*
  * Locate the struct page for both the matching buddy in our
  * pair (buddy1) and the combined O(n+1) page they form (page).
  *
diff -puN mm/page_alloc.c~mm-reduce-try_to_compact_pages-parameters mm/page_alloc.c
--- a/mm/page_alloc.c~mm-reduce-try_to_compact_pages-parameters
+++ a/mm/page_alloc.c
@@ -232,27 +232,6 @@ EXPORT_SYMBOL(nr_node_ids);
 EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
-/*
- * Structure for holding the mostly immutable allocation parameters passed
- * between alloc_pages* family of functions.
- *
- * nodemask, migratetype and high_zoneidx are initialized only once in
- * __alloc_pages_nodemask() and then never change.
- *
- * zonelist, preferred_zone and classzone_idx are set first in
- * __alloc_pages_nodemask() for the fast path, and might be later changed
- * in __alloc_pages_slowpath(). All other functions pass the whole strucure
- * by a const pointer.
- */
-struct alloc_context {
-	struct zonelist *zonelist;
-	nodemask_t *nodemask;
-	struct zone *preferred_zone;
-	int classzone_idx;
-	int migratetype;
-	enum zone_type high_zoneidx;
-};
-
 int page_group_by_mobility_disabled __read_mostly;
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
@@ -2429,10 +2408,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		return NULL;
 
 	current->flags |= PF_MEMALLOC;
-	compact_result = try_to_compact_pages(ac->zonelist, order, gfp_mask,
-						ac->nodemask, mode,
-						contended_compaction,
-						alloc_flags, ac->classzone_idx);
+	compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
+						mode, contended_compaction);
 	current->flags &= ~PF_MEMALLOC;
 
 	switch (compact_result) {
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
mm-fix-negative-nr_isolated-counts.patch
zram-fix-umount-reset_store-mount-race-condition.patch

