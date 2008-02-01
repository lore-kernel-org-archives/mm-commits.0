From: akpm@linux-foundation.org
Subject: - m68knommu-platform-setup-for-5206e-coldfire-uarts.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:53 -0800
Message-ID: <200802012229.m11MTrHZ001838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756438AbYBAWa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:30:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: platform setup for 5206e ColdFire UARTs
has been removed from the -mm tree.  Its filename was
     m68knommu-platform-setup-for-5206e-coldfire-uarts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: platform setup for 5206e ColdFire UARTs
From: Greg Ungerer <gerg@snapgear.com>

Switch to platform style configuration for 5206e ColdFire UARTs.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/5206e/config.c |   65 ++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 2 deletions(-)

diff -puN arch/m68knommu/platform/5206e/config.c~m68knommu-platform-setup-for-5206e-coldfire-uarts arch/m68knommu/platform/5206e/config.c
--- a/arch/m68knommu/platform/5206e/config.c~m68knommu-platform-setup-for-5206e-coldfire-uarts
+++ a/arch/m68knommu/platform/5206e/config.c
@@ -10,9 +10,11 @@
 
 #include <linux/kernel.h>
 #include <linux/param.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/dma.h>
 #include <asm/machdep.h>
+#include <asm/dma.h>
+#include <asm/io.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
@@ -35,6 +37,54 @@ unsigned int dma_device_address[MAX_M68K
 
 /***************************************************************************/
 
+static struct mcf_platform_uart m5206_uart_platform[] = {
+	{
+		.mapbase	= MCF_MBAR + MCFUART_BASE1,
+		.irq		= 73,
+	},
+	{
+		.mapbase 	= MCF_MBAR + MCFUART_BASE2,
+		.irq		= 74,
+	},
+	{ },
+};
+
+static struct platform_device m5206_uart = {
+	.name			= "mcfuart",
+	.id			= 0,
+	.dev.platform_data	= m5206_uart_platform,
+};
+
+static struct platform_device *m5206_devices[] __initdata = {
+	&m5206_uart,
+};
+
+/***************************************************************************/
+
+static void __init m5206_uart_init_line(int line, int irq)
+{
+	if (line == 0) {
+		writel(MCFSIM_ICR_LEVEL6 | MCFSIM_ICR_PRI1, MCF_MBAR + MCFSIM_UART1ICR);
+		writeb(irq, MCFUART_BASE1 + MCFUART_UIVR);
+		mcf_setimr(mcf_getimr() & ~MCFSIM_IMR_UART1);
+	} else if (line == 1) {
+		writel(MCFSIM_ICR_LEVEL6 | MCFSIM_ICR_PRI2, MCF_MBAR + MCFSIM_UART2ICR);
+		writeb(irq, MCFUART_BASE2 + MCFUART_UIVR);
+		mcf_setimr(mcf_getimr() & ~MCFSIM_IMR_UART2);
+	}
+}
+
+static void __init m5206_uarts_init(void)
+{
+	const int nrlines = ARRAY_SIZE(m5206_uart_platform);
+	int line;
+
+	for (line = 0; (line < nrlines); line++)
+		m5206_uart_init_line(line, m5206_uart_platform[line].irq);
+}
+
+/***************************************************************************/
+
 void mcf_autovector(unsigned int vec)
 {
 	volatile unsigned char  *mbar;
@@ -85,7 +135,7 @@ int mcf_timerirqpending(int timer)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
@@ -99,3 +149,14 @@ void config_BSP(char *commandp, int size
 }
 
 /***************************************************************************/
+
+static int __init init_BSP(void)
+{
+	m5206_uarts_init();
+	platform_add_devices(m5206_devices, ARRAY_SIZE(m5206_devices));
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
