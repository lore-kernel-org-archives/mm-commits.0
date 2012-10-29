From: akpm@linux-foundation.org
Subject: [merged] drivers-dma-dw_dmac-make-drivers-endianness-configurable.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:19 -0700
Message-ID: <20121029195019.C4929100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36994 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2J2TuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:21 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so375916qae.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hein_tibosch@yahoo.es, andriy.shevchenko@linux.intel.com, arnd@arndb.de, egtvedt@samfundet.no, havard@skinnemoen.net, ludovic.desroches@atmel.com, nicolas.ferre@atmel.com, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/dma/dw_dmac: make driver's endianness configurable
has been removed from the -mm tree.  Its filename was
     drivers-dma-dw_dmac-make-drivers-endianness-configurable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hein Tibosch <hein_tibosch@yahoo.es>
Subject: drivers/dma/dw_dmac: make driver's endianness configurable

The dw_dmac driver was originally developed for avr32 to be used with the
Synopsys DesignWare AHB DMA controller.  Starting from 2.6.38, access to
the device's i/o memory was done with the little-endian readl/writel
functions(1)

This broke the driver for the avr32 platform, because it needs big
(native) endian accessors.  This patch makes the endianness configurable
using 'DW_DMAC_BIG_ENDIAN_IO', which will default be true for AVR32

I submitted this patch before(2) but then waited for Andy to finish other
changes to the same module(3).

(1) https://patchwork.kernel.org/patch/608211
(2) https://lkml.org/lkml/2012/8/26/148
(3) https://lkml.org/lkml/2012/9/21/173

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Havard Skinnemoen <havard@skinnemoen.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/Kconfig        |   11 +++++++++++
 drivers/dma/dw_dmac_regs.h |   18 +++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff -puN drivers/dma/Kconfig~drivers-dma-dw_dmac-make-drivers-endianness-configurable drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~drivers-dma-dw_dmac-make-drivers-endianness-configurable
+++ a/drivers/dma/Kconfig
@@ -90,6 +90,17 @@ config DW_DMAC
 	  Support the Synopsys DesignWare AHB DMA controller.  This
 	  can be integrated in chips such as the Atmel AT32ap7000.
 
+config DW_DMAC_BIG_ENDIAN_IO
+	bool "Use big endian I/O register access"
+	default y if AVR32
+	depends on DW_DMAC
+	help
+	  Say yes here to use big endian I/O access when reading and writing
+	  to the DMA controller registers. This is needed on some platforms,
+	  like the Atmel AVR32 architecture.
+
+	  If unsure, use the default setting.
+
 config AT_HDMAC
 	tristate "Atmel AHB DMA support"
 	depends on ARCH_AT91
diff -puN drivers/dma/dw_dmac_regs.h~drivers-dma-dw_dmac-make-drivers-endianness-configurable drivers/dma/dw_dmac_regs.h
--- a/drivers/dma/dw_dmac_regs.h~drivers-dma-dw_dmac-make-drivers-endianness-configurable
+++ a/drivers/dma/dw_dmac_regs.h
@@ -98,9 +98,17 @@ struct dw_dma_regs {
 	u32	DW_PARAMS;
 };
 
+#ifdef CONFIG_DW_DMAC_BIG_ENDIAN_IO
+#define dma_readl_native ioread32be
+#define dma_writel_native iowrite32be
+#else
+#define dma_readl_native readl
+#define dma_writel_native writel
+#endif
+
 /* To access the registers in early stage of probe */
 #define dma_read_byaddr(addr, name) \
-	readl((addr) + offsetof(struct dw_dma_regs, name))
+	dma_readl_native((addr) + offsetof(struct dw_dma_regs, name))
 
 /* Bitfields in DW_PARAMS */
 #define DW_PARAMS_NR_CHAN	8		/* number of channels */
@@ -216,9 +224,9 @@ __dwc_regs(struct dw_dma_chan *dwc)
 }
 
 #define channel_readl(dwc, name) \
-	readl(&(__dwc_regs(dwc)->name))
+	dma_readl_native(&(__dwc_regs(dwc)->name))
 #define channel_writel(dwc, name, val) \
-	writel((val), &(__dwc_regs(dwc)->name))
+	dma_writel_native((val), &(__dwc_regs(dwc)->name))
 
 static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
 {
@@ -246,9 +254,9 @@ static inline struct dw_dma_regs __iomem
 }
 
 #define dma_readl(dw, name) \
-	readl(&(__dw_regs(dw)->name))
+	dma_readl_native(&(__dw_regs(dw)->name))
 #define dma_writel(dw, name, val) \
-	writel((val), &(__dw_regs(dw)->name))
+	dma_writel_native((val), &(__dw_regs(dw)->name))
 
 #define channel_set_bit(dw, reg, mask) \
 	dma_writel(dw, reg, ((mask) << 8) | (mask))
_

Patches currently in -mm which might be from hein_tibosch@yahoo.es are


