From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-depend-on-am33xx.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:31 -0800
Message-ID: <20121218200731.C8C9A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:55819 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2LRUHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:33 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so126009yen.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: afzal@ti.com, a.zummo@towertech.it, grant.likely@secretlab.ca, hvaibhav@ti.com, khilman@ti.com, linux@arm.linux.org.uk, nsekhar@ti.com, zonque@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: depend on am33xx
has been removed from the -mm tree.  Its filename was
     rtc-omap-depend-on-am33xx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Afzal Mohammed <afzal@ti.com>
Subject: rtc: omap: depend on am33xx

rtc-omap driver can be reused for AM33xx RTC.  Provide dependency in
Kconfig.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-omap-depend-on-am33xx drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-omap-depend-on-am33xx
+++ a/drivers/rtc/Kconfig
@@ -777,11 +777,13 @@ config RTC_DRV_IMXDI
 
 config RTC_DRV_OMAP
 	tristate "TI OMAP1"
-	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 || ARCH_DAVINCI_DA8XX
+	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 || ARCH_DAVINCI_DA8XX || SOC_AM33XX
 	help
-	  Say "yes" here to support the real time clock on TI OMAP1 and
-	  DA8xx/OMAP-L13x chips.  This driver can also be built as a
-	  module called rtc-omap.
+	  Say "yes" here to support the on chip real time clock
+	  present on TI OMAP1, AM33xx and DA8xx/OMAP-L13x.
+
+	  This driver can also be built as a module, if so, module
+	  will be called rtc-omap.
 
 config HAVE_S3C_RTC
 	bool
_

Patches currently in -mm which might be from afzal@ti.com are

origin.patch

