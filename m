From: akpm@linux-foundation.org
Subject: - paride-push-ioctl-down-into-driver.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:36 -0700
Message-ID: <200807112351.m6BNpa6R011055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758809AbYGKXw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     paride: push ioctl down into driver
has been removed from the -mm tree.  Its filename was
     paride-push-ioctl-down-into-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: paride: push ioctl down into driver
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Leaves us with lock_krnel for two methods.  Also remove a bogus printk
with no printk level and return -ENOTTY not -EINVAL for correctness.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pt.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/block/paride/pt.c~paride-push-ioctl-down-into-driver drivers/block/paride/pt.c
--- a/drivers/block/paride/pt.c~paride-push-ioctl-down-into-driver
+++ a/drivers/block/paride/pt.c
@@ -190,8 +190,7 @@ module_param_array(drive3, int, NULL, 0)
 #define ATAPI_LOG_SENSE		0x4d
 
 static int pt_open(struct inode *inode, struct file *file);
-static int pt_ioctl(struct inode *inode, struct file *file,
-		    unsigned int cmd, unsigned long arg);
+static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 static int pt_release(struct inode *inode, struct file *file);
 static ssize_t pt_read(struct file *filp, char __user *buf,
 		       size_t count, loff_t * ppos);
@@ -237,7 +236,7 @@ static const struct file_operations pt_f
 	.owner = THIS_MODULE,
 	.read = pt_read,
 	.write = pt_write,
-	.ioctl = pt_ioctl,
+	.unlocked_ioctl = pt_ioctl,
 	.open = pt_open,
 	.release = pt_release,
 };
@@ -691,8 +690,7 @@ out:
 	return err;
 }
 
-static int pt_ioctl(struct inode *inode, struct file *file,
-	 unsigned int cmd, unsigned long arg)
+static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct pt_unit *tape = file->private_data;
 	struct mtop __user *p = (void __user *)arg;
@@ -706,23 +704,26 @@ static int pt_ioctl(struct inode *inode,
 		switch (mtop.mt_op) {
 
 		case MTREW:
+			lock_kernel();
 			pt_rewind(tape);
+			unlock_kernel();
 			return 0;
 
 		case MTWEOF:
+			lock_kernel();
 			pt_write_fm(tape);
+			unlock_kernel();
 			return 0;
 
 		default:
-			printk("%s: Unimplemented mt_op %d\n", tape->name,
+			/* FIXME: rate limit ?? */
+			printk(KERN_DEBUG "%s: Unimplemented mt_op %d\n", tape->name,
 			       mtop.mt_op);
 			return -EINVAL;
 		}
 
 	default:
-		printk("%s: Unimplemented ioctl 0x%x\n", tape->name, cmd);
-		return -EINVAL;
-
+		return -ENOTTY;
 	}
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl-fix.patch
pcwd-a-couple-of-watchdogs-escaped-conversion.patch
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
sdio-fix-break-control-to-now-return-success-or-an-error.patch
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

