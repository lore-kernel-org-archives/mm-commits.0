From: akpm@linux-foundation.org
Subject: - ata_piix-clean-up.patch removed from -mm tree
Date: Mon, 21 May 2007 22:56:45 -0700
Message-ID: <200705220556.l4M5uiT2028407@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756156AbXEVF7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 01:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata_piix: clean up
has been removed from the -mm tree.  Its filename was
     ata_piix-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata_piix: clean up
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

With cable methods in place we don't need a custom error handler for SATA so
get rid of it

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_piix.c |    9 +--------
 1 files changed, 1 insertion(+), 8 deletions(-)

diff -puN drivers/ata/ata_piix.c~ata_piix-clean-up drivers/ata/ata_piix.c
--- a/drivers/ata/ata_piix.c~ata_piix-clean-up
+++ a/drivers/ata/ata_piix.c
@@ -155,7 +155,6 @@ struct piix_host_priv {
 static int piix_init_one (struct pci_dev *pdev,
 				    const struct pci_device_id *ent);
 static void piix_pata_error_handler(struct ata_port *ap);
-static void piix_sata_error_handler(struct ata_port *ap);
 static void piix_set_piomode (struct ata_port *ap, struct ata_device *adev);
 static void piix_set_dmamode (struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode (struct ata_port *ap, struct ata_device *adev);
@@ -364,7 +363,7 @@ static const struct ata_port_operations 
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= piix_sata_error_handler,
+	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 
 	.irq_handler		= ata_interrupt,
@@ -641,12 +640,6 @@ static void piix_pata_error_handler(stru
 			   ata_std_postreset);
 }
 
-static void piix_sata_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset, NULL,
-			   ata_std_postreset);
-}
-
 /**
  *	piix_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-build-failure-for-drivers-ata-pata_sccc.patch
hpt3x2n-correct-revision-boundary.patch
pata_sis-fix-and-clean-up-some-timing-setups.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
ide-add-seagate-stt20000a-to-dma-blacklist.patch
serial-use-resource_size_t-for-port-io-addresses.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
pci_find_slot-mark-deprecated.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
watchdog-documentation.patch
add-pci_try_set_mwi-prism54pci.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
