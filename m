From: akpm@linux-foundation.org
Subject: [merged] regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:05:35 -0700
Message-ID: <200909232005.n8NK5ZOA023709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752212AbZIWUKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk, mm-commits@vger.kernel.org


The patch titled
     regulator: fix calculation of voltage range in da9034_set_ldo12_voltage()
has been removed from the -mm tree.  Its filename was
     regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
hfc_usb-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
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
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
gru-allocation-may-fail-in-quicktest1.patch

