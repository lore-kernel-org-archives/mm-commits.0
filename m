From: akpm@linux-foundation.org
Subject: - arm-replace-remaining-__function__-occurences.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:21:30 -0800
Message-ID: <200803062221.m26MLUOc020723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbYCFWWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:22:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     arm-replace-remaining-__function__-occurences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/it8152.c            |    6 +-
 arch/arm/mach-h720x/common.c        |   12 ++--
 arch/arm/mach-imx/dma.c             |   12 ++--
 arch/arm/mach-imx/irq.c             |    6 +-
 arch/arm/mach-iop13xx/iq81340mc.c   |    2 
 arch/arm/mach-iop13xx/iq81340sc.c   |    2 
 arch/arm/mach-iop13xx/pci.c         |    8 +--
 arch/arm/mach-iop13xx/setup.c       |    2 
 arch/arm/mach-ixp4xx/common-pci.c   |    2 
 arch/arm/mach-ixp4xx/gtwx5715-pci.c |    2 
 arch/arm/mach-netx/generic.c        |    6 +-
 arch/arm/mach-orion/gpio.c          |   12 ++--
 arch/arm/mach-pnx4008/clock.c       |    2 
 arch/arm/mach-pnx4008/dma.c         |    2 
 arch/arm/mach-pxa/cm-x270-pci.c     |    2 
 arch/arm/mach-pxa/cm-x270.c         |    4 -
 arch/arm/mach-pxa/dma.c             |    2 
 arch/arm/mach-pxa/em-x270.c         |    2 
 arch/arm/mach-pxa/mainstone.c       |    4 -
 arch/arm/mach-pxa/trizeps4.c        |    8 +--
 arch/arm/mach-sa1100/badge4.c       |    6 +-
 arch/arm/mach-sa1100/cpu-sa1100.c   |    2 
 arch/arm/mach-sa1100/dma.c          |    8 +--
 arch/arm/mach-sa1100/h3600.c        |   14 ++---
 arch/arm/plat-iop/pci.c             |    2 
 arch/arm/plat-omap/dma.c            |    4 -
 arch/arm/plat-omap/dmtimer.c        |    2 
 arch/arm/plat-s3c24xx/dma.c         |   64 +++++++++++++-------------
 28 files changed, 100 insertions(+), 100 deletions(-)

diff -puN arch/arm/common/it8152.c~arm-replace-remaining-__function__-occurences arch/arm/common/it8152.c
--- a/arch/arm/common/it8152.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/common/it8152.c
@@ -274,7 +274,7 @@ static int it8152_pci_platform_notify_re
 int dma_needs_bounce(struct device *dev, dma_addr_t dma_addr, size_t size)
 {
 	dev_dbg(dev, "%s: dma_addr %08x, size %08x\n",
-		__FUNCTION__, dma_addr, size);
+		__func__, dma_addr, size);
 	return (dev->bus == &pci_bus_type) &&
 		((dma_addr + size - PHYS_OFFSET) >= SZ_64M);
 }
