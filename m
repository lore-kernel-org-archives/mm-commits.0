Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D331C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3512660FDB
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhGFTRt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231755AbhGFTRt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DBC860C3D;
        Tue,  6 Jul 2021 19:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598909;
        bh=ALXpyBSFFovhQfY02aGegVeKd4b/ufTuA2ZxSesyP5Y=;
        h=Date:From:To:Subject:From;
        b=gwjaXswnahysipgkF4abU53mNFthBNpP0IAZAZ3cLyxDGuwUAYHQlJOtZCEqoj0rM
         bQ6NhJ4YVozq4D0TL0v9RnlV5o/2oBZpD2zB/c6m3Et+nq88Dt9eE/xXr3LPZ5qmWc
         0Ude4vxDifk76kCyFMYqZWR1XTLqQ+s7ojiQbtNE=
Date:   Tue, 06 Jul 2021 12:15:09 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch removed from
 -mm tree
Message-ID: <20210706191509.EWAXqWVRC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: introduce vm.percpu_pagelist_high_fraction
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: introduce vm.percpu_pagelist_high_fraction

This introduces a new sysctl vm.percpu_pagelist_high_fraction.  It is
similar to the old vm.percpu_pagelist_fraction.  The old sysctl increased
both pcp->batch and pcp->high with the higher pcp->high potentially
reducing zone->lock contention.  However, the higher pcp->batch value also
potentially increased allocation latency while the PCP was refilled.  This
sysctl only adjusts pcp->high so that zone->lock contention is potentially
reduced but allocation latency during a PCP refill remains the same.

  # grep -E "high:|batch" /proc/zoneinfo | tail -2
              high:  649
              batch: 63

  # sysctl vm.percpu_pagelist_high_fraction=8
  # grep -E "high:|batch" /proc/zoneinfo | tail -2
              high:  35071
              batch: 63

  # sysctl vm.percpu_pagelist_high_fraction=64
              high:  4383
              batch: 63

  # sysctl vm.percpu_pagelist_high_fraction=0
              high:  649
              batch: 63

[mgorman@techsingularity.net: fix documentation]
  Link: https://lkml.kernel.org/r/20210528151010.GQ30378@techsingularity.net
Link: https://lkml.kernel.org/r/20210525080119.5455-7-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   21 ++++++
 include/linux/mmzone.h                  |    3 
 kernel/sysctl.c                         |    8 ++
 mm/page_alloc.c                         |   69 +++++++++++++++++++---
 4 files changed, 94 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -64,6 +64,7 @@ Currently, these files are in /proc/sys/
 - overcommit_ratio
 - page-cluster
 - panic_on_oom
+- percpu_pagelist_high_fraction
 - stat_interval
 - stat_refresh
 - numa_stat
@@ -789,6 +790,26 @@ panic_on_oom=2+kdump gives you very stro
 why oom happens. You can get snapshot.
 
 
+percpu_pagelist_high_fraction
+=============================
+
+This is the fraction of pages in each zone that are can be stored to
+per-cpu page lists. It is an upper boundary that is divided depending
+on the number of online CPUs. The min value for this is 8 which means
+that we do not allow more than 1/8th of pages in each zone to be stored
+on per-cpu page lists. This entry only changes the value of hot per-cpu
+page lists. A user can specify a number like 100 to allocate 1/100th of
+each zone between per-cpu lists.
+
+The batch value of each per-cpu page list remains the same regardless of
+the value of the high fraction so allocation latencies are unaffected.
+
+The initial value is zero. Kernel uses this value to set the high pcp->high
+mark based on the low watermark for the zone and the number of local
+online CPUs.  If the user writes '0' to this sysctl, it will revert to
+this default behavior.
+
+
 stat_interval
 =============
 
--- a/include/linux/mmzone.h~mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction
+++ a/include/linux/mmzone.h
@@ -1029,12 +1029,15 @@ int watermark_scale_factor_sysctl_handle
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int, void *,
 		size_t *, loff_t *);
+int percpu_pagelist_high_fraction_sysctl_handler(struct ctl_table *, int,
+		void *, size_t *, loff_t *);
 int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *, int,
 		void *, size_t *, loff_t *);
 int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *, int,
 		void *, size_t *, loff_t *);
 int numa_zonelist_order_handler(struct ctl_table *, int,
 		void *, size_t *, loff_t *);
+extern int percpu_pagelist_high_fraction;
 extern char numa_zonelist_order[];
 #define NUMA_ZONELIST_ORDER_LEN	16
 
