From: akpm@linux-foundation.org
Subject: - atmel_tc-library-update.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:23:48 -0800
Message-ID: <200803062223.m26MNn1t020916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211AbYCFWja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:39:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, linux@maxim.org.za, nicolas.ferre@rfo.atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_tc library (update)
has been removed from the -mm tree.  Its filename was
     atmel_tc-library-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_tc library (update)
From: David Brownell <david-b@pacbell.net>

  * Drop unneeded inclusion of <linux/mutex.h>
  * Support an arbitrary number of TC blocks
  * Return a struct with information about a TC block from
    atmel_tc_alloc() instead of using a combination of return values
    and "out" parameters.
  * ioremap() the I/O registers on allocation
  * Look up clocks and irqs for all channels
  * Add "name" parameter to atmel_tc_alloc() and use this when
    requesting the iomem resource.
  * Check if the platform provided the necessary resources at probe()
    time instead of when the TCB is allocated.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/atmel_tclib.c |  144 ++++++++++++++++++++++++-----------
 include/linux/atmel_tc.h   |   37 ++++++++
 2 files changed, 133 insertions(+), 48 deletions(-)

diff -puN drivers/misc/atmel_tclib.c~atmel_tc-library-update drivers/misc/atmel_tclib.c
--- a/drivers/misc/atmel_tclib.c~atmel_tc-library-update
+++ a/drivers/misc/atmel_tclib.c
@@ -1,9 +1,14 @@
+#include <linux/atmel_tc.h>
+#include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/mutex.h>
+#include <linux/io.h>
 #include <linux/ioport.h>
+#include <linux/kernel.h>
 #include <linux/platform_device.h>
-#include <linux/atmel_tc.h>
+
+/* Number of bytes to reserve for the iomem resource */
+#define ATMEL_TC_IOMEM_SIZE	256
 
 
 /*
@@ -24,75 +29,124 @@ EXPORT_SYMBOL(atmel_tc_divisors);
 
 #endif
 
-/* we "know" that there will be either one or two TC blocks */
-static struct platform_device *blocks[2];
-
+static DEFINE_SPINLOCK(tc_list_lock);
+static LIST_HEAD(tc_list);
 
 /**
  * atmel_tc_alloc - allocate a specified TC block
  * @block: which block to allocate
- * @iomem: used to return its IO memory resource
+ * @name: name to be associated with the iomem resource
  *
- * Caller allocates a block.  If it is available, its I/O space is requested
- * and returned through the iomem pointer, and the device node for the block
- * is returned.  When it is not available, NULL is returned.
- *
- * On some platforms, each TC channel has its own clocks and IRQs.  Drivers
- * should clk_get() and clk_enable() "t0_clk", "t1_clk, and "t2_clk".
- * In the same vein, they should platform_get_irq() for irqs 0, 1, and 2.
- * On other platforms, only irq 0 and "t0_clk" will be available; drivers
- * should handle with both configurations.
+ * Caller allocates a block.  If it is available, a pointer to a
+ * pre-initialized struct atmel_tc is returned. The caller can access
+ * the registers directly through the "regs" field.
  */
