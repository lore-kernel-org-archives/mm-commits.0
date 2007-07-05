From: akpm@linux-foundation.org
Subject: + scheduler-profiling-use-immediate-values.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:22:09 -0700
Message-ID: <200707052022.l65KM9fe017132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760100AbXGEUWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Scheduler profiling: use immediate values
has been added to the -mm tree.  Its filename is
     scheduler-profiling-use-immediate-values.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Scheduler profiling: use immediate values
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Use immediate values with lower d-cache hit in optimized version as a
condition for scheduler profiling call.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/svm.c       |    2 +-
 drivers/kvm/vmx.c       |    2 +-
 include/linux/profile.h |    9 +++------
 kernel/profile.c        |   37 +++++++++++++++++++++++++------------
 kernel/sched.c          |    3 ++-
 5 files changed, 32 insertions(+), 21 deletions(-)

diff -puN drivers/kvm/svm.c~scheduler-profiling-use-immediate-values drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~scheduler-profiling-use-immediate-values
+++ a/drivers/kvm/svm.c
@@ -1654,7 +1654,7 @@ again:
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING))
+	if (unlikely(immediate(kvm_profiling)))
 		profile_hit(KVM_PROFILING,
 			(void *)(unsigned long)vcpu->svm->vmcb->save.rip);
 
diff -puN drivers/kvm/vmx.c~scheduler-profiling-use-immediate-values drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~scheduler-profiling-use-immediate-values
+++ a/drivers/kvm/vmx.c
@@ -2156,7 +2156,7 @@ again:
 	/*
 	 * Profile KVM exit RIPs:
 	 */
-	if (unlikely(prof_on == KVM_PROFILING))
+	if (unlikely(immediate(kvm_profiling)))
 		profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
 
 	vcpu->launched = 1;
diff -puN include/linux/profile.h~scheduler-profiling-use-immediate-values include/linux/profile.h
--- a/include/linux/profile.h~scheduler-profiling-use-immediate-values
+++ a/include/linux/profile.h
@@ -10,7 +10,8 @@
 
 #include <asm/errno.h>
 
-extern int prof_on __read_mostly;
+extern immediate_t __read_mostly sleep_profiling, sched_profiling, kvm_profiling,
+		cpu_profiling;
 
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
@@ -35,11 +36,7 @@ void profile_hits(int, void *ip, unsigne
  */
 static inline void profile_hit(int type, void *ip)
 {
-	/*
-	 * Speedup for the common (no profiling enabled) case:
-	 */
-	if (unlikely(prof_on == type))
-		profile_hits(type, ip, 1);
+	profile_hits(type, ip, 1);
 }
 
 #ifdef CONFIG_PROC_FS
diff -puN kernel/profile.c~scheduler-profiling-use-immediate-values kernel/profile.c
--- a/kernel/profile.c~scheduler-profiling-use-immediate-values
+++ a/kernel/profile.c
@@ -23,6 +23,7 @@
 #include <linux/profile.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
+#include <linux/immediate.h>
 #include <asm/sections.h>
 #include <asm/semaphore.h>
 #include <asm/irq_regs.h>
@@ -42,9 +43,6 @@ int (*timer_hook)(struct pt_regs *) __re
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
 
-int prof_on __read_mostly;
-EXPORT_SYMBOL_GPL(prof_on);
-
 static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
@@ -52,6 +50,12 @@ static DEFINE_PER_CPU(int, cpu_profile_f
 static DEFINE_MUTEX(profile_flip_mutex);
 #endif /* CONFIG_SMP */
 
+/* Immediate values */
+immediate_t __read_mostly sleep_profiling, sched_profiling, kvm_profiling,
+	cpu_profiling;
+EXPORT_SYMBOL_GPL(kvm_profiling);
+EXPORT_SYMBOL_GPL(cpu_profiling);
+
 static int __init profile_setup(char * str)
 {
 	static char __initdata schedstr[] = "schedule";
@@ -60,7 +64,7 @@ static int __init profile_setup(char * s
 	int par;
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
-		prof_on = SLEEP_PROFILING;
+		immediate_arm(&sleep_profiling);
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
@@ -69,7 +73,7 @@ static int __init profile_setup(char * s
 			"kernel sleep profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
-		prof_on = SCHED_PROFILING;
+		immediate_arm(&sched_profiling);
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
@@ -78,7 +82,7 @@ static int __init profile_setup(char * s
 			"kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
-		prof_on = KVM_PROFILING;
+		immediate_arm(&kvm_profiling);
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
@@ -88,7 +92,7 @@ static int __init profile_setup(char * s
 			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
-		prof_on = CPU_PROFILING;
+		immediate_arm(&cpu_profiling);
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
@@ -99,7 +103,10 @@ __setup("profile=", profile_setup);
 
 void __init profile_init(void)
 {
-	if (!prof_on) 
+	if (!immediate_query(&sleep_profiling) &&
+		!immediate_query(&sched_profiling) &&
+		!immediate_query(&kvm_profiling) &&
+		!immediate_query(&cpu_profiling))
 		return;
  
 	/* only text is profiled */
@@ -288,7 +295,7 @@ void profile_hits(int type, void *__pc, 
 	int i, j, cpu;
 	struct profile_hit *hits;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
@@ -398,7 +405,7 @@ void profile_hits(int type, void *__pc, 
 {
 	unsigned long pc;
 
-	if (prof_on != type || !prof_buffer)
+	if (!prof_buffer)
 		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
@@ -555,7 +562,10 @@ static int __init create_hash_tables(voi
 	}
 	return 0;
 out_cleanup:
-	prof_on = 0;
+	immediate_disarm(&sleep_profiling);
+	immediate_disarm(&sched_profiling);
+	immediate_disarm(&kvm_profiling);
+	immediate_disarm(&cpu_profiling);
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 0, 1);
 	for_each_online_cpu(cpu) {
@@ -582,7 +592,10 @@ static int __init create_proc_profile(vo
 {
 	struct proc_dir_entry *entry;
 
-	if (!prof_on)
+	if (!immediate_query(&sleep_profiling) &&
+		!immediate_query(&sched_profiling) &&
+		!immediate_query(&kvm_profiling) &&
+		!immediate_query(&cpu_profiling))
 		return 0;
 	if (create_hash_tables())
 		return -1;
diff -puN kernel/sched.c~scheduler-profiling-use-immediate-values kernel/sched.c
--- a/kernel/sched.c~scheduler-profiling-use-immediate-values
+++ a/kernel/sched.c
@@ -3233,7 +3233,8 @@ static inline void schedule_debug(struct
 	if (unlikely(in_atomic_preempt_off()) && unlikely(!prev->exit_state))
 		__schedule_bug(prev);
 
-	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
+	if (unlikely(immediate(sched_profiling)))
+		profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
 	schedstat_inc(this_rq(), sched_cnt);
 }
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
