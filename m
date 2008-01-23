From: akpm@linux-foundation.org
Subject: + at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch added to -mm tree
Date: Wed, 23 Jan 2008 13:08:31 -0800
Message-ID: <200801232108.m0NL8NOC026498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbYAWVJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jan 2008 16:09:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, david-b@pacbell.net, rmk@arm.linux.org.uk


The patch titled
     AT91: correct at91sam9263ek LCD power gpio pin
has been added to the -mm tree.  Its filename is
     at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch

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
Subject: AT91: correct at91sam9263ek LCD power gpio pin
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Correct GPIO pin assignment for the LCD power control (PCI)

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/board-sam9263ek.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/arm/mach-at91/board-sam9263ek.c~at91-correct-at91sam9263ek-lcd-power-gpio-pin arch/arm/mach-at91/board-sam9263ek.c
--- a/arch/arm/mach-at91/board-sam9263ek.c~at91-correct-at91sam9263ek-lcd-power-gpio-pin
+++ a/arch/arm/mach-at91/board-sam9263ek.c
@@ -242,10 +242,7 @@ static struct fb_monspecs at91fb_default
 
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

at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
atmel_lcdfb-backlight-control.patch