@@ -289,7 +289,7 @@ int dma_needs_bounce(struct device *dev,
  */
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
 {
-	dev_dbg(&dev->dev, "%s: %llx\n", __FUNCTION__, mask);
+	dev_dbg(&dev->dev, "%s: %llx\n", __func__, mask);
 	if (mask >= PHYS_OFFSET + SZ_64M - 1)
 		return 0;
 
@@ -299,7 +299,7 @@ int pci_set_dma_mask(struct pci_dev *dev
 int
 pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
 {
-	dev_dbg(&dev->dev, "%s: %llx\n", __FUNCTION__, mask);
+	dev_dbg(&dev->dev, "%s: %llx\n", __func__, mask);
 	if (mask >= PHYS_OFFSET + SZ_64M - 1)
 		return 0;
 
diff -puN arch/arm/mach-h720x/common.c~arm-replace-remaining-__function__-occurences arch/arm/mach-h720x/common.c
--- a/arch/arm/mach-h720x/common.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-h720x/common.c
@@ -103,7 +103,7 @@ static void
 h720x_gpio_handler(unsigned int mask, unsigned int irq,
                  struct irq_desc *desc)
 {
-	IRQDBG("%s irq: %d\n",__FUNCTION__,irq);
+	IRQDBG("%s irq: %d\n", __func__, irq);
 	desc = irq_desc + irq;
 	while (mask) {
 		if (mask & 1) {
@@ -123,7 +123,7 @@ h720x_gpioa_demux_handler(unsigned int i
 
 	mask = CPU_REG(GPIO_A_VIRT,GPIO_STAT);
 	irq = IRQ_CHAINED_GPIOA(0);
-	IRQDBG("%s mask: 0x%08x irq: %d\n",__FUNCTION__,mask,irq);
+	IRQDBG("%s mask: 0x%08x irq: %d\n", __func__, mask,irq);
 	h720x_gpio_handler(mask, irq, desc);
 }
 
@@ -133,7 +133,7 @@ h720x_gpiob_demux_handler(unsigned int i
 	unsigned int mask, irq;
 	mask = CPU_REG(GPIO_B_VIRT,GPIO_STAT);
 	irq = IRQ_CHAINED_GPIOB(0);
-	IRQDBG("%s mask: 0x%08x irq: %d\n",__FUNCTION__,mask,irq);
+	IRQDBG("%s mask: 0x%08x irq: %d\n", __func__, mask,irq);
 	h720x_gpio_handler(mask, irq, desc);
 }
 
@@ -144,7 +144,7 @@ h720x_gpioc_demux_handler(unsigned int i
 
 	mask = CPU_REG(GPIO_C_VIRT,GPIO_STAT);
 	irq = IRQ_CHAINED_GPIOC(0);
-	IRQDBG("%s mask: 0x%08x irq: %d\n",__FUNCTION__,mask,irq);
+	IRQDBG("%s mask: 0x%08x irq: %d\n", __func__, mask,irq);
 	h720x_gpio_handler(mask, irq, desc);
 }
 
@@ -155,7 +155,7 @@ h720x_gpiod_demux_handler(unsigned int i
 
 	mask = CPU_REG(GPIO_D_VIRT,GPIO_STAT);
 	irq = IRQ_CHAINED_GPIOD(0);
-	IRQDBG("%s mask: 0x%08x irq: %d\n",__FUNCTION__,mask,irq);
+	IRQDBG("%s mask: 0x%08x irq: %d\n", __func__, mask,irq);
 	h720x_gpio_handler(mask, irq, desc);
 }
 
@@ -167,7 +167,7 @@ h720x_gpioe_demux_handler(unsigned int i
 
 	mask = CPU_REG(GPIO_E_VIRT,GPIO_STAT);
 	irq = IRQ_CHAINED_GPIOE(0);
-	IRQDBG("%s mask: 0x%08x irq: %d\n",__FUNCTION__,mask,irq);
+	IRQDBG("%s mask: 0x%08x irq: %d\n", __func__, mask,irq);
 	h720x_gpio_handler(mask, irq, desc);
 }
 #endif
diff -puN arch/arm/mach-imx/dma.c~arm-replace-remaining-__function__-occurences arch/arm/mach-imx/dma.c
--- a/arch/arm/mach-imx/dma.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-imx/dma.c
@@ -54,7 +54,7 @@ static inline int imx_dma_sg_next(imx_dm
 
 	if (!imxdma->name) {
 		printk(KERN_CRIT "%s: called for  not allocated channel %d\n",
-		       __FUNCTION__, dma_ch);
+		       __func__, dma_ch);
 		return 0;
 	}
 
@@ -288,7 +288,7 @@ imx_dma_setup_handlers(imx_dmach_t dma_c
 
 	if (!imxdma->name) {
 		printk(KERN_CRIT "%s: called for  not allocated channel %d\n",
-		       __FUNCTION__, dma_ch);
+		       __func__, dma_ch);
 		return -ENODEV;
 	}
 
@@ -321,7 +321,7 @@ void imx_dma_enable(imx_dmach_t dma_ch)
 
 	if (!imxdma->name) {
 		printk(KERN_CRIT "%s: called for  not allocated channel %d\n",
-		       __FUNCTION__, dma_ch);
+		       __func__, dma_ch);
 		return;
 	}
 
@@ -365,7 +365,7 @@ int imx_dma_request(imx_dmach_t dma_ch, 
 
 	if (dma_ch >= IMX_DMA_CHANNELS) {
 		printk(KERN_CRIT "%s: called for  non-existed channel %d\n",
-		       __FUNCTION__, dma_ch);
+		       __func__, dma_ch);
 		return -EINVAL;
 	}
 
@@ -396,7 +396,7 @@ void imx_dma_free(imx_dmach_t dma_ch)
 	if (!imxdma->name) {
 		printk(KERN_CRIT
 		       "%s: trying to free channel %d which is already freed\n",
-		       __FUNCTION__, dma_ch);
+		       __func__, dma_ch);
 		return;
 	}
 
@@ -456,7 +456,7 @@ imx_dma_request_by_prio(imx_dmach_t * pd
 		}
 	}
 
-	printk(KERN_ERR "%s: no free DMA channel found\n", __FUNCTION__);
+	printk(KERN_ERR "%s: no free DMA channel found\n", __func__);
 
 	return -ENODEV;
 }
diff -puN arch/arm/mach-imx/irq.c~arm-replace-remaining-__function__-occurences arch/arm/mach-imx/irq.c
--- a/arch/arm/mach-imx/irq.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-imx/irq.c
@@ -160,21 +160,21 @@ imx_gpio_irq_type(unsigned int _irq, uns
 static void
 imx_gpio_ack_irq(unsigned int irq)
 {
-	DEBUG_IRQ("%s: irq %d\n", __FUNCTION__, irq);
+	DEBUG_IRQ("%s: irq %d\n", __func__, irq);
 	ISR(IRQ_TO_REG(irq)) = 1 << ((irq - IRQ_GPIOA(0)) % 32);
 }
 
 static void
 imx_gpio_mask_irq(unsigned int irq)
 {
-	DEBUG_IRQ("%s: irq %d\n", __FUNCTION__, irq);
+	DEBUG_IRQ("%s: irq %d\n", __func__, irq);
 	IMR(IRQ_TO_REG(irq)) &= ~( 1 << ((irq - IRQ_GPIOA(0)) % 32));
 }
 
 static void
 imx_gpio_unmask_irq(unsigned int irq)
 {
-	DEBUG_IRQ("%s: irq %d\n", __FUNCTION__, irq);
+	DEBUG_IRQ("%s: irq %d\n", __func__, irq);
 	IMR(IRQ_TO_REG(irq)) |= 1 << ((irq - IRQ_GPIOA(0)) % 32);
 }
 
diff -puN arch/arm/mach-iop13xx/iq81340mc.c~arm-replace-remaining-__function__-occurences arch/arm/mach-iop13xx/iq81340mc.c
--- a/arch/arm/mach-iop13xx/iq81340mc.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-iop13xx/iq81340mc.c
@@ -81,7 +81,7 @@ static void __init iq81340mc_init(void)
 static void __init iq81340mc_timer_init(void)
 {
 	unsigned long bus_freq = iop13xx_core_freq() / iop13xx_xsi_bus_ratio();
-	printk(KERN_DEBUG "%s: bus frequency: %lu\n", __FUNCTION__, bus_freq);
+	printk(KERN_DEBUG "%s: bus frequency: %lu\n", __func__, bus_freq);
 	iop_init_time(bus_freq);
 }
 
diff -puN arch/arm/mach-iop13xx/iq81340sc.c~arm-replace-remaining-__function__-occurences arch/arm/mach-iop13xx/iq81340sc.c
--- a/arch/arm/mach-iop13xx/iq81340sc.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-iop13xx/iq81340sc.c
@@ -83,7 +83,7 @@ static void __init iq81340sc_init(void)
 static void __init iq81340sc_timer_init(void)
 {
 	unsigned long bus_freq = iop13xx_core_freq() / iop13xx_xsi_bus_ratio();
-	printk(KERN_DEBUG "%s: bus frequency: %lu\n", __FUNCTION__, bus_freq);
+	printk(KERN_DEBUG "%s: bus frequency: %lu\n", __func__, bus_freq);
 	iop_init_time(bus_freq);
 }
 
diff -puN arch/arm/mach-iop13xx/pci.c~arm-replace-remaining-__function__-occurences arch/arm/mach-iop13xx/pci.c
--- a/arch/arm/mach-iop13xx/pci.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-iop13xx/pci.c
@@ -94,13 +94,13 @@ void iop13xx_map_pci_memory(void)
 					, 0, iop13xx_atux_mem_size, MT_DEVICE);
 					if (!iop13xx_atux_mem_base) {
 						printk("%s: atux allocation "
-						       "failed\n", __FUNCTION__);
+						       "failed\n", __func__);
 						BUG();
 					}
 				} else
 					iop13xx_atux_mem_size = 0;
 				PRINTK("%s: atu: %d bus_size: %d mem_base: %x\n",
-				__FUNCTION__, atu, iop13xx_atux_mem_size,
+				__func__, atu, iop13xx_atux_mem_size,
 				iop13xx_atux_mem_base);
 				break;
 			case 1:
@@ -120,13 +120,13 @@ void iop13xx_map_pci_memory(void)
 					, 0, iop13xx_atue_mem_size, MT_DEVICE);
 					if (!iop13xx_atue_mem_base) {
 						printk("%s: atue allocation "
-						       "failed\n", __FUNCTION__);
+						       "failed\n", __func__);
 						BUG();
 					}
 				} else
 					iop13xx_atue_mem_size = 0;
 				PRINTK("%s: atu: %d bus_size: %d mem_base: %x\n",
-				__FUNCTION__, atu, iop13xx_atue_mem_size,
+				__func__, atu, iop13xx_atue_mem_size,
 				iop13xx_atue_mem_base);
 				break;
 			}
diff -puN arch/arm/mach-iop13xx/setup.c~arm-replace-remaining-__function__-occurences arch/arm/mach-iop13xx/setup.c
--- a/arch/arm/mach-iop13xx/setup.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-iop13xx/setup.c
@@ -519,7 +519,7 @@ void __init iop13xx_platform_init(void)
 	if (iq8134x_flash_resource.end > iq8134x_flash_resource.start)
 		iop13xx_devices[plat_idx++] = &iq8134x_flash;
 	else
-		printk(KERN_ERR "%s: Failed to probe flash size\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Failed to probe flash size\n", __func__);
 #endif
 
 	platform_add_devices(iop13xx_devices, plat_idx);
diff -puN arch/arm/mach-ixp4xx/common-pci.c~arm-replace-remaining-__function__-occurences arch/arm/mach-ixp4xx/common-pci.c
--- a/arch/arm/mach-ixp4xx/common-pci.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-ixp4xx/common-pci.c
@@ -87,7 +87,7 @@ static inline int check_master_abort(voi
 	if (isr & PCI_ISR_PFE) {
 		/* make sure the Master Abort bit is reset */    
 		*PCI_ISR = PCI_ISR_PFE;
-		pr_debug("%s failed\n", __FUNCTION__);
+		pr_debug("%s failed\n", __func__);
 		return 1;
 	}
 
diff -puN arch/arm/mach-ixp4xx/gtwx5715-pci.c~arm-replace-remaining-__function__-occurences arch/arm/mach-ixp4xx/gtwx5715-pci.c
--- a/arch/arm/mach-ixp4xx/gtwx5715-pci.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-ixp4xx/gtwx5715-pci.c
@@ -65,7 +65,7 @@ static int __init gtwx5715_map_irq(struc
 	else
 		rc = gtwx5715_irqmap[slot][pin-1];
 
-	printk("%s: Mapped slot %d pin %d to IRQ %d\n", __FUNCTION__,slot, pin, rc);
+	printk("%s: Mapped slot %d pin %d to IRQ %d\n", __func__, slot, pin, rc);
 	return(rc);
 }
 
diff -puN arch/arm/mach-netx/generic.c~arm-replace-remaining-__function__-occurences arch/arm/mach-netx/generic.c
--- a/arch/arm/mach-netx/generic.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-netx/generic.c
@@ -133,7 +133,7 @@ netx_hif_ack_irq(unsigned int _irq)
 	val &= ~((1 << 24) << irq);
 	writel(val, NETX_DPMAS_INT_EN);
 
-	DEBUG_IRQ("%s: irq %d\n", __FUNCTION__, _irq);
+	DEBUG_IRQ("%s: irq %d\n", __func__, _irq);
 }
 
 static void
@@ -145,7 +145,7 @@ netx_hif_mask_irq(unsigned int _irq)
 	val = readl(NETX_DPMAS_INT_EN);
 	val &= ~((1 << 24) << irq);
 	writel(val, NETX_DPMAS_INT_EN);
-	DEBUG_IRQ("%s: irq %d\n", __FUNCTION__, _irq);
+	DEBUG_IRQ("%s: irq %d\n", __func__, _irq);
 }
 
 static void
@@ -157,7 +157,7 @@ netx_hif_unmask_irq(unsigned int _irq)
 	val = readl(NETX_DPMAS_INT_EN);
 	val |= (1 << 24) << irq;
 	writel(val, NETX_DPMAS_INT_EN);
