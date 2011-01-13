From: akpm@linux-foundation.org
Subject: [merged] gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:59 -0800
Message-ID: <201101132010.p0DKAem4030082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933757Ab1AMUUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, florian@openwrt.org, mm-commits@vger.kernel.org


The patch titled
     GPIO_RDC321X: select MFD_SUPPORT to squelch kconfig warning
has been removed from the -mm tree.  Its filename was
     gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
fs-fs_posix_acl-does-not-depend-on-block.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

