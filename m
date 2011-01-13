From: akpm@linux-foundation.org
Subject: [merged] gpio_vx855-eliminate-kconfig-dependency-warning.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:01 -0800
Message-ID: <201101132010.p0DKAgcY030085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933651Ab1AMULR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dsd@laptop.org, mm-commits@vger.kernel.org


The patch titled
     GPIO_VX855: eliminate kconfig dependency warning
has been removed from the -mm tree.  Its filename was
     gpio_vx855-eliminate-kconfig-dependency-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
fs-fs_posix_acl-does-not-depend-on-block.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

