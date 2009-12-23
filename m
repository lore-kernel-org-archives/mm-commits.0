From: akpm@linux-foundation.org
Subject: [merged] kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out.patch removed from -mm tree
Date: Wed, 23 Dec 2009 12:58:42 -0800
Message-ID: <200912232058.nBNKwg9a021188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947AbZLWU7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Dec 2009 15:59:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, ak@linux.intel.com, arnd@arndb.de, gregkh@suse.de, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kfifo: rename kfifo_put... into kfifo_in... and kfifo_get... into kfifo_out...
has been removed from the -mm tree.  Its filename was
     kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: rename kfifo_put... into kfifo_in... and kfifo_get... into kfifo_out...
From: Stefani Seibold <stefani@seibold.net>

rename kfifo_put...  into kfifo_in...  to prevent miss use of old non in
kernel-tree drivers

ditto for kfifo_get...  -> kfifo_out...

Improve the prototypes of kfifo_in and kfifo_out to make the kerneldoc
annotations more readable.

Add mini "howto porting to the new API" in kfifo.h

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c                       |    4 -
 drivers/char/sonypi.c                       |    8 +--
 drivers/infiniband/hw/cxgb3/cxio_resource.c |   16 +++----
 drivers/media/video/meye.c                  |   16 +++----
 drivers/net/wireless/libertas/main.c        |    5 +-
 drivers/platform/x86/fujitsu-laptop.c       |    4 -
 drivers/platform/x86/sony-laptop.c          |    8 +--
 drivers/scsi/libiscsi.c                     |   14 +++---
 drivers/scsi/libiscsi_tcp.c                 |   18 ++++----
 drivers/scsi/libsrp.c                       |    6 +-
 drivers/usb/host/fhci.h                     |    4 -
 drivers/usb/serial/generic.c                |    4 -
 include/linux/kfifo.h                       |   39 +++++++++++++-----
 kernel/kfifo.c                              |   32 +++++++-------
 net/dccp/probe.c                            |    4 -
 15 files changed, 101 insertions(+), 81 deletions(-)

