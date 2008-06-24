From: akpm@linux-foundation.org
Subject: + full-conversion-to-early_initcall-interface-remove-old-interface.patch added to -mm tree
Date: Mon, 23 Jun 2008 17:27:34 -0700
Message-ID: <200806240027.m5O0RYiM024113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484AbYFXA2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 20:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eduard.munteanu@linux360.ro, tzanussi@gmail.com


The patch titled
     Full conversion to early_initcall() interface, remove old interface
has been added to the -mm tree.  Its filename is
     full-conversion-to-early_initcall-interface-remove-old-interface.patch

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
Subject: Full conversion to early_initcall() interface, remove old interface
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

A previous patch added the early_initcall(), to allow a cleaner hooking of
pre-SMP initcalls.  Now we remove the older interface, converting all
existing users to the new one.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    9 ---------
 include/linux/smp.h   |    8 +++++---
 init/main.c           |   21 +--------------------
 kernel/sched.c        |    6 +++++-
 kernel/smp.c          |    3 ++-
 kernel/softirq.c      |    4 +++-
 kernel/softlockup.c   |   27 ++++++++++++++++++++++++---
 7 files changed, 40 insertions(+), 38 deletions(-)

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
@@ -2226,14 +2225,6 @@ static inline void inc_syscw(struct task
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
@@ -75,11 +75,12 @@ void __smp_call_function_single(int cpui
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void generic_smp_call_function_single_interrupt(void);
 void generic_smp_call_function_interrupt(void);
-void init_call_single_data(void);
+int init_call_single_data(void);
 extern spinlock_t call_function_lock;
 #else
-static inline void init_call_single_data(void)
+static inline int init_call_single_data(void)
 {
+	return 0;
 }
 #endif
 
@@ -138,8 +139,9 @@ static inline void smp_send_reschedule(i
 })
 #define smp_call_function_mask(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
-static inline void init_call_single_data(void)
+static inline int init_call_single_data(void)
 {
+	return 0;
 }
 #endif /* !SMP */
 
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
 
@@ -791,15 +782,6 @@ static void __init __do_pre_smp_initcall
 		do_one_initcall(*call);
 }
 
-static void __init do_pre_smp_initcalls(void)
-{
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
@@ -880,7 +862,6 @@ static int __init kernel_init(void * unu
 
 	smp_prepare_cpus(setup_max_cpus);
 
-	__do_pre_smp_initcalls();
 	do_pre_smp_initcalls();
 
 	smp_init();
diff -puN kernel/sched.c~full-conversion-to-early_initcall-interface-remove-old-interface kernel/sched.c
--- a/kernel/sched.c~full-conversion-to-early_initcall-interface-remove-old-interface
+++ a/kernel/sched.c
@@ -6248,7 +6248,7 @@ static struct notifier_block __cpuinitda
 	.priority = 10
 };
 
-void __init migration_init(void)
+static int __init migration_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
@@ -6258,7 +6258,11 @@ void __init migration_init(void)
 	BUG_ON(err == NOTIFY_BAD);
 	migration_call(&migration_notifier, CPU_ONLINE, cpu);
 	register_cpu_notifier(&migration_notifier);
+
+	return err;
 }
+
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
 
@@ -43,6 +43,7 @@ void __cpuinit init_call_single_data(voi
 		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->list);
 	}
+	return 0;
 }
 
 static void csd_flag_wait(struct call_single_data *data)
diff -puN kernel/softirq.c~full-conversion-to-early_initcall-interface-remove-old-interface kernel/softirq.c
--- a/kernel/softirq.c~full-conversion-to-early_initcall-interface-remove-old-interface
+++ a/kernel/softirq.c
@@ -658,7 +658,7 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpu_callback
 };
 
-__init int spawn_ksoftirqd(void)
+static __init int spawn_ksoftirqd(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
@@ -669,6 +669,8 @@ __init int spawn_ksoftirqd(void)
 	return 0;
 }
 
+early_initcall(spawn_ksoftirqd);
+
 #ifdef CONFIG_SMP
 /*
  * Call a function on all processors
diff -puN kernel/softlockup.c~full-conversion-to-early_initcall-interface-remove-old-interface kernel/softlockup.c
--- a/kernel/softlockup.c~full-conversion-to-early_initcall-interface-remove-old-interface
+++ a/kernel/softlockup.c
@@ -335,14 +335,35 @@ static struct notifier_block __cpuinitda
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
 
-	BUG_ON(err == NOTIFY_BAD);
+	if (nosoftlockup)
+		return 0;
+
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
+
+early_initcall(spawn_softlockup_task);
+
_

Patches currently in -mm which might be from eduard.munteanu@linux360.ro are

better-interface-for-hooking-early-initcalls.patch
full-conversion-to-early_initcall-interface-remove-old-interface.patch
relay-add-buffer-only-channels-useful-for-early-logging.patch

