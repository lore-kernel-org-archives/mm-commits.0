From: akpm@linux-foundation.org
Subject: [merged] kfifo-fix-warn_unused_result.patch removed from -mm tree
Date: Wed, 23 Dec 2009 12:58:45 -0800
Message-ID: <200912232058.nBNKwjQq021191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbZLWU7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Dec 2009 15:59:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     kfifo: fix warn_unused_result
has been removed from the -mm tree.  Its filename was
     kfifo-fix-warn_unused_result.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: fix warn_unused_result
From: Stefani Seibold <stefani@seibold.net>

Fix the "ignoring return value of '...', declared with attribute
warn_unused_result" compiler warning in several users of the new kfifo
API.

It removes the __must_check attribute from kfifo_in() and
kfifo_in_locked() which must not necessary performed.

Fix the allocation bug in the nozomi driver file, by moving out the
kfifo_alloc from the interrupt handler into the probe function.

Fix the kfifo_out() and kfifo_out_locked() users to handle a unexpected
end of fifo. 

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c                       |   31 +++++++++++++++---
 drivers/infiniband/hw/cxgb3/cxio_resource.c |    5 +-
 drivers/media/video/meye.c                  |    5 +-
 drivers/net/wireless/libertas/main.c        |    6 ++-
 drivers/scsi/libiscsi_tcp.c                 |    9 ++++-
 drivers/scsi/libsrp.c                       |    7 ++--
 include/linux/kfifo.h                       |    4 +-
 7 files changed, 51 insertions(+), 16 deletions(-)

diff -puN drivers/char/nozomi.c~kfifo-fix-warn_unused_result drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~kfifo-fix-warn_unused_result
+++ a/drivers/char/nozomi.c
@@ -685,8 +685,6 @@ static int nozomi_read_config_table(stru
 		dump_table(dc);
 
 		for (i = PORT_MDM; i < MAX_PORT; i++) {
-			kfifo_alloc(&dc->port[i].fifo_ul,
-				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC);
 			memset(&dc->port[i].ctrl_dl, 0, sizeof(struct ctrl_dl));
 			memset(&dc->port[i].ctrl_ul, 0, sizeof(struct ctrl_ul));
 		}
@@ -1433,6 +1431,16 @@ static int __devinit nozomi_card_init(st
 		goto err_free_sbuf;
 	}
 
+	for (i = PORT_MDM; i < MAX_PORT; i++) {
+		if (kfifo_alloc(&dc->port[i].fifo_ul,
+		      FIFO_BUFFER_SIZE_UL, GFP_ATOMIC)) {
+			dev_err(&pdev->dev,
+					"Could not allocate kfifo buffer\n");
+			ret = -ENOMEM;
+			goto err_free_kfifo;
+		}
+	}
+
 	spin_lock_init(&dc->spin_mutex);
 
 	nozomi_setup_private_data(dc);
@@ -1445,7 +1453,7 @@ static int __devinit nozomi_card_init(st
 			NOZOMI_NAME, dc);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev, "can't request irq %d\n", pdev->irq);
-		goto err_free_sbuf;
+		goto err_free_kfifo;
 	}
 
 	DBG1("base_addr: %p", dc->base_addr);
@@ -1464,13 +1472,28 @@ static int __devinit nozomi_card_init(st
 	dc->state = NOZOMI_STATE_ENABLED;
 
 	for (i = 0; i < MAX_PORT; i++) {
+		struct device *tty_dev;
+
 		mutex_init(&dc->port[i].tty_sem);
 		tty_port_init(&dc->port[i].port);
-		tty_register_device(ntty_driver, dc->index_start + i,
+		tty_dev = tty_register_device(ntty_driver, dc->index_start + i,
 							&pdev->dev);
+
+		if (IS_ERR(tty_dev)) {
+			ret = PTR_ERR(tty_dev);
+			dev_err(&pdev->dev, "Could not allocate tty?\n");
+			goto err_free_tty;
+		}
 	}
+
 	return 0;
 
+err_free_tty:
+	for (i = dc->index_start; i < dc->index_start + MAX_PORT; ++i)
+		tty_unregister_device(ntty_driver, i);
+err_free_kfifo:
+	for (i = 0; i < MAX_PORT; i++)
+		kfifo_free(&dc->port[i].fifo_ul);
 err_free_sbuf:
 	kfree(dc->send_buf);
 	iounmap(dc->base_addr);
diff -puN drivers/infiniband/hw/cxgb3/cxio_resource.c~kfifo-fix-warn_unused_result drivers/infiniband/hw/cxgb3/cxio_resource.c
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c~kfifo-fix-warn_unused_result
+++ a/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -86,8 +86,9 @@ static int __cxio_init_resource_fifo(str
 			kfifo_in(fifo, (unsigned char *) &i, sizeof(u32));
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_out_locked(fifo, (unsigned char *) &entry,
-				sizeof(u32), fifo_lock);
+		if (kfifo_out_locked(fifo, (unsigned char *) &entry,
+				sizeof(u32), fifo_lock) != sizeof(u32))
+					break;
 	return 0;
 }
 
diff -puN drivers/media/video/meye.c~kfifo-fix-warn_unused_result drivers/media/video/meye.c
--- a/drivers/media/video/meye.c~kfifo-fix-warn_unused_result
+++ a/drivers/media/video/meye.c
@@ -968,8 +968,9 @@ static int meyeioc_sync(struct file *fil
 		/* fall through */
 	case MEYE_BUF_DONE:
 		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
-		kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
-				sizeof(int), &meye.doneq_lock);
+		if (kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
+				sizeof(int), &meye.doneq_lock) != sizeof(int))
+					break;
 	}
 	*i = meye.grab_buffer[*i].size;
 	mutex_unlock(&meye.lock);
