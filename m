From: akpm@linux-foundation.org
Subject: + ssb-extif-timing-serial-port-initialization.patch added to -mm tree
Date: Tue, 07 Aug 2007 17:32:15 -0700
Message-ID: <200708080032.l780WFK7012466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55000 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160AbXHHAdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 20:33:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net, mb@bu3sch.de, nbd@openwrt.org


The patch titled
     SSB EXTIF timing & serial port initialization
has been added to the -mm tree.  Its filename is
     ssb-extif-timing-serial-port-initialization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SSB EXTIF timing & serial port initialization
From: Aurelien Jarno <aurelien@aurel32.net>

Add a new file drivers/ssb/driver_extif.c which contains new SSB EXTIF
functions to initializes the timing and the serial ports.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/Makefile                 |    2 
 drivers/ssb/driver_extif.c           |  104 +++++++++++++++++++++++++
 include/linux/ssb/ssb_driver_extif.h |   10 ++
 3 files changed, 115 insertions(+), 1 deletion(-)

diff -puN drivers/ssb/Makefile~ssb-extif-timing-serial-port-initialization drivers/ssb/Makefile
--- a/drivers/ssb/Makefile~ssb-extif-timing-serial-port-initialization
+++ a/drivers/ssb/Makefile
@@ -7,7 +7,7 @@ ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.
 
 # built-in drivers
 ssb-y					+= driver_chipcommon.o
-ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o
+ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o driver_extif.o
 ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
 
 obj-$(CONFIG_SSB)			+= ssb.o
diff -puN drivers/ssb/driver_extif.c~ssb-extif-timing-serial-port-initialization drivers/ssb/driver_extif.c
--- a/drivers/ssb/driver_extif.c~ssb-extif-timing-serial-port-initialization
+++ a/drivers/ssb/driver_extif.c
@@ -0,0 +1,104 @@
+/*
+ * Sonics Silicon Backplane
+ * Broadcom EXTIF core driver
+ *
+ * Copyright 2005, Broadcom Corporation
+ * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
+ * Copyright 2006, 2007, Felix Fietkau <nbd@openwrt.org>
+ * Copyright 2007, Aurelien Jarno <aurelien@aurel32.net>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/serial.h>
+#include <linux/serial_core.h>
+#include <linux/serial_reg.h>
+
+#include "ssb_private.h"
+
+
+static inline u32 extif_read32(struct ssb_extif *extif, u16 offset)
+{
+	return ssb_read32(extif->dev, offset);
+}
+
+static inline void extif_write32(struct ssb_extif *extif, u16 offset, u32 value)
+{
+	ssb_write32(extif->dev, offset, value);
+}
+
+#ifdef CONFIG_SSB_SERIAL
+static bool serial_exists(u8 *regs)
+{
+	u8 save_mcr, msr = 0;
+
+	if (regs) {
+		save_mcr = regs[UART_MCR];
+		regs[UART_MCR] = (UART_MCR_LOOP | UART_MCR_OUT2 | UART_MCR_RTS);
+		msr = regs[UART_MSR] & (UART_MSR_DCD | UART_MSR_RI
+					| UART_MSR_CTS | UART_MSR_DSR);
+		regs[UART_MCR] = save_mcr;
+	}
+	return (msr == (UART_MSR_DCD | UART_MSR_CTS));
+}
+
+int ssb_extif_serial_init(struct ssb_extif *extif, struct ssb_serial_port *ports)
+{
+	u32 i, nr_ports = 0;
+
+	/* Disable GPIO interrupt initially */
+	extif_write32(extif, SSB_EXTIF_GPIO_INTPOL, 0);
+	extif_write32(extif, SSB_EXTIF_GPIO_INTMASK, 0);
+
+	for (i = 0; i < 2; i++) {
+		void __iomem *uart_regs;
+
+		uart_regs = ioremap_nocache(SSB_EUART, 16);
+		if (uart_regs) {
+			uart_regs += (i * 8);
+
+			if (serial_exists(uart_regs) && ports) {
+				extif_write32(extif, SSB_EXTIF_GPIO_INTMASK, 2);
+
+				nr_ports++;
+				ports[i].regs = uart_regs;
+				ports[i].irq = 2;
+				ports[i].baud_base = 13500000;
+				ports[i].reg_shift = 0;
+			}
+			iounmap(uart_regs);
+		}
+	}
+	return nr_ports;
+}
+#endif /* CONFIG_SSB_SERIAL */
+
+void ssb_extif_timing_init(struct ssb_extif *extif, unsigned long ns)
+{
+	u32 tmp;
+
+	/* Initialize extif so we can get to the LEDs and external UART */
+	extif_write32(extif, SSB_EXTIF_PROG_CFG, SSB_EXTCFG_EN);
+
+	/* Set timing for the flash */
+	tmp  = DIV_ROUND_UP(10, ns) << SSB_PROG_WCNT_3_SHIFT;
+	tmp |= DIV_ROUND_UP(40, ns) << SSB_PROG_WCNT_1_SHIFT;
+	tmp |= DIV_ROUND_UP(120, ns);
+	extif_write32(extif, SSB_EXTIF_PROG_WAITCNT, tmp);
+
+	/* Set programmable interface timing for external uart */
+	tmp  = DIV_ROUND_UP(10, ns) << SSB_PROG_WCNT_3_SHIFT;
+	tmp |= DIV_ROUND_UP(20, ns) << SSB_PROG_WCNT_2_SHIFT;
+	tmp |= DIV_ROUND_UP(100, ns) << SSB_PROG_WCNT_1_SHIFT;
+	tmp |= DIV_ROUND_UP(120, ns);
+	extif_write32(extif, SSB_EXTIF_PROG_WAITCNT, tmp);
+}
+
+void ssb_extif_get_clockcontrol(struct ssb_extif *extif,
+				u32 *pll_type, u32 *n, u32 *m)
+{
+	*pll_type = SSB_PLLTYPE_1;
+	*n = extif_read32(extif, SSB_EXTIF_CLOCK_N);
+	*m = extif_read32(extif, SSB_EXTIF_CLOCK_SB);
+}
+
diff -puN include/linux/ssb/ssb_driver_extif.h~ssb-extif-timing-serial-port-initialization include/linux/ssb/ssb_driver_extif.h
--- a/include/linux/ssb/ssb_driver_extif.h~ssb-extif-timing-serial-port-initialization
+++ a/include/linux/ssb/ssb_driver_extif.h
@@ -156,5 +156,15 @@ struct ssb_extif {
 /* watchdog */
 #define SSB_EXTIF_WATCHDOG_CLK		48000000	/* Hz */
 
+extern void ssb_extif_get_clockcontrol(struct ssb_extif *extif,
+			               u32 *plltype, u32 *n, u32 *m);
+
+extern void ssb_extif_timing_init(struct ssb_extif *extif,
+				  unsigned long ns);
+
+#ifdef CONFIG_SSB_SERIAL
+extern int ssb_extif_serial_init(struct ssb_extif *extif,
+				 struct ssb_serial_port *ports);
+#endif /* CONFIG_SSB_SERIAL */
 
 #endif /* LINUX_SSB_EXTIFCORE_H_ */
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-wireless.patch
ssb-compile-fix.patch
watchdog-support-3.patch
ssb-chipcommon-add-function-to-get-processor-clock.patch
ssb-chipcommon-add-function-to-get-processor-clock-fix.patch
ssb-extif-timing-serial-port-initialization.patch
use-ssb-extif-in-ssb-mips-core-driver.patch
add-buswidth-to-ssb-mips-core-flash-driver.patch
