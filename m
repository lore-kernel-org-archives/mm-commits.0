From: akpm@linux-foundation.org
Subject: [merged] rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:29 -0700
Message-ID: <20120531192029.5F5E3A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:49749 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab2EaTUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:31 -0400
Received: by mail-fa0-f74.google.com with SMTP id a25so75487faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: festevam@gmail.com, a.zummo@towertech.it, fabio.estevam@freescale.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC
has been removed from the -mm tree.  Its filename was
     rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Fabio Estevam <festevam@gmail.com>
Subject: rtc: rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC

In order to keep consistency with other rtc drivers,rename CONFIG_RTC_MXC
to CONFIG_RTC_DRV_MXC.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
[akpm@linux-foundation.org: fix missed arch/arm/configs/imx_v6_v7_defconfig]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/imx_v4_v5_defconfig |    2 +-
 arch/arm/configs/imx_v6_v7_defconfig |    2 +-
 drivers/rtc/Kconfig                  |    2 +-
 drivers/rtc/Makefile                 |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/arm/configs/imx_v4_v5_defconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc arch/arm/configs/imx_v4_v5_defconfig
--- a/arch/arm/configs/imx_v4_v5_defconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc
+++ a/arch/arm/configs/imx_v4_v5_defconfig
@@ -173,7 +173,7 @@ CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PCF8563=y
 CONFIG_RTC_DRV_IMXDI=y
-CONFIG_RTC_MXC=y
+CONFIG_RTC_DRV_MXC=y
 CONFIG_DMADEVICES=y
 CONFIG_IMX_SDMA=y
 CONFIG_IMX_DMA=y
diff -puN arch/arm/configs/imx_v6_v7_defconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc arch/arm/configs/imx_v6_v7_defconfig
--- a/arch/arm/configs/imx_v6_v7_defconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc
+++ a/arch/arm/configs/imx_v6_v7_defconfig
@@ -178,7 +178,7 @@ CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_INTF_DEV_UIE_EMUL=y
-CONFIG_RTC_MXC=y
+CONFIG_RTC_DRV_MXC=y
 CONFIG_DMADEVICES=y
 CONFIG_IMX_SDMA=y
 CONFIG_EXT2_FS=y
diff -puN drivers/rtc/Kconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc
+++ a/drivers/rtc/Kconfig
@@ -1076,7 +1076,7 @@ config RTC_DRV_LOONGSON1
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ls1x.
 
-config RTC_MXC
+config RTC_DRV_MXC
 	tristate "Freescale MXC Real Time Clock"
 	depends on ARCH_MXC
 	depends on RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc
+++ a/drivers/rtc/Makefile
@@ -61,7 +61,7 @@ obj-$(CONFIG_RTC_DRV_M41T94)	+= rtc-m41t
 obj-$(CONFIG_RTC_DRV_M48T35)	+= rtc-m48t35.o
 obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
 obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
-obj-$(CONFIG_RTC_MXC)		+= rtc-mxc.o
+obj-$(CONFIG_RTC_DRV_MXC)	+= rtc-mxc.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX8925)	+= rtc-max8925.o
 obj-$(CONFIG_RTC_DRV_MAX8998)	+= rtc-max8998.o
_

Patches currently in -mm which might be from festevam@gmail.com are

origin.patch
linux-next.patch

