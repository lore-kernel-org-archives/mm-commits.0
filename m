From: akpm@linux-foundation.org
Subject: + kfifo-cleanup-namespace.patch added to -mm tree
Date: Mon, 23 Nov 2009 14:19:00 -0800
Message-ID: <200911232219.nANMJ1lr019857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001AbZKWWTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 17:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, ak@linux.intel.com, arnd@arndb.de, gregkh@suse.de, mchehab@redhat.com


The patch titled
     kfifo: cleanup namespace
has been added to the -mm tree.  Its filename is
     kfifo-cleanup-namespace.patch

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
Subject: kfifo: cleanup namespace
From: Stefani Seibold <stefani@seibold.net>

change name of __kfifo_* functions to kfifo_*, because the prefix __kfifo
should be reserved for internal functions only.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c                       |   12 +++---
 drivers/infiniband/hw/cxgb3/cxio_resource.c |   10 ++---
 drivers/net/wireless/libertas/cmd.c         |    4 +-
 drivers/net/wireless/libertas/main.c        |    8 ++--
 drivers/platform/x86/sony-laptop.c          |    2 -
 drivers/scsi/libiscsi.c                     |   14 +++----
 drivers/scsi/libiscsi_tcp.c                 |   20 +++++------
 drivers/scsi/libsrp.c                       |    2 -
 drivers/usb/host/fhci.h                     |    6 +--
 drivers/usb/serial/generic.c                |    4 +-
 include/linux/kfifo.h                       |   32 +++---------------
 kernel/kfifo.c                              |   12 +++---
 net/dccp/probe.c                            |    2 -
 13 files changed, 55 insertions(+), 73 deletions(-)

