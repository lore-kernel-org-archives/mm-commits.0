From: akpm@linux-foundation.org
Subject: + rtc-ia64-allow-other-architectures-to-use-efi-rtc.patch added
 to -mm tree
Date: Tue, 15 Jul 2014 16:17:22 -0700
Message-ID: <53c5b682.jsqgEGN/4d9YIPo+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:53185 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaGOXRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 19:17:24 -0400
Received: by mail-qc0-f201.google.com with SMTP id m20so18613qcx.4
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 16:17:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, a.zummo@towertech.it, fenghua.yu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ia64: allow other architectures to use EFI RTC
has been added to the -mm tree.  Its filename is
     rtc-ia64-allow-other-architectures-to-use-efi-rtc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ia64-allow-other-architectures-to-use-efi-rtc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ia64-allow-other-architectures-to-use-efi-rtc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: rtc: ia64: allow other architectures to use EFI RTC

Currently, the rtc-efi driver is restricted to ia64 only.  Newer
architectures with EFI support may want to also use that driver.  This
patch moves the platform device setup from ia64 into drivers/rtc and allow
any architecture with CONFIG_EFI=y to use the rtc-efi driver.

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/time.c        |   15 ---------------
 drivers/rtc/Kconfig            |    2 +-
 drivers/rtc/Makefile           |    4 ++++
 drivers/rtc/rtc-efi-platform.c |   30 ++++++++++++++++++++++++++++++
 4 files changed, 35 insertions(+), 16 deletions(-)

diff -puN arch/ia64/kernel/time.c~rtc-ia64-allow-other-architectures-to-use-efi-rtc arch/ia64/kernel/time.c
--- a/arch/ia64/kernel/time.c~rtc-ia64-allow-other-architectures-to-use-efi-rtc
+++ a/arch/ia64/kernel/time.c
@@ -384,21 +384,6 @@ static struct irqaction timer_irqaction
 	.name =		"timer"
 };
 
-static struct platform_device rtc_efi_dev = {
-	.name = "rtc-efi",
-	.id = -1,
-};
-
-static int __init rtc_init(void)
-{
-	if (platform_device_register(&rtc_efi_dev) < 0)
-		printk(KERN_ERR "unable to register rtc device...\n");
-
-	/* not necessarily an error */
-	return 0;
-}
-module_init(rtc_init);
-
 void read_persistent_clock(struct timespec *ts)
 {
 	efi_gettimeofday(ts);
diff -puN drivers/rtc/Kconfig~rtc-ia64-allow-other-architectures-to-use-efi-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-ia64-allow-other-architectures-to-use-efi-rtc
+++ a/drivers/rtc/Kconfig
@@ -798,7 +798,7 @@ config RTC_DRV_DA9063
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on IA64
+	depends on EFI
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
diff -puN drivers/rtc/Makefile~rtc-ia64-allow-other-architectures-to-use-efi-rtc drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-ia64-allow-other-architectures-to-use-efi-rtc
+++ a/drivers/rtc/Makefile
@@ -10,6 +10,10 @@ obj-$(CONFIG_RTC_SYSTOHC)	+= systohc.o
 obj-$(CONFIG_RTC_CLASS)		+= rtc-core.o
 rtc-core-y			:= class.o interface.o
 
+ifdef CONFIG_RTC_DRV_EFI
+rtc-core-y			+= rtc-efi-platform.o
+endif
+
 rtc-core-$(CONFIG_RTC_INTF_DEV)	+= rtc-dev.o
 rtc-core-$(CONFIG_RTC_INTF_PROC) += rtc-proc.o
 rtc-core-$(CONFIG_RTC_INTF_SYSFS) += rtc-sysfs.o
diff -puN /dev/null drivers/rtc/rtc-efi-platform.c
--- /dev/null
+++ a/drivers/rtc/rtc-efi-platform.c
@@ -0,0 +1,30 @@
+/*
+ * Moved from arch/ia64/kernel/time.c
+ *
+ * Copyright (C) 1998-2003 Hewlett-Packard Co
+ *	Stephane Eranian <eranian@hpl.hp.com>
+ *	David Mosberger <davidm@hpl.hp.com>
+ * Copyright (C) 1999 Don Dugger <don.dugger@intel.com>
+ * Copyright (C) 1999-2000 VA Linux Systems
+ * Copyright (C) 1999-2000 Walt Drummond <drummond@valinux.com>
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/efi.h>
+#include <linux/platform_device.h>
+
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (platform_device_register(&rtc_efi_dev) < 0)
+		pr_err("unable to register rtc device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+module_init(rtc_init);
_

Patches currently in -mm which might be from msalter@redhat.com are

rtc-ia64-allow-other-architectures-to-use-efi-rtc.patch

