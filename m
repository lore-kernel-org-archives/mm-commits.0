From: akpm@linux-foundation.org
Subject: - pktcdvd-push-bkl-down-into-driver.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:38 -0700
Message-ID: <200807112351.m6BNpc2k011058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322AbYGKXw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jens.axboe@oracle.com, petero2@telia.com, mm-commits@vger.kernel.org


The patch titled
     pktcdvd: push BKL down into driver
has been removed from the -mm tree.  Its filename was
     pktcdvd-push-bkl-down-into-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pktcdvd: push BKL down into driver
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Push the lock_kernel down into the driver and switch to unlocked_ioctl

[akpm@linux-foundation.org: build fix]
Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Peter Osterlund <petero2@telia.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-push-bkl-down-into-driver drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-push-bkl-down-into-driver
+++ a/drivers/block/pktcdvd.c
@@ -49,6 +49,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
+#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/spinlock.h>
 #include <linux/file.h>
@@ -2799,9 +2800,14 @@ out_mem:
 	return ret;
 }
 
-static int pkt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long pkt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct pktcdvd_device *pd = inode->i_bdev->bd_disk->private_data;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct pktcdvd_device *pd;
+	long ret;
+
+	lock_kernel();
+	pd = inode->i_bdev->bd_disk->private_data;
 
 	VPRINTK("pkt_ioctl: cmd %x, dev %d:%d\n", cmd, imajor(inode), iminor(inode));
 
@@ -2814,7 +2820,8 @@ static int pkt_ioctl(struct inode *inode
 	case CDROM_LAST_WRITTEN:
 	case CDROM_SEND_PACKET:
 	case SCSI_IOCTL_SEND_COMMAND:
-		return blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);
+		ret = blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);
+		break;
 
 	case CDROMEJECT:
 		/*
@@ -2823,14 +2830,15 @@ static int pkt_ioctl(struct inode *inode
 		 */
 		if (pd->refcnt == 1)
 			pkt_lock_door(pd, 0);
-		return blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);
+		ret = blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);
+		break;
 
 	default:
 		VPRINTK(DRIVER_NAME": Unknown ioctl for %s (%x)\n", pd->name, cmd);
-		return -ENOTTY;
+		ret = -ENOTTY;
 	}
-
-	return 0;
+	unlock_kernel();
+	return ret;
 }
 
 static int pkt_media_changed(struct gendisk *disk)
@@ -2852,7 +2860,7 @@ static struct block_device_operations pk
 	.owner =		THIS_MODULE,
 	.open =			pkt_open,
 	.release =		pkt_close,
-	.ioctl =		pkt_ioctl,
+	.unlocked_ioctl =	pkt_ioctl,
 	.media_changed =	pkt_media_changed,
 };
 
@@ -3017,7 +3025,8 @@ static void pkt_get_status(struct pkt_ct
 	mutex_unlock(&ctl_mutex);
 }
 
-static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long pkt_ctl_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct pkt_ctrl_command ctrl_cmd;
@@ -3034,16 +3043,22 @@ static int pkt_ctl_ioctl(struct inode *i
 	case PKT_CTRL_CMD_SETUP:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
+		lock_kernel();
 		ret = pkt_setup_dev(new_decode_dev(ctrl_cmd.dev), &pkt_dev);
 		ctrl_cmd.pkt_dev = new_encode_dev(pkt_dev);
+		unlock_kernel();
 		break;
 	case PKT_CTRL_CMD_TEARDOWN:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
+		lock_kernel();
 		ret = pkt_remove_dev(new_decode_dev(ctrl_cmd.pkt_dev));
+		unlock_kernel();
 		break;
 	case PKT_CTRL_CMD_STATUS:
+		lock_kernel();
 		pkt_get_status(&ctrl_cmd);
+		unlock_kernel();
 		break;
 	default:
 		return -ENOTTY;
@@ -3056,7 +3071,7 @@ static int pkt_ctl_ioctl(struct inode *i
 
 
 static const struct file_operations pkt_ctl_fops = {
-	.ioctl	 = pkt_ctl_ioctl,
+	.unlocked_ioctl	 = pkt_ctl_ioctl,
 	.owner	 = THIS_MODULE,
 };
 
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