-	DEBUG_IRQ("%s: irq %d\n", __FUNCTION__, _irq);
+	DEBUG_IRQ("%s: irq %d\n", __func__, _irq);
 }
 
 static struct irq_chip netx_hif_chip = {
diff -puN arch/arm/mach-orion/gpio.c~arm-replace-remaining-__function__-occurences arch/arm/mach-orion/gpio.c
--- a/arch/arm/mach-orion/gpio.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-orion/gpio.c
@@ -36,7 +36,7 @@ int gpio_direction_input(unsigned pin)
 	unsigned long flags;
 
 	if (pin >= GPIO_MAX || !test_bit(pin, gpio_valid)) {
-		pr_debug("%s: invalid GPIO %d\n", __FUNCTION__, pin);
+		pr_debug("%s: invalid GPIO %d\n", __func__, pin);
 		return -EINVAL;
 	}
 
@@ -62,7 +62,7 @@ int gpio_direction_output(unsigned pin, 
 	int mask;
 
 	if (pin >= GPIO_MAX || !test_bit(pin, gpio_valid)) {
-		pr_debug("%s: invalid GPIO %d\n", __FUNCTION__, pin);
+		pr_debug("%s: invalid GPIO %d\n", __func__, pin);
 		return -EINVAL;
 	}
 
@@ -141,7 +141,7 @@ int gpio_request(unsigned pin, const cha
 	unsigned long flags;
 
 	if (pin >= GPIO_MAX || !test_bit(pin, gpio_valid)) {
-		pr_debug("%s: invalid GPIO %d\n", __FUNCTION__, pin);
+		pr_debug("%s: invalid GPIO %d\n", __func__, pin);
 		return -EINVAL;
 	}
 
@@ -149,7 +149,7 @@ int gpio_request(unsigned pin, const cha
 
 	if (gpio_label[pin]) {
 		pr_debug("%s: GPIO %d already used as %s\n",
-			 __FUNCTION__, pin, gpio_label[pin]);
+			 __func__, pin, gpio_label[pin]);
 		ret = -EBUSY;
 	} else
 		gpio_label[pin] = label ? label : "?";
@@ -162,12 +162,12 @@ EXPORT_SYMBOL(gpio_request);
 void gpio_free(unsigned pin)
 {
 	if (pin >= GPIO_MAX || !test_bit(pin, gpio_valid)) {
-		pr_debug("%s: invalid GPIO %d\n", __FUNCTION__, pin);
+		pr_debug("%s: invalid GPIO %d\n", __func__, pin);
 		return;
 	}
 
 	if (!gpio_label[pin])
-		pr_warning("%s: GPIO %d already freed\n", __FUNCTION__, pin);
+		pr_warning("%s: GPIO %d already freed\n", __func__, pin);
 	else
 		gpio_label[pin] = NULL;
 }
diff -puN arch/arm/mach-pnx4008/clock.c~arm-replace-remaining-__function__-occurences arch/arm/mach-pnx4008/clock.c
--- a/arch/arm/mach-pnx4008/clock.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-pnx4008/clock.c
@@ -976,7 +976,7 @@ static int __init clk_init(void)
 				(*clkp)->set_parent((*clkp), (*clkp)->parent);
 		}
 		pr_debug("%s: clock %s, rate %ld\n",
-			__FUNCTION__, (*clkp)->name, (*clkp)->rate);
+			__func__, (*clkp)->name, (*clkp)->rate);
 	}
 
 	local_clk_use(&ck_pll4);
diff -puN arch/arm/mach-pnx4008/dma.c~arm-replace-remaining-__function__-occurences arch/arm/mach-pnx4008/dma.c
--- a/arch/arm/mach-pnx4008/dma.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-pnx4008/dma.c
@@ -192,7 +192,7 @@ void pnx4008_free_channel(int ch)
 	if (!dma_channels[ch].name) {
 		printk(KERN_CRIT
 		       "%s: trying to free channel %d which is already freed\n",
-		       __FUNCTION__, ch);
+		       __func__, ch);
 		return;
 	}
 
diff -puN arch/arm/mach-pxa/cm-x270-pci.c~arm-replace-remaining-__function__-occurences arch/arm/mach-pxa/cm-x270-pci.c
--- a/arch/arm/mach-pxa/cm-x270-pci.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-pxa/cm-x270-pci.c
@@ -104,7 +104,7 @@ static int __init cmx270_pci_map_irq(str
 {
 	int irq;
 
-	dev_dbg(&dev->dev, "%s: slot=%x, pin=%x\n", __FUNCTION__, slot, pin);
+	dev_dbg(&dev->dev, "%s: slot=%x, pin=%x\n", __func__, slot, pin);
 
 	irq = it8152_pci_map_irq(dev, slot, pin);
 	if (irq)
diff -puN arch/arm/mach-pxa/cm-x270.c~arm-replace-remaining-__function__-occurences arch/arm/mach-pxa/cm-x270.c
--- a/arch/arm/mach-pxa/cm-x270.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-pxa/cm-x270.c
@@ -504,11 +504,11 @@ static void cmx270_mci_setpower(struct d
 	struct pxamci_platform_data *p_d = dev->platform_data;
 
 	if ((1 << vdd) & p_d->ocr_mask) {
-		printk(KERN_DEBUG "%s: on\n", __FUNCTION__);
+		printk(KERN_DEBUG "%s: on\n", __func__);
 		GPCR(105) = GPIO_bit(105);
 	} else {
 		GPSR(105) = GPIO_bit(105);
-		printk(KERN_DEBUG "%s: off\n", __FUNCTION__);
+		printk(KERN_DEBUG "%s: off\n", __func__);
 	}
 }
 
diff -puN arch/arm/mach-pxa/dma.c~arm-replace-remaining-__function__-occurences arch/arm/mach-pxa/dma.c
--- a/arch/arm/mach-pxa/dma.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-pxa/dma.c
@@ -81,7 +81,7 @@ void pxa_free_dma (int dma_ch)
 	if (!dma_channels[dma_ch].name) {
 		printk (KERN_CRIT
 			"%s: trying to free channel %d which is already freed\n",
-			__FUNCTION__, dma_ch);
+			__func__, dma_ch);
 		return;
 	}
 
diff -puN arch/arm/mach-pxa/em-x270.c~arm-replace-remaining-__function__-occurences arch/arm/mach-pxa/em-x270.c
--- a/arch/arm/mach-pxa/em-x270.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-pxa/em-x270.c
@@ -264,7 +264,7 @@ static int em_x270_mci_init(struct devic
 			  "MMC card detect", data);
 	if (err) {
 		printk(KERN_ERR "%s: can't request MMC card detect IRQ: %d\n",
-		       __FUNCTION__, err);
+		       __func__, err);
 		return err;
 	}
 
