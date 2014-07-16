From: akpm@linux-foundation.org
Subject: +
 vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch added to -mm tree
Date: Wed, 16 Jul 2014 15:00:02 -0700
Message-ID: <53c6f5e2.zirs9RlXrjYdADLm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:41982 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaGPWAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 18:00:04 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so170069igd.4
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 15:00:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@gentwo.org, cl@linux.com, fweisbec@gmail.com, gilad@benyossef.com, hakanakkan@gmail.com, hpa@zytor.com, hughd@google.com, johnstul@us.ibm.com, maxk@qualcomm.com, minchan.kim@gmail.com, mingo@kernel.org, paulmck@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de, tj@kernel.org, vapier@gentoo.org, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: on demand vmstat: Do not open code alloc_cpumask_var
has been added to the -mm tree.  Its filename is
     vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch

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
Subject: on demand vmstat: Do not open code alloc_cpumask_var

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmstat.c~vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var mm/vmstat.c
--- a/mm/vmstat.c~vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var
+++ a/mm/vmstat.c
@@ -1245,7 +1245,7 @@ static const struct file_operations proc
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
-struct cpumask *cpu_stat_off;
+cpumask_var_t cpu_stat_off;
 
 static void vmstat_update(struct work_struct *w)
 {
@@ -1339,7 +1339,8 @@ static void __init start_shepherd_timer(
 		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
 			vmstat_update);
 
-	cpu_stat_off = kmalloc(cpumask_size(), GFP_KERNEL);
+	if (!alloc_cpumask_var(&cpu_stat_off, GFP_KERNEL))
+		BUG();
 	cpumask_copy(cpu_stat_off, cpu_online_mask);
 
 	schedule_delayed_work(&shepherd,
_

Patches currently in -mm which might be from cl@gentwo.org are

slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
linux-next.patch

