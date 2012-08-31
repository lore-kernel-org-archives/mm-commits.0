From: akpm@linux-foundation.org
Subject: + dw_dmac-make-driver-endianness-configurable.patch added to -mm tree
Date: Fri, 31 Aug 2012 16:44:51 -0700
Message-ID: <20120831234452.188061E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:35240 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2HaXox (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 19:44:53 -0400
Received: by yenq6 with SMTP id q6so404401yen.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 16:44:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hein_tibosch@yahoo.es, arnd.bergmann@linaro.org, egtvedt@samfundet.no, havard@skinnemoen.net, nicolas.ferre@atmel.com


The patch titled
     Subject: dw_dmac: make driver endianness configurable
has been added to the -mm tree.  Its filename is
     dw_dmac-make-driver-endianness-configurable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hein Tibosch <hein_tibosch@yahoo.es>
Subject: dw_dmac: make driver endianness configurable

The dw_dmac was originally developed for avr32 to be used with the
Synopsys DesignWare AHB DMA controller.  After 2.6.38, device access was
done with the little-endian readl/writel functions.  This didn't work on
the avr32 platform, because it needs native-endian (i.e.  big-endian)
accessors.  This patch makes the endianness configurable using
'DW_DMAC_BE', which will default be true for AVR32

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Havard Skinnemoen <havard@skinnemoen.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/Kconfig        |    8 ++++++++
 drivers/dma/dw_dmac_regs.h |   22 ++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff -puN drivers/dma/Kconfig~dw_dmac-make-driver-endianness-configurable drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~dw_dmac-make-driver-endianness-configurable
+++ a/drivers/dma/Kconfig
@@ -90,6 +90,14 @@ config DW_DMAC
 	  Support the Synopsys DesignWare AHB DMA controller.  This
 	  can be integrated in chips such as the Atmel AT32ap7000.
 
+config DW_DMAC_BE
+	bool "Synopsys DesignWare AHB DMA needs big endian access"
+	default y if AVR32
+	depends on DW_DMAC
+	help
+	  Say yes if access to the Synopsys DesignWare AHB DMA controller
+	  should be big endian, such as for Atmel AT32ap7000
+
 config AT_HDMAC
 	tristate "Atmel AHB DMA support"
 	depends on ARCH_AT91
diff -puN drivers/dma/dw_dmac_regs.h~dw_dmac-make-driver-endianness-configurable drivers/dma/dw_dmac_regs.h
--- a/drivers/dma/dw_dmac_regs.h~dw_dmac-make-driver-endianness-configurable
+++ a/drivers/dma/dw_dmac_regs.h
@@ -175,11 +175,22 @@ __dwc_regs(struct dw_dma_chan *dwc)
 	return dwc->ch_regs;
 }
 
+#ifdef CONFIG_DW_DMAC_BE
+
+#define channel_readl(dwc, name) \
+	ioread32be(&(__dwc_regs(dwc)->name))
+#define channel_writel(dwc, name, val) \
+	iowrite32be((val), &(__dwc_regs(dwc)->name))
+
+#else
+
 #define channel_readl(dwc, name) \
 	readl(&(__dwc_regs(dwc)->name))
 #define channel_writel(dwc, name, val) \
 	writel((val), &(__dwc_regs(dwc)->name))
 
+#endif
+
 static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
 {
 	return container_of(chan, struct dw_dma_chan, chan);
@@ -201,11 +212,22 @@ static inline struct dw_dma_regs __iomem
 	return dw->regs;
 }
 
+#ifdef CONFIG_DW_DMAC_BE
+
+#define dma_readl(dwc, name) \
+	ioread32be(&(__dw_regs(dw)->name))
+#define dma_writel(dwc, name, val) \
+	iowrite32be((val), &(__dw_regs(dw)->name))
+
+#else
+
 #define dma_readl(dw, name) \
 	readl(&(__dw_regs(dw)->name))
 #define dma_writel(dw, name, val) \
 	writel((val), &(__dw_regs(dw)->name))
 
+#endif
+
 #define channel_set_bit(dw, reg, mask) \
 	dma_writel(dw, reg, ((mask) << 8) | (mask))
 #define channel_clear_bit(dw, reg, mask) \
_

Patches currently in -mm which might be from hein_tibosch@yahoo.es are

dw_dmac-make-driver-endianness-configurable.patch
avr32-linux-at32ap700x-set-dma-slave-properties-for-mci-dw_dmac.patch
lib-decompressc-add-__init-to-decompress_method-and-data.patch

