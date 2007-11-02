From: akpm@linux-foundation.org
Subject: + m68knommu-platform-setup-for-5272-coldfire-uarts.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:35:38 -0700
Message-ID: <200711022135.lA2LZcbx012023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658AbXKBVgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:36:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: platform setup for 5272 ColdFire UARTs
has been added to the -mm tree.  Its filename is
     m68knommu-platform-setup-for-5272-coldfire-uarts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68knommu: platform setup for 5272 ColdFire UARTs
From: Greg Ungerer <gerg@snapgear.com>

Switch to platform style configuration for 5272 ColdFire UARTs.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/5272/config.c |   76 +++++++++++++++++++++---
 1 file changed, 69 insertions(+), 7 deletions(-)

diff -puN arch/m68knommu/platform/5272/config.c~m68knommu-platform-setup-for-5272-coldfire-uarts arch/m68knommu/platform/5272/config.c
--- a/arch/m68knommu/platform/5272/config.c~m68knommu-platform-setup-for-5272-coldfire-uarts
+++ a/arch/m68knommu/platform/5272/config.c
@@ -13,11 +13,12 @@
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
 
@@ -48,6 +49,60 @@ unsigned int dma_device_address[MAX_M68K
 
 /***************************************************************************/
 
+static struct mcf_platform_uart m5272_uart_platform[] = {
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
+static struct platform_device m5272_uart = {
+	.name			= "mcfuart",
+	.id			= 0,
+	.dev.platform_data	= m5272_uart_platform,
+};
+
+static struct platform_device *m5272_devices[] __initdata = {
+	&m5272_uart,
+};
+
+/***************************************************************************/
+
+static void __init m5272_uart_init_line(int line, int irq)
+{
+	u32 v;
+
+	if ((line >= 0) && (line < 2)) {
+		v = (line) ? 0x0e000000 : 0xe0000000;
+		writel(v, MCF_MBAR + MCFSIM_ICR2);
+
+		/* Enable the output lines for the serial ports */
+		v = readl(MCF_MBAR + MCFSIM_PBCNT);
+		v = (v & ~0x000000ff) | 0x00000055;
+		writel(v, MCF_MBAR + MCFSIM_PBCNT);
+
+		v = readl(MCF_MBAR + MCFSIM_PDCNT);
+		v = (v & ~0x000003fc) | 0x000002a8;
+		writel(v, MCF_MBAR + MCFSIM_PDCNT);
+	}
+}
+
+static void __init m5272_uarts_init(void)
+{
+	const int nrlines = ARRAY_SIZE(m5272_uart_platform);
+	int line;
+
+	for (line = 0; (line < nrlines); line++)
+		m5272_uart_init_line(line, m5272_uart_platform[line].irq);
+}
+
+/***************************************************************************/
+
 void mcf_disableall(void)
 {
 	volatile unsigned long	*icrp;
@@ -93,7 +148,7 @@ int mcf_timerirqpending(int timer)
 
 /***************************************************************************/
 
-void config_BSP(char *commandp, int size)
+void __init config_BSP(char *commandp, int size)
 {
 #if defined (CONFIG_MOD5272)
 	volatile unsigned char	*pivrp;
@@ -109,10 +164,6 @@ void config_BSP(char *commandp, int size
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0xf0004000, size);
 	commandp[size-1] = 0;
-#elif defined(CONFIG_MTD_KeyTechnology)
-	/* Copy command line from FLASH to local buffer... */
-	memcpy(commandp, (char *) 0xffe06000, size);
-	commandp[size-1] = 0;
 #elif defined(CONFIG_CANCam)
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0xf0010000, size);
@@ -125,3 +176,14 @@ void config_BSP(char *commandp, int size
 }
 
 /***************************************************************************/
+
+static int __init init_BSP(void)
+{
+	m5272_uarts_init();
+	platform_add_devices(m5272_devices, ARRAY_SIZE(m5272_devices));
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
