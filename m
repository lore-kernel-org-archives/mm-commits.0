Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3C1C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47B2561D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhF2Coh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231724AbhF2Cog (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C76D61D0D;
        Tue, 29 Jun 2021 02:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934530;
        bh=2Xms/tdWmIJSs14/XZ1aVvwWQc06r+RP/GqsDz3biyA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=spQtrzwC0KG80H9m0dkHTratpE/dNyaSNRJRdGvzoAW4sKIjAddWY+n25OCAap38i
         hSrRu9HLEImldfiOS+UveHrj+ugcPHk8SMUqsPp8F6whOGvG+TlKQ/KezDBDRJncb9
         0v8nZjhlR7KjqxTLqSdycVDABkOCaJrBgMD0/3dY=
Date:   Mon, 28 Jun 2021 19:42:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave.hansen@linux.intel.com,
        hdanton@sina.com, linux-mm@kvack.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 170/192] mm/page_alloc: delete
 vm.percpu_pagelist_fraction
Message-ID: <20210629024209.-3yLZL8dd%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: delete vm.percpu_pagelist_fraction

Patch series "Calculate pcp->high based on zone sizes and active CPUs", v2.

The per-cpu page allocator (PCP) is meant to reduce contention on the zone
lock but the sizing of batch and high is archaic and neither takes the
zone size into account or the number of CPUs local to a zone.  With larger
zones and more CPUs per node, the contention is getting worse. 
Furthermore, the fact that vm.percpu_pagelist_fraction adjusts both batch
and high values means that the sysctl can reduce zone lock contention but
also increase allocation latencies.

This series disassociates pcp->high from pcp->batch and then scales
pcp->high based on the size of the local zone with limited impact to
reclaim and accounting for active CPUs but leaves pcp->batch static.  It
also adapts the number of pages that can be on the pcp list based on
recent freeing patterns.

The motivation is partially to adjust to larger memory sizes but is also
driven by the fact that large batches of page freeing via release_pages()
often shows zone contention as a major part of the problem.  Another is a
bug report based on an older kernel where a multi-terabyte process can
takes several minutes to exit.  A workaround was to use
vm.percpu_pagelist_fraction to increase the pcp->high value but testing
indicated that a production workload could not use the same values because
of an increase in allocation latencies.  Unfortunately, I cannot reproduce
this test case myself as the multi-terabyte machines are in active use but
it should alleviate the problem.

The series aims to address both and partially acts as a pre-requisite. 
pcp only works with order-0 which is useless for SLUB (when using high
orders) and THP (unconditionally).  To store high-order pages on PCP, the
pcp->high values need to be increased first.


This patch (of 6):

The vm.percpu_pagelist_fraction is used to increase the batch and high
limits for the per-cpu page allocator (PCP).  The intent behind the sysctl
is to reduce zone lock acquisition when allocating/freeing pages but it
has a problem.  While it can decrease contention, it can also increase
latency on the allocation side due to unreasonably large batch sizes. 
This leads to games where an administrator adjusts
percpu_pagelist_fraction on the fly to work around contention and
allocation latency problems.

This series aims to alleviate the problems with zone lock contention while
avoiding the allocation-side latency problems.  For the purposes of
review, it's easier to remove this sysctl now and reintroduce a similar
sysctl later in the series that deals only with pcp->high.

Link: https://lkml.kernel.org/r/20210525080119.5455-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20210525080119.5455-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   19 -------
 include/linux/mmzone.h                  |    3 -
 kernel/sysctl.c                         |    8 ---
 mm/page_alloc.c                         |   55 +---------------------
 4 files changed, 4 insertions(+), 81 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-page_alloc-delete-vmpercpu_pagelist_fraction
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -64,7 +64,6 @@ Currently, these files are in /proc/sys/
 - overcommit_ratio
 - page-cluster
 - panic_on_oom
-- percpu_pagelist_fraction
 - stat_interval
 - stat_refresh
 - numa_stat
@@ -790,24 +789,6 @@ panic_on_oom=2+kdump gives you very stro
 why oom happens. You can get snapshot.
 
 
-percpu_pagelist_fraction
-========================
-
-This is the fraction of pages at most (high mark pcp->high) in each zone that
-are allocated for each per cpu page list.  The min value for this is 8.  It
-means that we don't allow more than 1/8th of pages in each zone to be
-allocated in any single per_cpu_pagelist.  This entry only changes the value
-of hot per cpu pagelists.  User can specify a number like 100 to allocate
-1/100th of each zone to each per cpu page list.
-
-The batch value of each per cpu pagelist is also updated as a result.  It is
-set to pcp->high/4.  The upper limit of batch is (PAGE_SHIFT * 8)
-
-The initial value is zero.  Kernel does not use this value at boot time to set
-the high water marks for each per cpu page list.  If the user writes '0' to this
-sysctl, it will revert to this default behavior.
-
-
 stat_interval
 =============
 
