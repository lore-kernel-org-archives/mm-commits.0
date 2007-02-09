From: akpm@linux-foundation.org
Subject: + revert-x86_64-mm-msr-on-cpu.patch added to -mm tree
Date: Thu, 08 Feb 2007 17:04:22 -0800
Message-ID: <200702090105.l1915TXB000533@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47912 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945973AbXBIBFi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 20:05:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@openvz.org, ak@suse.de, davej@codemonkey.org.uk


The patch titled
     revert x86_64-mm-msr-on-cpu
has been added to the -mm tree.  Its filename is
     revert-x86_64-mm-msr-on-cpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert x86_64-mm-msr-on-cpu
From: Andrew Morton <akpm@linux-foundation.org>

busted.  Go back to Alexey's later patch.

Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/p4-clockmod.c |   30 ++++++--
 arch/i386/lib/Makefile                     |    2 
 arch/i386/lib/msr-on-cpu.c                 |   70 -------------------
 arch/x86_64/lib/Makefile                   |    4 -
 include/asm-i386/msr.h                     |    3 
 5 files changed, 25 insertions(+), 84 deletions(-)

diff -puN arch/i386/kernel/cpu/cpufreq/p4-clockmod.c~revert-x86_64-mm-msr-on-cpu arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
--- a/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c~revert-x86_64-mm-msr-on-cpu
+++ a/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
@@ -62,7 +62,7 @@ static int cpufreq_p4_setdc(unsigned int
 	if (!cpu_online(cpu) || (newstate > DC_DISABLE) || (newstate == DC_RESV))
 		return -EINVAL;
 
-	rdmsr_on_cpu(cpu, MSR_IA32_THERM_STATUS, &l, &h);
+	rdmsr(MSR_IA32_THERM_STATUS, l, h);
 
 	if (l & 0x01)
 		dprintk("CPU#%d currently thermal throttled\n", cpu);
@@ -70,10 +70,10 @@ static int cpufreq_p4_setdc(unsigned int
 	if (has_N44_O17_errata[cpu] && (newstate == DC_25PT || newstate == DC_DFLT))
 		newstate = DC_38PT;
 
-	rdmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, &l, &h);
+	rdmsr(MSR_IA32_THERM_CONTROL, l, h);
 	if (newstate == DC_DISABLE) {
 		dprintk("CPU#%d disabling modulation\n", cpu);
-		wrmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, l & ~(1<<4), h);
+		wrmsr(MSR_IA32_THERM_CONTROL, l & ~(1<<4), h);
 	} else {
 		dprintk("CPU#%d setting duty cycle to %d%%\n",
 			cpu, ((125 * newstate) / 10));
@@ -84,7 +84,7 @@ static int cpufreq_p4_setdc(unsigned int
 		 */
 		l = (l & ~14);
 		l = l | (1<<4) | ((newstate & 0x7)<<1);
-		wrmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, l, h);
+		wrmsr(MSR_IA32_THERM_CONTROL, l, h);
 	}
 
 	return 0;
