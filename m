From: akpm@linux-foundation.org
Subject: + gpio-show-explicit-dependency-between-gpio_cs5535-and-mfd_cs5535.patch added to -mm tree
Date: Thu, 07 Apr 2011 15:51:15 -0700
Message-ID: <201104072251.p37MpFcn005184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756880Ab1DGWvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 18:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@wildgooses.com, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     From: kernel@wildgooses.com
has been added to the -mm tree.  Its filename is
     gpio-show-explicit-dependency-between-gpio_cs5535-and-mfd_cs5535.patch

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
Subject: From: kernel@wildgooses.com
From: Ed Wildgoose <kernel@wildgooses.com>


cs5535-gpio.c has been split into two, with various setup moved
into cs5535-mfd.c.  Given that cs5535-gpio will not load without
the -mfd part, lets make that dependency explicit in Kconfig

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
gpio-show-explicit-dependency-between-gpio_cs5535-and-mfd_cs5535.patch

