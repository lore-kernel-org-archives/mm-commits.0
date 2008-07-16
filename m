From: akpm@linux-foundation.org
Subject: - pcwd-a-couple-of-watchdogs-escaped-conversion.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:29 -0700
Message-ID: <200807162137.m6GLbTG4014389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757425AbYGPVi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     pcwd: a couple of watchdogs escaped conversion
has been removed from the -mm tree.  Its filename was
     pcwd-a-couple-of-watchdogs-escaped-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcwd: a couple of watchdogs escaped conversion
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Fix them up.  Once we know the long term plan the watchdogs can all get
shrunk massively anyway

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/pcwd_pci.c |    8 +++-----
 drivers/watchdog/pcwd_usb.c |    6 +++---
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/watchdog/pcwd_pci.c~pcwd-a-couple-of-watchdogs-escaped-conversion drivers/watchdog/pcwd_pci.c
--- a/drivers/watchdog/pcwd_pci.c~pcwd-a-couple-of-watchdogs-escaped-conversion
+++ a/drivers/watchdog/pcwd_pci.c
@@ -455,8 +455,8 @@ static ssize_t pcipcwd_write(struct file
 	return len;
 }
 
-static int pcipcwd_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long pcipcwd_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -478,9 +478,7 @@ static int pcipcwd_ioctl(struct inode *i
 		case WDIOC_GETSTATUS:
 		{
 			int status;
-
 			pcipcwd_get_status(&status);
-
 			return put_user(status, p);
 		}
 
@@ -644,7 +642,7 @@ static const struct file_operations pcip
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.write =	pcipcwd_write,
-	.ioctl =	pcipcwd_ioctl,
+	.unlocked_ioctl = pcipcwd_ioctl,
 	.open =		pcipcwd_open,
 	.release =	pcipcwd_release,
 };
diff -puN drivers/watchdog/pcwd_usb.c~pcwd-a-couple-of-watchdogs-escaped-conversion drivers/watchdog/pcwd_usb.c
--- a/drivers/watchdog/pcwd_usb.c~pcwd-a-couple-of-watchdogs-escaped-conversion
+++ a/drivers/watchdog/pcwd_usb.c
@@ -369,8 +369,8 @@ static ssize_t usb_pcwd_write(struct fil
 	return len;
 }
 
-static int usb_pcwd_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long usb_pcwd_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -535,7 +535,7 @@ static const struct file_operations usb_
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.write =	usb_pcwd_write,
-	.ioctl =	usb_pcwd_ioctl,
+	.unlocked_ioctl = usb_pcwd_ioctl,
 	.open =		usb_pcwd_open,
 	.release =	usb_pcwd_release,
 };
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl-fix.patch
generic-irqs-enable-polling-for-disabled-screaming-irqs.patch
8250-fix-break-handling-for-intel-82571.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
cpm1-dont-send-break-on-tx_stop-dont-interrupt-rx-tx-when-adjusting-termios-parameters.patch
spidev-bkl-removal.patch
vt-hold-console_sem-across-sysfs-operations.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch
rtc-remove-bkl-for-ioctl.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
char-isicom-enable-disable-pci-device.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch

