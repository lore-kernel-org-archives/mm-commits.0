From: akpm@linux-foundation.org
Subject: + gpio_vx855-eliminate-kconfig-dependency-warning.patch added to -mm tree
Date: Wed, 15 Dec 2010 14:31:47 -0800
Message-ID: <201012152231.oBFMVlKX009846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab0LOWbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 17:31:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dsd@laptop.org


The patch titled
     GPIO_VX855: eliminate kconfig dependency warning
has been added to the -mm tree.  Its filename is
     gpio_vx855-eliminate-kconfig-dependency-warning.patch

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
Subject: GPIO_VX855: eliminate kconfig dependency warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (GPIO_VX855 && GPIOLIB) selects MFD_VX855 which has unmet direct dependencies (MFD_SUPPORT && PCI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Daniel Drake <dsd@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/Kconfig~gpio_vx855-eliminate-kconfig-dependency-warning drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio_vx855-eliminate-kconfig-dependency-warning
+++ a/drivers/gpio/Kconfig
@@ -118,7 +118,7 @@ config GPIO_SCH
 
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
-	depends on GPIOLIB
+	depends on GPIOLIB && MFD_SUPPORT && PCI
 	select MFD_CORE
 	select MFD_VX855
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

