From: akpm@linux-foundation.org
Subject: + pata_it821x-fix-regression-corruptor.patch added to -mm tree
Date: Thu, 23 Aug 2007 14:31:54 -0700
Message-ID: <200708232131.l7NLVsGa027871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39443 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761474AbXHWVcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 17:32:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_it821x: fix regression/corruptor
has been added to the -mm tree.  Its filename is
     pata_it821x-fix-regression-corruptor.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_sis-add-the-fsc-amilo-and-friends.patch
pata_via-add-armia-w730-k8-and-other-rebadgings.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
pata_it821x-fix-regression-corruptor.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
char-cyclades-remove-bottom-half-processing.patch
