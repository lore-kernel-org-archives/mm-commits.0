From: akpm@linux-foundation.org
Subject: + rtc-kconfig-place-rtc_drv_imxdi-and-rtc_mxc-under-on-cpu-rtc-drivers.patch added to -mm tree
Date: Fri, 06 Apr 2012 14:55:49 -0700
Message-ID: <20120406215550.BE8EBA0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57783 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2DFVzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 17:55:53 -0400
Received: by bkcjm19 with SMTP id jm19so131995bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 14:55:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: festevam@gmail.com, a.zummo@towertech.it, fabio.estevam@freescale.com, w.sang@pengutronix.de


The patch titled
     Subject: drivers/rtc/Kconfig: place RTC_DRV_IMXDI and RTC_MXC under "on-CPU RTC drivers"
has been added to the -mm tree.  Its filename is
     rtc-kconfig-place-rtc_drv_imxdi-and-rtc_mxc-under-on-cpu-rtc-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/rtc/Kconfig: place RTC_DRV_IMXDI and RTC_MXC under "on-CPU RTC drivers"

Patches currently in -mm which might be from festevam@gmail.com are

origin.patch
linux-next.patch
rtc-kconfig-place-rtc_drv_imxdi-and-rtc_mxc-under-on-cpu-rtc-drivers.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

