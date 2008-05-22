From: akpm@linux-foundation.org
Subject: + dsp56k-bkl-pushdown.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:24 -0700
Message-ID: <200805222316.m4MNGOLi026606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbYEVXQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     dsp56k: BKL pushdown
has been added to the -mm tree.  Its filename is
     dsp56k-bkl-pushdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dsp56k: BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Push the BKL down into the driver ioctl methods

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/dsp56k.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff -puN drivers/char/dsp56k.c~dsp56k-bkl-pushdown drivers/char/dsp56k.c
--- a/drivers/char/dsp56k.c~dsp56k-bkl-pushdown
+++ a/drivers/char/dsp56k.c
@@ -34,10 +34,10 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/smp_lock.h>
+#include <linux/uaccess.h>	/* For put_user and get_user */
 
 #include <asm/atarihw.h>
 #include <asm/traps.h>
-#include <asm/uaccess.h>	/* For put_user and get_user */
 
 #include <asm/dsp56k.h>
 
@@ -322,8 +322,8 @@ static ssize_t dsp56k_write(struct file 
 	}
 }
 
-static int dsp56k_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long dsp56k_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int dev = iminor(inode) & 0x0f;
 	void __user *argp = (void __user *)arg;
@@ -350,8 +350,9 @@ static int dsp56k_ioctl(struct inode *in
 			if (len > DSP56K_MAX_BINARY_LENGTH) {
 				return -EINVAL;
 			}
-    
+			lock_kernel();
 			r = dsp56k_upload(bin, len);
+			unlock_kernel();
 			if (r < 0) {
 				return r;
 			}
@@ -361,12 +362,16 @@ static int dsp56k_ioctl(struct inode *in
 		case DSP56K_SET_TX_WSIZE:
 			if (arg > 4 || arg < 1)
 				return -EINVAL;
+			lock_kernel();
 			dsp56k.tx_wsize = (int) arg;
+			unlock_kernel();
 			break;
 		case DSP56K_SET_RX_WSIZE:
 			if (arg > 4 || arg < 1)
 				return -EINVAL;
+			lock_kernel();
 			dsp56k.rx_wsize = (int) arg;
+			unlock_kernel();
 			break;
 		case DSP56K_HOST_FLAGS:
 		{
@@ -378,6 +383,7 @@ static int dsp56k_ioctl(struct inode *in
 			if(get_user(out, &hf->out) < 0)
 				return -EFAULT;
 
+			lock_kernel();
 			if ((dir & 0x1) && (out & 0x1))
 				dsp56k_host_interface.icr |= DSP56K_ICR_HF0;
 			else if (dir & 0x1)
@@ -392,14 +398,16 @@ static int dsp56k_ioctl(struct inode *in
 			if (dsp56k_host_interface.icr & DSP56K_ICR_HF1) status |= 0x2;
 			if (dsp56k_host_interface.isr & DSP56K_ISR_HF2) status |= 0x4;
 			if (dsp56k_host_interface.isr & DSP56K_ISR_HF3) status |= 0x8;
-
+			unlock_kernel();
 			return put_user(status, &hf->status);
 		}
 		case DSP56K_HOST_CMD:
 			if (arg > 31 || arg < 0)
 				return -EINVAL;
+			lock_kernel();
 			dsp56k_host_interface.cvr = (u_char)((arg & DSP56K_CVR_HV_MASK) |
 							     DSP56K_CVR_HC);
+			unlock_kernel();
 			break;
 		default:
 			return -EINVAL;
@@ -491,7 +499,7 @@ static const struct file_operations dsp5
 	.owner		= THIS_MODULE,
 	.read		= dsp56k_read,
 	.write		= dsp56k_write,
-	.ioctl		= dsp56k_ioctl,
+	.unlocked_ioctl	= dsp56k_ioctl,
 	.open		= dsp56k_open,
 	.release	= dsp56k_release,
 };
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
paride-push-ioctl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
pcwd-a-couple-of-watchdogs-escaped-conversion.patch
dac960-push-down-bkl.patch
cm4000_cs-switch-to-unlocked_ioctl.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
snapshot-push-bkl-down-into-ioctl-handlers.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
lcd-push-the-bkl-down-into-the-driver-ioctl-handler.patch

