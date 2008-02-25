From: akpm@linux-foundation.org
Subject: - rtc-cmos-display-hpet-emulation-mode.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:55 -0800
Message-ID: <200802250044.m1P0it8D006144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029AbYBYAtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:49:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos: display HPET emulation mode
has been removed from the -mm tree.  Its filename was
     rtc-cmos-display-hpet-emulation-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cmos: display HPET emulation mode
From: David Brownell <david-b@pacbell.net>

For the "cmos" RTC, have /proc/driver/rtc say whether HPET based IRQ
emulation is in effect.  Given the problems we've had with this particular
hardware maldesign (and the fact that most BIOS code seems not to provide
the IRQ routing needed to use the saner HPET modes), this should help
troubleshooting.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-display-hpet-emulation-mode drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-display-hpet-emulation-mode
+++ a/drivers/rtc/rtc-cmos.c
@@ -388,6 +388,7 @@ static int cmos_procfs(struct device *de
 	return seq_printf(seq,
 			"periodic_IRQ\t: %s\n"
 			"update_IRQ\t: %s\n"
+			"HPET_emulated\t: %s\n"
 			// "square_wave\t: %s\n"
 			// "BCD\t\t: %s\n"
 			"DST_enable\t: %s\n"
@@ -395,6 +396,7 @@ static int cmos_procfs(struct device *de
 			"batt_status\t: %s\n",
 			(rtc_control & RTC_PIE) ? "yes" : "no",
 			(rtc_control & RTC_UIE) ? "yes" : "no",
+			is_hpet_enabled() ? "yes" : "no",
 			// (rtc_control & RTC_SQWE) ? "yes" : "no",
 			// (rtc_control & RTC_DM_BINARY) ? "no" : "yes",
 			(rtc_control & RTC_DST_EN) ? "yes" : "no",
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
git-avr32.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
