From: akpm@linux-foundation.org
Subject: [merged] arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:44:17 -0700
Message-ID: <200909222044.n8MKiHRL013325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbZIVUoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     arch/alpha/boot/tools/objstrip.c: wrong variable tested after open()
has been removed from the -mm tree.  Its filename was
     arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/alpha/boot/tools/objstrip.c: wrong variable tested after open()
From: Roel Kluin <roel.kluin@gmail.com>

The incorrect variable is tested. fd is used for another open()
and is already tested.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/boot/tools/objstrip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/boot/tools/objstrip.c~arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open arch/alpha/boot/tools/objstrip.c
--- a/arch/alpha/boot/tools/objstrip.c~arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open
+++ a/arch/alpha/boot/tools/objstrip.c
@@ -93,7 +93,7 @@ main (int argc, char *argv[])
     ofd = 1;
     if (i < argc) {
 	ofd = open(argv[i++], O_WRONLY | O_CREAT | O_TRUNC, 0666);
-	if (fd == -1) {
+	if (ofd == -1) {
 	    perror("open");
 	    exit(1);
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
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
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
gru-allocation-may-fail-in-quicktest1.patch

