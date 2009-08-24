From: akpm@linux-foundation.org
Subject: + hwmon-fix-freeing-of-gpio_data-and-irq.patch added to -mm tree
Date: Mon, 24 Aug 2009 13:17:09 -0700
Message-ID: <200908242017.n7OKH9jQ006179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216AbZHXURp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 16:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, david-b@pacbell.net, jic23@cam.ac.uk


The patch titled
     hwmon: fix freeing of gpio_data and irq
has been added to the -mm tree.  Its filename is
     hwmon-fix-freeing-of-gpio_data-and-irq.patch

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

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
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
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
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

