From: akpm@linux-foundation.org
Subject: + rtc-omap-update-kconfig-for-omap-rtc.patch added to -mm tree
Date: Fri, 03 Apr 2015 14:39:42 -0700
Message-ID: <551f089e.L1iTS3lDBXt0Rhye%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbbDCVjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 17:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lokeshvutla@ti.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, nsekhar@ti.com, paul@pwsan.com, t-kristo@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/Kconfig: update Kconfig for OMAP RTC
has been added to the -mm tree.  Its filename is
     rtc-omap-update-kconfig-for-omap-rtc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-update-kconfig-for-omap-rtc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-update-kconfig-for-omap-rtc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: drivers/rtc/Kconfig: update Kconfig for OMAP RTC

RTC is present in AM43xx and DRA7xx also.  Updating the Kconfig to depend
on ARCH_OMAP or ARCH_DAVINCI

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-omap-update-kconfig-for-omap-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-omap-update-kconfig-for-omap-rtc
+++ a/drivers/rtc/Kconfig
@@ -1141,11 +1141,11 @@ config RTC_DRV_IMXDI
 	   will be called "rtc-imxdi".
 
 config RTC_DRV_OMAP
-	tristate "TI OMAP1"
-	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 || ARCH_DAVINCI_DA8XX || SOC_AM33XX
+	tristate "TI OMAP Real Time Clock"
+	depends on ARCH_OMAP || ARCH_DAVINCI
 	help
 	  Say "yes" here to support the on chip real time clock
-	  present on TI OMAP1, AM33xx and DA8xx/OMAP-L13x.
+	  present on TI OMAP1, AM33xx, DA8xx/OMAP-L13x, AM43xx and DRA7xx.
 
 	  This driver can also be built as a module, if so, module
 	  will be called rtc-omap.
_

Patches currently in -mm which might be from lokeshvutla@ti.com are

rtc-omap-unlock-and-lock-rtc-registers-before-and-after-register-writes.patch
rtc-omap-update-kconfig-for-omap-rtc.patch
rtc-omap-use-module_platform_driver.patch
linux-next.patch

