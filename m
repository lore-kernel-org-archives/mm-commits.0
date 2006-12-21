From: akpm@osdl.org
Subject: + omap-gpio-wrappers.patch added to -mm tree
Date: Wed, 20 Dec 2006 22:13:43 -0800
Message-ID: <200612210613.kBL6Dhlv017384@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41555 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422764AbWLUGN5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 01:13:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     OMAP GPIO wrappers
has been added to the -mm tree.  Its filename is
     omap-gpio-wrappers.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OMAP GPIO wrappers
From: David Brownell <david-b@pacbell.net>

This teaches OMAP how to implement the cross-platform GPIO interfaces.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-arm/arch-omap/gpio.h |   54 +++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff -puN include/asm-arm/arch-omap/gpio.h~omap-gpio-wrappers include/asm-arm/arch-omap/gpio.h
--- a/include/asm-arm/arch-omap/gpio.h~omap-gpio-wrappers
+++ a/include/asm-arm/arch-omap/gpio.h
@@ -76,4 +76,58 @@ extern void omap_set_gpio_direction(int 
 extern void omap_set_gpio_dataout(int gpio, int enable);
 extern int omap_get_gpio_datain(int gpio);
 
+/*-------------------------------------------------------------------------*/
+
+/* wrappers for "new style" GPIO calls. the old OMAP-specfic ones should
+ * eventually be removed (along with this errno.h inclusion), and maybe
+ * gpios should put MPUIOs last too.
+ */
+
+#include <asm/errno.h>
+
+static inline int gpio_request(unsigned gpio, const char *label)
+	{ return omap_request_gpio(gpio); }
+
+static inline void gpio_free(unsigned gpio)
+	{ omap_free_gpio(gpio); }
+
+
+static inline int __gpio_set_direction(unsigned gpio, int is_input)
+{
+	if (cpu_class_is_omap2()) {
+		if (gpio > OMAP_MAX_GPIO_LINES)
+			return -EINVAL;
+	} else {
+		if (gpio > (OMAP_MAX_GPIO_LINES + 16 /* MPUIO */))
+			return -EINVAL;
+	}
+	omap_set_gpio_direction(gpio, is_input);
+	return 0;
+}
+
+static inline int gpio_direction_input(unsigned gpio)
+	{ return __gpio_set_direction(gpio, 1); }
+
+static inline int gpio_direction_output(unsigned gpio)
+	{ return __gpio_set_direction(gpio, 0); }
+
+
+static inline int gpio_get_value(unsigned gpio)
+	{ return omap_get_gpio_datain(gpio); }
+
+static inline void gpio_set_value(unsigned gpio, int value)
+	{ omap_set_gpio_dataout(gpio, value); }
+
+#include <asm-generic/gpio.h>		/* cansleep wrappers */
+
+static inline int gpio_to_irq(unsigned gpio)
+	{ return OMAP_GPIO_IRQ(gpio); }
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	if (cpu_class_is_omap1() && (irq < (IH_MPUIO_BASE + 16)))
+		return (irq - IH_MPUIO_BASE) + OMAP_MAX_GPIO_LINES;
+	return irq - IH_GPIO_BASE;
+}
+
 #endif
_

Patches currently in -mm which might be from david-b@pacbell.net are

gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch

