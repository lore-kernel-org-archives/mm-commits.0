From: akpm@linux-foundation.org
Subject: + remove-obsolete-sys-devices-power-state-docs.patch added to -mm tree
Date: Wed, 09 Jan 2008 16:21:05 -0800
Message-ID: <200801100021.m0A0L5NF028717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbYAJAVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2008 19:21:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     remove obsolete /sys/devices/.../power/state docs
has been added to the -mm tree.  Its filename is
     remove-obsolete-sys-devices-power-state-docs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove obsolete /sys/devices/.../power/state docs
From: David Brownell <david-b@pacbell.net>

The /sys/devices/.../power/state files have been gone for a while
now, but I just noticed some documentation that still refers to
them.  (Fortunately described as DEPRECATED and WILL REMOVE).

Time to remove that obsolete documentation too ...

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/devices.txt |   49 ------------------------------
 1 file changed, 49 deletions(-)

diff -puN Documentation/power/devices.txt~remove-obsolete-sys-devices-power-state-docs Documentation/power/devices.txt
--- a/Documentation/power/devices.txt~remove-obsolete-sys-devices-power-state-docs
+++ a/Documentation/power/devices.txt
@@ -502,52 +502,3 @@ If the CPU can have a "cpufreq" driver, 
 to shift to lower voltage settings and reduce the power cost of executing
 a given number of instructions.  (Without voltage adjustment, it's rare
 for cpufreq to save much power; the cost-per-instruction must go down.)
-
-
-/sys/devices/.../power/state files
-==================================
-For now you can also test some of this functionality using sysfs.
-
-	DEPRECATED:  USE "power/state" ONLY FOR DRIVER TESTING, AND
-	AVOID USING dev->power.power_state IN DRIVERS.
-
-	THESE WILL BE REMOVED.  IF THE "power/state" FILE GETS REPLACED,
-	IT WILL BECOME SOMETHING COUPLED TO THE BUS OR DRIVER.
-
-In each device's directory, there is a 'power' directory, which contains
-at least a 'state' file.  The value of this field is effectively boolean,
-PM_EVENT_ON or PM_EVENT_SUSPEND.
-
-   *	Reading from this file displays a value corresponding to
-	the power.power_state.event field.  All nonzero values are
-	displayed as "2", corresponding to a low power state; zero
-	is displayed as "0", corresponding to normal operation.
-
-   *	Writing to this file initiates a transition using the
-   	specified event code number; only '0', '2', and '3' are
-	accepted (without a newline); '2' and '3' are both
-	mapped to PM_EVENT_SUSPEND.
-
-On writes, the PM core relies on that recorded event code and the device/bus
-capabilities to determine whether it uses a partial suspend() or resume()
-sequence to change things so that the recorded event corresponds to the
-numeric parameter.
-
-   -	If the bus requires the irqs-disabled suspend_late()/resume_early()
-	phases, writes fail because those operations are not supported here.
-
-   -	If the recorded value is the expected value, nothing is done.
-
-   -	If the recorded value is nonzero, the device is partially resumed,
-	using the bus.resume() and/or class.resume() methods.
-
-   -	If the target value is nonzero, the device is partially suspended,
-	using the class.suspend() and/or bus.suspend() methods and the
-	PM_EVENT_SUSPEND message.
-
-Drivers have no way to tell whether their suspend() and resume() calls
-have come through the sysfs power/state file or as part of entering a
-system sleep state, except that when accessed through sysfs the normal
-parent/child sequencing rules are ignored.  Drivers (such as bus, bridge,
-or hub drivers) which expose child devices may need to enforce those rules
-on their own.
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-arm.patch
git-input.patch
git-mmc.patch
git-mtd.patch
pcmcia-stop-updating-dev-powerpower_state.patch
remove-obsolete-sys-devices-power-state-docs.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
spi-core-stop-updating-dev-powerpower_state.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
