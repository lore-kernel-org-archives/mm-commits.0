From: akpm@linux-foundation.org
Subject: [merged] mtd-prevent-a-read-from-eraseregions.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:05:18 -0700
Message-ID: <200909232005.n8NK5Il7023123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343AbZIWUKB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: prevent a read from eraseregions[-1]
has been removed from the -mm tree.  Its filename was
     mtd-prevent-a-read-from-eraseregions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: prevent a read from eraseregions[-1]
From: Roel Kluin <roel.kluin@gmail.com>

If the erase region was found in the first iteration we read from
eraseregions[-1]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdconcat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/mtdconcat.c~mtd-prevent-a-read-from-eraseregions drivers/mtd/mtdconcat.c
--- a/drivers/mtd/mtdconcat.c~mtd-prevent-a-read-from-eraseregions
+++ a/drivers/mtd/mtdconcat.c
@@ -427,7 +427,7 @@ static int concat_erase(struct mtd_info 
 		 * to-be-erased area begins. Verify that the starting
 		 * offset is aligned to this region's erase size:
 		 */
-		if (instr->addr & (erase_regions[i].erasesize - 1))
+		if (i < 0 || instr->addr & (erase_regions[i].erasesize - 1))
 			return -EINVAL;
 
 		/*
@@ -440,8 +440,8 @@ static int concat_erase(struct mtd_info 
 		/*
 		 * check if the ending offset is aligned to this region's erase size
 		 */
-		if ((instr->addr + instr->len) & (erase_regions[i].erasesize -
-						  1))
+		if (i < 0 || ((instr->addr + instr->len) &
+					(erase_regions[i].erasesize - 1)))
 			return -EINVAL;
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

