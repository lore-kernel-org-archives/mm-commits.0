From: akpm@linux-foundation.org
Subject: + mm-use-unsigned-types-for-fragmentation-score.patch added
 to -mm tree
Date: Sat, 20 Jun 2020 19:25:14 -0700
Message-ID: <20200621022514.0niab%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgFUCZQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 22:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yzaikin@google.com, vbabka@suse.cz, mcgrof@kernel.org, keescook@chromium.org, iamjoonsoo.kim@lge.com, bhe@redhat.com, nigupta@nvidia.com


The patch titled
     Subject: mm: use unsigned types for fragmentation score
has been added to the -mm tree.  Its filename is
     mm-use-unsigned-types-for-fragmentation-score.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-unsigned-types-for-fragmentation-score.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-unsigned-types-for-fragmentation-score.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nitin Gupta <nigupta@nvidia.com>
Subject: mm: use unsigned types for fragmentation score

Proactive compaction uses per-node/zone "fragmentation score" which is
always in range [0, 100], so use unsigned type of these scores as well as
for related constants.

Link: http://lkml.kernel.org/r/20200618010319.13159-1-nigupta@nvidia.com
Signed-off-by: Nitin Gupta <nigupta@nvidia.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 ++--
 kernel/sysctl.c            |    2 +-
 mm/compaction.c            |   18 +++++++++---------
 mm/vmstat.c                |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

--- a/include/linux/compaction.h~mm-use-unsigned-types-for-fragmentation-score
+++ a/include/linux/compaction.h
@@ -85,13 +85,13 @@ static inline unsigned long compact_gap(
 
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
-extern int sysctl_compaction_proactiveness;
+extern unsigned int sysctl_compaction_proactiveness;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void *buffer, size_t *length, loff_t *ppos);
 extern int sysctl_extfrag_threshold;
 extern int sysctl_compact_unevictable_allowed;
 
-extern int extfrag_for_order(struct zone *zone, unsigned int order);
+extern unsigned int extfrag_for_order(struct zone *zone, unsigned int order);
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 		unsigned int order, unsigned int alloc_flags,
--- a/kernel/sysctl.c~mm-use-unsigned-types-for-fragmentation-score
+++ a/kernel/sysctl.c
@@ -2833,7 +2833,7 @@ static struct ctl_table vm_table[] = {
 	{
 		.procname	= "compaction_proactiveness",
 		.data		= &sysctl_compaction_proactiveness,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(sysctl_compaction_proactiveness),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
--- a/mm/compaction.c~mm-use-unsigned-types-for-fragmentation-score
+++ a/mm/compaction.c
@@ -53,7 +53,7 @@ static inline void count_compact_events(
 /*
  * Fragmentation score check interval for proactive compaction purposes.
  */
-static const int HPAGE_FRAG_CHECK_INTERVAL_MSEC = 500;
+static const unsigned int HPAGE_FRAG_CHECK_INTERVAL_MSEC = 500;
 
 /*
  * Page order with-respect-to which proactive compaction
@@ -1890,7 +1890,7 @@ static bool kswapd_is_running(pg_data_t
  * ZONE_DMA32. For smaller zones, the score value remains close to zero,
  * and thus never exceeds the high threshold for proactive compaction.
  */
-static int fragmentation_score_zone(struct zone *zone)
+static unsigned int fragmentation_score_zone(struct zone *zone)
 {
 	unsigned long score;
 
@@ -1906,9 +1906,9 @@ static int fragmentation_score_zone(stru
  * the node's score falls below the low threshold, or one of the back-off
  * conditions is met.
  */
-static int fragmentation_score_node(pg_data_t *pgdat)
+static unsigned int fragmentation_score_node(pg_data_t *pgdat)
 {
-	unsigned long score = 0;
+	unsigned int score = 0;
 	int zoneid;
 
 	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
@@ -1921,17 +1921,17 @@ static int fragmentation_score_node(pg_d
 	return score;
 }
 
-static int fragmentation_score_wmark(pg_data_t *pgdat, bool low)
+static unsigned int fragmentation_score_wmark(pg_data_t *pgdat, bool low)
 {
-	int wmark_low;
+	unsigned int wmark_low;
 
 	/*
 	 * Cap the low watermak to avoid excessive compaction
 	 * activity in case a user sets the proactivess tunable
 	 * close to 100 (maximum).
 	 */
-	wmark_low = max(100 - sysctl_compaction_proactiveness, 5);
-	return low ? wmark_low : min(wmark_low + 10, 100);
+	wmark_low = max(100U - sysctl_compaction_proactiveness, 5U);
+	return low ? wmark_low : min(wmark_low + 10, 100U);
 }
 
 static bool should_proactive_compact_node(pg_data_t *pgdat)
@@ -2615,7 +2615,7 @@ int sysctl_compact_memory;
  * aggressively the kernel should compact memory in the
  * background. It takes values in the range [0, 100].
  */
-int __read_mostly sysctl_compaction_proactiveness = 20;
+unsigned int __read_mostly sysctl_compaction_proactiveness = 20;
 
 /*
  * This is the entry point for compacting all nodes via
--- a/mm/vmstat.c~mm-use-unsigned-types-for-fragmentation-score
+++ a/mm/vmstat.c
@@ -1101,7 +1101,7 @@ static int __fragmentation_index(unsigne
  * It is defined as the percentage of pages found in blocks of size
  * less than 1 << order. It returns values in range [0, 100].
  */
-int extfrag_for_order(struct zone *zone, unsigned int order)
+unsigned int extfrag_for_order(struct zone *zone, unsigned int order)
 {
 	struct contig_page_info info;
 
_

Patches currently in -mm which might be from nigupta@nvidia.com are

mm-proactive-compaction.patch
mm-use-unsigned-types-for-fragmentation-score.patch
