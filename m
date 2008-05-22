From: akpm@linux-foundation.org
Subject: + ip2-push-bkl-down-for-the-firmware-interface.patch added to -mm tree
Date: Thu, 22 May 2008 16:15:58 -0700
Message-ID: <200805222315.m4MNFwdq026495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757142AbYEVXQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     ip2: push BKL down for the firmware interface
has been added to the -mm tree.  Its filename is
     ip2-push-bkl-down-for-the-firmware-interface.patch

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
Subject: ip2: push BKL down for the firmware interface
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

(The tty side is already done)

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~ip2-push-bkl-down-for-the-firmware-interface drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~ip2-push-bkl-down-for-the-firmware-interface
+++ a/drivers/char/ip2/ip2main.c
@@ -203,7 +203,7 @@ static int set_serial_info(i2ChanStrPtr,
 
 static ssize_t ip2_ipl_read(struct file *, char __user *, size_t, loff_t *);
 static ssize_t ip2_ipl_write(struct file *, const char __user *, size_t, loff_t *);
-static int ip2_ipl_ioctl(struct inode *, struct file *, UINT, ULONG);
+static long ip2_ipl_ioctl(struct file *, UINT, ULONG);
 static int ip2_ipl_open(struct inode *, struct file *);
 
 static int DumpTraceBuffer(char __user *, int);
@@ -236,7 +236,7 @@ static const struct file_operations ip2_
 	.owner		= THIS_MODULE,
 	.read		= ip2_ipl_read,
 	.write		= ip2_ipl_write,
-	.ioctl		= ip2_ipl_ioctl,
+	.unlocked_ioctl	= ip2_ipl_ioctl,
 	.open		= ip2_ipl_open,
 }; 
 
@@ -2819,10 +2819,10 @@ ip2_ipl_write(struct file *pFile, const 
 /*                                                                            */
 /*                                                                            */
 /******************************************************************************/
-static int
-ip2_ipl_ioctl ( struct inode *pInode, struct file *pFile, UINT cmd, ULONG arg )
+static long
+ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
 {
-	unsigned int iplminor = iminor(pInode);
+	unsigned int iplminor = iminor(pFile->f_path.dentry->d_inode);
 	int rc = 0;
 	void __user *argp = (void __user *)arg;
 	ULONG __user *pIndex = argp;
@@ -2833,6 +2833,8 @@ ip2_ipl_ioctl ( struct inode *pInode, st
 	printk (KERN_DEBUG "IP2IPL: ioctl cmd %d, arg %ld\n", cmd, arg );
 #endif
 
+	lock_kernel();
+
 	switch ( iplminor ) {
 	case 0:	    // IPL device
 		rc = -EINVAL;
@@ -2893,6 +2895,7 @@ ip2_ipl_ioctl ( struct inode *pInode, st
 		rc = -ENODEV;
 		break;
 	}
+	unlock_kernel();
 	return rc;
 }
 
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

