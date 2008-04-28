From: akpm@linux-foundation.org
Subject: - powerpc-add-diu-platform-code-for-mpc8610hpcd.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:20 -0700
Message-ID: <200804282159.m3SLxKXG018574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965453AbYD1V73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yorksun@freescale.com, adaplas@pol.net, benh@kernel.crashing.org, paulus@samba.org, timur@freescale.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: Add DIU platform code for MPC8610HPCD
has been removed from the -mm tree.  Its filename was
     powerpc-add-diu-platform-code-for-mpc8610hpcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: Add DIU platform code for MPC8610HPCD
From: York Sun <yorksun@freescale.com>

Add platform code to support Freescale DIU.  The platform code includes
framebuffer memory allocation, pixel format, monitor port, etc.

Signed-off-by: York Sun <yorksun@freescale.com>
Signed-off-by: Timur Tabi <timur@freescale.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/86xx/mpc8610_hpcd.c |  190 ++++++++++++++++++-
 arch/powerpc/sysdev/fsl_soc.c              |   41 ++++
 arch/powerpc/sysdev/fsl_soc.h              |   23 ++
 3 files changed, 245 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/platforms/86xx/mpc8610_hpcd.c~powerpc-add-diu-platform-code-for-mpc8610hpcd arch/powerpc/platforms/86xx/mpc8610_hpcd.c
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c~powerpc-add-diu-platform-code-for-mpc8610hpcd
+++ a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -3,11 +3,12 @@
  *
  * Initial author: Xianghua Xiao <x.xiao@freescale.com>
  * Recode: Jason Jin <jason.jin@freescale.com>
+ *         York Sun <yorksun@freescale.com>
  *
  * Rewrite the interrupt routing. remove the 8259PIC support,
  * All the integrated device in ULI use sideband interrupt.
  *
- * Copyright 2007 Freescale Semiconductor Inc.
+ * Copyright 2008 Freescale Semiconductor Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -38,6 +39,8 @@
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
 
+static unsigned char *pixis_bdcfg0, *pixis_arch;
+
 static struct of_device_id __initdata mpc8610_ids[] = {
 	{ .compatible = "fsl,mpc8610-immr", },
 	{}
@@ -52,8 +55,7 @@ static int __init mpc8610_declare_of_pla
 }
 machine_device_initcall(mpc86xx_hpcd, mpc8610_declare_of_platform_devices);
 
-static void __init
-mpc86xx_hpcd_init_irq(void)
+static void __init mpc86xx_hpcd_init_irq(void)
 {
 	struct mpic *mpic1;
 	struct device_node *np;
@@ -161,12 +163,159 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, 0x5288, final_uli5288);
 #endif /* CONFIG_PCI */
 
-static void __init
-mpc86xx_hpcd_setup_arch(void)
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
+
+static u32 get_busfreq(void)
 {
-#ifdef CONFIG_PCI
-	struct device_node *np;
+	struct device_node *node;
+
+	u32 fs_busfreq = 0;
+	node = of_find_node_by_type(NULL, "cpu");
+	if (node) {
+		unsigned int size;
+		const unsigned int *prop =
+			of_get_property(node, "bus-frequency", &size);
+		if (prop)
+			fs_busfreq = *prop;
+		of_node_put(node);
+	};
+	return fs_busfreq;
+}
+
+unsigned int mpc8610hpcd_get_pixel_format(unsigned int bits_per_pixel,
+						int monitor_port)
+{
+	static const unsigned long pixelformat[][3] = {
+		{0x88882317, 0x88083218, 0x65052119},
+		{0x88883316, 0x88082219, 0x65053118},
+	};
+	unsigned int pix_fmt, arch_monitor;
+
+	arch_monitor = ((*pixis_arch == 0x01) && (monitor_port == 0))? 0 : 1;
+		/* DVI port for board version 0x01 */
+
+	if (bits_per_pixel == 32)
+		pix_fmt = pixelformat[arch_monitor][0];
+	else if (bits_per_pixel == 24)
+		pix_fmt = pixelformat[arch_monitor][1];
+	else if (bits_per_pixel == 16)
+		pix_fmt = pixelformat[arch_monitor][2];
+	else
+		pix_fmt = pixelformat[1][0];
+
+	return pix_fmt;
+}
+
+void mpc8610hpcd_set_gamma_table(int monitor_port, char *gamma_table_base)
+{
+	int i;
+	if (monitor_port == 2) {		/* dual link LVDS */
+		for (i = 0; i < 256*3; i++)
+			gamma_table_base[i] = (gamma_table_base[i] << 2) |
+					 ((gamma_table_base[i] >> 6) & 0x03);
+	}
+}
+
+void mpc8610hpcd_set_monitor_port(int monitor_port)
+{
+	static const u8 bdcfg[] = {0xBD, 0xB5, 0xA5};
+	if (monitor_port < 3)
+		*pixis_bdcfg0 = bdcfg[monitor_port];
+}
+
+void mpc8610hpcd_set_pixel_clock(unsigned int pixclock)
+{
+	u32 __iomem *clkdvdr;
+	u32 temp;
+	/* variables for pixel clock calcs */
+	ulong  bestval, bestfreq, speed_ccb, minpixclock, maxpixclock;
+	ulong pixval;
+	long err;
+	int i;
+
+	clkdvdr = ioremap(get_immrbase() + 0xe0800, sizeof(u32));
+	if (!clkdvdr) {
+		printk(KERN_ERR "Err: can't map clock divider register!\n");
+		return;
+	}
+
+	/* Pixel Clock configuration */
+	pr_debug("DIU: Bus Frequency = %d\n", get_busfreq());
+	speed_ccb = get_busfreq();
+
+	/* Calculate the pixel clock with the smallest error */
+	/* calculate the following in steps to avoid overflow */
+	pr_debug("DIU pixclock in ps - %d\n", pixclock);
+	temp = 1000000000/pixclock;
+	temp *= 1000;
+	pixclock = temp;
+	pr_debug("DIU pixclock freq - %u\n", pixclock);
+
+	temp = pixclock * 5 / 100;
+	pr_debug("deviation = %d\n", temp);
+	minpixclock = pixclock - temp;
+	maxpixclock = pixclock + temp;
+	pr_debug("DIU minpixclock - %lu\n", minpixclock);
+	pr_debug("DIU maxpixclock - %lu\n", maxpixclock);
+	pixval = speed_ccb/pixclock;
+	pr_debug("DIU pixval = %lu\n", pixval);
+
+	err = 100000000;
+	bestval = pixval;
+	pr_debug("DIU bestval = %lu\n", bestval);
+
+	bestfreq = 0;
+	for (i = -1; i <= 1; i++) {
+		temp = speed_ccb / ((pixval+i) + 1);
+		pr_debug("DIU test pixval i= %d, pixval=%lu, temp freq. = %u\n",
+							i, pixval, temp);
+		if ((temp < minpixclock) || (temp > maxpixclock))
+			pr_debug("DIU exceeds monitor range (%lu to %lu)\n",
+				minpixclock, maxpixclock);
+		else if (abs(temp - pixclock) < err) {
+		  pr_debug("Entered the else if block %d\n", i);
+			err = abs(temp - pixclock);
+			bestval = pixval+i;
+			bestfreq = temp;
+		}
+	}
+
+	pr_debug("DIU chose = %lx\n", bestval);
+	pr_debug("DIU error = %ld\n NomPixClk ", err);
+	pr_debug("DIU: Best Freq = %lx\n", bestfreq);
+	/* Modify PXCLK in GUTS CLKDVDR */
+	pr_debug("DIU: Current value of CLKDVDR = 0x%08x\n", (*clkdvdr));
+	temp = (*clkdvdr) & 0x2000FFFF;
+	*clkdvdr = temp;		/* turn off clock */
+	*clkdvdr = temp | 0x80000000 | (((bestval) & 0x1F) << 16);
+	pr_debug("DIU: Modified value of CLKDVDR = 0x%08x\n", (*clkdvdr));
+	iounmap(clkdvdr);
+}
+
+ssize_t mpc8610hpcd_show_monitor_port(int monitor_port, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE,
+			"%c0 - DVI\n"
+			"%c1 - Single link LVDS\n"
+			"%c2 - Dual link LVDS\n",
+			monitor_port == 0 ? '*' : ' ',
+			monitor_port == 1 ? '*' : ' ',
+			monitor_port == 2 ? '*' : ' ');
+}
+
+int mpc8610hpcd_set_sysfs_monitor_port(int val)
+{
+	return val < 3 ? val : 0;
+}
+
 #endif
