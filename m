From: akpm@linux-foundation.org
Subject: - full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:31:35 -0700
Message-ID: <200807020731.m627VZfv005057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761386AbYGBHbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eduard.munteanu@linux360.ro, mm-commits@vger.kernel.org


The patch titled
     full-conversion-to-early_initcall-interface-remove-old-interface-fix
has been removed from the -mm tree.  Its filename was
     full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch

This patch was dropped because kernel/smp.c has vanshed from linux-next

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: full-conversion-to-early_initcall-interface-remove-old-interface-fix
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 ---
 include/linux/smp.h   |   10 ----------
 kernel/smp.c          |    2 ++
 kernel/softirq.c      |    2 +-
 4 files changed, 3 insertions(+), 14 deletions(-)

diff -puN include/linux/sched.h~full-conversion-to-early_initcall-interface-remove-old-interface-fix include/linux/sched.h
--- a/include/linux/sched.h~full-conversion-to-early_initcall-interface-remove-old-interface-fix
+++ a/include/linux/sched.h
@@ -303,9 +303,6 @@ extern int softlockup_thresh;
 static inline void softlockup_tick(void)
 {
 }
-static inline void spawn_softlockup_task(void)
-{
-}
 static inline void touch_softlockup_watchdog(void)
 {
 }
diff -puN include/linux/smp.h~full-conversion-to-early_initcall-interface-remove-old-interface-fix include/linux/smp.h
--- a/include/linux/smp.h~full-conversion-to-early_initcall-interface-remove-old-interface-fix
+++ a/include/linux/smp.h
@@ -75,13 +75,7 @@ void __smp_call_function_single(int cpui
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void generic_smp_call_function_single_interrupt(void);
 void generic_smp_call_function_interrupt(void);
-int init_call_single_data(void);
 extern spinlock_t call_function_lock;
-#else
-static inline int init_call_single_data(void)
-{
-	return 0;
-}
 #endif
 
 /*
@@ -139,10 +133,6 @@ static inline void smp_send_reschedule(i
 })
 #define smp_call_function_mask(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
-static inline int init_call_single_data(void)
-{
-	return 0;
-}
 #endif /* !SMP */
 
 /*
diff -puN kernel/smp.c~full-conversion-to-early_initcall-interface-remove-old-interface-fix kernel/smp.c
--- a/kernel/smp.c~full-conversion-to-early_initcall-interface-remove-old-interface-fix
+++ a/kernel/smp.c
@@ -46,6 +46,8 @@ static int __cpuinit init_call_single_da
 	return 0;
 }
 
+early_initcall(init_call_single_data);
+
 static void csd_flag_wait(struct call_single_data *data)
 {
 	/* Wait for response */
diff -puN kernel/softirq.c~full-conversion-to-early_initcall-interface-remove-old-interface-fix kernel/softirq.c
--- a/kernel/softirq.c~full-conversion-to-early_initcall-interface-remove-old-interface-fix
+++ a/kernel/softirq.c
@@ -658,7 +658,7 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpu_callback
 };
 
-static __init int spawn_ksoftirqd(void)
+static int __init spawn_ksoftirqd(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
_

Patches currently in -mm which might be from eduard.munteanu@linux360.ro are

origin.patch
better-interface-for-hooking-early-initcalls.patch
full-conversion-to-early_initcall-interface-remove-old-interface.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
relay-add-buffer-only-channels-useful-for-early-logging.patch

