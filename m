Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60362C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiGRASx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiGRARn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822D513D4A
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3139DB80EE7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD667C3411E;
        Mon, 18 Jul 2022 00:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103439;
        bh=91FJjWeJYzH+21Fw8poZ6JLhTgl3V2erP+UW545ePSI=;
        h=Date:To:From:Subject:From;
        b=ylMxlURJtqjCjTjwy+z2EoWyeoUQ4YGDHyYZw4tr39mbzpLdnAMkC2ssdR+cy143E
         Zikj2XGtPRt85kbsBo487Lv3N3piCFJetdSeJgbzgaV8P28vVwX8Z4UDMeT1VzhmU8
         jIHSCANMJrezQGRuU6bqmwPJ9o0uLmZE1AQOBVEk=
Date:   Sun, 17 Jul 2022 17:17:19 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        mtosatti@redhat.com, m.szyprowski@samsung.com, minchan@kernel.org,
        mhocko@kernel.org, mgorman@techsingularity.net, hughd@google.com,
        nsaenzju@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remotely-drain-per-cpu-lists.patch removed from -mm tree
Message-Id: <20220718001719.CD667C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remotely drain per-cpu lists
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remotely-drain-per-cpu-lists.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: mm/page_alloc: remotely drain per-cpu lists
Date: Fri, 24 Jun 2022 13:54:22 +0100

Some setups, notably NOHZ_FULL CPUs, are too busy to handle the per-cpu
drain work queued by __drain_all_pages().  So introduce a new mechanism to
remotely drain the per-cpu lists.  It is made possible by remotely locking
'struct per_cpu_pages' new per-cpu spinlocks.  A benefit of this new
scheme is that drain operations are now migration safe.

There was no observed performance degradation vs.  the previous scheme. 
Both netperf and hackbench were run in parallel to triggering the
__drain_all_pages(NULL, true) code path around ~100 times per second.  The
new scheme performs a bit better (~5%), although the important point here
is there are no performance regressions vs.  the previous mechanism. 
Per-cpu lists draining happens only in slow paths.

Minchan Kim tested an earlier version and reported;

	My workload is not NOHZ CPUs but run apps under heavy memory
	pressure so they goes to direct reclaim and be stuck on
	drain_all_pages until work on workqueue run.

	unit: nanosecond
	max(dur)        avg(dur)                count(dur)
	166713013       487511.77786438033      1283

	From traces, system encountered the drain_all_pages 1283 times and
	worst case was 166ms and avg was 487us.

	The other problem was alloc_contig_range in CMA. The PCP draining
	takes several hundred millisecond sometimes though there is no
	memory pressure or a few of pages to be migrated out but CPU were
	fully booked.

	Your patch perfectly removed those wasted time.

Link: https://lkml.kernel.org/r/20220624125423.6126-7-mgorman@techsingularity.net
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   58 +++-------------------------------------------
 1 file changed, 4 insertions(+), 54 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remotely-drain-per-cpu-lists
+++ a/mm/page_alloc.c
@@ -165,13 +165,7 @@ DEFINE_PER_CPU(int, _numa_mem_);		/* Ker
 EXPORT_PER_CPU_SYMBOL(_numa_mem_);
 #endif
 
-/* work_structs for global per-cpu drains */
-struct pcpu_drain {
-	struct zone *zone;
-	struct work_struct work;
-};
 static DEFINE_MUTEX(pcpu_drain_mutex);
-static DEFINE_PER_CPU(struct pcpu_drain, pcpu_drain);
 
 #ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
 volatile unsigned long latent_entropy __latent_entropy;
@@ -3109,9 +3103,6 @@ static int rmqueue_bulk(struct zone *zon
  * Called from the vmstat counter updater to drain pagesets of this
  * currently executing processor on remote nodes after they have
  * expired.
- *
- * Note that this function must be called with the thread pinned to
- * a single processor.
  */
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
@@ -3136,10 +3127,6 @@ void drain_zone_pages(struct zone *zone,
 
 /*
  * Drain pcplists of the indicated processor and zone.
- *
- * The processor must either be the current processor and the
- * thread pinned to the current processor or a processor that
- * is not online.
  */
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
@@ -3158,10 +3145,6 @@ static void drain_pages_zone(unsigned in
 
 /*
  * Drain pcplists of all zones on the indicated processor.
- *
- * The processor must either be the current processor and the
- * thread pinned to the current processor or a processor that
- * is not online.
  */
 static void drain_pages(unsigned int cpu)
 {
@@ -3174,9 +3157,6 @@ static void drain_pages(unsigned int cpu
 
 /*
  * Spill all of this CPU's per-cpu pages back into the buddy allocator.
- *
- * The CPU has to be pinned. When zone parameter is non-NULL, spill just
- * the single zone's pages.
  */
 void drain_local_pages(struct zone *zone)
 {
@@ -3188,24 +3168,6 @@ void drain_local_pages(struct zone *zone
 		drain_pages(cpu);
 }
 
-static void drain_local_pages_wq(struct work_struct *work)
-{
-	struct pcpu_drain *drain;
-
-	drain = container_of(work, struct pcpu_drain, work);
-
-	/*
-	 * drain_all_pages doesn't use proper cpu hotplug protection so
-	 * we can race with cpu offline when the WQ can move this from
-	 * a cpu pinned worker to an unbound one. We can operate on a different
-	 * cpu which is alright but we also have to make sure to not move to
-	 * a different one.
-	 */
-	migrate_disable();
-	drain_local_pages(drain->zone);
-	migrate_enable();
-}
-
 /*
  * The implementation of drain_all_pages(), exposing an extra parameter to
  * drain on all cpus.
@@ -3227,13 +3189,6 @@ static void __drain_all_pages(struct zon
 	static cpumask_t cpus_with_pcps;
 
 	/*
-	 * Make sure nobody triggers this path before mm_percpu_wq is fully
-	 * initialized.
-	 */
-	if (WARN_ON_ONCE(!mm_percpu_wq))
-		return;
-
-	/*
 	 * Do not drain if one is already in progress unless it's specific to
 	 * a zone. Such callers are primarily CMA and memory hotplug and need
 	 * the drain to be complete when the call returns.
@@ -3282,14 +3237,11 @@ static void __drain_all_pages(struct zon
 	}
 
 	for_each_cpu(cpu, &cpus_with_pcps) {
-		struct pcpu_drain *drain = per_cpu_ptr(&pcpu_drain, cpu);
-
-		drain->zone = zone;
-		INIT_WORK(&drain->work, drain_local_pages_wq);
-		queue_work_on(cpu, mm_percpu_wq, &drain->work);
+		if (zone)
+			drain_pages_zone(cpu, zone);
+		else
+			drain_pages(cpu);
 	}
-	for_each_cpu(cpu, &cpus_with_pcps)
-		flush_work(&per_cpu_ptr(&pcpu_drain, cpu)->work);
 
 	mutex_unlock(&pcpu_drain_mutex);
 }
@@ -3298,8 +3250,6 @@ static void __drain_all_pages(struct zon
  * Spill all the per-cpu pages from all CPUs back into the buddy allocator.
  *
  * When zone parameter is non-NULL, spill just the single zone's pages.
- *
- * Note that this can be extremely slow as the draining happens in a workqueue.
  */
 void drain_all_pages(struct zone *zone)
 {
_

Patches currently in -mm which might be from nsaenzju@redhat.com are


