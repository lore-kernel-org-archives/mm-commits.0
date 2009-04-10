From: akpm@linux-foundation.org
Subject: [to-be-updated] rtc-add-x86-support-for-rtc-efi.patch removed from -mm tree
Date: Fri, 10 Apr 2009 13:52:13 -0700
Message-ID: <200904102052.n3AKqEEa015518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbZDJU6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 16:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bmaly@redhat.com, a.zummo@towertech.it, dannf@hp.com, david-b@pacbell.net, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc: add x86 support for rtc-efi
has been removed from the -mm tree.  Its filename was
     rtc-add-x86-support-for-rtc-efi.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add x86 support for rtc-efi
From: Brian Maly <bmaly@redhat.com>

Add support for rtc-efi (RTC Class Driver for EFI-based systems) to x86.

This patch has been tested and works perfectly on every x86 EFI system I
could find, though all have been EL64 systems.  I would appreciate any
testing feedback from EL32 systems from anyone that has one and can test.

Signed-off-by: Brian Maly <bmaly@redhat.com>
Acked-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/time_32.c |   19 +++++++++++++++++++
 arch/x86/kernel/time_64.c |   18 ++++++++++++++++++
 drivers/rtc/Kconfig       |    2 +-
 3 files changed, 38 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/time_32.c~rtc-add-x86-support-for-rtc-efi arch/x86/kernel/time_32.c
--- a/arch/x86/kernel/time_32.c~rtc-add-x86-support-for-rtc-efi
+++ a/arch/x86/kernel/time_32.c
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/mca.h>
+#include <linux/platform_device.h>
 
 #include <asm/setup.h>
 #include <asm/hpet.h>
@@ -135,3 +136,21 @@ void __init time_init(void)
 	tsc_init();
 	late_time_init = choose_time_init();
 }
+
+
+#ifdef CONFIG_RTC_DRV_EFI
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (platform_device_register(&rtc_efi_dev) < 0)
+		printk(KERN_ERR "unable to register rtc device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+module_init(rtc_init);
+#endif
diff -puN arch/x86/kernel/time_64.c~rtc-add-x86-support-for-rtc-efi arch/x86/kernel/time_64.c
--- a/arch/x86/kernel/time_64.c~rtc-add-x86-support-for-rtc-efi
+++ a/arch/x86/kernel/time_64.c
@@ -18,6 +18,7 @@
 #include <linux/time.h>
 #include <linux/mca.h>
 #include <linux/nmi.h>
+#include <linux/platform_device.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
@@ -133,3 +134,20 @@ void __init time_init(void)
 
 	late_time_init = choose_time_init();
 }
+
+#ifdef CONFIG_RTC_DRV_EFI
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (platform_device_register(&rtc_efi_dev) < 0)
+		printk(KERN_ERR "unable to register rtc device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+module_init(rtc_init);
+#endif
diff -puN drivers/rtc/Kconfig~rtc-add-x86-support-for-rtc-efi drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-x86-support-for-rtc-efi
+++ a/drivers/rtc/Kconfig
@@ -455,7 +455,7 @@ config RTC_DRV_DS1742
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on IA64
+	depends on EFI
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
_

Patches currently in -mm which might be from bmaly@redhat.com are

rtc-add-x86-support-for-rtc-efi.patch

