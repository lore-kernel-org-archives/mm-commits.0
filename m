From: akpm@linux-foundation.org
Subject: [merged] s3c-fix-check-of-index-into-s3c_gpios.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:56 -0700
Message-ID: <200909232003.n8NK3uNc020259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753702AbZIWUEh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ben-linux@fluff.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     s3c: fix check of index into s3c_gpios[]
has been removed from the -mm tree.  Its filename was
     s3c-fix-check-of-index-into-s3c_gpios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c: fix check of index into s3c_gpios[]
From: Roel Kluin <roel.kluin@gmail.com>

The check of the s3c_gpios[] index had an off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-s3c/gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-s3c/gpio.c~s3c-fix-check-of-index-into-s3c_gpios arch/arm/plat-s3c/gpio.c
--- a/arch/arm/plat-s3c/gpio.c~s3c-fix-check-of-index-into-s3c_gpios
+++ a/arch/arm/plat-s3c/gpio.c
@@ -28,7 +28,7 @@ static __init void s3c_gpiolib_track(str
 
 	gpn = chip->chip.base;
 	for (i = 0; i < chip->chip.ngpio; i++, gpn++) {
-		BUG_ON(gpn > ARRAY_SIZE(s3c_gpios));
+		BUG_ON(gpn >= ARRAY_SIZE(s3c_gpios));
 		s3c_gpios[gpn] = chip;
 	}
 }
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

