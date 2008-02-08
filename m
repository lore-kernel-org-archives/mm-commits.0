From: akpm@linux-foundation.org
Subject: + rtc-cmos-display-hpet-emulation-mode.patch added to -mm tree
Date: Fri, 08 Feb 2008 15:58:04 -0800
Message-ID: <200802082357.m18Nvj1L020584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589AbYBHX7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 18:59:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     rtc-cmos: display HPET emulation mode
has been added to the -mm tree.  Its filename is
     rtc-cmos-display-hpet-emulation-mode.patch

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

origin.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-mmc.patch
usb-ehci-tolerates-some-buggy-devices.patch
rtc-cmos-display-hpet-emulation-mode.patch
