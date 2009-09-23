From: akpm@linux-foundation.org
Subject: [merged] sdio-fix-read-buffer-overflow.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:34 -0700
Message-ID: <200909231955.n8NJtY8x003109__46530.7123530239$1253735798$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbZIWT4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:56:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, david.vrabel@csr.com, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     sdio: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     sdio-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Avoid buffer underrun when parsing an invalid CISTPL_VERS_1.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_cis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/core/sdio_cis.c~sdio-fix-read-buffer-overflow drivers/mmc/core/sdio_cis.c
--- a/drivers/mmc/core/sdio_cis.c~sdio-fix-read-buffer-overflow
+++ a/drivers/mmc/core/sdio_cis.c
@@ -40,7 +40,7 @@ static int cistpl_vers_1(struct mmc_card
 			nr_strings++;
 	}
 
-	if (buf[i-1] != '\0') {
+	if (nr_strings < 4) {
 		printk(KERN_WARNING "SDIO: ignoring broken CISTPL_VERS_1\n");
 		return 0;
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

