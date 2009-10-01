From: akpm@linux-foundation.org
Subject: [merged] msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch removed from -mm tree
Date: Thu, 01 Oct 2009 11:44:40 -0700
Message-ID: <200910011844.n91Iiedk013403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755840AbZJASo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 14:44:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ithamar.adema@team-embedded.nl, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     MSP71xx: request_irq() failure ignored in msp_pcibios_config_access()
has been removed from the -mm tree.  Its filename was
     msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MSP71xx: request_irq() failure ignored in msp_pcibios_config_access()
From: Roel Kluin <roel.kluin@gmail.com>

Produce an error if request_irq() fails.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: "Ithamar R. Adema" <ithamar.adema@team-embedded.nl>
Cc: Ralf Baechle <ralf@linux-mips.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/pci/ops-pmcmsp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/mips/pci/ops-pmcmsp.c~msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access arch/mips/pci/ops-pmcmsp.c
--- a/arch/mips/pci/ops-pmcmsp.c~msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access
+++ a/arch/mips/pci/ops-pmcmsp.c
@@ -385,6 +385,7 @@ int msp_pcibios_config_access(unsigned c
 	unsigned long intr;
 	unsigned long value;
 	static char pciirqflag;
+	int ret;
 #if defined(CONFIG_PMC_MSP7120_GW) || defined(CONFIG_PMC_MSP7120_EVAL)
 	unsigned int	vpe_status;
 #endif
@@ -402,11 +403,13 @@ int msp_pcibios_config_access(unsigned c
 	 * allocation assigns an interrupt handler to the interrupt.
 	 */
 	if (pciirqflag == 0) {
-		request_irq(MSP_INT_PCI,/* Hardcoded internal MSP7120 wiring */
+		ret = request_irq(MSP_INT_PCI,/* Hardcoded internal MSP7120 wiring */
 				bpci_interrupt,
 				IRQF_SHARED | IRQF_DISABLED,
 				"PMC MSP PCI Host",
 				preg);
+		if (ret != 0)
+			return ret;
 		pciirqflag = ~0;
 	}
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
bcm63xx_enet-timeout-off-by-one-in-do_mdio_op.patch
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
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
random-kmalloc-failure-ignored-in-init_std_data.patch

