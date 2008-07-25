From: akpm@linux-foundation.org
Subject: - sx-push-bkl-down-into-the-firmware-ioctl-handler.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:26 -0700
Message-ID: <200807252301.m6PN1Q1w003708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754468AbYGYXHC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sx: push BKL down into the firmware ioctl handler
has been removed from the -mm tree.  Its filename was
     sx-push-bkl-down-into-the-firmware-ioctl-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -286,8 +286,8 @@ static void sx_close(void *ptr);
 static int sx_chars_in_buffer(void *ptr);
 static int sx_init_board(struct sx_board *board);
 static int sx_init_portstructs(int nboards, int nports);
-static int sx_fw_ioctl(struct inode *inode, struct file *filp,
-		unsigned int cmd, unsigned long arg);
+static long sx_fw_ioctl(struct file *filp, unsigned int cmd,
+						unsigned long arg);
 static int sx_init_drivers(void);
 
 static struct tty_driver *sx_driver;
@@ -396,7 +396,7 @@ static struct real_driver sx_real_driver
 
 static const struct file_operations sx_fw_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = sx_fw_ioctl,
+	.unlocked_ioctl = sx_fw_ioctl,
 };
 
 static struct miscdevice sx_fw_device = {
@@ -1686,10 +1686,10 @@ static int do_memtest_w(struct sx_board 
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
@@ -1699,13 +1699,10 @@ static int sx_fw_ioctl(struct inode *ino
 
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
 
@@ -1720,19 +1717,23 @@ static int sx_fw_ioctl(struct inode *ino
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
@@ -1746,7 +1747,7 @@ static int sx_fw_ioctl(struct inode *ino
 			rc = SX_TYPE_SI;
 		if (IS_EISA_BOARD(board))
 			rc = SX_TYPE_SI;
-		sx_dprintk(SX_DEBUG_FIRMWARE, "returning type= %d\n", rc);
+		sx_dprintk(SX_DEBUG_FIRMWARE, "returning type= %ld\n", rc);
 		break;
 	case SXIO_DO_RAMTEST:
 		if (sx_initialized)	/* Already initialized: better not ramtest the board.  */
@@ -1760,19 +1761,26 @@ static int sx_fw_ioctl(struct inode *ino
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
@@ -1782,7 +1790,8 @@ static int sx_fw_ioctl(struct inode *ino
 						(i + SX_CHUNK_SIZE > nbytes) ?
 						nbytes - i : SX_CHUNK_SIZE)) {
 					kfree(tmp);
-					return -EFAULT;
+					rc = -EFAULT;
+					break;
 				}
 				memcpy_toio(board->base2 + offset + i, tmp,
 						(i + SX_CHUNK_SIZE > nbytes) ?
@@ -1798,13 +1807,17 @@ static int sx_fw_ioctl(struct inode *ino
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
@@ -1832,10 +1845,10 @@ static int sx_fw_ioctl(struct inode *ino
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
hugetlb-fix-config_sysctl=n-build.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch

