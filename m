From: akpm@linux-foundation.org
Subject: - mwave-ioctl-bkl-pushdown.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:21 -0700
Message-ID: <200807252301.m6PN1LtW003700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012AbYGYXCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, snakebyte@gmx.de, yani.ioannou@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mwave: ioctl BKL pushdown
has been removed from the -mm tree.  Its filename was
     mwave-ioctl-bkl-pushdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mwave: ioctl BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Push the BKL down to the point it wraps the actual mwave method handlers

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Yani Ioannou <yani.ioannou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mwave/mwavedd.c |   39 +++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff -puN drivers/char/mwave/mwavedd.c~mwave-ioctl-bkl-pushdown drivers/char/mwave/mwavedd.c
--- a/drivers/char/mwave/mwavedd.c~mwave-ioctl-bkl-pushdown
+++ a/drivers/char/mwave/mwavedd.c
@@ -86,8 +86,8 @@ module_param(mwave_uart_io, int, 0);
 
 static int mwave_open(struct inode *inode, struct file *file);
 static int mwave_close(struct inode *inode, struct file *file);
-static int mwave_ioctl(struct inode *inode, struct file *filp,
-                       unsigned int iocmd, unsigned long ioarg);
+static long mwave_ioctl(struct file *filp, unsigned int iocmd,
+							unsigned long ioarg);
 
 MWAVE_DEVICE_DATA mwave_s_mdd;
 
@@ -119,16 +119,16 @@ static int mwave_close(struct inode *ino
 	return retval;
 }
 
-static int mwave_ioctl(struct inode *inode, struct file *file,
-                       unsigned int iocmd, unsigned long ioarg)
+static long mwave_ioctl(struct file *file, unsigned int iocmd,
+							unsigned long ioarg)
 {
 	unsigned int retval = 0;
 	pMWAVE_DEVICE_DATA pDrvData = &mwave_s_mdd;
 	void __user *arg = (void __user *)ioarg;
 
-	PRINTK_5(TRACE_MWAVE,
-		"mwavedd::mwave_ioctl, entry inode %p file %p cmd %x arg %x\n",
-		 inode,  file, iocmd, (int) ioarg);
+	PRINTK_4(TRACE_MWAVE,
+		"mwavedd::mwave_ioctl, entry file %p cmd %x arg %x\n",
+		file, iocmd, (int) ioarg);
 
 	switch (iocmd) {
 
@@ -136,7 +136,9 @@ static int mwave_ioctl(struct inode *ino
 			PRINTK_1(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RESET"
 				" calling tp3780I_ResetDSP\n");
+			lock_kernel();
 			retval = tp3780I_ResetDSP(&pDrvData->rBDData);
+			unlock_kernel();
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RESET"
 				" retval %x from tp3780I_ResetDSP\n",
@@ -147,7 +149,9 @@ static int mwave_ioctl(struct inode *ino
 			PRINTK_1(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RUN"
 				" calling tp3780I_StartDSP\n");
+			lock_kernel();
 			retval = tp3780I_StartDSP(&pDrvData->rBDData);
+			unlock_kernel();
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_RUN"
 				" retval %x from tp3780I_StartDSP\n",
@@ -161,8 +165,10 @@ static int mwave_ioctl(struct inode *ino
 				"mwavedd::mwave_ioctl,"
 				" IOCTL_MW_DSP_ABILITIES calling"
 				" tp3780I_QueryAbilities\n");
+			lock_kernel();
 			retval = tp3780I_QueryAbilities(&pDrvData->rBDData,
 					&rAbilities);
+			unlock_kernel();
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl, IOCTL_MW_DSP_ABILITIES"
 				" retval %x from tp3780I_QueryAbilities\n",
@@ -193,11 +199,13 @@ static int mwave_ioctl(struct inode *ino
 				"mwavedd::mwave_ioctl IOCTL_MW_READ_DATA,"
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rReadData.ulDataLength, ioarg, pusBuffer);
+			lock_kernel();
 			retval = tp3780I_ReadWriteDspDStore(&pDrvData->rBDData,
 					iocmd,
 					pusBuffer,
 					rReadData.ulDataLength,
 					rReadData.usDspAddress);
+			unlock_kernel();
 		}
 			break;
 	
@@ -215,10 +223,12 @@ static int mwave_ioctl(struct inode *ino
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rReadData.ulDataLength / 2, ioarg,
 				pusBuffer);
+			lock_kernel();
 			retval = tp3780I_ReadWriteDspDStore(&pDrvData->rBDData,
 				iocmd, pusBuffer,
 				rReadData.ulDataLength / 2,
 				rReadData.usDspAddress);
+			unlock_kernel();
 		}
 			break;
 	
@@ -236,10 +246,12 @@ static int mwave_ioctl(struct inode *ino
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rWriteData.ulDataLength, ioarg,
 				pusBuffer);
+			lock_kernel();
 			retval = tp3780I_ReadWriteDspDStore(&pDrvData->rBDData,
 					iocmd, pusBuffer,
 					rWriteData.ulDataLength,
 					rWriteData.usDspAddress);
+			unlock_kernel();
 		}
 			break;
 	
@@ -257,10 +269,12 @@ static int mwave_ioctl(struct inode *ino
 				" size %lx, ioarg %lx pusBuffer %p\n",
 				rWriteData.ulDataLength, ioarg,
 				pusBuffer);
+			lock_kernel();
 			retval = tp3780I_ReadWriteDspIStore(&pDrvData->rBDData,
 					iocmd, pusBuffer,
 					rWriteData.ulDataLength,
 					rWriteData.usDspAddress);
+			unlock_kernel();
 		}
 			break;
 	
@@ -281,8 +295,10 @@ static int mwave_ioctl(struct inode *ino
 						ipcnum);
 				return -EINVAL;
 			}
+			lock_kernel();
 			pDrvData->IPCs[ipcnum].bIsHere = FALSE;
 			pDrvData->IPCs[ipcnum].bIsEnabled = TRUE;
+			unlock_kernel();
 	
 			PRINTK_2(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl IOCTL_MW_REGISTER_IPC"
@@ -307,6 +323,7 @@ static int mwave_ioctl(struct inode *ino
 				return -EINVAL;
 			}
 	
+			lock_kernel();
 			if (pDrvData->IPCs[ipcnum].bIsEnabled == TRUE) {
 				DECLARE_WAITQUEUE(wait, current);
 
@@ -347,6 +364,7 @@ static int mwave_ioctl(struct inode *ino
 					" processing\n",
 					ipcnum);
 			}
+			unlock_kernel();
 		}
 			break;
 	
@@ -365,19 +383,18 @@ static int mwave_ioctl(struct inode *ino
 						ipcnum);
 				return -EINVAL;
 			}
+			lock_kernel();
 			if (pDrvData->IPCs[ipcnum].bIsEnabled == TRUE) {
 				pDrvData->IPCs[ipcnum].bIsEnabled = FALSE;
 				if (pDrvData->IPCs[ipcnum].bIsHere == TRUE) {
 					wake_up_interruptible(&pDrvData->IPCs[ipcnum].ipc_wait_queue);
 				}
 			}
+			unlock_kernel();
 		}
 			break;
 	
 		default:
-			PRINTK_ERROR(KERN_ERR_MWAVE "mwavedd::mwave_ioctl:"
-					" Error: Unrecognized iocmd %x\n",
-					iocmd);
 			return -ENOTTY;
 			break;
 	} /* switch */
@@ -460,7 +477,7 @@ static const struct file_operations mwav
 	.owner		= THIS_MODULE,
 	.read		= mwave_read,
 	.write		= mwave_write,
-	.ioctl		= mwave_ioctl,
+	.unlocked_ioctl	= mwave_ioctl,
 	.open		= mwave_open,
 	.release	= mwave_close
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

