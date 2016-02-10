From: akpm@linux-foundation.org
Subject: [merged] vmstat-make-vmstat_update-deferrable.patch removed from
 -mm tree
Date: Wed, 10 Feb 2016 11:35:36 -0800
Message-ID: <56bb9108.LUEfLuyZAcWPIHEx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbcBJTfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, cl@linux.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: make vmstat_update deferrable
has been removed from the -mm tree.  Its filename was
     vmstat-make-vmstat_update-deferrable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: vmstat: make vmstat_update deferrable

0eb77e988032 ("vmstat: make vmstat_updater deferrable again and shut down
on idle") made vmstat_shepherd deferrable.  vmstat_update itself is still
useing standard timer which might interrupt idle task.  This is possible
because "mm, vmstat: make quiet_vmstat lighter" removed
cancel_delayed_work from the quiet_vmstat.  Change vmstat_work to use
DEFERRABLE_WORK to prevent from pointless wakeups from the idle context.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-make-vmstat_update-deferrable mm/vmstat.c
--- a/mm/vmstat.c~vmstat-make-vmstat_update-deferrable
+++ a/mm/vmstat.c
@@ -1512,7 +1512,7 @@ static void __init start_shepherd_timer(
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		INIT_DELAYED_WORK(per_cpu_ptr(&vmstat_work, cpu),
+		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
 			vmstat_update);
 
 	if (!alloc_cpumask_var(&cpu_stat_off, GFP_KERNEL))
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-report-success-failure-fix-2.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

