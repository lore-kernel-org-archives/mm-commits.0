Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08F4E7F147
	for <mm-commits@archiver.kernel.org>; Tue, 26 Sep 2023 23:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjIZXSC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 19:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjIZXPz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 19:15:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A1717804
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 15:17:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4BCC433CD;
        Tue, 26 Sep 2023 20:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695761968;
        bh=gju8kxVhR1rocLlrNh+Cyd3wRxU1fa6YiRbRYbMehmI=;
        h=Date:To:From:Subject:From;
        b=LnS9pno/OKjS5JlHpZxJm1aPg9AAAkz44R5Sdp0BCErc81SE7u2bLmzL+zObQMOlV
         TzA34Es6MZdLaC6y//aBm0YFNqEaWIYpcj2lb8USaQTjL6Ac3S+vi4/AuOt30NBk+K
         26dYFG92boGnIE7L77ws7QjFPj8JINltWXNnxBXw=
Date:   Tue, 26 Sep 2023 13:59:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-framework-for-pcp-high-auto-tuning.patch added to mm-unstable branch
Message-Id: <20230926205928.AE4BCC433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add framework for PCP high auto-tuning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-framework-for-pcp-high-auto-tuning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-framework-for-pcp-high-auto-tuning.patch

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
From: Huang Ying <ying.huang@intel.com>
Subject: mm: add framework for PCP high auto-tuning
Date: Tue, 26 Sep 2023 14:09:07 +0800

The page allocation performance requirements of different workloads are
usually different.  So, we need to tune PCP (per-CPU pageset) high to
optimize the workload page allocation performance.  Now, we have a system
wide sysctl knob (percpu_pagelist_high_fraction) to tune PCP high by hand.
But, it's hard to find out the best value by hand.  And one global
configuration may not work best for the different workloads that run on
the same system.  One solution to these issues is to tune PCP high of each
CPU automatically.

This patch adds the framework for PCP high auto-tuning.  With it,
pcp->high of each CPU will be changed automatically by tuning algorithm at
runtime.  The minimal high (pcp->high_min) is the original PCP high value
calculated based on the low watermark pages.  While the maximal high
(pcp->high_max) is the PCP high value when percpu_pagelist_high_fraction
sysctl knob is set to MIN_PERCPU_PAGELIST_HIGH_FRACTION.  That is, the
maximal pcp->high that can be set via sysctl knob by hand.

It's possible that PCP high auto-tuning doesn't work well for some
workloads.  So, when PCP high is tuned by hand via the sysctl knob, the
auto-tuning will be disabled.  The PCP high set by hand will be used
instead.

This patch only adds the framework, so pcp->high will be set to
pcp->high_min (original default) always.  We will add actual auto-tuning
algorithm in the following patches in the series.

Link: https://lkml.kernel.org/r/20230926060911.266511-7-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   12 ++-
 include/linux/mmzone.h                  |    5 +
 mm/page_alloc.c                         |   71 ++++++++++++++--------
 3 files changed, 58 insertions(+), 30 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-add-framework-for-pcp-high-auto-tuning
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -843,10 +843,14 @@ each zone between per-cpu lists.
 The batch value of each per-cpu page list remains the same regardless of
 the value of the high fraction so allocation latencies are unaffected.
 
-The initial value is zero. Kernel uses this value to set the high pcp->high
-mark based on the low watermark for the zone and the number of local
-online CPUs.  If the user writes '0' to this sysctl, it will revert to
-this default behavior.
+The initial value is zero. With this value, kernel will tune pcp->high
+automatically according to the requirements of workloads.  The lower
+limit of tuning is based on the low watermark for the zone and the
+number of local online CPUs.  The upper limit is the page number when
+the sysctl is set to the minimal value (8).  If the user writes '0' to
+this sysctl, it will revert to this default behavior.  In another
+words, if the user write other value, the auto-tuning will be disabled
+and the user specified pcp->high will be used.
 
 
 stat_interval
