Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8BFC47087
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CEE861408
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhEYXon (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 19:44:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231356AbhEYXon (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 19:44:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25E0E61404;
        Tue, 25 May 2021 23:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621986192;
        bh=0vEg6d7dmyuzKUCRhb8oBZzi0oXoISZq1U9hQMGvdeo=;
        h=Date:From:To:Subject:From;
        b=IN68s+yri+9CMKLGhBpwzYNmX9gPdj00mxG40GDEHq4Dad5UCz97hhI9SK6QdfFLw
         7yisqV2E5OEFafKASlaSRK35kUNrZCwnLBL8YeJKFX89FzUMkux/+mtLAo5M+zUvac
         LJZhC8keIgzT+CTAKlmB5RLT8M0YQ5rEG9SbAxMs=
Date:   Tue, 25 May 2021 16:43:11 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch added to -mm
 tree
Message-ID: <20210525234311.X8heoO2Fg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: introduce vm.percpu_pagelist_high_fraction
has been added to the -mm tree.  Its filename is
     mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20210525080119.5455-7-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   20 ++++++
 include/linux/mmzone.h                  |    3 
 kernel/sysctl.c                         |    8 ++
 mm/page_alloc.c                         |   69 +++++++++++++++++++---
 4 files changed, 93 insertions(+), 7 deletions(-)

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
@@ -789,6 +790,25 @@ panic_on_oom=2+kdump gives you very stro
 why oom happens. You can get snapshot.
 
 
+percpu_pagelist_high_fraction
+=============================
+
+This is the fraction of pages in each zone that are allocated for each
+per cpu page list.  The min value for this is 8.  It means that we do
+not allow more than 1/8th of pages in each zone to be allocated in any
+single per_cpu_pagelist.  This entry only changes the value of hot per
+cpu pagelists. User can specify a number like 100 to allocate 1/100th
+of each zone to each per cpu page list.
+
+The batch value of each per cpu pagelist remains the same regardless of the
+value of the high fraction so allocation latencies are unaffected.
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
@@ -2890,6 +2890,14 @@ static struct ctl_table vm_table[] = {
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
@@ -181,6 +182,7 @@ EXPORT_SYMBOL(_totalram_pages);
 unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
 
+int percpu_pagelist_high_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 EXPORT_SYMBOL(init_on_alloc);
@@ -6689,17 +6691,32 @@ static int zone_highsize(struct zone *zo
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
@@ -8461,6 +8478,44 @@ int lowmem_reserve_ratio_sysctl_handler(
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

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-delete-vmpercpu_pagelist_fraction.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch
mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch
mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch
mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch
mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust.patch
mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch
mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch
mm-swap-make-swap_address_space-an-inline-function.patch
mm-mmap_lock-remove-dead-code-for-config_tracing-configurations.patch
mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

