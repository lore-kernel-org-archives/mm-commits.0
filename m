From: akpm@linux-foundation.org
Subject: [merged] hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:51 -0800
Message-ID: <200912292133.nBTLXpEM008733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbZL2Vd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, brueckner@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hvc_console: fix test on unsigned in hvc_console_print()
has been removed from the -mm tree.  Its filename was
     hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hvc_console: fix test on unsigned in hvc_console_print()
From: Roel Kluin <roel.kluin@gmail.com>

vtermnos[] is unsigned, so this test was wrong.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_console.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/hvc_console.c~hvc_console-fix-test-on-unsigned-in-hvc_console_print drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~hvc_console-fix-test-on-unsigned-in-hvc_console_print
+++ a/drivers/char/hvc_console.c
@@ -146,7 +146,7 @@ static void hvc_console_print(struct con
 		return;
 
 	/* This console adapter was removed so it is not usable. */
-	if (vtermnos[index] < 0)
+	if (vtermnos[index] == -1)
 		return;
 
 	while (count > 0 || i > 0) {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
omap-confusion-in-iommu_put.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch

