From: akpm@linux-foundation.org
Subject: + fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch added to -mm tree
Date: Wed, 22 Aug 2007 16:43:04 -0700
Message-ID: <200708222343.l7MNh4Jd010912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763032AbXHVXng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 19:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, gregkh@suse.de, tv@beamnet.de


The patch titled
     oti6858: Remove broken ioctl code in -mm tree and also the broken fixes
has been added to the -mm tree.  Its filename is
     fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oti6858: Remove broken ioctl code in -mm tree and also the broken fixes
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This stuff is simply not needed.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Thomas Viehmann <tv@beamnet.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/oti6858.c |   15 ---------------
 1 files changed, 15 deletions(-)

diff -puN drivers/usb/serial/oti6858.c~fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling drivers/usb/serial/oti6858.c
--- a/drivers/usb/serial/oti6858.c~fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling
+++ a/drivers/usb/serial/oti6858.c
@@ -817,21 +817,6 @@ static int oti6858_ioctl(struct usb_seri
 				__FUNCTION__, port->number, cmd, arg);
 
 	switch (cmd) {
-		case TCGETS:
-			if (kernel_termios_to_user_termios((struct ktermios __user *)arg,
-							   port->tty->termios))
-				return -EFAULT;
-			return 0;
-
-		case TCSETS:
-		case TCSETSW:	/* FIXME: this is not the same! */
-		case TCSETSF:	/* FIXME: this is not the same! */
-			if (user_termios_to_kernel_termios(port->tty->termios,
-						(struct ktermios __user *)arg))
-				return -EFAULT;
-			oti6858_set_termios(port, NULL);
-			return 0;
-
 		case TCFLSH:
 			/* FIXME */
 			return 0;
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
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
char-cyclades-remove-bottom-half-processing.patch
