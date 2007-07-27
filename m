From: akpm@linux-foundation.org
Subject: + kl5kusb105-switch-to-new-speed-api.patch added to -mm tree
Date: Thu, 26 Jul 2007 22:56:40 -0700
Message-ID: <200707270556.l6R5ueth008352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758276AbXG0F47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 01:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     kl5kusb105: witch to new speed API
has been added to the -mm tree.  Its filename is
     kl5kusb105-switch-to-new-speed-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kl5kusb105: witch to new speed API
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/kl5kusb105.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN drivers/usb/serial/kl5kusb105.c~kl5kusb105-switch-to-new-speed-api drivers/usb/serial/kl5kusb105.c
--- a/drivers/usb/serial/kl5kusb105.c~kl5kusb105-switch-to-new-speed-api
+++ a/drivers/usb/serial/kl5kusb105.c
@@ -728,24 +728,32 @@ static void klsi_105_set_termios (struct
 #endif
 		}
 		
-		switch(cflag & CBAUD) {
-		case B0: /* handled below */
+		switch(tty_get_baud_rate(port->tty)) {
+		case 0: /* handled below */
 			break;
-		case B1200: priv->cfg.baudrate = kl5kusb105a_sio_b1200;
+		case 1200:
+			priv->cfg.baudrate = kl5kusb105a_sio_b1200;
 			break;
-		case B2400: priv->cfg.baudrate = kl5kusb105a_sio_b2400;
+		case 2400:
+			priv->cfg.baudrate = kl5kusb105a_sio_b2400;
 			break;
-		case B4800: priv->cfg.baudrate = kl5kusb105a_sio_b4800;
+		case 4800:
+			priv->cfg.baudrate = kl5kusb105a_sio_b4800;
 			break;
-		case B9600: priv->cfg.baudrate = kl5kusb105a_sio_b9600;
+		case 9600:
+			priv->cfg.baudrate = kl5kusb105a_sio_b9600;
 			break;
-		case B19200: priv->cfg.baudrate = kl5kusb105a_sio_b19200;
+		case 19200:
+			priv->cfg.baudrate = kl5kusb105a_sio_b19200;
 			break;
-		case B38400: priv->cfg.baudrate = kl5kusb105a_sio_b38400;
+		case 38400:
+			priv->cfg.baudrate = kl5kusb105a_sio_b38400;
 			break;
-		case B57600: priv->cfg.baudrate = kl5kusb105a_sio_b57600;
+		case 57600:
+			priv->cfg.baudrate = kl5kusb105a_sio_b57600;
 			break;
-		case B115200: priv->cfg.baudrate = kl5kusb105a_sio_b115200;
+		case 115200:
+			priv->cfg.baudrate = kl5kusb105a_sio_b115200;
 			break;
 		default:
 			err("KLSI USB->Serial converter:"
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
drivers-edac-fix-reset-edac_mc-pollmsec.patch
drivers-edac-fix-edac_pci-sysfs.patch
include-asm-mips-add-missing-edac-h-file.patch
drivers-edac-fix-pasemi-kconfig-depends.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
nozomi-shoot-defunct-label.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-sff-unbreak-non-dma-capable-controllers-again.patch
pata_cmd64x-correct-the-speed-ranges.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
lib8390-comment-on-locking-by-alan-cox.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
git-scsi-rc-fixes.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
digi_acceleport-drag-the-driver-kicking-and-screaming-into.patch
kl5kusb105-switch-to-new-speed-api.patch
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
