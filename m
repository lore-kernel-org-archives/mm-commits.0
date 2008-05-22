From: akpm@linux-foundation.org
Subject: + mwave-ioctl-bkl-pushdown.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:00 -0700
Message-ID: <200805222316.m4MNG07v026499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757295AbYEVXQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, snakebyte@gmx.de, yani.ioannou@gmail.com


The patch titled
     mwave: ioctl BKL pushdown
has been added to the -mm tree.  Its filename is
     mwave-ioctl-bkl-pushdown.patch

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

