From: akpm@linux-foundation.org
Subject: + hw_random-add-hardware-rng-for-octeon-socs.patch added to -mm tree
Date: Thu, 20 Aug 2009 16:29:36 -0700
Message-ID: <200908202329.n7KNTbNM004448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596AbZHTXaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 19:30:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ddaney@caviumnetworks.com, herbert@gondor.apana.org.au, mpm@selenic.com, ralf@linux-mips.org


The patch titled
     hw_random: add hardware RNG for Octeon SOCs
has been added to the -mm tree.  Its filename is
     hw_random-add-hardware-rng-for-octeon-socs.patch

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
Subject: hw_random: add hardware RNG for Octeon SOCs
From: David Daney <ddaney@caviumnetworks.com>

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/Kconfig      |   13 ++
 drivers/char/hw_random/Makefile     |    1 
 drivers/char/hw_random/octeon-rng.c |  147 ++++++++++++++++++++++++++
 3 files changed, 161 insertions(+)

diff -puN drivers/char/hw_random/Kconfig~hw_random-add-hardware-rng-for-octeon-socs drivers/char/hw_random/Kconfig
--- a/drivers/char/hw_random/Kconfig~hw_random-add-hardware-rng-for-octeon-socs
+++ a/drivers/char/hw_random/Kconfig
@@ -126,6 +126,19 @@ config HW_RANDOM_OMAP
 
  	  If unsure, say Y.
 
+config HW_RANDOM_OCTEON
+	tristate "Octeon Random Number Generator support"
+	depends on HW_RANDOM && CPU_CAVIUM_OCTEON
+	default HW_RANDOM
+ 	---help---
+ 	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on Octeon processors.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called octeon-rng.
+
+ 	  If unsure, say Y.
+
 config HW_RANDOM_PASEMI
 	tristate "PA Semi HW Random Number Generator support"
 	depends on HW_RANDOM && PPC_PASEMI
diff -puN drivers/char/hw_random/Makefile~hw_random-add-hardware-rng-for-octeon-socs drivers/char/hw_random/Makefile
--- a/drivers/char/hw_random/Makefile~hw_random-add-hardware-rng-for-octeon-socs
+++ a/drivers/char/hw_random/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_HW_RANDOM_PASEMI) += pasemi
 obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
 obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
 obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
+obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
diff -puN /dev/null drivers/char/hw_random/octeon-rng.c
--- /dev/null
+++ a/drivers/char/hw_random/octeon-rng.c
@@ -0,0 +1,147 @@
+/*
+ * Hardware Random Number Generator support for Cavium Networks
+ * Octeon processor family.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2009 Cavium Networks
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+
+#include <asm/octeon/octeon.h>
+#include <asm/octeon/cvmx-rnm-defs.h>
+
+struct octeon_rng {
+	struct hwrng ops;
+	void __iomem *control_status;
+	void __iomem *result;
+};
+
+static int octeon_rng_init(struct hwrng *rng)
+{
+	union cvmx_rnm_ctl_status ctl;
+	struct octeon_rng *p = container_of(rng, struct octeon_rng, ops);
+
+	ctl.u64 = 0;
+	ctl.s.ent_en = 1; /* Enable the entropy source.  */
+	ctl.s.rng_en = 1; /* Enable the RNG hardware.  */
+	cvmx_write_csr((u64)p->control_status, ctl.u64);
+	return 0;
+}
+
+static void octeon_rng_cleanup(struct hwrng *rng)
+{
+	union cvmx_rnm_ctl_status ctl;
+	struct octeon_rng *p = container_of(rng, struct octeon_rng, ops);
+
+	ctl.u64 = 0;
+	/* Disable everything.  */
+	cvmx_write_csr((u64)p->control_status, ctl.u64);
+}
+
+static int octeon_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	struct octeon_rng *p = container_of(rng, struct octeon_rng, ops);
+
+	*data = cvmx_read64_uint32((u64)p->result);
+	return sizeof(u32);
+}
+
+static int __devinit octeon_rng_probe(struct platform_device *pdev)
+{
+	struct resource *res_ports;
+	struct resource *res_result;
+	struct octeon_rng *rng;
+	int ret;
+	struct hwrng ops = {
+		.name = "octeon",
+		.init = octeon_rng_init,
+		.cleanup = octeon_rng_cleanup,
+		.data_read = octeon_rng_data_read
+	};
+
+	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
+	if (!rng)
+		return -ENOMEM;
+
+	res_ports = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res_ports)
+		goto err_ports;
+
+	res_result = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res_result)
+		goto err_ports;
+
+
+	rng->control_status = devm_ioremap_nocache(&pdev->dev,
+						   res_ports->start,
+						   sizeof(u64));
+	if (!rng->control_status)
+		goto err_ports;
+
+	rng->result = devm_ioremap_nocache(&pdev->dev,
+					   res_result->start,
+					   sizeof(u64));
+	if (!rng->result)
+		goto err_r;
+
+	rng->ops = ops;
+
+	dev_set_drvdata(&pdev->dev, &rng->ops);
+	ret = hwrng_register(&rng->ops);
+	if (ret)
+		goto err;
+
+	dev_info(&pdev->dev, "Octeon Random Number Generator\n");
+
+	return 0;
+err:
+	devm_iounmap(&pdev->dev, rng->control_status);
+err_r:
+	devm_iounmap(&pdev->dev, rng->result);
+err_ports:
+	devm_kfree(&pdev->dev, rng);
+	return -ENOENT;
+}
+
+static int __exit octeon_rng_remove(struct platform_device *pdev)
+{
+	struct hwrng *rng = dev_get_drvdata(&pdev->dev);
+
+	hwrng_unregister(rng);
+
+	return 0;
+}
+
+static struct platform_driver octeon_rng_driver = {
+	.driver = {
+		.name		= "octeon_rng",
+		.owner		= THIS_MODULE,
+	},
+	.probe		= octeon_rng_probe,
+	.remove		= __exit_p(octeon_rng_remove),
+};
+
+static int __init octeon_rng_mod_init(void)
+{
+	return platform_driver_register(&octeon_rng_driver);
+}
+
+static void __exit octeon_rng_mod_exit(void)
+{
+	platform_driver_unregister(&octeon_rng_driver);
+}
+
+module_init(octeon_rng_mod_init);
+module_exit(octeon_rng_mod_exit);
+
+MODULE_AUTHOR("David Daney");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from ddaney@caviumnetworks.com are

origin.patch
mips-octeon-add-hardware-rng-platform-device.patch
hw_random-add-hardware-rng-for-octeon-socs.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

