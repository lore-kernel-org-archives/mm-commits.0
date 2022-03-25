Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2B9C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357403AbiCYBfV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357416AbiCYBe2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2904BF524
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2432260A50
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A0AC340ED;
        Fri, 25 Mar 2022 01:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171944;
        bh=HTAUyIAL1ZypLJLmPN9IRha/jpaANJiTsYT5jg1HikI=;
        h=Date:To:From:Subject:From;
        b=PNx75Ekm66pQUj9af1Pb8YvPi8n6AtwuEnvAXa/dUicaNUw9CJ9GdgDX+nDDy1fYc
         /YU1v5zltxTxXARX5xrVVXqrAju5H6+051KzLtlldW8U0/cTbKtlazx7vD1YI6SNMe
         J3m0BihT8YJShiCs0NGOFwZG5OyEUE/tXSa+qvhM=
Date:   Thu, 24 Mar 2022 18:32:23 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhongjiang-ali@linux.alibaba.com, weixugc@google.com,
        shy828301@gmail.com, shakeelb@google.com, riel@surriel.com,
        rdunlap@infradead.org, peterz@infradead.org, osalvador@suse.de,
        mhocko@suse.com, mgorman@techsingularity.net, hannes@cmpxchg.org,
        feng.tang@intel.com, dave.hansen@linux.intel.com,
        baolin.wang@linux.alibaba.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] numa-balancing-optimize-page-placement-for-memory-tiering-system.patch removed from -mm tree
Message-Id: <20220325013224.79A0AC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: NUMA balancing: optimize page placement for memory tiering system
has been removed from the -mm tree.  Its filename was
     numa-balancing-optimize-page-placement-for-memory-tiering-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: NUMA balancing: optimize page placement for memory tiering system

With the advent of various new memory types, some machines will have
multiple types of memory, e.g.  DRAM and PMEM (persistent memory).  The
memory subsystem of these machines can be called memory tiering system,
because the performance of the different types of memory are usually
different.

In such system, because of the memory accessing pattern changing etc,
some pages in the slow memory may become hot globally.  So in this
patch, the NUMA balancing mechanism is enhanced to optimize the page
placement among the different memory types according to hot/cold
dynamically.

In a typical memory tiering system, there are CPUs, fast memory and
slow memory in each physical NUMA node.  The CPUs and the fast memory
will be put in one logical node (called fast memory node), while the
slow memory will be put in another (faked) logical node (called slow
memory node).  That is, the fast memory is regarded as local while the
slow memory is regarded as remote.  So it's possible for the recently
accessed pages in the slow memory node to be promoted to the fast
memory node via the existing NUMA balancing mechanism.

The original NUMA balancing mechanism will stop to migrate pages if the
free memory of the target node becomes below the high watermark.  This
is a reasonable policy if there's only one memory type.  But this makes
the original NUMA balancing mechanism almost do not work to optimize
page placement among different memory types.  Details are as follows.

It's the common cases that the working-set size of the workload is
larger than the size of the fast memory nodes.  Otherwise, it's
unnecessary to use the slow memory at all.  So, there are almost always
no enough free pages in the fast memory nodes, so that the globally hot
pages in the slow memory node cannot be promoted to the fast memory
node.  To solve the issue, we have 2 choices as follows,

a. Ignore the free pages watermark checking when promoting hot pages
   from the slow memory node to the fast memory node.  This will
   create some memory pressure in the fast memory node, thus trigger
   the memory reclaiming.  So that, the cold pages in the fast memory
   node will be demoted to the slow memory node.

b. Define a new watermark called wmark_promo which is higher than
   wmark_high, and have kswapd reclaiming pages until free pages reach
   such watermark.  The scenario is as follows: when we want to promote
   hot-pages from a slow memory to a fast memory, but fast memory's free
   pages would go lower than high watermark with such promotion, we wake
   up kswapd with wmark_promo watermark in order to demote cold pages and
   free us up some space.  So, next time we want to promote hot-pages we
   might have a chance of doing so.

The choice "a" may create high memory pressure in the fast memory node.
If the memory pressure of the workload is high, the memory pressure
may become so high that the memory allocation latency of the workload
is influenced, e.g.  the direct reclaiming may be triggered.

The choice "b" works much better at this aspect.  If the memory
pressure of the workload is high, the hot pages promotion will stop
earlier because its allocation watermark is higher than that of the
normal memory allocation.  So in this patch, choice "b" is implemented.
A new zone watermark (WMARK_PROMO) is added.  Which is larger than the
high watermark and can be controlled via watermark_scale_factor.

In addition to the original page placement optimization among sockets,
the NUMA balancing mechanism is extended to be used to optimize page
placement according to hot/cold among different memory types.  So the
sysctl user space interface (numa_balancing) is extended in a backward
compatible way as follow, so that the users can enable/disable these
functionality individually.

