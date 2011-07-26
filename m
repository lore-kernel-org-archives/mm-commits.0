From: akpm@linux-foundation.org
Subject: [nacked] frv-hook-up-gpiolib-support.patch removed from -mm tree
Date: Tue, 26 Jul 2011 14:13:51 -0700
Message-ID: <201107262113.p6QLDqFF009336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112Ab1GZVOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 17:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, dhowells@redhat.com, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     frv: hook up gpiolib support
has been removed from the -mm tree.  Its filename was
     frv-hook-up-gpiolib-support.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: hook up gpiolib support
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Allow people to use gpiolib on FRV, mostly for build coverage as it seems
more useful to standardise the API than handle making it optional.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/Kconfig            |    4 ++
 arch/frv/include/asm/gpio.h |   55 ++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff -puN arch/frv/Kconfig~frv-hook-up-gpiolib-support arch/frv/Kconfig
--- a/arch/frv/Kconfig~frv-hook-up-gpiolib-support
+++ a/arch/frv/Kconfig
@@ -2,6 +2,7 @@ config FRV
 	bool
 	default y
 	select HAVE_IDE
+	select ARCH_WANT_OPTIONAL_GPIO
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
@@ -28,6 +29,9 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default n
 
+config GENERIC_GPIO
+	def_bool y
+
 config TIME_LOW_RES
 	bool
 	default y
diff -puN /dev/null arch/frv/include/asm/gpio.h
--- /dev/null
+++ a/arch/frv/include/asm/gpio.h
@@ -0,0 +1,55 @@
+/*
+ * Generic GPIO API implementation for FRV.
+ *
+ * A stright copy of that for PowerPC which was:
+ *
+ * Copyright (c) 2007-2008  MontaVista Software, Inc.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _ASM_FRV_GPIO_H
+#define _ASM_FRV_GPIO_H
+
+#include <linux/errno.h>
+#include <asm-generic/gpio.h>
+
+#ifdef CONFIG_GPIOLIB
+
+/*
+ * We don't (yet) implement inlined/rapid versions for on-chip gpios.
+ * Just call gpiolib.
+ */
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return __gpio_to_irq(gpio);
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_GPIOLIB */
+
+#endif /* _ASM_FRV_GPIO_H */
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch

