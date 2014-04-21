From: akpm@linux-foundation.org
Subject: + dec-switch-decstation-systems-to-rtc-cmos.patch added to -mm
 tree
Date: Mon, 21 Apr 2014 14:25:46 -0700
Message-ID: <53558cda.0XP06Gxco+5DQJf7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbaDUVZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 17:25:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, a.zummo@towertech.it, macro@linux-mips.org

Subject: + dec-switch-decstation-systems-to-rtc-cmos.patch added to -mm tree
To: macro@linux-mips.org,a.zummo@towertech.it,ralf@linux-mips.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 14:25:46 -0700


The patch titled
     Subject: arch/mips/dec: switch DECstation systems to rtc-cmos
has been added to the -mm tree.  Its filename is
     dec-switch-decstation-systems-to-rtc-cmos.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dec-switch-decstation-systems-to-rtc-cmos.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dec-switch-decstation-systems-to-rtc-cmos.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: arch/mips/dec: switch DECstation systems to rtc-cmos

This adds an RTC platform device for DECstation systems so that they can
use the rtc-cmos driver for their RTC device.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/dec/Makefile   |    2 -
 arch/mips/dec/platform.c |   44 +++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff -puN arch/mips/dec/Makefile~dec-switch-decstation-systems-to-rtc-cmos arch/mips/dec/Makefile
--- a/arch/mips/dec/Makefile~dec-switch-decstation-systems-to-rtc-cmos
+++ a/arch/mips/dec/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y		:= ecc-berr.o int-handler.o ioasic-irq.o kn01-berr.o \
-		   kn02-irq.o kn02xa-berr.o reset.o setup.o time.o
+		   kn02-irq.o kn02xa-berr.o platform.o reset.o setup.o time.o
 
 obj-$(CONFIG_TC)		+= tc.o
 obj-$(CONFIG_CPU_HAS_WB)	+= wbflush.o
diff -puN /dev/null arch/mips/dec/platform.c
--- /dev/null
+++ a/arch/mips/dec/platform.c
@@ -0,0 +1,44 @@
+/*
+ *	DEC platform devices.
+ *
+ *	Copyright (c) 2014  Maciej W. Rozycki
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/mc146818rtc.h>
+#include <linux/platform_device.h>
+
+static struct resource dec_rtc_resources[] = {
+	{
+		.name = "rtc",
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct cmos_rtc_board_info dec_rtc_info = {
+	.flags = CMOS_RTC_FLAGS_NOFREQ,
+	.address_space = 64,
+};
+
+static struct platform_device dec_rtc_device = {
+	.name = "rtc_cmos",
+	.id = PLATFORM_DEVID_NONE,
+	.dev.platform_data = &dec_rtc_info,
+	.resource = dec_rtc_resources,
+	.num_resources = ARRAY_SIZE(dec_rtc_resources),
+};
+
+static int __init dec_add_devices(void)
+{
+	dec_rtc_resources[0].start = RTC_PORT(0);
+	dec_rtc_resources[0].end = RTC_PORT(0) + dec_kn_slot_size - 1;
+	return platform_device_register(&dec_rtc_device);
+}
+
+device_initcall(dec_add_devices);
_

Patches currently in -mm which might be from macro@linux-mips.org are

rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
dec-switch-decstation-systems-to-rtc-cmos.patch
linux-next.patch

