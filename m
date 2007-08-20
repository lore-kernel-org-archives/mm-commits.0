From: akpm@linux-foundation.org
Subject: - libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:37 -0700
Message-ID: <200708201912.l7KJCbJm018367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759037AbXHTTVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: ACPI checks for 80wire cable: use in pata_amd
has been removed from the -mm tree.  Its filename was
     libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: ACPI checks for 80wire cable: use in pata_amd
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We can make use of this on the pata_amd driver as many Nvidia devices don't
have reliable cable detect.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c |    3 +++
 1 files changed, 3 insertions(+)

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
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
char-cyclades-remove-bottom-half-processing.patch
