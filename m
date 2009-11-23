From: akpm@linux-foundation.org
Subject: + kfifo-move-out-spinlock.patch added to -mm tree
Date: Mon, 23 Nov 2009 14:18:57 -0800
Message-ID: <200911232218.nANMIwm9019760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757452AbZKWWTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 17:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, ak@linux.intel.com, arnd@arndb.de, gregkh@suse.de, mchehab@redhat.com


The patch titled
     kfifo: move out spinlock
has been added to the -mm tree.  Its filename is
     kfifo-move-out-spinlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: move out spinlock
From: Stefani Seibold <stefani@seibold.net>

Move the pointer to the spinlock out of struct kfifo.  Most users in tree
do not actually use a spinlock, so the few exceptions now have to call
kfifo_{get,put}_locked, which takes an extra argument to a spinlock.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c                       |    2 
 drivers/char/sonypi.c                       |   21 ++--
 drivers/infiniband/hw/cxgb3/cxio_resource.c |   36 ++++----
 drivers/media/video/meye.c                  |   35 ++++---
 drivers/net/wireless/libertas/main.c        |    2 
 drivers/platform/x86/fujitsu-laptop.c       |   18 ++--
 drivers/platform/x86/sony-laptop.c          |   22 ++--
 drivers/scsi/libiscsi.c                     |    2 
 drivers/scsi/libiscsi_tcp.c                 |    2 
 drivers/scsi/libsrp.c                       |    9 +-
 drivers/usb/host/fhci.h                     |    2 
 drivers/usb/serial/generic.c                |    4 
 drivers/usb/serial/usb-serial.c             |    3 
 include/linux/kfifo.h                       |   80 +++++++-----------
 kernel/kfifo.c                              |   17 +--
 net/dccp/probe.c                            |    6 -
 16 files changed, 131 insertions(+), 130 deletions(-)

diff -puN drivers/char/nozomi.c~kfifo-move-out-spinlock drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~kfifo-move-out-spinlock
+++ a/drivers/char/nozomi.c
@@ -686,7 +686,7 @@ static int nozomi_read_config_table(stru
 
 		for (i = PORT_MDM; i < MAX_PORT; i++) {
 			kfifo_alloc(&dc->port[i].fifo_ul,
-				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC, NULL);
+				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC);
 			memset(&dc->port[i].ctrl_dl, 0, sizeof(struct ctrl_dl));
 			memset(&dc->port[i].ctrl_ul, 0, sizeof(struct ctrl_ul));
 		}
