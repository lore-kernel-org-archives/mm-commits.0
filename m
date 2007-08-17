From: akpm@linux-foundation.org
Subject: + sched-fix-broken-smt-mc-optimizations-with-cfs.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:52:24 -0700
Message-ID: <200708171852.l7HIqO59024470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369AbXHQSwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com


The patch titled
     sched: fix broken smt/mc optimizations with CFS
has been added to the -mm tree.  Its filename is
     sched-fix-broken-smt-mc-optimizations-with-cfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

slab-skip-calling-cache_free_alien-when-the-platform-is-not-numa-capable.patch
sched-fix-broken-smt-mc-optimizations-with-cfs.patch
sched-skip-updating-rqs-next_balance-under-null-sd.patch
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