--- a/kernel/sysctl.c~mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction
+++ a/kernel/sysctl.c
@@ -2909,6 +2909,14 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one_thousand,
 	},
 	{
+		.procname	= "percpu_pagelist_high_fraction",
+		.data		= &percpu_pagelist_high_fraction,
+		.maxlen		= sizeof(percpu_pagelist_high_fraction),
+		.mode		= 0644,
+		.proc_handler	= percpu_pagelist_high_fraction_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
 		.procname	= "page_lock_unfairness",
 		.data		= &sysctl_page_lock_unfairness,
 		.maxlen		= sizeof(sysctl_page_lock_unfairness),
--- a/mm/page_alloc.c~mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction
+++ a/mm/page_alloc.c
@@ -120,6 +120,7 @@ typedef int __bitwise fpi_t;
 
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
+#define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
 
 struct pagesets {
 	local_lock_t lock;
@@ -192,6 +193,7 @@ EXPORT_SYMBOL(_totalram_pages);
 unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
 
+int percpu_pagelist_high_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 EXPORT_SYMBOL(init_on_alloc);
@@ -6725,17 +6727,32 @@ static int zone_highsize(struct zone *zo
 #ifdef CONFIG_MMU
 	int high;
 	int nr_local_cpus;
+	unsigned long total_pages;
+
+	if (!percpu_pagelist_high_fraction) {
+		/*
+		 * By default, the high value of the pcp is based on the zone
+		 * low watermark so that if they are full then background
+		 * reclaim will not be started prematurely.
+		 */
+		total_pages = low_wmark_pages(zone);
+	} else {
+		/*
+		 * If percpu_pagelist_high_fraction is configured, the high
+		 * value is based on a fraction of the managed pages in the
+		 * zone.
+		 */
+		total_pages = zone_managed_pages(zone) / percpu_pagelist_high_fraction;
+	}
 
 	/*
-	 * The high value of the pcp is based on the zone low watermark
-	 * so that if they are full then background reclaim will not be
-	 * started prematurely. The value is split across all online CPUs
-	 * local to the zone. Note that early in boot that CPUs may not be
-	 * online yet and that during CPU hotplug that the cpumask is not
-	 * yet updated when a CPU is being onlined.
+	 * Split the high value across all online CPUs local to the zone. Note
+	 * that early in boot that CPUs may not be online yet and that during
+	 * CPU hotplug that the cpumask is not yet updated when a CPU is being
+	 * onlined.
 	 */
 	nr_local_cpus = max(1U, cpumask_weight(cpumask_of_node(zone_to_nid(zone)))) + cpu_online;
-	high = low_wmark_pages(zone) / nr_local_cpus;
+	high = total_pages / nr_local_cpus;
 
 	/*
 	 * Ensure high is at least batch*4. The multiple is based on the
@@ -8500,6 +8517,44 @@ int lowmem_reserve_ratio_sysctl_handler(
 	return 0;
 }
 
+/*
+ * percpu_pagelist_high_fraction - changes the pcp->high for each zone on each
+ * cpu. It is the fraction of total pages in each zone that a hot per cpu
+ * pagelist can have before it gets flushed back to buddy allocator.
+ */
+int percpu_pagelist_high_fraction_sysctl_handler(struct ctl_table *table,
+		int write, void *buffer, size_t *length, loff_t *ppos)
+{
+	struct zone *zone;
+	int old_percpu_pagelist_high_fraction;
+	int ret;
+
+	mutex_lock(&pcp_batch_high_lock);
+	old_percpu_pagelist_high_fraction = percpu_pagelist_high_fraction;
+
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (!write || ret < 0)
+		goto out;
+
+	/* Sanity checking to avoid pcp imbalance */
+	if (percpu_pagelist_high_fraction &&
+	    percpu_pagelist_high_fraction < MIN_PERCPU_PAGELIST_HIGH_FRACTION) {
+		percpu_pagelist_high_fraction = old_percpu_pagelist_high_fraction;
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* No change? */
+	if (percpu_pagelist_high_fraction == old_percpu_pagelist_high_fraction)
+		goto out;
+
+	for_each_populated_zone(zone)
+		zone_set_pageset_high_and_batch(zone, 0);
+out:
+	mutex_unlock(&pcp_batch_high_lock);
+	return ret;
+}
+
 #ifndef __HAVE_ARCH_RESERVED_KERNEL_PAGES
 /*
  * Returns the number of pages that arch has reserved but
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


