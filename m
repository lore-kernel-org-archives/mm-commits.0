From: akpm@linux-foundation.org
Subject: - rdmsr_on_cpu-wrmsr_on_cpu.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:32:43 -0800
Message-ID: <200702082132.l18LWhl4027000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40530 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423421AbXBHVcz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:32:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@openvz.org, ak@suse.de, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     rdmsr_on_cpu, wrmsr_on_cpu
has been removed from the -mm tree.  Its filename was
     rdmsr_on_cpu-wrmsr_on_cpu.patch

This patch was dropped because I've lost the plot on this thing

------------------------------------------------------
Subject: rdmsr_on_cpu, wrmsr_on_cpu
From: Alexey Dobriyan <adobriyan@openvz.org>

There was OpenVZ specific bug rendering some cpufreq drivers unusable on SMP. 
In short, when cpufreq code thinks it confined itself to needed cpu by means
of set_cpus_allowed() to execute rdmsr, some "virtual cpu" feature can migrate
process to anywhere.  This triggers bugons and does wrong things in general.

This got fixed by introducing rdmsr_on_cpu and wrmsr_on_cpu executing rdmsr
and wrmsr on given physical cpu by means of smp_call_function_single().

Dave Jones mentioned cpufreq might be not only user of rdmsr_on_cpu() and
wrmsr_on_cpu(), so I'm putting them into arch/{i386,x86_64}/lib/ .

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Acked-by: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lib/Makefile       |    2 
 arch/i386/lib/msr-on-cpu.c   |   70 +++++++++++++++++++++++++++++++++
 arch/x86_64/lib/Makefile     |    2 
 arch/x86_64/lib/msr-on-cpu.c |    1 
 include/asm-i386/msr.h       |    3 +
 include/asm-x86_64/msr.h     |    2 
 6 files changed, 79 insertions(+), 1 deletion(-)

diff -puN arch/i386/lib/Makefile~rdmsr_on_cpu-wrmsr_on_cpu arch/i386/lib/Makefile
--- a/arch/i386/lib/Makefile~rdmsr_on_cpu-wrmsr_on_cpu
+++ a/arch/i386/lib/Makefile
@@ -7,3 +7,5 @@ lib-y = checksum.o delay.o usercopy.o ge
 	bitops.o semaphore.o
 
 lib-$(CONFIG_X86_USE_3DNOW) += mmx.o
+
+obj-y = msr-on-cpu.o
diff -puN /dev/null arch/i386/lib/msr-on-cpu.c
--- /dev/null
+++ a/arch/i386/lib/msr-on-cpu.c
@@ -0,0 +1,70 @@
+#include <linux/module.h>
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <asm/msr.h>
+
+#ifdef CONFIG_SMP
+struct msr_info {
+	u32 msr_no;
+	u32 l, h;
+};
+
+static void __rdmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	rdmsr(rv->msr_no, rv->l, rv->h);
+}
+
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	preempt_disable();
+	if (smp_processor_id() == cpu)
+		rdmsr(msr_no, *l, *h);
+	else {
+		struct msr_info rv;
+
+		rv.msr_no = msr_no;
+		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
+		*l = rv.l;
+		*h = rv.h;
+	}
+	preempt_enable();
+}
+
+static void __wrmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	wrmsr(rv->msr_no, rv->l, rv->h);
+}
+
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	preempt_disable();
+	if (smp_processor_id() == cpu)
+		wrmsr(msr_no, l, h);
+	else {
+		struct msr_info rv;
+
+		rv.msr_no = msr_no;
+		rv.l = l;
+		rv.h = h;
+		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
+	}
+	preempt_enable();
+}
+#else
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	rdmsr(msr_no, *l, *h);
+}
+
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	wrmsr(msr_no, l, h);
+}
+#endif
+
+EXPORT_SYMBOL(rdmsr_on_cpu);
+EXPORT_SYMBOL(wrmsr_on_cpu);
diff -puN arch/x86_64/lib/Makefile~rdmsr_on_cpu-wrmsr_on_cpu arch/x86_64/lib/Makefile
--- a/arch/x86_64/lib/Makefile~rdmsr_on_cpu-wrmsr_on_cpu
+++ a/arch/x86_64/lib/Makefile
@@ -4,7 +4,7 @@
 
 CFLAGS_csum-partial.o := -funroll-loops
 
-obj-y := io.o iomap_copy.o
+obj-y := io.o iomap_copy.o msr-on-cpu.o
 
 lib-y := csum-partial.o csum-copy.o csum-wrappers.o delay.o \
 	usercopy.o getuser.o putuser.o  \
diff -puN /dev/null arch/x86_64/lib/msr-on-cpu.c
--- /dev/null
+++ a/arch/x86_64/lib/msr-on-cpu.c
@@ -0,0 +1 @@
+#include "../../i386/lib/msr-on-cpu.c"
diff -puN include/asm-i386/msr.h~rdmsr_on_cpu-wrmsr_on_cpu include/asm-i386/msr.h
--- a/include/asm-i386/msr.h~rdmsr_on_cpu-wrmsr_on_cpu
+++ a/include/asm-i386/msr.h
@@ -83,6 +83,9 @@ static inline void wrmsrl (unsigned long
 			  : "c" (counter))
 #endif	/* !CONFIG_PARAVIRT */
 
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+
 /* symbolic names for some interesting MSRs */
 /* Intel defined MSRs. */
 #define MSR_IA32_P5_MC_ADDR		0
diff -puN include/asm-x86_64/msr.h~rdmsr_on_cpu-wrmsr_on_cpu include/asm-x86_64/msr.h
--- a/include/asm-x86_64/msr.h~rdmsr_on_cpu-wrmsr_on_cpu
+++ a/include/asm-x86_64/msr.h
@@ -160,6 +160,8 @@ static inline unsigned int cpuid_edx(uns
 #define MSR_IA32_UCODE_WRITE		0x79
 #define MSR_IA32_UCODE_REV		0x8b
 
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 
 #endif
 
_

Patches currently in -mm which might be from adobriyan@openvz.org are

git-net.patch
revert-x86_64-mm-msr-on-cpu.patch
rdmsr_on_cpu-wrmsr_on_cpu.patch
p4-clockmod-use-rdmsr_on_cpu-wrmsr_on_cpu.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
consolidate-default-sched_clock.patch
fix-rmmod-read-write-races-in-proc-entries.patch
sn2-use-static-proc_fops.patch
consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
