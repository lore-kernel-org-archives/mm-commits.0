From: akpm@linux-foundation.org
Subject: - fix-bogus-softlockup-warning-with-sysrq-t.patch removed from -mm tree
Date: Wed, 28 Mar 2007 16:37:16 -0700
Message-ID: <200703282337.l2SNbGTk022805@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35729 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934046AbXC1Xkq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 19:40:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, clalance@redhat.com, mingo@elte.hu, ricklind@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Fix bogus softlockup warning with sysrq-t
has been removed from the -mm tree.  Its filename was
     fix-bogus-softlockup-warning-with-sysrq-t.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Fix bogus softlockup warning with sysrq-t
From: Prarit Bhargava <prarit@redhat.com>

There are some situations when soft lockup warnings are expected in the
kernel.  For example, when doing an alt-sysrq-t on a large number of
processes, the dump to console can take a long time and the tasklist_lock
is held over that period.  This results in a bogus soft lockup warning.

This patch reworks touch_softlockup_watchdog to touch ALL cpu's
touch_timestamp.  It also introduces touch_cpu_softlockup_watchdog to touch
a single cpu's touch_timestamp.  This makes it functionally equivalent to
touch_nmi_watchdog.

touch_nmi_watchdog is not modified -- AFAICT it was attempting to touch all
cpu's softlockup watchdogs, not just a specific cpu.

/drivers/ide/ide-iops.c does not need to call touch_softlockup_watchdog as
it is done in the call to touch_nmi_watchdog.

The EXPORT_SYMBOL for touch_softlockup_watchdog is needed by
drivers/scsi/ips.ko

Acked-by: Chris Lalancette <clalance@redhat.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Rick Lindsley <ricklind@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/uncached.c  |    2 +-
 drivers/ide/ide-iops.c       |    1 -
 drivers/ide/ide-taskfile.c   |    2 +-
 drivers/mtd/nand/nand_base.c |    2 +-
 include/linux/sched.h        |    4 ++++
 kernel/panic.c               |    2 +-
 kernel/power/swsusp.c        |    2 +-
 kernel/sched.c               |    1 +
 kernel/softlockup.c          |   16 +++++++++++++---
 9 files changed, 23 insertions(+), 9 deletions(-)