diff -puN drivers/char/sonypi.c~kfifo-move-out-spinlock drivers/char/sonypi.c
--- a/drivers/char/sonypi.c~kfifo-move-out-spinlock
+++ a/drivers/char/sonypi.c
@@ -777,8 +777,9 @@ static void input_keyrelease(struct work
 {
 	struct sonypi_keypress kp;
 
-	while (kfifo_get(&sonypi_device.input_fifo, (unsigned char *)&kp,
-			 sizeof(kp)) == sizeof(kp)) {
+	while (kfifo_get_locked(&sonypi_device.input_fifo, (unsigned char *)&kp,
+			 sizeof(kp), &sonypi_device.input_fifo_lock)
+			== sizeof(kp)) {
 		msleep(10);
 		input_report_key(kp.dev, kp.key, 0);
 		input_sync(kp.dev);
@@ -827,8 +828,9 @@ static void sonypi_report_input_event(u8
 	if (kp.dev) {
 		input_report_key(kp.dev, kp.key, 1);
 		input_sync(kp.dev);
-		kfifo_put(&sonypi_device.input_fifo,
-			  (unsigned char *)&kp, sizeof(kp));
+		kfifo_put_locked(&sonypi_device.input_fifo,
+			(unsigned char *)&kp, sizeof(kp),
+			&sonypi_device.input_fifo_lock);
 		schedule_work(&sonypi_device.input_work);
 	}
 }
@@ -880,7 +882,8 @@ found:
 		acpi_bus_generate_proc_event(sonypi_acpi_device, 1, event);
 #endif
 
-	kfifo_put(&sonypi_device.fifo, (unsigned char *)&event, sizeof(event));
+	kfifo_put_locked(&sonypi_device.fifo, (unsigned char *)&event,
+			sizeof(event), &sonypi_device.fifo_lock);
 	kill_fasync(&sonypi_device.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_device.fifo_proc_list);
 
@@ -929,7 +932,8 @@ static ssize_t sonypi_misc_read(struct f
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_get(&sonypi_device.fifo, &c, sizeof(c)) == sizeof(c))) {
+	       (kfifo_get_locked(&sonypi_device.fifo, &c, sizeof(c),
+				 &sonypi_device.fifo_lock) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
 		ret++;
@@ -1313,8 +1317,7 @@ static int __devinit sonypi_probe(struct
 			"http://www.linux.it/~malattia/wiki/index.php/Sony_drivers\n");
 
 	spin_lock_init(&sonypi_device.fifo_lock);
-	error = kfifo_alloc(&sonypi_device.fifo, SONYPI_BUF_SIZE, GFP_KERNEL,
-					 &sonypi_device.fifo_lock);
+	error = kfifo_alloc(&sonypi_device.fifo, SONYPI_BUF_SIZE, GFP_KERNEL);
 	if (error) {
 		printk(KERN_ERR "sonypi: kfifo_alloc failed\n");
 		return error;
@@ -1394,7 +1397,7 @@ static int __devinit sonypi_probe(struct
 
 		spin_lock_init(&sonypi_device.input_fifo_lock);
 		error = kfifo_alloc(&sonypi_device.input_fifo, SONYPI_BUF_SIZE,
-				GFP_KERNEL, &sonypi_device.input_fifo_lock);
+				GFP_KERNEL);
 		if (error) {
 			printk(KERN_ERR "sonypi: kfifo_alloc failed\n");
 			goto err_inpdev_unregister;
diff -puN drivers/infiniband/hw/cxgb3/cxio_resource.c~kfifo-move-out-spinlock drivers/infiniband/hw/cxgb3/cxio_resource.c
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c~kfifo-move-out-spinlock
+++ a/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -55,7 +55,7 @@ static int __cxio_init_resource_fifo(str
 	u32 rarray[16];
 	spin_lock_init(fifo_lock);
 
-	if (kfifo_alloc(fifo, nr * sizeof(u32), GFP_KERNEL, fifo_lock))
+	if (kfifo_alloc(fifo, nr * sizeof(u32), GFP_KERNEL))
 		return -ENOMEM;
 
 	for (i = 0; i < skip_low + skip_high; i++)
@@ -86,7 +86,8 @@ static int __cxio_init_resource_fifo(str
 			__kfifo_put(fifo, (unsigned char *) &i, sizeof(u32));
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_get(fifo, (unsigned char *) &entry, sizeof(u32));
+		kfifo_get_locked(fifo, (unsigned char *) &entry,
+				sizeof(u32), fifo_lock);
 	return 0;
 }
 
@@ -113,8 +114,7 @@ static int cxio_init_qpid_fifo(struct cx
 	spin_lock_init(&rdev_p->rscp->qpid_fifo_lock);
 
 	if (kfifo_alloc(&rdev_p->rscp->qpid_fifo, T3_MAX_NUM_QP * sizeof(u32),
-					      GFP_KERNEL,
-					      &rdev_p->rscp->qpid_fifo_lock))
+					      GFP_KERNEL))
 		return -ENOMEM;
 
 	for (i = 16; i < T3_MAX_NUM_QP; i++)
@@ -177,33 +177,37 @@ tpt_err:
 /*
  * returns 0 if no resource available
  */
-static u32 cxio_hal_get_resource(struct kfifo *fifo)
+static u32 cxio_hal_get_resource(struct kfifo *fifo, spinlock_t * lock)
 {
 	u32 entry;
-	if (kfifo_get(fifo, (unsigned char *) &entry, sizeof(u32)))
+	if (kfifo_get_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock))
 		return entry;
 	else
 		return 0;	/* fifo emptry */
 }
 
-static void cxio_hal_put_resource(struct kfifo *fifo, u32 entry)
+static void cxio_hal_put_resource(struct kfifo *fifo, spinlock_t * lock,
+		u32 entry)
 {
-	BUG_ON(kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32)) == 0);
+	BUG_ON(
+	kfifo_put_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock)
+	== 0);
 }
 
 u32 cxio_hal_get_stag(struct cxio_hal_resource *rscp)
 {
-	return cxio_hal_get_resource(&rscp->tpt_fifo);
+	return cxio_hal_get_resource(&rscp->tpt_fifo, &rscp->tpt_fifo_lock);
 }
 
 void cxio_hal_put_stag(struct cxio_hal_resource *rscp, u32 stag)
 {
-	cxio_hal_put_resource(&rscp->tpt_fifo, stag);
+	cxio_hal_put_resource(&rscp->tpt_fifo, &rscp->tpt_fifo_lock, stag);
 }
 
 u32 cxio_hal_get_qpid(struct cxio_hal_resource *rscp)
 {
-	u32 qpid = cxio_hal_get_resource(&rscp->qpid_fifo);
+	u32 qpid = cxio_hal_get_resource(&rscp->qpid_fifo,
+			&rscp->qpid_fifo_lock);
 	PDBG("%s qpid 0x%x\n", __func__, qpid);
 	return qpid;
 }
@@ -211,27 +215,27 @@ u32 cxio_hal_get_qpid(struct cxio_hal_re
 void cxio_hal_put_qpid(struct cxio_hal_resource *rscp, u32 qpid)
 {
 	PDBG("%s qpid 0x%x\n", __func__, qpid);
-	cxio_hal_put_resource(&rscp->qpid_fifo, qpid);
+	cxio_hal_put_resource(&rscp->qpid_fifo, &rscp->qpid_fifo_lock, qpid);
 }
 
 u32 cxio_hal_get_cqid(struct cxio_hal_resource *rscp)
 {
-	return cxio_hal_get_resource(&rscp->cqid_fifo);
+	return cxio_hal_get_resource(&rscp->cqid_fifo, &rscp->cqid_fifo_lock);
 }
 
 void cxio_hal_put_cqid(struct cxio_hal_resource *rscp, u32 cqid)
 {
-	cxio_hal_put_resource(&rscp->cqid_fifo, cqid);
+	cxio_hal_put_resource(&rscp->cqid_fifo, &rscp->cqid_fifo_lock, cqid);
 }
 
 u32 cxio_hal_get_pdid(struct cxio_hal_resource *rscp)
 {
-	return cxio_hal_get_resource(&rscp->pdid_fifo);
+	return cxio_hal_get_resource(&rscp->pdid_fifo, &rscp->pdid_fifo_lock);
 }
 
 void cxio_hal_put_pdid(struct cxio_hal_resource *rscp, u32 pdid)
 {
-	cxio_hal_put_resource(&rscp->pdid_fifo, pdid);
+	cxio_hal_put_resource(&rscp->pdid_fifo, &rscp->pdid_fifo_lock, pdid);
 }
 
 void cxio_hal_destroy_resource(struct cxio_hal_resource *rscp)
diff -puN drivers/media/video/meye.c~kfifo-move-out-spinlock drivers/media/video/meye.c
--- a/drivers/media/video/meye.c~kfifo-move-out-spinlock
+++ a/drivers/media/video/meye.c
@@ -800,8 +800,8 @@ again:
 		return IRQ_HANDLED;
 
 	if (meye.mchip_mode == MCHIP_HIC_MODE_CONT_OUT) {
-		if (kfifo_get(&meye.grabq, (unsigned char *)&reqnr,
-			      sizeof(int)) != sizeof(int)) {
+		if (kfifo_get_locked(&meye.grabq, (unsigned char *)&reqnr,
+			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
 			mchip_free_frame();
 			return IRQ_HANDLED;
 		}
@@ -811,7 +811,8 @@ again:
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_put(&meye.doneq, (unsigned char *)&reqnr, sizeof(int));
+		kfifo_put_locked(&meye.doneq, (unsigned char *)&reqnr,
+				sizeof(int), &meye.doneq_lock);
 		wake_up_interruptible(&meye.proc_list);
 	} else {
 		int size;
@@ -820,8 +821,8 @@ again:
 			mchip_free_frame();
 			goto again;
 		}
-		if (kfifo_get(&meye.grabq, (unsigned char *)&reqnr,
-			      sizeof(int)) != sizeof(int)) {
+		if (kfifo_get_locked(&meye.grabq, (unsigned char *)&reqnr,
+			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
 			mchip_free_frame();
 			goto again;
 		}
@@ -831,7 +832,8 @@ again:
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_put(&meye.doneq, (unsigned char *)&reqnr, sizeof(int));
+		kfifo_put_locked(&meye.doneq, (unsigned char *)&reqnr,
+				sizeof(int), &meye.doneq_lock);
 		wake_up_interruptible(&meye.proc_list);
 	}
 	mchip_free_frame();
@@ -933,7 +935,8 @@ static int meyeioc_qbuf_capt(int *nb)
 		mchip_cont_compression_start();
 
 	meye.grab_buffer[*nb].state = MEYE_BUF_USING;
-	kfifo_put(&meye.grabq, (unsigned char *)nb, sizeof(int));
+	kfifo_put_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
+			 &meye.grabq_lock);
 	mutex_unlock(&meye.lock);
 
 	return 0;
@@ -965,7 +968,8 @@ static int meyeioc_sync(struct file *fil
 		/* fall through */
 	case MEYE_BUF_DONE:
 		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
-		kfifo_get(&meye.doneq, (unsigned char *)&unused, sizeof(int));
+		kfifo_get_locked(&meye.doneq, (unsigned char *)&unused,
+				sizeof(int), &meye.doneq_lock);
 	}
 	*i = meye.grab_buffer[*i].size;
 	mutex_unlock(&meye.lock);
@@ -1452,7 +1456,8 @@ static int vidioc_qbuf(struct file *file
 	buf->flags |= V4L2_BUF_FLAG_QUEUED;
 	buf->flags &= ~V4L2_BUF_FLAG_DONE;
 	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
-	kfifo_put(&meye.grabq, (unsigned char *)&buf->index, sizeof(int));
+	kfifo_put_locked(&meye.grabq, (unsigned char *)&buf->index,
+			sizeof(int), &meye.grabq_lock);
 	mutex_unlock(&meye.lock);
 
 	return 0;
@@ -1478,8 +1483,8 @@ static int vidioc_dqbuf(struct file *fil
 		return -EINTR;
 	}
 
-	if (!kfifo_get(&meye.doneq, (unsigned char *)&reqnr,
-		       sizeof(int))) {
+	if (!kfifo_get_locked(&meye.doneq, (unsigned char *)&reqnr,
+		       sizeof(int), &meye.doneq_lock)) {
 		mutex_unlock(&meye.lock);
 		return -EBUSY;
 	}
@@ -1746,14 +1751,14 @@ static int __devinit meye_probe(struct p
 	}
 
 	spin_lock_init(&meye.grabq_lock);
-	if (kfifo_alloc(&meye.grabq, sizeof(int) * MEYE_MAX_BUFNBRS, GFP_KERNEL,
-				 &meye.grabq_lock)) {
+	if (kfifo_alloc(&meye.grabq, sizeof(int) * MEYE_MAX_BUFNBRS,
+				GFP_KERNEL)) {
 		printk(KERN_ERR "meye: fifo allocation failed\n");
 		goto outkfifoalloc1;
 	}
 	spin_lock_init(&meye.doneq_lock);
-	if (kfifo_alloc(&meye.doneq, sizeof(int) * MEYE_MAX_BUFNBRS, GFP_KERNEL,
-				 &meye.doneq_lock)) {
+	if (kfifo_alloc(&meye.doneq, sizeof(int) * MEYE_MAX_BUFNBRS,
+				GFP_KERNEL)) {
 		printk(KERN_ERR "meye: fifo allocation failed\n");
 		goto outkfifoalloc2;
 	}
diff -puN drivers/net/wireless/libertas/main.c~kfifo-move-out-spinlock drivers/net/wireless/libertas/main.c
--- a/drivers/net/wireless/libertas/main.c~kfifo-move-out-spinlock
+++ a/drivers/net/wireless/libertas/main.c
@@ -1081,7 +1081,7 @@ static int lbs_init_adapter(struct lbs_p
 	priv->resp_len[0] = priv->resp_len[1] = 0;
 
 	/* Create the event FIFO */
-	ret = kfifo_alloc(&priv->event_fifo, sizeof(u32) * 16, GFP_KERNEL, NULL);
+	ret = kfifo_alloc(&priv->event_fifo, sizeof(u32) * 16, GFP_KERNEL);
 	if (ret) {
 		lbs_pr_err("Out of memory allocating event FIFO buffer\n");
 		goto out;
diff -puN drivers/platform/x86/fujitsu-laptop.c~kfifo-move-out-spinlock drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c~kfifo-move-out-spinlock
+++ a/drivers/platform/x86/fujitsu-laptop.c
@@ -825,7 +825,7 @@ static int acpi_fujitsu_hotkey_add(struc
 	/* kfifo */
 	spin_lock_init(&fujitsu_hotkey->fifo_lock);
 	error = kfifo_alloc(&fujitsu_hotkey->fifo, RINGBUFFERSIZE * sizeof(int),
-			GFP_KERNEL, &fujitsu_hotkey->fifo_lock);
+			GFP_KERNEL);
 	if (error) {
 		printk(KERN_ERR "kfifo_alloc failed\n");
 		goto err_stop;
@@ -1006,9 +1006,10 @@ static void acpi_fujitsu_hotkey_notify(s
 				vdbg_printk(FUJLAPTOP_DBG_TRACE,
 					"Push keycode into ringbuffer [%d]\n",
 					keycode);
-				status = kfifo_put(&fujitsu_hotkey->fifo,
+				status = kfifo_put_locked(&fujitsu_hotkey->fifo,
 						   (unsigned char *)&keycode,
-						   sizeof(keycode));
+						   sizeof(keycode),
+						   &fujitsu_hotkey->fifo_lock);
 				if (status != sizeof(keycode)) {
 					vdbg_printk(FUJLAPTOP_DBG_WARN,
 					    "Could not push keycode [0x%x]\n",
@@ -1019,11 +1020,12 @@ static void acpi_fujitsu_hotkey_notify(s
 				}
 			} else if (keycode == 0) {
 				while ((status =
-					kfifo_get
-					(&fujitsu_hotkey->fifo, (unsigned char *)
-					 &keycode_r,
-					 sizeof
-					 (keycode_r))) == sizeof(keycode_r)) {
+					kfifo_get_locked(
+					 &fujitsu_hotkey->fifo,
+					 (unsigned char *) &keycode_r,
+					 sizeof(keycode_r),
+					 &fujitsu_hotkey->fifo_lock))
+					 == sizeof(keycode_r)) {
 					input_report_key(input, keycode_r, 0);
 					input_sync(input);
 					vdbg_printk(FUJLAPTOP_DBG_TRACE,
diff -puN drivers/platform/x86/sony-laptop.c~kfifo-move-out-spinlock drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~kfifo-move-out-spinlock
+++ a/drivers/platform/x86/sony-laptop.c
@@ -300,8 +300,9 @@ static void do_sony_laptop_release_key(s
 {
 	struct sony_laptop_keypress kp;
 
-	while (kfifo_get(&sony_laptop_input.fifo, (unsigned char *)&kp,
-			 sizeof(kp)) == sizeof(kp)) {
+	while (kfifo_get_locked(&sony_laptop_input.fifo, (unsigned char *)&kp,
+			sizeof(kp), &sony_laptop_input.fifo_lock)
+			== sizeof(kp)) {
 		msleep(10);
 		input_report_key(kp.dev, kp.key, 0);
 		input_sync(kp.dev);
@@ -362,8 +363,9 @@ static void sony_laptop_report_input_eve
 		/* we emit the scancode so we can always remap the key */
 		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
 		input_sync(kp.dev);
-		kfifo_put(&sony_laptop_input.fifo,
-			  (unsigned char *)&kp, sizeof(kp));
+		kfifo_put_locked(&sony_laptop_input.fifo,
+			  (unsigned char *)&kp, sizeof(kp),
+			  &sony_laptop_input.fifo_lock);
 
 		if (!work_pending(&sony_laptop_release_key_work))
 			queue_work(sony_laptop_input.wq,
@@ -386,8 +388,7 @@ static int sony_laptop_setup_input(struc
 	/* kfifo */
 	spin_lock_init(&sony_laptop_input.fifo_lock);
 	error =
-	 kfifo_alloc(&sony_laptop_input.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL,
-			    &sony_laptop_input.fifo_lock);
+	 kfifo_alloc(&sony_laptop_input.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL);
 	if (error) {
 		printk(KERN_ERR DRV_PFX "kfifo_alloc failed\n");
 		goto err_dec_users;
@@ -2129,7 +2130,8 @@ static ssize_t sonypi_misc_read(struct f
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_get(&sonypi_compat.fifo, &c, sizeof(c)) == sizeof(c))) {
+	       (kfifo_get_locked(&sonypi_compat.fifo, &c, sizeof(c),
+			  &sonypi_compat.fifo_lock) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
 		ret++;
@@ -2308,7 +2310,8 @@ static struct miscdevice sonypi_misc_dev
 
 static void sonypi_compat_report_event(u8 event)
 {
-	kfifo_put(&sonypi_compat.fifo, (unsigned char *)&event, sizeof(event));
+	kfifo_put_locked(&sonypi_compat.fifo, (unsigned char *)&event,
+			sizeof(event), &sonypi_compat.fifo_lock);
 	kill_fasync(&sonypi_compat.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_compat.fifo_proc_list);
 }
@@ -2319,8 +2322,7 @@ static int sonypi_compat_init(void)
 
 	spin_lock_init(&sonypi_compat.fifo_lock);
 	error =
-	 kfifo_alloc(&sonypi_compat.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL,
-					 &sonypi_compat.fifo_lock);
+	 kfifo_alloc(&sonypi_compat.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL);
 	if (error) {
 		printk(KERN_ERR DRV_PFX "kfifo_alloc failed\n");
 		return error;
diff -puN drivers/scsi/libiscsi.c~kfifo-move-out-spinlock drivers/scsi/libiscsi.c
--- a/drivers/scsi/libiscsi.c~kfifo-move-out-spinlock
+++ a/drivers/scsi/libiscsi.c
@@ -2461,7 +2461,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
 	if (q->pool == NULL)
 		return -ENOMEM;
 
-	kfifo_init(&q->queue, (void*)q->pool, max * sizeof(void*), NULL);
+	kfifo_init(&q->queue, (void*)q->pool, max * sizeof(void*));
 
 	for (i = 0; i < max; i++) {
 		q->pool[i] = kzalloc(item_size, GFP_KERNEL);
diff -puN drivers/scsi/libiscsi_tcp.c~kfifo-move-out-spinlock drivers/scsi/libiscsi_tcp.c
--- a/drivers/scsi/libiscsi_tcp.c~kfifo-move-out-spinlock
+++ a/drivers/scsi/libiscsi_tcp.c
@@ -1128,7 +1128,7 @@ int iscsi_tcp_r2tpool_alloc(struct iscsi
 
 		/* R2T xmit queue */
 		if (kfifo_alloc(&tcp_task->r2tqueue,
-		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL, NULL)) {
+		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL)) {
 			iscsi_pool_free(&tcp_task->r2tpool);
 			goto r2t_alloc_fail;
 		}
diff -puN drivers/scsi/libsrp.c~kfifo-move-out-spinlock drivers/scsi/libsrp.c
--- a/drivers/scsi/libsrp.c~kfifo-move-out-spinlock
+++ a/drivers/scsi/libsrp.c
@@ -58,8 +58,7 @@ static int srp_iu_pool_alloc(struct srp_
 		goto free_pool;
 
 	spin_lock_init(&q->lock);
-	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *),
-			      &q->lock);
+	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
 	for (i = 0, iue = q->items; i < max; i++) {
 		__kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
@@ -165,7 +164,8 @@ struct iu_entry *srp_iu_get(struct srp_t
 {
 	struct iu_entry *iue = NULL;
 
-	kfifo_get(&target->iu_queue.queue, (void *) &iue, sizeof(void *));
+	kfifo_get_locked(&target->iu_queue.queue, (void *) &iue,
+			sizeof(void *), &target->iu_queue.lock);
 	if (!iue)
 		return iue;
 	iue->target = target;
@@ -177,7 +177,8 @@ EXPORT_SYMBOL_GPL(srp_iu_get);
 
 void srp_iu_put(struct iu_entry *iue)
 {
-	kfifo_put(&iue->target->iu_queue.queue, (void *) &iue, sizeof(void *));
+	kfifo_put_locked(&iue->target->iu_queue.queue, (void *) &iue,
+			sizeof(void *), &iue->target->iu_queue.lock);
 }
 EXPORT_SYMBOL_GPL(srp_iu_put);
 
diff -puN drivers/usb/host/fhci.h~kfifo-move-out-spinlock drivers/usb/host/fhci.h
--- a/drivers/usb/host/fhci.h~kfifo-move-out-spinlock
+++ a/drivers/usb/host/fhci.h
@@ -495,7 +495,7 @@ static inline struct usb_hcd *fhci_to_hc
 /* fifo of pointers */
 static inline int cq_new(struct kfifo *fifo, int size)
 {
-	return kfifo_alloc(fifo, size * sizeof(void *), GFP_KERNEL, NULL);
+	return kfifo_alloc(fifo, size * sizeof(void *), GFP_KERNEL);
 }
 
 static inline void cq_delete(struct kfifo *kfifo)
diff -puN drivers/usb/serial/generic.c~kfifo-move-out-spinlock drivers/usb/serial/generic.c
--- a/drivers/usb/serial/generic.c~kfifo-move-out-spinlock
+++ a/drivers/usb/serial/generic.c
@@ -285,7 +285,7 @@ static int usb_serial_generic_write_star
 		return 0;
 
 	data = port->write_urb->transfer_buffer;
-	count = kfifo_get(port->write_fifo, data, port->bulk_out_size);
+	count = kfifo_get_locked(port->write_fifo, data, port->bulk_out_size, &port->lock);
 	usb_serial_debug_data(debug, &port->dev, __func__, count, data);
 
 	/* set up our urb */
@@ -345,7 +345,7 @@ int usb_serial_generic_write(struct tty_
 		return usb_serial_multi_urb_write(tty, port,
 						  buf, count);
 
-	count = kfifo_put(port->write_fifo, buf, count);
+	count = kfifo_put_locked(port->write_fifo, buf, count, &port->lock);
 	result = usb_serial_generic_write_start(port);
 
 	if (result >= 0)
diff -puN drivers/usb/serial/usb-serial.c~kfifo-move-out-spinlock drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~kfifo-move-out-spinlock
+++ a/drivers/usb/serial/usb-serial.c
@@ -939,8 +939,7 @@ int usb_serial_probe(struct usb_interfac
 			dev_err(&interface->dev, "No free urbs available\n");
 			goto probe_error;
 		}
-		if (kfifo_alloc(&port->write_fifo, PAGE_SIZE, GFP_KERNEL,
-			&port->lock))
+		if (kfifo_alloc(port->write_fifo, PAGE_SIZE, GFP_KERNEL))
 			goto probe_error;
 		buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 		port->bulk_out_size = buffer_size;
diff -puN include/linux/kfifo.h~kfifo-move-out-spinlock include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-move-out-spinlock
+++ a/include/linux/kfifo.h
@@ -30,13 +30,12 @@ struct kfifo {
 	unsigned int size;	/* the size of the allocated buffer */
 	unsigned int in;	/* data is added at offset (in % size) */
 	unsigned int out;	/* data is extracted from off. (out % size) */
-	spinlock_t *lock;	/* protects concurrent modifications */
 };
 
 extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
-			unsigned int size, spinlock_t *lock);
+			unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
-			gfp_t gfp_mask, spinlock_t *lock);
+			gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
 extern unsigned int __kfifo_put(struct kfifo *fifo,
 				const unsigned char *buffer, unsigned int len);
@@ -58,58 +57,67 @@ static inline void __kfifo_reset(struct 
  */
 static inline void kfifo_reset(struct kfifo *fifo)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(fifo->lock, flags);
-
 	__kfifo_reset(fifo);
+}
+
+/**
+ * __kfifo_len - returns the number of bytes available in the FIFO
+ * @fifo: the fifo to be used.
+ */
+static inline unsigned int __kfifo_len(struct kfifo *fifo)
+{
+	register unsigned int	out;
 
-	spin_unlock_irqrestore(fifo->lock, flags);
+	out = fifo->out;
+	smp_rmb();
+	return fifo->in - out;
 }
 
 /**
- * kfifo_put - puts some data into the FIFO
+ * kfifo_put_locked - puts some data into the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
- * @buffer: the data to be added.
- * @len: the length of the data to be added.
+ * @from: the data to be added.
+ * @n: the length of the data to be added.
+ * @lock: pointer to the spinlock to use for locking.
  *
- * This function copies at most @len bytes from the @buffer into
+ * This function copies at most @len bytes from the @from buffer into
  * the FIFO depending on the free space, and returns the number of
  * bytes copied.
  */
-static inline unsigned int kfifo_put(struct kfifo *fifo,
-				const unsigned char *buffer, unsigned int len)
+static inline __must_check unsigned int kfifo_put_locked(struct kfifo *fifo,
+		const unsigned char *from, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
 	unsigned int ret;
 
-	spin_lock_irqsave(fifo->lock, flags);
+	spin_lock_irqsave(lock, flags);
 
-	ret = __kfifo_put(fifo, buffer, len);
+	ret = __kfifo_put(fifo, from, n);
 
-	spin_unlock_irqrestore(fifo->lock, flags);
+	spin_unlock_irqrestore(lock, flags);
 
 	return ret;
 }
 
 /**
- * kfifo_get - gets some data from the FIFO
+ * kfifo_get_locked - gets some data from the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
- * @buffer: where the data must be copied.
- * @len: the size of the destination buffer.
+ * @to: where the data must be copied.
+ * @n: the size of the destination buffer.
+ * @lock: pointer to the spinlock to use for locking.
  *
  * This function copies at most @len bytes from the FIFO into the
- * @buffer and returns the number of copied bytes.
+ * @to buffer and returns the number of copied bytes.
  */
-static inline unsigned int kfifo_get(struct kfifo *fifo,
-				     unsigned char *buffer, unsigned int len)
+static inline __must_check unsigned int kfifo_get_locked(struct kfifo *fifo,
+	unsigned char *to, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
 	unsigned int ret;
 
-	spin_lock_irqsave(fifo->lock, flags);
+	spin_lock_irqsave(lock, flags);
 
-	ret = __kfifo_get(fifo, buffer, len);
+	ret = __kfifo_get(fifo, to, n);
 
 	/*
 	 * optimization: if the FIFO is empty, set the indices to 0
@@ -118,36 +126,18 @@ static inline unsigned int kfifo_get(str
 	if (fifo->in == fifo->out)
 		fifo->in = fifo->out = 0;
 
-	spin_unlock_irqrestore(fifo->lock, flags);
+	spin_unlock_irqrestore(lock, flags);
 
 	return ret;
 }
 
 /**
- * __kfifo_len - returns the number of bytes available in the FIFO, no locking version
- * @fifo: the fifo to be used.
- */
-static inline unsigned int __kfifo_len(struct kfifo *fifo)
-{
-	return fifo->in - fifo->out;
-}
-
-/**
  * kfifo_len - returns the number of bytes available in the FIFO
  * @fifo: the fifo to be used.
  */
 static inline unsigned int kfifo_len(struct kfifo *fifo)
 {
-	unsigned long flags;
-	unsigned int ret;
-
-	spin_lock_irqsave(fifo->lock, flags);
-
-	ret = __kfifo_len(fifo);
-
-	spin_unlock_irqrestore(fifo->lock, flags);
-
-	return ret;
+	return __kfifo_len(fifo);
 }
 
 #endif
diff -puN kernel/kfifo.c~kfifo-move-out-spinlock kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-move-out-spinlock
+++ a/kernel/kfifo.c
@@ -28,11 +28,10 @@
 #include <linux/log2.h>
 
 static void _kfifo_init(struct kfifo *fifo, unsigned char *buffer,
-		unsigned int size, spinlock_t *lock)
+		unsigned int size)
 {
 	fifo->buffer = buffer;
 	fifo->size = size;
-	fifo->lock = lock;
 
 	kfifo_reset(fifo);
 }
@@ -42,16 +41,14 @@ static void _kfifo_init(struct kfifo *fi
  * @fifo: the fifo to assign the buffer
  * @buffer: the preallocated buffer to be used.
  * @size: the size of the internal buffer, this have to be a power of 2.
- * @lock: the lock to be used to protect the fifo buffer
  *
  */
-void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size,
-			spinlock_t *lock)
+void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size)
 {
 	/* size must be a power of 2 */
 	BUG_ON(!is_power_of_2(size));
 
-	_kfifo_init(fifo, buffer, size, lock);
+	_kfifo_init(fifo, buffer, size);
 }
 EXPORT_SYMBOL(kfifo_init);
 
@@ -60,7 +57,6 @@ EXPORT_SYMBOL(kfifo_init);
  * @fifo: the fifo to assign then new buffer
  * @size: the size of the buffer to be allocated, this have to be a power of 2.
  * @gfp_mask: get_free_pages mask, passed to kmalloc()
- * @lock: the lock to be used to protect the fifo buffer
  *
  * This function dynamically allocates a new fifo internal buffer
  *
@@ -68,8 +64,7 @@ EXPORT_SYMBOL(kfifo_init);
  * The buffer will be release with kfifo_free().
  * Return 0 if no error, otherwise the an error code
  */
-int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask,
-			spinlock_t *lock)
+int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask)
 {
 	unsigned char *buffer;
 
@@ -84,11 +79,11 @@ int kfifo_alloc(struct kfifo *fifo, unsi
 
 	buffer = kmalloc(size, gfp_mask);
 	if (!buffer) {
-		_kfifo_init(fifo, 0, 0, NULL);
+		_kfifo_init(fifo, 0, 0);
 		return -ENOMEM;
 	}
 
-	_kfifo_init(fifo, buffer, size, lock);
+	_kfifo_init(fifo, buffer, size);
 
 	return 0;
 }
diff -puN net/dccp/probe.c~kfifo-move-out-spinlock net/dccp/probe.c
--- a/net/dccp/probe.c~kfifo-move-out-spinlock
+++ a/net/dccp/probe.c
@@ -67,7 +67,7 @@ static void printl(const char *fmt, ...)
 	len += vscnprintf(tbuf+len, sizeof(tbuf)-len, fmt, args);
 	va_end(args);
 
-	kfifo_put(&dccpw.fifo, tbuf, len);
+	kfifo_put_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
 	wake_up(&dccpw.wait);
 }
 
@@ -135,7 +135,7 @@ static ssize_t dccpprobe_read(struct fil
 	if (error)
 		goto out_free;
 
-	cnt = kfifo_get(&dccpw.fifo, tbuf, len);
+	cnt = kfifo_get_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
 	error = copy_to_user(buf, tbuf, cnt) ? -EFAULT : 0;
 
 out_free:
@@ -156,7 +156,7 @@ static __init int dccpprobe_init(void)
 
 	init_waitqueue_head(&dccpw.wait);
 	spin_lock_init(&dccpw.lock);
-	if (kfifo_alloc(&dccpw.fifo, bufsize, GFP_KERNEL, &dccpw.lock))
+	if (kfifo_alloc(&dccpw.fifo, bufsize, GFP_KERNEL))
 		return ret;
 	if (!proc_net_fops_create(&init_net, procname, S_IRUSR, &dccpprobe_fops))
 		goto err0;
_

Patches currently in -mm which might be from stefani@seibold.net are

kfifo-move-struct-kfifo-in-place.patch
kfifo-move-out-spinlock.patch
kfifo-cleanup-namespace.patch
kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch
kfifo-add-kfifo_skip-kfifo_from_user-and-kfifo_to_user.patch
kfifo-add-record-handling-functions.patch

