From: akpm@linux-foundation.org
Subject: [merged] alpha-hook-up-gpiolib-support.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:45 -0700
Message-ID: <201105252029.p4PKT8JJ014817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754628Ab1EYU3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: hook up gpiolib support
has been removed from the -mm tree.  Its filename was
     alpha-hook-up-gpiolib-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: hook up gpiolib support
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Allow people to use gpiolib on Alpha if they want to, mostly for build
coverage.  The header is a stright copy of that for Microblaze, which in
turn was taken from PowerPC.

[akpm@linux-foundation.org: define GENERIC_GPIO]
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig            |    4 ++
 arch/alpha/include/asm/gpio.h |   55 ++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff -puN arch/alpha/Kconfig~alpha-hook-up-gpiolib-support arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-hook-up-gpiolib-support
+++ a/arch/alpha/Kconfig
@@ -12,6 +12,7 @@ config ALPHA
 	select GENERIC_IRQ_PROBE
 	select AUTO_IRQ_AFFINITY if SMP
 	select GENERIC_IRQ_SHOW
+	select ARCH_WANT_OPTIONAL_GPIOLIB
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
@@ -51,6 +52,9 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_CMOS_UPDATE
         def_bool y
 
+config GENERIC_GPIO
+	def_bool y
+
 config ZONE_DMA
 	bool
 	default y
diff -puN /dev/null arch/alpha/include/asm/gpio.h
--- /dev/null
+++ a/arch/alpha/include/asm/gpio.h
@@ -0,0 +1,55 @@
+/*
+ * Generic GPIO API implementation for Alpha.
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
+#ifndef _ASM_ALPHA_GPIO_H
+#define _ASM_ALPHA_GPIO_H
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
+#endif /* _ASM_ALPHA_GPIO_H */
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch

