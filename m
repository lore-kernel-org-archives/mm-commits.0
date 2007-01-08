From: akpm@osdl.org
Subject: + really-fix-funsoft-driver.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:48:17 -0800
Message-ID: <200701082348.l08NmHhZ023090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55332 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbXAHXsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:48:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, greg@kroah.com


The patch titled
     really fix funsoft driver
has been added to the -mm tree.  Its filename is
     really-fix-funsoft-driver.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: really fix funsoft driver
From: David Miller <davem@davemloft.net>

Fix void cast and re-enable on sparc.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/serial/Kconfig   |    2 +-
 drivers/usb/serial/funsoft.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/serial/Kconfig~really-fix-funsoft-driver drivers/usb/serial/Kconfig
--- a/drivers/usb/serial/Kconfig~really-fix-funsoft-driver
+++ a/drivers/usb/serial/Kconfig
@@ -170,7 +170,7 @@ config USB_SERIAL_FTDI_SIO
 
 config USB_SERIAL_FUNSOFT
 	tristate "USB Fundamental Software Dongle Driver"
-	depends on USB_SERIAL && !(SPARC || SPARC64)
+	depends on USB_SERIAL
 	---help---
 	  Say Y here if you want to use the Fundamental Software dongle.
 
diff -puN drivers/usb/serial/funsoft.c~really-fix-funsoft-driver drivers/usb/serial/funsoft.c
--- a/drivers/usb/serial/funsoft.c~really-fix-funsoft-driver
+++ a/drivers/usb/serial/funsoft.c
@@ -32,7 +32,7 @@ static int funsoft_ioctl(struct usb_seri
 	dbg("%s - port %d, cmd 0x%04x", __FUNCTION__, port->number, cmd);
 
 	if (cmd == TCSETSF) {
-		if (user_termios_to_kernel_termios(&t, (void __user *)arg))
+		if (user_termios_to_kernel_termios(&t, (struct termios __user *)arg))
 			return -EFAULT;
 
 		dbg("%s - iflag:%x oflag:%x cflag:%x lflag:%x", __FUNCTION__,
_

Patches currently in -mm which might be from davem@davemloft.net are

change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
really-fix-funsoft-driver.patch
infiniband-work-around-gcc-bug-on-sparc64.patch
git-net.patch
resend-iphase-64bit-cleanup.patch
scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
simplify-the-stacktrace-code.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
