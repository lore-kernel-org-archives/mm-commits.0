From: akpm@linux-foundation.org
Subject: [merged] mtd-fix-read-buffer-overflow.patch removed from -mm tree
Date: Tue, 08 Sep 2009 14:26:28 -0700
Message-ID: <200909082126.n88LQSc2007054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbZIHV0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 17:26:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     mtd-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before testing the element.

with `for (i = 0; bbt[i] && i < ebcnt; ++i)'
we test bbt[ebcnt] in the last iteration

with `for (i = 0; bbt[ebcnt - i - 1] && i < ebcnt; ++i)'
we test bbt[-1] in the last iteration

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/tests/mtd_oobtest.c  |    2 +-
 drivers/mtd/tests/mtd_pagetest.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/mtd/tests/mtd_oobtest.c~mtd-fix-read-buffer-overflow drivers/mtd/tests/mtd_oobtest.c
--- a/drivers/mtd/tests/mtd_oobtest.c~mtd-fix-read-buffer-overflow
+++ a/drivers/mtd/tests/mtd_oobtest.c
@@ -512,7 +512,7 @@ static int __init mtd_oobtest_init(void)
 		goto out;
 
 	addr0 = 0;
-	for (i = 0; bbt[i] && i < ebcnt; ++i)
+	for (i = 0; i < ebcnt && bbt[i]; ++i)
 		addr0 += mtd->erasesize;
 
 	/* Attempt to write off end of OOB */
diff -puN drivers/mtd/tests/mtd_pagetest.c~mtd-fix-read-buffer-overflow drivers/mtd/tests/mtd_pagetest.c
--- a/drivers/mtd/tests/mtd_pagetest.c~mtd-fix-read-buffer-overflow
+++ a/drivers/mtd/tests/mtd_pagetest.c
@@ -116,11 +116,11 @@ static int verify_eraseblock(int ebnum)
 	loff_t addr = ebnum * mtd->erasesize;
 
 	addr0 = 0;
-	for (i = 0; bbt[i] && i < ebcnt; ++i)
+	for (i = 0; i < ebcnt && bbt[i]; ++i)
 		addr0 += mtd->erasesize;
 
 	addrn = mtd->size;
-	for (i = 0; bbt[ebcnt - i - 1] && i < ebcnt; ++i)
+	for (i = 0; i < ebcnt && bbt[ebcnt - i - 1]; ++i)
 		addrn -= mtd->erasesize;
 
 	set_random_data(writebuf, mtd->erasesize);
@@ -219,11 +219,11 @@ static int crosstest(void)
 	memset(pp1, 0, pgsize * 4);
 
 	addr0 = 0;
-	for (i = 0; bbt[i] && i < ebcnt; ++i)
+	for (i = 0; i < ebcnt && bbt[i]; ++i)
 		addr0 += mtd->erasesize;
 
 	addrn = mtd->size;
-	for (i = 0; bbt[ebcnt - i - 1] && i < ebcnt; ++i)
+	for (i = 0; i < ebcnt && bbt[ebcnt - i - 1]; ++i)
 		addrn -= mtd->erasesize;
 
 	/* Read 2nd-to-last page to pp1 */
@@ -317,7 +317,7 @@ static int erasecrosstest(void)
 
 	ebnum = 0;
 	addr0 = 0;
-	for (i = 0; bbt[i] && i < ebcnt; ++i) {
+	for (i = 0; i < ebcnt && bbt[i]; ++i) {
 		addr0 += mtd->erasesize;
 		ebnum += 1;
 	}
@@ -413,7 +413,7 @@ static int erasetest(void)
 
 	ebnum = 0;
 	addr0 = 0;
-	for (i = 0; bbt[i] && i < ebcnt; ++i) {
+	for (i = 0; i < ebcnt && bbt[i]; ++i) {
 		addr0 += mtd->erasesize;
 		ebnum += 1;
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
octeon-false-positive-timeout.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
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
st-fix-test-of-value-range-in-st_set_options-fix.patch
comedi-null-dereference-of-amcc-in-v_pci_card_list_init.patch
rt2860-possible-null-dereferences.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
octeon-request_irq-failure-ignored-in-cvm_oct_spi_init.patch
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
gru-allocation-may-fail-in-quicktest1.patch

