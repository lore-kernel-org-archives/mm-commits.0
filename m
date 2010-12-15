From: akpm@linux-foundation.org
Subject: + gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning.patch added to -mm tree
Date: Wed, 15 Dec 2010 14:31:45 -0800
Message-ID: <201012152231.oBFMVj6Q009842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab0LOWbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 17:31:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, florian@openwrt.org


The patch titled
     GPIO_RDC321X: select MFD_SUPPORT to squelch kconfig warning
has been added to the -mm tree.  Its filename is
     gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning.patch

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
Subject: GPIO_RDC321X: select MFD_SUPPORT to squelch kconfig warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (GPIO_RDC321X && PCI && GPIOLIB) selects MFD_RDC321X which has unmet direct dependencies (MFD_SUPPORT && PCI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/Kconfig~gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning
+++ a/drivers/gpio/Kconfig
@@ -342,6 +342,7 @@ config GPIO_TIMBERDALE
 config GPIO_RDC321X
 	tristate "RDC R-321x GPIO support"
 	depends on PCI && GPIOLIB
+	select MFD_SUPPORT
 	select MFD_CORE
 	select MFD_RDC321X
 	help
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
uml-mmapper_kern-needs-module_license.patch
kernel-clean-up-use_generic_smp_helpers.patch
gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning.patch
gpio_vx855-eliminate-kconfig-dependency-warning.patch
w1-ds2423-counter-driver-and-documentation-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

