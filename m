From: akpm@linux-foundation.org
Subject: - rename-tanbac-tb0219-config.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:01 -0700
Message-ID: <200705080008.l48081Nm009348@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967428AbXEHAId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     rename TANBAC TB0219 config
has been removed from the -mm tree.  Its filename was
     rename-tanbac-tb0219-config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rename TANBAC TB0219 config
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Rename config for TANBAC TB0219 GPIO support to something more appropriate.

Fixes this:

drivers/char/Kconfig:906:warning: type of 'TANBAC_TB0219' redefined from 'boolean' to 'tristate'
drivers/char/Kconfig:907:warning: choice values currently only support a single
prompt

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig  |    4 ++--
 drivers/char/Makefile |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/Kconfig~rename-tanbac-tb0219-config drivers/char/Kconfig
--- a/drivers/char/Kconfig~rename-tanbac-tb0219-config
+++ a/drivers/char/Kconfig
@@ -905,8 +905,8 @@ config SONYPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called sonypi.
 
-config TANBAC_TB0219
-	tristate "TANBAC TB0219 base board support"
+config GPIO_TB0219
+	tristate "TANBAC TB0219 GPIO support"
 	depends on TANBAC_TB022X
 	select GPIO_VR41XX
 
diff -puN drivers/char/Makefile~rename-tanbac-tb0219-config drivers/char/Makefile
--- a/drivers/char/Makefile~rename-tanbac-tb0219-config
+++ a/drivers/char/Makefile
@@ -91,7 +91,7 @@ obj-$(CONFIG_PC8736x_GPIO)	+= pc8736x_gp
 obj-$(CONFIG_NSC_GPIO)		+= nsc_gpio.o
 obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
 obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
-obj-$(CONFIG_TANBAC_TB0219)	+= tb0219.o
+obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
 obj-$(CONFIG_TELCLOCK)		+= tlclk.o
 
 obj-$(CONFIG_WATCHDOG)		+= watchdog/
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch
git-mips.patch
rtc-update-vr41xx-alarm-handling.patch
