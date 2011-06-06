From: akpm@linux-foundation.org
Subject: + leds-move-leds_gpio_register-out-of-menuconfig-new_leds.patch added to -mm tree
Date: Mon, 06 Jun 2011 13:38:37 -0700
Message-ID: <201106062038.p56Kcccr020877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757989Ab1FFUjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2011 16:39:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, axel.lin@gmail.com, rpurdie@rpsys.net


The patch titled
     leds: move LEDS_GPIO_REGISTER out of menuconfig NEW_LEDS
has been added to the -mm tree.  Its filename is
     leds-move-leds_gpio_register-out-of-menuconfig-new_leds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: leds: move LEDS_GPIO_REGISTER out of menuconfig NEW_LEDS
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Commit 4440673a ("leds: provide helper to register "leds-gpio" devices"=
)
broke the display of the NEW_LEDS menu as it didn't depend on NEW_LEDS =
and
so made "LED drivers" and "LED Triggers" appear at the same level as "L=
ED
Support" instead of below it as it was before 4440673a.

Moving LEDS_GPIO_REGISTER out of the menuconfig NEW_LEDS fixes this
unintended side effect.

Reported-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/leds/Kconfig~leds-move-leds_gpio_register-out-of-menu=
config-new_leds drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-move-leds_gpio_register-out-of-menuconf=
ig-new_leds
+++ a/drivers/leds/Kconfig
@@ -1,3 +1,10 @@
+config LEDS_GPIO_REGISTER
+	bool
+	help
+	  This option provides the function gpio_led_register_device.
+	  As this function is used by arch code it must not be compiled as a
+	  module.
+
 menuconfig NEW_LEDS
 	bool "LED Support"
 	help
@@ -14,13 +21,6 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
=20
-config LEDS_GPIO_REGISTER
-	bool
-	help
-	  This option provides the function gpio_led_register_device.
-	  As this function is used by arch code it must not be compiled as a
-	  module.
