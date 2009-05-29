From: akpm@linux-foundation.org
Subject: + hwrng-add-tx4939-rng-driver.patch added to -mm tree
Date: Fri, 29 May 2009 16:29:52 -0700
Message-ID: <200905292329.n4TNTqLE019340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbZE2XbQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 19:31:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, herbert@gondor.apana.org.au, mpm@selenic.com, ralf@linux-mips.org


The patch titled
     hwrng: add TX4939 RNG driver
has been added to the -mm tree.  Its filename is
     hwrng-add-tx4939-rng-driver.patch

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
Subject: hwrng: add TX4939 RNG driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add support for the integrated RNG of the TX4939 SoC.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/Kconfig      |   13 ++
 drivers/char/hw_random/Makefile     |    1 
 drivers/char/hw_random/tx4939-rng.c |  157 ++++++++++++++++++++++++++
 3 files changed, 171 insertions(+)

diff -puN drivers/char/hw_random/Kconfig~hwrng-add-tx4939-rng-driver drivers/char/hw_random/Kconfig
--- a/drivers/char/hw_random/Kconfig~hwrng-add-tx4939-rng-driver
+++ a/drivers/char/hw_random/Kconfig
@@ -139,6 +139,19 @@ config HW_RANDOM_PASEMI
 
 	  If unsure, say Y.
 
+config HW_RANDOM_TX4939
+	tristate "TX4939 Random Number Generator support"
+	depends on HW_RANDOM && SOC_TX4939
+	default HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on TX4939 SoC.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tx4939-rng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_VIRTIO
 	tristate "VirtIO Random Number Generator support"
 	depends on HW_RANDOM && VIRTIO
diff -puN drivers/char/hw_random/Makefile~hwrng-add-tx4939-rng-driver drivers/char/hw_random/Makefile
--- a/drivers/char/hw_random/Makefile~hwrng-add-tx4939-rng-driver
+++ a/drivers/char/hw_random/Makefile
@@ -14,5 +14,6 @@ obj-$(CONFIG_HW_RANDOM_VIA) += via-rng.o
 obj-$(CONFIG_HW_RANDOM_IXP4XX) += ixp4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_OMAP) += omap-rng.o
 obj-$(CONFIG_HW_RANDOM_PASEMI) += pasemi-rng.o
+obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
 obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
 obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
