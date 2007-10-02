From: akpm@linux-foundation.org
Subject: - mips-add-gpio-support-to-the-bcm947xx-platform.patch removed from -mm tree
Date: Tue, 02 Oct 2007 14:24:14 -0700
Message-ID: <200710022124.l92LOEGE023134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920AbXJBVZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 17:25:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien@aurel32.net, david-b@pacbell.net, geert@linux-m68k.org, mb@bu3sch.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: add GPIO support to the BCM947xx platform
has been removed from the -mm tree.  Its filename was
     mips-add-gpio-support-to-the-bcm947xx-platform.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mips: add GPIO support to the BCM947xx platform
From: Aurelien Jarno <aurelien@aurel32.net>

Add GPIO support to the BCM947xx platform.  It will be used by a GPIO LED
driver.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/mach-bcm947xx/gpio.h |   89 ++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff -puN include/asm-mips/mach-bcm947xx/gpio.h~mips-add-gpio-support-to-the-bcm947xx-platform include/asm-mips/mach-bcm947xx/gpio.h
--- a/include/asm-mips/mach-bcm947xx/gpio.h~mips-add-gpio-support-to-the-bcm947xx-platform
+++ a/include/asm-mips/mach-bcm947xx/gpio.h
@@ -0,0 +1,89 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Aurelien Jarno <aurelien@aurel32.net>
+ */
+
+#ifndef __BCM947XX_GPIO_H
+#define __BCM947XX_GPIO_H
+
+#include <linux/ssb/ssb.h>
+#include <linux/ssb/ssb_driver_chipcommon.h>
+#include <linux/ssb/ssb_driver_extif.h>
+#include <asm/mach-bcm947xx/bcm947xx.h>
+
+static inline int gpio_request(unsigned gpio, const char *label)
+{
+       return 0;
+}
+
+static inline void gpio_free(unsigned gpio)
+{
+}
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	if (ssb_bcm947xx.chipco.dev)
+		return ssb_mips_irq(ssb_bcm947xx.chipco.dev) + 2;
+	else if (ssb_bcm947xx.extif.dev)
+		return ssb_mips_irq(ssb_bcm947xx.extif.dev) + 2;
+	else
+		return -EINVAL;
+}
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	if (ssb_bcm947xx.chipco.dev)
+		return ssb_chipco_gpio_in(&ssb_bcm947xx.chipco, 1 << gpio);
+	else if (ssb_bcm947xx.extif.dev)
+		return ssb_extif_gpio_in(&ssb_bcm947xx.extif, 1 << gpio);
+	else
+		return 0;
+}
+
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	if (ssb_bcm947xx.chipco.dev)
+		ssb_chipco_gpio_out(&ssb_bcm947xx.chipco,
+				    1 << gpio,
+				    value ? 1 << gpio : 0);
+	else if (ssb_bcm947xx.extif.dev)
+		ssb_extif_gpio_out(&ssb_bcm947xx.extif,
+				   1 << gpio,
+				   value ? 1 << gpio : 0);
+}
+
+static inline int gpio_direction_input(unsigned gpio)
+{
+	if (ssb_bcm947xx.chipco.dev)
+		ssb_chipco_gpio_outen(&ssb_bcm947xx.chipco,
+				      1 << gpio, 0);
+	else if (ssb_bcm947xx.extif.dev)
+		ssb_extif_gpio_outen(&ssb_bcm947xx.extif,
+				     1 << gpio, 0);
+	else
+		return -EINVAL;
+	return 0;
+}
+
+static inline int gpio_direction_output(unsigned gpio, int value)
+{
+	gpio_set_value(gpio, value);
+
+	if (ssb_bcm947xx.chipco.dev)
+		ssb_chipco_gpio_outen(&ssb_bcm947xx.chipco,
+				      1 << gpio, 1 << gpio);
+	else if (ssb_bcm947xx.extif.dev)
+		ssb_extif_gpio_outen(&ssb_bcm947xx.extif,
+				     1 << gpio, 1 << gpio);
+	else
+		return -EINVAL;
+	return 0;
+}
+
+/* cansleep wrappers */
+#include <asm-generic/gpio.h>
+
+#endif /* __BCM947XX_GPIO_H */
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
git-wireless.patch
move-mm_struct-and-vm_area_struct-fix.patch
