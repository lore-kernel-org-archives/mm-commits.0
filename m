From: akpm@linux-foundation.org
Subject: [to-be-updated] hw_random-add-timeriomem-rng-driver.patch removed from -mm tree
Date: Mon, 09 Feb 2009 21:12:46 -0800
Message-ID: <200902100512.n1A5Ckwe031542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbZBJFOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 00:14:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@digriz.org.uk, herbert@gondor.apana.org.au, jbeulich@novell.com, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     hw_random: add timeriomem-rng driver
has been removed from the -mm tree.  Its filename was
     hw_random-add-timeriomem-rng-driver.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hw_random: add timeriomem-rng driver
From: Alexander Clouter <alex@digriz.org.uk>

Some hardware platforms, the TS-7800[1] is one for example, can supply the
kernel with an entropy source, albeit a slow one for TS-7800 users, by
just reading a particular IO address.  This source must not be read above
a certain rate otherwise the quality suffers.

The driver is then hooked into by calling
platform_device_(register|add|del) passing a structure similar to:

static struct timeriomem_rng_data ts78xx_ts_rng_data = {
        .address        = (u32 *__iomem) TS_RNG,
        .period         = 1000000, /* one second */
};

static struct platform_device ts78xx_ts_rng_device = {
        .name           = "timeriomem_rng",
        .id             = -1,
        .dev            = {
                .platform_data  = &ts78xx_ts_rng_data,
        },
        .num_resources  = 0,
};

[1] http://www.embeddedarm.com/products/board-detail.php?product=TS-7800

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/Kconfig          |   14 ++
 drivers/char/hw_random/Makefile         |    1 
 drivers/char/hw_random/timeriomem-rng.c |  151 ++++++++++++++++++++++
 include/linux/timeriomem-rng.h          |   16 ++
 4 files changed, 182 insertions(+)

diff -puN drivers/char/hw_random/Kconfig~hw_random-add-timeriomem-rng-driver drivers/char/hw_random/Kconfig
--- a/drivers/char/hw_random/Kconfig~hw_random-add-timeriomem-rng-driver
+++ a/drivers/char/hw_random/Kconfig
@@ -20,6 +20,20 @@ config HW_RANDOM
 
 	  If unsure, say Y.
 
+config HW_RANDOM_TIMERIOMEM
+	tristate "Timer IOMEM HW Random Number Generator support"
+	depends on HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for a generic Random
+	  Number Generator used by reading a 'dumb' iomem address that
+	  is to be read no faster than, for example, once a second;
+	  the default FPGA bitstream on the TS-7800 has such functionality.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called timeriomem-rng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_INTEL
 	tristate "Intel HW Random Number Generator support"
 	depends on HW_RANDOM && (X86 || IA64) && PCI
diff -puN drivers/char/hw_random/Makefile~hw_random-add-timeriomem-rng-driver drivers/char/hw_random/Makefile
--- a/drivers/char/hw_random/Makefile~hw_random-add-timeriomem-rng-driver
+++ a/drivers/char/hw_random/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_HW_RANDOM) += rng-core.o
 rng-core-y := core.o
+obj-$(CONFIG_HW_RANDOM_TIMERIOMEM) += timeriomem-rng.o
 obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
 obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
 obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
