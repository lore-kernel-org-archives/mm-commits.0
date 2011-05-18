From: akpm@linux-foundation.org
Subject: + alpha-hook-up-gpiolib-support.patch added to -mm tree
Date: Wed, 18 May 2011 14:12:03 -0700
Message-ID: <201105182112.p4ILC35u023956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559Ab1ERVMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 17:12:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     alpha: hook up gpiolib support
has been added to the -mm tree.  Its filename is
     alpha-hook-up-gpiolib-support.patch

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
Subject: alpha: hook up gpiolib support
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Allow people to use gpiolib on Alpha if they want to, mostly for build
coverage.  The header is a stright copy of that for Microblaze, which in
turn was taken from PowerPC.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig            |    1 
 arch/alpha/include/asm/gpio.h |   55 ++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

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
alpha-hook-up-gpiolib-support.patch

