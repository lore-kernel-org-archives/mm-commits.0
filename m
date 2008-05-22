From: akpm@linux-foundation.org
Subject: + pktcdvd-push-bkl-down-into-driver.patch added to -mm tree
Date: Thu, 22 May 2008 16:15:54 -0700
Message-ID: <200805222315.m4MNFs2b026487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986AbYEVXRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:17:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jens.axboe@oracle.com, petero2@telia.com


The patch titled
     pktcdvd: push BKL down into driver
has been added to the -mm tree.  Its filename is
     pktcdvd-push-bkl-down-into-driver.patch

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
Subject: pktcdvd: push BKL down into driver
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Push the lock_kernel down into the driver and switch to unlocked_ioctl

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-push-bkl-down-into-driver drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-push-bkl-down-into-driver
+++ a/drivers/block/pktcdvd.c
@@ -2798,9 +2798,14 @@ out_mem:
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
 
@@ -2813,7 +2818,8 @@ static int pkt_ioctl(struct inode *inode
 	case CDROM_LAST_WRITTEN:
 	case CDROM_SEND_PACKET:
 	case SCSI_IOCTL_SEND_COMMAND:
-		return blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);
+		ret = blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);
+		break;
 
 	case CDROMEJECT:
 		/*
@@ -2822,14 +2828,15 @@ static int pkt_ioctl(struct inode *inode
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
@@ -2851,7 +2858,7 @@ static struct block_device_operations pk
 	.owner =		THIS_MODULE,
 	.open =			pkt_open,
 	.release =		pkt_close,
-	.ioctl =		pkt_ioctl,
+	.unlocked_ioctl =	pkt_ioctl,
 	.media_changed =	pkt_media_changed,
 };
 
@@ -3016,7 +3023,8 @@ static void pkt_get_status(struct pkt_ct
 	mutex_unlock(&ctl_mutex);
 }
 
-static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long pkt_ctl_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct pkt_ctrl_command ctrl_cmd;
@@ -3033,16 +3041,22 @@ static int pkt_ctl_ioctl(struct inode *i
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
@@ -3055,7 +3069,7 @@ static int pkt_ctl_ioctl(struct inode *i
 
 
 static const struct file_operations pkt_ctl_fops = {
-	.ioctl	 = pkt_ctl_ioctl,
+	.unlocked_ioctl	 = pkt_ctl_ioctl,
 	.owner	 = THIS_MODULE,
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

