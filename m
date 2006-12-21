From: akpm@osdl.org
Subject: + s3c2410-gpio-wrappers.patch added to -mm tree
Date: Wed, 20 Dec 2006 22:13:50 -0800
Message-ID: <200612210613.kBL6DonA017404@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422758AbWLUGNw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 01:13:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com


The patch titled
     S3C2410 GPIO wrappers
has been added to the -mm tree.  Its filename is
     s3c2410-gpio-wrappers.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: S3C2410 GPIO wrappers
From: Philipp Zabel <philipp.zabel@gmail.com>

Arch-neutral GPIO calls for S3C24xx.


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-arm/arch-s3c2410/gpio.h |   65 ++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff -puN /dev/null include/asm-arm/arch-s3c2410/gpio.h
--- /dev/null
+++ a/include/asm-arm/arch-s3c2410/gpio.h
@@ -0,0 +1,65 @@
+/*
+ * linux/include/asm-arm/arch-pxa/gpio.h
+ *
+ * S3C2400 GPIO wrappers for arch-neutral GPIO calls
+ *
+ * Written by Philipp Zabel <philipp.zabel@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#ifndef __ASM_ARCH_PXA_GPIO_H
+#define __ASM_ARCH_PXA_GPIO_H
+
+#include <asm/arch/pxa-regs.h>
+#include <asm/arch/irqs.h>
+#include <asm/arch/hardware.h>
+
+#include <asm/errno.h>
+
+static inline int gpio_request(unsigned gpio, const char *label)
+{
+	return 0;
+}
+
+static inline void gpio_free(unsigned gpio)
+{
+	return;
+}
+
+static inline int gpio_direction_input(unsigned gpio)
+{
+	s3c2410_gpio_cfgpin(gpio, S3C2410_GPIO_INPUT);
+	return 0;
+}
+
+static inline int gpio_direction_output(unsigned gpio)
+{
+	s3c2410_gpio_cfgpin(gpio, S3C2410_GPIO_OUTPUT);
+	return 0;
+}
+
+#define gpio_get_value(gpio)		s3c2410_gpio_getpin(gpio)
+#define gpio_set_value(gpio,value)	s3c2410_gpio_setpin(gpio, value)
+
+#include <asm-generic/gpio.h>			/* cansleep wrappers */
+
+/* FIXME or maybe s3c2400_gpio_getirq() ... */
+#define gpio_to_irq(gpio)		s3c2410_gpio_getirq(gpio)
+
+/* FIXME implement irq_to_gpio() */
+
+#endif
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

git-alsa.patch
pxa-gpio-wrappers.patch
sa1100-gpio-wrappers.patch
s3c2410-gpio-wrappers.patch

