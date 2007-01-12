From: akpm@osdl.org
Subject: - change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:17:46 -0800
Message-ID: <200701122217.l0CMHkHR030751@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161145AbXALWTD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:19:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, benh@kernel.crashing.org, davem@davemloft.net, kyle@mcmartin.ca, paulus@samba.org, ralf@linux-mips.org, starvik@axis.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Change cpu_up and co from __devinit to __cpuinit
has been removed from the -mm tree.  Its filename was
     change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Change cpu_up and co from __devinit to __cpuinit
From: Gautham R Shenoy <ego@in.ibm.com>

Compiling the kernel with CONFIG_HOTPLUG = y and CONFIG_HOTPLUG_CPU = n
with CONFIG_RELOCATABLE = y generates the following modpost warnings

WARNING: vmlinux - Section mismatch: reference to .init.data: from
.text between '_cpu_up' (at offset 0xc0141b7d) and 'cpu_up'
WARNING: vmlinux - Section mismatch: reference to .init.data: from
.text between '_cpu_up' (at offset 0xc0141b9c) and 'cpu_up'
WARNING: vmlinux - Section mismatch: reference to .init.text:__cpu_up
from .text between '_cpu_up' (at offset 0xc0141bd8) and 'cpu_up'
WARNING: vmlinux - Section mismatch: reference to .init.data: from
.text between '_cpu_up' (at offset 0xc0141c05) and 'cpu_up'
WARNING: vmlinux - Section mismatch: reference to .init.data: from
.text between '_cpu_up' (at offset 0xc0141c26) and 'cpu_up'
WARNING: vmlinux - Section mismatch: reference to .init.data: from
.text between '_cpu_up' (at offset 0xc0141c37) and 'cpu_up'

This is because cpu_up, _cpu_up and __cpu_up (in some architectures) are
defined as __devinit
AND
__cpu_up calls some __cpuinit functions.

Since __cpuinit would map to __init with this kind of a configuration,
we get a .text refering .init.data warning.

This patch solves the problem by converting all of __cpu_up, _cpu_up
and cpu_up from __devinit to __cpuinit. The approach is justified since
the callers of cpu_up are either dependent on CONFIG_HOTPLUG_CPU or
are of __init type.

Thus when CONFIG_HOTPLUG_CPU=y, all these cpu up functions would land up
in .text section, and when CONFIG_HOTPLUG_CPU=n, all these functions would
land up in .init section.

Tested on a i386 SMP machine running linux-2.6.20-rc3-mm1.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/cris/arch-v32/kernel/smp.c |    2 +-
 arch/m32r/kernel/smpboot.c      |    2 +-
 arch/mips/kernel/smp.c          |    2 +-
 arch/parisc/kernel/smp.c        |    2 +-
 arch/powerpc/kernel/smp.c       |    2 +-
 arch/sparc64/kernel/smp.c       |    2 +-
 kernel/cpu.c                    |    4 ++--
 7 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/cris/arch-v32/kernel/smp.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit arch/cris/arch-v32/kernel/smp.c
--- a/arch/cris/arch-v32/kernel/smp.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit
+++ a/arch/cris/arch-v32/kernel/smp.c
@@ -195,7 +195,7 @@ int setup_profiling_timer(unsigned int m
  */
 unsigned long cache_decay_ticks = 1;
 
-int __devinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu)
 {
 	smp_boot_one_cpu(cpu);
 	return cpu_online(cpu) ? 0 : -ENOSYS;
diff -puN arch/m32r/kernel/smpboot.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit arch/m32r/kernel/smpboot.c
--- a/arch/m32r/kernel/smpboot.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit
+++ a/arch/m32r/kernel/smpboot.c
@@ -351,7 +351,7 @@ static void __init do_boot_cpu(int phys_
 	}
 }
 
-int __devinit __cpu_up(unsigned int cpu_id)
+int __cpuinit __cpu_up(unsigned int cpu_id)
 {
 	int timeout;
 
diff -puN arch/mips/kernel/smp.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit arch/mips/kernel/smp.c
--- a/arch/mips/kernel/smp.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit
+++ a/arch/mips/kernel/smp.c
@@ -271,7 +271,7 @@ void __devinit smp_prepare_boot_cpu(void
  * and keep control until "cpu_online(cpu)" is set.  Note: cpu is
  * physical, not logical.
  */
-int __devinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu)
 {
 	struct task_struct *idle;
 
diff -puN arch/parisc/kernel/smp.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit arch/parisc/kernel/smp.c
--- a/arch/parisc/kernel/smp.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit
+++ a/arch/parisc/kernel/smp.c
@@ -608,7 +608,7 @@ void smp_cpus_done(unsigned int cpu_max)
 }
 
 
-int __devinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu)
 {
 	if (cpu != 0 && cpu < parisc_max_cpus)
 		smp_boot_one_cpu(cpu);
diff -puN arch/powerpc/kernel/smp.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit
+++ a/arch/powerpc/kernel/smp.c
@@ -468,7 +468,7 @@ static int __devinit cpu_enable(unsigned
 	return -ENOSYS;
 }
 
-int __devinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu)
 {
 	int c;
 
diff -puN arch/sparc64/kernel/smp.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit arch/sparc64/kernel/smp.c
--- a/arch/sparc64/kernel/smp.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit
+++ a/arch/sparc64/kernel/smp.c
@@ -1388,7 +1388,7 @@ void __devinit smp_prepare_boot_cpu(void
 {
 }
 
-int __devinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu)
 {
 	int ret = smp_boot_one_cpu(cpu);
 
diff -puN kernel/cpu.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit kernel/cpu.c
--- a/kernel/cpu.c~change-cpu_up-and-co-from-__devinit-to-__cpuinit
+++ a/kernel/cpu.c
@@ -204,7 +204,7 @@ int cpu_down(unsigned int cpu)
 #endif /*CONFIG_HOTPLUG_CPU*/
 
 /* Requires cpu_add_remove_lock to be held */
-static int __devinit _cpu_up(unsigned int cpu)
+static int __cpuinit _cpu_up(unsigned int cpu)
 {
 	int ret;
 	void *hcpu = (void *)(long)cpu;
@@ -239,7 +239,7 @@ out_notify:
 	return ret;
 }
 
-int __devinit cpu_up(unsigned int cpu)
+int __cpuinit cpu_up(unsigned int cpu)
 {
 	int err = 0;
 
_

Patches currently in -mm which might be from ego@in.ibm.com are

rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
ondemand-governor-restructure-the-work-callback.patch
ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
handle-cpu_lock_acquire-and-cpu_lock_release-in-workqueue_cpu_callback.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
