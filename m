From: akpm@linux-foundation.org
Subject: + mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch added to -mm tree
Date: Tue, 06 Apr 2010 17:07:27 -0700
Message-ID: <201004070007.o3707Rlo016423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932272Ab0DGAHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 20:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: compaction: do not compact within a preferred zone after a compaction failure
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch

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
Subject: mm: compaction: do not compact within a preferred zone after a compaction failure
From: Mel Gorman <mel@csn.ul.ie>

The fragmentation index may indicate that a failure is due to external
fragmentation but after a compaction run completes, it is still possible
for an allocation to fail.  There are two obvious reasons as to why

  o Page migration cannot move all pages so fragmentation remains
  o A suitable page may exist but watermarks are not met

In the event of compaction followed by an allocation failure, this patch
defers further compaction in the zone for a period of time.  The zone that
is deferred is the first zone in the zonelist - i.e.  the preferred zone. 
To defer compaction in the other zones, the information would need to be
stored in the zonelist or implemented similar to the zonelist_cache.  This
would impact the fast-paths and is not justified at this time.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   35 +++++++++++++++++++++++++++++++++++
 include/linux/mmzone.h     |    7 +++++++
 mm/page_alloc.c            |    5 ++++-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff -puN include/linux/compaction.h~mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure
+++ a/include/linux/compaction.h
@@ -18,6 +18,32 @@ extern int sysctl_extfrag_handler(struct
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask);
+
+/* defer_compaction - Do not compact within a zone until a given time */
+static inline void defer_compaction(struct zone *zone, unsigned long resume)
+{
+	/*
+	 * This function is called when compaction fails to result in a page
+	 * allocation success. This is somewhat unsatisfactory as the failure
+	 * to compact has nothing to do with time and everything to do with
+	 * the requested order, the number of free pages and watermarks. How
+	 * to wait on that is more unclear, but the answer would apply to
+	 * other areas where the VM waits based on time.
+	 */
+	zone->compact_resume = resume;
+}
+
+static inline int compaction_deferred(struct zone *zone)
+{
+	/* init once if necessary */
+	if (unlikely(!zone->compact_resume)) {
+		zone->compact_resume = jiffies;
+		return 0;
+	}
+
+	return time_before(jiffies, zone->compact_resume);
+}
+
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask)
@@ -25,6 +51,15 @@ static inline unsigned long try_to_compa
 	return COMPACT_INCOMPLETE;
 }
 
+static inline void defer_compaction(struct zone *zone, unsigned long resume)
+{
+}
+
+static inline int compaction_deferred(struct zone *zone)
+{
+	return 1;
+}
+
 #endif /* CONFIG_COMPACTION */
 
 #if defined(CONFIG_COMPACTION) && defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
diff -puN include/linux/mmzone.h~mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure
+++ a/include/linux/mmzone.h
@@ -321,6 +321,13 @@ struct zone {
 	unsigned long		*pageblock_flags;
 #endif /* CONFIG_SPARSEMEM */
 
+#ifdef CONFIG_COMPACTION
+	/*
+	 * If a compaction fails, do not try compaction again until
+	 * jiffies is after the value of compact_resume
+	 */
+	unsigned long		compact_resume;
+#endif
 
 	ZONE_PADDING(_pad1_)
 
diff -puN mm/page_alloc.c~mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure
+++ a/mm/page_alloc.c
@@ -1770,7 +1770,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	cond_resched();
 
 	/* Try memory compaction for high-order allocations before reclaim */
-	if (order) {
+	if (order && !compaction_deferred(preferred_zone)) {
 		*did_some_progress = try_to_compact_pages(zonelist,
 						order, gfp_mask, nodemask);
 		if (*did_some_progress != COMPACT_SKIPPED) {
@@ -1795,6 +1795,9 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 			 */
 			count_vm_event(COMPACTFAIL);
 
+			/* On failure, avoid compaction for a short time. */
+			defer_compaction(preferred_zone, jiffies + HZ/50);
+
 			cond_resched();
 		}
 	}
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

