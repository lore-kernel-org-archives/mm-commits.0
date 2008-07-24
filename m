From: akpm@linux-foundation.org
Subject: - pm-boot-time-suspend-selftest.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:12 -0700
Message-ID: <200807242325.m6ONPCOM010858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044AbYGXX0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, matthltc@us.ibm.com, mingo@elte.hu, pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm: boot time suspend selftest
has been removed from the -mm tree.  Its filename was
     pm-boot-time-suspend-selftest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: boot time suspend selftest
From: David Brownell <dbrownell@users.sourceforge.net>

Boot-time test for system suspend states (STR or standby).  The generic
RTC framework triggers wakeup alarms, which are used to exit those states.

  - Measures some aspects of suspend time ... this uses "jiffies" until
    someone converts it to use a timebase that works properly even while
    timer IRQs are disabled.

  - Triggered by a command line parameter.  By default nothing even
    vaguely troublesome will happen, but "test_suspend=mem" will give
    you a brief STR test during system boot.  (Or you may need to use
    "test_suspend=standby" instead, if your hardware needs that.)

This isn't without problems.  It fires early enough during boot that for
example both PCMCIA and MMC stacks have misbehaved.  The workaround in
those cases was to boot without such media cards inserted.

[matthltc@us.ibm.com: fix compile failure in boot time suspend selftest]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    9 +
 kernel/power/Kconfig                |   11 +
 kernel/power/main.c                 |  194 +++++++++++++++++++++++++-
 3 files changed, 212 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~pm-boot-time-suspend-selftest Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~pm-boot-time-suspend-selftest
+++ a/Documentation/kernel-parameters.txt
@@ -87,7 +87,8 @@ parameter is applicable:
 	SH	SuperH architecture is enabled.
 	SMP	The kernel is an SMP kernel.
 	SPARC	Sparc architecture is enabled.
-	SWSUSP	Software suspend is enabled.
+	SWSUSP	Software suspend (hibernation) is enabled.
+	SUSPEND	System suspend states are enabled.
 	TS	Appropriate touchscreen support is enabled.
 	USB	USB support is enabled.
 	USBHID	USB Human Interface Device support is enabled.
@@ -2120,6 +2121,12 @@ and is between 256 and 4096 characters. 
 
 	tdfx=		[HW,DRM]
 
+	test_suspend=	[SUSPEND]
+			Specify "mem" (for Suspend-to-RAM) or "standby" (for
+			standby suspend) as the system sleep state to briefly
+			enter during system startup.  The system is woken from
+			this state using a wakeup-capable RTC alarm.
+
 	thash_entries=	[KNL,NET]
 			Set number of hash buckets for TCP connection
 
diff -puN kernel/power/Kconfig~pm-boot-time-suspend-selftest kernel/power/Kconfig
--- a/kernel/power/Kconfig~pm-boot-time-suspend-selftest
+++ a/kernel/power/Kconfig
@@ -94,6 +94,17 @@ config SUSPEND
 	  powered and thus its contents are preserved, such as the
 	  suspend-to-RAM state (e.g. the ACPI S3 state).
 
+config PM_TEST_SUSPEND
+	bool "Test suspend/resume and wakealarm during bootup"
+	depends on SUSPEND && PM_DEBUG && RTC_LIB=y
+	---help---
+	This option will let you suspend your machine during bootup, and
+	make it wake up a few seconds later using an RTC wakeup alarm.
+	Enable this with a kernel parameter like "test_suspend=mem".
+
+	You probably want to have your system's RTC driver statically
+	linked, ensuring that it's available when this test runs.
+
 config SUSPEND_FREEZER
 	bool "Enable freezer for suspend to RAM/standby" \
 		if ARCH_WANTS_FREEZER_CONTROL || BROKEN
diff -puN kernel/power/main.c~pm-boot-time-suspend-selftest kernel/power/main.c
--- a/kernel/power/main.c~pm-boot-time-suspend-selftest
+++ a/kernel/power/main.c
@@ -132,6 +132,61 @@ static inline int suspend_test(int level
 
 #ifdef CONFIG_SUSPEND
 
+#ifdef CONFIG_PM_TEST_SUSPEND
+
+/*
+ * We test the system suspend code by setting an RTC wakealarm a short
+ * time in the future, then suspending.  Suspending the devices won't
+ * normally take long ... some systems only need a few milliseconds.
+ *
+ * The time it takes is system-specific though, so when we test this
+ * during system bootup we allow a LOT of time.
+ */
+#define TEST_SUSPEND_SECONDS	5
+
+static unsigned long suspend_test_start_time;
+
+static void suspend_test_start(void)
+{
+	/* FIXME Use better timebase than "jiffies", ideally a clocksource.
+	 * What we want is a hardware counter that will work correctly even
+	 * during the irqs-are-off stages of the suspend/resume cycle...
+	 */
+	suspend_test_start_time = jiffies;
+}
+
+static void suspend_test_finish(const char *label)
+{
+	long nj = jiffies - suspend_test_start_time;
+	unsigned msec;
+
+	msec = jiffies_to_msecs(abs(nj));
+	pr_info("PM: %s took %d.%03d seconds\n", label,
+			msec / 1000, msec % 1000);
+
+	/* Warning on suspend means the RTC alarm period needs to be
+	 * larger -- the system was sooo slooowwww to suspend that the
+	 * alarm (should have) fired before the system went to sleep!
+	 *
+	 * Warning on either suspend or resume also means the system
+	 * has some performance issues.  The stack dump of a WARN_ON
+	 * is more likely to get the right attention than a printk...
+	 */
+	WARN_ON(msec > (TEST_SUSPEND_SECONDS * 1000));
+}
+
+#else
+
+static void suspend_test_start(void)
+{
+}
+
+static void suspend_test_finish(const char *label)
+{
+}
+
+#endif
+
 /* This is just an arbitrary number */
 #define FREE_PAGE_NUMBER (100)
 
@@ -266,12 +321,13 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
+	suspend_test_start();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to suspend\n");
 		goto Recover_platform;
 	}
-
+	suspend_test_finish("suspend devices");
 	if (suspend_test(TEST_DEVICES))
 		goto Recover_platform;
 
@@ -293,7 +349,9 @@ int suspend_devices_and_enter(suspend_st
 	if (suspend_ops->finish)
 		suspend_ops->finish();
  Resume_devices:
+	suspend_test_start();
 	device_resume(PMSG_RESUME);
+	suspend_test_finish("resume devices");
 	resume_console();
  Close:
 	if (suspend_ops->end)
@@ -521,3 +579,137 @@ static int __init pm_init(void)
 }
 
 core_initcall(pm_init);
+
+
+#ifdef CONFIG_PM_TEST_SUSPEND
+
+#include <linux/rtc.h>
+
+/*
+ * To test system suspend, we need a hands-off mechanism to resume the
+ * system.  RTCs wake alarms are a common self-contained mechanism.
+ */
+
+static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
+{
+	static char err_readtime[] __initdata =
+		KERN_ERR "PM: can't read %s time, err %d\n";
+	static char err_wakealarm [] __initdata =
+		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
+	static char err_suspend[] __initdata =
+		KERN_ERR "PM: suspend test failed, error %d\n";
+	static char info_test[] __initdata =
+		KERN_INFO "PM: test RTC wakeup from '%s' suspend\n";
+
+	unsigned long		now;
+	struct rtc_wkalrm	alm;
+	int			status;
+
+	/* this may fail if the RTC hasn't been initialized */
+	status = rtc_read_time(rtc, &alm.time);
+	if (status < 0) {
+		printk(err_readtime, rtc->dev.bus_id, status);
+		return;
+	}
+	rtc_tm_to_time(&alm.time, &now);
+
+	memset(&alm, 0, sizeof alm);
+	rtc_time_to_tm(now + TEST_SUSPEND_SECONDS, &alm.time);
+	alm.enabled = true;
+
+	status = rtc_set_alarm(rtc, &alm);
+	if (status < 0) {
+		printk(err_wakealarm, rtc->dev.bus_id, status);
+		return;
+	}
+
+	if (state == PM_SUSPEND_MEM) {
+		printk(info_test, pm_states[state]);
+		status = pm_suspend(state);
+		if (status == -ENODEV)
+			state = PM_SUSPEND_STANDBY;
+	}
+	if (state == PM_SUSPEND_STANDBY) {
+		printk(info_test, pm_states[state]);
+		status = pm_suspend(state);
+	}
+	if (status < 0)
+		printk(err_suspend, status);
+}
+
+static int __init has_wakealarm(struct device *dev, void *name_ptr)
+{
+	struct rtc_device *candidate = to_rtc_device(dev);
+
+	if (!candidate->ops->set_alarm)
+		return 0;
+	if (!device_may_wakeup(candidate->dev.parent))
+		return 0;
+
+	*(char **)name_ptr = dev->bus_id;
+	return 1;
+}
+
+/*
+ * Kernel options like "test_suspend=mem" force suspend/resume sanity tests
+ * at startup time.  They're normally disabled, for faster boot and because
+ * we can't know which states really work on this particular system.
+ */
+static suspend_state_t test_state __initdata = PM_SUSPEND_ON;
+
+static char warn_bad_state[] __initdata =
+	KERN_WARNING "PM: can't test '%s' suspend state\n";
+
+static int __init setup_test_suspend(char *value)
+{
+	unsigned i;
+
+	/* "=mem" ==> "mem" */
+	value++;
+	for (i = 0; i < PM_SUSPEND_MAX; i++) {
+		if (!pm_states[i])
+			continue;
+		if (strcmp(pm_states[i], value) != 0)
+			continue;
+		test_state = (__force suspend_state_t) i;
+		return 0;
+	}
+	printk(warn_bad_state, value);
+	return 0;
+}
+__setup("test_suspend", setup_test_suspend);
+
+static int __init test_suspend(void)
+{
+	static char		warn_no_rtc[] __initdata =
+		KERN_WARNING "PM: no wakealarm-capable RTC driver is ready\n";
+
+	char			*pony = NULL;
+	struct rtc_device	*rtc = NULL;
+
+	/* PM is initialized by now; is that state testable? */
+	if (test_state == PM_SUSPEND_ON)
+		goto done;
+	if (!valid_state(test_state)) {
+		printk(warn_bad_state, pm_states[test_state]);
+		goto done;
+	}
+
+	/* RTCs have initialized by now too ... can we use one? */
+	class_find_device(rtc_class, NULL, &pony, has_wakealarm);
+	if (pony)
+		rtc = rtc_class_open(pony);
+	if (!rtc) {
+		printk(warn_no_rtc);
+		goto done;
+	}
+
+	/* go for it */
+	test_wakealarm(rtc, test_state);
+	rtc_class_close(rtc);
+done:
+	return 0;
+}
+late_initcall(test_suspend);
+
+#endif /* CONFIG_PM_TEST_SUSPEND */
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix-fix.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-max732x-driver.patch

