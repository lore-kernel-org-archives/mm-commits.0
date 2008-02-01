From: akpm@linux-foundation.org
Subject: - m68knommu-platform-setup-for-520x-coldfire-uarts.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:55 -0800
Message-ID: <200802012229.m11MTt3Z001841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758347AbYBAWbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:31:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: platform setup for 520x ColdFire UARTs
has been removed from the -mm tree.  Its filename was
     m68knommu-platform-setup-for-520x-coldfire-uarts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: platform setup for 520x ColdFire UARTs
From: Greg Ungerer <gerg@snapgear.com>

Switch to platform style configuration for 520x ColdFire family UARTs.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/520x/config.c |   96 +++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 2 deletions(-)

diff -puN arch/m68knommu/platform/520x/config.c~m68knommu-platform-setup-for-520x-coldfire-uarts arch/m68knommu/platform/520x/config.c
--- a/arch/m68knommu/platform/520x/config.c~m68knommu-platform-setup-for-520x-coldfire-uarts
+++ a/arch/m68knommu/platform/520x/config.c
@@ -5,7 +5,7 @@
  *
  *  Copyright (C) 2005,      Freescale (www.freescale.com)
  *  Copyright (C) 2005,      Intec Automation (mike@steroidmicros.com)
- *  Copyright (C) 1999-2003, Greg Ungerer (gerg@snapgear.com)
+ *  Copyright (C) 1999-2007, Greg Ungerer (gerg@snapgear.com)
  *  Copyright (C) 2001-2003, SnapGear Inc. (www.snapgear.com)
  */
 
@@ -13,9 +13,14 @@
 
 #include <linux/kernel.h>
 #include <linux/param.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/machdep.h>
 #include <asm/dma.h>
+#include <asm/io.h>
+#include <asm/coldfire.h>
+#include <asm/mcfsim.h>
+#include <asm/mcfuart.h>
 
 /***************************************************************************/
 
@@ -31,6 +36,82 @@ void coldfire_reset(void);
 
 /***************************************************************************/
 
+static struct mcf_platform_uart m520x_uart_platform[] = {
+	{
+		.mapbase	= MCF_MBAR + MCFUART_BASE1,
+		.irq		= MCFINT_VECBASE + MCFINT_UART0,
+	},
+	{
+		.mapbase 	= MCF_MBAR + MCFUART_BASE2,
+		.irq		= MCFINT_VECBASE + MCFINT_UART1,
+	},
+	{
+		.mapbase 	= MCF_MBAR + MCFUART_BASE3,
+		.irq		= MCFINT_VECBASE + MCFINT_UART2,
+	},
+	{ },
+};
+
+static struct platform_device m520x_uart = {
+	.name			= "mcfuart",
+	.id			= 0,
+	.dev.platform_data	= m520x_uart_platform,
+};
+
+static struct platform_device *m520x_devices[] __initdata = {
+	&m520x_uart,
+};
+
+/***************************************************************************/
+
+#define	INTC0	(MCF_MBAR + MCFICM_INTC0)
+
+static void __init m520x_uart_init_line(int line, int irq)
+{
+	u32 imr;
+	u16 par;
+	u8 par2;
+
+	writeb(0x03, INTC0 + MCFINTC_ICR0 + MCFINT_UART0 + line);
+
+	imr = readl(INTC0 + MCFINTC_IMRL);
+	imr &= ~((1 << (irq - MCFINT_VECBASE)) | 1);
+	writel(imr, INTC0 + MCFINTC_IMRL);
+
+	switch (line) {
+	case 0:
+		par = readw(MCF_IPSBAR + MCF_GPIO_PAR_UART);
+		par |= MCF_GPIO_PAR_UART_PAR_UTXD0 |
+		       MCF_GPIO_PAR_UART_PAR_URXD0;
+		writew(par, MCF_IPSBAR + MCF_GPIO_PAR_UART);
+		break;
+	case 1:
+		par = readw(MCF_IPSBAR + MCF_GPIO_PAR_UART);
+		par |= MCF_GPIO_PAR_UART_PAR_UTXD1 |
+		       MCF_GPIO_PAR_UART_PAR_URXD1;
+		writew(par, MCF_IPSBAR + MCF_GPIO_PAR_UART);
+		break;
+	case 2:
+		par2 = readb(MCF_IPSBAR + MCF_GPIO_PAR_FECI2C);
+		par2 &= ~0x0F;
+		par2 |= MCF_GPIO_PAR_FECI2C_PAR_SCL_UTXD2 |
+			MCF_GPIO_PAR_FECI2C_PAR_SDA_URXD2;
+		writeb(par2, MCF_IPSBAR + MCF_GPIO_PAR_FECI2C);
+		break;
+	}
+}
+
+static void __init m520x_uarts_init(void)
+{
+	const int nrlines = ARRAY_SIZE(m520x_uart_platform);
+	int line;
+
+	for (line = 0; (line < nrlines); line++)
+		m520x_uart_init_line(line, m520x_uart_platform[line].irq);
+}
+
+/***************************************************************************/
+
 /*
  *  Program the vector to be an auto-vectored.
  */
@@ -42,9 +123,20 @@ void mcf_autovector(unsigned int vec)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 	mach_reset = coldfire_reset;
+	m520x_uarts_init();
 }
 
 /***************************************************************************/
+
+static int __init init_BSP(void)
+{
+	platform_add_devices(m520x_devices, ARRAY_SIZE(m520x_devices));
+	return 0;
+}
+
+arch_initcall(init_BSP);
+
+/***************************************************************************/
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
m68knommu-removing-config-variable-dumptoflash.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
add-cmpxchg_local-to-m68knommu.patch
