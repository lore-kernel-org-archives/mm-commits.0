From: akpm@linux-foundation.org
Subject: - cpufreq-bug-using-smp_processor_id-in-preemptible-code.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:39:37 -0700
Message-ID: <200810072339.m97NdcbO009572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757742AbYJGXjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:39:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: BUG: using smp_processor_id() in preemptible code
has been removed from the -mm tree.  Its filename was
     cpufreq-bug-using-smp_processor_id-in-preemptible-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: BUG: using smp_processor_id() in preemptible code
From: Andrea Righi <righi.andrea@gmail.com>

Use get_cpu()/put_cpu() in cpufreq_ondemand init routine, instead of
smp_processor_id() to avoid the following BUG:

[   35.313118] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/4952
[   35.313132] caller is cpufreq_gov_dbs_init+0xa/0x8f [cpufreq_ondemand]
[   35.313140] Pid: 4952, comm: modprobe Not tainted 2.6.27-rc5-mm1 #23
[   35.313145] Call Trace:
[   35.313158]  [<ffffffff80361ff7>] debug_smp_processor_id+0xd7/0xe0
[   35.313167]  [<ffffffffa010800a>] cpufreq_gov_dbs_init+0xa/0x8f [cpufreq_ondemand]
[   35.313176]  [<ffffffff8020903b>] _stext+0x3b/0x160
[   35.313185]  [<ffffffff804768c5>] __mutex_unlock_slowpath+0xe5/0x190
[   35.313195]  [<ffffffff8026236a>] trace_hardirqs_on_caller+0xca/0x140
[   35.313205]  [<ffffffff8026ef4c>] sys_init_module+0xdc/0x210
[   35.313212]  [<ffffffff8020b7cb>] system_call_fastpath+0x16/0x1b

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-bug-using-smp_processor_id-in-preemptible-code drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-bug-using-smp_processor_id-in-preemptible-code
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -638,8 +638,11 @@ static int __init cpufreq_gov_dbs_init(v
 {
 	int err;
 	cputime64_t wall;
-	u64 idle_time = get_cpu_idle_time_us(smp_processor_id(), &wall);
+	u64 idle_time;
+	int cpu = get_cpu();
 
+	idle_time = get_cpu_idle_time_us(cpu, &wall);
+	put_cpu();
 	if (idle_time != -1ULL) {
 		/* Idle micro accounting is supported. Use finer thresholds */
 		dbs_tuners_ins.up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

git-cpufreq.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2.patch

