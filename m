From: akpm@linux-foundation.org
Subject: [folded-merged] vmstat-on-demand-vmstat-workers-v8-fix-2.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 13:46:02 -0700
Message-ID: <5436f40a.Q0K27Zmvv4jFMpNj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaJIUqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@gentwo.org, cl@linux.com, gilad@benyossef.com, sasha.levin@oracle.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat ondemand: fix online/offline races
has been removed from the -mm tree.  Its filename was
     vmstat-on-demand-vmstat-workers-v8-fix-2.patch

This patch was dropped because it was folded into vmstat-on-demand-vmstat-workers-v8.patch

------------------------------------------------------
From: Christoph Lameter <cl@gentwo.org>
Subject: vmstat ondemand: fix online/offline races

Do not allow onlining/offlining while the shepherd task is checking
for vmstat threads.

On offlining a processor do the right thing cancelling the vmstat
worker thread if it exista and also exclude it from the shepherd
process checks.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/vmstat.c~vmstat-on-demand-vmstat-workers-v8-fix-2 mm/vmstat.c
--- a/mm/vmstat.c~vmstat-on-demand-vmstat-workers-v8-fix-2
+++ a/mm/vmstat.c
@@ -1327,6 +1327,7 @@ static void vmstat_shepherd(struct work_
 {
 	int cpu;
 
+	get_online_cpus();
 	/* Check processors whose vmstat worker threads have been disabled */
 	for_each_cpu(cpu, cpu_stat_off)
 		if (need_update(cpu) &&
@@ -1335,6 +1336,7 @@ static void vmstat_shepherd(struct work_
 			schedule_delayed_work_on(cpu, &per_cpu(vmstat_work, cpu),
 				__round_jiffies_relative(sysctl_stat_interval, cpu));
 
+	put_online_cpus();
 
 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
@@ -1390,8 +1392,8 @@ static int vmstat_cpuup_callback(struct
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
-		if (!cpumask_test_and_set_cpu(cpu, cpu_stat_off))
-			cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
+		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
+		cpumask_clear_cpu(cpu, cpu_stat_off);
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
_

Patches currently in -mm which might be from cl@gentwo.org are

vmstat-on-demand-vmstat-workers-v8.patch

