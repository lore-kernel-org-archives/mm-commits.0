From: akpm@linux-foundation.org
Subject: - pata_it821x-fix-regression-corruptor.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:48 -0700
Message-ID: <200708242058.l7OKwmCu014335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758700AbXHXVIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_it821x: fix regression/corruptor
has been removed from the -mm tree.  Its filename was
     pata_it821x-fix-regression-corruptor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_it821x: fix regression/corruptor
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Whoever did the PCI revision patch slipped up on the it821x, and I didn't
spot this at the time either. They moved the check for the errata from
the 0x10 revision to 0x11. Put it back

This one is important for 2.6.23 final as in some cases bad things will
occur if 0x10 revision boards don't get the fixups.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_it821x.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/pata_it821x.c~pata_it821x-fix-regression-corruptor drivers/ata/pata_it821x.c
--- a/drivers/ata/pata_it821x.c~pata_it821x-fix-regression-corruptor
+++ a/drivers/ata/pata_it821x.c
@@ -586,7 +586,7 @@ static int it821x_port_start(struct ata_
 	itdev->want[1][1] = ATA_ANY;
 	itdev->last_device = -1;
 
-	if (pdev->revision == 0x11) {
+	if (pdev->revision == 0x10) {
 		itdev->timing10 = 1;
 		/* Need to disable ATAPI DMA for this case */
 		if (!itdev->smart)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_marvell-add-more-identifiers.patch
libata-portmap-remove-unused-definitions.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-spot-bridge-chips.patch
libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch
libata-strict-checking-for-identify-reporting.patch
libata-add-a-drivers-ide-style-dma-disable.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
kobil_sct-rework-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
