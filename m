From: akpm@linux-foundation.org
Subject: [merged] mtd-jffs2-fix-read-buffer-overflow.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:05:16 -0700
Message-ID: <200909232005.n8NK5GoY023052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345AbZIWUKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd/jffs2: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     mtd-jffs2-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd/jffs2: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Prevent a read from mtd->eraseregions[-1]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/lart.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/devices/lart.c~mtd-jffs2-fix-read-buffer-overflow drivers/mtd/devices/lart.c
--- a/drivers/mtd/devices/lart.c~mtd-jffs2-fix-read-buffer-overflow
+++ a/drivers/mtd/devices/lart.c
@@ -393,7 +393,8 @@ static int flash_erase (struct mtd_info 
 	* erase range is aligned with the erase size which is in
 	* effect here.
 	*/
-   if (instr->addr & (mtd->eraseregions[i].erasesize - 1)) return (-EINVAL);
+   if (i < 0 || (instr->addr & (mtd->eraseregions[i].erasesize - 1)))
+      return -EINVAL;
 
    /* Remember the erase region we start on */
    first = i;
@@ -409,7 +410,8 @@ static int flash_erase (struct mtd_info 
    i--;
 
    /* is the end aligned on a block boundary? */
-   if ((instr->addr + instr->len) & (mtd->eraseregions[i].erasesize - 1)) return (-EINVAL);
+   if (i < 0 || ((instr->addr + instr->len) & (mtd->eraseregions[i].erasesize - 1)))
+      return -EINVAL;
 
    addr = instr->addr;
    len = instr->len;
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

