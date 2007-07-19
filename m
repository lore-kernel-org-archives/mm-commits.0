From: akpm@linux-foundation.org
Subject: - sched-fix-newly-idle-load-balance-in-case-of-smt.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:50 -0700
Message-ID: <200707192007.l6JK7oRj020395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760155AbXGSUQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     sched: fix newly idle load balance in case of SMT
has been removed from the -mm tree.  Its filename was
     sched-fix-newly-idle-load-balance-in-case-of-smt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: fix newly idle load balance in case of SMT
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

In the presence of SMT, newly idle balance was never happening for multi-core
and SMP domains(even when both the logical siblings are idle).

If thread 0 is already idle and when thread 1 is about to go to idle, newly
idle load balance always think that one of the threads is not idle and skips
doing the newly idle load balance for multi-core and SMP domains.

This is because of the idle_cpu() macro, which checks if the current process
on a cpu is an idle process.  But this is not the case for the thread doing
the load_balance_newidle().

Fix this by using runqueue's nr_running field instead of idle_cpu().  And also
skip the logic of 'only one idle cpu in the group will be doing load
balancing' during newly idle case.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/sched.c~sched-fix-newly-idle-load-balance-in-case-of-smt kernel/sched.c
--- a/kernel/sched.c~sched-fix-newly-idle-load-balance-in-case-of-smt
+++ a/kernel/sched.c
@@ -2235,7 +2235,7 @@ find_busiest_group(struct sched_domain *
 
 			rq = cpu_rq(i);
 
-			if (*sd_idle && !idle_cpu(i))
+			if (*sd_idle && rq->nr_running)
 				*sd_idle = 0;
 
 			/* Bias balancing toward cpus of our domain */
@@ -2257,9 +2257,11 @@ find_busiest_group(struct sched_domain *
 		/*
 		 * First idle cpu or the first cpu(busiest) in this sched group
 		 * is eligible for doing load balancing at this and above
-		 * domains.
+		 * domains. In the newly idle case, we will allow all the cpu's
+		 * to do the newly idle load balance.
 		 */
-		if (local_group && balance_cpu != this_cpu && balance) {
+		if (idle != CPU_NEWLY_IDLE && local_group &&
+		    balance_cpu != this_cpu && balance) {
 			*balance = 0;
 			goto ret;
 		}
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
