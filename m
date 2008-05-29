From: akpm@linux-foundation.org
Subject: + pm-boot-time-suspend-selftest.patch added to -mm tree
Date: Thu, 29 May 2008 16:24:03 -0700
Message-ID: <200805292324.m4TNO3Ym028151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbYE2XYe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 19:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, mingo@elte.hu, pavel@suse.cz, rjw@sisk.pl


The patch titled
     pm: boot time suspend selftest
has been added to the -mm tree.  Its filename is
     pm-boot-time-suspend-selftest.patch

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

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    9 +
 kernel/power/Kconfig                |   11 +
 kernel/power/main.c                 |  185 ++++++++++++++++++++++++++
 3 files changed, 204 insertions(+), 1 deletion(-)

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
@@ -2066,6 +2067,12 @@ and is between 256 and 4096 characters. 
 
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
@@ -132,6 +132,52 @@ static inline int suspend_test(int level
 
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
+	msec = jiffies_to_msecs((nj >= 0) ? nj : -nj);
+	pr_info("PM: %s took %d.%03d seconds\n", label,
+			msec / 1000, msec % 1000);
+	WARN_ON_ONCE(msec > (TEST_SUSPEND_SECONDS * 1000));
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
 
@@ -266,11 +312,14 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
+
+	suspend_test_start();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to suspend\n");
 		goto Resume_console;
 	}
+	suspend_test_finish("suspend devices");
 
 	if (suspend_test(TEST_DEVICES))
 		goto Resume_devices;
@@ -293,7 +342,9 @@ int suspend_devices_and_enter(suspend_st
 	if (suspend_ops->finish)
 		suspend_ops->finish();
  Resume_devices:
+	suspend_test_start();
 	device_resume(PMSG_RESUME);
+	suspend_test_finish("resume devices");
  Resume_console:
 	resume_console();
  Close:
@@ -517,3 +568,137 @@ static int __init pm_init(void)
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
+	static char		err_readtime [] __initdata =
+		KERN_ERR "PM: can't read %s time, err %d\n";
+	static char		err_wakealarm [] __initdata =
+		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
+	static char		err_suspend [] __initdata =
+		KERN_ERR "PM: suspend test failed, error %d\n";
+	static char		info_test [] __initdata =
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
+	class_find_device(rtc_class, &pony, has_wakealarm);
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

spi-fix-refcount-related-spidev-oops-on-rmmod.patch
mmc_spih-should-include-linux-interruptsh.patch
linux-next.patch
add-have_clk-to-kconfig-for-driver-dependencies.patch
acpi_pm_device_sleep_state-cleanup.patch
git-orion.patch
pm-boot-time-suspend-selftest.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
spi-kconfig-simplifications.patch
spi-make-spi_board_infomodalias-a-char-array.patch
spidev-bkl-removal.patch
gpio-sysfs-interface.patch