--- a/include/linux/mmzone.h~mm-page_alloc-delete-vmpercpu_pagelist_fraction
+++ a/include/linux/mmzone.h
@@ -1027,15 +1027,12 @@ int watermark_scale_factor_sysctl_handle
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int, void *,
 		size_t *, loff_t *);
-int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *, int,
-		void *, size_t *, loff_t *);
 int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *, int,
 		void *, size_t *, loff_t *);
 int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *, int,
 		void *, size_t *, loff_t *);
 int numa_zonelist_order_handler(struct ctl_table *, int,
 		void *, size_t *, loff_t *);
-extern int percpu_pagelist_fraction;
 extern char numa_zonelist_order[];
 #define NUMA_ZONELIST_ORDER_LEN	16
 
--- a/kernel/sysctl.c~mm-page_alloc-delete-vmpercpu_pagelist_fraction
+++ a/kernel/sysctl.c
@@ -2909,14 +2909,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one_thousand,
 	},
 	{
-		.procname	= "percpu_pagelist_fraction",
-		.data		= &percpu_pagelist_fraction,
-		.maxlen		= sizeof(percpu_pagelist_fraction),
-		.mode		= 0644,
-		.proc_handler	= percpu_pagelist_fraction_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
 		.procname	= "page_lock_unfairness",
 		.data		= &sysctl_page_lock_unfairness,
 		.maxlen		= sizeof(sysctl_page_lock_unfairness),
--- a/mm/page_alloc.c~mm-page_alloc-delete-vmpercpu_pagelist_fraction
+++ a/mm/page_alloc.c
@@ -120,7 +120,6 @@ typedef int __bitwise fpi_t;
 
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
-#define MIN_PERCPU_PAGELIST_FRACTION	(8)
 
 struct pagesets {
 	local_lock_t lock;
@@ -193,7 +192,6 @@ EXPORT_SYMBOL(_totalram_pages);
 unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
 
-int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 EXPORT_SYMBOL(init_on_alloc);
@@ -6735,22 +6733,15 @@ static void __zone_set_pageset_high_and_
 
 /*
  * Calculate and set new high and batch values for all per-cpu pagesets of a
- * zone, based on the zone's size and the percpu_pagelist_fraction sysctl.
+ * zone based on the zone's size.
  */
 static void zone_set_pageset_high_and_batch(struct zone *zone)
 {
 	unsigned long new_high, new_batch;
 
-	if (percpu_pagelist_fraction) {
-		new_high = zone_managed_pages(zone) / percpu_pagelist_fraction;
-		new_batch = max(1UL, new_high / 4);
-		if ((new_high / 4) > (PAGE_SHIFT * 8))
-			new_batch = PAGE_SHIFT * 8;
-	} else {
-		new_batch = zone_batchsize(zone);
-		new_high = 6 * new_batch;
-		new_batch = max(1UL, 1 * new_batch);
-	}
+	new_batch = zone_batchsize(zone);
+	new_high = 6 * new_batch;
+	new_batch = max(1UL, 1 * new_batch);
 
 	if (zone->pageset_high == new_high &&
 	    zone->pageset_batch == new_batch)
@@ -8413,44 +8404,6 @@ int lowmem_reserve_ratio_sysctl_handler(
 	return 0;
 }
 
-/*
- * percpu_pagelist_fraction - changes the pcp->high for each zone on each
- * cpu.  It is the fraction of total pages in each zone that a hot per cpu
- * pagelist can have before it gets flushed back to buddy allocator.
- */
-int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *table, int write,
-		void *buffer, size_t *length, loff_t *ppos)
-{
-	struct zone *zone;
-	int old_percpu_pagelist_fraction;
-	int ret;
-
-	mutex_lock(&pcp_batch_high_lock);
-	old_percpu_pagelist_fraction = percpu_pagelist_fraction;
-
-	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (!write || ret < 0)
-		goto out;
-
-	/* Sanity checking to avoid pcp imbalance */
-	if (percpu_pagelist_fraction &&
-	    percpu_pagelist_fraction < MIN_PERCPU_PAGELIST_FRACTION) {
-		percpu_pagelist_fraction = old_percpu_pagelist_fraction;
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* No change? */
-	if (percpu_pagelist_fraction == old_percpu_pagelist_fraction)
-		goto out;
-
-	for_each_populated_zone(zone)
-		zone_set_pageset_high_and_batch(zone);
-out:
-	mutex_unlock(&pcp_batch_high_lock);
-	return ret;
-}
-
 #ifndef __HAVE_ARCH_RESERVED_KERNEL_PAGES
 /*
  * Returns the number of pages that arch has reserved but
_
