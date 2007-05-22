From: akpm@linux-foundation.org
Subject: - pata_hpt366-enable-bits-are-unreliable-so-dont-use-them.patch removed from -mm tree
Date: Mon, 21 May 2007 22:56:42 -0700
Message-ID: <200705220556.l4M5ufex028402@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756203AbXEVF7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 01:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_hpt366: Enable bits are unreliable so don't use them
has been removed from the -mm tree.  Its filename was
     pata_hpt366-enable-bits-are-unreliable-so-dont-use-them.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_hpt366: Enable bits are unreliable so don't use them
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Various people had problems with both old and new IDE when hpt366 enable bits
started getting honoured.  It turns out they are not reliable so don't rely on
them

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt366.c |   28 +---------------------------
 1 files changed, 1 insertion(+), 27 deletions(-)

diff -puN drivers/ata/pata_hpt366.c~pata_hpt366-enable-bits-are-unreliable-so-dont-use-them drivers/ata/pata_hpt366.c
--- a/drivers/ata/pata_hpt366.c~pata_hpt366-enable-bits-are-unreliable-so-dont-use-them
+++ a/drivers/ata/pata_hpt366.c
@@ -220,32 +220,6 @@ static int hpt36x_cable_detect(struct at
 	return ATA_CBL_PATA80;
 }
 
-static int hpt36x_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	static const struct pci_bits hpt36x_enable_bits[] = {
-		{ 0x50, 1, 0x04, 0x04 },
-		{ 0x54, 1, 0x04, 0x04 }
-	};
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	if (!pci_test_config_bits(pdev, &hpt36x_enable_bits[ap->port_no]))
-		return -ENOENT;
-
-	return ata_std_prereset(ap, deadline);
-}
-
-/**
- *	hpt36x_error_handler	-	reset the hpt36x bus
- *	@ap: ATA port to reset
- *
- *	Perform the reset handling for the 366/368
- */
-
-static void hpt36x_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, hpt36x_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
 /**
  *	hpt366_set_piomode		-	PIO setup
  *	@ap: ATA interface
@@ -351,7 +325,7 @@ static struct ata_port_operations hpt366
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= hpt36x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.cable_detect	= hpt36x_cable_detect,
 
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
