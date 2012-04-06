From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:47:38 -0700
Message-ID: <20120406184740.044D9A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:37516 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298Ab2DFSrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:47:43 -0400
Received: by laai8 with SMTP id i8so128127laa.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:47:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/fsl/imx-audmux.c |    8 
 sound/soc/imx/imx-audmux.c |  308 -----------------------------------
 2 files changed, 1 insertion(+), 315 deletions(-)

diff -puN sound/soc/fsl/imx-audmux.c~linux-next-rejects sound/soc/fsl/imx-audmux.c
--- a/sound/soc/fsl/imx-audmux.c~linux-next-rejects
+++ a/sound/soc/fsl/imx-audmux.c
@@ -40,12 +40,6 @@ static void __iomem *audmux_base;
 #ifdef CONFIG_DEBUG_FS
 static struct dentry *audmux_debugfs_root;
 
-static int audmux_open_file(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 /* There is an annoying discontinuity in the SSI numbering with regard
  * to the Linux number of the devices */
 static const char *audmux_port_string(int port)
@@ -142,7 +136,7 @@ static ssize_t audmux_read_file(struct f
 }
 
 static const struct file_operations audmux_debugfs_fops = {
-	.open = audmux_open_file,
+	.open = simple_open,
 	.read = audmux_read_file,
 	.llseek = default_llseek,
 };
diff -puN sound/soc/imx/imx-audmux.c~linux-next-rejects /dev/null
--- a/sound/soc/imx/imx-audmux.c
+++ /dev/null
@@ -1,308 +0,0 @@
-/*
- * Copyright 2012 Freescale Semiconductor, Inc.
- * Copyright 2012 Linaro Ltd.
- * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
- *
- * Initial development of this code was funded by
- * Phytec Messtechnik GmbH, http://www.phytec.de
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/clk.h>
-#include <linux/debugfs.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-
-#include "imx-audmux.h"
-
-#define DRIVER_NAME "imx-audmux"
-
-static struct clk *audmux_clk;
-static void __iomem *audmux_base;
-
-#define IMX_AUDMUX_V2_PTCR(x)		((x) * 8)
-#define IMX_AUDMUX_V2_PDCR(x)		((x) * 8 + 4)
-
-#ifdef CONFIG_DEBUG_FS
-static struct dentry *audmux_debugfs_root;
-
-/* There is an annoying discontinuity in the SSI numbering with regard
- * to the Linux number of the devices */
-static const char *audmux_port_string(int port)
-{
-	switch (port) {
-	case MX31_AUDMUX_PORT1_SSI0:
-		return "imx-ssi.0";
-	case MX31_AUDMUX_PORT2_SSI1:
-		return "imx-ssi.1";
-	case MX31_AUDMUX_PORT3_SSI_PINS_3:
-		return "SSI3";
-	case MX31_AUDMUX_PORT4_SSI_PINS_4:
-		return "SSI4";
-	case MX31_AUDMUX_PORT5_SSI_PINS_5:
-		return "SSI5";
-	case MX31_AUDMUX_PORT6_SSI_PINS_6:
-		return "SSI6";
-	default:
-		return "UNKNOWN";
-	}
-}
-
-static ssize_t audmux_read_file(struct file *file, char __user *user_buf,
-				size_t count, loff_t *ppos)
-{
-	ssize_t ret;
-	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	int port = (int)file->private_data;
-	u32 pdcr, ptcr;
-
-	if (!buf)
-		return -ENOMEM;
-
-	if (audmux_clk)
-		clk_prepare_enable(audmux_clk);
-
-	ptcr = readl(audmux_base + IMX_AUDMUX_V2_PTCR(port));
-	pdcr = readl(audmux_base + IMX_AUDMUX_V2_PDCR(port));
-
-	if (audmux_clk)
-		clk_disable_unprepare(audmux_clk);
-
-	ret = snprintf(buf, PAGE_SIZE, "PDCR: %08x\nPTCR: %08x\n",
-		       pdcr, ptcr);
-
-	if (ptcr & IMX_AUDMUX_V2_PTCR_TFSDIR)
-		ret += snprintf(buf + ret, PAGE_SIZE - ret,
-				"TxFS output from %s, ",
-				audmux_port_string((ptcr >> 27) & 0x7));
-	else
-		ret += snprintf(buf + ret, PAGE_SIZE - ret,
-				"TxFS input, ");
-
-	if (ptcr & IMX_AUDMUX_V2_PTCR_TCLKDIR)
-		ret += snprintf(buf + ret, PAGE_SIZE - ret,
-				"TxClk output from %s",
-				audmux_port_string((ptcr >> 22) & 0x7));
-	else
-		ret += snprintf(buf + ret, PAGE_SIZE - ret,
-				"TxClk input");
-
-	ret += snprintf(buf + ret, PAGE_SIZE - ret, "\n");
-
-	if (ptcr & IMX_AUDMUX_V2_PTCR_SYN) {
-		ret += snprintf(buf + ret, PAGE_SIZE - ret,
-				"Port is symmetric");
-	} else {
-		if (ptcr & IMX_AUDMUX_V2_PTCR_RFSDIR)
-			ret += snprintf(buf + ret, PAGE_SIZE - ret,
-					"RxFS output from %s, ",
-					audmux_port_string((ptcr >> 17) & 0x7));
-		else
-			ret += snprintf(buf + ret, PAGE_SIZE - ret,
-					"RxFS input, ");
-
-		if (ptcr & IMX_AUDMUX_V2_PTCR_RCLKDIR)
-			ret += snprintf(buf + ret, PAGE_SIZE - ret,
-					"RxClk output from %s",
-					audmux_port_string((ptcr >> 12) & 0x7));
-		else
-			ret += snprintf(buf + ret, PAGE_SIZE - ret,
-					"RxClk input");
-	}
-
-	ret += snprintf(buf + ret, PAGE_SIZE - ret,
-			"\nData received from %s\n",
-			audmux_port_string((pdcr >> 13) & 0x7));
-
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
-
-	kfree(buf);
-
-	return ret;
-}
-
-static const struct file_operations audmux_debugfs_fops = {
-	.open = simple_open,
-	.read = audmux_read_file,
-	.llseek = default_llseek,
-};
-
-static void __init audmux_debugfs_init(void)
-{
-	int i;
-	char buf[20];
-
-	audmux_debugfs_root = debugfs_create_dir("audmux", NULL);
-	if (!audmux_debugfs_root) {
-		pr_warning("Failed to create AUDMUX debugfs root\n");
-		return;
-	}
-
-	for (i = 1; i < 8; i++) {
-		snprintf(buf, sizeof(buf), "ssi%d", i);
-		if (!debugfs_create_file(buf, 0444, audmux_debugfs_root,
-					 (void *)i, &audmux_debugfs_fops))
-			pr_warning("Failed to create AUDMUX port %d debugfs file\n",
-				   i);
-	}
-}
-
-static void __devexit audmux_debugfs_remove(void)
-{
-	debugfs_remove_recursive(audmux_debugfs_root);
-}
-#else
-static inline void audmux_debugfs_init(void)
-{
-}
-
-static inline void audmux_debugfs_remove(void)
-{
-}
-#endif
-
-enum imx_audmux_type {
-	IMX21_AUDMUX,
-	IMX31_AUDMUX,
-} audmux_type;
-
-static struct platform_device_id imx_audmux_ids[] = {
-	{
-		.name = "imx21-audmux",
-		.driver_data = IMX21_AUDMUX,
-	}, {
-		.name = "imx31-audmux",
-		.driver_data = IMX31_AUDMUX,
-	}, {
-		/* sentinel */
-	}
-};
-MODULE_DEVICE_TABLE(platform, imx_audmux_ids);
-
-static const struct of_device_id imx_audmux_dt_ids[] = {
-	{ .compatible = "fsl,imx21-audmux", .data = &imx_audmux_ids[0], },
-	{ .compatible = "fsl,imx31-audmux", .data = &imx_audmux_ids[1], },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, imx_audmux_dt_ids);
-
-static const uint8_t port_mapping[] = {
-	0x0, 0x4, 0x8, 0x10, 0x14, 0x1c,
-};
-
-int imx_audmux_v1_configure_port(unsigned int port, unsigned int pcr)
-{
-	if (audmux_type != IMX21_AUDMUX)
-		return -EINVAL;
-
-	if (!audmux_base)
-		return -ENOSYS;
-
-	if (port >= ARRAY_SIZE(port_mapping))
-		return -EINVAL;
-
-	writel(pcr, audmux_base + port_mapping[port]);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(imx_audmux_v1_configure_port);
-
-int imx_audmux_v2_configure_port(unsigned int port, unsigned int ptcr,
-		unsigned int pdcr)
-{
-	if (audmux_type != IMX31_AUDMUX)
-		return -EINVAL;
-
-	if (!audmux_base)
-		return -ENOSYS;
-
-	if (audmux_clk)
-		clk_prepare_enable(audmux_clk);
-
-	writel(ptcr, audmux_base + IMX_AUDMUX_V2_PTCR(port));
-	writel(pdcr, audmux_base + IMX_AUDMUX_V2_PDCR(port));
-
-	if (audmux_clk)
-		clk_disable_unprepare(audmux_clk);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(imx_audmux_v2_configure_port);
-
-static int __devinit imx_audmux_probe(struct platform_device *pdev)
-{
-	struct resource *res;
-	const struct of_device_id *of_id =
-			of_match_device(imx_audmux_dt_ids, &pdev->dev);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	audmux_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!audmux_base)
-		return -EADDRNOTAVAIL;
-
-	audmux_clk = clk_get(&pdev->dev, "audmux");
-	if (IS_ERR(audmux_clk)) {
-		dev_dbg(&pdev->dev, "cannot get clock: %ld\n",
-				PTR_ERR(audmux_clk));
-		audmux_clk = NULL;
-	}
-
-	if (of_id)
-		pdev->id_entry = of_id->data;
-	audmux_type = pdev->id_entry->driver_data;
-	if (audmux_type == IMX31_AUDMUX)
-		audmux_debugfs_init();
-
-	return 0;
-}
-
-static int __devexit imx_audmux_remove(struct platform_device *pdev)
-{
-	if (audmux_type == IMX31_AUDMUX)
-		audmux_debugfs_remove();
-	clk_put(audmux_clk);
-
-	return 0;
-}
-
-static struct platform_driver imx_audmux_driver = {
-	.probe		= imx_audmux_probe,
-	.remove		= __devexit_p(imx_audmux_remove),
-	.id_table	= imx_audmux_ids,
-	.driver	= {
-		.name	= DRIVER_NAME,
-		.owner	= THIS_MODULE,
-		.of_match_table = imx_audmux_dt_ids,
-	}
-};
-
-static int __init imx_audmux_init(void)
-{
-	return platform_driver_register(&imx_audmux_driver);
-}
-subsys_initcall(imx_audmux_init);
-
-static void __exit imx_audmux_exit(void)
-{
-	platform_driver_unregister(&imx_audmux_driver);
-}
-module_exit(imx_audmux_exit);
-
-MODULE_DESCRIPTION("Freescale i.MX AUDMUX driver");
-MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:" DRIVER_NAME);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-fix-2.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

