From: akpm@linux-foundation.org
Subject: + libata-sff-unbreak-non-dma-capable-controllers-again.patch added to -mm tree
Date: Thu, 26 Jul 2007 22:31:31 -0700
Message-ID: <200707270531.l6R5VVQ7007475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756787AbXG0Fbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 01:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata-sff: unbreak non DMA capable controllers again
has been added to the -mm tree.  Its filename is
     libata-sff-unbreak-non-dma-capable-controllers-again.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
drivers-edac-fix-reset-edac_mc-pollmsec.patch
drivers-edac-fix-edac_pci-sysfs.patch
include-asm-mips-add-missing-edac-h-file.patch
drivers-edac-fix-pasemi-kconfig-depends.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-sff-unbreak-non-dma-capable-controllers-again.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
lib8390-comment-on-locking-by-alan-cox.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
git-scsi-rc-fixes.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-setup-correct-chipset-access-functions-fix.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
