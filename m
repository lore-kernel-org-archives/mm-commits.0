Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1B8C61DA3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 22:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbjCCWhf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 17:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbjCCWhU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 17:37:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156352ED64
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 14:35:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B121761921
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 22:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1118CC433A0;
        Fri,  3 Mar 2023 22:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677882744;
        bh=9kFdkfBVeb97ahm4Cfg4kvI6Si/ugYRzCZX6vQNsL6k=;
        h=Date:To:From:Subject:From;
        b=Gbfuviqbq0UBNpabZnCPXQvoYHzNH+fsE+G8ZOVks8DSmAQWIeBVAYo0XFxRk6ibe
         kZDIeK9/STIM2rz+WDfx14I3HyD3hyPcppJrYgDQrFTCN2fYusDzRGlGf9sl9qTUrV
         bVKIVmkpodto3N3kR8HSYXpR384dbX+i8DFnSdoY=
Date:   Fri, 03 Mar 2023 14:32:23 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, peterx@redhat.com,
        mingo@elte.hu, linux@armlinux.org.uk, hpa@zytor.com,
        hca@linux.ibm.com, frederic@kernel.org, david@redhat.com,
        cl@linux.com, chenhuacai@kernel.org, atomlin@atomlin.com,
        mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-remove-remote-node-draining.patch added to mm-unstable branch
Message-Id: <20230303223224.1118CC433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: remove remote node draining
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-remove-remote-node-draining.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-remove-remote-node-draining.patch

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
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: mm/vmstat: remove remote node draining
Date: Fri, 03 Mar 2023 16:58:42 -0300

Patch series "fold per-CPU vmstats remotely", v3.

This patch series addresses the following two problems:

    1. A customer provided some evidence which indicates that
       the idle tick was stopped; albeit, CPU-specific vmstat
       counters still remained populated.

       Thus one can only assume quiet_vmstat() was not
       invoked on return to the idle loop. If I understand
       correctly, I suspect this divergence might erroneously
       prevent a reclaim attempt by kswapd. If the number of
       zone specific free pages are below their per-cpu drift
       value then zone_page_state_snapshot() is used to
       compute a more accurate view of the aforementioned
       statistic.  Thus any task blocked on the NUMA node
       specific pfmemalloc_wait queue will be unable to make
       significant progress via direct reclaim unless it is
       killed after being woken up by kswapd
       (see throttle_direct_reclaim())

    2. With a SCHED_FIFO task that busy loops on a given CPU,
       and kworker for that CPU at SCHED_OTHER priority,
       queuing work to sync per-vmstats will either cause that
       work to never execute, or stalld (i.e. stall daemon)
       boosts kworker priority which causes a latency
       violation

By having vmstat_shepherd flush the per-CPU counters to the global
counters from remote CPUs.

This is done using cmpxchg to manipulate the counters, both CPU locally
(via the account functions), and remotely (via cpu_vm_stats_fold).

Thanks to Aaron Tomlin for diagnosing issue 1 and writing the initial
patch series.


This patch (of 3):

Draining of pages from the local pcp for a remote zone should not be
necessary, since once the system is low on memory (or compaction on a
zone is in effect), drain_all_pages should be called freeing any unused
pcps.

For reference, the original commit which introduces remote node
draining is 4037d452202e34214e8a939fa5621b2b3bbb45b7.

