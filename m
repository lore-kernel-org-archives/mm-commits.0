From: akpm@linux-foundation.org
Subject: - at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:21:27 -0800
Message-ID: <200803062221.m26MLRmP020720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759232AbYCFWXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, david-b@pacbell.net, linux@maxim.org.za, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     AT91: correct at91sam9263ek LCD power gpio pin
has been removed from the -mm tree.  Its filename was
     at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: AT91: correct at91sam9263ek LCD power gpio pin
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Correct GPIO pin assignment for the LCD power control (PCI)

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/board-sam9263ek.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/arm/mach-at91/board-sam9263ek.c~at91-correct-at91sam9263ek-lcd-power-gpio-pin arch/arm/mach-at91/board-sam9263ek.c
--- a/arch/arm/mach-at91/board-sam9263ek.c~at91-correct-at91sam9263ek-lcd-power-gpio-pin
+++ a/arch/arm/mach-at91/board-sam9263ek.c
@@ -245,10 +245,7 @@ static struct fb_monspecs at91fb_default
 
 static void at91_lcdc_power_control(int on)
 {
-	if (on)
-		at91_set_gpio_value(AT91_PIN_PD12, 0);	/* power up */
-	else
-		at91_set_gpio_value(AT91_PIN_PD12, 1);	/* power down */
+	at91_set_gpio_value(AT91_PIN_PA30, on);
 }
 
 /* Driver datas */
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

git-arm-master.patch