diff -puN /dev/null drivers/char/hw_random/timeriomem-rng.c
--- /dev/null
+++ a/drivers/char/hw_random/timeriomem-rng.c
@@ -0,0 +1,151 @@
+/*
+ * drivers/char/hw_random/timeriomem-rng.c
+ *
+ * Copyright (C) 2008 Alexander Clouter <alex@digriz.org.uk>
+ *
+ * Derived from drivers/char/hw_random/omap-rng.c
+ *   Copyright 2005 (c) MontaVista Software, Inc.
+ *   Author: Deepak Saxena <dsaxena@plexity.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Overview:
+ *   This driver is useful for platforms that have an IO range that provides
+ *   periodic random data from a single IO memory address.  All the platform
+ *   has to do is provide the address and 'wait time' that new data becomes
+ *   available.
+ *
+ * TODO: add support for reading sizes other than 32bits and masking
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/timeriomem-rng.h>
+#include <linux/jiffies.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+
+static struct timeriomem_rng_data *timeriomem_rng_data;
+
+static void timeriomem_rng_trigger(unsigned long);
+static DEFINE_TIMER(timeriomem_rng_timer, &timeriomem_rng_trigger, 0, 0);
+
+/*
+ * have data return 1, however return 0 if we have nothing
+ */
+static int timeriomem_rng_data_present(struct hwrng *rng, int wait)
+{
+	s32 delay;
+
+	if (rng->priv == 0)
+		return 1;
+
+	if (del_timer_sync(&timeriomem_rng_timer)) {
+		if (!wait)
+			return 0;
+
+		delay = timeriomem_rng_timer.expires - jiffies;
+
+		schedule_timeout_uninterruptible(delay);
+	}
+
+	return 1;
+}
+
+static int timeriomem_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	unsigned long cur;
+	s32 delay;
+
+	*data = readl(timeriomem_rng_data->address);
+
+	if (rng->priv != 0) {
+		cur = jiffies;
+
+		delay = cur - timeriomem_rng_timer.expires;
+		delay = rng->priv - (delay % rng->priv);
+
+		timeriomem_rng_timer.expires = cur + delay;
+		add_timer(&timeriomem_rng_timer);
+	}
+
+	return 4;
+}
+
+static void timeriomem_rng_trigger(unsigned long dummy)
+{
+	del_timer_sync(&timeriomem_rng_timer);
+}
+
+static struct hwrng timeriomem_rng_ops = {
+	.name		= "timeriomem",
+	.data_present	= timeriomem_rng_data_present,
+	.data_read	= timeriomem_rng_data_read,
+	.priv		= 0,
+};
+
+static int __init timeriomem_rng_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	timeriomem_rng_data = pdev->dev.platform_data;
+
+	if (timeriomem_rng_data->period != 0
+		&& usecs_to_jiffies(timeriomem_rng_data->period) > 0) {
+		timeriomem_rng_timer.expires = jiffies;
+
+		timeriomem_rng_ops.priv = usecs_to_jiffies(
+						timeriomem_rng_data->period);
+	}
+
+	ret = hwrng_register(&timeriomem_rng_ops);
+	if (ret) {
+		dev_err(&pdev->dev, "problem registering\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "32bits from 0x%p @ %dus\n",
+			timeriomem_rng_data->address,
+			timeriomem_rng_data->period);
+
+	return 0;
+}
+
+static int __devexit timeriomem_rng_remove(struct platform_device *pdev)
+{
+	del_timer_sync(&timeriomem_rng_timer);
+	hwrng_unregister(&timeriomem_rng_ops);
+
+	return 0;
+}
+
+static struct platform_driver timeriomem_rng_driver = {
+	.driver = {
+		.name		= "timeriomem_rng",
+		.owner		= THIS_MODULE,
+	},
+	.probe		= timeriomem_rng_probe,
+	.remove		= __devexit_p(timeriomem_rng_remove),
+};
+
+static int __init timeriomem_rng_init(void)
+{
+	return platform_driver_register(&timeriomem_rng_driver);
+}
+
+static void __exit timeriomem_rng_exit(void)
+{
+	platform_driver_unregister(&timeriomem_rng_driver);
+}
+
+module_init(timeriomem_rng_init);
+module_exit(timeriomem_rng_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Alexander Clouter <alex@digriz.org.uk>");
+MODULE_DESCRIPTION("Timer IOMEM H/W RNG driver");
diff -puN /dev/null include/linux/timeriomem-rng.h
--- /dev/null
+++ a/include/linux/timeriomem-rng.h
@@ -0,0 +1,16 @@
+/*
+ * linux/include/linux/timeriomem-rng.h
+ *
+ * Copyright (c) 2008 Alexander Clouter <alex@digriz.org.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+struct timeriomem_rng_data {
+	u32 __iomem	*address;
+
+	/* measures in usecs */
+	unsigned int	period;
+};
_

Patches currently in -mm which might be from alex@digriz.org.uk are

hw_random-add-timeriomem-rng-driver.patch

