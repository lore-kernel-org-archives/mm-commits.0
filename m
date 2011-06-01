From: akpm@linux-foundation.org
Subject: [merged] gpio-show-explicit-dependency-between-gpio_cs5535-and-mfd_cs5535.patch removed from -mm tree
Date: Wed, 01 Jun 2011 13:34:00 -0700
Message-ID: <201106012033.p51KXYD7008098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759574Ab1FAUd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 16:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@wildgooses.com, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     gpio: show explicit dependency between GPIO_CS5535 and MFD_CS5535
has been removed from the -mm tree.  Its filename was
     gpio-show-explicit-dependency-between-gpio_cs5535-and-mfd_cs5535.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: show explicit dependency between GPIO_CS5535 and MFD_CS5535
From: Ed Wildgoose <kernel@wildgooses.com>

cs5535-gpio.c has been split into two, with various setup moved into
cs5535-mfd.c.  Given that cs5535-gpio will not load without the -mfd part,
lets make that dependency explicit in Kconfig

Signed-off-by: Ed Wildgoose <kernel@wildgooses.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/Kconfig~gpio-show-explicit-dependency-between-gpio_cs5535-and-mfd_cs5535 drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-show-explicit-dependency-between-gpio_cs5535-and-mfd_cs5535
+++ a/drivers/gpio/Kconfig
@@ -298,7 +298,7 @@ comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
 	tristate "AMD CS5535/CS5536 GPIO support"
-	depends on PCI && X86 && !CS5535_GPIO
+	depends on PCI && X86 && !CS5535_GPIO && MFD_CS5535
 	help
 	  The AMD CS5535 and CS5536 southbridges support 28 GPIO pins that
 	  can be used for quite a number of things.  The CS5535/6 is found on
_

Patches currently in -mm which might be from kernel@wildgooses.com are

leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface.patch

