From: akpm@linux-foundation.org
Subject: - 8250_pci-autodetect-mainpine-cards.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:29:56 -0700
Message-ID: <200710162029.l9GKTu0t014354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936019AbXJPUaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     8250_pci: Autodetect mainpine cards
has been removed from the -mm tree.  Its filename was
     8250_pci-autodetect-mainpine-cards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 include/linux/pci_ids.h   |    2 
 2 files changed, 122 insertions(+)

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
diff -puN include/linux/pci_ids.h~8250_pci-autodetect-mainpine-cards include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~8250_pci-autodetect-mainpine-cards
+++ a/include/linux/pci_ids.h
@@ -1995,6 +1995,8 @@
 #define PCI_VENDOR_ID_TOPIC		0x151f
 #define PCI_DEVICE_ID_TOPIC_TP560	0x0000
 
+#define PCI_VENDOR_ID_MAINPINE		0x1522
+#define PCI_DEVICE_ID_MAINPINE_PBRIDGE	0x0100
 #define PCI_VENDOR_ID_ENE		0x1524
 #define PCI_DEVICE_ID_ENE_CB712_SD	0x0550
 #define PCI_DEVICE_ID_ENE_CB712_SD_2	0x0551
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
serial-keep-the-dtr-setting-for-serial-console.patch
initio-fix-conflict-when-loading-driver.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
