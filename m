From: akpm@osdl.org
Subject: + simplify-the-registration-of-clocksources.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:35:55 -0800
Message-ID: <200701250635.l0P6ZtYY008283@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965553AbXAYGgZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:36:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     Simplify the registration of clocksources
has been added to the -mm tree.  Its filename is
     simplify-the-registration-of-clocksources.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Simplify the registration of clocksources
From: Thomas Gleixner <tglx@linutronix.de>

Enqueue clocksources in rating order to make selection of the
clocksource easier. Also check the match with an user override
at enqueue time.

Preparatory patch for the generic clocksource verification.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time/clocksource.c |  118 +++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 61 deletions(-)

diff -puN kernel/time/clocksource.c~simplify-the-registration-of-clocksources kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~simplify-the-registration-of-clocksources
+++ a/kernel/time/clocksource.c
@@ -47,6 +47,7 @@ extern struct clocksource clocksource_ji
  */
 static struct clocksource *curr_clocksource = &clocksource_jiffies;
 static struct clocksource *next_clocksource;
+static struct clocksource *clocksource_override;
 static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
@@ -83,60 +84,46 @@ struct clocksource *clocksource_get_next
 }
 
 /**
- * select_clocksource - Finds the best registered clocksource.
+ * select_clocksource - Selects the best registered clocksource.
  *
  * Private function. Must hold clocksource_lock when called.
  *
- * Looks through the list of registered clocksources, returning
- * the one with the highest rating value. If there is a clocksource
- * name that matches the override string, it returns that clocksource.
+ * Select the clocksource with the best rating, or the clocksource,
+ * which is selected by userspace override.
  */
 static struct clocksource *select_clocksource(void)
 {
-	struct clocksource *best = NULL;
-	struct list_head *tmp;
-
-	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *src;
+	if (list_empty(&clocksource_list))
+		return NULL;
 
-		src = list_entry(tmp, struct clocksource, list);
-		if (!best)
-			best = src;
-
-		/* check for override: */
-		if (strlen(src->name) == strlen(override_name) &&
-		    !strcmp(src->name, override_name)) {
-			best = src;
-			break;
-		}
-		/* pick the highest rating: */
-		if (src->rating > best->rating)
-		 	best = src;
-	}
+	if (clocksource_override)
+		return clocksource_override;
 
-	return best;
+	return list_entry(clocksource_list.next, struct clocksource, list);
 }
 
-/**
- * is_registered_source - Checks if clocksource is registered
- * @c:		pointer to a clocksource
- *
- * Private helper function. Must hold clocksource_lock when called.
- *
- * Returns one if the clocksource is already registered, zero otherwise.
+/*
+ * Enqueue the clocksource sorted by rating
  */
-static int is_registered_source(struct clocksource *c)
+static int clocksource_enqueue(struct clocksource *c)
 {
-	int len = strlen(c->name);
-	struct list_head *tmp;
+	struct list_head *tmp, *entry = &clocksource_list;
 
 	list_for_each(tmp, &clocksource_list) {
-		struct clocksource *src;
+		struct clocksource *cs;
 
-		src = list_entry(tmp, struct clocksource, list);
-		if (strlen(src->name) == len &&	!strcmp(src->name, c->name))
-			return 1;
+		cs = list_entry(tmp, struct clocksource, list);
+		if (cs == c)
+			return -EBUSY;
+		/* Keep track of the place, where to insert */
+		if (cs->rating >= c->rating)
+			entry = tmp;
 	}
+	list_add(&c->list, entry);
+
+	if (strlen(c->name) == strlen(override_name) &&
+	    !strcmp(c->name, override_name))
+		clocksource_override = c;
 
 	return 0;
 }
@@ -149,42 +136,32 @@ static int is_registered_source(struct c
  */
 int clocksource_register(struct clocksource *c)
 {
-	int ret = 0;
 	unsigned long flags;
+	int ret = 0;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
-	/* check if clocksource is already registered */
-	if (is_registered_source(c)) {
-		printk("register_clocksource: Cannot register %s. "
-		       "Already registered!", c->name);
-		ret = -EBUSY;
-	} else {
-		/* register it */
- 		list_add(&c->list, &clocksource_list);
-		/* scan the registered clocksources, and pick the best one */
+	ret = clocksource_enqueue(c);
+	if (!ret)
 		next_clocksource = select_clocksource();
-	}
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(clocksource_register);
 
 /**
- * clocksource_reselect - Rescan list for next clocksource
+ * clocksource_change_rating - Change the rating of a registered clocksource
  *
- * A quick helper function to be used if a clocksource changes its
- * rating. Forces the clocksource list to be re-scanned for the best
- * clocksource.
  */
-void clocksource_reselect(void)
+void clocksource_change_rating(struct clocksource *cs, int rating)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
+	list_del(&cs->list);
+	clocksource_enqueue(cs);
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
-EXPORT_SYMBOL(clocksource_reselect);
 
 #ifdef CONFIG_SYSFS
 /**
@@ -220,7 +197,11 @@ sysfs_show_current_clocksources(struct s
 static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 					  const char *buf, size_t count)
 {
+	struct clocksource *ovr = NULL;
+	struct list_head *tmp;
 	size_t ret = count;
+	int len;
+
 	/* strings from sysfs write are not 0 terminated! */
 	if (count >= sizeof(override_name))
 		return -EINVAL;
@@ -228,17 +209,32 @@ static ssize_t sysfs_override_clocksourc
 	/* strip of \n: */
 	if (buf[count-1] == '\n')
 		count--;
-	if (count < 1)
-		return -EINVAL;
 
 	spin_lock_irq(&clocksource_lock);
 
-	/* copy the name given: */
-	memcpy(override_name, buf, count);
+	if (count > 0)
+		memcpy(override_name, buf, count);
 	override_name[count] = 0;
 
-	/* try to select it: */
-	next_clocksource = select_clocksource();
+	len = strlen(override_name);
+	if (len) {
+		ovr = clocksource_override;
+		/* try to select it: */
+		list_for_each(tmp, &clocksource_list) {
+			struct clocksource *cs;
+
+			cs = list_entry(tmp, struct clocksource, list);
+			if (strlen(cs->name) == len &&
+			    !strcmp(cs->name, override_name))
+				ovr = cs;
+		}
+	}
+
+	/* Reselect, when the override name has changed */
+	if (ovr != clocksource_override) {
+		clocksource_override = ovr;
+		next_clocksource = select_clocksource();
+	}
 
 	spin_unlock_irq(&clocksource_lock);
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
clocksource-add-verification-watchdog-helper-fix.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