The sysctl is converted from a Boolean value to a bits field.  The
definition of the flags is,

- 0: NUMA_BALANCING_DISABLED
- 1: NUMA_BALANCING_NORMAL
- 2: NUMA_BALANCING_MEMORY_TIERING

We have tested the patch with the pmbench memory accessing benchmark
with the 80:20 read/write ratio and the Gauss access address
distribution on a 2 socket Intel server with Optane DC Persistent
Memory Model.  The test results shows that the pmbench score can
improve up to 95.9%.

Thanks Andrew Morton to help fix the document format error.

Link: https://lkml.kernel.org/r/20220221084529.1052339-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   31 ++++++++++++------
 include/linux/mmzone.h                      |    1 
 include/linux/sched/sysctl.h                |   10 +++++
 kernel/sched/core.c                         |   21 +++++++++---
 kernel/sysctl.c                             |    2 -
 mm/migrate.c                                |   16 ++++++++-
 mm/page_alloc.c                             |    3 +
 mm/vmscan.c                                 |    6 ++-
 8 files changed, 71 insertions(+), 19 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~numa-balancing-optimize-page-placement-for-memory-tiering-system
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -595,16 +595,23 @@ Documentation/admin-guide/kernel-paramet
 numa_balancing
 ==============
 
-Enables/disables automatic page fault based NUMA memory
-balancing. Memory is moved automatically to nodes
-that access it often.
-
-Enables/disables automatic NUMA memory balancing. On NUMA machines, there
-is a performance penalty if remote memory is accessed by a CPU. When this
-feature is enabled the kernel samples what task thread is accessing memory
-by periodically unmapping pages and later trapping a page fault. At the
-time of the page fault, it is determined if the data being accessed should
-be migrated to a local memory node.
+Enables/disables and configures automatic page fault based NUMA memory
+balancing.  Memory is moved automatically to nodes that access it often.
+The value to set can be the result of ORing the following:
+
+= =================================
+0 NUMA_BALANCING_DISABLED
+1 NUMA_BALANCING_NORMAL
+2 NUMA_BALANCING_MEMORY_TIERING
+= =================================
+
+Or NUMA_BALANCING_NORMAL to optimize page placement among different
+NUMA nodes to reduce remote accessing.  On NUMA machines, there is a
+performance penalty if remote memory is accessed by a CPU. When this
+feature is enabled the kernel samples what task thread is accessing
+memory by periodically unmapping pages and later trapping a page
+fault. At the time of the page fault, it is determined if the data
+being accessed should be migrated to a local memory node.
 
 The unmapping of pages and trapping faults incur additional overhead that
 ideally is offset by improved memory locality but there is no universal
@@ -615,6 +622,10 @@ faults may be controlled by the `numa_ba
 numa_balancing_scan_delay_ms, numa_balancing_scan_period_max_ms,
 numa_balancing_scan_size_mb`_, and numa_balancing_settle_count sysctls.
 
+Or NUMA_BALANCING_MEMORY_TIERING to optimize page placement among
+different types of memory (represented as different NUMA nodes) to
+place the hot pages in the fast memory.  This is implemented based on
+unmapping and page fault too.
 
 numa_balancing_scan_period_min_ms, numa_balancing_scan_delay_ms, numa_balancing_scan_period_max_ms, numa_balancing_scan_size_mb
 ===============================================================================================================================
--- a/include/linux/mmzone.h~numa-balancing-optimize-page-placement-for-memory-tiering-system
+++ a/include/linux/mmzone.h
@@ -353,6 +353,7 @@ enum zone_watermarks {
 	WMARK_MIN,
 	WMARK_LOW,
 	WMARK_HIGH,
+	WMARK_PROMO,
 	NR_WMARK
 };
 
--- a/include/linux/sched/sysctl.h~numa-balancing-optimize-page-placement-for-memory-tiering-system
+++ a/include/linux/sched/sysctl.h
@@ -23,6 +23,16 @@ enum sched_tunable_scaling {
 	SCHED_TUNABLESCALING_END,
 };
 
