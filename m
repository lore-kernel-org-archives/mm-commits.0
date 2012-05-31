From: akpm@linux-foundation.org
Subject: [merged] rtc-kconfig-place-rtc_drv_imxdi-and-rtc_mxc-under-on-cpu-rtc-drivers.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:27 -0700
Message-ID: <20120531192027.7A751A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:49749 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123Ab2EaTU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:29 -0400
Received: by faaa25 with SMTP id a25so75487faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: festevam@gmail.com, a.zummo@towertech.it, fabio.estevam@freescale.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/Kconfig: place RTC_DRV_IMXDI and RTC_MXC under "on-CPU RTC drivers"
has been removed from the -mm tree.  Its filename was
     rtc-kconfig-place-rtc_drv_imxdi-and-rtc_mxc-under-on-cpu-rtc-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Fabio Estevam <festevam@gmail.com>
Subject: drivers/rtc/Kconfig: place RTC_DRV_IMXDI and RTC_MXC under "on-CPU RTC drivers"

RTC_DRV_IMXDI and RTC_MXC are on-chip RTC modules, so move them under
"on-CPU RTC drivers" selection menu.

While at it change the dependency of RTC_DRV_IMXDI from ARCH_MX25 to
SOC_IMX25.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-kconfig-place-rtc_drv_imxdi-and-rtc_mxc-under-on-cpu-rtc-drivers drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-kconfig-place-rtc_drv_imxdi-and-rtc_mxc-under-on-cpu-rtc-drivers
+++ a/drivers/rtc/Kconfig
@@ -620,27 +620,6 @@ config RTC_DRV_MSM6242
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-msm6242.
 
-config RTC_DRV_IMXDI
-	tristate "Freescale IMX DryIce Real Time Clock"
-	depends on ARCH_MX25
-	depends on RTC_CLASS
-	help
-	   Support for Freescale IMX DryIce RTC
-
-	   This driver can also be built as a module, if so, the module
-	   will be called "rtc-imxdi".
-
-config RTC_MXC
-	tristate "Freescale MXC Real Time Clock"
-	depends on ARCH_MXC
-	depends on RTC_CLASS
-	help
-	   If you say yes here you get support for the Freescale MXC
-	   RTC module.
-
-	   This driver can also be built as a module, if so, the module
-	   will be called "rtc-mxc".
-
 config RTC_DRV_BQ4802
 	tristate "TI BQ4802"
 	help
@@ -738,6 +717,16 @@ config RTC_DRV_DAVINCI
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-davinci.
 
+config RTC_DRV_IMXDI
+	tristate "Freescale IMX DryIce Real Time Clock"
+	depends on SOC_IMX25
+	depends on RTC_CLASS
+	help
+	   Support for Freescale IMX DryIce RTC
+
+	   This driver can also be built as a module, if so, the module
+	   will be called "rtc-imxdi".
+
 config RTC_DRV_OMAP
 	tristate "TI OMAP1"
 	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 || ARCH_DAVINCI_DA8XX
@@ -1087,4 +1076,15 @@ config RTC_DRV_LOONGSON1
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ls1x.
 
+config RTC_MXC
+	tristate "Freescale MXC Real Time Clock"
+	depends on ARCH_MXC
+	depends on RTC_CLASS
+	help
+	   If you say yes here you get support for the Freescale MXC
+	   RTC module.
+
+	   This driver can also be built as a module, if so, the module
+	   will be called "rtc-mxc".
+
 endif # RTC_CLASS
_

Patches currently in -mm which might be from festevam@gmail.com are

origin.patch
linux-next.patch

