From: akpm@linux-foundation.org
Subject: [merged] txx9wdtc-52-fix-txx9wdt_probe-cleaning-up-after-errors.patch removed from -mm tree
Date: Wed, 26 Aug 2009 12:40:16 -0700
Message-ID: <200908261940.n7QJeG1a001940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbZHZTkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 15:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     txx9wdt.c:52: fix txx9wdt_probe() cleaning up after errors
has been removed from the -mm tree.  Its filename was
     txx9wdtc-52-fix-txx9wdt_probe-cleaning-up-after-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: txx9wdt.c:52: fix txx9wdt_probe() cleaning up after errors
From: Roel Kluin <roel.kluin@gmail.com>

Make txx9wdt_probe() clean up after errors.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/txx9wdt.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff -puN drivers/watchdog/txx9wdt.c~txx9wdtc-52-fix-txx9wdt_probe-cleaning-up-after-errors drivers/watchdog/txx9wdt.c
--- a/drivers/watchdog/txx9wdt.c~txx9wdtc-52-fix-txx9wdt_probe-cleaning-up-after-errors
+++ a/drivers/watchdog/txx9wdt.c
@@ -212,25 +212,31 @@ static int __init txx9wdt_probe(struct p
 	}
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res)
-		goto exit_busy;
+	if (!res) {
+		ret = -EBUSY;
+		goto exit;
+	}
 	if (!devm_request_mem_region(&dev->dev,
 				     res->start, res->end - res->start + 1,
-				     "txx9wdt"))
-		goto exit_busy;
+				     "txx9wdt")) {
+		ret = -EBUSY;
+		goto exit;
+	}
 	txx9wdt_reg = devm_ioremap(&dev->dev,
 				   res->start, res->end - res->start + 1);
-	if (!txx9wdt_reg)
-		goto exit_busy;
+	if (!txx9wdt_reg) {
+		ret = -EBUSY;
+		goto exit_release_mem;
+	}
 
 	ret = register_reboot_notifier(&txx9wdt_notifier);
 	if (ret)
-		goto exit;
+		goto exit_iounmap;
 
 	ret = misc_register(&txx9wdt_miscdev);
 	if (ret) {
 		unregister_reboot_notifier(&txx9wdt_notifier);
-		goto exit;
+		goto exit_iounmap;
 	}
 
 	printk(KERN_INFO "Hardware Watchdog Timer for TXx9: "
@@ -238,8 +244,11 @@ static int __init txx9wdt_probe(struct p
 	       timeout, WD_MAX_TIMEOUT, nowayout);
 
 	return 0;
-exit_busy:
-	ret = -EBUSY;
+
+exit_iounmap:
+	devm_iounmap(&dev->dev, txx9wdt_reg);
+exit_release_mem:
+	devm_release_mem_region(&dev->dev, res->start, res->end - res->start + 1);
 exit:
 	if (txx9_imclk) {
 		clk_disable(txx9_imclk);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
x86-fix-x86_model-test-in-es7000_apic_is_cluster.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
v4l-dvb-fix-test-of-bandwidth-range-in-cx22700_set_tps.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
rt2860-fix-test-in-rt_ioctl_siwfrag.patch
apci3200-fix-test-of-ui_delaytime-range-in-i_apci3200_commandtestanaloginput.patch
usb-fix-double-put_tty_drivergs_tty_driver-in-gserial_setup.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
uml-fix-order-of-pud-and-pmd_free.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
hwmon-fix-freeing-of-gpio_data-and-irq.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