Link: https://lkml.kernel.org/r/20230303195841.310844446@redhat.com
Link: https://lkml.kernel.org/r/20230303195908.774798959@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mmzone.h~mm-vmstat-remove-remote-node-draining
+++ a/include/linux/mmzone.h
@@ -679,9 +679,6 @@ struct per_cpu_pages {
 	int high;		/* high watermark, emptying needed */
 	int batch;		/* chunk size for buddy add/remove */
 	short free_factor;	/* batch scaling factor during free */
-#ifdef CONFIG_NUMA
-	short expire;		/* When 0, remote pagesets are drained */
-#endif
 
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
 	struct list_head lists[NR_PCP_LISTS];
--- a/mm/page_alloc.c~mm-vmstat-remove-remote-node-draining
+++ a/mm/page_alloc.c
@@ -3107,26 +3107,6 @@ static int rmqueue_bulk(struct zone *zon
 	return i;
 }
 
-#ifdef CONFIG_NUMA
-/*
- * Called from the vmstat counter updater to drain pagesets of this
- * currently executing processor on remote nodes after they have
- * expired.
- */
-void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
-{
-	int to_drain, batch;
-
-	batch = READ_ONCE(pcp->batch);
-	to_drain = min(pcp->count, batch);
-	if (to_drain > 0) {
-		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
-		spin_unlock(&pcp->lock);
-	}
-}
-#endif
-
 /*
  * Drain pcplists of the indicated processor and zone.
  */
--- a/mm/vmstat.c~mm-vmstat-remove-remote-node-draining
+++ a/mm/vmstat.c
@@ -803,20 +803,16 @@ static int fold_diff(int *zone_diff, int
  *
  * The function returns the number of global counters updated.
  */
-static int refresh_cpu_vm_stats(bool do_pagesets)
+static int refresh_cpu_vm_stats(void)
 {
 	struct pglist_data *pgdat;
 	struct zone *zone;
 	int i;
 	int global_zone_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
 	int global_node_diff[NR_VM_NODE_STAT_ITEMS] = { 0, };
-	int changes = 0;
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
-#ifdef CONFIG_NUMA
-		struct per_cpu_pages __percpu *pcp = zone->per_cpu_pageset;
-#endif
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 			int v;
@@ -826,44 +822,8 @@ static int refresh_cpu_vm_stats(bool do_
 
 				atomic_long_add(v, &zone->vm_stat[i]);
 				global_zone_diff[i] += v;
-#ifdef CONFIG_NUMA
-				/* 3 seconds idle till flush */
-				__this_cpu_write(pcp->expire, 3);
-#endif
 			}
 		}
-#ifdef CONFIG_NUMA
-
-		if (do_pagesets) {
-			cond_resched();
-			/*
-			 * Deal with draining the remote pageset of this
-			 * processor
-			 *
-			 * Check if there are pages remaining in this pageset
-			 * if not then there is nothing to expire.
-			 */
-			if (!__this_cpu_read(pcp->expire) ||
-			       !__this_cpu_read(pcp->count))
-				continue;
-
-			/*
-			 * We never drain zones local to this processor.
-			 */
-			if (zone_to_nid(zone) == numa_node_id()) {
-				__this_cpu_write(pcp->expire, 0);
-				continue;
-			}
-
-			if (__this_cpu_dec_return(pcp->expire))
-				continue;
-
-			if (__this_cpu_read(pcp->count)) {
-				drain_zone_pages(zone, this_cpu_ptr(pcp));
-				changes++;
-			}
-		}
-#endif
 	}
 
 	for_each_online_pgdat(pgdat) {
@@ -880,8 +840,7 @@ static int refresh_cpu_vm_stats(bool do_
 		}
 	}
 
-	changes += fold_diff(global_zone_diff, global_node_diff);
-	return changes;
+	return fold_diff(global_zone_diff, global_node_diff);
 }
 
 /*
@@ -1873,7 +1832,7 @@ int sysctl_stat_interval __read_mostly =
 #ifdef CONFIG_PROC_FS
 static void refresh_vm_stats(struct work_struct *work)
 {
-	refresh_cpu_vm_stats(true);
+	refresh_cpu_vm_stats();
 }
 
 int vmstat_refresh(struct ctl_table *table, int write,
@@ -1883,6 +1842,8 @@ int vmstat_refresh(struct ctl_table *tab
 	int err;
 	int i;
 
+	drain_all_pages(NULL);
+
 	/*
 	 * The regular update, every sysctl_stat_interval, may come later
 	 * than expected: leaving a significant amount in per_cpu buckets.
@@ -1937,7 +1898,7 @@ int vmstat_refresh(struct ctl_table *tab
 
 static void vmstat_update(struct work_struct *w)
 {
-	if (refresh_cpu_vm_stats(true)) {
+	if (refresh_cpu_vm_stats()) {
 		/*
 		 * Counters were updated so we expect more updates
 		 * to occur in the future. Keep on running the
@@ -2000,7 +1961,7 @@ void quiet_vmstat(void)
 	 * it would be too expensive from this path.
 	 * vmstat_shepherd will take care about that for us.
 	 */
-	refresh_cpu_vm_stats(false);
+	refresh_cpu_vm_stats();
 }
 
 /*
_

Patches currently in -mm which might be from mtosatti@redhat.com are

mm-vmstat-remove-remote-node-draining.patch
this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch

