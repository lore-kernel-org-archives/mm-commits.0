From: akpm@linux-foundation.org
Subject: - misc-phantom-move-to-unlocked_ioctl.patch removed from -mm tree
Date: Tue, 29 May 2007 11:52:04 -0700
Message-ID: <200705291852.l4TIq3Ip008373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757952AbXE2Swi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, xslaby@phantom.fi.muni.cz, mm-commits@vger.kernel.org


The patch titled
     phantom: move to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     misc-phantom-move-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: phantom: move to unlocked_ioctl
From: Jiri Slaby <jirislaby@gmail.com>

phantom's ioctl is often (4000 times a sec or so) invoked, don't acquire
BKL and block other processes.

Signed-off-by: Jiri Slaby <xslaby@phantom.fi.muni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff -puN drivers/misc/phantom.c~misc-phantom-move-to-unlocked_ioctl drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-phantom-move-to-unlocked_ioctl
+++ a/drivers/misc/phantom.c
@@ -47,6 +47,7 @@ struct phantom_device {
 	struct cdev cdev;
 
 	struct mutex open_lock;
+	spinlock_t ioctl_lock;
 };
 
 static unsigned char phantom_devices[PHANTOM_MAX_MINORS];
@@ -71,8 +72,8 @@ static int phantom_status(struct phantom
  * File ops
  */
 
-static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
-	u_long arg)
+static long phantom_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
 {
 	struct phantom_device *dev = file->private_data;
 	struct phm_regs rs;
@@ -92,24 +93,30 @@ static int phantom_ioctl(struct inode *i
 		if (r.reg > 7)
 			return -EINVAL;
 
+		spin_lock(&dev->ioctl_lock);
 		if (r.reg == PHN_CONTROL && (r.value & PHN_CTL_IRQ) &&
-				phantom_status(dev, dev->status | PHB_RUNNING))
+				phantom_status(dev, dev->status | PHB_RUNNING)){
+			spin_unlock(&dev->ioctl_lock);
 			return -ENODEV;
+		}
 
 		pr_debug("phantom: writing %x to %u\n", r.value, r.reg);
 		iowrite32(r.value, dev->iaddr + r.reg);
 
 		if (r.reg == PHN_CONTROL && !(r.value & PHN_CTL_IRQ))
 			phantom_status(dev, dev->status & ~PHB_RUNNING);
+		spin_unlock(&dev->ioctl_lock);
 		break;
 	case PHN_SET_REGS:
 		if (copy_from_user(&rs, argp, sizeof(rs)))
 			return -EFAULT;
 
 		pr_debug("phantom: SRS %u regs %x\n", rs.count, rs.mask);
+		spin_lock(&dev->ioctl_lock);
 		for (i = 0; i < min(rs.count, 8U); i++)
 			if ((1 << i) & rs.mask)
 				iowrite32(rs.values[i], dev->oaddr + i);
+		spin_unlock(&dev->ioctl_lock);
 		break;
 	case PHN_GET_REG:
 		if (copy_from_user(&r, argp, sizeof(r)))
@@ -128,9 +135,11 @@ static int phantom_ioctl(struct inode *i
 			return -EFAULT;
 
 		pr_debug("phantom: GRS %u regs %x\n", rs.count, rs.mask);
+		spin_lock(&dev->ioctl_lock);
 		for (i = 0; i < min(rs.count, 8U); i++)
 			if ((1 << i) & rs.mask)
 				rs.values[i] = ioread32(dev->iaddr + i);
+		spin_unlock(&dev->ioctl_lock);
 
 		if (copy_to_user(argp, &rs, sizeof(rs)))
 			return -EFAULT;
@@ -199,7 +208,7 @@ static unsigned int phantom_poll(struct 
 static struct file_operations phantom_file_ops = {
 	.open = phantom_open,
 	.release = phantom_release,
-	.ioctl = phantom_ioctl,
+	.unlocked_ioctl = phantom_ioctl,
 	.poll = phantom_poll,
 };
 
@@ -282,6 +291,7 @@ static int __devinit phantom_probe(struc
 	}
 
 	mutex_init(&pht->open_lock);
+	spin_lock_init(&pht->ioctl_lock);
 	init_waitqueue_head(&pht->wait);
 	cdev_init(&pht->cdev, &phantom_file_ops);
 	pht->cdev.owner = THIS_MODULE;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
shrink_slab-handle-bad-shrinkers.patch
