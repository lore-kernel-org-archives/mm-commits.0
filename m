From: akpm@linux-foundation.org
Subject: + vmstat-on-demand-vmstat-workers-v8-fix-2.patch added to -mm
 tree
Date: Wed, 06 Aug 2014 12:20:40 -0700
Message-ID: <53e28008.tZK789AUf1VFAXtO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:63020 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaHFTUl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 15:20:41 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so560129iec.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 12:20:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@gentwo.org, cl@linux.com, gilad@benyossef.com, sasha.levin@oracle.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat ondemand: fix online/offline races
has been added to the -mm tree.  Its filename is
     vmstat-on-demand-vmstat-workers-v8-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-on-demand-vmstat-workers-v8-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-on-demand-vmstat-workers-v8-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1317,6 +1317,7 @@ static void vmstat_shepherd(struct work_
 {
 	int cpu;
 
+	get_online_cpus();
 	/* Check processors whose vmstat worker threads have been disabled */
 	for_each_cpu(cpu, cpu_stat_off)
 		if (need_update(cpu) &&
@@ -1325,6 +1326,7 @@ static void vmstat_shepherd(struct work_
 			schedule_delayed_work_on(cpu, &per_cpu(vmstat_work, cpu),
 				__round_jiffies_relative(sysctl_stat_interval, cpu));
 
+	put_online_cpus();
 
 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
@@ -1380,8 +1382,8 @@ static int vmstat_cpuup_callback(struct
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

origin.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path.patch

