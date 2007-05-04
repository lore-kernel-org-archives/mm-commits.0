From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch added to -mm tree
Date: Thu, 03 May 2007 20:14:46 -0700
Message-ID: <200705040314.l443EkpP027902@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbXEDDO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 23:14:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, axboe@kernel.dk


The patch titled
     use mutex instead of binary semaphore in CDU-31A driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of binary semaphore in CDU-31A driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Use mutex instead of binary semaphore in CDU-31A driver.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdu31a.c |   50 +++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff -puN drivers/cdrom/cdu31a.c~use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver drivers/cdrom/cdu31a.c
--- a/drivers/cdrom/cdu31a.c~use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver
+++ a/drivers/cdrom/cdu31a.c
@@ -263,7 +263,7 @@ static int sony_toc_read = 0;	/* Has the
 static struct s_sony_subcode last_sony_subcode;	/* Points to the last
 						   subcode address read */
 
-static DECLARE_MUTEX(sony_sem);		/* Semaphore for drive hardware access */
+static DEFINE_MUTEX(sony_mtx);		/* Mutex for drive hardware access */
 
 static int is_double_speed = 0;	/* does the drive support double speed ? */
 
@@ -339,11 +339,11 @@ static int scd_drive_status(struct cdrom
 		return -EINVAL;
 	if (sony_spun_up)
 		return CDS_DISC_OK;
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	if (scd_spinup() == 0)
 		sony_spun_up = 1;
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return sony_spun_up ? CDS_DISC_OK : CDS_DRIVE_NOT_READY;
 }
 
@@ -452,7 +452,7 @@ static int scd_reset(struct cdrom_device
 {
 	unsigned long retry_count;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	reset_drive();
 
@@ -461,7 +461,7 @@ static int scd_reset(struct cdrom_device
 		sony_sleep();
 	}
 
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return 0;
 }
 
@@ -655,10 +655,10 @@ static int scd_select_speed(struct cdrom
 	else
 		sony_speed = speed - 1;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	set_drive_params(sony_speed);
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return 0;
 }
 
@@ -673,10 +673,10 @@ static int scd_lock_door(struct cdrom_de
 	} else {
 		is_auto_eject = 0;
 	}
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	set_drive_params(sony_speed);
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return 0;
 }
 
@@ -1143,7 +1143,7 @@ static void handle_abort_timeout(unsigne
 {
 	pr_debug(PFX "Entering %s\n", __FUNCTION__);
 	/* If it is in use, ignore it. */
-	if (down_trylock(&sony_sem) == 0) {
+	if (mutex_trylock(&sony_mtx) == 0) {
 		/* We can't use abort_read(), because it will sleep
 		   or schedule in the timer interrupt.  Just start
 		   the operation, finish it on the next access to
@@ -1154,7 +1154,7 @@ static void handle_abort_timeout(unsigne
 
 		sony_blocks_left = 0;
 		abort_read_started = 1;
-		up(&sony_sem);
+		mutex_unlock(&sony_mtx);
 	}
 	pr_debug(PFX "Leaving %s\n", __FUNCTION__);
 }
@@ -1300,7 +1300,7 @@ static void do_cdu31a_request(request_qu
 	pr_debug(PFX "Entering %s\n", __FUNCTION__);
 
 	spin_unlock_irq(q->queue_lock);
-	if (down_interruptible(&sony_sem)) {
+	if (mutex_lock_interruptible(&sony_mtx)) {
 		spin_lock_irq(q->queue_lock);
 		return;
 	}
@@ -1435,7 +1435,7 @@ static void do_cdu31a_request(request_qu
 	add_timer(&cdu31a_abort_timer);
 #endif
 
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	spin_lock_irq(q->queue_lock);
 	pr_debug(PFX "Leaving %s at %d\n", __FUNCTION__, __LINE__);
 }
@@ -1906,10 +1906,10 @@ static int scd_get_last_session(struct c
 		return 1;
 
 	if (!sony_toc_read) {
-		if (down_interruptible(&sony_sem))
+		if (mutex_lock_interruptible(&sony_mtx))
 			return -ERESTARTSYS;
 		sony_get_toc();
-		up(&sony_sem);
+		mutex_unlock(&sony_mtx);
 	}
 
 	ms_info->addr_format = CDROM_LBA;
@@ -1988,11 +1988,11 @@ scd_get_mcn(struct cdrom_device_info *cd
 	unsigned int res_size;
 
 	memset(mcn->medium_catalog_number, 0, 14);
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	do_sony_cd_cmd(SONY_REQ_UPC_EAN_CMD,
 		       NULL, 0, resbuffer, &res_size);
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	if ((res_size < 2) || ((resbuffer[0] & 0xf0) == 0x20));
 	else {
 		/* packed bcd to single ASCII digits */
@@ -2207,7 +2207,7 @@ static int read_audio(struct cdrom_read_
 	unsigned int res_size;
 	unsigned int cframe;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	if (!sony_spun_up)
 		scd_spinup();
@@ -2343,7 +2343,7 @@ static int read_audio(struct cdrom_read_
 	}
 
  out_up:
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 
 	return retval;
 }
@@ -2373,7 +2373,7 @@ static int scd_tray_move(struct cdrom_de
 {
 	int retval;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	if (position == 1 /* open tray */ ) {
 		unsigned char res_reg[12];
@@ -2392,7 +2392,7 @@ static int scd_tray_move(struct cdrom_de
 			sony_spun_up = 1;
 		retval = 0;
 	}
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return retval;
 }
 
@@ -2407,7 +2407,7 @@ static int scd_audio_ioctl(struct cdrom_
 	unsigned char params[7];
 	int i, retval;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	switch (cmd) {
 	case CDROMSTART:	/* Spin up the drive */
@@ -2665,7 +2665,7 @@ static int scd_audio_ioctl(struct cdrom_
 		retval = -EINVAL;
 		break;
 	}
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return retval;
 }
 
@@ -2675,7 +2675,7 @@ static int scd_read_audio(struct cdrom_d
 	void __user *argp = (void __user *)arg;
 	int retval;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	switch (cmd) {
 	case CDROMREADAUDIO:	/* Read 2352 byte audio tracks and 2340 byte
@@ -2749,7 +2749,7 @@ static int scd_read_audio(struct cdrom_d
 	default:
 		retval = -EINVAL;
 	}
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return retval;
 }
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
use-mutex-instead-of-semaphore-in-rocketport-driver.patch
use-mutex-instead-of-semaphore-in-tpm-driver.patch
use-mutex-instead-of-semaphore-in-hdaps-driver.patch
use-mutex-instead-of-semaphore-for-misc-char-devices.patch
fix-spinlock-usage-in-hysdn_log_close.patch
use-mutex-instead-of-semaphore-in-capi-20-interface.patch
use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
