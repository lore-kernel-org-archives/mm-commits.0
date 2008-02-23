From: akpm@linux-foundation.org
Subject: + init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:37:20 -0800
Message-ID: <200802230738.m1N7c9PS018640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760233AbYBWIFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:05:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, ak@suse.de, apw@shadowen.org, jschopp@austin.ibm.com, mingo@elte.hu, rdunlap@xenotime.net, tglx@linutronix.de


The patch titled
     init: move setup of nr_cpu_ids to as early as possible
has been added to the -mm tree.  Its filename is
     init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init: move setup of nr_cpu_ids to as early as possible
From: Mike Travis <travis@sgi.com>

Move the setting of nr_cpu_ids from sched_init() to init/main.c,
so that it's available as early as possible.

Based on git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joel Schopp <jschopp@austin.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c    |   20 ++++++++++++++++++++
 kernel/sched.c |    7 -------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff -puN init/main.c~init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3 init/main.c
--- a/init/main.c~init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3
+++ a/init/main.c
@@ -365,10 +365,29 @@ static void __init smp_init(void)
 #endif
 
 static inline void setup_per_cpu_areas(void) { }
+static inline void setup_nr_cpu_ids(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
 
 #else
 
+/*
+ * Setup number of possible processor ids.
+ * This is different than setup_max_cpus as it accounts for zero
+ * bits embedded between one bits in the cpu possible map.
+ */
+int nr_cpu_ids __read_mostly = NR_CPUS;
+EXPORT_SYMBOL(nr_cpu_ids);
+
+static void __init setup_nr_cpu_ids(void)
+{
+	int cpu, highest_cpu = 0;
+
+	for_each_possible_cpu(cpu)
+		highest_cpu = cpu;
+
+	nr_cpu_ids = highest_cpu + 1;
+}
+
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 
@@ -542,6 +561,7 @@ asmlinkage void __init start_kernel(void
 	setup_arch(&command_line);
 	setup_command_line(command_line);
 	unwind_setup();
+	setup_nr_cpu_ids();
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
diff -puN kernel/sched.c~init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3 kernel/sched.c
--- a/kernel/sched.c~init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3
+++ a/kernel/sched.c
@@ -6072,10 +6072,6 @@ void __init migration_init(void)
 
 #ifdef CONFIG_SMP
 
-/* Number of possible processor ids */
-int nr_cpu_ids __read_mostly = NR_CPUS;
-EXPORT_SYMBOL(nr_cpu_ids);
-
 #ifdef CONFIG_SCHED_DEBUG
 
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level)
@@ -7316,7 +7312,6 @@ static void init_tg_rt_entry(struct rq *
 
 void __init sched_init(void)
 {
-	int highest_cpu = 0;
 	int i, j;
 
 #ifdef CONFIG_SMP
@@ -7379,7 +7374,6 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
-		highest_cpu = i;
 	}
 
 	set_load_weight(&init_task);
@@ -7389,7 +7383,6 @@ void __init sched_init(void)
 #endif
 
 #ifdef CONFIG_SMP
-	nr_cpu_ids = highest_cpu + 1;
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
 #endif
 
_

Patches currently in -mm which might be from travis@sgi.com are

cpufreq-change-cpu-freq-tables-to-per_cpu-variables.patch
x86-minor-cleanup-of-comments-in-processorh.patch
percpu-fix-debug_preempt-per_cpu-checking.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
