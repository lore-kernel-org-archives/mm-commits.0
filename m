From: akpm@linux-foundation.org
Subject: + smc911x-introduce-platform-data-flags.patch added to -mm tree
Date: Tue, 03 Jun 2008 15:46:57 -0700
Message-ID: <200806032246.m53Mkvn8023823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965AbYFCWrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 18:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org


The patch titled
     smc911x: introduce platform data flags
has been added to the -mm tree.  Its filename is
     smc911x-introduce-platform-data-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc911x: introduce platform data flags
From: Magnus Damm <magnus.damm@gmail.com>

This patch adds a new header file for platform data information
together with code that adds run time bus width and irq flag support.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc911x.c   |   17 +++++++
 drivers/net/smc911x.h   |   81 ++++++++++++++++++++++++++++++++++++++
 include/linux/smc911x.h |   12 +++++
 3 files changed, 109 insertions(+), 1 deletion(-)

diff -puN drivers/net/smc911x.c~smc911x-introduce-platform-data-flags drivers/net/smc911x.c
--- a/drivers/net/smc911x.c~smc911x-introduce-platform-data-flags
+++ a/drivers/net/smc911x.c
@@ -1819,6 +1819,7 @@ static int __init smc911x_probe(struct n
 	int i, retval;
 	unsigned int val, chip_id, revision;
 	const char *version_string;
+	unsigned long irq_flags;
 
 	DBG(SMC_DEBUG_FUNC, "%s: --> %s\n", dev->name, __FUNCTION__);
 
@@ -1985,9 +1986,15 @@ static int __init smc911x_probe(struct n
 	lp->ctl_rfduplx = 1;
 	lp->ctl_rspeed = 100;
 
+#ifdef SMC_DYNAMIC_BUS_CONFIG
+	irq_flags = lp->cfg.irq_flags;
+#else
+	irq_flags = IRQF_SHARED | SMC_IRQ_SENSE;
+#endif
+
 	/* Grab the IRQ */
 	retval = request_irq(dev->irq, &smc911x_interrupt,
-			IRQF_SHARED | SMC_IRQ_SENSE, dev->name, dev);
+			     irq_flags, dev->name, dev);
 	if (retval)
 		goto err_out;
 
@@ -2057,6 +2064,7 @@ err_out:
  */
 static int smc911x_drv_probe(struct platform_device *pdev)
 {
+	struct smc91x_platdata *pd = pdev->dev.platform_data;
 	struct net_device *ndev;
 	struct resource *res;
 	struct smc911x_local *lp;
@@ -2090,6 +2098,13 @@ static int smc911x_drv_probe(struct plat
 	ndev->irq = platform_get_irq(pdev, 0);
 	lp = netdev_priv(ndev);
 	lp->netdev = ndev;
+#ifdef SMC_DYNAMIC_BUS_CONFIG
+	if (!pd) {
+		ret = -EINVAL;
+		goto release_both;
+	}
+	memcpy(&lp->cfg, pd, sizeof(lp->cfg));
+#endif
 
 	addr = ioremap(res->start, SMC911X_IO_EXTENT);
 	if (!addr) {
diff -puN drivers/net/smc911x.h~smc911x-introduce-platform-data-flags drivers/net/smc911x.h
--- a/drivers/net/smc911x.h~smc911x-introduce-platform-data-flags
+++ a/drivers/net/smc911x.h
@@ -29,6 +29,7 @@
 #ifndef _SMC911X_H_
 #define _SMC911X_H_
 
+#include <linux/smc911x.h>
 /*
  * Use the DMA feature on PXA chips
  */
@@ -42,6 +43,12 @@
   #define SMC_USE_16BIT		0
   #define SMC_USE_32BIT		1
   #define SMC_IRQ_SENSE		IRQF_TRIGGER_LOW
+#else
+/*
+ * Default configuration
+ */
+
+#define SMC_DYNAMIC_BUS_CONFIG
 #endif
 
 /* store this information for the driver.. */
@@ -92,12 +99,84 @@ struct smc911x_local {
 	struct device *dev;
 #endif
 	void __iomem *base;
+#ifdef SMC_DYNAMIC_BUS_CONFIG
+	struct smc911x_platdata cfg;
+#endif
 };
 
 /*
  * Define the bus width specific IO macros
  */
 
+#ifdef SMC_DYNAMIC_BUS_CONFIG
+static inline unsigned int SMC_inl(struct smc911x_local *lp, int reg)
+{
+	void __iomem *ioaddr = lp->base + reg;
+
+	if (lp->cfg.flags & SMC911X_USE_32BIT)
+		return readl(ioaddr);
+
+	if (lp->cfg.flags & SMC911X_USE_16BIT)
+		return readw(ioaddr) | (readw(ioaddr + 2) << 16);
+
+	BUG();
+}
+
+static inline void SMC_outl(unsigned int value, struct smc911x_local *lp,
+			    int reg)
+{
+	void __iomem *ioaddr = lp->base + reg;
+
+	if (lp->cfg.flags & SMC911X_USE_32BIT) {
+		writel(value, ioaddr);
+		return;
+	}
+
+	if (lp->cfg.flags & SMC911X_USE_16BIT) {
+		writew(value & 0xffff, ioaddr);
+		writew(value >> 16, ioaddr + 2);
+		return;
+	}
+
+	BUG();
+}
+
+static inline void SMC_insl(struct smc911x_local *lp, int reg,
+			      void *addr, unsigned int count)
+{
+	void __iomem *ioaddr = lp->base + reg;
+
+	if (lp->cfg.flags & SMC911X_USE_32BIT) {
+		readsl(ioaddr, addr, count);
+		return;
+	}
+
+	if (lp->cfg.flags & SMC911X_USE_16BIT) {
+		readsw(ioaddr, addr, count * 2);
+		return;
+	}
+
+	BUG();
+}
+
+static inline void SMC_outsl(struct smc911x_local *lp, int reg,
+			     void *addr, unsigned int count)
+{
+	void __iomem *ioaddr = lp->base + reg;
+
+	if (lp->cfg.flags & SMC911X_USE_32BIT) {
+		writesl(ioaddr, addr, count);
+		return;
+	}
+
+	if (lp->cfg.flags & SMC911X_USE_16BIT) {
+		writesw(ioaddr, addr, count * 2);
+		return;
+	}
+
+	BUG();
+}
+#else
 #if	SMC_USE_16BIT
 #define SMC_inl(lp, r)		 (readw((lp)->base + (r)) & 0xFFFF) + (readw((lp)->base + (r) + 2) << 16))
 #define SMC_outl(v, lp, r) 			 \
@@ -115,6 +194,8 @@ struct smc911x_local {
 #define SMC_outsl(lp, r, p, l)	 writesl((int*)((lp)->base + (r)), p, l)
 
 #endif /* SMC_USE_16BIT */
+#endif /* SMC_DYNAMIC_BUS_CONFIG */
+
 
 #ifdef SMC_USE_PXA_DMA
 #define SMC_USE_DMA
diff -puN /dev/null include/linux/smc911x.h
--- /dev/null
+++ a/include/linux/smc911x.h
@@ -0,0 +1,12 @@
+#ifndef __SMC911X_H__
+#define __SMC911X_H__
+
+#define SMC911X_USE_16BIT (1 << 0)
+#define SMC911X_USE_32BIT (1 << 1)
+
+struct smc911x_platdata {
+	unsigned long flags;
+	unsigned long irq_flags; /* IRQF_... */
+};
+
+#endif /* __SMC911X_H__ */
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

linux-next.patch
smc911x-remove-unused-8-bit-i-o-operations.patch
smc911x-fix-16-bit-i-o-operations.patch
smc911x-pass-along-private-data-and-use-iomem.patch
smc911x-introduce-platform-data-flags.patch
smc911x-superh-architecture-support.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch

