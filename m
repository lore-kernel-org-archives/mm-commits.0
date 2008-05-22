From: akpm@linux-foundation.org
Subject: + cm4000_cs-switch-to-unlocked_ioctl.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:14 -0700
Message-ID: <200805222316.m4MNGEp8026594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbYEVXQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:16:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, laforge@gnumonks.org, linux@dominikbrodowski.net


The patch titled
     cm4000_cs: switch to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     cm4000_cs-switch-to-unlocked_ioctl.patch

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
Subject: cm4000_cs: switch to unlocked_ioctl
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Gack....

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/cm4000_cs.c |   92 ++++++++++++++++++------------
 1 file changed, 56 insertions(+), 36 deletions(-)

diff -puN drivers/char/pcmcia/cm4000_cs.c~cm4000_cs-switch-to-unlocked_ioctl drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~cm4000_cs-switch-to-unlocked_ioctl
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -33,8 +33,8 @@
 #include <linux/delay.h>
 #include <linux/bitrev.h>
 #include <linux/smp_lock.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
@@ -1406,11 +1406,11 @@ static void stop_monitor(struct cm4000_d
 	DEBUGP(3, dev, "<- stop_monitor\n");
 }
 
-static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		     unsigned long arg)
+static long cmm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct cm4000_dev *dev = filp->private_data;
 	unsigned int iobase = dev->p_dev->io.BasePort1;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct pcmcia_device *link;
 	int size;
 	int rc;
@@ -1427,38 +1427,42 @@ static int cmm_ioctl(struct inode *inode
 	DEBUGP(3, dev, "cmm_ioctl(device=%d.%d) %s\n", imajor(inode),
 	       iminor(inode), ioctl_names[_IOC_NR(cmd)]);
 
+	lock_kernel();
+	rc = -ENODEV;
 	link = dev_table[iminor(inode)];
 	if (!pcmcia_dev_present(link)) {
 		DEBUGP(4, dev, "DEV_OK false\n");
-		return -ENODEV;
+		goto out;
 	}
 
 	if (test_bit(IS_CMM_ABSENT, &dev->flags)) {
 		DEBUGP(4, dev, "CMM_ABSENT flag set\n");
-		return -ENODEV;
+		goto out;
 	}
+	rc = EINVAL;
 
 	if (_IOC_TYPE(cmd) != CM_IOC_MAGIC) {
 		DEBUGP(4, dev, "ioctype mismatch\n");
-		return -EINVAL;
+		goto out;
 	}
 	if (_IOC_NR(cmd) > CM_IOC_MAXNR) {
 		DEBUGP(4, dev, "iocnr mismatch\n");
-		return -EINVAL;
+		goto out;
 	}
 	size = _IOC_SIZE(cmd);
-	rc = 0;
+	rc = -EFAULT;
 	DEBUGP(4, dev, "iocdir=%.4x iocr=%.4x iocw=%.4x iocsize=%d cmd=%.4x\n",
 	      _IOC_DIR(cmd), _IOC_READ, _IOC_WRITE, size, cmd);
 
 	if (_IOC_DIR(cmd) & _IOC_READ) {
 		if (!access_ok(VERIFY_WRITE, argp, size))
-			return -EFAULT;
+			goto out;
 	}
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
 		if (!access_ok(VERIFY_READ, argp, size))
-			return -EFAULT;
+			goto out;
 	}
+	rc = 0;
 
 	switch (cmd) {
 	case CM_IOCGSTATUS:
@@ -1478,9 +1482,9 @@ static int cmm_ioctl(struct inode *inode
 			if (test_bit(IS_BAD_CARD, &dev->flags))
 				status |= CM_BAD_CARD;
 			if (copy_to_user(argp, &status, sizeof(int)))
-				return -EFAULT;
+				rc = -EFAULT;
 		}
-		return 0;
+		break;
 	case CM_IOCGATR:
 		DEBUGP(4, dev, "... in CM_IOCGATR\n");
 		{
@@ -1493,25 +1497,29 @@ static int cmm_ioctl(struct inode *inode
 			      || (test_bit(IS_ATR_PRESENT, (void *)&dev->flags)
 				  != 0)))) {
 				if (filp->f_flags & O_NONBLOCK)
-					return -EAGAIN;
-				return -ERESTARTSYS;
+					rc = -EAGAIN;
+				else
+					rc = -ERESTARTSYS;
+				break;
 			}
 
+			rc = -EFAULT;
 			if (test_bit(IS_ATR_VALID, &dev->flags) == 0) {
 				tmp = -1;
 				if (copy_to_user(&(atreq->atr_len), &tmp,
 						 sizeof(int)))
-					return -EFAULT;
+					break;
 			} else {
 				if (copy_to_user(atreq->atr, dev->atr,
 						 dev->atr_len))
-					return -EFAULT;
+					break;
 
 				tmp = dev->atr_len;
 				if (copy_to_user(&(atreq->atr_len), &tmp, sizeof(int)))
-					return -EFAULT;
+					break;
 			}
-			return 0;
+			rc = 0;
+			break;
 		}
 	case CM_IOCARDOFF:
 
@@ -1539,8 +1547,10 @@ static int cmm_ioctl(struct inode *inode
 			      || (test_and_set_bit(LOCK_IO, (void *)&dev->flags)
 				  == 0)))) {
 				if (filp->f_flags & O_NONBLOCK)
-					return -EAGAIN;
-				return -ERESTARTSYS;
+					rc = -EAGAIN;
+				else
+					rc = -ERESTARTSYS;
+				break;
 			}
 			/* Set Flags0 = 0x42 */
 			DEBUGP(4, dev, "Set Flags0=0x42 \n");
@@ -1555,8 +1565,10 @@ static int cmm_ioctl(struct inode *inode
 			      || (test_bit(IS_ATR_VALID, (void *)&dev->flags) !=
 				  0)))) {
 				if (filp->f_flags & O_NONBLOCK)
-					return -EAGAIN;
-				return -ERESTARTSYS;
+					rc = -EAGAIN;
+				else
+					rc = -ERESTARTSYS;
+				break;
 			}
 		}
 		/* release lock */
@@ -1569,8 +1581,10 @@ static int cmm_ioctl(struct inode *inode
 			struct ptsreq krnptsreq;
 
 			if (copy_from_user(&krnptsreq, argp,
-					   sizeof(struct ptsreq)))
-				return -EFAULT;
+					   sizeof(struct ptsreq))) {
+				rc = -EFAULT;
+				break;
+			}
 
 			rc = 0;
 			DEBUGP(4, dev, "... in CM_IOCSPTS\n");
@@ -1581,8 +1595,10 @@ static int cmm_ioctl(struct inode *inode
 			      || (test_bit(IS_ATR_PRESENT, (void *)&dev->flags)
 				  != 0)))) {
 				if (filp->f_flags & O_NONBLOCK)
-					return -EAGAIN;
-				return -ERESTARTSYS;
+					rc = -EAGAIN;
+				else
+					rc = -ERESTARTSYS;
+				break;
 			}
 			/* get IO lock */
 			if (wait_event_interruptible
@@ -1591,8 +1607,10 @@ static int cmm_ioctl(struct inode *inode
 			      || (test_and_set_bit(LOCK_IO, (void *)&dev->flags)
 				  == 0)))) {
 				if (filp->f_flags & O_NONBLOCK)
-					return -EAGAIN;
-				return -ERESTARTSYS;
+					rc = -EAGAIN;
+				else
+					rc = -ERESTARTSYS;
+				break;
 			}
 
 			if ((rc = set_protocol(dev, &krnptsreq)) != 0) {
@@ -1605,7 +1623,7 @@ static int cmm_ioctl(struct inode *inode
 			wake_up_interruptible(&dev->ioq);
 
 		}
-		return rc;
+		break;
 #ifdef PCMCIA_DEBUG
 	case CM_IOSDBGLVL:	/* set debug log level */
 		{
@@ -1613,18 +1631,20 @@ static int cmm_ioctl(struct inode *inode
 
 			old_pc_debug = pc_debug;
 			if (copy_from_user(&pc_debug, argp, sizeof(int)))
-				return -EFAULT;
-
-			if (old_pc_debug != pc_debug)
+				rc = -EFAULT;
+			else if (old_pc_debug != pc_debug)
 				DEBUGP(0, dev, "Changed debug log level "
 				       "to %i\n", pc_debug);
 		}
-		return rc;
+		break;
 #endif
 	default:
 		DEBUGP(4, dev, "... in default (unknown IOCTL code)\n");
-		return -EINVAL;
+		rc = -ENOTTY;
 	}
+out:
+	unlock_kernel();
+	return rc;
 }
 
 static int cmm_open(struct inode *inode, struct file *filp)
@@ -1909,7 +1929,7 @@ static const struct file_operations cm40
 	.owner	= THIS_MODULE,
 	.read	= cmm_read,
 	.write	= cmm_write,
-	.ioctl	= cmm_ioctl,
+	.unlocked_ioctl	= cmm_ioctl,
 	.open	= cmm_open,
 	.release= cmm_close,
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

