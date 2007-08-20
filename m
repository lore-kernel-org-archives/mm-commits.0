From: akpm@linux-foundation.org
Subject: - kl5kusb105-switch-to-new-speed-api.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:42 -0700
Message-ID: <200708201913.l7KJDgP2018466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760360AbXHTTV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     kl5kusb105: witch to new speed API
has been removed from the -mm tree.  Its filename was
     kl5kusb105-switch-to-new-speed-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kl5kusb105: witch to new speed API
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/kl5kusb105.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

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
