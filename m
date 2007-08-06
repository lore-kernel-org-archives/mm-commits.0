From: akpm@linux-foundation.org
Subject: - libata-sff-unbreak-non-dma-capable-controllers-again.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:13 -0700
Message-ID: <200708060753.l767rDJp016319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758178AbXHFHx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata-sff: unbreak non DMA capable controllers again
has been removed from the -mm tree.  Its filename was
     libata-sff-unbreak-non-dma-capable-controllers-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata-sff: unbreak non DMA capable controllers again
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Seems nobody else is checking/testing this case as it keeps getting horked.

If we have no BAR4 mapping on an SFF controller this is *NOT* an error, it
just means it isn't doing BMDMA.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/ata/libata-sff.c~libata-sff-unbreak-non-dma-capable-controllers-again drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-sff-unbreak-non-dma-capable-controllers-again
+++ a/drivers/ata/libata-sff.c
@@ -573,6 +573,10 @@ int ata_pci_init_bmdma(struct ata_host *
 	struct pci_dev *pdev = to_pci_dev(gdev);
 	int i, rc;
 
+	/* No BAR4 allocation: No DMA */
+	if (pci_resource_start(pdev, 4) == 0)
+		return 0;
+
 	/* TODO: If we get no DMA mask we should fall back to PIO */
 	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
 	if (rc)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

nozomi-shoot-defunct-label.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-correct-iordy-handling.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
