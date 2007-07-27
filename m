From: akpm@linux-foundation.org
Subject: + libata-acpi-checks-for-80wire-cable-implementation.patch added to -mm tree
Date: Thu, 26 Jul 2007 22:29:43 -0700
Message-ID: <200707270529.l6R5ThoF007441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807AbXG0Fa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 01:30:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: ACPI checks for 80wire cable: implementation
has been added to the -mm tree.  Its filename is
     libata-acpi-checks-for-80wire-cable-implementation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: ACPI checks for 80wire cable: implementation
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Provide actual methods for checking if the ACPI support thinks the cable is
80wire, or doesn't know

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |   38 ++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff -puN drivers/ata/libata-acpi.c~libata-acpi-checks-for-80wire-cable-implementation drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~libata-acpi-checks-for-80wire-cable-implementation
+++ a/drivers/ata/libata-acpi.c
@@ -296,6 +296,44 @@ static int ata_dev_get_GTF(struct ata_de
 }
 
 /**
+ * ata_acpi_cbl_80wire		-	Check for 80 wire cable
+ * @ap: Port to check
+ *
+ * Return 1 if the ACPI mode data for this port indicates the BIOS selected
+ * an 80wire mode.
+ */
+
+int ata_acpi_cbl_80wire(struct ata_port *ap)
+{
+	struct ata_acpi_gtm gtm;
+	int valid = 0;
+
+	/* No _GTM data, no information */
+	if (ata_acpi_gtm(ap, &gtm) < 0)
+		return 0;
+
+	/* Split timing, DMA enabled */
+	if ((gtm.flags & 0x11) == 0x11 && gtm.drive[0].dma < 55)
+		valid |= 1;
+	if ((gtm.flags & 0x14) == 0x14 && gtm.drive[1].dma < 55)
+		valid |= 2;
+	/* Shared timing, DMA enabled */
+	if ((gtm.flags & 0x11) == 0x01 && gtm.drive[0].dma < 55)
+		valid |= 1;
+	if ((gtm.flags & 0x14) == 0x04 && gtm.drive[0].dma < 55)
+		valid |= 2;
+
+	/* Drive check */
+	if ((valid & 1) && ata_dev_enabled(&ap->device[0]))
+		return 1;
+	if ((valid & 2) && ata_dev_enabled(&ap->device[1]))
+		return 1;
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
+
+/**
  * taskfile_load_raw - send taskfile registers to host controller
  * @dev: target ATA device
  * @gtf: raw ATA taskfile register set (0x1f1 - 0x1f7)
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
