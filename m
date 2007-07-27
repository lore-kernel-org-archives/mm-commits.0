From: akpm@linux-foundation.org
Subject: + libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch added to -mm tree
Date: Thu, 26 Jul 2007 22:29:44 -0700
Message-ID: <200707270529.l6R5Ti2Q007444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47650 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373AbXG0Faa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 01:30:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: ACPI checks for 80wire cable: use in pata_amd
has been added to the -mm tree.  Its filename is
     libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: ACPI checks for 80wire cable: use in pata_amd
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We can make use of this on the pata_amd driver as many Nvidia devices don't
have reliable cable detect.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/ata/pata_amd.c~libata-acpi-checks-for-80wire-cable-use-in-pata_amd drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~libata-acpi-checks-for-80wire-cable-use-in-pata_amd
+++ a/drivers/ata/pata_amd.c
@@ -268,6 +268,9 @@ static int nv_cable_detect(struct ata_po
  	pci_read_config_word(pdev, 0x62 - 2 * ap->port_no, &udma);
  	if ((udma & 0xC4) == 0xC4 || (udma & 0xC400) == 0xC400)
 		cbl = ATA_CBL_PATA80;
+	/* And a triple check across suspend/resume with ACPI around */
+	if (ata_acpi_cbl_80wire(ap))
+		cbl = ATA_CBL_PATA80;
 	return cbl;
 }
 
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