diff -puN drivers/char/nozomi.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/char/nozomi.c
@@ -798,7 +798,7 @@ static int send_data(enum port_type inde
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
 
 	/* Get data from tty and place in buf for now */
-	size = kfifo_get(&port->fifo_ul, dc->send_buf,
+	size = kfifo_out(&port->fifo_ul, dc->send_buf,
 			   ul_size < SEND_BUF_MAX ? ul_size : SEND_BUF_MAX);
 
 	if (size == 0) {
@@ -1672,7 +1672,7 @@ static int ntty_write(struct tty_struct 
 		goto exit;
 	}
 
-	rval = kfifo_put(&port->fifo_ul, (unsigned char *)buffer, count);
+	rval = kfifo_in(&port->fifo_ul, (unsigned char *)buffer, count);
 
 	/* notify card */
 	if (unlikely(dc == NULL)) {
diff -puN drivers/char/sonypi.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/char/sonypi.c
--- a/drivers/char/sonypi.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/char/sonypi.c
@@ -777,7 +777,7 @@ static void input_keyrelease(struct work
 {
 	struct sonypi_keypress kp;
 
-	while (kfifo_get_locked(&sonypi_device.input_fifo, (unsigned char *)&kp,
+	while (kfifo_out_locked(&sonypi_device.input_fifo, (unsigned char *)&kp,
 			 sizeof(kp), &sonypi_device.input_fifo_lock)
 			== sizeof(kp)) {
 		msleep(10);
@@ -828,7 +828,7 @@ static void sonypi_report_input_event(u8
 	if (kp.dev) {
 		input_report_key(kp.dev, kp.key, 1);
 		input_sync(kp.dev);
-		kfifo_put_locked(&sonypi_device.input_fifo,
+		kfifo_in_locked(&sonypi_device.input_fifo,
 			(unsigned char *)&kp, sizeof(kp),
 			&sonypi_device.input_fifo_lock);
 		schedule_work(&sonypi_device.input_work);
@@ -882,7 +882,7 @@ found:
 		acpi_bus_generate_proc_event(sonypi_acpi_device, 1, event);
 #endif
 
-	kfifo_put_locked(&sonypi_device.fifo, (unsigned char *)&event,
+	kfifo_in_locked(&sonypi_device.fifo, (unsigned char *)&event,
 			sizeof(event), &sonypi_device.fifo_lock);
 	kill_fasync(&sonypi_device.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_device.fifo_proc_list);
@@ -932,7 +932,7 @@ static ssize_t sonypi_misc_read(struct f
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_get_locked(&sonypi_device.fifo, &c, sizeof(c),
+	       (kfifo_out_locked(&sonypi_device.fifo, &c, sizeof(c),
 				 &sonypi_device.fifo_lock) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
diff -puN drivers/infiniband/hw/cxgb3/cxio_resource.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/infiniband/hw/cxgb3/cxio_resource.c
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -59,7 +59,7 @@ static int __cxio_init_resource_fifo(str
 		return -ENOMEM;
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32));
+		kfifo_in(fifo, (unsigned char *) &entry, sizeof(u32));
 	if (random) {
 		j = 0;
 		random_bytes = random32();
@@ -71,22 +71,22 @@ static int __cxio_init_resource_fifo(str
 				random_bytes = random32();
 			}
 			idx = (random_bytes >> (j * 2)) & 0xF;
-			kfifo_put(fifo,
+			kfifo_in(fifo,
 				(unsigned char *) &rarray[idx],
 				sizeof(u32));
 			rarray[idx] = i;
 			j++;
 		}
 		for (i = 0; i < RANDOM_SIZE; i++)
-			kfifo_put(fifo,
+			kfifo_in(fifo,
 				(unsigned char *) &rarray[i],
 				sizeof(u32));
 	} else
 		for (i = skip_low; i < nr - skip_high; i++)
-			kfifo_put(fifo, (unsigned char *) &i, sizeof(u32));
+			kfifo_in(fifo, (unsigned char *) &i, sizeof(u32));
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_get_locked(fifo, (unsigned char *) &entry,
+		kfifo_out_locked(fifo, (unsigned char *) &entry,
 				sizeof(u32), fifo_lock);
 	return 0;
 }
@@ -119,7 +119,7 @@ static int cxio_init_qpid_fifo(struct cx
 
 	for (i = 16; i < T3_MAX_NUM_QP; i++)
 		if (!(i & rdev_p->qpmask))
-			kfifo_put(&rdev_p->rscp->qpid_fifo,
+			kfifo_in(&rdev_p->rscp->qpid_fifo,
 				    (unsigned char *) &i, sizeof(u32));
 	return 0;
 }
@@ -180,7 +180,7 @@ tpt_err:
 static u32 cxio_hal_get_resource(struct kfifo *fifo, spinlock_t * lock)
 {
 	u32 entry;
-	if (kfifo_get_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock))
+	if (kfifo_out_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock))
 		return entry;
 	else
 		return 0;	/* fifo emptry */
@@ -190,7 +190,7 @@ static void cxio_hal_put_resource(struct
 		u32 entry)
 {
 	BUG_ON(
-	kfifo_put_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock)
+	kfifo_in_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock)
 	== 0);
 }
 
diff -puN drivers/media/video/meye.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/media/video/meye.c
--- a/drivers/media/video/meye.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/media/video/meye.c
@@ -800,7 +800,7 @@ again:
 		return IRQ_HANDLED;
 
 	if (meye.mchip_mode == MCHIP_HIC_MODE_CONT_OUT) {
-		if (kfifo_get_locked(&meye.grabq, (unsigned char *)&reqnr,
+		if (kfifo_out_locked(&meye.grabq, (unsigned char *)&reqnr,
 			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
 			mchip_free_frame();
 			return IRQ_HANDLED;
@@ -811,7 +811,7 @@ again:
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_put_locked(&meye.doneq, (unsigned char *)&reqnr,
+		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
 				sizeof(int), &meye.doneq_lock);
 		wake_up_interruptible(&meye.proc_list);
 	} else {
@@ -821,7 +821,7 @@ again:
 			mchip_free_frame();
 			goto again;
 		}
-		if (kfifo_get_locked(&meye.grabq, (unsigned char *)&reqnr,
+		if (kfifo_out_locked(&meye.grabq, (unsigned char *)&reqnr,
 			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
 			mchip_free_frame();
 			goto again;
@@ -832,7 +832,7 @@ again:
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_put_locked(&meye.doneq, (unsigned char *)&reqnr,
+		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
 				sizeof(int), &meye.doneq_lock);
 		wake_up_interruptible(&meye.proc_list);
 	}
@@ -935,7 +935,7 @@ static int meyeioc_qbuf_capt(int *nb)
 		mchip_cont_compression_start();
 
 	meye.grab_buffer[*nb].state = MEYE_BUF_USING;
-	kfifo_put_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
+	kfifo_in_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
 			 &meye.grabq_lock);
 	mutex_unlock(&meye.lock);
 
@@ -968,7 +968,7 @@ static int meyeioc_sync(struct file *fil
 		/* fall through */
 	case MEYE_BUF_DONE:
 		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
-		kfifo_get_locked(&meye.doneq, (unsigned char *)&unused,
+		kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
 				sizeof(int), &meye.doneq_lock);
 	}
 	*i = meye.grab_buffer[*i].size;
@@ -1456,7 +1456,7 @@ static int vidioc_qbuf(struct file *file
 	buf->flags |= V4L2_BUF_FLAG_QUEUED;
 	buf->flags &= ~V4L2_BUF_FLAG_DONE;
 	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
-	kfifo_put_locked(&meye.grabq, (unsigned char *)&buf->index,
+	kfifo_in_locked(&meye.grabq, (unsigned char *)&buf->index,
 			sizeof(int), &meye.grabq_lock);
 	mutex_unlock(&meye.lock);
 
@@ -1483,7 +1483,7 @@ static int vidioc_dqbuf(struct file *fil
 		return -EINTR;
 	}
 
-	if (!kfifo_get_locked(&meye.doneq, (unsigned char *)&reqnr,
+	if (!kfifo_out_locked(&meye.doneq, (unsigned char *)&reqnr,
 		       sizeof(int), &meye.doneq_lock)) {
 		mutex_unlock(&meye.lock);
 		return -EBUSY;
diff -puN drivers/net/wireless/libertas/main.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/net/wireless/libertas/main.c
--- a/drivers/net/wireless/libertas/main.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/net/wireless/libertas/main.c
@@ -513,7 +513,8 @@ static int lbs_thread(void *data)
 		spin_lock_irq(&priv->driver_lock);
 		while (kfifo_len(&priv->event_fifo)) {
 			u32 event;
-			kfifo_get(&priv->event_fifo, (unsigned char *) &event,
+
+			kfifo_out(&priv->event_fifo, (unsigned char *) &event,
 				sizeof(event));
 			spin_unlock_irq(&priv->driver_lock);
 			lbs_process_event(priv, event);
@@ -1175,7 +1176,7 @@ void lbs_queue_event(struct lbs_private 
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
 
-	kfifo_put(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
+	kfifo_in(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
 
 	wake_up_interruptible(&priv->waitq);
 
diff -puN drivers/platform/x86/fujitsu-laptop.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/platform/x86/fujitsu-laptop.c
@@ -1006,7 +1006,7 @@ static void acpi_fujitsu_hotkey_notify(s
 				vdbg_printk(FUJLAPTOP_DBG_TRACE,
 					"Push keycode into ringbuffer [%d]\n",
 					keycode);
-				status = kfifo_put_locked(&fujitsu_hotkey->fifo,
+				status = kfifo_in_locked(&fujitsu_hotkey->fifo,
 						   (unsigned char *)&keycode,
 						   sizeof(keycode),
 						   &fujitsu_hotkey->fifo_lock);
@@ -1020,7 +1020,7 @@ static void acpi_fujitsu_hotkey_notify(s
 				}
 			} else if (keycode == 0) {
 				while ((status =
-					kfifo_get_locked(
+					kfifo_out_locked(
 					 &fujitsu_hotkey->fifo,
 					 (unsigned char *) &keycode_r,
 					 sizeof(keycode_r),
diff -puN drivers/platform/x86/sony-laptop.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/platform/x86/sony-laptop.c
@@ -300,7 +300,7 @@ static void do_sony_laptop_release_key(s
 {
 	struct sony_laptop_keypress kp;
 
-	while (kfifo_get_locked(&sony_laptop_input.fifo, (unsigned char *)&kp,
+	while (kfifo_out_locked(&sony_laptop_input.fifo, (unsigned char *)&kp,
 			sizeof(kp), &sony_laptop_input.fifo_lock)
 			== sizeof(kp)) {
 		msleep(10);
@@ -363,7 +363,7 @@ static void sony_laptop_report_input_eve
 		/* we emit the scancode so we can always remap the key */
 		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
 		input_sync(kp.dev);
-		kfifo_put_locked(&sony_laptop_input.fifo,
+		kfifo_in_locked(&sony_laptop_input.fifo,
 			  (unsigned char *)&kp, sizeof(kp),
 			  &sony_laptop_input.fifo_lock);
 
@@ -2130,7 +2130,7 @@ static ssize_t sonypi_misc_read(struct f
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_get_locked(&sonypi_compat.fifo, &c, sizeof(c),
+	       (kfifo_out_locked(&sonypi_compat.fifo, &c, sizeof(c),
 			  &sonypi_compat.fifo_lock) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
@@ -2310,7 +2310,7 @@ static struct miscdevice sonypi_misc_dev
 
 static void sonypi_compat_report_event(u8 event)
 {
-	kfifo_put_locked(&sonypi_compat.fifo, (unsigned char *)&event,
+	kfifo_in_locked(&sonypi_compat.fifo, (unsigned char *)&event,
 			sizeof(event), &sonypi_compat.fifo_lock);
 	kill_fasync(&sonypi_compat.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_compat.fifo_proc_list);
diff -puN drivers/scsi/libiscsi.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/scsi/libiscsi.c
--- a/drivers/scsi/libiscsi.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/scsi/libiscsi.c
@@ -517,7 +517,7 @@ static void iscsi_free_task(struct iscsi
 	if (conn->login_task == task)
 		return;
 
-	kfifo_put(&session->cmdpool.queue, (void*)&task, sizeof(void*));
+	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (sc) {
 		task->sc = NULL;
@@ -737,7 +737,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn 
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!kfifo_get(&session->cmdpool.queue,
+		if (!kfifo_out(&session->cmdpool.queue,
 				 (void*)&task, sizeof(void*)))
 			return NULL;
 	}
@@ -1567,7 +1567,7 @@ static inline struct iscsi_task *iscsi_a
 {
 	struct iscsi_task *task;
 
-	if (!kfifo_get(&conn->session->cmdpool.queue,
+	if (!kfifo_out(&conn->session->cmdpool.queue,
 			 (void *) &task, sizeof(void *)))
 		return NULL;
 
@@ -2469,7 +2469,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
 			q->max = i;
 			goto enomem;
 		}
-		kfifo_put(&q->queue, (void*)&q->pool[i], sizeof(void*));
+		kfifo_in(&q->queue, (void*)&q->pool[i], sizeof(void*));
 	}
 
 	if (items) {
@@ -2819,7 +2819,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->lock);
-	if (!kfifo_get(&session->cmdpool.queue,
+	if (!kfifo_out(&session->cmdpool.queue,
                          (void*)&conn->login_task,
 			 sizeof(void*))) {
 		spin_unlock_bh(&session->lock);
@@ -2839,7 +2839,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
@@ -2902,7 +2902,7 @@ void iscsi_conn_teardown(struct iscsi_cl
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
-	kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
diff -puN drivers/scsi/libiscsi_tcp.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/scsi/libiscsi_tcp.c
--- a/drivers/scsi/libiscsi_tcp.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/scsi/libiscsi_tcp.c
@@ -445,15 +445,15 @@ void iscsi_tcp_cleanup_task(struct iscsi
 		return;
 
 	/* flush task's r2t queues */
-	while (kfifo_get(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
-		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+	while (kfifo_out(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
+		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		ISCSI_DBG_TCP(task->conn, "pending r2t dropped\n");
 	}
 
 	r2t = tcp_task->r2t;
 	if (r2t != NULL) {
-		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		tcp_task->r2t = NULL;
 	}
@@ -541,7 +541,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 		return 0;
 	}
 
-	rc = kfifo_get(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
+	rc = kfifo_out(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
 	if (!rc) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
 				  "Target has sent more R2Ts than it "
@@ -554,7 +554,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 	if (r2t->data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -570,7 +570,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", r2t->data_length,
 				  r2t->data_offset, scsi_out(task->sc)->length);
-		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -580,7 +580,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 	r2t->sent = 0;
 
 	tcp_task->exp_datasn = r2tsn + 1;
-	kfifo_put(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
+	kfifo_in(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
 	conn->r2t_pdus_cnt++;
 
 	iscsi_requeue_task(task);
@@ -982,7 +982,7 @@ static struct iscsi_r2t_info *iscsi_tcp_
 			if (r2t->data_length <= r2t->sent) {
 				ISCSI_DBG_TCP(task->conn,
 					      "  done with r2t %p\n", r2t);
-				kfifo_put(&tcp_task->r2tpool.queue,
+				kfifo_in(&tcp_task->r2tpool.queue,
 					    (void *)&tcp_task->r2t,
 					    sizeof(void *));
 				tcp_task->r2t = r2t = NULL;
@@ -990,7 +990,7 @@ static struct iscsi_r2t_info *iscsi_tcp_
 		}
 
 		if (r2t == NULL) {
-			kfifo_get(&tcp_task->r2tqueue,
+			kfifo_out(&tcp_task->r2tqueue,
 				    (void *)&tcp_task->r2t, sizeof(void *));
 			r2t = tcp_task->r2t;
 		}
diff -puN drivers/scsi/libsrp.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/scsi/libsrp.c
--- a/drivers/scsi/libsrp.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/scsi/libsrp.c
@@ -61,7 +61,7 @@ static int srp_iu_pool_alloc(struct srp_
 	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
 	for (i = 0, iue = q->items; i < max; i++) {
-		kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
+		kfifo_in(&q->queue, (void *) &iue, sizeof(void *));
 		iue->sbuf = ring[i];
 		iue++;
 	}
@@ -163,7 +163,7 @@ struct iu_entry *srp_iu_get(struct srp_t
 {
 	struct iu_entry *iue = NULL;
 
-	kfifo_get_locked(&target->iu_queue.queue, (void *) &iue,
+	kfifo_out_locked(&target->iu_queue.queue, (void *) &iue,
 			sizeof(void *), &target->iu_queue.lock);
 	if (!iue)
 		return iue;
@@ -176,7 +176,7 @@ EXPORT_SYMBOL_GPL(srp_iu_get);
 
 void srp_iu_put(struct iu_entry *iue)
 {
-	kfifo_put_locked(&iue->target->iu_queue.queue, (void *) &iue,
+	kfifo_in_locked(&iue->target->iu_queue.queue, (void *) &iue,
 			sizeof(void *), &iue->target->iu_queue.lock);
 }
 EXPORT_SYMBOL_GPL(srp_iu_put);
diff -puN drivers/usb/host/fhci.h~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/usb/host/fhci.h
--- a/drivers/usb/host/fhci.h~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/usb/host/fhci.h
@@ -510,14 +510,14 @@ static inline unsigned int cq_howmany(st
 
 static inline int cq_put(struct kfifo *kfifo, void *p)
 {
-	return kfifo_put(kfifo, (void *)&p, sizeof(p));
+	return kfifo_in(kfifo, (void *)&p, sizeof(p));
 }
 
 static inline void *cq_get(struct kfifo *kfifo)
 {
 	void *p = NULL;
 
-	kfifo_get(kfifo, (void *)&p, sizeof(p));
+	kfifo_out(kfifo, (void *)&p, sizeof(p));
 	return p;
 }
 
diff -puN drivers/usb/serial/generic.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out drivers/usb/serial/generic.c
--- a/drivers/usb/serial/generic.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/drivers/usb/serial/generic.c
@@ -285,7 +285,7 @@ static int usb_serial_generic_write_star
 		return 0;
 
 	data = port->write_urb->transfer_buffer;
-	count = kfifo_get_locked(port->write_fifo, data, port->bulk_out_size, &port->lock);
+	count = kfifo_out_locked(port->write_fifo, data, port->bulk_out_size, &port->lock);
 	usb_serial_debug_data(debug, &port->dev, __func__, count, data);
 
 	/* set up our urb */
@@ -345,7 +345,7 @@ int usb_serial_generic_write(struct tty_
 		return usb_serial_multi_urb_write(tty, port,
 						  buf, count);
 
-	count = kfifo_put_locked(port->write_fifo, buf, count, &port->lock);
+	count = kfifo_in_locked(port->write_fifo, buf, count, &port->lock);
 	result = usb_serial_generic_write_start(port);
 
 	if (result >= 0)
diff -puN include/linux/kfifo.h~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/include/linux/kfifo.h
@@ -19,6 +19,25 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  */
+
+/*
+ * Howto porting drivers to the new generic fifo API:
+ *
+ * - Modify the declaration of the "struct kfifo *" object into a
+ *   in-place "struct kfifo" object
+ * - Init the in-place object with kfifo_alloc() or kfifo_init()
+ *   Note: The address of the in-place "struct kfifo" object must be
+ *   passed as the first argument to this functions
+ * - Replace the use of __kfifo_put into kfifo_in and __kfifo_get
+ *   into kfifo_out
+ * - Replace the use of kfifo_put into kfifo_in_locked and kfifo_get
+ *   into kfifo_out_locked
+ *   Note: the spinlock pointer formerly passed to kfifo_init/kfifo_alloc
+ *   must be passed now to the kfifo_in_locked and kfifo_out_locked
+ *   as the last parameter.
+ * - All formerly name __kfifo_* functions has been renamed into kfifo_*
+ */
+
 #ifndef _LINUX_KFIFO_H
 #define _LINUX_KFIFO_H
 
@@ -37,10 +56,10 @@ extern void kfifo_init(struct kfifo *fif
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
 			gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
-extern unsigned int kfifo_put(struct kfifo *fifo,
-				const unsigned char *buffer, unsigned int len);
-extern unsigned int kfifo_get(struct kfifo *fifo,
-				unsigned char *buffer, unsigned int len);
+extern __must_check unsigned int kfifo_in(struct kfifo *fifo,
+				const unsigned char *from, unsigned int len);
+extern __must_check unsigned int kfifo_out(struct kfifo *fifo,
+				unsigned char *to, unsigned int len);
 
 /**
  * kfifo_reset - removes the entire FIFO contents
@@ -65,7 +84,7 @@ static inline unsigned int kfifo_len(str
 }
 
 /**
- * kfifo_put_locked - puts some data into the FIFO using a spinlock for locking
+ * kfifo_in_locked - puts some data into the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
  * @from: the data to be added.
  * @n: the length of the data to be added.
@@ -75,7 +94,7 @@ static inline unsigned int kfifo_len(str
  * the FIFO depending on the free space, and returns the number of
  * bytes copied.
  */
-static inline __must_check unsigned int kfifo_put_locked(struct kfifo *fifo,
+static inline __must_check unsigned int kfifo_in_locked(struct kfifo *fifo,
 		const unsigned char *from, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
@@ -83,7 +102,7 @@ static inline __must_check unsigned int 
 
 	spin_lock_irqsave(lock, flags);
 
-	ret = kfifo_put(fifo, from, n);
+	ret = kfifo_in(fifo, from, n);
 
 	spin_unlock_irqrestore(lock, flags);
 
@@ -91,7 +110,7 @@ static inline __must_check unsigned int 
 }
 
 /**
- * kfifo_get_locked - gets some data from the FIFO using a spinlock for locking
+ * kfifo_out_locked - gets some data from the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
  * @to: where the data must be copied.
  * @n: the size of the destination buffer.
@@ -100,7 +119,7 @@ static inline __must_check unsigned int 
  * This function copies at most @len bytes from the FIFO into the
  * @to buffer and returns the number of copied bytes.
  */
-static inline __must_check unsigned int kfifo_get_locked(struct kfifo *fifo,
+static inline __must_check unsigned int kfifo_out_locked(struct kfifo *fifo,
 	unsigned char *to, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
@@ -108,7 +127,7 @@ static inline __must_check unsigned int 
 
 	spin_lock_irqsave(lock, flags);
 
-	ret = kfifo_get(fifo, to, n);
+	ret = kfifo_out(fifo, to, n);
 
 	/*
 	 * optimization: if the FIFO is empty, set the indices to 0
diff -puN kernel/kfifo.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/kernel/kfifo.c
@@ -100,20 +100,20 @@ void kfifo_free(struct kfifo *fifo)
 EXPORT_SYMBOL(kfifo_free);
 
 /**
- * kfifo_put - puts some data into the FIFO, no locking version
+ * kfifo_in - puts some data into the FIFO
  * @fifo: the fifo to be used.
- * @buffer: the data to be added.
+ * @from: the data to be added.
  * @len: the length of the data to be added.
  *
- * This function copies at most @len bytes from the @buffer into
+ * This function copies at most @len bytes from the @from buffer into
  * the FIFO depending on the free space, and returns the number of
  * bytes copied.
  *
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_put(struct kfifo *fifo,
-			const unsigned char *buffer, unsigned int len)
+unsigned int kfifo_in(struct kfifo *fifo,
+			const unsigned char *from, unsigned int len)
 {
 	unsigned int l;
 
@@ -128,10 +128,10 @@ unsigned int kfifo_put(struct kfifo *fif
 
 	/* first put the data starting from fifo->in to buffer end */
 	l = min(len, fifo->size - (fifo->in & (fifo->size - 1)));
-	memcpy(fifo->buffer + (fifo->in & (fifo->size - 1)), buffer, l);
+	memcpy(fifo->buffer + (fifo->in & (fifo->size - 1)), from, l);
 
 	/* then put the rest (if any) at the beginning of the buffer */
-	memcpy(fifo->buffer, buffer + l, len - l);
+	memcpy(fifo->buffer, from + l, len - l);
 
 	/*
 	 * Ensure that we add the bytes to the kfifo -before-
@@ -144,22 +144,22 @@ unsigned int kfifo_put(struct kfifo *fif
 
 	return len;
 }
-EXPORT_SYMBOL(kfifo_put);
+EXPORT_SYMBOL(kfifo_in);
 
 /**
- * kfifo_get - gets some data from the FIFO, no locking version
+ * kfifo_out - gets some data from the FIFO
  * @fifo: the fifo to be used.
- * @buffer: where the data must be copied.
+ * @to: where the data must be copied.
  * @len: the size of the destination buffer.
  *
  * This function copies at most @len bytes from the FIFO into the
- * @buffer and returns the number of copied bytes.
+ * @to buffer and returns the number of copied bytes.
  *
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_get(struct kfifo *fifo,
-			 unsigned char *buffer, unsigned int len)
+unsigned int kfifo_out(struct kfifo *fifo,
+			 unsigned char *to, unsigned int len)
 {
 	unsigned int l;
 
@@ -174,10 +174,10 @@ unsigned int kfifo_get(struct kfifo *fif
 
 	/* first get the data from fifo->out until the end of the buffer */
 	l = min(len, fifo->size - (fifo->out & (fifo->size - 1)));
-	memcpy(buffer, fifo->buffer + (fifo->out & (fifo->size - 1)), l);
+	memcpy(to, fifo->buffer + (fifo->out & (fifo->size - 1)), l);
 
 	/* then get the rest (if any) from the beginning of the buffer */
-	memcpy(buffer + l, fifo->buffer, len - l);
+	memcpy(to + l, fifo->buffer, len - l);
 
 	/*
 	 * Ensure that we remove the bytes from the kfifo -before-
@@ -190,4 +190,4 @@ unsigned int kfifo_get(struct kfifo *fif
 
 	return len;
 }
-EXPORT_SYMBOL(kfifo_get);
+EXPORT_SYMBOL(kfifo_out);
diff -puN net/dccp/probe.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out net/dccp/probe.c
--- a/net/dccp/probe.c~kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out
+++ a/net/dccp/probe.c
@@ -67,7 +67,7 @@ static void printl(const char *fmt, ...)
 	len += vscnprintf(tbuf+len, sizeof(tbuf)-len, fmt, args);
 	va_end(args);
 
-	kfifo_put_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
+	kfifo_in_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
 	wake_up(&dccpw.wait);
 }
 
@@ -135,7 +135,7 @@ static ssize_t dccpprobe_read(struct fil
 	if (error)
 		goto out_free;
 
-	cnt = kfifo_get_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
+	cnt = kfifo_out_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
 	error = copy_to_user(buf, tbuf, cnt) ? -EFAULT : 0;
 
 out_free:
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch

