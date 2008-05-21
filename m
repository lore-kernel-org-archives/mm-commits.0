From: akpm@linux-foundation.org
Subject: + x86-provide-rtc_cmos-platform-device.patch added to -mm tree
Date: Wed, 21 May 2008 15:32:28 -0700
Message-ID: <200805212232.m4LMWS99004100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761443AbYEUWeO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 18:34:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stsp@aknet.ru, ambx1@neo.rr.com, bjorn.helgaas@hp.com, david-b@pacbell.net, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de


The patch titled
     x86: provide rtc_cmos platform device
has been added to the -mm tree.  Its filename is
     x86-provide-rtc_cmos-platform-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: provide rtc_cmos platform device
From: Stas Sergeev <stsp@aknet.ru>

Recently (around 2.6.25) I've noticed that RTC no longer works for me.  It
turned out this is because I use pnpacpi=off kernel option to work around
the parport_pc bugs.  I always did so, but RTC used to work fine in the
past, and now it have regressed.

The attached patch fixes the problem by creating the platform device for
the RTC when PNP is disabled.  This may also help running the PNP-enabled
kernel on an older PCs.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/rtc.c  |   31 +++++++++++++++++++++++++++++++
 drivers/rtc/rtc-cmos.c |   26 +++++++++-----------------
 include/asm-x86/rtc.h  |    4 ++++
 3 files changed, 44 insertions(+), 17 deletions(-)

diff -puN arch/x86/kernel/rtc.c~x86-provide-rtc_cmos-platform-device arch/x86/kernel/rtc.c
--- a/arch/x86/kernel/rtc.c~x86-provide-rtc_cmos-platform-device
+++ a/arch/x86/kernel/rtc.c
@@ -4,9 +4,12 @@
 #include <linux/acpi.h>
 #include <linux/bcd.h>
 #include <linux/mc146818rtc.h>
+#include <linux/platform_device.h>
+#include <linux/pnp.h>
 
 #include <asm/time.h>
 #include <asm/vsyscall.h>
+#include <asm/rtc.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -197,3 +200,31 @@ unsigned long long native_read_tsc(void)
 }
 EXPORT_SYMBOL(native_read_tsc);
 
+
+static struct resource rtc_resources[] = {
+	[0] = {
+		.start	= RTC_PORT_START,
+		.end	= RTC_PORT_END,
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
+	if (!pnp_platform_devices)
+		platform_device_register(&rtc_device);
+	return 0;
+}
+device_initcall(add_rtc_cmos);
diff -puN drivers/rtc/rtc-cmos.c~x86-provide-rtc_cmos-platform-device drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~x86-provide-rtc_cmos-platform-device
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
 
@@ -958,20 +946,24 @@ static struct platform_driver cmos_platf
 
 static int __init cmos_init(void)
 {
-	return platform_driver_probe(&cmos_platform_driver,
+	if (pnp_platform_devices)
+		return pnp_register_driver(&cmos_pnp_driver);
+	else
+		return platform_driver_probe(&cmos_platform_driver,
 			cmos_platform_probe);
 }
 module_init(cmos_init);
 
 static void __exit cmos_exit(void)
 {
-	platform_driver_unregister(&cmos_platform_driver);
+	if (pnp_platform_devices)
+		pnp_unregister_driver(&cmos_pnp_driver);
+	else
+		platform_driver_unregister(&cmos_platform_driver);
 }
 module_exit(cmos_exit);
 
 
-#endif	/* !PNP */
