From: akpm@linux-foundation.org
Subject: - sched-skip-updating-rqs-next_balance-under-null-sd.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:06 -0700
Message-ID: <200708242058.l7OKw64a014284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49695 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757849AbXHXVH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:07:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: skip updating  rq's next_balance under null SD
has been removed from the -mm tree.  Its filename was
     sched-skip-updating-rqs-next_balance-under-null-sd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: skip updating  rq's next_balance under null SD
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Was playing with sched_smt_power_savings/sched_mc_power_savings and found out
that while the scheduler domains are reconstructed when sysfs settings change,
rebalance_domains() can get triggered with null domain on other cpus, which is
setting next_balance to jiffies + 60*HZ.  Resulting in no idle/busy balancing
for 60 seconds.

Fix this.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~sched-skip-updating-rqs-next_balance-under-null-sd kernel/sched.c
--- a/kernel/sched.c~sched-skip-updating-rqs-next_balance-under-null-sd
+++ a/kernel/sched.c
@@ -3020,6 +3020,7 @@ static inline void rebalance_domains(int
 	struct sched_domain *sd;
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
+	int update_next_balance = 0;
 
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -3056,8 +3057,10 @@ static inline void rebalance_domains(int
 		if (sd->flags & SD_SERIALIZE)
 			spin_unlock(&balancing);
 out:
-		if (time_after(next_balance, sd->last_balance + interval))
+		if (time_after(next_balance, sd->last_balance + interval)) {
 			next_balance = sd->last_balance + interval;
+			update_next_balance = 1;
+		}
 
 		/*
 		 * Stop the load balance at this level. There is another
@@ -3067,7 +3070,14 @@ out:
 		if (!balance)
 			break;
 	}
-	rq->next_balance = next_balance;
+
+	/*
+	 * next_balance will be updated only when there is a need.
+	 * When the cpu is attached to null domain for ex, it will not be
+	 * updated.
+	 */
+	if (likely(update_next_balance))
+		rq->next_balance = next_balance;
 }
 
 /*
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
