From: akpm@linux-foundation.org
Subject: - sched-fix-the-all-pinned-logic-in-load_balance_newidle.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:52 -0700
Message-ID: <200707192007.l6JK7qdE020398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49722 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761406AbXGSUQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     sched: fix the all pinned logic in load_balance_newidle()
has been removed from the -mm tree.  Its filename was
     sched-fix-the-all-pinned-logic-in-load_balance_newidle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: fix the all pinned logic in load_balance_newidle()
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

nr_moved is not the correct check for triggering all pinned logic.  Fix the
all pinned logic in the case of load_balance_newidle().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~sched-fix-the-all-pinned-logic-in-load_balance_newidle kernel/sched.c
--- a/kernel/sched.c~sched-fix-the-all-pinned-logic-in-load_balance_newidle
+++ a/kernel/sched.c
@@ -2679,6 +2679,7 @@ load_balance_newidle(int this_cpu, struc
 	unsigned long imbalance;
 	int nr_moved = 0;
 	int sd_idle = 0;
+	int all_pinned = 0;
 	cpumask_t cpus = CPU_MASK_ALL;
 
 	/*
@@ -2717,10 +2718,10 @@ redo:
 		double_lock_balance(this_rq, busiest);
 		nr_moved = move_tasks(this_rq, this_cpu, busiest,
 					minus_1_or_zero(busiest->nr_running),
-					imbalance, sd, CPU_NEWLY_IDLE, NULL);
+					imbalance, sd, CPU_NEWLY_IDLE, &all_pinned);
 		spin_unlock(&busiest->lock);
 
-		if (!nr_moved) {
+		if (unlikely(all_pinned)) {
 			cpu_clear(cpu_of(busiest), cpus);
 			if (!cpus_empty(cpus))
 				goto redo;
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
git-sched.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
