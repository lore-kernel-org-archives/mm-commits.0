From: akpm@linux-foundation.org
Subject: - libata-acpi-checks-for-80wire-cable-implementation.patch removed from -mm tree
Date: Mon, 20 Aug 2007 16:02:42 -0700
Message-ID: <200708202307.l7KN7mjs028561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59733 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbXHTXIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 19:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: ACPI checks for 80wire cable: implementation
has been removed from the -mm tree.  Its filename was
     libata-acpi-checks-for-80wire-cable-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -335,6 +335,44 @@ int ata_acpi_cbl_80wire(struct ata_port 
 EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
 
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
serial-keep-the-dtr-setting-for-serial-console.patch
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