-struct platform_device *atmel_tc_alloc(unsigned block, struct resource **iomem)
+struct atmel_tc *atmel_tc_alloc(unsigned block, const char *name)
 {
-	struct platform_device	*tc;
+	struct atmel_tc		*tc;
+	struct platform_device	*pdev = NULL;
 	struct resource		*r;
 
-	if (block >= ARRAY_SIZE(blocks) || !iomem)
-		return NULL;
-
-	tc = blocks[block];
-	if (tc) {
-		r = platform_get_resource(tc, IORESOURCE_MEM, 0);
-		if (r)
-			r = request_mem_region(r->start, 256, NULL);
-		*iomem = r;
-		if (!r)
-			tc = NULL;
+	spin_lock(&tc_list_lock);
+	list_for_each_entry(tc, &tc_list, node) {
+		if (tc->pdev->id == block) {
+			pdev = tc->pdev;
+			break;
+		}
 	}
 
+	if (!pdev || tc->iomem)
+		goto fail;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	r = request_mem_region(r->start, ATMEL_TC_IOMEM_SIZE, name);
+	if (!r)
+		goto fail;
+
+	tc->regs = ioremap(r->start, ATMEL_TC_IOMEM_SIZE);
+	if (!tc->regs)
+		goto fail_ioremap;
+
+	tc->iomem = r;
+
+out:
+	spin_unlock(&tc_list_lock);
 	return tc;
+
+fail_ioremap:
+	release_resource(r);
+fail:
+	tc = NULL;
+	goto out;
 }
 EXPORT_SYMBOL_GPL(atmel_tc_alloc);
 
 /**
  * atmel_tc_free - release a specified TC block
- * @block: which block to release
+ * @tc: Timer/counter block that was returned by atmel_tc_alloc()
  *
- * This reverses the effect of atmel_tc_alloc(), invalidating the resource
- * returned by that routine and making the TC available to other drivers.
+ * This reverses the effect of atmel_tc_alloc(), unmapping the I/O
+ * registers, invalidating the resource returned by that routine and
+ * making the TC available to other drivers.
  */
-void atmel_tc_free(struct platform_device *tc)
+void atmel_tc_free(struct atmel_tc *tc)
 {
-	if (tc->id >= 0 && tc->id < ARRAY_SIZE(blocks)) {
-		struct resource		*r;
-
-		r = platform_get_resource(tc, IORESOURCE_MEM, 0);
-		release_mem_region(r->start, 256);
+	spin_lock(&tc_list_lock);
+	if (tc->regs) {
+		iounmap(tc->regs);
+		release_resource(tc->iomem);
+		tc->regs = NULL;
+		tc->iomem = NULL;
 	}
+	spin_unlock(&tc_list_lock);
 }
 EXPORT_SYMBOL_GPL(atmel_tc_free);
 
 static int __init tc_probe(struct platform_device *pdev)
 {
-	static char __initdata e2big[] =
-		KERN_ERR "tclib: can't record TC block %d\n";
-
-	if (pdev->id < 0 || pdev->id >= ARRAY_SIZE(blocks)) {
-		printk(e2big, pdev->id);
-		return -ENFILE;
+	struct atmel_tc *tc;
+	struct clk	*clk;
+	int		irq;
+
+	if (!platform_get_resource(pdev, IORESOURCE_MEM, 0))
+		return -EINVAL;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return -EINVAL;
+
+	tc = kzalloc(sizeof(struct atmel_tc), GFP_KERNEL);
+	if (!tc)
+		return -ENOMEM;
+
+	tc->pdev = pdev;
+
+	clk = clk_get(&pdev->dev, "t0_clk");
+	if (IS_ERR(clk)) {
+		kfree(tc);
+		return -EINVAL;
 	}
-	blocks[pdev->id] = pdev;
+
+	tc->clk[0] = clk;
+	tc->clk[1] = clk_get(&pdev->dev, "t1_clk");
+	if (IS_ERR(tc->clk[1]))
+		tc->clk[1] = clk;
+	tc->clk[2] = clk_get(&pdev->dev, "t2_clk");
+	if (IS_ERR(tc->clk[2]))
+		tc->clk[2] = clk;
+
+	tc->irq[0] = irq;
+	tc->irq[1] = platform_get_irq(pdev, 1);
+	if (tc->irq[1] < 0)
+		tc->irq[1] = irq;
+	tc->irq[2] = platform_get_irq(pdev, 2);
+	if (tc->irq[2] < 0)
+		tc->irq[2] = irq;
+
+	spin_lock(&tc_list_lock);
+	list_add_tail(&tc->node, &tc_list);
+	spin_unlock(&tc_list_lock);
+
 	return 0;
 }
 
diff -puN include/linux/atmel_tc.h~atmel_tc-library-update include/linux/atmel_tc.h
--- a/include/linux/atmel_tc.h~atmel_tc-library-update
+++ a/include/linux/atmel_tc.h
@@ -10,6 +10,9 @@
 #ifndef ATMEL_TC_H
 #define ATMEL_TC_H
 
+#include <linux/compiler.h>
+#include <linux/list.h>
+
 /*
  * Many 32-bit Atmel SOCs include one or more TC blocks, each of which holds
  * three general-purpose 16-bit timers.  These timers share one register bank.
@@ -27,9 +30,37 @@
  * timers.  Then they use clk_get() and platform_get_irq() to get clock and
  * IRQ resources.
  */
-extern struct platform_device *atmel_tc_alloc(unsigned block,
-		struct resource **iomem);
-extern void atmel_tc_free(struct platform_device *tc);
+
+struct clk;
+
+/**
+ * struct atmel_tc - information about a Timer/Counter Block
+ * @pdev: physical device
+ * @iomem: resource associated with the I/O register
+ * @regs: mapping through which the I/O registers can be accessed
+ * @irq: irq for each of the three channels
+ * @clk: internal clock source for each of the three channels
+ * @node: list node, for tclib internal use
+ *
+ * On some platforms, each TC channel has its own clocks and IRQs,
+ * while on others, all TC channels share the same clock and IRQ.
+ * Drivers should clk_enable() all the clocks they need even though
+ * all the entries in @clk may point to the same physical clock.
+ * Likewise, drivers should request irqs independently for each
+ * channel, but they must use IRQF_SHARED in case some of the entries
+ * in @irq are actually the same IRQ.
+ */
+struct atmel_tc {
+	struct platform_device	*pdev;
+	struct resource		*iomem;
+	void __iomem		*regs;
+	int			irq[3];
+	struct clk		*clk[3];
+	struct list_head	node;
+};
+
+extern struct atmel_tc *atmel_tc_alloc(unsigned block, const char *name);
+extern void atmel_tc_free(struct atmel_tc *tc);
 
 /* platform-specific ATMEL_TC_TIMER_CLOCKx divisors (0 means 32KiHz) */
 extern const u8 atmel_tc_divisors[5];
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
git-arm-master.patch
git-avr32.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
rtc-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

