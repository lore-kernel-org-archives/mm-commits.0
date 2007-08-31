From: akpm@linux-foundation.org
Subject: - 8250_pci-autodetect-mainpine-cards.patch removed from -mm tree
Date: Fri, 31 Aug 2007 15:15:45 -0700
Message-ID: <200708312221.l7VML5h4029330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbXHaWV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 18:21:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     8250_pci: Autodetect mainpine cards
has been removed from the -mm tree.  Its filename was
     8250_pci-autodetect-mainpine-cards.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: 8250_pci: Autodetect mainpine cards
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add support for a whole range of boards. Some are partly autodetected but
not fully correctly others (PCI Express notably) not at all. Stick all
the right entries in.

Thanks to Mainpine for information and testing.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |  120 ++++++++++++++++++++++++++++++++++++
 1 files changed, 120 insertions(+)

diff -puN drivers/serial/8250_pci.c~8250_pci-autodetect-mainpine-cards drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~8250_pci-autodetect-mainpine-cards
+++ a/drivers/serial/8250_pci.c
@@ -1036,6 +1036,7 @@ enum pci_board_num_t {
 	pbn_b0_2_115200,
 	pbn_b0_4_115200,
 	pbn_b0_5_115200,
+	pbn_b0_8_115200,
 
 	pbn_b0_1_921600,
 	pbn_b0_2_921600,
@@ -1172,6 +1173,12 @@ static struct pciserial_board pci_boards
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
+	[pbn_b0_8_115200] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 8,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
 
 	[pbn_b0_1_921600] = {
 		.flags		= FL_BASE0,
@@ -2566,6 +2573,119 @@ static struct pci_device_id serial_pci_t
 	{       PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030,
 		PCI_SUBVENDOR_ID_PERLE, PCI_SUBDEVICE_ID_PCI_RAS8,
 		0, 0, pbn_b2_8_921600 },
+
+	/*
+	 * Mainpine series cards: Fairly standard layout but fools
+	 * parts of the autodetect in some cases and uses otherwise
+	 * unmatched communications subclasses in the PCI Express case
+	 */
+
+	{	/* RockForceDUO */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0200,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForceQUATRO */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0300,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForceDUO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0400,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForceQUATRO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0500,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForce+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0600,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForce+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0700,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForceOCTO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0800,
+		0, 0, pbn_b0_8_115200 },
+	{	/* RockForceDUO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0C00,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForceQUARTRO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0D00,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForceOCTO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x1D00,
+		0, 0, pbn_b0_8_115200 },
+	{	/* RockForceD1 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2000,
+		0, 0, pbn_b0_1_115200 },
+	{	/* RockForceF1 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2100,
+		0, 0, pbn_b0_1_115200 },
+	{	/* RockForceD2 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2200,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForceF2 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2300,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForceD4 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2400,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForceF4 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2500,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForceD8 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2600,
+		0, 0, pbn_b0_8_115200 },
+	{	/* RockForceF8 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2700,
+		0, 0, pbn_b0_8_115200 },
+	{	/* IQ Express D1 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3000,
+		0, 0, pbn_b0_1_115200 },
+	{	/* IQ Express F1 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3100,
+		0, 0, pbn_b0_1_115200 },
+	{	/* IQ Express D2 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3200,
+		0, 0, pbn_b0_2_115200 },
+	{	/* IQ Express F2 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3300,
+		0, 0, pbn_b0_2_115200 },
+	{	/* IQ Express D4 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3400,
+		0, 0, pbn_b0_4_115200 },
+	{	/* IQ Express F4 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3500,
+		0, 0, pbn_b0_4_115200 },
+	{	/* IQ Express D8 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3C00,
+		0, 0, pbn_b0_8_115200 },
+	{	/* IQ Express F8 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3D00,
+		0, 0, pbn_b0_8_115200 },
+
+
 	/*
 	 * PA Semi PA6T-1682M on-chip UART
 	 */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch
drivers-edac-fix-e752x-correct-return-code.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
git-xtensa.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