--- a/include/linux/mmzone.h~mm-add-framework-for-pcp-high-auto-tuning
+++ a/include/linux/mmzone.h
@@ -695,6 +695,8 @@ struct per_cpu_pages {
 	spinlock_t lock;	/* Protects lists field */
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
+	int high_min;		/* min high watermark */
+	int high_max;		/* max high watermark */
 	int batch;		/* chunk size for buddy add/remove */
 	u8 flags;		/* protected by pcp->lock */
 	u8 alloc_factor;	/* batch scaling factor during allocate */
@@ -854,7 +856,8 @@ struct zone {
 	 * the high and batch values are copied to individual pagesets for
 	 * faster access
 	 */
-	int pageset_high;
+	int pageset_high_min;
+	int pageset_high_max;
 	int pageset_batch;
 
 #ifndef CONFIG_SPARSEMEM
--- a/mm/page_alloc.c~mm-add-framework-for-pcp-high-auto-tuning
+++ a/mm/page_alloc.c
@@ -2383,7 +2383,7 @@ static int nr_pcp_free(struct per_cpu_pa
 static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
 		       bool free_high)
 {
-	int high = READ_ONCE(pcp->high);
+	int high = READ_ONCE(pcp->high_min);
 
 	if (unlikely(!high || free_high))
 		return 0;
@@ -2722,7 +2722,7 @@ static int nr_pcp_alloc(struct per_cpu_p
 {
 	int high, batch, max_nr_alloc;
 
-	high = READ_ONCE(pcp->high);
+	high = READ_ONCE(pcp->high_min);
 	batch = READ_ONCE(pcp->batch);
 
 	/* Check for PCP disabled or boot pageset */
@@ -5328,14 +5328,15 @@ static int zone_batchsize(struct zone *z
 }
 
 static int percpu_pagelist_high_fraction;
-static int zone_highsize(struct zone *zone, int batch, int cpu_online)
+static int zone_highsize(struct zone *zone, int batch, int cpu_online,
+			 int high_fraction)
 {
 #ifdef CONFIG_MMU
 	int high;
 	int nr_split_cpus;
 	unsigned long total_pages;
 
-	if (!percpu_pagelist_high_fraction) {
+	if (!high_fraction) {
 		/*
 		 * By default, the high value of the pcp is based on the zone
 		 * low watermark so that if they are full then background
@@ -5348,15 +5349,15 @@ static int zone_highsize(struct zone *zo
 		 * value is based on a fraction of the managed pages in the
 		 * zone.
 		 */
-		total_pages = zone_managed_pages(zone) / percpu_pagelist_high_fraction;
+		total_pages = zone_managed_pages(zone) / high_fraction;
 	}
 
 	/*
 	 * Split the high value across all online CPUs local to the zone. Note
 	 * that early in boot that CPUs may not be online yet and that during
 	 * CPU hotplug that the cpumask is not yet updated when a CPU is being
-	 * onlined. For memory nodes that have no CPUs, split pcp->high across
-	 * all online CPUs to mitigate the risk that reclaim is triggered
+	 * onlined. For memory nodes that have no CPUs, split the high value
+	 * across all online CPUs to mitigate the risk that reclaim is triggered
 	 * prematurely due to pages stored on pcp lists.
 	 */
 	nr_split_cpus = cpumask_weight(cpumask_of_node(zone_to_nid(zone))) + cpu_online;
@@ -5384,19 +5385,21 @@ static int zone_highsize(struct zone *zo
  * However, guaranteeing these relations at all times would require e.g. write
  * barriers here but also careful usage of read barriers at the read side, and
  * thus be prone to error and bad for performance. Thus the update only prevents
- * store tearing. Any new users of pcp->batch and pcp->high should ensure they
- * can cope with those fields changing asynchronously, and fully trust only the
- * pcp->count field on the local CPU with interrupts disabled.
+ * store tearing. Any new users of pcp->batch, pcp->high_min and pcp->high_max
+ * should ensure they can cope with those fields changing asynchronously, and
+ * fully trust only the pcp->count field on the local CPU with interrupts
+ * disabled.
  *
  * mutex_is_locked(&pcp_batch_high_lock) required when calling this function
  * outside of boot time (or some other assurance that no concurrent updaters
  * exist).
  */
-static void pageset_update(struct per_cpu_pages *pcp, unsigned long high,
-		unsigned long batch)
+static void pageset_update(struct per_cpu_pages *pcp, unsigned long high_min,
+			   unsigned long high_max, unsigned long batch)
 {
 	WRITE_ONCE(pcp->batch, batch);
-	WRITE_ONCE(pcp->high, high);
+	WRITE_ONCE(pcp->high_min, high_min);
+	WRITE_ONCE(pcp->high_max, high_max);
 }
 
 static void per_cpu_pages_init(struct per_cpu_pages *pcp, struct per_cpu_zonestat *pzstats)
@@ -5416,20 +5419,21 @@ static void per_cpu_pages_init(struct pe
 	 * need to be as careful as pageset_update() as nobody can access the
 	 * pageset yet.
 	 */
-	pcp->high = BOOT_PAGESET_HIGH;
+	pcp->high_min = BOOT_PAGESET_HIGH;
+	pcp->high_max = BOOT_PAGESET_HIGH;
 	pcp->batch = BOOT_PAGESET_BATCH;
 	pcp->free_factor = 0;
 }
 
-static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
-		unsigned long batch)
+static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high_min,
+					      unsigned long high_max, unsigned long batch)
 {
 	struct per_cpu_pages *pcp;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
-		pageset_update(pcp, high, batch);
+		pageset_update(pcp, high_min, high_max, batch);
 	}
 }
 
@@ -5439,19 +5443,34 @@ static void __zone_set_pageset_high_and_
  */
 static void zone_set_pageset_high_and_batch(struct zone *zone, int cpu_online)
 {
-	int new_high, new_batch;
+	int new_high_min, new_high_max, new_batch;
 
 	new_batch = max(1, zone_batchsize(zone));
-	new_high = zone_highsize(zone, new_batch, cpu_online);
+	if (percpu_pagelist_high_fraction) {
+		new_high_min = zone_highsize(zone, new_batch, cpu_online,
+					     percpu_pagelist_high_fraction);
+		/*
+		 * PCP high is tuned manually, disable auto-tuning via
+		 * setting high_min and high_max to the manual value.
+		 */
+		new_high_max = new_high_min;
+	} else {
+		new_high_min = zone_highsize(zone, new_batch, cpu_online, 0);
+		new_high_max = zone_highsize(zone, new_batch, cpu_online,
+					     MIN_PERCPU_PAGELIST_HIGH_FRACTION);
+	}
 
-	if (zone->pageset_high == new_high &&
+	if (zone->pageset_high_min == new_high_min &&
+	    zone->pageset_high_max == new_high_max &&
 	    zone->pageset_batch == new_batch)
 		return;
 
-	zone->pageset_high = new_high;
+	zone->pageset_high_min = new_high_min;
+	zone->pageset_high_max = new_high_max;
 	zone->pageset_batch = new_batch;
 
-	__zone_set_pageset_high_and_batch(zone, new_high, new_batch);
+	__zone_set_pageset_high_and_batch(zone, new_high_min, new_high_max,
+					  new_batch);
 }
 
 void __meminit setup_zone_pageset(struct zone *zone)
@@ -5559,7 +5578,8 @@ __meminit void zone_pcp_init(struct zone
 	 */
 	zone->per_cpu_pageset = &boot_pageset;
 	zone->per_cpu_zonestats = &boot_zonestats;
-	zone->pageset_high = BOOT_PAGESET_HIGH;
+	zone->pageset_high_min = BOOT_PAGESET_HIGH;
+	zone->pageset_high_max = BOOT_PAGESET_HIGH;
 	zone->pageset_batch = BOOT_PAGESET_BATCH;
 
 	if (populated_zone(zone))
@@ -6461,13 +6481,14 @@ EXPORT_SYMBOL(free_contig_range);
 void zone_pcp_disable(struct zone *zone)
 {
 	mutex_lock(&pcp_batch_high_lock);
-	__zone_set_pageset_high_and_batch(zone, 0, 1);
+	__zone_set_pageset_high_and_batch(zone, 0, 0, 1);
 	__drain_all_pages(zone, true);
 }
 
 void zone_pcp_enable(struct zone *zone)
 {
-	__zone_set_pageset_high_and_batch(zone, zone->pageset_high, zone->pageset_batch);
+	__zone_set_pageset_high_and_batch(zone, zone->pageset_high_min,
+		zone->pageset_high_max, zone->pageset_batch);
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch
memory-tiering-add-abstract-distance-calculation-algorithms-management.patch
acpi-hmat-refactor-hmat_register_target_initiators.patch
acpi-hmat-calculate-abstract-distance-with-hmat.patch
dax-kmem-calculate-abstract-distance-with-general-interface.patch
mm-pcp-avoid-to-drain-pcp-when-process-exit.patch
cacheinfo-calculate-per-cpu-data-cache-size.patch
mm-pcp-reduce-lock-contention-for-draining-high-order-pages.patch
mm-restrict-the-pcp-batch-scale-factor-to-avoid-too-long-latency.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated.patch
mm-add-framework-for-pcp-high-auto-tuning.patch
mm-tune-pcp-high-automatically.patch
mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch
mm-pcp-avoid-to-reduce-pcp-high-unnecessarily.patch
mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing.patch

