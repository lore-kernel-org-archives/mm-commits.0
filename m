From: akpm@linux-foundation.org
Subject: - dsp56k-bkl-pushdown.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:35 -0700
Message-ID: <200807252301.m6PN1ZKk003720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766AbYGYXHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     dsp56k: BKL pushdown
has been removed from the -mm tree.  Its filename was
     dsp56k-bkl-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -36,10 +36,10 @@
 #include <linux/smp_lock.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
+#include <linux/uaccess.h>	/* For put_user and get_user */
 
 #include <asm/atarihw.h>
 #include <asm/traps.h>
-#include <asm/uaccess.h>	/* For put_user and get_user */
 
 #include <asm/dsp56k.h>
 
@@ -303,8 +303,8 @@ static ssize_t dsp56k_write(struct file 
 	}
 }
 
-static int dsp56k_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long dsp56k_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int dev = iminor(inode) & 0x0f;
 	void __user *argp = (void __user *)arg;
@@ -331,8 +331,9 @@ static int dsp56k_ioctl(struct inode *in
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
@@ -342,12 +343,16 @@ static int dsp56k_ioctl(struct inode *in
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
@@ -359,6 +364,7 @@ static int dsp56k_ioctl(struct inode *in
 			if(get_user(out, &hf->out) < 0)
 				return -EFAULT;
 
+			lock_kernel();
 			if ((dir & 0x1) && (out & 0x1))
 				dsp56k_host_interface.icr |= DSP56K_ICR_HF0;
 			else if (dir & 0x1)
@@ -373,14 +379,16 @@ static int dsp56k_ioctl(struct inode *in
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
@@ -472,7 +480,7 @@ static const struct file_operations dsp5
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