diff -puN arch/arm/mach-pxa/mainstone.c~arm-replace-remaining-__function__-occurences arch/arm/mach-pxa/mainstone.c
--- a/arch/arm/mach-pxa/mainstone.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-pxa/mainstone.c
@@ -390,11 +390,11 @@ static void mainstone_mci_setpower(struc
 	struct pxamci_platform_data* p_d = dev->platform_data;
 
 	if (( 1 << vdd) & p_d->ocr_mask) {
-		printk(KERN_DEBUG "%s: on\n", __FUNCTION__);
+		printk(KERN_DEBUG "%s: on\n", __func__);
 		MST_MSCWR1 |= MST_MSCWR1_MMC_ON;
 		MST_MSCWR1 &= ~MST_MSCWR1_MS_SEL;
 	} else {
-		printk(KERN_DEBUG "%s: off\n", __FUNCTION__);
+		printk(KERN_DEBUG "%s: off\n", __func__);
 		MST_MSCWR1 &= ~MST_MSCWR1_MMC_ON;
 	}
 }
diff -puN arch/arm/mach-pxa/trizeps4.c~arm-replace-remaining-__function__-occurences arch/arm/mach-pxa/trizeps4.c
--- a/arch/arm/mach-pxa/trizeps4.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-pxa/trizeps4.c
@@ -217,7 +217,7 @@ void board_pcmcia_power(int power)
 		ConXS_BCR = trizeps_conxs_bcr;
 
 	}
-	pr_debug("%s: o%s 0x%x\n", __FUNCTION__, power ? "n": "ff", trizeps_conxs_bcr);
+	pr_debug("%s: o%s 0x%x\n", __func__, power ? "n": "ff", trizeps_conxs_bcr);
 }
 
 /* backlight power switching for LCD panel */
@@ -228,7 +228,7 @@ static void board_backlight_power(int on
 	} else {
 		trizeps_conxs_bcr &= ~ConXS_BCR_L_DISP;
 	}
-	pr_debug("%s: o%s 0x%x\n", __FUNCTION__, on ? "n" : "ff", trizeps_conxs_bcr);
+	pr_debug("%s: o%s 0x%x\n", __func__, on ? "n" : "ff", trizeps_conxs_bcr);
 	ConXS_BCR = trizeps_conxs_bcr;
 }
 
@@ -238,10 +238,10 @@ static void board_mci_power(struct devic
 	struct pxamci_platform_data* p_d = dev->platform_data;
 
 	if (( 1 << vdd) & p_d->ocr_mask) {
-		pr_debug("%s: on\n", __FUNCTION__);
+		pr_debug("%s: on\n", __func__);
 		/* FIXME fill in values here */
 	} else {
-		pr_debug("%s: off\n", __FUNCTION__);
+		pr_debug("%s: off\n", __func__);
 		/* FIXME fill in values here */
 	}
 }
diff -puN arch/arm/mach-sa1100/badge4.c~arm-replace-remaining-__function__-occurences arch/arm/mach-sa1100/badge4.c
--- a/arch/arm/mach-sa1100/badge4.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-sa1100/badge4.c
@@ -206,7 +206,7 @@ static int __init badge4_init(void)
 	if (ret < 0)
 		printk(KERN_ERR
 		       "%s: SA-1111 initialization failed (%d)\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 
 
 	/* maybe turn on 5v0 from the start */
@@ -240,11 +240,11 @@ void badge4_set_5V(unsigned subsystem, i
 	/* detect on->off and off->on transitions */
 	if ((!old_5V_bitmap) && (badge4_5V_bitmap)) {
 		/* was off, now on */
-		printk(KERN_INFO "%s: enabling 5V supply rail\n", __FUNCTION__);
+		printk(KERN_INFO "%s: enabling 5V supply rail\n", __func__);
 		GPSR = BADGE4_GPIO_PCMEN5V;
 	} else if ((old_5V_bitmap) && (!badge4_5V_bitmap)) {
 		/* was on, now off */
-		printk(KERN_INFO "%s: disabling 5V supply rail\n", __FUNCTION__);
+		printk(KERN_INFO "%s: disabling 5V supply rail\n", __func__);
 		GPCR = BADGE4_GPIO_PCMEN5V;
 	}
 
diff -puN arch/arm/mach-sa1100/cpu-sa1100.c~arm-replace-remaining-__function__-occurences arch/arm/mach-sa1100/cpu-sa1100.c
--- a/arch/arm/mach-sa1100/cpu-sa1100.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-sa1100/cpu-sa1100.c
@@ -139,7 +139,7 @@ static void sa1100_update_dram_timings(i
 
 	if (settings->speed == 0) {
 		panic("%s: couldn't find dram setting for speed %d\n",
-		      __FUNCTION__, new_speed);
+		      __func__, new_speed);
 	}
 
 	/* No risk, no fun: run with interrupts on! */
diff -puN arch/arm/mach-sa1100/dma.c~arm-replace-remaining-__function__-occurences arch/arm/mach-sa1100/dma.c
--- a/arch/arm/mach-sa1100/dma.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-sa1100/dma.c
@@ -129,7 +129,7 @@ int sa1100_request_dma (dma_device_t dev
 	if (err) {
 		printk(KERN_ERR
 		       "%s: unable to request IRQ %d for %s\n",
-		       __FUNCTION__, IRQ_DMA0 + i, device_id);
+		       __func__, IRQ_DMA0 + i, device_id);
 		dma->device = 0;
 		return err;
 	}
@@ -165,12 +165,12 @@ void sa1100_free_dma(dma_regs_t *regs)
 		if (regs == (dma_regs_t *)&DDAR(i))
 			break;
 	if (i >= SA1100_DMA_CHANNELS) {
-		printk(KERN_ERR "%s: bad DMA identifier\n", __FUNCTION__);
+		printk(KERN_ERR "%s: bad DMA identifier\n", __func__);
 		return;
 	}
 
 	if (!dma_chan[i].device) {
-		printk(KERN_ERR "%s: Trying to free free DMA\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Trying to free free DMA\n", __func__);
 		return;
 	}
 
@@ -329,7 +329,7 @@ void sa1100_reset_dma(dma_regs_t *regs)
 		if (regs == (dma_regs_t *)&DDAR(i))
 			break;
 	if (i >= SA1100_DMA_CHANNELS) {
-		printk(KERN_ERR "%s: bad DMA identifier\n", __FUNCTION__);
+		printk(KERN_ERR "%s: bad DMA identifier\n", __func__);
 		return;
 	}
 
diff -puN arch/arm/mach-sa1100/h3600.c~arm-replace-remaining-__function__-occurences arch/arm/mach-sa1100/h3600.c
--- a/arch/arm/mach-sa1100/h3600.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/mach-sa1100/h3600.c
@@ -596,7 +596,7 @@ static void h3800_control_egpio(enum ipa
 	case IPAQ_EGPIO_CODEC_NRESET:
 	case IPAQ_EGPIO_AUDIO_ON:
 	case IPAQ_EGPIO_QMUTE:
-		printk("%s: error - should not be called\n", __FUNCTION__);
+		printk("%s: error - should not be called\n", __func__);
 		break;
 	case IPAQ_EGPIO_OPT_NVRAM_ON:
 		SET_ASIC2(GPIO2_OPT_ON_NVRAM);
@@ -638,7 +638,7 @@ static int h3800_pm_callback(int req)
 	static u16 asic2_data;
 	int result = 0;
 
-	printk("%s %d\n", __FUNCTION__, req);
+	printk("%s %d\n", __func__, req);
 
 	switch (req) {
 	case PM_RESUME:
@@ -666,7 +666,7 @@ static int h3800_pm_callback(int req)
 		asic2_data = H3800_ASIC2_GPIOPIOD;
 		break;
 	default:
-		printk("%s: unrecognized PM callback\n", __FUNCTION__);
+		printk("%s: unrecognized PM callback\n", __func__);
 		break;
 	}
 	return result;
@@ -706,7 +706,7 @@ static void h3800_IRQ_demux(unsigned int
 {
 	int i;
 
-	if (0) printk("%s: interrupt received\n", __FUNCTION__);
+	if (0) printk("%s: interrupt received\n", __func__);
 
 	desc->chip->ack(irq);
 
@@ -716,21 +716,21 @@ static void h3800_IRQ_demux(unsigned int
 
 		/* KPIO */
 		irq = H3800_ASIC2_KPIINTFLAG;
-		if (0) printk("%s KPIO 0x%08X\n", __FUNCTION__, irq);
+		if (0) printk("%s KPIO 0x%08X\n", __func__, irq);
 		for (j = 0; j < H3800_KPIO_IRQ_COUNT; j++)
 			if (irq & kpio_irq_mask[j])
 				handle_edge_irq(H3800_KPIO_IRQ_COUNT + j, irq_desc + H3800_KPIO_IRQ_COUNT + j);
 
 		/* GPIO2 */
 		irq = H3800_ASIC2_GPIINTFLAG;
-		if (0) printk("%s GPIO 0x%08X\n", __FUNCTION__, irq);
+		if (0) printk("%s GPIO 0x%08X\n", __func__, irq);
 		for (j = 0; j < H3800_GPIO_IRQ_COUNT; j++)
 			if (irq & gpio_irq_mask[j])
 				handle_edge_irq(H3800_GPIO_IRQ_COUNT + j, irq_desc + H3800_GPIO_IRQ_COUNT + j);
 	}
 
 	if (i >= MAX_ASIC_ISR_LOOPS)
-		printk("%s: interrupt processing overrun\n", __FUNCTION__);
+		printk("%s: interrupt processing overrun\n", __func__);
 
 	/* For level-based interrupts */
 	desc->chip->unmask(irq);
diff -puN arch/arm/plat-iop/pci.c~arm-replace-remaining-__function__-occurences arch/arm/plat-iop/pci.c
--- a/arch/arm/plat-iop/pci.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/plat-iop/pci.c
@@ -371,7 +371,7 @@ static int __init iop3xx_init_atu_setup(
 			default:
 				printk(KERN_DEBUG "\"%s\" malformed at "
 					    "character: \'%c\'",
-					    __FUNCTION__,
+					    __func__,
 					    *str);
 				*(str + 1) = '\0';
 			}
diff -puN arch/arm/plat-omap/dma.c~arm-replace-remaining-__function__-occurences arch/arm/plat-omap/dma.c
--- a/arch/arm/plat-omap/dma.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/plat-omap/dma.c
@@ -137,7 +137,7 @@ static void omap_disable_channel_irq(int
 static inline void omap_enable_channel_irq(int lch);
 
 #define REVISIT_24XX()		printk(KERN_ERR "FIXME: no %s on 24xx\n", \
-						__FUNCTION__);
+						__func__);
 
 #ifdef CONFIG_ARCH_OMAP15XX
 /* Returns 1 if the DMA module is in OMAP1510-compatible mode, 0 otherwise */
@@ -699,7 +699,7 @@ omap_dma_set_global_params(int arb_rate,
 	u32 reg;
 
 	if (!cpu_class_is_omap2()) {
-		printk(KERN_ERR "FIXME: no %s on 15xx/16xx\n", __FUNCTION__);
+		printk(KERN_ERR "FIXME: no %s on 15xx/16xx\n", __func__);
 		return;
 	}
 
diff -puN arch/arm/plat-omap/dmtimer.c~arm-replace-remaining-__function__-occurences arch/arm/plat-omap/dmtimer.c
--- a/arch/arm/plat-omap/dmtimer.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/plat-omap/dmtimer.c
@@ -268,7 +268,7 @@ struct omap_dm_timer *omap_dm_timer_requ
 	if (id <= 0 || id > dm_timer_count || dm_timers[id-1].reserved) {
 		spin_unlock_irqrestore(&dm_timer_lock, flags);
 		printk("BUG: warning at %s:%d/%s(): unable to get timer %d\n",
-		       __FILE__, __LINE__, __FUNCTION__, id);
+		       __FILE__, __LINE__, __func__, id);
 		dump_stack();
 		return NULL;
 	}
diff -puN arch/arm/plat-s3c24xx/dma.c~arm-replace-remaining-__function__-occurences arch/arm/plat-s3c24xx/dma.c
--- a/arch/arm/plat-s3c24xx/dma.c~arm-replace-remaining-__function__-occurences
+++ a/arch/arm/plat-s3c24xx/dma.c
@@ -130,8 +130,8 @@ dmadbg_showregs(const char *fname, int l
 	dmadbg_dumpregs(fname, line, chan, &state);
 }
 
-#define dbg_showregs(chan) dmadbg_showregs(__FUNCTION__, __LINE__, (chan))
-#define dbg_showchan(chan) dmadbg_showchan(__FUNCTION__, __LINE__, (chan))
+#define dbg_showregs(chan) dmadbg_showregs(__func__, __LINE__, (chan))
+#define dbg_showchan(chan) dmadbg_showchan(__func__, __LINE__, (chan))
 #else
 #define dbg_showregs(chan) do { } while(0)
 #define dbg_showchan(chan) do { } while(0)
@@ -403,7 +403,7 @@ static int s3c2410_dma_start(struct s3c2
 
 			if (s3c2410_dma_waitforload(chan, __LINE__) == 0) {
 				pr_debug("%s: buff not yet loaded, no more todo\n",
-					 __FUNCTION__);
+					 __func__);
 			} else {
 				chan->load_state = S3C2410_DMALOAD_1RUNNING;
 				s3c2410_dma_loadbuffer(chan, chan->next);
@@ -463,16 +463,16 @@ int s3c2410_dma_enqueue(unsigned int cha
 		return -EINVAL;
 
 	pr_debug("%s: id=%p, data=%08x, size=%d\n",
-		 __FUNCTION__, id, (unsigned int)data, size);
+		 __func__, id, (unsigned int)data, size);
 
 	buf = kmem_cache_alloc(dma_kmem, GFP_ATOMIC);
 	if (buf == NULL) {
 		pr_debug("%s: out of memory (%ld alloc)\n",
-			 __FUNCTION__, (long)sizeof(*buf));
+			 __func__, (long)sizeof(*buf));
 		return -ENOMEM;
 	}
 
-	//pr_debug("%s: new buffer %p\n", __FUNCTION__, buf);
+	//pr_debug("%s: new buffer %p\n", __func__, buf);
 	//dbg_showchan(chan);
 
 	buf->next  = NULL;
@@ -486,18 +486,18 @@ int s3c2410_dma_enqueue(unsigned int cha
 	if (chan->curr == NULL) {
 		/* we've got nothing loaded... */
 		pr_debug("%s: buffer %p queued onto empty channel\n",
-			 __FUNCTION__, buf);
+			 __func__, buf);
 
 		chan->curr = buf;
 		chan->end  = buf;
 		chan->next = NULL;
 	} else {
 		pr_debug("dma%d: %s: buffer %p queued onto non-empty channel\n",
-			 chan->number, __FUNCTION__, buf);
+			 chan->number, __func__, buf);
 
 		if (chan->end == NULL)
 			pr_debug("dma%d: %s: %p not empty, and chan->end==NULL?\n",
-				 chan->number, __FUNCTION__, chan);
+				 chan->number, __func__, chan);
 
 		chan->end->next = buf;
 		chan->end = buf;
@@ -572,7 +572,7 @@ s3c2410_dma_lastxfer(struct s3c2410_dma_
 		if (s3c2410_dma_waitforload(chan, __LINE__) == 0) {
 				/* flag error? */
 			printk(KERN_ERR "dma%d: timeout waiting for load (%s)\n",
-			       chan->number, __FUNCTION__);
+			       chan->number, __func__);
 			return;
 		}
 		break;
@@ -658,7 +658,7 @@ s3c2410_dma_irq(int irq, void *devpw)
 
 		if (buf->magic != BUF_MAGIC) {
 			printk(KERN_ERR "dma%d: %s: buf %p incorrect magic\n",
-			       chan->number, __FUNCTION__, buf);
+			       chan->number, __func__, buf);
 			return IRQ_HANDLED;
 		}
 
@@ -692,7 +692,7 @@ s3c2410_dma_irq(int irq, void *devpw)
 			if (s3c2410_dma_waitforload(chan, __LINE__) == 0) {
 				/* flag error? */
 				printk(KERN_ERR "dma%d: timeout waiting for load (%s)\n",
-				       chan->number, __FUNCTION__);
+				       chan->number, __func__);
 				return IRQ_HANDLED;
 			}
 
@@ -759,7 +759,7 @@ int s3c2410_dma_request(unsigned int cha
 
 	if (!chan->irq_claimed) {
 		pr_debug("dma%d: %s : requesting irq %d\n",
-			 channel, __FUNCTION__, chan->irq);
+			 channel, __func__, chan->irq);
 
 		chan->irq_claimed = 1;
 		local_irq_restore(flags);
@@ -786,7 +786,7 @@ int s3c2410_dma_request(unsigned int cha
 
 	/* need to setup */
 
-	pr_debug("%s: channel initialised, %p\n", __FUNCTION__, chan);
+	pr_debug("%s: channel initialised, %p\n", __func__, chan);
 
 	return chan->number | DMACH_LOW_LEVEL;
 }
@@ -823,7 +823,7 @@ int s3c2410_dma_free(dmach_t channel, st
 
 	if (chan->state != S3C2410_DMA_IDLE) {
 		pr_debug("%s: need to stop dma channel %p\n",
-		       __FUNCTION__, chan);
+		       __func__, chan);
 
 		/* possibly flush the channel */
 		s3c2410_dma_ctrl(channel, S3C2410_DMAOP_STOP);
@@ -852,7 +852,7 @@ static int s3c2410_dma_dostop(struct s3c
 	unsigned long flags;
 	unsigned long tmp;
 
-	pr_debug("%s:\n", __FUNCTION__);
+	pr_debug("%s:\n", __func__);
 
 	dbg_showchan(chan);
 
@@ -907,14 +907,14 @@ static int s3c2410_dma_flush(struct s3c2
 	struct s3c2410_dma_buf *buf, *next;
 	unsigned long flags;
 
-	pr_debug("%s: chan %p (%d)\n", __FUNCTION__, chan, chan->number);
+	pr_debug("%s: chan %p (%d)\n", __func__, chan, chan->number);
 
 	dbg_showchan(chan);
 
 	local_irq_save(flags);
 
 	if (chan->state != S3C2410_DMA_IDLE) {
-		pr_debug("%s: stopping channel...\n", __FUNCTION__ );
+		pr_debug("%s: stopping channel...\n", __func__ );
 		s3c2410_dma_ctrl(chan->number, S3C2410_DMAOP_STOP);
 	}
 
@@ -929,7 +929,7 @@ static int s3c2410_dma_flush(struct s3c2
 			next = buf->next;
 
 			pr_debug("%s: free buffer %p, next %p\n",
-			       __FUNCTION__, buf, buf->next);
+			       __func__, buf, buf->next);
 
 			s3c2410_dma_buffdone(chan, buf, S3C2410_RES_ABORT);
 			s3c2410_dma_freebuf(buf);
@@ -976,7 +976,7 @@ static int s3c2410_dma_started(struct s3
 
 			if (s3c2410_dma_waitforload(chan, __LINE__) == 0) {
 				pr_debug("%s: buff not yet loaded, no more todo\n",
-					 __FUNCTION__);
+					 __func__);
 			} else {
 				chan->load_state = S3C2410_DMALOAD_1RUNNING;
 				s3c2410_dma_loadbuffer(chan, chan->next);
@@ -1050,16 +1050,16 @@ int s3c2410_dma_config(dmach_t channel,
 	struct s3c2410_dma_chan *chan = lookup_dma_channel(channel);
 
 	pr_debug("%s: chan=%d, xfer_unit=%d, dcon=%08x\n",
-		 __FUNCTION__, channel, xferunit, dcon);
+		 __func__, channel, xferunit, dcon);
 
 	if (chan == NULL)
 		return -EINVAL;
 
-	pr_debug("%s: Initial dcon is %08x\n", __FUNCTION__, dcon);
+	pr_debug("%s: Initial dcon is %08x\n", __func__, dcon);
 
 	dcon |= chan->dcon & dma_sel.dcon_mask;
 
-	pr_debug("%s: New dcon is %08x\n", __FUNCTION__, dcon);
+	pr_debug("%s: New dcon is %08x\n", __func__, dcon);
 
 	switch (xferunit) {
 	case 1:
@@ -1075,14 +1075,14 @@ int s3c2410_dma_config(dmach_t channel,
 		break;
 
 	default:
-		pr_debug("%s: bad transfer size %d\n", __FUNCTION__, xferunit);
+		pr_debug("%s: bad transfer size %d\n", __func__, xferunit);
 		return -EINVAL;
 	}
 
 	dcon |= S3C2410_DCON_HWTRIG;
 	dcon |= S3C2410_DCON_INTREQ;
 
-	pr_debug("%s: dcon now %08x\n", __FUNCTION__, dcon);
+	pr_debug("%s: dcon now %08x\n", __func__, dcon);
 
 	chan->dcon = dcon;
 	chan->xfer_unit = xferunit;
@@ -1099,7 +1099,7 @@ int s3c2410_dma_setflags(dmach_t channel
 	if (chan == NULL)
 		return -EINVAL;
 
-	pr_debug("%s: chan=%p, flags=%08x\n", __FUNCTION__, chan, flags);
+	pr_debug("%s: chan=%p, flags=%08x\n", __func__, chan, flags);
 
 	chan->flags = flags;
 
@@ -1120,7 +1120,7 @@ int s3c2410_dma_set_opfn(dmach_t channel
 	if (chan == NULL)
 		return -EINVAL;
 
-	pr_debug("%s: chan=%p, op rtn=%p\n", __FUNCTION__, chan, rtn);
+	pr_debug("%s: chan=%p, op rtn=%p\n", __func__, chan, rtn);
 
 	chan->op_fn = rtn;
 
@@ -1136,7 +1136,7 @@ int s3c2410_dma_set_buffdone_fn(dmach_t 
 	if (chan == NULL)
 		return -EINVAL;
 
-	pr_debug("%s: chan=%p, callback rtn=%p\n", __FUNCTION__, chan, rtn);
+	pr_debug("%s: chan=%p, callback rtn=%p\n", __func__, chan, rtn);
 
 	chan->callback_fn = rtn;
 
@@ -1170,7 +1170,7 @@ int s3c2410_dma_devconfig(int channel,
 		return -EINVAL;
 
 	pr_debug("%s: source=%d, hwcfg=%08x, devaddr=%08lx\n",
-		 __FUNCTION__, (int)source, hwcfg, devaddr);
+		 __func__, (int)source, hwcfg, devaddr);
 
 	chan->source = source;
 	chan->dev_addr = devaddr;
@@ -1180,7 +1180,7 @@ int s3c2410_dma_devconfig(int channel,
 	case S3C2410_DMASRC_HW:
 		/* source is hardware */
 		pr_debug("%s: hw source, devaddr=%08lx, hwcfg=%d\n",
-			 __FUNCTION__, devaddr, hwcfg);
+			 __func__, devaddr, hwcfg);
 		dma_wrreg(chan, S3C2410_DMA_DISRCC, hwcfg & 3);
 		dma_wrreg(chan, S3C2410_DMA_DISRC,  devaddr);
 		dma_wrreg(chan, S3C2410_DMA_DIDSTC, (0<<1) | (0<<0));
@@ -1190,8 +1190,8 @@ int s3c2410_dma_devconfig(int channel,
 
 	case S3C2410_DMASRC_MEM:
 		/* source is memory */
-		pr_debug( "%s: mem source, devaddr=%08lx, hwcfg=%d\n",
-			  __FUNCTION__, devaddr, hwcfg);
+		pr_debug("%s: mem source, devaddr=%08lx, hwcfg=%d\n",
+			 __func__, devaddr, hwcfg);
 		dma_wrreg(chan, S3C2410_DMA_DISRCC, (0<<1) | (0<<0));
 		dma_wrreg(chan, S3C2410_DMA_DIDST,  devaddr);
 		dma_wrreg(chan, S3C2410_DMA_DIDSTC, hwcfg & 3);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
acpi-replace-remaining-__function__-occurrences.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-arm-master.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
ieee1394-replace-remaining-__function__-occurrences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
ata-replace-remaining-__function__-occurrences.patch
pata_amd-fix-sparse-warning.patch
git-mips.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
git-sh.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
power-replace-remaining-__function__-occurrences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
iop-admac-replace-remaining-__function__-occurrences.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