+
+static void __init mpc86xx_hpcd_setup_arch(void)
+{
+	struct resource r;
+	struct device_node *np;
+	unsigned char *pixis;
+
 	if (ppc_md.progress)
 		ppc_md.progress("mpc86xx_hpcd_setup_arch()", 0);
 
@@ -183,6 +332,30 @@ mpc86xx_hpcd_setup_arch(void)
 		}
         }
 #endif
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
+	preallocate_diu_videomemory();
+	diu_ops.get_pixel_format	= mpc8610hpcd_get_pixel_format;
+	diu_ops.set_gamma_table		= mpc8610hpcd_set_gamma_table;
+	diu_ops.set_monitor_port	= mpc8610hpcd_set_monitor_port;
+	diu_ops.set_pixel_clock		= mpc8610hpcd_set_pixel_clock;
+	diu_ops.show_monitor_port	= mpc8610hpcd_show_monitor_port;
+	diu_ops.set_sysfs_monitor_port	= mpc8610hpcd_set_sysfs_monitor_port;
+#endif
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,fpga-pixis");
+	if (np) {
+		of_address_to_resource(np, 0, &r);
+		of_node_put(np);
+		pixis = ioremap(r.start, 32);
+		if (!pixis) {
+			printk(KERN_ERR "Err: can't map FPGA cfg register!\n");
+			return;
+		}
+		pixis_bdcfg0 = pixis + 8;
+		pixis_arch = pixis + 1;
+	} else
+		printk(KERN_ERR "Err: "
+				"can't find device node 'fsl,fpga-pixis'\n");
 
 	printk("MPC86xx HPCD board from Freescale Semiconductor\n");
 }
@@ -200,8 +373,7 @@ static int __init mpc86xx_hpcd_probe(voi
 	return 0;
 }
 
-static long __init
-mpc86xx_time_init(void)
+static long __init mpc86xx_time_init(void)
 {
 	unsigned int temp;
 
diff -puN arch/powerpc/sysdev/fsl_soc.c~powerpc-add-diu-platform-code-for-mpc8610hpcd arch/powerpc/sysdev/fsl_soc.c
--- a/arch/powerpc/sysdev/fsl_soc.c~powerpc-add-diu-platform-code-for-mpc8610hpcd
+++ a/arch/powerpc/sysdev/fsl_soc.c
@@ -892,3 +892,44 @@ void fsl_rstcr_restart(char *cmd)
 	while (1) ;
 }
 #endif
+
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
+struct platform_diu_data_ops diu_ops = {
+	.diu_size = 1280 * 1024 * 4,	/* default one 1280x1024 buffer */
+};
+EXPORT_SYMBOL(diu_ops);
+
+int __init preallocate_diu_videomemory(void)
+{
+	pr_debug("diu_size=%lu\n", diu_ops.diu_size);
+
+	diu_ops.diu_mem = __alloc_bootmem(diu_ops.diu_size, 8, 0);
+	if (!diu_ops.diu_mem) {
+		printk(KERN_ERR "fsl-diu: cannot allocate %lu bytes\n",
+			diu_ops.diu_size);
+		return -ENOMEM;
+	}
+
+	pr_debug("diu_mem=%p\n", diu_ops.diu_mem);
+
+	rh_init(&diu_ops.diu_rh_info, 4096, ARRAY_SIZE(diu_ops.diu_rh_block),
+		diu_ops.diu_rh_block);
+	return rh_attach_region(&diu_ops.diu_rh_info,
+				(unsigned long) diu_ops.diu_mem,
+				diu_ops.diu_size);
+}
+
+static int __init early_parse_diufb(char *p)
+{
+	if (!p)
+		return 1;
+
+	diu_ops.diu_size = _ALIGN_UP(memparse(p, &p), 8);
+
+	pr_debug("diu_size=%lu\n", diu_ops.diu_size);
+
+	return 0;
+}
+early_param("diufb", early_parse_diufb);
+
+#endif
diff -puN arch/powerpc/sysdev/fsl_soc.h~powerpc-add-diu-platform-code-for-mpc8610hpcd arch/powerpc/sysdev/fsl_soc.h
--- a/arch/powerpc/sysdev/fsl_soc.h~powerpc-add-diu-platform-code-for-mpc8610hpcd
+++ a/arch/powerpc/sysdev/fsl_soc.h
@@ -17,5 +17,28 @@ extern int fsl_spi_init(struct spi_board
 			void (*deactivate_cs)(u8 cs, u8 polarity));
 
 extern void fsl_rstcr_restart(char *cmd);
+
+#if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
+#include <linux/bootmem.h>
+#include <asm/rheap.h>
+struct platform_diu_data_ops {
+	rh_block_t diu_rh_block[16];
+	rh_info_t diu_rh_info;
+	unsigned long diu_size;
+	void *diu_mem;
+
+	unsigned int (*get_pixel_format) (unsigned int bits_per_pixel,
+		int monitor_port);
+	void (*set_gamma_table) (int monitor_port, char *gamma_table_base);
+	void (*set_monitor_port) (int monitor_port);
+	void (*set_pixel_clock) (unsigned int pixclock);
+	ssize_t (*show_monitor_port) (int monitor_port, char *buf);
+	int (*set_sysfs_monitor_port) (int val);
+};
+
+extern struct platform_diu_data_ops diu_ops;
+int __init preallocate_diu_videomemory(void);
+#endif
+
 #endif
 #endif
_

Patches currently in -mm which might be from yorksun@freescale.com are

origin.patch

