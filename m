Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CB8C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 19:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348384AbiFMTFX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346301AbiFMTET (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 15:04:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CA3106A49
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 09:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FD9861034
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 16:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97871C34114;
        Mon, 13 Jun 2022 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655139278;
        bh=2xY/uChMRitTzxVb6TkgDVDhAPbDwRpIl2dD7VhjXEo=;
        h=Date:To:From:Subject:From;
        b=OLX7YebCt4jlGvhS1VL0JckmeHBgQE3hqqSq734oi6C7SL27NtB5mKYJ9kJ682Ru8
         3s2T7RG+dW0/cMHTjFDt1YjEiyQZvo7hYQLQSri6CaTz1JWmKZ47BjvQb5B1+pj3+I
         sblNxiSG+8b+UGRdHHQsBjvhtH92iipSTR5rEp1c=
Date:   Mon, 13 Jun 2022 09:54:38 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mtosatti@redhat.com,
        minchan@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net,
        hughd@google.com, nsaenzju@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remotely-drain-per-cpu-lists.patch added to mm-unstable branch
Message-Id: <20220613165438.97871C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remotely drain per-cpu lists
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remotely-drain-per-cpu-lists.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remotely-drain-per-cpu-lists.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: mm/page_alloc: remotely drain per-cpu lists
Date: Mon, 13 Jun 2022 13:56:21 +0100

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

Minchan Kim tested this independently and reported;

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

Link: https://lkml.kernel.org/r/20220613125622.18628-7-mgorman@techsingularity.net
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -3101,9 +3095,6 @@ static int rmqueue_bulk(struct zone *zon
  * Called from the vmstat counter updater to drain pagesets of this
  * currently executing processor on remote nodes after they have
  * expired.
- *
- * Note that this function must be called with the thread pinned to
- * a single processor.
  */
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
@@ -3128,10 +3119,6 @@ void drain_zone_pages(struct zone *zone,
 
 /*
  * Drain pcplists of the indicated processor and zone.
- *
- * The processor must either be the current processor and the
- * thread pinned to the current processor or a processor that
- * is not online.
  */
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
@@ -3150,10 +3137,6 @@ static void drain_pages_zone(unsigned in
 
 /*
  * Drain pcplists of all zones on the indicated processor.
- *
- * The processor must either be the current processor and the
- * thread pinned to the current processor or a processor that
- * is not online.
  */
 static void drain_pages(unsigned int cpu)
 {
@@ -3166,9 +3149,6 @@ static void drain_pages(unsigned int cpu
 
 /*
  * Spill all of this CPU's per-cpu pages back into the buddy allocator.
- *
- * The CPU has to be pinned. When zone parameter is non-NULL, spill just
- * the single zone's pages.
  */
 void drain_local_pages(struct zone *zone)
 {
@@ -3180,24 +3160,6 @@ void drain_local_pages(struct zone *zone
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
@@ -3219,13 +3181,6 @@ static void __drain_all_pages(struct zon
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
@@ -3274,14 +3229,11 @@ static void __drain_all_pages(struct zon
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
@@ -3290,8 +3242,6 @@ static void __drain_all_pages(struct zon
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

mm-page_alloc-remotely-drain-per-cpu-lists.patch

