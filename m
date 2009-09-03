From: akpm@linux-foundation.org
Subject: + drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch added to -mm tree
Date: Thu, 03 Sep 2009 15:02:11 -0700
Message-ID: <200909032202.n83M2Bui018992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328AbZICWCm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 18:02:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ddaney@caviumnetworks.com, greg@kroah.com


The patch titled
     drivers/staging/octeon/ethernet-rgmii.c: don't ignore request_irq() return code
has been added to the -mm tree.  Its filename is
     drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/octeon/ethernet-rgmii.c: don't ignore request_irq() return code
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: David Daney <ddaney@caviumnetworks.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/octeon/ethernet-rgmii.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/staging/octeon/ethernet-rgmii.c~drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code drivers/staging/octeon/ethernet-rgmii.c
--- a/drivers/staging/octeon/ethernet-rgmii.c~drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code
+++ a/drivers/staging/octeon/ethernet-rgmii.c
@@ -308,7 +308,7 @@ int cvm_oct_rgmii_init(struct net_device
 
 	/*
 	 * Due to GMX errata in CN3XXX series chips, it is necessary
-	 * to take the link down immediately whne the PHY changes
+	 * to take the link down immediately when the PHY changes
 	 * state. In order to do this we call the poll function every
 	 * time the RGMII inband status changes.  This may cause
 	 * problems if the PHY doesn't implement inband status
@@ -317,6 +317,8 @@ int cvm_oct_rgmii_init(struct net_device
 	if (number_rgmii_ports == 0) {
 		r = request_irq(OCTEON_IRQ_RML, cvm_oct_rgmii_rml_interrupt,
 				IRQF_SHARED, "RGMII", &number_rgmii_ports);
+		if (r != 0)
+			return r;
 	}
 	number_rgmii_ports++;
 
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
octeon-false-positive-timeout.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
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
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch

