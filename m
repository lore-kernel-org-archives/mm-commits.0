From: akpm@linux-foundation.org
Subject: + m68knommu-platform-setup-for-5249-coldfire-uarts.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:35:35 -0700
Message-ID: <200711022135.lA2LZZOQ012020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbXKBVgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:36:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: platform setup for 5249 ColdFire UARTs
has been added to the -mm tree.  Its filename is
     m68knommu-platform-setup-for-5249-coldfire-uarts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68knommu: platform setup for 5249 ColdFire UARTs
From: Greg Ungerer <gerg@snapgear.com>

Switch to platform style configuration for 5249 ColdFire UARTs.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/5249/config.c |   66 ++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 3 deletions(-)

diff -puN arch/m68knommu/platform/5249/config.c~m68knommu-platform-setup-for-5249-coldfire-uarts arch/m68knommu/platform/5249/config.c
--- a/arch/m68knommu/platform/5249/config.c~m68knommu-platform-setup-for-5249-coldfire-uarts
+++ a/arch/m68knommu/platform/5249/config.c
@@ -12,11 +12,12 @@
 #include <linux/param.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/dma.h>
 #include <asm/machdep.h>
+#include <asm/dma.h>
+#include <asm/io.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
-#include <asm/mcfdma.h>
+#include <asm/mcfuart.h>
 
 /***************************************************************************/
 
@@ -38,6 +39,54 @@ unsigned int dma_device_address[MAX_M68K
 
 /***************************************************************************/
 
+static struct mcf_platform_uart m5249_uart_platform[] = {
+	{
+		.mapbase	= MCF_MBAR + MCFUART_BASE1,
+		.irq		= 73,
+	},
+	{
+		.mapbase 	= MCF_MBAR + MCFUART_BASE2,
+		.irq		= 74,
+	}
+};
+
+static struct platform_device m5249_uart = {
+	.name			= "mcfuart",
+	.id			= 0,
+	.dev.platform_data	= m5249_uart_platform,
+};
+
+static struct platform_device *m5249_devices[] __initdata = {
+	&m5249_uart,
+};
+
+/***************************************************************************/
+
+static void __init m5249_uart_init_line(int line, int irq)
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
+static void __init m5249_uarts_init(void)
+{
+	const int nrlines = ARRAY_SIZE(m5249_uart_platform);
+	int line;
+
+	for (line = 0; (line < nrlines); line++)
+		m5249_uart_init_line(line, m5249_uart_platform[line].irq);
+}
+
+
+/***************************************************************************/
+
 void mcf_autovector(unsigned int vec)
 {
 	volatile unsigned char  *mbar;
@@ -85,10 +134,21 @@ int mcf_timerirqpending(int timer)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 	mach_reset = coldfire_reset;
 }
 
 /***************************************************************************/
+
+static int __init init_BSP(void)
+{
+	m5249_uarts_init();
+	platform_add_devices(m5249_devices, ARRAY_SIZE(m5249_devices));
+	return 0;
+}
+
+arch_initcall(init_BSP);
+
+/***************************************************************************/
_

Patches currently in -mm which might be from gerg@snapgear.com are

m68knommu-fix-pread-pwrite-defines.patch
m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch
m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch
m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
add-build-support-for-new-coldfire-serial-driver.patch
add-configure-support-for-new-coldfire-serial-driver.patch
m68knommu-platform-setup-for-5206-coldfire-uarts.patch
m68knommu-platform-setup-for-5206e-coldfire-uarts.patch
m68knommu-platform-setup-for-520x-coldfire-uarts.patch
m68knommu-platform-setup-for-5249-coldfire-uarts.patch
m68knommu-platform-setup-for-5272-coldfire-uarts.patch
add-cmpxchg_local-to-m68knommu.patch
