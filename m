From: akpm@linux-foundation.org
Subject: [merged] octeon-false-positive-timeout.patch removed from -mm tree
Date: Fri, 18 Sep 2009 12:31:30 -0700
Message-ID: <200909181931.n8IJVUa2015851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbZIRTb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Sep 2009 15:31:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ddaney@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     octeon: false positive timeout
has been removed from the -mm tree.  Its filename was
     octeon-false-positive-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: octeon: false positive timeout
From: Roel Kluin <roel.kluin@gmail.com>

If we reach the test just below the loop with a `timeout' value of 0, this
does not mean that the timeout caused the loop to end, but rather the
`smi_rd.s.pending', in the last iteration.  If timeout caused the loop to
end, then `timeout' is -1, not 0.

Since this can occur only in the last iteration, it is not very likely to
be a problem.  By changing the post- to prefix decrement we ensure that a
timeout of 0 does mean it timed out.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/octeon/cvmx-mdio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/octeon/cvmx-mdio.h~octeon-false-positive-timeout drivers/staging/octeon/cvmx-mdio.h
--- a/drivers/staging/octeon/cvmx-mdio.h~octeon-false-positive-timeout
+++ a/drivers/staging/octeon/cvmx-mdio.h
@@ -421,7 +421,7 @@ static inline int cvmx_mdio_45_read(int 
 	do {
 		cvmx_wait(1000);
 		smi_rd.u64 = cvmx_read_csr(CVMX_SMIX_RD_DAT(bus_id));
-	} while (smi_rd.s.pending && timeout--);
+	} while (smi_rd.s.pending && --timeout);
 
 	if (timeout <= 0) {
 		cvmx_dprintf("cvmx_mdio_45_read: bus_id %d phy_id %2d "
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
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
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
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