diff -puN /dev/null drivers/char/hw_random/tx4939-rng.c
--- /dev/null
+++ a/drivers/char/hw_random/tx4939-rng.c
@@ -0,0 +1,157 @@
+/*
+ * RNG driver for TX4939 Random Number Generators (RNG)
+ *
+ * Copyright (C) 2009 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/hw_random.h>
+
+#define TX4939_RNG_RCSR		0x00000000
+#define TX4939_RNG_ROR(n)	(0x00000018 + (n) * 8)
+
+#define TX4939_RNG_RCSR_INTE	0x00000008
+#define TX4939_RNG_RCSR_RST	0x00000004
+#define TX4939_RNG_RCSR_FIN	0x00000002
+#define TX4939_RNG_RCSR_ST	0x00000001
+
+struct tx4939_rng {
+	struct hwrng rng;
+	void __iomem *base;
+	u64 databuf[3];
+	unsigned int data_avail;
+};
+
+static u64 read_rng(void __iomem *base, unsigned int offset)
+{
+	/* Caller must disable interrupts */
+	return ____raw_readq(base + offset);
+}
+
+static void write_rng(u64 val, void __iomem *base, unsigned int offset)
+{
+	return ____raw_writeq(val, base + offset);
+}
+
+static int tx4939_rng_data_present(struct hwrng *rng, int wait)
+{
+	struct tx4939_rng *rngdev = container_of(rng, struct tx4939_rng, rng);
+	int i;
+
+	if (rngdev->data_avail)
+		return rngdev->data_avail;
+	for (i = 0; i < 20; i++) {
+		local_irq_disable();
+		if (!(read_rng(rngdev->base, TX4939_RNG_RCSR)
+		      & TX4939_RNG_RCSR_ST)) {
+			rngdev->databuf[0] =
+				read_rng(rngdev->base, TX4939_RNG_ROR(0));
+			rngdev->databuf[1] =
+				read_rng(rngdev->base, TX4939_RNG_ROR(1));
+			rngdev->databuf[2] =
+				read_rng(rngdev->base, TX4939_RNG_ROR(2));
+			rngdev->data_avail =
+				sizeof(rngdev->databuf) / sizeof(u32);
+			/* Start RNG */
+			write_rng(TX4939_RNG_RCSR_ST,
+				  rngdev->base, TX4939_RNG_RCSR);
+			wait = 0;
+		}
+		local_irq_enable();
+		if (!wait)
+			break;
+		udelay(1);
+	}
+	return rngdev->data_avail;
+}
+
+static int tx4939_rng_data_read(struct hwrng *rng, u32 *buffer)
+{
+	struct tx4939_rng *rngdev = container_of(rng, struct tx4939_rng, rng);
+
+	rngdev->data_avail--;
+	*buffer = *((u32 *)&rngdev->databuf + rngdev->data_avail);
+	return sizeof(u32);
+}
+
+static int __init tx4939_rng_probe(struct platform_device *dev)
+{
+	struct tx4939_rng *rngdev;
+	struct resource *r;
+	int i;
+
+	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -EBUSY;
+	rngdev = devm_kzalloc(&dev->dev, sizeof(*rngdev), GFP_KERNEL);
+	if (!rngdev)
+		return -ENOMEM;
+	if (!devm_request_mem_region(&dev->dev, r->start, resource_size(r),
+				     dev_name(&dev->dev)))
+		return -EBUSY;
+	rngdev->base = devm_ioremap(&dev->dev, r->start, resource_size(r));
+	if (!rngdev->base)
+		return -EBUSY;
+
+	rngdev->rng.name = dev_name(&dev->dev);
+	rngdev->rng.data_present = tx4939_rng_data_present;
+	rngdev->rng.data_read = tx4939_rng_data_read;
+
+	local_irq_disable();
+	/* Reset RNG */
+	write_rng(TX4939_RNG_RCSR_RST, rngdev->base, TX4939_RNG_RCSR);
+	write_rng(0, rngdev->base, TX4939_RNG_RCSR);
+	/* Start RNG */
+	write_rng(TX4939_RNG_RCSR_ST, rngdev->base, TX4939_RNG_RCSR);
+	local_irq_enable();
+	/* drop first two results */
+	for (i = 0; i < 2; i++) {
+		rngdev->data_avail = 0;
+		if (!tx4939_rng_data_present(&rngdev->rng, 1))
+			return -EIO;
+	}
+
+	platform_set_drvdata(dev, rngdev);
+	return hwrng_register(&rngdev->rng);
+}
+
+static int __exit tx4939_rng_remove(struct platform_device *dev)
+{
+	struct tx4939_rng *rngdev = platform_get_drvdata(dev);
+
+	hwrng_unregister(&rngdev->rng);
+	platform_set_drvdata(dev, NULL);
+	return 0;
+}
+
+static struct platform_driver tx4939_rng_driver = {
+	.driver		= {
+		.name	= "tx4939-rng",
+		.owner	= THIS_MODULE,
+	},
+	.remove = tx4939_rng_remove,
+};
+
+static int __init tx4939_rng_init(void)
+{
+	return platform_driver_probe(&tx4939_rng_driver, tx4939_rng_probe);
+}
+
+static void __exit tx4939_rng_exit(void)
+{
+	platform_driver_unregister(&tx4939_rng_driver);
+}
+
+module_init(tx4939_rng_init);
+module_exit(tx4939_rng_exit);
+
+MODULE_DESCRIPTION("H/W Random Number Generator (RNG) driver for TX4939");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set.patch
hwrng-add-tx4939-rng-driver.patch
mips-txx9-add-tx4939-rng-support.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
rtc-rtc-ds1742-nvram-attribute-fix.patch
rtc-tx4939-drop-irqf_shared.patch
rtc-ds1553-drop-irqf_shared.patch
rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2.patch