diff -puN drivers/char/nozomi.c~kfifo-cleanup-namespace drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~kfifo-cleanup-namespace
+++ a/drivers/char/nozomi.c
@@ -798,7 +798,7 @@ static int send_data(enum port_type inde
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
 
 	/* Get data from tty and place in buf for now */
-	size = __kfifo_get(&port->fifo_ul, dc->send_buf,
+	size = kfifo_get(&port->fifo_ul, dc->send_buf,
 			   ul_size < SEND_BUF_MAX ? ul_size : SEND_BUF_MAX);
 
 	if (size == 0) {
@@ -988,11 +988,11 @@ static int receive_flow_control(struct n
 
 	} else if (old_ctrl.CTS == 0 && ctrl_dl.CTS == 1) {
 
-		if (__kfifo_len(&dc->port[port].fifo_ul)) {
+		if (kfifo_len(&dc->port[port].fifo_ul)) {
 			DBG1("Enable interrupt (0x%04X) on port: %d",
 				enable_ier, port);
 			DBG1("Data in buffer [%d], enable transmit! ",
-				__kfifo_len(&dc->port[port].fifo_ul));
+				kfifo_len(&dc->port[port].fifo_ul));
 			enable_transmit_ul(port, dc);
 		} else {
 			DBG1("No data in buffer...");
@@ -1672,7 +1672,7 @@ static int ntty_write(struct tty_struct 
 		goto exit;
 	}
 
-	rval = __kfifo_put(&port->fifo_ul, (unsigned char *)buffer, count);
+	rval = kfifo_put(&port->fifo_ul, (unsigned char *)buffer, count);
 
 	/* notify card */
 	if (unlikely(dc == NULL)) {
@@ -1720,7 +1720,7 @@ static int ntty_write_room(struct tty_st
 	if (!port->port.count)
 		goto exit;
 
-	room = port->fifo_ul.size - __kfifo_len(&port->fifo_ul);
+	room = port->fifo_ul.size - kfifo_len(&port->fifo_ul);
 
 exit:
 	mutex_unlock(&port->tty_sem);
@@ -1877,7 +1877,7 @@ static s32 ntty_chars_in_buffer(struct t
 		goto exit_in_buffer;
 	}
 
-	rval = __kfifo_len(&port->fifo_ul);
+	rval = kfifo_len(&port->fifo_ul);
 
 exit_in_buffer:
 	return rval;
diff -puN drivers/infiniband/hw/cxgb3/cxio_resource.c~kfifo-cleanup-namespace drivers/infiniband/hw/cxgb3/cxio_resource.c
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c~kfifo-cleanup-namespace
+++ a/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -59,7 +59,7 @@ static int __cxio_init_resource_fifo(str
 		return -ENOMEM;
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		__kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32));
+		kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32));
 	if (random) {
 		j = 0;
 		random_bytes = random32();
@@ -71,19 +71,19 @@ static int __cxio_init_resource_fifo(str
 				random_bytes = random32();
 			}
 			idx = (random_bytes >> (j * 2)) & 0xF;
-			__kfifo_put(fifo,
+			kfifo_put(fifo,
 				(unsigned char *) &rarray[idx],
 				sizeof(u32));
 			rarray[idx] = i;
 			j++;
 		}
 		for (i = 0; i < RANDOM_SIZE; i++)
-			__kfifo_put(fifo,
+			kfifo_put(fifo,
 				(unsigned char *) &rarray[i],
 				sizeof(u32));
 	} else
 		for (i = skip_low; i < nr - skip_high; i++)
-			__kfifo_put(fifo, (unsigned char *) &i, sizeof(u32));
+			kfifo_put(fifo, (unsigned char *) &i, sizeof(u32));
 
 	for (i = 0; i < skip_low + skip_high; i++)
 		kfifo_get_locked(fifo, (unsigned char *) &entry,
@@ -119,7 +119,7 @@ static int cxio_init_qpid_fifo(struct cx
 
 	for (i = 16; i < T3_MAX_NUM_QP; i++)
 		if (!(i & rdev_p->qpmask))
-			__kfifo_put(&rdev_p->rscp->qpid_fifo,
+			kfifo_put(&rdev_p->rscp->qpid_fifo,
 				    (unsigned char *) &i, sizeof(u32));
 	return 0;
 }
diff -puN drivers/net/wireless/libertas/cmd.c~kfifo-cleanup-namespace drivers/net/wireless/libertas/cmd.c
--- a/drivers/net/wireless/libertas/cmd.c~kfifo-cleanup-namespace
+++ a/drivers/net/wireless/libertas/cmd.c
@@ -1533,7 +1533,7 @@ static void lbs_send_confirmsleep(struct
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
 	/* If nothing to do, go back to sleep (?) */
-	if (!__kfifo_len(&priv->event_fifo) && !priv->resp_len[priv->resp_idx])
+	if (!kfifo_len(&priv->event_fifo) && !priv->resp_len[priv->resp_idx])
 		priv->psstate = PS_STATE_SLEEP;
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -1607,7 +1607,7 @@ void lbs_ps_confirm_sleep(struct lbs_pri
 	}
 
 	/* Pending events or command responses? */
-	if (__kfifo_len(&priv->event_fifo) || priv->resp_len[priv->resp_idx]) {
+	if (kfifo_len(&priv->event_fifo) || priv->resp_len[priv->resp_idx]) {
 		allowed = 0;
 		lbs_deb_host("pending events or command responses\n");
 	}
diff -puN drivers/net/wireless/libertas/main.c~kfifo-cleanup-namespace drivers/net/wireless/libertas/main.c
--- a/drivers/net/wireless/libertas/main.c~kfifo-cleanup-namespace
+++ a/drivers/net/wireless/libertas/main.c
@@ -657,7 +657,7 @@ static int lbs_thread(void *data)
 		else if (!list_empty(&priv->cmdpendingq) &&
 					!(priv->wakeup_dev_required))
 			shouldsleep = 0;	/* We have a command to send */
-		else if (__kfifo_len(&priv->event_fifo))
+		else if (kfifo_len(&priv->event_fifo))
 			shouldsleep = 0;	/* We have an event to process */
 		else
 			shouldsleep = 1;	/* No command */
@@ -709,9 +709,9 @@ static int lbs_thread(void *data)
 
 		/* Process hardware events, e.g. card removed, link lost */
 		spin_lock_irq(&priv->driver_lock);
-		while (__kfifo_len(&priv->event_fifo)) {
+		while (kfifo_len(&priv->event_fifo)) {
 			u32 event;
-			__kfifo_get(&priv->event_fifo, (unsigned char *) &event,
+			kfifo_get(&priv->event_fifo, (unsigned char *) &event,
 				sizeof(event));
 			spin_unlock_irq(&priv->driver_lock);
 			lbs_process_event(priv, event);
@@ -1502,7 +1502,7 @@ void lbs_queue_event(struct lbs_private 
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
 
-	__kfifo_put(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
+	kfifo_put(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
 
 	wake_up_interruptible(&priv->waitq);
 
diff -puN drivers/platform/x86/sony-laptop.c~kfifo-cleanup-namespace drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~kfifo-cleanup-namespace
+++ a/drivers/platform/x86/sony-laptop.c
@@ -2107,7 +2107,7 @@ static int sonypi_misc_open(struct inode
 	spin_lock_irqsave(&sonypi_compat.fifo_lock, flags);
 
 	if (atomic_inc_return(&sonypi_compat.open_count) == 1)
-		__kfifo_reset(&sonypi_compat.fifo);
+		kfifo_reset(&sonypi_compat.fifo);
 
 	spin_unlock_irqrestore(&sonypi_compat.fifo_lock, flags);
 
diff -puN drivers/scsi/libiscsi.c~kfifo-cleanup-namespace drivers/scsi/libiscsi.c
--- a/drivers/scsi/libiscsi.c~kfifo-cleanup-namespace
+++ a/drivers/scsi/libiscsi.c
@@ -517,7 +517,7 @@ static void iscsi_free_task(struct iscsi
 	if (conn->login_task == task)
 		return;
 
-	__kfifo_put(&session->cmdpool.queue, (void*)&task, sizeof(void*));
+	kfifo_put(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (sc) {
 		task->sc = NULL;
@@ -737,7 +737,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn 
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-		if (!__kfifo_get(&session->cmdpool.queue,
+		if (!kfifo_get(&session->cmdpool.queue,
 				 (void*)&task, sizeof(void*)))
 			return NULL;
 	}
@@ -1567,7 +1567,7 @@ static inline struct iscsi_task *iscsi_a
 {
 	struct iscsi_task *task;
 
-	if (!__kfifo_get(&conn->session->cmdpool.queue,
+	if (!kfifo_get(&conn->session->cmdpool.queue,
 			 (void *) &task, sizeof(void *)))
 		return NULL;
 
@@ -2469,7 +2469,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
 			q->max = i;
 			goto enomem;
 		}
-		__kfifo_put(&q->queue, (void*)&q->pool[i], sizeof(void*));
+		kfifo_put(&q->queue, (void*)&q->pool[i], sizeof(void*));
 	}
 
 	if (items) {
@@ -2819,7 +2819,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 
 	/* allocate login_task used for the login/text sequences */
 	spin_lock_bh(&session->lock);
-	if (!__kfifo_get(&session->cmdpool.queue,
+	if (!kfifo_get(&session->cmdpool.queue,
                          (void*)&conn->login_task,
 			 sizeof(void*))) {
 		spin_unlock_bh(&session->lock);
@@ -2839,7 +2839,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	__kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
@@ -2902,7 +2902,7 @@ void iscsi_conn_teardown(struct iscsi_cl
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
-	__kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_put(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
diff -puN drivers/scsi/libiscsi_tcp.c~kfifo-cleanup-namespace drivers/scsi/libiscsi_tcp.c
--- a/drivers/scsi/libiscsi_tcp.c~kfifo-cleanup-namespace
+++ a/drivers/scsi/libiscsi_tcp.c
@@ -445,15 +445,15 @@ void iscsi_tcp_cleanup_task(struct iscsi
 		return;
 
 	/* flush task's r2t queues */
-	while (__kfifo_get(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
-		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+	while (kfifo_get(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
+		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		ISCSI_DBG_TCP(task->conn, "pending r2t dropped\n");
 	}
 
 	r2t = tcp_task->r2t;
 	if (r2t != NULL) {
-		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		tcp_task->r2t = NULL;
 	}
@@ -541,7 +541,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 		return 0;
 	}
 
-	rc = __kfifo_get(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
+	rc = kfifo_get(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
 	if (!rc) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
 				  "Target has sent more R2Ts than it "
@@ -554,7 +554,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 	if (r2t->data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -570,7 +570,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", r2t->data_length,
 				  r2t->data_offset, scsi_out(task->sc)->length);
-		__kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_put(&tcp_task->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -580,7 +580,7 @@ static int iscsi_tcp_r2t_rsp(struct iscs
 	r2t->sent = 0;
 
 	tcp_task->exp_datasn = r2tsn + 1;
-	__kfifo_put(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
+	kfifo_put(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
 	conn->r2t_pdus_cnt++;
 
 	iscsi_requeue_task(task);
@@ -951,7 +951,7 @@ int iscsi_tcp_task_init(struct iscsi_tas
 		return conn->session->tt->init_pdu(task, 0, task->data_count);
 	}
 
-	BUG_ON(__kfifo_len(&tcp_task->r2tqueue));
+	BUG_ON(kfifo_len(&tcp_task->r2tqueue));
 	tcp_task->exp_datasn = 0;
 
 	/* Prepare PDU, optionally w/ immediate data */
@@ -982,7 +982,7 @@ static struct iscsi_r2t_info *iscsi_tcp_
 			if (r2t->data_length <= r2t->sent) {
 				ISCSI_DBG_TCP(task->conn,
 					      "  done with r2t %p\n", r2t);
-				__kfifo_put(&tcp_task->r2tpool.queue,
+				kfifo_put(&tcp_task->r2tpool.queue,
 					    (void *)&tcp_task->r2t,
 					    sizeof(void *));
 				tcp_task->r2t = r2t = NULL;
@@ -990,7 +990,7 @@ static struct iscsi_r2t_info *iscsi_tcp_
 		}
 
 		if (r2t == NULL) {
-			__kfifo_get(&tcp_task->r2tqueue,
+			kfifo_get(&tcp_task->r2tqueue,
 				    (void *)&tcp_task->r2t, sizeof(void *));
 			r2t = tcp_task->r2t;
 		}
diff -puN drivers/scsi/libsrp.c~kfifo-cleanup-namespace drivers/scsi/libsrp.c
--- a/drivers/scsi/libsrp.c~kfifo-cleanup-namespace
+++ a/drivers/scsi/libsrp.c
@@ -61,7 +61,7 @@ static int srp_iu_pool_alloc(struct srp_
 	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
 	for (i = 0, iue = q->items; i < max; i++) {
-		__kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
+		kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
 		iue->sbuf = ring[i];
 		iue++;
 	}
diff -puN drivers/usb/host/fhci.h~kfifo-cleanup-namespace drivers/usb/host/fhci.h
--- a/drivers/usb/host/fhci.h~kfifo-cleanup-namespace
+++ a/drivers/usb/host/fhci.h
@@ -505,19 +505,19 @@ static inline void cq_delete(struct kfif
 
 static inline unsigned int cq_howmany(struct kfifo *kfifo)
 {
-	return __kfifo_len(kfifo) / sizeof(void *);
+	return kfifo_len(kfifo) / sizeof(void *);
 }
 
 static inline int cq_put(struct kfifo *kfifo, void *p)
 {
-	return __kfifo_put(kfifo, (void *)&p, sizeof(p));
+	return kfifo_put(kfifo, (void *)&p, sizeof(p));
 }
 
 static inline void *cq_get(struct kfifo *kfifo)
 {
 	void *p = NULL;
 
-	__kfifo_get(kfifo, (void *)&p, sizeof(p));
+	kfifo_get(kfifo, (void *)&p, sizeof(p));
 	return p;
 }
 
diff -puN drivers/usb/serial/generic.c~kfifo-cleanup-namespace drivers/usb/serial/generic.c
--- a/drivers/usb/serial/generic.c~kfifo-cleanup-namespace
+++ a/drivers/usb/serial/generic.c
@@ -276,7 +276,7 @@ static int usb_serial_generic_write_star
 	if (port->write_urb_busy)
 		start_io = false;
 	else {
-		start_io = (__kfifo_len(port->write_fifo) != 0);
+		start_io = (kfifo_len(port->write_fifo) != 0);
 		port->write_urb_busy = start_io;
 	}
 	spin_unlock_irqrestore(&port->lock, flags);
@@ -370,7 +370,7 @@ int usb_serial_generic_write_room(struct
 				(serial->type->max_in_flight_urbs -
 				 port->urbs_in_flight);
 	} else if (serial->num_bulk_out)
-		room = port->write_fifo->size - __kfifo_len(port->write_fifo);
+		room = port->write_fifo->size - kfifo_len(port->write_fifo);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	dbg("%s - returns %d", __func__, room);
diff -puN include/linux/kfifo.h~kfifo-cleanup-namespace include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-cleanup-namespace
+++ a/include/linux/kfifo.h
@@ -37,34 +37,25 @@ extern void kfifo_init(struct kfifo *fif
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
 			gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
-extern unsigned int __kfifo_put(struct kfifo *fifo,
+extern unsigned int kfifo_put(struct kfifo *fifo,
 				const unsigned char *buffer, unsigned int len);
-extern unsigned int __kfifo_get(struct kfifo *fifo,
+extern unsigned int kfifo_get(struct kfifo *fifo,
 				unsigned char *buffer, unsigned int len);
 
 /**
- * __kfifo_reset - removes the entire FIFO contents, no locking version
- * @fifo: the fifo to be emptied.
- */
-static inline void __kfifo_reset(struct kfifo *fifo)
-{
-	fifo->in = fifo->out = 0;
-}
-
-/**
  * kfifo_reset - removes the entire FIFO contents
  * @fifo: the fifo to be emptied.
  */
 static inline void kfifo_reset(struct kfifo *fifo)
 {
-	__kfifo_reset(fifo);
+	fifo->in = fifo->out = 0;
 }
 
 /**
- * __kfifo_len - returns the number of bytes available in the FIFO
+ * kfifo_len - returns the number of used bytes in the FIFO
  * @fifo: the fifo to be used.
  */
-static inline unsigned int __kfifo_len(struct kfifo *fifo)
+static inline unsigned int kfifo_len(struct kfifo *fifo)
 {
 	register unsigned int	out;
 
@@ -92,7 +83,7 @@ static inline __must_check unsigned int 
 
 	spin_lock_irqsave(lock, flags);
 
-	ret = __kfifo_put(fifo, from, n);
+	ret = kfifo_put(fifo, from, n);
 
 	spin_unlock_irqrestore(lock, flags);
 
@@ -117,7 +108,7 @@ static inline __must_check unsigned int 
 
 	spin_lock_irqsave(lock, flags);
 
-	ret = __kfifo_get(fifo, to, n);
+	ret = kfifo_get(fifo, to, n);
 
 	/*
 	 * optimization: if the FIFO is empty, set the indices to 0
@@ -131,13 +122,4 @@ static inline __must_check unsigned int 
 	return ret;
 }
 
-/**
- * kfifo_len - returns the number of bytes available in the FIFO
- * @fifo: the fifo to be used.
- */
-static inline unsigned int kfifo_len(struct kfifo *fifo)
-{
-	return __kfifo_len(fifo);
-}
-
 #endif
diff -puN kernel/kfifo.c~kfifo-cleanup-namespace kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-cleanup-namespace
+++ a/kernel/kfifo.c
@@ -100,7 +100,7 @@ void kfifo_free(struct kfifo *fifo)
 EXPORT_SYMBOL(kfifo_free);
 
 /**
- * __kfifo_put - puts some data into the FIFO, no locking version
+ * kfifo_put - puts some data into the FIFO, no locking version
  * @fifo: the fifo to be used.
  * @buffer: the data to be added.
  * @len: the length of the data to be added.
@@ -112,7 +112,7 @@ EXPORT_SYMBOL(kfifo_free);
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int __kfifo_put(struct kfifo *fifo,
+unsigned int kfifo_put(struct kfifo *fifo,
 			const unsigned char *buffer, unsigned int len)
 {
 	unsigned int l;
@@ -144,10 +144,10 @@ unsigned int __kfifo_put(struct kfifo *f
 
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_put);
+EXPORT_SYMBOL(kfifo_put);
 
 /**
- * __kfifo_get - gets some data from the FIFO, no locking version
+ * kfifo_get - gets some data from the FIFO, no locking version
  * @fifo: the fifo to be used.
  * @buffer: where the data must be copied.
  * @len: the size of the destination buffer.
@@ -158,7 +158,7 @@ EXPORT_SYMBOL(__kfifo_put);
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int __kfifo_get(struct kfifo *fifo,
+unsigned int kfifo_get(struct kfifo *fifo,
 			 unsigned char *buffer, unsigned int len)
 {
 	unsigned int l;
@@ -190,4 +190,4 @@ unsigned int __kfifo_get(struct kfifo *f
 
 	return len;
 }
-EXPORT_SYMBOL(__kfifo_get);
+EXPORT_SYMBOL(kfifo_get);
diff -puN net/dccp/probe.c~kfifo-cleanup-namespace net/dccp/probe.c
--- a/net/dccp/probe.c~kfifo-cleanup-namespace
+++ a/net/dccp/probe.c
@@ -131,7 +131,7 @@ static ssize_t dccpprobe_read(struct fil
 		return -ENOMEM;
 
 	error = wait_event_interruptible(dccpw.wait,
-					 __kfifo_len(&dccpw.fifo) != 0);
+					 kfifo_len(&dccpw.fifo) != 0);
 	if (error)
 		goto out_free;
 
_

Patches currently in -mm which might be from stefani@seibold.net are

kfifo-move-struct-kfifo-in-place.patch
kfifo-move-out-spinlock.patch
kfifo-cleanup-namespace.patch
kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch
kfifo-add-kfifo_skip-kfifo_from_user-and-kfifo_to_user.patch
kfifo-add-record-handling-functions.patch

