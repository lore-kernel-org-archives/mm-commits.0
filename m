From: akpm@linux-foundation.org
Subject: [merged] hwmon-fix-freeing-of-gpio_data-and-irq.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:46:29 -0700
Message-ID: <200909222046.n8MKkTLT017822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbZIVUze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, david-b@pacbell.net, jic23@cam.ac.uk, mm-commits@vger.kernel.org


The patch titled
     hwmon: fix freeing of gpio_data and irq
has been removed from the -mm tree.  Its filename was
     hwmon-fix-freeing-of-gpio_data-and-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: fix freeing of gpio_data and irq
From: Roel Kluin <roel.kluin@gmail.com>

If already requested, gpio_data and irq should be freed in the case of an
error.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/sht15.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/sht15.c~hwmon-fix-freeing-of-gpio_data-and-irq drivers/hwmon/sht15.c
--- a/drivers/hwmon/sht15.c~hwmon-fix-freeing-of-gpio_data-and-irq
+++ a/drivers/hwmon/sht15.c
@@ -562,7 +562,7 @@ static int __devinit sht15_probe(struct 
 	ret = sysfs_create_group(&pdev->dev.kobj, &sht15_attr_group);
 	if (ret) {
 		dev_err(&pdev->dev, "sysfs create failed");
-		goto err_free_data;
+		goto err_release_gpio_data;
 	}
 
 	ret = request_irq(gpio_to_irq(data->pdata->gpio_data),
@@ -581,10 +581,12 @@ static int __devinit sht15_probe(struct 
 	data->hwmon_dev = hwmon_device_register(data->dev);
 	if (IS_ERR(data->hwmon_dev)) {
 		ret = PTR_ERR(data->hwmon_dev);
-		goto err_release_gpio_data;
+		goto err_release_irq;
 	}
 	return 0;
 
+err_release_irq:
+	free_irq(gpio_to_irq(data->pdata->gpio_data), data);
 err_release_gpio_data:
 	gpio_free(data->pdata->gpio_data);
 err_release_gpio_sck:
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
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
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
gru-allocation-may-fail-in-quicktest1.patch

