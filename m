From: akpm@linux-foundation.org
Subject: + xtensa-s6105-specific-configuration-for-s6gmac.patch added to -mm tree
Date: Mon, 30 Mar 2009 17:01:10 -0700
Message-ID: <200903310001.n2V01BJS031714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083AbZCaAFr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 20:05:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: os@emlix.com, chris@zankel.net, davem@davemloft.net, dg@emlix.com, jw@emlix.com


The patch titled
     xtensa: s6105 specific configuration for s6gmac
has been added to the -mm tree.  Its filename is
     xtensa-s6105-specific-configuration-for-s6gmac.patch

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
Subject: xtensa: s6105 specific configuration for s6gmac
From: Oskar Schirmer <os@emlix.com>

Platform-specific configuration for the s6gmac driver, including the
PHY interrupt line.

Signed-off-by: Daniel Glockner <dg@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Johannes Weiner <jw@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/platforms/s6105/device.c |   91 +++++++++++++++++++++++++
 arch/xtensa/platforms/s6105/setup.c  |    9 ++
 2 files changed, 100 insertions(+)

diff -puN arch/xtensa/platforms/s6105/device.c~xtensa-s6105-specific-configuration-for-s6gmac arch/xtensa/platforms/s6105/device.c
--- a/arch/xtensa/platforms/s6105/device.c~xtensa-s6105-specific-configuration-for-s6gmac
+++ a/arch/xtensa/platforms/s6105/device.c
@@ -5,14 +5,27 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/gpio.h>
 #include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/serial_8250.h>
 
 #include <variant/hardware.h>
+#include <variant/dmac.h>
 
+#include <platform/gpio.h>
+
+#define GPIO3_INTNUM		3
 #define UART_INTNUM		4
+#define GMAC_INTNUM		5
+
+static const signed char gpio3_irq_mappings[] = {
+	S6_INTC_GPIO(3),
+	-1
+};
 
 static const signed char uart_irq_mappings[] = {
 	S6_INTC_UART(0),
@@ -20,8 +33,18 @@ static const signed char uart_irq_mappin
 	-1,
 };
 
+static const signed char gmac_irq_mappings[] = {
+	S6_INTC_GMAC_STAT,
+	S6_INTC_GMAC_ERR,
+	S6_INTC_DMA_HOSTTERMCNT(0),
+	S6_INTC_DMA_HOSTTERMCNT(1),
+	-1
+};
+
 const signed char *platform_irq_mappings[NR_IRQS] = {
+	[GPIO3_INTNUM] = gpio3_irq_mappings,
 	[UART_INTNUM] = uart_irq_mappings,
+	[GMAC_INTNUM] = gmac_irq_mappings,
 };
 
 static struct plat_serial8250_port serial_platform_data[] = {
@@ -46,6 +69,66 @@ static struct plat_serial8250_port seria
 	{ },
 };
 
+static struct resource s6_gmac_resource[] = {
+	{
+		.name   = "mem",
+		.start  = (resource_size_t)S6_REG_GMAC,
+		.end    = (resource_size_t)S6_REG_GMAC + 0x10000 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	{
+		.name   = "dma",
+		.start  = (resource_size_t)
+			DMA_CHNL(S6_REG_HIFDMA, S6_HIFDMA_GMACTX),
+		.end    = (resource_size_t)
+			DMA_CHNL(S6_REG_HIFDMA, S6_HIFDMA_GMACTX) + 0x100 - 1,
+		.flags  = IORESOURCE_DMA,
+	},
+	{
+		.name   = "dma",
+		.start  = (resource_size_t)
+			DMA_CHNL(S6_REG_HIFDMA, S6_HIFDMA_GMACRX),
+		.end    = (resource_size_t)
+			DMA_CHNL(S6_REG_HIFDMA, S6_HIFDMA_GMACRX) + 0x100 - 1,
+		.flags  = IORESOURCE_DMA,
+	},
+	{
+		.name   = "io",
+		.start  = (resource_size_t)S6_MEM_GMAC,
+		.end    = (resource_size_t)S6_MEM_GMAC + 0x2000000 - 1,
+		.flags  = IORESOURCE_IO,
+	},
+	{
+		.name   = "irq",
+		.start  = (resource_size_t)GMAC_INTNUM,
+		.flags  = IORESOURCE_IRQ,
+	},
+	{
+		.name   = "irq",
+		.start  = (resource_size_t)PHY_POLL,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static int __init prepare_phy_irq(int pin)
+{
+	int irq;
+	if (gpio_request(pin, "s6gmac_phy") < 0)
+		goto fail;
+	if (gpio_direction_input(pin) < 0)
+		goto free;
+	irq = gpio_to_irq(pin);
+	if (irq < 0)
+		goto free;
+	if (set_irq_type(irq, IRQ_TYPE_LEVEL_LOW) < 0)
+		goto free;
+	return irq;
+free:
+	gpio_free(pin);
+fail:
+	return PHY_POLL;
+}
+
 static struct platform_device platform_devices[] = {
 	{
 		.name = "serial8250",
@@ -54,12 +137,20 @@ static struct platform_device platform_d
 			.platform_data = serial_platform_data,
 		},
 	},
+	{
+		.name = "s6gmac",
+		.id = 0,
+		.resource = s6_gmac_resource,
+		.num_resources = ARRAY_SIZE(s6_gmac_resource),
+	},
 };
 
 static int __init device_init(void)
 {
 	int i;
 
+	s6_gmac_resource[5].start = prepare_phy_irq(GPIO_PHY_IRQ);
+
 	for (i = 0; i < ARRAY_SIZE(platform_devices); i++)
 		platform_device_register(&platform_devices[i]);
 	return 0;
diff -puN arch/xtensa/platforms/s6105/setup.c~xtensa-s6105-specific-configuration-for-s6gmac arch/xtensa/platforms/s6105/setup.c
--- a/arch/xtensa/platforms/s6105/setup.c~xtensa-s6105-specific-configuration-for-s6gmac
+++ a/arch/xtensa/platforms/s6105/setup.c
@@ -35,12 +35,21 @@ void __init platform_setup(char **cmdlin
 {
 	unsigned long reg;
 
+	reg = readl(S6_REG_GREG1 + S6_GREG1_PLLSEL);
+	reg &= ~(S6_GREG1_PLLSEL_GMAC_MASK << S6_GREG1_PLLSEL_GMAC |
+		S6_GREG1_PLLSEL_GMII_MASK << S6_GREG1_PLLSEL_GMII);
+	reg |= S6_GREG1_PLLSEL_GMAC_125MHZ << S6_GREG1_PLLSEL_GMAC |
+		S6_GREG1_PLLSEL_GMII_125MHZ << S6_GREG1_PLLSEL_GMII;
+	writel(reg, S6_REG_GREG1 + S6_GREG1_PLLSEL);
+
 	reg = readl(S6_REG_GREG1 + S6_GREG1_CLKGATE);
 	reg &= ~(1 << S6_GREG1_BLOCK_SB);
+	reg &= ~(1 << S6_GREG1_BLOCK_GMAC);
 	writel(reg, S6_REG_GREG1 + S6_GREG1_CLKGATE);
 
 	reg = readl(S6_REG_GREG1 + S6_GREG1_BLOCKENA);
 	reg |= 1 << S6_GREG1_BLOCK_SB;
+	reg |= 1 << S6_GREG1_BLOCK_GMAC;
 	writel(reg, S6_REG_GREG1 + S6_GREG1_BLOCKENA);
 
 	printk(KERN_NOTICE "S6105 on Stretch S6000 - "
_

Patches currently in -mm which might be from os@emlix.com are

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch

