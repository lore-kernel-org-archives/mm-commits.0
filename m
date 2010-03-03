From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 03 Mar 2010 11:54:48 -0800
Message-ID: <201003031954.o23Jsmlb028026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001Ab0CCTyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 14:54:51 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o23JsmJ6009809
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 3 Mar 2010 11:54:49 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-mx2/devices.c   |    4 +---
 arch/arm/mach-mx2/devices.h   |    3 ---
 drivers/i2c/busses/i2c-isch.c |    4 ----
 drivers/i2c/i2c-smbus.c       |   11 -----------
 drivers/usb/early/ehci-dbgp.c |    7 -------
 5 files changed, 1 insertion(+), 28 deletions(-)

diff -puN arch/arm/mach-mx2/devices.c~linux-next-git-rejects arch/arm/mach-mx2/devices.c
--- a/arch/arm/mach-mx2/devices.c~linux-next-git-rejects
+++ a/arch/arm/mach-mx2/devices.c
@@ -271,7 +271,6 @@ struct platform_device mxc_pwm_device = 
 /*
  * Resource definition for the MXC SDHC
  */
-<<<<<<< HEAD:arch/arm/mach-mx2/devices.c
 static struct resource mxc_sdhc1_resources[] = {
 	{
 		.start = SDHC1_BASE_ADDR,
@@ -329,7 +328,7 @@ struct platform_device mxc_sdhc_device1 
 	.num_resources  = ARRAY_SIZE(mxc_sdhc2_resources),
 	.resource       = mxc_sdhc2_resources,
 };
-=======
+
 #define DEFINE_MXC_MMC_DEVICE(n, baseaddr, irq, dmareq)			\
 	static struct resource mxc_sdhc_resources ## n[] = {		\
 		{							\
@@ -362,7 +361,6 @@ struct platform_device mxc_sdhc_device1 
 
 DEFINE_MXC_MMC_DEVICE(0, MX2x_SDHC1_BASE_ADDR, MX2x_INT_SDHC1, MX2x_DMA_REQ_SDHC1);
 DEFINE_MXC_MMC_DEVICE(1, MX2x_SDHC2_BASE_ADDR, MX2x_INT_SDHC2, MX2x_DMA_REQ_SDHC2);
->>>>>>> FETCH_HEAD:arch/arm/mach-mx2/devices.c
 
 #ifdef CONFIG_MACH_MX27
 static struct resource otg_resources[] = {
diff -puN arch/arm/mach-mx2/devices.h~linux-next-git-rejects arch/arm/mach-mx2/devices.h
--- a/arch/arm/mach-mx2/devices.h~linux-next-git-rejects
+++ a/arch/arm/mach-mx2/devices.h
@@ -36,10 +36,7 @@ extern struct platform_device mxc_spi_de
 extern struct platform_device mxc_spi_device1;
 #ifdef CONFIG_MACH_MX27
 extern struct platform_device mxc_spi_device2;
-<<<<<<< HEAD:arch/arm/mach-mx2/devices.h
-=======
 #endif
->>>>>>> FETCH_HEAD:arch/arm/mach-mx2/devices.h
 extern struct platform_device mx21_usbhc_device;
 extern struct platform_device imx_ssi_device0;
 extern struct platform_device imx_ssi_device1;
diff -puN drivers/i2c/busses/i2c-isch.c~linux-next-git-rejects drivers/i2c/busses/i2c-isch.c
--- a/drivers/i2c/busses/i2c-isch.c~linux-next-git-rejects
+++ a/drivers/i2c/busses/i2c-isch.c
@@ -249,7 +249,6 @@ static struct i2c_adapter sch_adapter = 
 	.algo		= &smbus_algorithm,
 };
 
-<<<<<<< HEAD:drivers/i2c/busses/i2c-isch.c
 static const struct pci_device_id sch_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_LPC) },
 	{ 0, }
@@ -259,9 +258,6 @@ MODULE_DEVICE_TABLE(pci, sch_ids);
 
 static int __devinit sch_probe(struct pci_dev *dev,
 				const struct pci_device_id *id)
-=======
-static int __devinit smbus_sch_probe(struct platform_device *dev)
->>>>>>> FETCH_HEAD:drivers/i2c/busses/i2c-isch.c
 {
 	struct resource *res;
 	int retval;
diff -puN drivers/i2c/i2c-smbus.c~linux-next-git-rejects drivers/i2c/i2c-smbus.c
--- a/drivers/i2c/i2c-smbus.c~linux-next-git-rejects
+++ a/drivers/i2c/i2c-smbus.c
@@ -27,10 +27,7 @@
 #include <linux/workqueue.h>
 #include <linux/i2c.h>
 #include <linux/i2c-smbus.h>
-<<<<<<< HEAD:drivers/i2c/i2c-smbus.c
-=======
 #include <linux/mutex.h>
->>>>>>> FETCH_HEAD:drivers/i2c/i2c-smbus.c
 
 struct i2c_smbus_alert {
 	unsigned int		alert_edge_triggered:1;
@@ -59,11 +56,7 @@ static int smbus_do_alert(struct device 
 	 * Drivers should either disable alerts, or provide at least
 	 * a minimal handler.  Lock so client->driver won't change.
 	 */
-<<<<<<< HEAD:drivers/i2c/i2c-smbus.c
-	down(&dev->sem);
-=======
 	device_lock(dev);
->>>>>>> FETCH_HEAD:drivers/i2c/i2c-smbus.c
 	if (client->driver) {
 		if (client->driver->alert)
 			client->driver->alert(client, data->flag);
@@ -71,11 +64,7 @@ static int smbus_do_alert(struct device 
 			dev_warn(&client->dev, "no driver alert()!\n");
 	} else
 		dev_dbg(&client->dev, "alert with no driver\n");
-<<<<<<< HEAD:drivers/i2c/i2c-smbus.c
-	up(&dev->sem);
-=======
 	device_unlock(dev);
->>>>>>> FETCH_HEAD:drivers/i2c/i2c-smbus.c
 
 	/* Stop iterating after we find the device */
 	return -EBUSY;
diff -puN drivers/usb/early/ehci-dbgp.c~linux-next-git-rejects drivers/usb/early/ehci-dbgp.c
--- a/drivers/usb/early/ehci-dbgp.c~linux-next-git-rejects
+++ a/drivers/usb/early/ehci-dbgp.c
@@ -197,10 +197,7 @@ static int dbgp_wait_until_done(unsigned
 {
 	u32 pids, lpid;
 	int ret;
-<<<<<<< HEAD:drivers/usb/early/ehci-dbgp.c
 	int loop = DBGP_LOOPS;
-=======
->>>>>>> FETCH_HEAD:drivers/usb/early/ehci-dbgp.c
 
 retry:
 	writel(ctrl | DBGP_GO, &ehci_debug->control);
@@ -290,11 +287,7 @@ static int dbgp_bulk_write(unsigned devn
 	dbgp_set_data(bytes, size);
 	writel(addr, &ehci_debug->address);
 	writel(pids, &ehci_debug->pids);
-<<<<<<< HEAD:drivers/usb/early/ehci-dbgp.c
-	ret = dbgp_wait_until_done(ctrl);
-=======
 	ret = dbgp_wait_until_done(ctrl, DBGP_LOOPS);
->>>>>>> FETCH_HEAD:drivers/usb/early/ehci-dbgp.c
 
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-net.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-watchdog-wdtc-dont-constify-something-which-isnt-constant.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch
broadsheetfb-support-storing-waveform-fix.patch
mx3fb-introduce-waveform-configuration-for-pixel-clock-signal-checkpatch-fixes.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