diff -puN arch/ia64/kernel/uncached.c~fix-bogus-softlockup-warning-with-sysrq-t arch/ia64/kernel/uncached.c
--- a/arch/ia64/kernel/uncached.c~fix-bogus-softlockup-warning-with-sysrq-t
+++ a/arch/ia64/kernel/uncached.c
@@ -254,7 +254,7 @@ static int __init uncached_build_memmap(
 	struct gen_pool *pool = uncached_pools[nid].pool;
 	size_t size = uc_end - uc_start;
 
-	touch_softlockup_watchdog();
+	touch_cpu_softlockup_watchdog();
 
 	if (pool != NULL) {
 		memset((char *)uc_start, 0, size);
diff -puN drivers/ide/ide-iops.c~fix-bogus-softlockup-warning-with-sysrq-t drivers/ide/ide-iops.c
--- a/drivers/ide/ide-iops.c~fix-bogus-softlockup-warning-with-sysrq-t
+++ a/drivers/ide/ide-iops.c
@@ -1226,7 +1226,6 @@ int ide_wait_not_busy(ide_hwif_t *hwif, 
 		 */
 		if (stat == 0xff)
 			return -ENODEV;
-		touch_softlockup_watchdog();
 		touch_nmi_watchdog();
 	}
 	return -EBUSY;
diff -puN drivers/ide/ide-taskfile.c~fix-bogus-softlockup-warning-with-sysrq-t drivers/ide/ide-taskfile.c
--- a/drivers/ide/ide-taskfile.c~fix-bogus-softlockup-warning-with-sysrq-t
+++ a/drivers/ide/ide-taskfile.c
@@ -313,7 +313,7 @@ static void ide_pio_datablock(ide_drive_
 	if (rq->bio)	/* fs request */
 		rq->errors = 0;
 
-	touch_softlockup_watchdog();
+	touch_cpu_softlockup_watchdog();
 
 	switch (drive->hwif->data_phase) {
 	case TASKFILE_MULTI_IN:
diff -puN drivers/mtd/nand/nand_base.c~fix-bogus-softlockup-warning-with-sysrq-t drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~fix-bogus-softlockup-warning-with-sysrq-t
+++ a/drivers/mtd/nand/nand_base.c
@@ -425,7 +425,7 @@ void nand_wait_ready(struct mtd_info *mt
 	do {
 		if (chip->dev_ready(mtd))
 			break;
-		touch_softlockup_watchdog();
+		touch_cpu_softlockup_watchdog();
 	} while (time_before(jiffies, timeo));
 	led_trigger_event(nand_led_trigger, LED_OFF);
 }
diff -puN include/linux/sched.h~fix-bogus-softlockup-warning-with-sysrq-t include/linux/sched.h
--- a/include/linux/sched.h~fix-bogus-softlockup-warning-with-sysrq-t
+++ a/include/linux/sched.h
@@ -225,6 +225,7 @@ extern void scheduler_tick(void);
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 extern void softlockup_tick(void);
 extern void spawn_softlockup_task(void);
+extern void touch_cpu_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog(void);
 #else
 static inline void softlockup_tick(void)
@@ -233,6 +234,9 @@ static inline void softlockup_tick(void)
 static inline void spawn_softlockup_task(void)
 {
 }
+static inline void touch_cpu_softlockup_watchdog(void)
+{
+}
 static inline void touch_softlockup_watchdog(void)
 {
 }
diff -puN kernel/panic.c~fix-bogus-softlockup-warning-with-sysrq-t kernel/panic.c
--- a/kernel/panic.c~fix-bogus-softlockup-warning-with-sysrq-t
+++ a/kernel/panic.c
@@ -132,7 +132,7 @@ NORET_TYPE void panic(const char * fmt, 
 #endif
 	local_irq_enable();
 	for (i = 0;;) {
-		touch_softlockup_watchdog();
+		touch_cpu_softlockup_watchdog();
 		i += panic_blink(i);
 		mdelay(1);
 		i++;
diff -puN kernel/power/swsusp.c~fix-bogus-softlockup-warning-with-sysrq-t kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~fix-bogus-softlockup-warning-with-sysrq-t
+++ a/kernel/power/swsusp.c
@@ -323,7 +323,7 @@ int swsusp_resume(void)
 	 */
 	swsusp_free();
 	restore_processor_state();
-	touch_softlockup_watchdog();
+	touch_cpu_softlockup_watchdog();
 	device_power_up();
 	local_irq_enable();
 	return error;
diff -puN kernel/sched.c~fix-bogus-softlockup-warning-with-sysrq-t kernel/sched.c
--- a/kernel/sched.c~fix-bogus-softlockup-warning-with-sysrq-t
+++ a/kernel/sched.c
@@ -4783,6 +4783,7 @@ void show_state_filter(unsigned long sta
 		if (p->state & state_filter)
 			show_task(p);
 	} while_each_thread(g, p);
+	touch_softlockup_watchdog();
 
 	read_unlock(&tasklist_lock);
 	/*
diff -puN kernel/softlockup.c~fix-bogus-softlockup-warning-with-sysrq-t kernel/softlockup.c
--- a/kernel/softlockup.c~fix-bogus-softlockup-warning-with-sysrq-t
+++ a/kernel/softlockup.c
@@ -8,6 +8,7 @@
  */
 #include <linux/mm.h>
 #include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
@@ -34,10 +35,19 @@ static struct notifier_block panic_block
 	.notifier_call = softlock_panic,
 };
 
-void touch_softlockup_watchdog(void)
+void touch_cpu_softlockup_watchdog(void)
 {
 	__raw_get_cpu_var(touch_timestamp) = jiffies;
 }
+EXPORT_SYMBOL(touch_cpu_softlockup_watchdog);
+
+void touch_softlockup_watchdog(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		per_cpu(touch_timestamp, cpu) = jiffies;
+}
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
 /*
@@ -57,7 +67,7 @@ void softlockup_tick(void)
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
-		touch_softlockup_watchdog();
+		touch_cpu_softlockup_watchdog();
 		return;
 	}
 
@@ -94,7 +104,7 @@ static int watchdog(void * __bind_cpu)
 	 */
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		touch_softlockup_watchdog();
+		touch_cpu_softlockup_watchdog();
 		schedule();
 	}
 
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
use-stop_machine_run-in-the-intel-rng-driver.patch
fix-bogus-softlockup-warning-with-sysrq-t.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
change-rivafb_remove-to-__devexit.patch
