From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:46:00 -0700
Message-ID: <5436f408.W6YBWkzR6YWp2py9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaJIUqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:46:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@gentwo.org, cl@linux.com, fweisbec@gmail.com, gilad@benyossef.com, hakanakkan@gmail.com, hpa@zytor.com, hughd@google.com, johnstul@us.ibm.com, maxk@qti.qualcomm.com, minchan.kim@gmail.com, mingo@kernel.org, paulmck@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de, tj@kernel.org, vapier@gentoo.org, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: on demand vmstat: Do not open code alloc_cpumask_var
has been removed from the -mm tree.  Its filename was
     vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch

This patch was dropped because it was folded into vmstat-on-demand-vmstat-workers-v8.patch

------------------------------------------------------
From: Christoph Lameter <cl@gentwo.org>
Subject: on demand vmstat: Do not open code alloc_cpumask_var

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Max Krasnyansky <maxk@qti.qualcomm.com>
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
@@ -1255,7 +1255,7 @@ static const struct file_operations proc
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
-static struct cpumask *cpu_stat_off;
+static cpumask_var_t cpu_stat_off;
 
 static void vmstat_update(struct work_struct *w)
 {
@@ -1349,7 +1349,8 @@ static void __init start_shepherd_timer(
 		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
 			vmstat_update);
 
-	cpu_stat_off = kmalloc(cpumask_size(), GFP_KERNEL);
+	if (!alloc_cpumask_var(&cpu_stat_off, GFP_KERNEL))
+		BUG();
 	cpumask_copy(cpu_stat_off, cpu_online_mask);
 
 	schedule_delayed_work(&shepherd,
_

Patches currently in -mm which might be from cl@gentwo.org are

vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch

