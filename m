From: akpm@linux-foundation.org
Subject: [nacked] hrtimers-special-case-zero-length-sleeps.patch removed from -mm tree
Date: Tue, 06 Mar 2012 12:40:49 -0800
Message-ID: <20120306204049.DB114A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:33505 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031036Ab2CFUku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 15:40:50 -0500
Received: by ggnd2 with SMTP id d2so688613ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 12:40:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg@redhat.com, arjan@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: hrtimers: Special-case zero length sleeps
has been removed from the -mm tree.  Its filename was
     hrtimers-special-case-zero-length-sleeps.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matthew Garrett <mjg@redhat.com>
Subject: hrtimers: Special-case zero length sleeps

sleep(0) is a common construct used by applications that want to trigger
the scheduler.  sched_yield() might make more sense, but only appeared in
POSIX.1-2001 and so plenty of example code still uses the sleep(0) form.

This wouldn't normally be a problem, but it means that event-driven
applications that are merely trying to avoid starving other processes may
actually end up sleeping due to having large timer_slack values.  Special-
casing this seems reasonable.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN kernel/hrtimer.c~hrtimers-special-case-zero-length-sleeps kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-special-case-zero-length-sleeps
+++ a/kernel/hrtimer.c
@@ -1568,6 +1568,14 @@ long hrtimer_nanosleep(struct timespec *
 	if (rt_task(current))
 		slack = 0;
 
+	/*
+	 * Applications will often sleep(0) to indicate that they wish to
+	 * be scheduled. Special case that to avoid actually putting them
+	 * to sleep for the duration of the slack.
+	 */
+	if (rqtp->tv_sec == 0 && rqtp->tv_nsec == 0)
+		slack = 0;
+
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
 	if (do_nanosleep(&t, mode))
_

Patches currently in -mm which might be from mjg@redhat.com are

origin.patch
linux-next.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
acerhdf-add-support-for-new-hardware.patch
acerhdf-lowered-default-temp-fanon-fanoff-values.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
geos-platform-driver-for-geos-and-geos2-single-board-computers.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
platform-x86-kill-off-moorestown.patch
intel_scu_ipc-remove-moorestown-support.patch
platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch
platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch
platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch
intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch
intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch
drivers-platform-x86-acer-wmic-no-wifi-rfkill-on-lenovo-machines.patch
alix2-supplement-driver-to-include-gpio-button-support.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
ipmi-increase-kcs-timeouts.patch

