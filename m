From: akpm@linux-foundation.org
Subject: + rtc-omap-depend-on-am33xx.patch added to -mm tree
Date: Mon, 22 Oct 2012 15:21:05 -0700
Message-ID: <20121022222106.3B91F1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40624 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2JVWVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 18:21:07 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so406152yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 15:21:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: afzal@ti.com, a.zummo@towertech.it, grant.likely@secretlab.ca, hvaibhav@ti.com, khilman@ti.com, linux@arm.linux.org.uk, nsekhar@ti.com, zonque@gmail.com


The patch titled
     Subject: rtc: omap: depend on am33xx
has been added to the -mm tree.  Its filename is
     rtc-omap-depend-on-am33xx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-omap-kicker-mechanism-support.patch
arm-davinci-remove-rtc-kicker-release.patch
rtc-omap-dt-support.patch
rtc-omap-depend-on-am33xx.patch
rtc-omap-add-runtime-pm-support.patch

