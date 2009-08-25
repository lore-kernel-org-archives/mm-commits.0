From: akpm@linux-foundation.org
Subject: + regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch added to -mm tree
Date: Tue, 25 Aug 2009 13:35:17 -0700
Message-ID: <200908252035.n7PKZH6A016307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095AbZHYUgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Aug 2009 16:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk


The patch titled
     regulator: fix calculation of voltage range in da9034_set_ldo12_voltage()
has been added to the -mm tree.  Its filename is
     regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch

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
Subject: regulator: fix calculation of voltage range in da9034_set_ldo12_voltage()
From: Roel Kluin <roel.kluin@gmail.com>

For val to be greater than 7 or less than 20 is logically always true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/da903x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/regulator/da903x.c~regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage drivers/regulator/da903x.c
--- a/drivers/regulator/da903x.c~regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage
+++ a/drivers/regulator/da903x.c
@@ -301,7 +301,7 @@ static int da9034_set_ldo12_voltage(stru
 	}
 
 	val = (min_uV - info->min_uV + info->step_uV - 1) / info->step_uV;
-	val = (val > 7 || val < 20) ? 8 : val - 12;
+	val = (val > 7 && val < 20) ? 8 : val - 12;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 
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
v4l-dvb-fix-test-of-bandwidth-range-in-cx22700_set_tps.patch
x86-fix-x86_model-test-in-es7000_apic_is_cluster.patch
regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch

