From: akpm@linux-foundation.org
Subject: + sx-push-bkl-down-into-the-firmware-ioctl-handler.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:04 -0700
Message-ID: <200805222316.m4MNG4gY026577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757264AbYEVXQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     sx: push BKL down into the firmware ioctl handler
has been added to the -mm tree.  Its filename is
     sx-push-bkl-down-into-the-firmware-ioctl-handler.patch

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
Subject: sx: push BKL down into the firmware ioctl handler
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Also fix the capability checking for firmware load.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |   73 +++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff -puN drivers/char/sx.c~sx-push-bkl-down-into-the-firmware-ioctl-handler drivers/char/sx.c
--- a/drivers/char/sx.c~sx-push-bkl-down-into-the-firmware-ioctl-handler
+++ a/drivers/char/sx.c
@@ -287,8 +287,8 @@ static void sx_close(void *ptr);
 static int sx_chars_in_buffer(void *ptr);
 static int sx_init_board(struct sx_board *board);
 static int sx_init_portstructs(int nboards, int nports);
-static int sx_fw_ioctl(struct inode *inode, struct file *filp,
-		unsigned int cmd, unsigned long arg);
+static long sx_fw_ioctl(struct file *filp, unsigned int cmd,
+						unsigned long arg);
 static int sx_init_drivers(void);
 
 static struct tty_driver *sx_driver;
@@ -397,7 +397,7 @@ static struct real_driver sx_real_driver
 
 static const struct file_operations sx_fw_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = sx_fw_ioctl,
+	.unlocked_ioctl = sx_fw_ioctl,
 };
 
 static struct miscdevice sx_fw_device = {
@@ -1687,10 +1687,10 @@ static int do_memtest_w(struct sx_board 
 }
 #endif
 
-static int sx_fw_ioctl(struct inode *inode, struct file *filp,
-		unsigned int cmd, unsigned long arg)
+static long sx_fw_ioctl(struct file *filp, unsigned int cmd,
+							unsigned long arg)
 {
-	int rc = 0;
+	long rc = 0;
 	int __user *descr = (int __user *)arg;
 	int i;
 	static struct sx_board *board = NULL;
@@ -1700,13 +1700,10 @@ static int sx_fw_ioctl(struct inode *ino
 
 	func_enter();
 
-#if 0
-	/* Removed superuser check: Sysops can use the permissions on the device
-	   file to restrict access. Recommendation: Root only. (root.root 600) */
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	}
-#endif
+
+	lock_kernel();
 
 	sx_dprintk(SX_DEBUG_FIRMWARE, "IOCTL %x: %lx\n", cmd, arg);
 
@@ -1721,19 +1718,23 @@ static int sx_fw_ioctl(struct inode *ino
 		for (i = 0; i < SX_NBOARDS; i++)
 			sx_dprintk(SX_DEBUG_FIRMWARE, "<%x> ", boards[i].flags);
 		sx_dprintk(SX_DEBUG_FIRMWARE, "\n");
+		unlock_kernel();
 		return -EIO;
 	}
 
 	switch (cmd) {
 	case SXIO_SET_BOARD:
 		sx_dprintk(SX_DEBUG_FIRMWARE, "set board to %ld\n", arg);
+		rc = -EIO;
 		if (arg >= SX_NBOARDS)
-			return -EIO;
+			break;
 		sx_dprintk(SX_DEBUG_FIRMWARE, "not out of range\n");
 		if (!(boards[arg].flags & SX_BOARD_PRESENT))
-			return -EIO;
+			break;
 		sx_dprintk(SX_DEBUG_FIRMWARE, ".. and present!\n");
 		board = &boards[arg];
+		rc = 0;
+		/* FIXME: And this does ... nothing?? */
 		break;
 	case SXIO_GET_TYPE:
 		rc = -ENOENT;	/* If we manage to miss one, return error. */
@@ -1747,7 +1748,7 @@ static int sx_fw_ioctl(struct inode *ino
 			rc = SX_TYPE_SI;
 		if (IS_EISA_BOARD(board))
 			rc = SX_TYPE_SI;
-		sx_dprintk(SX_DEBUG_FIRMWARE, "returning type= %d\n", rc);
+		sx_dprintk(SX_DEBUG_FIRMWARE, "returning type= %ld\n", rc);
 		break;
 	case SXIO_DO_RAMTEST:
 		if (sx_initialized)	/* Already initialized: better not ramtest the board.  */
@@ -1761,19 +1762,26 @@ static int sx_fw_ioctl(struct inode *ino
 			rc = do_memtest(board, 0, 0x7ff8);
 			/* if (!rc) rc = do_memtest_w (board, 0, 0x7ff8); */
 		}
-		sx_dprintk(SX_DEBUG_FIRMWARE, "returning memtest result= %d\n",
-			   rc);
+		sx_dprintk(SX_DEBUG_FIRMWARE,
+				"returning memtest result= %ld\n", rc);
 		break;
 	case SXIO_DOWNLOAD:
-		if (sx_initialized)	/* Already initialized */
-			return -EEXIST;
-		if (!sx_reset(board))
-			return -EIO;
+		if (sx_initialized) {/* Already initialized */
+			rc = -EEXIST;
+			break;
+		}
+		if (!sx_reset(board)) {
+			rc = -EIO;
+			break;
+		}
 		sx_dprintk(SX_DEBUG_INIT, "reset the board...\n");
 
 		tmp = kmalloc(SX_CHUNK_SIZE, GFP_USER);
-		if (!tmp)
-			return -ENOMEM;
+		if (!tmp) {
+			rc = -ENOMEM;
+			break;
+		}
+		/* FIXME: check returns */
 		get_user(nbytes, descr++);
 		get_user(offset, descr++);
 		get_user(data, descr++);
@@ -1783,7 +1791,8 @@ static int sx_fw_ioctl(struct inode *ino
 						(i + SX_CHUNK_SIZE > nbytes) ?
 						nbytes - i : SX_CHUNK_SIZE)) {
 					kfree(tmp);
-					return -EFAULT;
+					rc = -EFAULT;
+					break;
 				}
 				memcpy_toio(board->base2 + offset + i, tmp,
 						(i + SX_CHUNK_SIZE > nbytes) ?
@@ -1799,13 +1808,17 @@ static int sx_fw_ioctl(struct inode *ino
 		rc = sx_nports;
 		break;
 	case SXIO_INIT:
-		if (sx_initialized)	/* Already initialized */
-			return -EEXIST;
+		if (sx_initialized) {	/* Already initialized */
+			rc = -EEXIST;
+			break;
+		}
 		/* This is not allowed until all boards are initialized... */
 		for (i = 0; i < SX_NBOARDS; i++) {
 			if ((boards[i].flags & SX_BOARD_PRESENT) &&
-				!(boards[i].flags & SX_BOARD_INITIALIZED))
-				return -EIO;
+				!(boards[i].flags & SX_BOARD_INITIALIZED)) {
+				rc = -EIO;
+				break;
+			}
 		}
 		for (i = 0; i < SX_NBOARDS; i++)
 			if (!(boards[i].flags & SX_BOARD_PRESENT))
@@ -1833,10 +1846,10 @@ static int sx_fw_ioctl(struct inode *ino
 		rc = sx_nports;
 		break;
 	default:
-		printk(KERN_WARNING "Unknown ioctl on firmware device (%x).\n",
-				cmd);
+		rc = -ENOTTY;
 		break;
 	}
+	unlock_kernel();
 	func_exit();
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

