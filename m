From: akpm@osdl.org
Subject: + sa1100-gpio-wrappers.patch added to -mm tree
Date: Wed, 20 Dec 2006 22:13:49 -0800
Message-ID: <200612210613.kBL6DnMm017401@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422757AbWLUGNv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 01:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com


The patch titled
     SA1100 GPIO wrappers
has been added to the -mm tree.  Its filename is
     sa1100-gpio-wrappers.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SA1100 GPIO wrappers
From: Philipp Zabel <philipp.zabel@gmail.com>

Arch-neutral GPIO calls for SA-1100.


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-arm/arch-sa1100/gpio.h |   81 +++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff -puN /dev/null include/asm-arm/arch-sa1100/gpio.h
--- /dev/null
+++ a/include/asm-arm/arch-sa1100/gpio.h
@@ -0,0 +1,81 @@
+/*
+ * linux/include/asm-arm/arch-pxa/gpio.h
+ *
+ * SA1100 GPIO wrappers for arch-neutral GPIO calls
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
+#ifndef __ASM_ARCH_SA1100_GPIO_H
+#define __ASM_ARCH_SA1100_GPIO_H
+
+#include <asm/arch/SA-1100.h>
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
+	if (gpio > GPIO_MAX)
+		return -EINVAL;
+	GPDR = (GPDR_In << gpio) 0
+}
+
+static inline int gpio_direction_output(unsigned gpio)
+{
+	if (gpio > GPIO_MAX)
+		return -EINVAL;
+	GPDR = (GPDR_Out << gpio) 0
+}
+
+#define gpio_get_value(gpio) \
+	(GPLR & GPIO_GPIO(gpio))
+
+#define gpio_set_value(gpio,value) \
+	((value) ? (GPSR = GPIO_GPIO(gpio)) : (GPCR(gpio) = GPIO_GPIO(gpio)))
+
+#include <asm-generic/gpio.h>			/* cansleep wrappers */
+
+static inline unsigned gpio_to_irq(unsigned gpio)
+{
+	if (gpio < 11)
+		return IRQ_GPIO0 + gpio;
+	else
+		return IRQ_GPIO11 - 11 + gpio;
+}
+
+static inline unsigned irq_to_gpio(unsigned irq)
+{
+	if (irq < IRQ_GPIO11_27)
+		return irq - IRQ_GPIO0;
+	else
+		return irq - IRQ_GPIO11 + 11;
+}
+
+#endif
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

git-alsa.patch
pxa-gpio-wrappers.patch
sa1100-gpio-wrappers.patch
s3c2410-gpio-wrappers.patch

