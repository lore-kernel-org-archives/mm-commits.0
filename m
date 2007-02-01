From: akpm@osdl.org
Subject: + p4-clockmod-use-rdmsr_on_cpu-wrmsr_on_cpu.patch added to -mm tree
Date: Thu, 01 Feb 2007 13:40:27 -0800
Message-ID: <200702012140.l11LeRvq023650@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40671 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbXBAVkg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 16:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@openvz.org, ak@suse.de, davej@codemonkey.org.uk


The patch titled
     p4-clockmod: use rdmsr_on_cpu(), wrmsr_on_cpu()
has been added to the -mm tree.  Its filename is
     p4-clockmod-use-rdmsr_on_cpu-wrmsr_on_cpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: p4-clockmod: use rdmsr_on_cpu(), wrmsr_on_cpu()
From: Alexey Dobriyan <adobriyan@openvz.org>

Dances with cpu masks go away.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/cpufreq/p4-clockmod.c |   30 +++----------------
 1 files changed, 6 insertions(+), 24 deletions(-)

diff -puN arch/i386/kernel/cpu/cpufreq/p4-clockmod.c~p4-clockmod-use-rdmsr_on_cpu-wrmsr_on_cpu arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
--- a/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c~p4-clockmod-use-rdmsr_on_cpu-wrmsr_on_cpu
+++ a/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
@@ -62,7 +62,7 @@ static int cpufreq_p4_setdc(unsigned int
 	if (!cpu_online(cpu) || (newstate > DC_DISABLE) || (newstate == DC_RESV))
 		return -EINVAL;
 
-	rdmsr(MSR_IA32_THERM_STATUS, l, h);
+	rdmsr_on_cpu(cpu, MSR_IA32_THERM_STATUS, &l, &h);
 
 	if (l & 0x01)
 		dprintk("CPU#%d currently thermal throttled\n", cpu);
@@ -70,10 +70,10 @@ static int cpufreq_p4_setdc(unsigned int
 	if (has_N44_O17_errata[cpu] && (newstate == DC_25PT || newstate == DC_DFLT))
 		newstate = DC_38PT;
 
-	rdmsr(MSR_IA32_THERM_CONTROL, l, h);
+	rdmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, &l, &h);
 	if (newstate == DC_DISABLE) {
 		dprintk("CPU#%d disabling modulation\n", cpu);
-		wrmsr(MSR_IA32_THERM_CONTROL, l & ~(1<<4), h);
+		wrmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, l & ~(1<<4), h);
 	} else {
 		dprintk("CPU#%d setting duty cycle to %d%%\n",
 			cpu, ((125 * newstate) / 10));
@@ -84,7 +84,7 @@ static int cpufreq_p4_setdc(unsigned int
 		 */
 		l = (l & ~14);
 		l = l | (1<<4) | ((newstate & 0x7)<<1);
-		wrmsr(MSR_IA32_THERM_CONTROL, l, h);
+		wrmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, l, h);
 	}
 
 	return 0;
@@ -111,7 +111,6 @@ static int cpufreq_p4_target(struct cpuf
 {
 	unsigned int    newstate = DC_RESV;
 	struct cpufreq_freqs freqs;
-	cpumask_t cpus_allowed;
 	int i;
 
 	if (cpufreq_frequency_table_target(policy, &p4clockmod_table[0], target_freq, relation, &newstate))
@@ -132,17 +131,8 @@ static int cpufreq_p4_target(struct cpuf
 	/* run on each logical CPU, see section 13.15.3 of IA32 Intel Architecture Software
 	 * Developer's Manual, Volume 3
 	 */
-	cpus_allowed = current->cpus_allowed;
-
-	for_each_cpu_mask(i, policy->cpus) {
-		cpumask_t this_cpu = cpumask_of_cpu(i);
-
-		set_cpus_allowed(current, this_cpu);
-		BUG_ON(smp_processor_id() != i);
-
+	for_each_cpu_mask(i, policy->cpus)
 		cpufreq_p4_setdc(i, p4clockmod_table[newstate].index);
-	}
-	set_cpus_allowed(current, cpus_allowed);
 
 	/* notifiers */
 	for_each_cpu_mask(i, policy->cpus) {
@@ -256,17 +246,9 @@ static int cpufreq_p4_cpu_exit(struct cp
 
 static unsigned int cpufreq_p4_get(unsigned int cpu)
 {
-	cpumask_t cpus_allowed;
 	u32 l, h;
 
-	cpus_allowed = current->cpus_allowed;
-
-	set_cpus_allowed(current, cpumask_of_cpu(cpu));
-	BUG_ON(smp_processor_id() != cpu);
-
-	rdmsr(MSR_IA32_THERM_CONTROL, l, h);
-
-	set_cpus_allowed(current, cpus_allowed);
+	rdmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, &l, &h);
 
 	if (l & 0x10) {
 		l = l >> 1;
_

Patches currently in -mm which might be from adobriyan@openvz.org are

revert-x86_64-mm-msr-on-cpu.patch
rdmsr_on_cpu-wrmsr_on_cpu.patch
p4-clockmod-use-rdmsr_on_cpu-wrmsr_on_cpu.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
consolidate-default-sched_clock.patch
fix-rmmod-read-write-races-in-proc-entries.patch
sn2-use-static-proc_fops.patch
consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
