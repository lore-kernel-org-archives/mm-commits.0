From: akpm@linux-foundation.org
Subject: + apci3200-fix-test-of-ui_delaytime-range-in-i_apci3200_commandtestanaloginput.patch added to -mm tree
Date: Tue, 25 Aug 2009 13:29:19 -0700
Message-ID: <200908252029.n7PKTJxT005586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644AbZHYU3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Aug 2009 16:29:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, gregkh@suse.de, wfp5p@virginia.edu


The patch titled
     apci3200: fix test of ui_DelayTime range in i_APCI3200_CommandTestAnalogInput()
has been added to the -mm tree.  Its filename is
     apci3200-fix-test-of-ui_delaytime-range-in-i_apci3200_commandtestanaloginput.patch

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
Subject: apci3200: fix test of ui_DelayTime range in i_APCI3200_CommandTestAnalogInput()
From: Roel Kluin <roel.kluin@gmail.com>

For ui_DelayTime to be less than 1 and greater than 1023 is logically
impossible.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c~apci3200-fix-test-of-ui_delaytime-range-in-i_apci3200_commandtestanaloginput drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c~apci3200-fix-test-of-ui_delaytime-range-in-i_apci3200_commandtestanaloginput
+++ a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -2669,7 +2669,7 @@ int i_APCI3200_CommandTestAnalogInput(st
 			err++;
 			printk("\nThe Delay time base selection is in error\n");
 		}
-		if (ui_DelayTime < 1 && ui_DelayTime > 1023) {
+		if (ui_DelayTime < 1 || ui_DelayTime > 1023) {
 			err++;
 			printk("\nThe Delay time value is in error\n");
 		}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
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
cio-double-put_device-in-subchannel_register.patch
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
txx9wdtc-52-fix-txx9wdt_probe-cleaning-up-after-errors.patch
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
kref-documentation-double-kref_put-in-my_data_handler.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

