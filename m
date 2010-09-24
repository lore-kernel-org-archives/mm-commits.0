From: akpm@linux-foundation.org
Subject: + rtc-omap-let-device-wakeup-capability-be-configured-from-chip-init-logic.patch added to -mm tree
Date: Fri, 24 Sep 2010 12:51:27 -0700
Message-ID: <201009241951.o8OJpRmh021743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758028Ab0IXTwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 15:52:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nsekhar@ti.com, a.zummo@towertech.it, david-b@pacbell.net, khilman@deeprootsystems.com, mcuos.com@gmail.com, tony@atomide.com


The patch titled
     rtc: omap: let device wakeup capability be configured from chip init logic
has been added to the -mm tree.  Its filename is
     rtc-omap-let-device-wakeup-capability-be-configured-from-chip-init-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: omap: let device wakeup capability be configured from chip init logic
From: Sekhar Nori <nsekhar@ti.com>

The rtc-omap driver currently hardcodes the RTC wakeup capability to be
"not capable".  While this seems to be true for existing OMAP1 boards
which are not wired for this, the DA850/OMAP-L138 SoC, the RTC can always
be wake up source from its "deep sleep" mode.

This patch lets the wakeup capability be set from platform data and does
not override the setting from the driver.  For DA850/OMAP-L138, this is
done from arch/arm/mach-davinci/devices-da8xx.c:da8xx_register_rtc()

Note that this patch does not change the behavior on any existing OMAP1
board since the platform device registration sets the wakeup capability to
0 by default.

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-let-device-wakeup-capability-be-configured-from-chip-init-logic drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-let-device-wakeup-capability-be-configured-from-chip-init-logic
+++ a/drivers/rtc/rtc-omap.c
@@ -34,7 +34,8 @@
  * Board-specific wiring options include using split power mode with
  * RTC_OFF_NOFF used as the reset signal (so the RTC won't be reset),
  * and wiring RTC_WAKE_INT (so the RTC alarm can wake the system from
- * low power modes).  See the BOARD-SPECIFIC CUSTOMIZATION comment.
+ * low power modes) for OMAP1 boards (OMAP-L138 has this built into
+ * the SoC). See the BOARD-SPECIFIC CUSTOMIZATION comment.
  */
 
 #define OMAP_RTC_BASE			0xfffb4800
@@ -401,16 +402,17 @@ static int __init omap_rtc_probe(struct 
 
 	/* BOARD-SPECIFIC CUSTOMIZATION CAN GO HERE:
 	 *
-	 *  - Boards wired so that RTC_WAKE_INT does something, and muxed
-	 *    right (W13_1610_RTC_WAKE_INT is the default after chip reset),
-	 *    should initialize the device wakeup flag appropriately.
+	 *  - Device wake-up capability setting should come through chip
+	 *    init logic. OMAP1 boards should initialize the "wakeup capable"
+	 *    flag in the platform device if the board is wired right for
+	 *    being woken up by RTC alarm. For OMAP-L138, this capability
+	 *    is built into the SoC by the "Deep Sleep" capability.
 	 *
 	 *  - Boards wired so RTC_ON_nOFF is used as the reset signal,
 	 *    rather than nPWRON_RESET, should forcibly enable split
 	 *    power mode.  (Some chip errata report that RTC_CTRL_SPLIT
 	 *    is write-only, and always reads as zero...)
 	 */
-	device_init_wakeup(&pdev->dev, 0);
 
 	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
 		pr_info("%s: split power mode\n", pdev->name);
_

Patches currently in -mm which might be from nsekhar@ti.com are

linux-next.patch
rtc-omap-let-device-wakeup-capability-be-configured-from-chip-init-logic.patch

