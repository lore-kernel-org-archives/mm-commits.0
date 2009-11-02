From: akpm@linux-foundation.org
Subject: + const-constify-remaining-dev_pm_ops.patch added to -mm tree
Date: Mon, 02 Nov 2009 14:13:43 -0800
Message-ID: <200911022213.nA2MDhwH014426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756875AbZKBWNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 17:13:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     const: constify remaining dev_pm_ops
has been added to the -mm tree.  Its filename is
     const-constify-remaining-dev_pm_ops.patch

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
Subject: const: constify remaining dev_pm_ops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/arm/plat-omap/debug-leds.c~const-constify-remaining-dev_pm_ops arch/arm/plat-omap/debug-leds.c
--- a/arch/arm/plat-omap/debug-leds.c~const-constify-remaining-dev_pm_ops
+++ a/arch/arm/plat-omap/debug-leds.c
@@ -293,7 +293,7 @@ static int fpga_resume_noirq(struct devi
 	return 0;
 }
 
-static struct dev_pm_ops fpga_dev_pm_ops = {
+static const struct dev_pm_ops fpga_dev_pm_ops = {
 	.suspend_noirq = fpga_suspend_noirq,
 	.resume_noirq = fpga_resume_noirq,
 };
diff -puN arch/arm/plat-omap/gpio.c~const-constify-remaining-dev_pm_ops arch/arm/plat-omap/gpio.c
--- a/arch/arm/plat-omap/gpio.c~const-constify-remaining-dev_pm_ops
+++ a/arch/arm/plat-omap/gpio.c
@@ -1384,7 +1384,7 @@ static int omap_mpuio_resume_noirq(struc
 	return 0;
 }
 
-static struct dev_pm_ops omap_mpuio_dev_pm_ops = {
+static const struct dev_pm_ops omap_mpuio_dev_pm_ops = {
 	.suspend_noirq = omap_mpuio_suspend_noirq,
 	.resume_noirq = omap_mpuio_resume_noirq,
 };
diff -puN arch/s390/appldata/appldata_base.c~const-constify-remaining-dev_pm_ops arch/s390/appldata/appldata_base.c
--- a/arch/s390/appldata/appldata_base.c~const-constify-remaining-dev_pm_ops
+++ a/arch/s390/appldata/appldata_base.c
@@ -551,7 +551,7 @@ static int appldata_thaw(struct device *
 	return appldata_restore(dev);
 }
 
-static struct dev_pm_ops appldata_pm_ops = {
+static const struct dev_pm_ops appldata_pm_ops = {
 	.freeze		= appldata_freeze,
 	.thaw		= appldata_thaw,
 	.restore	= appldata_restore,
diff -puN drivers/block/floppy.c~const-constify-remaining-dev_pm_ops drivers/block/floppy.c
--- a/drivers/block/floppy.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/block/floppy.c
@@ -4162,7 +4162,7 @@ static int floppy_resume(struct device *
 	return 0;
 }
 
-static struct dev_pm_ops floppy_pm_ops = {
+static const struct dev_pm_ops floppy_pm_ops = {
 	.resume = floppy_resume,
 	.restore = floppy_resume,
 };
diff -puN drivers/char/hvc_iucv.c~const-constify-remaining-dev_pm_ops drivers/char/hvc_iucv.c
--- a/drivers/char/hvc_iucv.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/char/hvc_iucv.c
@@ -931,7 +931,7 @@ static struct hv_ops hvc_iucv_ops = {
 };
 
 /* Suspend / resume device operations */
-static struct dev_pm_ops hvc_iucv_pm_ops = {
+static const struct dev_pm_ops hvc_iucv_pm_ops = {
 	.freeze	  = hvc_iucv_pm_freeze,
 	.thaw	  = hvc_iucv_pm_restore_thaw,
 	.restore  = hvc_iucv_pm_restore_thaw,
diff -puN drivers/clocksource/sh_cmt.c~const-constify-remaining-dev_pm_ops drivers/clocksource/sh_cmt.c
--- a/drivers/clocksource/sh_cmt.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/clocksource/sh_cmt.c
@@ -689,7 +689,7 @@ static int sh_cmt_resume(struct device *
 	return 0;
 }
 
-static struct dev_pm_ops sh_cmt_dev_pm_ops = {
+static const struct dev_pm_ops sh_cmt_dev_pm_ops = {
 	.suspend = sh_cmt_suspend,
 	.resume = sh_cmt_resume,
 };
diff -puN drivers/dma/at_hdmac.c~const-constify-remaining-dev_pm_ops drivers/dma/at_hdmac.c
--- a/drivers/dma/at_hdmac.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/dma/at_hdmac.c
@@ -1188,7 +1188,7 @@ static int at_dma_resume_noirq(struct de
 	return 0;
 }
 
-static struct dev_pm_ops at_dma_dev_pm_ops = {
+static const struct dev_pm_ops at_dma_dev_pm_ops = {
 	.suspend_noirq = at_dma_suspend_noirq,
 	.resume_noirq = at_dma_resume_noirq,
 };
diff -puN drivers/dma/dw_dmac.c~const-constify-remaining-dev_pm_ops drivers/dma/dw_dmac.c
--- a/drivers/dma/dw_dmac.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/dma/dw_dmac.c
@@ -1427,7 +1427,7 @@ static int dw_resume_noirq(struct device
 	return 0;
 }
 
-static struct dev_pm_ops dw_dev_pm_ops = {
+static const struct dev_pm_ops dw_dev_pm_ops = {
 	.suspend_noirq = dw_suspend_noirq,
 	.resume_noirq = dw_resume_noirq,
 };
diff -puN drivers/dma/txx9dmac.c~const-constify-remaining-dev_pm_ops drivers/dma/txx9dmac.c
--- a/drivers/dma/txx9dmac.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/dma/txx9dmac.c
@@ -1313,7 +1313,7 @@ static int txx9dmac_resume_noirq(struct 
 
 }
 
-static struct dev_pm_ops txx9dmac_dev_pm_ops = {
+static const struct dev_pm_ops txx9dmac_dev_pm_ops = {
 	.suspend_noirq = txx9dmac_suspend_noirq,
 	.resume_noirq = txx9dmac_resume_noirq,
 };
diff -puN drivers/hwmon/applesmc.c~const-constify-remaining-dev_pm_ops drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/hwmon/applesmc.c
@@ -518,7 +518,7 @@ static int applesmc_pm_restore(struct de
 	return applesmc_pm_resume(dev);
 }
 
-static struct dev_pm_ops applesmc_pm_ops = {
+static const struct dev_pm_ops applesmc_pm_ops = {
 	.resume = applesmc_pm_resume,
 	.restore = applesmc_pm_restore,
 };
diff -puN drivers/i2c/busses/i2c-pxa.c~const-constify-remaining-dev_pm_ops drivers/i2c/busses/i2c-pxa.c
--- a/drivers/i2c/busses/i2c-pxa.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/i2c/busses/i2c-pxa.c
@@ -1155,7 +1155,7 @@ static int i2c_pxa_resume_noirq(struct d
 	return 0;
 }
 
-static struct dev_pm_ops i2c_pxa_dev_pm_ops = {
+static const struct dev_pm_ops i2c_pxa_dev_pm_ops = {
 	.suspend_noirq = i2c_pxa_suspend_noirq,
 	.resume_noirq = i2c_pxa_resume_noirq,
 };
diff -puN drivers/i2c/busses/i2c-s3c2410.c~const-constify-remaining-dev_pm_ops drivers/i2c/busses/i2c-s3c2410.c
--- a/drivers/i2c/busses/i2c-s3c2410.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/i2c/busses/i2c-s3c2410.c
@@ -967,7 +967,7 @@ static int s3c24xx_i2c_resume(struct dev
 	return 0;
 }
 
-static struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
+static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
 	.suspend_noirq = s3c24xx_i2c_suspend_noirq,
 	.resume = s3c24xx_i2c_resume,
 };
diff -puN drivers/i2c/busses/i2c-sh_mobile.c~const-constify-remaining-dev_pm_ops drivers/i2c/busses/i2c-sh_mobile.c
--- a/drivers/i2c/busses/i2c-sh_mobile.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/i2c/busses/i2c-sh_mobile.c
@@ -647,7 +647,7 @@ static int sh_mobile_i2c_runtime_nop(str
 	return 0;
 }
 
-static struct dev_pm_ops sh_mobile_i2c_dev_pm_ops = {
+static const struct dev_pm_ops sh_mobile_i2c_dev_pm_ops = {
 	.runtime_suspend = sh_mobile_i2c_runtime_nop,
 	.runtime_resume = sh_mobile_i2c_runtime_nop,
 };
diff -puN drivers/input/keyboard/adp5588-keys.c~const-constify-remaining-dev_pm_ops drivers/input/keyboard/adp5588-keys.c
--- a/drivers/input/keyboard/adp5588-keys.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/input/keyboard/adp5588-keys.c
@@ -319,7 +319,7 @@ static int adp5588_resume(struct device 
 	return 0;
 }
 
-static struct dev_pm_ops adp5588_dev_pm_ops = {
+static const struct dev_pm_ops adp5588_dev_pm_ops = {
 	.suspend = adp5588_suspend,
 	.resume  = adp5588_resume,
 };
diff -puN drivers/input/keyboard/sh_keysc.c~const-constify-remaining-dev_pm_ops drivers/input/keyboard/sh_keysc.c
--- a/drivers/input/keyboard/sh_keysc.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/input/keyboard/sh_keysc.c
@@ -295,7 +295,7 @@ static int sh_keysc_resume(struct device
 	return 0;
 }
 
-static struct dev_pm_ops sh_keysc_dev_pm_ops = {
+static const struct dev_pm_ops sh_keysc_dev_pm_ops = {
 	.suspend = sh_keysc_suspend,
 	.resume = sh_keysc_resume,
 };
diff -puN drivers/input/misc/bfin_rotary.c~const-constify-remaining-dev_pm_ops drivers/input/misc/bfin_rotary.c
--- a/drivers/input/misc/bfin_rotary.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/input/misc/bfin_rotary.c
@@ -247,7 +247,7 @@ static int bfin_rotary_resume(struct dev
 	return 0;
 }
 
-static struct dev_pm_ops bfin_rotary_pm_ops = {
+static const struct dev_pm_ops bfin_rotary_pm_ops = {
 	.suspend	= bfin_rotary_suspend,
 	.resume		= bfin_rotary_resume,
 };
diff -puN drivers/input/misc/pcspkr.c~const-constify-remaining-dev_pm_ops drivers/input/misc/pcspkr.c
--- a/drivers/input/misc/pcspkr.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/input/misc/pcspkr.c
@@ -127,7 +127,7 @@ static void pcspkr_shutdown(struct platf
 	pcspkr_event(NULL, EV_SND, SND_BELL, 0);
 }
 
-static struct dev_pm_ops pcspkr_pm_ops = {
+static const struct dev_pm_ops pcspkr_pm_ops = {
 	.suspend = pcspkr_suspend,
 };
 
diff -puN drivers/input/touchscreen/pcap_ts.c~const-constify-remaining-dev_pm_ops drivers/input/touchscreen/pcap_ts.c
--- a/drivers/input/touchscreen/pcap_ts.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/input/touchscreen/pcap_ts.c
@@ -233,7 +233,7 @@ static int pcap_ts_resume(struct device 
 	return 0;
 }
 
-static struct dev_pm_ops pcap_ts_pm_ops = {
+static const struct dev_pm_ops pcap_ts_pm_ops = {
 	.suspend	= pcap_ts_suspend,
 	.resume		= pcap_ts_resume,
 };
diff -puN drivers/media/video/davinci/vpfe_capture.c~const-constify-remaining-dev_pm_ops drivers/media/video/davinci/vpfe_capture.c
--- a/drivers/media/video/davinci/vpfe_capture.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/media/video/davinci/vpfe_capture.c
@@ -2090,7 +2090,7 @@ vpfe_resume(struct device *dev)
 	return -1;
 }
 
-static struct dev_pm_ops vpfe_dev_pm_ops = {
+static const struct dev_pm_ops vpfe_dev_pm_ops = {
 	.suspend = vpfe_suspend,
 	.resume = vpfe_resume,
 };
diff -puN drivers/media/video/davinci/vpif_capture.c~const-constify-remaining-dev_pm_ops drivers/media/video/davinci/vpif_capture.c
--- a/drivers/media/video/davinci/vpif_capture.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/media/video/davinci/vpif_capture.c
@@ -2107,7 +2107,7 @@ vpif_resume(struct device *dev)
 	return -1;
 }
 
-static struct dev_pm_ops vpif_dev_pm_ops = {
+static const struct dev_pm_ops vpif_dev_pm_ops = {
 	.suspend = vpif_suspend,
 	.resume = vpif_resume,
 };
diff -puN drivers/media/video/sh_mobile_ceu_camera.c~const-constify-remaining-dev_pm_ops drivers/media/video/sh_mobile_ceu_camera.c
--- a/drivers/media/video/sh_mobile_ceu_camera.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1767,7 +1767,7 @@ static int sh_mobile_ceu_runtime_nop(str
 	return 0;
 }
 
-static struct dev_pm_ops sh_mobile_ceu_dev_pm_ops = {
+static const struct dev_pm_ops sh_mobile_ceu_dev_pm_ops = {
 	.runtime_suspend = sh_mobile_ceu_runtime_nop,
 	.runtime_resume = sh_mobile_ceu_runtime_nop,
 };
diff -puN drivers/mmc/host/pxamci.c~const-constify-remaining-dev_pm_ops drivers/mmc/host/pxamci.c
--- a/drivers/mmc/host/pxamci.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/mmc/host/pxamci.c
@@ -826,7 +826,7 @@ static int pxamci_resume(struct device *
 	return ret;
 }
 
-static struct dev_pm_ops pxamci_pm_ops = {
+static const struct dev_pm_ops pxamci_pm_ops = {
 	.suspend	= pxamci_suspend,
 	.resume		= pxamci_resume,
 };
diff -puN drivers/mmc/host/s3cmci.c~const-constify-remaining-dev_pm_ops drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/mmc/host/s3cmci.c
@@ -1892,7 +1892,7 @@ static int s3cmci_resume(struct device *
 	return mmc_resume_host(mmc);
 }
 
-static struct dev_pm_ops s3cmci_pm = {
+static const struct dev_pm_ops s3cmci_pm = {
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
diff -puN drivers/mtd/nand/nomadik_nand.c~const-constify-remaining-dev_pm_ops drivers/mtd/nand/nomadik_nand.c
--- a/drivers/mtd/nand/nomadik_nand.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/mtd/nand/nomadik_nand.c
@@ -216,7 +216,7 @@ static int nomadik_nand_resume(struct de
 	return 0;
 }
 
-static struct dev_pm_ops nomadik_nand_pm_ops = {
+static const struct dev_pm_ops nomadik_nand_pm_ops = {
 	.suspend = nomadik_nand_suspend,
 	.resume = nomadik_nand_resume,
 };
diff -puN drivers/net/3c59x.c~const-constify-remaining-dev_pm_ops drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/net/3c59x.c
@@ -836,7 +836,7 @@ static int vortex_resume(struct device *
 	return 0;
 }
 
-static struct dev_pm_ops vortex_pm_ops = {
+static const struct dev_pm_ops vortex_pm_ops = {
 	.suspend = vortex_suspend,
 	.resume = vortex_resume,
 	.freeze = vortex_suspend,
diff -puN drivers/net/dm9000.c~const-constify-remaining-dev_pm_ops drivers/net/dm9000.c
--- a/drivers/net/dm9000.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/net/dm9000.c
@@ -1519,7 +1519,7 @@ dm9000_drv_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops dm9000_drv_pm_ops = {
+static const struct dev_pm_ops dm9000_drv_pm_ops = {
 	.suspend	= dm9000_drv_suspend,
 	.resume		= dm9000_drv_resume,
 };
diff -puN drivers/net/r8169.c~const-constify-remaining-dev_pm_ops drivers/net/r8169.c
--- a/drivers/net/r8169.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/net/r8169.c
@@ -4855,7 +4855,7 @@ out:
 	return 0;
 }
 
-static struct dev_pm_ops rtl8169_pm_ops = {
+static const struct dev_pm_ops rtl8169_pm_ops = {
 	.suspend = rtl8169_suspend,
 	.resume = rtl8169_resume,
 	.freeze = rtl8169_suspend,
diff -puN drivers/net/smsc911x.c~const-constify-remaining-dev_pm_ops drivers/net/smsc911x.c
--- a/drivers/net/smsc911x.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/net/smsc911x.c
@@ -2154,7 +2154,7 @@ static int smsc911x_resume(struct device
 	return (to == 0) ? -EIO : 0;
 }
 
-static struct dev_pm_ops smsc911x_pm_ops = {
+static const struct dev_pm_ops smsc911x_pm_ops = {
 	.suspend	= smsc911x_suspend,
 	.resume		= smsc911x_resume,
 };
diff -puN drivers/net/vmxnet3/vmxnet3_drv.c~const-constify-remaining-dev_pm_ops drivers/net/vmxnet3/vmxnet3_drv.c
--- a/drivers/net/vmxnet3/vmxnet3_drv.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2532,7 +2532,7 @@ vmxnet3_resume(struct device *device)
 	return 0;
 }
 
-static struct dev_pm_ops vmxnet3_pm_ops = {
+static const struct dev_pm_ops vmxnet3_pm_ops = {
 	.suspend = vmxnet3_suspend,
 	.resume = vmxnet3_resume,
 };
diff -puN drivers/pci/pcie/portdrv_pci.c~const-constify-remaining-dev_pm_ops drivers/pci/pcie/portdrv_pci.c
--- a/drivers/pci/pcie/portdrv_pci.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/pci/pcie/portdrv_pci.c
@@ -43,7 +43,7 @@ static int pcie_portdrv_restore_config(s
 }
 
 #ifdef CONFIG_PM
-static struct dev_pm_ops pcie_portdrv_pm_ops = {
+static const struct dev_pm_ops pcie_portdrv_pm_ops = {
 	.suspend	= pcie_port_device_suspend,
 	.resume		= pcie_port_device_resume,
 	.freeze		= pcie_port_device_suspend,
diff -puN drivers/pcmcia/pxa2xx_base.c~const-constify-remaining-dev_pm_ops drivers/pcmcia/pxa2xx_base.c
--- a/drivers/pcmcia/pxa2xx_base.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/pcmcia/pxa2xx_base.c
@@ -311,7 +311,7 @@ static int pxa2xx_drv_pcmcia_resume(stru
 	return pcmcia_socket_dev_resume(dev);
 }
 
-static struct dev_pm_ops  pxa2xx_drv_pcmcia_pm_ops = {
+static const struct dev_pm_ops pxa2xx_drv_pcmcia_pm_ops = {
 	.suspend	= pxa2xx_drv_pcmcia_suspend,
 	.resume		= pxa2xx_drv_pcmcia_resume,
 };
diff -puN drivers/pcmcia/yenta_socket.c~const-constify-remaining-dev_pm_ops drivers/pcmcia/yenta_socket.c
--- a/drivers/pcmcia/yenta_socket.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/pcmcia/yenta_socket.c
@@ -1278,7 +1278,7 @@ static int yenta_dev_resume_noirq(struct
 	return pcmcia_socket_dev_resume(dev);
 }
 
-static struct dev_pm_ops yenta_pm_ops = {
+static const struct dev_pm_ops yenta_pm_ops = {
 	.suspend_noirq = yenta_dev_suspend_noirq,
 	.resume_noirq = yenta_dev_resume_noirq,
 	.freeze_noirq = yenta_dev_suspend_noirq,
diff -puN drivers/platform/x86/acerhdf.c~const-constify-remaining-dev_pm_ops drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/platform/x86/acerhdf.c
@@ -460,7 +460,7 @@ static int acerhdf_remove(struct platfor
 	return 0;
 }
 
-static struct dev_pm_ops acerhdf_pm_ops = {
+static const struct dev_pm_ops acerhdf_pm_ops = {
 	.suspend = acerhdf_suspend,
 	.freeze  = acerhdf_suspend,
 };
diff -puN drivers/platform/x86/eeepc-laptop.c~const-constify-remaining-dev_pm_ops drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -156,7 +156,7 @@ static void eeepc_rfkill_hotplug(bool re
 static int eeepc_hotk_thaw(struct device *device);
 static int eeepc_hotk_restore(struct device *device);
 
-static struct dev_pm_ops eeepc_pm_ops = {
+static const struct dev_pm_ops eeepc_pm_ops = {
 	.thaw = eeepc_hotk_thaw,
 	.restore = eeepc_hotk_restore,
 };
diff -puN drivers/platform/x86/hp-wmi.c~const-constify-remaining-dev_pm_ops drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/platform/x86/hp-wmi.c
@@ -94,7 +94,7 @@ static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
 
-static struct dev_pm_ops hp_wmi_pm_ops = {
+static const struct dev_pm_ops hp_wmi_pm_ops = {
 	.resume  = hp_wmi_resume_handler,
 	.restore  = hp_wmi_resume_handler,
 };
diff -puN drivers/power/wm97xx_battery.c~const-constify-remaining-dev_pm_ops drivers/power/wm97xx_battery.c
--- a/drivers/power/wm97xx_battery.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/power/wm97xx_battery.c
@@ -157,7 +157,7 @@ static int wm97xx_bat_resume(struct devi
 	return 0;
 }
 
-static struct dev_pm_ops wm97xx_bat_pm_ops = {
+static const struct dev_pm_ops wm97xx_bat_pm_ops = {
 	.suspend	= wm97xx_bat_suspend,
 	.resume		= wm97xx_bat_resume,
 };
diff -puN drivers/rtc/rtc-pxa.c~const-constify-remaining-dev_pm_ops drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/rtc/rtc-pxa.c
@@ -456,7 +456,7 @@ static int pxa_rtc_resume(struct device 
 	return 0;
 }
 
-static struct dev_pm_ops pxa_rtc_pm_ops = {
+static const struct dev_pm_ops pxa_rtc_pm_ops = {
 	.suspend	= pxa_rtc_suspend,
 	.resume		= pxa_rtc_resume,
 };
diff -puN drivers/rtc/rtc-sa1100.c~const-constify-remaining-dev_pm_ops drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/rtc/rtc-sa1100.c
@@ -407,7 +407,7 @@ static int sa1100_rtc_resume(struct devi
 	return 0;
 }
 
-static struct dev_pm_ops sa1100_rtc_pm_ops = {
+static const struct dev_pm_ops sa1100_rtc_pm_ops = {
 	.suspend	= sa1100_rtc_suspend,
 	.resume		= sa1100_rtc_resume,
 };
diff -puN drivers/rtc/rtc-sh.c~const-constify-remaining-dev_pm_ops drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/rtc/rtc-sh.c
@@ -826,7 +826,7 @@ static int sh_rtc_resume(struct device *
 	return 0;
 }
 
-static struct dev_pm_ops sh_rtc_dev_pm_ops = {
+static const struct dev_pm_ops sh_rtc_dev_pm_ops = {
 	.suspend = sh_rtc_suspend,
 	.resume = sh_rtc_resume,
 };
diff -puN drivers/rtc/rtc-wm831x.c~const-constify-remaining-dev_pm_ops drivers/rtc/rtc-wm831x.c
--- a/drivers/rtc/rtc-wm831x.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/rtc/rtc-wm831x.c
@@ -485,7 +485,7 @@ static int __devexit wm831x_rtc_remove(s
 	return 0;
 }
 
-static struct dev_pm_ops wm831x_rtc_pm_ops = {
+static const struct dev_pm_ops wm831x_rtc_pm_ops = {
 	.suspend = wm831x_rtc_suspend,
 	.resume = wm831x_rtc_resume,
 
diff -puN drivers/s390/block/dcssblk.c~const-constify-remaining-dev_pm_ops drivers/s390/block/dcssblk.c
--- a/drivers/s390/block/dcssblk.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/block/dcssblk.c
@@ -1005,7 +1005,7 @@ static int dcssblk_thaw(struct device *d
 	return 0;
 }
 
-static struct dev_pm_ops dcssblk_pm_ops = {
+static const struct dev_pm_ops dcssblk_pm_ops = {
 	.freeze		= dcssblk_freeze,
 	.thaw		= dcssblk_thaw,
 	.restore	= dcssblk_restore,
diff -puN drivers/s390/block/xpram.c~const-constify-remaining-dev_pm_ops drivers/s390/block/xpram.c
--- a/drivers/s390/block/xpram.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/block/xpram.c
@@ -407,7 +407,7 @@ static int xpram_restore(struct device *
 	return 0;
 }
 
-static struct dev_pm_ops xpram_pm_ops = {
+static const struct dev_pm_ops xpram_pm_ops = {
 	.restore	= xpram_restore,
 };
 
diff -puN drivers/s390/char/monreader.c~const-constify-remaining-dev_pm_ops drivers/s390/char/monreader.c
--- a/drivers/s390/char/monreader.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/char/monreader.c
@@ -532,7 +532,7 @@ static int monreader_restore(struct devi
 	return monreader_thaw(dev);
 }
 
-static struct dev_pm_ops monreader_pm_ops = {
+static const struct dev_pm_ops monreader_pm_ops = {
 	.freeze  = monreader_freeze,
 	.thaw	 = monreader_thaw,
 	.restore = monreader_restore,
diff -puN drivers/s390/char/monwriter.c~const-constify-remaining-dev_pm_ops drivers/s390/char/monwriter.c
--- a/drivers/s390/char/monwriter.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/char/monwriter.c
@@ -326,7 +326,7 @@ static int monwriter_thaw(struct device 
 	return monwriter_restore(dev);
 }
 
-static struct dev_pm_ops monwriter_pm_ops = {
+static const struct dev_pm_ops monwriter_pm_ops = {
 	.freeze		= monwriter_freeze,
 	.thaw		= monwriter_thaw,
 	.restore	= monwriter_restore,
diff -puN drivers/s390/char/sclp.c~const-constify-remaining-dev_pm_ops drivers/s390/char/sclp.c
--- a/drivers/s390/char/sclp.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/char/sclp.c
@@ -1019,7 +1019,7 @@ static int sclp_restore(struct device *d
 	return sclp_undo_suspend(SCLP_PM_EVENT_RESTORE);
 }
 
-static struct dev_pm_ops sclp_pm_ops = {
+static const struct dev_pm_ops sclp_pm_ops = {
 	.freeze		= sclp_freeze,
 	.thaw		= sclp_thaw,
 	.restore	= sclp_restore,
diff -puN drivers/s390/char/sclp_cmd.c~const-constify-remaining-dev_pm_ops drivers/s390/char/sclp_cmd.c
--- a/drivers/s390/char/sclp_cmd.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/char/sclp_cmd.c
@@ -546,7 +546,7 @@ struct read_storage_sccb {
 	u32 entries[0];
 } __packed;
 
-static struct dev_pm_ops sclp_mem_pm_ops = {
+static const struct dev_pm_ops sclp_mem_pm_ops = {
 	.freeze		= sclp_mem_freeze,
 };
 
diff -puN drivers/s390/char/vmlogrdr.c~const-constify-remaining-dev_pm_ops drivers/s390/char/vmlogrdr.c
--- a/drivers/s390/char/vmlogrdr.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/char/vmlogrdr.c
@@ -679,7 +679,7 @@ static int vmlogrdr_pm_prepare(struct de
 }
 
 
-static struct dev_pm_ops vmlogrdr_pm_ops = {
+static const struct dev_pm_ops vmlogrdr_pm_ops = {
 	.prepare = vmlogrdr_pm_prepare,
 };
 
diff -puN drivers/s390/cio/ccwgroup.c~const-constify-remaining-dev_pm_ops drivers/s390/cio/ccwgroup.c
--- a/drivers/s390/cio/ccwgroup.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/cio/ccwgroup.c
@@ -560,7 +560,7 @@ static int ccwgroup_pm_restore(struct de
 	return gdrv->restore ? gdrv->restore(gdev) : 0;
 }
 
-static struct dev_pm_ops ccwgroup_pm_ops = {
+static const struct dev_pm_ops ccwgroup_pm_ops = {
 	.prepare = ccwgroup_pm_prepare,
 	.complete = ccwgroup_pm_complete,
 	.freeze = ccwgroup_pm_freeze,
diff -puN drivers/s390/cio/css.c~const-constify-remaining-dev_pm_ops drivers/s390/cio/css.c
--- a/drivers/s390/cio/css.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/cio/css.c
@@ -1095,7 +1095,7 @@ static int css_pm_restore(struct device 
 	return drv->restore ? drv->restore(sch) : 0;
 }
 
-static struct dev_pm_ops css_pm_ops = {
+static const struct dev_pm_ops css_pm_ops = {
 	.prepare = css_pm_prepare,
 	.complete = css_pm_complete,
 	.freeze = css_pm_freeze,
diff -puN drivers/s390/cio/device.c~const-constify-remaining-dev_pm_ops drivers/s390/cio/device.c
--- a/drivers/s390/cio/device.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/cio/device.c
@@ -2147,7 +2147,7 @@ out_unlock:
 	return ret;
 }
 
-static struct dev_pm_ops ccw_pm_ops = {
+static const struct dev_pm_ops ccw_pm_ops = {
 	.prepare = ccw_device_pm_prepare,
 	.complete = ccw_device_pm_complete,
 	.freeze = ccw_device_pm_freeze,
diff -puN drivers/s390/net/netiucv.c~const-constify-remaining-dev_pm_ops drivers/s390/net/netiucv.c
--- a/drivers/s390/net/netiucv.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/net/netiucv.c
@@ -159,7 +159,7 @@ static void netiucv_pm_complete(struct d
 static int netiucv_pm_freeze(struct device *);
 static int netiucv_pm_restore_thaw(struct device *);
 
-static struct dev_pm_ops netiucv_pm_ops = {
+static const struct dev_pm_ops netiucv_pm_ops = {
 	.prepare = netiucv_pm_prepare,
 	.complete = netiucv_pm_complete,
 	.freeze = netiucv_pm_freeze,
diff -puN drivers/s390/net/smsgiucv.c~const-constify-remaining-dev_pm_ops drivers/s390/net/smsgiucv.c
--- a/drivers/s390/net/smsgiucv.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/s390/net/smsgiucv.c
@@ -168,7 +168,7 @@ static int smsg_pm_restore_thaw(struct d
 	return 0;
 }
 
-static struct dev_pm_ops smsg_pm_ops = {
+static const struct dev_pm_ops smsg_pm_ops = {
 	.freeze = smsg_pm_freeze,
 	.thaw = smsg_pm_restore_thaw,
 	.restore = smsg_pm_restore_thaw,
diff -puN drivers/serial/pxa.c~const-constify-remaining-dev_pm_ops drivers/serial/pxa.c
--- a/drivers/serial/pxa.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/serial/pxa.c
@@ -747,7 +747,7 @@ static int serial_pxa_resume(struct devi
         return 0;
 }
 
-static struct dev_pm_ops serial_pxa_pm_ops = {
+static const struct dev_pm_ops serial_pxa_pm_ops = {
 	.suspend	= serial_pxa_suspend,
 	.resume		= serial_pxa_resume,
 };
diff -puN drivers/serial/sh-sci.c~const-constify-remaining-dev_pm_ops drivers/serial/sh-sci.c
--- a/drivers/serial/sh-sci.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/serial/sh-sci.c
@@ -1363,7 +1363,7 @@ static int sci_resume(struct device *dev
 	return 0;
 }
 
-static struct dev_pm_ops sci_dev_pm_ops = {
+static const struct dev_pm_ops sci_dev_pm_ops = {
 	.suspend	= sci_suspend,
 	.resume		= sci_resume,
 };
diff -puN drivers/spi/pxa2xx_spi.c~const-constify-remaining-dev_pm_ops drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1709,7 +1709,7 @@ static int pxa2xx_spi_resume(struct devi
 	return 0;
 }
 
-static struct dev_pm_ops pxa2xx_spi_pm_ops = {
+static const struct dev_pm_ops pxa2xx_spi_pm_ops = {
 	.suspend	= pxa2xx_spi_suspend,
 	.resume		= pxa2xx_spi_resume,
 };
diff -puN drivers/spi/spi_s3c24xx.c~const-constify-remaining-dev_pm_ops drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/spi/spi_s3c24xx.c
@@ -489,7 +489,7 @@ static int s3c24xx_spi_resume(struct dev
 	return 0;
 }
 
-static struct dev_pm_ops s3c24xx_spi_pmops = {
+static const struct dev_pm_ops s3c24xx_spi_pmops = {
 	.suspend	= s3c24xx_spi_suspend,
 	.resume		= s3c24xx_spi_resume,
 };
diff -puN drivers/uio/uio_pdrv_genirq.c~const-constify-remaining-dev_pm_ops drivers/uio/uio_pdrv_genirq.c
--- a/drivers/uio/uio_pdrv_genirq.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/uio/uio_pdrv_genirq.c
@@ -209,7 +209,7 @@ static int uio_pdrv_genirq_runtime_nop(s
 	return 0;
 }
 
-static struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
+static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
 	.runtime_suspend = uio_pdrv_genirq_runtime_nop,
 	.runtime_resume = uio_pdrv_genirq_runtime_nop,
 };
diff -puN drivers/usb/core/hcd-pci.c~const-constify-remaining-dev_pm_ops drivers/usb/core/hcd-pci.c
--- a/drivers/usb/core/hcd-pci.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/usb/core/hcd-pci.c
@@ -363,7 +363,7 @@ static int hcd_pci_restore(struct device
 	return resume_common(dev, true);
 }
 
-struct dev_pm_ops usb_hcd_pci_pm_ops = {
+const struct dev_pm_ops usb_hcd_pci_pm_ops = {
 	.suspend	= hcd_pci_suspend,
 	.suspend_noirq	= hcd_pci_suspend_noirq,
 	.resume_noirq	= hcd_pci_resume_noirq,
diff -puN drivers/usb/core/hcd.h~const-constify-remaining-dev_pm_ops drivers/usb/core/hcd.h
--- a/drivers/usb/core/hcd.h~const-constify-remaining-dev_pm_ops
+++ a/drivers/usb/core/hcd.h
@@ -315,7 +315,7 @@ extern void usb_hcd_pci_remove(struct pc
 extern void usb_hcd_pci_shutdown(struct pci_dev *dev);
 
 #ifdef CONFIG_PM_SLEEP
-extern struct dev_pm_ops	usb_hcd_pci_pm_ops;
+extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
 #endif
 #endif /* CONFIG_PCI */
 
diff -puN drivers/usb/core/usb.c~const-constify-remaining-dev_pm_ops drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/usb/core/usb.c
@@ -291,7 +291,7 @@ static int usb_dev_restore(struct device
 	return usb_resume(dev, PMSG_RESTORE);
 }
 
-static struct dev_pm_ops usb_device_pm_ops = {
+static const struct dev_pm_ops usb_device_pm_ops = {
 	.prepare =	usb_dev_prepare,
 	.complete =	usb_dev_complete,
 	.suspend =	usb_dev_suspend,
diff -puN drivers/usb/host/ehci-au1xxx.c~const-constify-remaining-dev_pm_ops drivers/usb/host/ehci-au1xxx.c
--- a/drivers/usb/host/ehci-au1xxx.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/usb/host/ehci-au1xxx.c
@@ -297,7 +297,7 @@ static int ehci_hcd_au1xxx_drv_resume(st
 	return 0;
 }
 
-static struct dev_pm_ops au1xxx_ehci_pmops = {
+static const struct dev_pm_ops au1xxx_ehci_pmops = {
 	.suspend	= ehci_hcd_au1xxx_drv_suspend,
 	.resume		= ehci_hcd_au1xxx_drv_resume,
 };
diff -puN drivers/usb/host/ohci-au1xxx.c~const-constify-remaining-dev_pm_ops drivers/usb/host/ohci-au1xxx.c
--- a/drivers/usb/host/ohci-au1xxx.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/usb/host/ohci-au1xxx.c
@@ -294,7 +294,7 @@ static int ohci_hcd_au1xxx_drv_resume(st
 	return 0;
 }
 
-static struct dev_pm_ops au1xxx_ohci_pmops = {
+static const struct dev_pm_ops au1xxx_ohci_pmops = {
 	.suspend	= ohci_hcd_au1xxx_drv_suspend,
 	.resume		= ohci_hcd_au1xxx_drv_resume,
 };
diff -puN drivers/usb/host/ohci-pxa27x.c~const-constify-remaining-dev_pm_ops drivers/usb/host/ohci-pxa27x.c
--- a/drivers/usb/host/ohci-pxa27x.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/usb/host/ohci-pxa27x.c
@@ -518,7 +518,7 @@ static int ohci_hcd_pxa27x_drv_resume(st
 	return 0;
 }
 
-static struct dev_pm_ops ohci_hcd_pxa27x_pm_ops = {
+static const struct dev_pm_ops ohci_hcd_pxa27x_pm_ops = {
 	.suspend	= ohci_hcd_pxa27x_drv_suspend,
 	.resume		= ohci_hcd_pxa27x_drv_resume,
 };
diff -puN drivers/usb/host/r8a66597-hcd.c~const-constify-remaining-dev_pm_ops drivers/usb/host/r8a66597-hcd.c
--- a/drivers/usb/host/r8a66597-hcd.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/usb/host/r8a66597-hcd.c
@@ -2357,7 +2357,7 @@ static int r8a66597_resume(struct device
 	return 0;
 }
 
-static struct dev_pm_ops r8a66597_dev_pm_ops = {
+static const struct dev_pm_ops r8a66597_dev_pm_ops = {
 	.suspend = r8a66597_suspend,
 	.resume = r8a66597_resume,
 	.poweroff = r8a66597_suspend,
diff -puN drivers/usb/musb/musb_core.c~const-constify-remaining-dev_pm_ops drivers/usb/musb/musb_core.c
--- a/drivers/usb/musb/musb_core.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/usb/musb/musb_core.c
@@ -2216,7 +2216,7 @@ static int musb_resume_noirq(struct devi
 	return 0;
 }
 
-static struct dev_pm_ops musb_dev_pm_ops = {
+static const struct dev_pm_ops musb_dev_pm_ops = {
 	.suspend	= musb_suspend,
 	.resume_noirq	= musb_resume_noirq,
 };
diff -puN drivers/video/backlight/da903x_bl.c~const-constify-remaining-dev_pm_ops drivers/video/backlight/da903x_bl.c
--- a/drivers/video/backlight/da903x_bl.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/video/backlight/da903x_bl.c
@@ -170,7 +170,7 @@ static int da903x_backlight_resume(struc
 	return 0;
 }
 
-static struct dev_pm_ops da903x_backlight_pm_ops = {
+static const struct dev_pm_ops da903x_backlight_pm_ops = {
 	.suspend	= da903x_backlight_suspend,
 	.resume		= da903x_backlight_resume,
 };
diff -puN drivers/video/hitfb.c~const-constify-remaining-dev_pm_ops drivers/video/hitfb.c
--- a/drivers/video/hitfb.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/video/hitfb.c
@@ -456,7 +456,7 @@ static int hitfb_resume(struct device *d
 	return 0;
 }
 
-static struct dev_pm_ops hitfb_dev_pm_ops = {
+static const struct dev_pm_ops hitfb_dev_pm_ops = {
 	.suspend	= hitfb_suspend,
 	.resume		= hitfb_resume,
 };
diff -puN drivers/video/pxafb.c~const-constify-remaining-dev_pm_ops drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/video/pxafb.c
@@ -1654,7 +1654,7 @@ static int pxafb_resume(struct device *d
 	return 0;
 }
 
-static struct dev_pm_ops pxafb_pm_ops = {
+static const struct dev_pm_ops pxafb_pm_ops = {
 	.suspend	= pxafb_suspend,
 	.resume		= pxafb_resume,
 };
diff -puN drivers/video/sh_mobile_lcdcfb.c~const-constify-remaining-dev_pm_ops drivers/video/sh_mobile_lcdcfb.c
--- a/drivers/video/sh_mobile_lcdcfb.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/video/sh_mobile_lcdcfb.c
@@ -874,7 +874,7 @@ static int sh_mobile_lcdc_runtime_resume
 	return 0;
 }
 
-static struct dev_pm_ops sh_mobile_lcdc_dev_pm_ops = {
+static const struct dev_pm_ops sh_mobile_lcdc_dev_pm_ops = {
 	.suspend = sh_mobile_lcdc_suspend,
 	.resume = sh_mobile_lcdc_resume,
 	.runtime_suspend = sh_mobile_lcdc_runtime_suspend,
diff -puN drivers/watchdog/adx_wdt.c~const-constify-remaining-dev_pm_ops drivers/watchdog/adx_wdt.c
--- a/drivers/watchdog/adx_wdt.c~const-constify-remaining-dev_pm_ops
+++ a/drivers/watchdog/adx_wdt.c
@@ -314,7 +314,7 @@ static int adx_wdt_resume(struct device 
 	return 0;
 }
 
-static struct dev_pm_ops adx_wdt_pm_ops = {
+static const struct dev_pm_ops adx_wdt_pm_ops = {
 	.suspend = adx_wdt_suspend,
 	.resume = adx_wdt_resume,
 };
diff -puN include/linux/pm.h~const-constify-remaining-dev_pm_ops include/linux/pm.h
--- a/include/linux/pm.h~const-constify-remaining-dev_pm_ops
+++ a/include/linux/pm.h
@@ -219,7 +219,7 @@ struct dev_pm_ops {
  * to RAM and hibernation.
  */
 #define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
-struct dev_pm_ops name = { \
+const struct dev_pm_ops name = { \
 	.suspend = suspend_fn, \
 	.resume = resume_fn, \
 	.freeze = suspend_fn, \
diff -puN net/iucv/af_iucv.c~const-constify-remaining-dev_pm_ops net/iucv/af_iucv.c
--- a/net/iucv/af_iucv.c~const-constify-remaining-dev_pm_ops
+++ a/net/iucv/af_iucv.c
@@ -221,7 +221,7 @@ static int afiucv_pm_restore_thaw(struct
 	return 0;
 }
 
-static struct dev_pm_ops afiucv_pm_ops = {
+static const struct dev_pm_ops afiucv_pm_ops = {
 	.prepare = afiucv_pm_prepare,
 	.complete = afiucv_pm_complete,
 	.freeze = afiucv_pm_freeze,
diff -puN net/iucv/iucv.c~const-constify-remaining-dev_pm_ops net/iucv/iucv.c
--- a/net/iucv/iucv.c~const-constify-remaining-dev_pm_ops
+++ a/net/iucv/iucv.c
@@ -93,7 +93,7 @@ static int iucv_pm_freeze(struct device 
 static int iucv_pm_thaw(struct device *);
 static int iucv_pm_restore(struct device *);
 
-static struct dev_pm_ops iucv_pm_ops = {
+static const struct dev_pm_ops iucv_pm_ops = {
 	.prepare = iucv_pm_prepare,
 	.complete = iucv_pm_complete,
 	.freeze = iucv_pm_freeze,
diff -puN sound/arm/pxa2xx-ac97.c~const-constify-remaining-dev_pm_ops sound/arm/pxa2xx-ac97.c
--- a/sound/arm/pxa2xx-ac97.c~const-constify-remaining-dev_pm_ops
+++ a/sound/arm/pxa2xx-ac97.c
@@ -159,7 +159,7 @@ static int pxa2xx_ac97_resume(struct dev
 	return ret;
 }
 
-static struct dev_pm_ops pxa2xx_ac97_pm_ops = {
+static const struct dev_pm_ops pxa2xx_ac97_pm_ops = {
 	.suspend	= pxa2xx_ac97_suspend,
 	.resume		= pxa2xx_ac97_resume,
 };
diff -puN sound/soc/s3c24xx/s3c24xx_simtec.c~const-constify-remaining-dev_pm_ops sound/soc/s3c24xx/s3c24xx_simtec.c
--- a/sound/soc/s3c24xx/s3c24xx_simtec.c~const-constify-remaining-dev_pm_ops
+++ a/sound/soc/s3c24xx/s3c24xx_simtec.c
@@ -312,7 +312,7 @@ int simtec_audio_resume(struct device *d
 	return 0;
 }
 
-struct dev_pm_ops simtec_audio_pmops = {
+const struct dev_pm_ops simtec_audio_pmops = {
 	.resume	= simtec_audio_resume,
 };
 EXPORT_SYMBOL_GPL(simtec_audio_pmops);
diff -puN sound/soc/s3c24xx/s3c24xx_simtec.h~const-constify-remaining-dev_pm_ops sound/soc/s3c24xx/s3c24xx_simtec.h
--- a/sound/soc/s3c24xx/s3c24xx_simtec.h~const-constify-remaining-dev_pm_ops
+++ a/sound/soc/s3c24xx/s3c24xx_simtec.h
@@ -15,7 +15,7 @@ extern int simtec_audio_core_probe(struc
 extern int simtec_audio_remove(struct platform_device *pdev);
 
 #ifdef CONFIG_PM
-extern struct dev_pm_ops simtec_audio_pmops;
+extern const struct dev_pm_ops simtec_audio_pmops;
 #define simtec_audio_pm &simtec_audio_pmops
 #else
 #define simtec_audio_pm NULL
diff -puN sound/soc/soc-core.c~const-constify-remaining-dev_pm_ops sound/soc/soc-core.c
--- a/sound/soc/soc-core.c~const-constify-remaining-dev_pm_ops
+++ a/sound/soc/soc-core.c
@@ -1009,7 +1009,7 @@ static int soc_poweroff(struct device *d
 	return 0;
 }
 
-static struct dev_pm_ops soc_pm_ops = {
+static const struct dev_pm_ops soc_pm_ops = {
 	.suspend = soc_suspend,
 	.resume = soc_resume,
 	.poweroff = soc_poweroff,
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
proc-fix-stack_start-in-compat-mode.patch
uml-irq-register-race-condition.patch
linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
const-constify-remaining-pipe_buf_operations.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

