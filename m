From: akpm@linux-foundation.org
Subject: + clockevents-remove-bad-designed-sysfs-support-for-now.patch added to -mm tree
Date: Mon, 26 Mar 2007 02:02:12 -0800
Message-ID: <200703261002.l2QA2CMf016406@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51279 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbXCZKFj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 06:05:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     clockevents: remove bad designed sysfs support for now
has been added to the -mm tree.  Its filename is
     clockevents-remove-bad-designed-sysfs-support-for-now.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: remove bad designed sysfs support for now
From: Thomas Gleixner <tglx@linutronix.de>

The current sysfs support of clockevents does not obey the "only one value
per file" rule.

The real fix is not 2.6.21 material.  Therefor remove the sysfs support for
now.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clockevents.c |   69 ------------------------------------
 1 file changed, 69 deletions(-)

diff -puN kernel/time/clockevents.c~clockevents-remove-bad-designed-sysfs-support-for-now kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~clockevents-remove-bad-designed-sysfs-support-for-now
+++ a/kernel/time/clockevents.c
@@ -274,72 +274,3 @@ void clockevents_notify(unsigned long re
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 
-#ifdef CONFIG_SYSFS
-
-/**
- * clockevents_show_registered - sysfs interface for listing clockevents
- * @dev:	unused
- * @buf:	char buffer to be filled with clock events list
- *
- * Provides sysfs interface for listing registered clock event devices
- */
-static ssize_t clockevents_show_registered(struct sys_device *dev, char *buf)
-{
-	struct list_head *tmp;
-	char *p = buf;
-	int cpu;
-
-	spin_lock(&clockevents_lock);
-
-	list_for_each(tmp, &clockevent_devices) {
-		struct clock_event_device *ce;
-
-		ce = list_entry(tmp, struct clock_event_device, list);
-		p += sprintf(p, "%-20s F:%04x M:%d", ce->name,
-			     ce->features, ce->mode);
-		p += sprintf(p, " C:");
-		if (!cpus_equal(ce->cpumask, cpu_possible_map)) {
-			for_each_cpu_mask(cpu, ce->cpumask)
-				p += sprintf(p, " %d", cpu);
-		} else {
-			/*
-			 * FIXME: Add the cpu which is handling this sucker
-			 */
-		}
-		p += sprintf(p, "\n");
-	}
-
-	spin_unlock(&clockevents_lock);
-
-	return p - buf;
-}
-
-/*
- * Sysfs setup bits:
- */
-static SYSDEV_ATTR(registered, 0600,
-		   clockevents_show_registered, NULL);
-
-static struct sysdev_class clockevents_sysclass = {
-	set_kset_name("clockevents"),
-};
-
-static struct sys_device clockevents_sys_device = {
-	.id	= 0,
-	.cls	= &clockevents_sysclass,
-};
-
-static int __init clockevents_sysfs_init(void)
-{
-	int error = sysdev_class_register(&clockevents_sysclass);
-
-	if (!error)
-		error = sysdev_register(&clockevents_sys_device);
-	if (!error)
-		error = sysdev_create_file(
-				&clockevents_sys_device,
-				&attr_registered);
-	return error;
-}
-device_initcall(clockevents_sysfs_init);
-#endif
_

Patches currently in -mm which might be from tglx@linutronix.de are

correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
ntp-avoid-time_offset-overflows-fix.patch
clockevents-remove-bad-designed-sysfs-support-for-now.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
declare-struct-ktime.patch
mm-only-hrtimers-debug-patch.patch
mm-only-hrtimers-debug-patch-fix.patch