@@ -111,6 +111,7 @@ static int cpufreq_p4_target(struct cpuf
 {
 	unsigned int    newstate = DC_RESV;
 	struct cpufreq_freqs freqs;
+	cpumask_t cpus_allowed;
 	int i;
 
 	if (cpufreq_frequency_table_target(policy, &p4clockmod_table[0], target_freq, relation, &newstate))
@@ -131,8 +132,17 @@ static int cpufreq_p4_target(struct cpuf
 	/* run on each logical CPU, see section 13.15.3 of IA32 Intel Architecture Software
 	 * Developer's Manual, Volume 3
 	 */
-	for_each_cpu_mask(i, policy->cpus)
+	cpus_allowed = current->cpus_allowed;
+
+	for_each_cpu_mask(i, policy->cpus) {
+		cpumask_t this_cpu = cpumask_of_cpu(i);
+
+		set_cpus_allowed(current, this_cpu);
+		BUG_ON(smp_processor_id() != i);
+
 		cpufreq_p4_setdc(i, p4clockmod_table[newstate].index);
+	}
+	set_cpus_allowed(current, cpus_allowed);
 
 	/* notifiers */
 	for_each_cpu_mask(i, policy->cpus) {
@@ -246,9 +256,17 @@ static int cpufreq_p4_cpu_exit(struct cp
 
 static unsigned int cpufreq_p4_get(unsigned int cpu)
 {
+	cpumask_t cpus_allowed;
 	u32 l, h;
 
-	rdmsr_on_cpu(cpu, MSR_IA32_THERM_CONTROL, &l, &h);
+	cpus_allowed = current->cpus_allowed;
+
+	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	BUG_ON(smp_processor_id() != cpu);
+
+	rdmsr(MSR_IA32_THERM_CONTROL, l, h);
+
+	set_cpus_allowed(current, cpus_allowed);
 
 	if (l & 0x10) {
 		l = l >> 1;
diff -puN arch/i386/lib/Makefile~revert-x86_64-mm-msr-on-cpu arch/i386/lib/Makefile
--- a/arch/i386/lib/Makefile~revert-x86_64-mm-msr-on-cpu
+++ a/arch/i386/lib/Makefile
@@ -7,5 +7,3 @@ lib-y = checksum.o delay.o usercopy.o ge
 	bitops.o semaphore.o
 
 lib-$(CONFIG_X86_USE_3DNOW) += mmx.o
-
-obj-y = msr-on-cpu.o
diff -puN arch/i386/lib/msr-on-cpu.c~revert-x86_64-mm-msr-on-cpu /dev/null
--- a/arch/i386/lib/msr-on-cpu.c
+++ /dev/null
@@ -1,70 +0,0 @@
-#include <linux/module.h>
-#include <linux/preempt.h>
-#include <linux/smp.h>
-#include <asm/msr.h>
-
-#ifdef CONFIG_SMP
-struct msr_info {
-	u32 msr_no;
-	u32 l, h;
-};
-
-static void __rdmsr_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-
-	rdmsr(rv->msr_no, rv->l, rv->h);
-}
-
-void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	preempt_disable();
-	if (smp_processor_id() == cpu)
-		rdmsr(msr_no, *l, *h);
-	else {
-		struct msr_info rv;
-
-		rv.msr_no = msr_no;
-		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
-		*l = rv.l;
-		*h = rv.h;
-	}
-	preempt_enable();
-}
-
-static void __wrmsr_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-
-	wrmsr(rv->msr_no, rv->l, rv->h);
-}
-
-void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	preempt_disable();
-	if (smp_processor_id() == cpu)
-		wrmsr(msr_no, l, h);
-	else {
-		struct msr_info rv;
-
-		rv.msr_no = msr_no;
-		rv.l = l;
-		rv.h = h;
-		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
-	}
-	preempt_enable();
-}
-#else
-void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	rdmsr(msr_no, *l, *h);
-}
-
-void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	wrmsr(msr_no, l, h);
-}
-#endif
-
-EXPORT_SYMBOL(rdmsr_on_cpu);
-EXPORT_SYMBOL(wrmsr_on_cpu);
diff -puN arch/x86_64/lib/Makefile~revert-x86_64-mm-msr-on-cpu arch/x86_64/lib/Makefile
--- a/arch/x86_64/lib/Makefile~revert-x86_64-mm-msr-on-cpu
+++ a/arch/x86_64/lib/Makefile
@@ -4,12 +4,10 @@
 
 CFLAGS_csum-partial.o := -funroll-loops
 
-obj-y := io.o iomap_copy.o msr-on-cpu.o
+obj-y := io.o iomap_copy.o
 
 lib-y := csum-partial.o csum-copy.o csum-wrappers.o delay.o \
 	usercopy.o getuser.o putuser.o  \
 	thunk.o clear_page.o copy_page.o bitstr.o bitops.o
 lib-y += memcpy.o memmove.o memset.o copy_user.o rwlock.o copy_user_nocache.o
 lib-y += memcpy_uncached_read.o
-
-msr-on-cpu-y += ../../i386/lib/msr-on-cpu.o
diff -puN include/asm-i386/msr.h~revert-x86_64-mm-msr-on-cpu include/asm-i386/msr.h
--- a/include/asm-i386/msr.h~revert-x86_64-mm-msr-on-cpu
+++ a/include/asm-i386/msr.h
@@ -83,9 +83,6 @@ static inline void wrmsrl (unsigned long
 			  : "c" (counter))
 #endif	/* !CONFIG_PARAVIRT */
 
-void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
-void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-
 /* symbolic names for some interesting MSRs */
 /* Intel defined MSRs. */
 #define MSR_IA32_P5_MC_ADDR		0
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-bay-driver-warning-fix.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-backlight-acpi-fix.patch
git-backlight-asus-fix.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
deprecate-sa_interrupt-and-friends.patch
