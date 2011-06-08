From: akpm@linux-foundation.org
Subject: + frv-hook-up-gpiolib-support.patch added to -mm tree
Date: Wed, 08 Jun 2011 13:48:56 -0700
Message-ID: <201106082048.p58Kmu1C027921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755025Ab1FHUtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2011 16:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dhowells@redhat.com, grant.likely@secretlab.ca


The patch titled
     frv: hook up gpiolib support
has been added to the -mm tree.  Its filename is
     frv-hook-up-gpiolib-support.patch

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
@@ -7,6 +7,7 @@ config FRV
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select ARCH_WANT_OPTIONAL_GPIO
 
 config ZONE_DMA
 	bool
@@ -27,6 +28,9 @@ config GENERIC_CALIBRATE_DELAY
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
linux-next.patch
frv-hook-up-gpiolib-support.patch

