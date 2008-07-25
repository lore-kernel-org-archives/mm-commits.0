From: akpm@linux-foundation.org
Subject: - rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:24 -0700
Message-ID: <200807252301.m6PN1O78003705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbYGYXCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rio: push down the BKL into the firmware ioctl handler
has been removed from the -mm tree.  Its filename was
     rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rio: push down the BKL into the firmware ioctl handler
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

TTY side is already done.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rio/rio_linux.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/rio/rio_linux.c~rio-push-down-the-bkl-into-the-firmware-ioctl-handler drivers/char/rio/rio_linux.c
--- a/drivers/char/rio/rio_linux.c~rio-push-down-the-bkl-into-the-firmware-ioctl-handler
+++ a/drivers/char/rio/rio_linux.c
@@ -179,7 +179,7 @@ static int rio_set_real_termios(void *pt
 static void rio_hungup(void *ptr);
 static void rio_close(void *ptr);
 static int rio_chars_in_buffer(void *ptr);
-static int rio_fw_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);
+static long rio_fw_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 static int rio_init_drivers(void);
 
 static void my_hd(void *addr, int len);
@@ -240,7 +240,7 @@ static struct real_driver rio_real_drive
 
 static const struct file_operations rio_fw_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = rio_fw_ioctl,
+	.unlocked_ioctl = rio_fw_ioctl,
 };
 
 static struct miscdevice rio_fw_device = {
@@ -560,13 +560,15 @@ static void rio_close(void *ptr)
 
 
 
-static int rio_fw_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
+static long rio_fw_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int rc = 0;
 	func_enter();
 
 	/* The "dev" argument isn't used. */
+	lock_kernel();
 	rc = riocontrol(p, 0, cmd, arg, capable(CAP_SYS_ADMIN));
+	unlock_kernel();
 
 	func_exit();
 	return rc;
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

