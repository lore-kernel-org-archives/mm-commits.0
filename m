From: akpm@linux-foundation.org
Subject: - provide-rtc_cmos-platform-device-take-2.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:04:08 -0700
Message-ID: <200806160604.m5G648Aq010657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751940AbYFPGGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:06:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stsp@aknet.ru, ambx1@neo.rr.com, bjorn.helgaas@hp.com, david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     provide rtc_cmos platform device
has been removed from the -mm tree.  Its filename was
     provide-rtc_cmos-platform-device-take-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: provide rtc_cmos platform device
From: Stas Sergeev <stsp@aknet.ru>

Recently (around 2.6.25) I've noticed that RTC no longer works for me.  It
turned out this is because I use pnpacpi=off kernel option to work around
the parport_pc bugs.  I always did so, but RTC used to work fine in the
past, and now it have regressed.

The patch fixes the problem by creating the platform device for the RTC
when PNP is disabled.  This may also help running the PNP-enabled kernel
on an older PCs.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/rtc.c  |   34 ++++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-cmos.c |   31 ++++++++++++++++---------------
 2 files changed, 50 insertions(+), 15 deletions(-)

diff -puN arch/x86/kernel/rtc.c~provide-rtc_cmos-platform-device-take-2 arch/x86/kernel/rtc.c
--- a/arch/x86/kernel/rtc.c~provide-rtc_cmos-platform-device-take-2
+++ a/arch/x86/kernel/rtc.c
@@ -4,6 +4,8 @@
 #include <linux/acpi.h>
 #include <linux/bcd.h>
 #include <linux/mc146818rtc.h>
+#include <linux/platform_device.h>
+#include <linux/pnp.h>
 
 #include <asm/time.h>
 #include <asm/vsyscall.h>
@@ -197,3 +199,35 @@ unsigned long long native_read_tsc(void)
 }
 EXPORT_SYMBOL(native_read_tsc);
 
+
+static struct resource rtc_resources[] = {
+	[0] = {
+		.start	= RTC_PORT(0),
+		.end	= RTC_PORT(1),
+		.flags	= IORESOURCE_IO,
+	},
+	[1] = {
+		.start	= RTC_IRQ,
+		.end	= RTC_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device rtc_device = {
+	.name		= "rtc_cmos",
+	.id		= -1,
+	.resource	= rtc_resources,
+	.num_resources	= ARRAY_SIZE(rtc_resources),
+};
+
+static __init int add_rtc_cmos(void)
+{
+#ifdef CONFIG_PNP
+	if (!pnp_platform_devices)
+		platform_device_register(&rtc_device);
+#else
+	platform_device_register(&rtc_device);
+#endif /* CONFIG_PNP */
+	return 0;
+}
+device_initcall(add_rtc_cmos);
diff -puN drivers/rtc/rtc-cmos.c~provide-rtc_cmos-platform-device-take-2 drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~provide-rtc_cmos-platform-device-take-2
+++ a/drivers/rtc/rtc-cmos.c
@@ -905,19 +905,7 @@ static struct pnp_driver cmos_pnp_driver
 	.resume		= cmos_pnp_resume,
 };
 
-static int __init cmos_init(void)
-{
-	return pnp_register_driver(&cmos_pnp_driver);
-}
-module_init(cmos_init);
-
-static void __exit cmos_exit(void)
-{
-	pnp_unregister_driver(&cmos_pnp_driver);
-}
-module_exit(cmos_exit);
-
-#else	/* no PNP */
+#endif	/* CONFIG_PNP */
 
 /*----------------------------------------------------------------*/
 
@@ -958,20 +946,33 @@ static struct platform_driver cmos_platf
 
 static int __init cmos_init(void)
 {
+#ifdef	CONFIG_PNP
+	if (pnp_platform_devices)
+		return pnp_register_driver(&cmos_pnp_driver);
+	else
+		return platform_driver_probe(&cmos_platform_driver,
+			cmos_platform_probe);
+#else
 	return platform_driver_probe(&cmos_platform_driver,
 			cmos_platform_probe);
+#endif /* CONFIG_PNP */
 }
 module_init(cmos_init);
 
 static void __exit cmos_exit(void)
 {
+#ifdef	CONFIG_PNP
+	if (pnp_platform_devices)
+		pnp_unregister_driver(&cmos_pnp_driver);
+	else
+		platform_driver_unregister(&cmos_platform_driver);
+#else
 	platform_driver_unregister(&cmos_platform_driver);
+#endif /* CONFIG_PNP */
 }
 module_exit(cmos_exit);
 
 
-#endif	/* !PNP */
