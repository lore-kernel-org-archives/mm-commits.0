From: akpm@linux-foundation.org
Subject: [failures] cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch removed from -mm tree
Date: Fri, 17 Apr 2009 11:34:48 -0700
Message-ID: <200904171834.n3HIYmIq029151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbZDQTOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 15:14:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix
has been removed from the -mm tree.  Its filename was
     cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix
From: Andres Salomon <dilinger@queued.net>

Force GPIO_CS553X to select GPIOLIB, which it makes use of.

akpm: still doesn't work though.  Randy said:

: When PCI is not enabled:
: 
: drivers/gpio/cs553x-gpio.c: In function 'cs553x_gpio_probe':
: drivers/gpio/cs553x-gpio.c:176: error: implicit declaration of function 'pci_enable_device_io'
: drivers/gpio/cs553x-gpio.c:182: error: implicit declaration of function 'pci_request_region'
: drivers/gpio/cs553x-gpio.c:207: error: implicit declaration of function 'pci_release_region'
: 
: I guess that OLPC needs an additional dependency on PCI ??

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/Kconfig~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix
+++ a/drivers/gpio/Kconfig
@@ -148,6 +148,7 @@ comment "PCI GPIO expanders:"
 config GPIO_CS553X
 	tristate "AMD cs5535/cs5536 GPIO support"
 	depends on PCI && !CS5535_GPIO && !MGEODE_LX
+	select GPIOLIB
 	help
 	  The AMD cs5535 and cs5536 southbridges support 28 GPIO pins that
 	  can be used for quite a number of things.  The cs553x is found on
_

Patches currently in -mm which might be from dilinger@queued.net are

cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

