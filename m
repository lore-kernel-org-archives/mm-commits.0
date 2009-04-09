From: akpm@linux-foundation.org
Subject: + rtc-add-x86-support-for-rtc-efi.patch added to -mm tree
Date: Thu, 09 Apr 2009 16:18:06 -0700
Message-ID: <200904092318.n39NI69m017437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937364AbZDIXYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 19:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bmaly@redhat.com, a.zummo@towertech.it, dannf@hp.com, david-b@pacbell.net, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     rtc: add x86 support for rtc-efi
has been added to the -mm tree.  Its filename is
     rtc-add-x86-support-for-rtc-efi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