+#define NUMA_BALANCING_DISABLED		0x0
+#define NUMA_BALANCING_NORMAL		0x1
+#define NUMA_BALANCING_MEMORY_TIERING	0x2
+
+#ifdef CONFIG_NUMA_BALANCING
+extern int sysctl_numa_balancing_mode;
+#else
+#define sysctl_numa_balancing_mode	0
+#endif
+
 /*
  *  control realtime throttling:
  *
--- a/kernel/sched/core.c~numa-balancing-optimize-page-placement-for-memory-tiering-system
+++ a/kernel/sched/core.c
@@ -4279,7 +4279,9 @@ DEFINE_STATIC_KEY_FALSE(sched_numa_balan
 
 #ifdef CONFIG_NUMA_BALANCING
 
-void set_numabalancing_state(bool enabled)
+int sysctl_numa_balancing_mode;
+
+static void __set_numabalancing_state(bool enabled)
 {
 	if (enabled)
 		static_branch_enable(&sched_numa_balancing);
@@ -4287,13 +4289,22 @@ void set_numabalancing_state(bool enable
 		static_branch_disable(&sched_numa_balancing);
 }
 
+void set_numabalancing_state(bool enabled)
+{
+	if (enabled)
+		sysctl_numa_balancing_mode = NUMA_BALANCING_NORMAL;
+	else
+		sysctl_numa_balancing_mode = NUMA_BALANCING_DISABLED;
+	__set_numabalancing_state(enabled);
+}
+
 #ifdef CONFIG_PROC_SYSCTL
 int sysctl_numa_balancing(struct ctl_table *table, int write,
 			  void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table t;
 	int err;
-	int state = static_branch_likely(&sched_numa_balancing);
+	int state = sysctl_numa_balancing_mode;
 
 	if (write && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -4303,8 +4314,10 @@ int sysctl_numa_balancing(struct ctl_tab
 	err = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
 	if (err < 0)
 		return err;
-	if (write)
-		set_numabalancing_state(state);
+	if (write) {
+		sysctl_numa_balancing_mode = state;
+		__set_numabalancing_state(state);
+	}
 	return err;
 }
 #endif
--- a/kernel/sysctl.c~numa-balancing-optimize-page-placement-for-memory-tiering-system
+++ a/kernel/sysctl.c
@@ -1696,7 +1696,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sysctl_numa_balancing,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= SYSCTL_FOUR,
 	},
 #endif /* CONFIG_NUMA_BALANCING */
 	{
--- a/mm/migrate.c~numa-balancing-optimize-page-placement-for-memory-tiering-system
+++ a/mm/migrate.c
@@ -51,6 +51,7 @@
 #include <linux/oom.h>
 #include <linux/memory.h>
 #include <linux/random.h>
+#include <linux/sched/sysctl.h>
 
 #include <asm/tlbflush.h>
 
@@ -2031,16 +2032,27 @@ static int numamigrate_isolate_page(pg_d
 {
 	int page_lru;
 	int nr_pages = thp_nr_pages(page);
+	int order = compound_order(page);
 
-	VM_BUG_ON_PAGE(compound_order(page) && !PageTransHuge(page), page);
+	VM_BUG_ON_PAGE(order && !PageTransHuge(page), page);
 
 	/* Do not migrate THP mapped by multiple processes */
 	if (PageTransHuge(page) && total_mapcount(page) > 1)
 		return 0;
 
 	/* Avoid migrating to a node that is nearly full */
-	if (!migrate_balanced_pgdat(pgdat, nr_pages))
+	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
+		int z;
+
+		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
+			return 0;
+		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
+			if (populated_zone(pgdat->node_zones + z))
+				break;
+		}
+		wakeup_kswapd(pgdat->node_zones + z, 0, order, ZONE_MOVABLE);
 		return 0;
+	}
 
 	if (isolate_lru_page(page))
 		return 0;
--- a/mm/page_alloc.c~numa-balancing-optimize-page-placement-for-memory-tiering-system
+++ a/mm/page_alloc.c
@@ -8441,7 +8441,8 @@ static void __setup_per_zone_wmarks(void
 
 		zone->watermark_boost = 0;
 		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
-		zone->_watermark[WMARK_HIGH] = min_wmark_pages(zone) + tmp * 2;
+		zone->_watermark[WMARK_HIGH] = low_wmark_pages(zone) + tmp;
+		zone->_watermark[WMARK_PROMO] = high_wmark_pages(zone) + tmp;
 
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
--- a/mm/vmscan.c~numa-balancing-optimize-page-placement-for-memory-tiering-system
+++ a/mm/vmscan.c
@@ -56,6 +56,7 @@
 
 #include <linux/swapops.h>
 #include <linux/balloon_compaction.h>
+#include <linux/sched/sysctl.h>
 
 #include "internal.h"
 
@@ -3895,7 +3896,10 @@ static bool pgdat_balanced(pg_data_t *pg
 		if (!managed_zone(zone))
 			continue;
 
-		mark = high_wmark_pages(zone);
+		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+			mark = wmark_pages(zone, WMARK_PROMO);
+		else
+			mark = high_wmark_pages(zone);
 		if (zone_watermark_ok_safe(zone, order, mark, highest_zoneidx))
 			return true;
 	}
_

Patches currently in -mm which might be from ying.huang@intel.com are


