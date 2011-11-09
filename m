From: akpm@linux-foundation.org
Subject: + drivers-misc-eeprom-fix-dependecy-on-ppc_mpc5200_gpio.patch added to -mm tree
Date: Wed, 09 Nov 2011 13:58:40 -0800
Message-ID: <201111092158.pA9LweXd031542@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1KIV6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 16:58:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pebolle@tiscali.nl, agust@denx.de, grant.likely@secretlab.ca


The patch titled
     Subject: drivers/misc/eeprom: fix dependecy on 'PPC_MPC5200_GPIO'
has been added to the -mm tree.  Its filename is
     drivers-misc-eeprom-fix-dependecy-on-ppc_mpc5200_gpio.patch

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
From: Paul Bolle <pebolle@tiscali.nl>
Subject: drivers/misc/eeprom: fix dependecy on 'PPC_MPC5200_GPIO'

The driver for the DigsyMTC display configuration EEPROMs device got added
by commit 469dded183 ("misc/eeprom: add eeprom access driver for digsy_mtc
board").  Its Kconfig symbol depends on PPC_MPC5200_GPIO.  But at the time
that driver got added PPC_MPC5200_GPIO was already renamed to
GPIO_MPC5200, by commit 6eae1ace68 ("gpio: Move mpc5200 gpio driver to
drivers/gpio").

So make this driver depend on GPIO_MPC5200. And since GPIO_MPC5200 itself
implies that GPIOLIB is set, that dependency can be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Anatolij Gustschin <agust@denx.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/eeprom/Kconfig~drivers-misc-eeprom-fix-dependecy-on-ppc_mpc5200_gpio drivers/misc/eeprom/Kconfig
--- a/drivers/misc/eeprom/Kconfig~drivers-misc-eeprom-fix-dependecy-on-ppc_mpc5200_gpio
+++ a/drivers/misc/eeprom/Kconfig
@@ -85,7 +85,7 @@ config EEPROM_93XX46
 
 config EEPROM_DIGSY_MTC_CFG
 	bool "DigsyMTC display configuration EEPROMs device"
-	depends on PPC_MPC5200_GPIO && GPIOLIB && SPI_GPIO
+	depends on GPIO_MPC5200 && SPI_GPIO
 	help
 	  This option enables access to display configuration EEPROMs
 	  on digsy_mtc board. You have to additionally select Microwire
_
Subject: Subject: drivers/misc/eeprom: fix dependecy on 'PPC_MPC5200_GPIO'

Patches currently in -mm which might be from pebolle@tiscali.nl are

linux-next.patch
drivers-misc-eeprom-fix-dependecy-on-ppc_mpc5200_gpio.patch

