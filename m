From: akpm@linux-foundation.org
Subject: - rtc-class-driver-for-ppc_md-rtc-functions.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:10 -0700
Message-ID: <200806081949.m58JnAaW017630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754514AbYFHTtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, a.zummo@towertech.it, benh@kernel.crashing.org, david-b@pacbell.net, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     rtc: class driver for ppc_md RTC functions
has been removed from the -mm tree.  Its filename was
     rtc-class-driver-for-ppc_md-rtc-functions.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: rtc: class driver for ppc_md RTC functions
=46rom: David Woodhouse <dwmw2@infradead.org>

This hooks up the platform-specific [gs]et_rtc_time functions so that
kernels using CONFIG_RTC_CLASS have RTC support on most PowerPC platfor=
ms.

A new driver, and one which we've been shipping in Fedora for a while
already, since otherwise RTC support breaks.

[akpm@linux-foundation.org: fix Kconfig indenting]
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig   |    8 ++++
 drivers/rtc/Makefile  |    1=20
 drivers/rtc/rtc-ppc.c |   69 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-class-driver-for-ppc_md-rtc-functions=
 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-class-driver-for-ppc_md-rtc-functions
+++ a/drivers/rtc/Kconfig
@@ -534,4 +534,12 @@ config RTC_DRV_RS5C313
 	help
 	  If you say yes here you get support for the Ricoh RS5C313 RTC chips=
=2E
=20
+config RTC_DRV_PPC
+       tristate "PowerPC machine dependent RTC support"
+       depends on PPC_MERGE
+       help
+	 The PowerPC kernel has machine-specific functions for accessing
+	 the RTC. This exposes that functionality through the generic RTC
+	 class.
+
 endif # RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-class-driver-for-ppc_md-rtc-function=
s drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-class-driver-for-ppc_md-rtc-functions
+++ a/drivers/rtc/Makefile
@@ -54,3 +54,4 @@ obj-$(CONFIG_RTC_DRV_TEST)	+=3D rtc-test.o
 obj-$(CONFIG_RTC_DRV_V3020)	+=3D rtc-v3020.o
 obj-$(CONFIG_RTC_DRV_VR41XX)	+=3D rtc-vr41xx.o
 obj-$(CONFIG_RTC_DRV_X1205)	+=3D rtc-x1205.o
+obj-$(CONFIG_RTC_DRV_PPC)	+=3D rtc-ppc.o
diff -puN /dev/null drivers/rtc/rtc-ppc.c
--- /dev/null
+++ a/drivers/rtc/rtc-ppc.c
@@ -0,0 +1,69 @@
+/*
+ * RTC driver for ppc_md RTC functions
+ *
+ * =C2=A9 2007 Red Hat, Inc.
+ *
+ * Author: David Woodhouse <dwmw2@infradead.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+#include <asm/machdep.h>
+
+static int ppc_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	ppc_md.get_rtc_time(tm);
+	return 0;
+}
+
+static int ppc_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	return ppc_md.set_rtc_time(tm);
+}
+
+static const struct rtc_class_ops ppc_rtc_ops =3D {
+	.set_time =3D ppc_rtc_set_time,
+	.read_time =3D ppc_rtc_read_time,
+};
+
+static struct rtc_device *rtc;
+static struct platform_device *ppc_rtc_pdev;
+
+static int __init ppc_rtc_init(void)
+{
+	if (!ppc_md.get_rtc_time || !ppc_md.set_rtc_time)
+		return -ENODEV;
+
+	ppc_rtc_pdev =3D platform_device_register_simple("ppc-rtc", 0, NULL, =
0);
+	if (IS_ERR(ppc_rtc_pdev))
+		return PTR_ERR(ppc_rtc_pdev);
+
+	rtc =3D rtc_device_register("ppc_md", &ppc_rtc_pdev->dev,
+				  &ppc_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		platform_device_unregister(ppc_rtc_pdev);
+		return PTR_ERR(rtc);
+	}
+
+	return 0;
+}
+
+static void __exit ppc_rtc_exit(void)
+{
+	rtc_device_unregister(rtc);
+	platform_device_unregister(ppc_rtc_pdev);
+}
+
+module_init(ppc_rtc_init);
+module_exit(ppc_rtc_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
+MODULE_DESCRIPTION("Generic RTC class driver for PowerPC");
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
linux-next.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
git-battery.patch
mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to.patch
mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to-fix-up.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
