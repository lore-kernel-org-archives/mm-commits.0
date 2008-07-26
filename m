From: akpm@linux-foundation.org
Subject: - full-conversion-to-early_initcall-interface-remove-old-interface.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:14:19 -0700
Message-ID: <200807262114.m6QLEJ5Q019684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757543AbYGZVOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eduard.munteanu@linux360.ro, kosaki.motohiro@jp.fujitsu.com, tzanussi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Full conversion to early_initcall() interface, remove old interface
has been removed from the -mm tree.  Its filename was
     full-conversion-to-early_initcall-interface-remove-old-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Full conversion to early_initcall() interface, remove old interface
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

A previous patch added the early_initcall(), to allow a cleaner hooking of
pre-SMP initcalls.  Now we remove the older interface, converting all
existing users to the new one.

[akpm@linux-foundation.org: cleanups]
[akpm@linux-foundation.org: build fix]
[kosaki.motohiro@jp.fujitsu.com: warning fix]
[kosaki.motohiro@jp.fujitsu.com: warning fix]
Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    9 ---------
 include/linux/smp.h   |    5 -----
 init/main.c           |   23 +----------------------
 kernel/sched.c        |    5 ++++-
 kernel/smp.c          |    4 +++-
 kernel/softirq.c      |    3 ++-
 kernel/softlockup.c   |   25 ++++++++++++++++++++++---
 7 files changed, 32 insertions(+), 42 deletions(-)

diff -puN include/linux/sched.h~full-conversion-to-early_initcall-interface-remove-old-interface include/linux/sched.h
--- a/include/linux/sched.h~full-conversion-to-early_initcall-interface-remove-old-interface
+++ a/include/linux/sched.h
@@ -292,7 +292,6 @@ extern void sched_show_task(struct task_
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 extern void softlockup_tick(void);
-extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
 extern unsigned int  softlockup_panic;
@@ -2222,14 +2221,6 @@ static inline void inc_syscw(struct task
 }
 #endif
 
-#ifdef CONFIG_SMP
-void migration_init(void);
-#else
-static inline void migration_init(void)
-{
-}
-#endif
-
 #ifndef TASK_SIZE_OF
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
diff -puN include/linux/smp.h~full-conversion-to-early_initcall-interface-remove-old-interface include/linux/smp.h
--- a/include/linux/smp.h~full-conversion-to-early_initcall-interface-remove-old-interface
+++ a/include/linux/smp.h
@@ -74,15 +74,10 @@ void __smp_call_function_single(int cpui
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void generic_smp_call_function_single_interrupt(void);
 void generic_smp_call_function_interrupt(void);
-void init_call_single_data(void);
 void ipi_call_lock(void);
 void ipi_call_unlock(void);
 void ipi_call_lock_irq(void);
 void ipi_call_unlock_irq(void);
-#else
-static inline void init_call_single_data(void)
-{
-}
 #endif
 
 /*
diff -puN init/main.c~full-conversion-to-early_initcall-interface-remove-old-interface init/main.c
--- a/init/main.c~full-conversion-to-early_initcall-interface-remove-old-interface
+++ a/init/main.c
@@ -774,16 +774,7 @@ static void __init do_basic_setup(void)
 	do_initcalls();
 }
 
-static int __initdata nosoftlockup;
-
-static int __init nosoftlockup_setup(char *str)
-{
-	nosoftlockup = 1;
-	return 1;
-}
-__setup("nosoftlockup", nosoftlockup_setup);
-
-static void __init __do_pre_smp_initcalls(void)
+static void __init do_pre_smp_initcalls(void)
 {
 	initcall_t *call;
 
@@ -791,17 +782,6 @@ static void __init __do_pre_smp_initcall
 		do_one_initcall(*call);
 }
 
-static void __init do_pre_smp_initcalls(void)
-{
-	extern int spawn_ksoftirqd(void);
-
-	init_call_single_data();
-	migration_init();
-	spawn_ksoftirqd();
-	if (!nosoftlockup)
-		spawn_softlockup_task();
-}
-
 static void run_init_process(char *init_filename)
 {
 	argv_init[0] = init_filename;
@@ -873,7 +853,6 @@ static int __init kernel_init(void * unu
 
 	smp_prepare_cpus(setup_max_cpus);
 
-	__do_pre_smp_initcalls();
 	do_pre_smp_initcalls();
 
 	smp_init();
diff -puN kernel/sched.c~full-conversion-to-early_initcall-interface-remove-old-interface kernel/sched.c
--- a/kernel/sched.c~full-conversion-to-early_initcall-interface-remove-old-interface
+++ a/kernel/sched.c
@@ -6389,7 +6389,7 @@ static struct notifier_block __cpuinitda
 	.priority = 10
 };
 
-void __init migration_init(void)
+static int __init migration_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
@@ -6399,7 +6399,10 @@ void __init migration_init(void)
 	BUG_ON(err == NOTIFY_BAD);
 	migration_call(&migration_notifier, CPU_ONLINE, cpu);
 	register_cpu_notifier(&migration_notifier);
+
+	return err;
 }
+early_initcall(migration_init);
 #endif
 
 #ifdef CONFIG_SMP
diff -puN kernel/smp.c~full-conversion-to-early_initcall-interface-remove-old-interface kernel/smp.c
--- a/kernel/smp.c~full-conversion-to-early_initcall-interface-remove-old-interface
+++ a/kernel/smp.c
@@ -33,7 +33,7 @@ struct call_single_queue {
 	spinlock_t lock;
 };
 
-void __cpuinit init_call_single_data(void)
+static int __cpuinit init_call_single_data(void)
 {
 	int i;
 
@@ -43,7 +43,9 @@ void __cpuinit init_call_single_data(voi
 		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->list);
 	}
+	return 0;
 }
+early_initcall(init_call_single_data);
 
 static void csd_flag_wait(struct call_single_data *data)
 {
diff -puN kernel/softirq.c~full-conversion-to-early_initcall-interface-remove-old-interface kernel/softirq.c
--- a/kernel/softirq.c~full-conversion-to-early_initcall-interface-remove-old-interface
+++ a/kernel/softirq.c
@@ -630,7 +630,7 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpu_callback
 };
 
-__init int spawn_ksoftirqd(void)
+static __init int spawn_ksoftirqd(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
@@ -640,6 +640,7 @@ __init int spawn_ksoftirqd(void)
 	register_cpu_notifier(&cpu_nfb);
 	return 0;
 }
+early_initcall(spawn_ksoftirqd);
 
 #ifdef CONFIG_SMP
 /*
diff -puN kernel/softlockup.c~full-conversion-to-early_initcall-interface-remove-old-interface kernel/softlockup.c
--- a/kernel/softlockup.c~full-conversion-to-early_initcall-interface-remove-old-interface
+++ a/kernel/softlockup.c
@@ -338,14 +338,33 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpu_callback
 };
 
-__init void spawn_softlockup_task(void)
+static int __initdata nosoftlockup;
+
+static int __init nosoftlockup_setup(char *str)
+{
+	nosoftlockup = 1;
+	return 1;
+}
+__setup("nosoftlockup", nosoftlockup_setup);
+
+static int __init spawn_softlockup_task(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
-	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
+	int err;
+
+	if (nosoftlockup)
+		return 0;
 
-	BUG_ON(err == NOTIFY_BAD);
+	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
+	if (err == NOTIFY_BAD) {
+		BUG();
+		return 1;
+	}
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
 	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
+
+	return 0;
 }
+early_initcall(spawn_softlockup_task);
_

Patches currently in -mm which might be from eduard.munteanu@linux360.ro are

origin.patch

