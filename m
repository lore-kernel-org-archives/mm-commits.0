From: akpm@linux-foundation.org
Subject: - sched-fix-broken-smt-mc-optimizations-with-cfs.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:04 -0700
Message-ID: <200708242058.l7OKw4xE014281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756906AbXHXVHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: fix broken smt/mc optimizations with CFS
has been removed from the -mm tree.  Its filename was
     sched-fix-broken-smt-mc-optimizations-with-cfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: fix broken smt/mc optimizations with CFS
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

On a four package system with HT - HT load balancing optimizations were
broken.  For example, if two tasks end up running on two logical threads of
one of the packages, scheduler is not able to pull one of the tasks to a
completely idle package.

In this scenario, for nice-0 tasks, imbalance calculated by scheduler will be
512 and find_busiest_queue() will return 0 (as each cpu's load is 1024 >
imbalance and has only one task running).

Similarly MC scheduler optimizations also get fixed with this patch.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-fix-broken-smt-mc-optimizations-with-cfs kernel/sched.c
--- a/kernel/sched.c~sched-fix-broken-smt-mc-optimizations-with-cfs
+++ a/kernel/sched.c
@@ -2494,7 +2494,7 @@ group_next:
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task/2) {
+	if (*imbalance < busiest_load_per_task) {
 		unsigned long tmp, pwr_now, pwr_move;
 		unsigned int imbn;
 
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
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
intel-iommu-optimize-sg-map-unmap-calls.patch
