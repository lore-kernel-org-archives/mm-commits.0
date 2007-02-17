From: akpm@linux-foundation.org
Subject: - i386-remove-useless-code-in-tscc.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:42 -0800
Message-ID: <200702170713.l1H7DgbU021472@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51316 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946580AbXBQHTq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:19:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     i386 Remove useless code in tsc.c
has been removed from the -mm tree.  Its filename was
     i386-remove-useless-code-in-tscc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 Remove useless code in tsc.c
From: Thomas Gleixner <tglx@linutronix.de>

The delayed work code in arch/i386/kernel/tsc.c is an unused leftover of the
GTOD conversion. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c |   40 +--------------------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff -puN arch/i386/kernel/tsc.c~i386-remove-useless-code-in-tscc arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~i386-remove-useless-code-in-tscc
+++ a/arch/i386/kernel/tsc.c
@@ -222,34 +222,6 @@ out_no_tsc:
 
 #ifdef CONFIG_CPU_FREQ
 
-static unsigned int cpufreq_delayed_issched = 0;
-static unsigned int cpufreq_init = 0;
-static struct work_struct cpufreq_delayed_get_work;
-
-static void handle_cpufreq_delayed_get(struct work_struct *work)
-{
-	unsigned int cpu;
-
-	for_each_online_cpu(cpu)
-		cpufreq_get(cpu);
-
-	cpufreq_delayed_issched = 0;
-}
-
-/*
- * if we notice cpufreq oddness, schedule a call to cpufreq_get() as it tries
- * to verify the CPU frequency the timing core thinks the CPU is running
- * at is still correct.
- */
-static inline void cpufreq_delayed_get(void)
-{
-	if (cpufreq_init && !cpufreq_delayed_issched) {
-		cpufreq_delayed_issched = 1;
-		printk(KERN_DEBUG "Checking if CPU frequency changed.\n");
-		schedule_work(&cpufreq_delayed_get_work);
-	}
-}
-
 /*
  * if the CPU frequency is scaled, TSC-based delays will need a different
  * loops_per_jiffy value to function properly.
@@ -313,17 +285,9 @@ static struct notifier_block time_cpufre
 
 static int __init cpufreq_tsc(void)
 {
-	int ret;
-
-	INIT_WORK(&cpufreq_delayed_get_work, handle_cpufreq_delayed_get);
-	ret = cpufreq_register_notifier(&time_cpufreq_notifier_block,
-					CPUFREQ_TRANSITION_NOTIFIER);
-	if (!ret)
-		cpufreq_init = 1;
-
-	return ret;
+	return cpufreq_register_notifier(&time_cpufreq_notifier_block,
+					 CPUFREQ_TRANSITION_NOTIFIER);
 }
-
 core_initcall(cpufreq_tsc);
 
 #endif
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