diff -puN drivers/net/wireless/libertas/main.c~kfifo-fix-warn_unused_result drivers/net/wireless/libertas/main.c
--- a/drivers/net/wireless/libertas/main.c~kfifo-fix-warn_unused_result
+++ a/drivers/net/wireless/libertas/main.c
@@ -514,8 +514,10 @@ static int lbs_thread(void *data)
 		while (kfifo_len(&priv->event_fifo)) {
 			u32 event;
 
-			kfifo_out(&priv->event_fifo, (unsigned char *) &event,
-				sizeof(event));
+			if (kfifo_out(&priv->event_fifo,
+				(unsigned char *) &event, sizeof(event)) !=
+				sizeof(event))
+					break;
 			spin_unlock_irq(&priv->driver_lock);
 			lbs_process_event(priv, event);
 			spin_lock_irq(&priv->driver_lock);
diff -puN drivers/scsi/libiscsi_tcp.c~kfifo-fix-warn_unused_result drivers/scsi/libiscsi_tcp.c
--- a/drivers/scsi/libiscsi_tcp.c~kfifo-fix-warn_unused_result
+++ a/drivers/scsi/libiscsi_tcp.c
@@ -990,8 +990,13 @@ static struct iscsi_r2t_info *iscsi_tcp_
 		}
 
 		if (r2t == NULL) {
-			kfifo_out(&tcp_task->r2tqueue,
-				    (void *)&tcp_task->r2t, sizeof(void *));
+			if (kfifo_out(&tcp_task->r2tqueue,
+			    (void *)&tcp_task->r2t, sizeof(void *)) !=
+			    sizeof(void *)) {
+				WARN_ONCE(1, "unexpected fifo state");
+				r2t = NULL;
+			}
+
 			r2t = tcp_task->r2t;
 		}
 		spin_unlock_bh(&session->lock);
diff -puN drivers/scsi/libsrp.c~kfifo-fix-warn_unused_result drivers/scsi/libsrp.c
--- a/drivers/scsi/libsrp.c~kfifo-fix-warn_unused_result
+++ a/drivers/scsi/libsrp.c
@@ -163,8 +163,11 @@ struct iu_entry *srp_iu_get(struct srp_t
 {
 	struct iu_entry *iue = NULL;
 
-	kfifo_out_locked(&target->iu_queue.queue, (void *) &iue,
-			sizeof(void *), &target->iu_queue.lock);
+	if (kfifo_out_locked(&target->iu_queue.queue, (void *) &iue,
+		sizeof(void *), &target->iu_queue.lock) != sizeof(void *)) {
+			WARN_ONCE(1, "unexpected fifo state");
+			return NULL;
+	}
 	if (!iue)
 		return iue;
 	iue->target = target;
diff -puN include/linux/kfifo.h~kfifo-fix-warn_unused_result include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-fix-warn_unused_result
+++ a/include/linux/kfifo.h
@@ -56,7 +56,7 @@ extern void kfifo_init(struct kfifo *fif
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
 			gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
-extern __must_check unsigned int kfifo_in(struct kfifo *fifo,
+extern unsigned int kfifo_in(struct kfifo *fifo,
 				const unsigned char *from, unsigned int len);
 extern __must_check unsigned int kfifo_out(struct kfifo *fifo,
 				unsigned char *to, unsigned int len);
@@ -94,7 +94,7 @@ static inline unsigned int kfifo_len(str
  * the FIFO depending on the free space, and returns the number of
  * bytes copied.
  */
-static inline __must_check unsigned int kfifo_in_locked(struct kfifo *fifo,
+static inline unsigned int kfifo_in_locked(struct kfifo *fifo,
 		const unsigned char *from, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch

