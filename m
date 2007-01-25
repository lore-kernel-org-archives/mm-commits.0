From: akpm@osdl.org
Subject: + uml-add-per-device-queues-and-locks-to-ubd-driver.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:03:37 -0800
Message-ID: <200701250603.l0P63bUR007566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48780 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965373AbXAYGDq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:03:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, axboe@kernel.dk, blaisorblade@yahoo.it


The patch titled
     uml: add per-device queues and locks to ubd driver
has been added to the -mm tree.  Its filename is
     uml-add-per-device-queues-and-locks-to-ubd-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: add per-device queues and locks to ubd driver
From: Jeff Dike <jdike@addtoit.com>

Replace global queue and lock with per-device queues and locks.  Mostly a
straightforward replacement of ubd_io_lock with dev->lock and ubd_queue with
dev->queue.

Complications -
	There was no way to get a request struct (and queue) from the
structure sent to the io_thread, so a pointer to the request was
added.  This is needed in ubd_handler in order to kick do_ubd_request
to process another request.
	Queue initialization is moved from ubd_init to ubd_add.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/ubd_kern.c |   70 ++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-add-per-device-queues-and-locks-to-ubd-driver arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-add-per-device-queues-and-locks-to-ubd-driver
+++ a/arch/um/drivers/ubd_kern.c
@@ -56,6 +56,7 @@
 enum ubd_req { UBD_READ, UBD_WRITE };
 
 struct io_thread_req {
+	struct request *req;
 	enum ubd_req op;
 	int fds[2];
 	unsigned long offsets[2];
@@ -106,10 +107,6 @@ static inline void ubd_set_bit(__u64 bit
 
 #define DRIVER_NAME "uml-blkdev"
 
-/* Can be taken in interrupt context, and is passed to the block layer to lock
- * the request queue. Kernel side code knows that. */
-static DEFINE_SPINLOCK(ubd_io_lock);
-
 static DEFINE_MUTEX(ubd_lock);
 
 /* XXX - this made sense in 2.4 days, now it's only used as a boolean, and
@@ -132,9 +129,6 @@ static struct block_device_operations ub
 	.getgeo		= ubd_getgeo,
 };
 
-/* Protected by the queue_lock */
-static request_queue_t *ubd_queue;
-
 /* Protected by ubd_lock */
 static int fake_major = MAJOR_NR;
 
@@ -178,6 +172,8 @@ struct ubd {
 	unsigned no_cow:1;
 	struct cow cow;
 	struct platform_device pdev;
+	struct request_queue *queue;
+	spinlock_t lock;
 };
 
 #define DEFAULT_COW { \
@@ -198,6 +194,7 @@ struct ubd {
         .no_cow =               0, \
 	.shared =		0, \
         .cow =			DEFAULT_COW, \
+	.lock =			SPIN_LOCK_UNLOCKED,	\
 }
 
 struct ubd ubd_devs[MAX_DEV] = { [ 0 ... MAX_DEV - 1 ] = DEFAULT_UBD };
@@ -504,17 +501,20 @@ static void __ubd_finish(struct request 
  * spin_lock_irq()/spin_lock_irqsave() */
 static inline void ubd_finish(struct request *req, int error)
 {
- 	spin_lock(&ubd_io_lock);
+	struct ubd *dev = req->rq_disk->private_data;
+
+	spin_lock(&dev->lock);
 	__ubd_finish(req, error);
-	spin_unlock(&ubd_io_lock);
+	spin_unlock(&dev->lock);
 }
 
 /* XXX - move this inside ubd_intr. */
-/* Called without ubd_io_lock held, and only in interrupt context. */
+/* Called without dev->lock held, and only in interrupt context. */
 static void ubd_handler(void)
 {
 	struct io_thread_req req;
-	struct request *rq = elv_next_request(ubd_queue);
+	struct request *rq;
+	struct ubd *dev;
 	int n;
 
 	do_ubd = 0;
@@ -523,17 +523,17 @@ static void ubd_handler(void)
 	if(n != sizeof(req)){
 		printk(KERN_ERR "Pid %d - spurious interrupt in ubd_handler, "
 		       "err = %d\n", os_getpid(), -n);
-		spin_lock(&ubd_io_lock);
-		end_request(rq, 0);
-		spin_unlock(&ubd_io_lock);
 		return;
 	}
 
+	rq = req.req;
+	dev = rq->rq_disk->private_data;
+
 	ubd_finish(rq, req.error);
-	reactivate_fd(thread_fd, UBD_IRQ);	
-	spin_lock(&ubd_io_lock);
-	do_ubd_request(ubd_queue);
-	spin_unlock(&ubd_io_lock);
+	reactivate_fd(thread_fd, UBD_IRQ);
+	spin_lock(&dev->lock);
+	do_ubd_request(dev->queue);
+	spin_unlock(&dev->lock);
 }
 
 static irqreturn_t ubd_intr(int irq, void *dev)
@@ -664,7 +664,7 @@ static int ubd_disk_register(int major, 
 	}
 
 	disk->private_data = &ubd_devs[unit];
-	disk->queue = ubd_queue;
+	disk->queue = ubd_devs[unit].queue;
 	add_disk(disk);
 
 	*disk_out = disk;
@@ -689,13 +689,23 @@ static int ubd_add(int n, char **error_o
 
 	ubd_dev->size = ROUND_BLOCK(ubd_dev->size);
 
-	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
-	if(err)
+	err = -ENOMEM;
+	ubd_dev->queue = blk_init_queue(do_ubd_request, &ubd_dev->lock);
+	if (ubd_dev->queue == NULL) {
+		*error_out = "Failed to initialize device queue";
 		goto out;
+	}
+	ubd_dev->queue->queuedata = ubd_dev;
+
+	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
+	if(err){
+		*error_out = "Failed to register device";
+		goto out_cleanup;
+	}
 
 	if(fake_major != MAJOR_NR)
 		ubd_disk_register(fake_major, ubd_dev->size, n,
-			     &fake_gendisk[n]);
+				  &fake_gendisk[n]);
 
 	/* perhaps this should also be under the "if (fake_major)" above */
 	/* using the fake_disk->disk_name and also the fakehd_set name */
@@ -705,6 +715,10 @@ static int ubd_add(int n, char **error_o
 	err = 0;
 out:
 	return err;
+
+out_cleanup:
+	blk_cleanup_queue(ubd_dev->queue);
+	goto out;
 }
 
 static int ubd_config(char *str, char **error_out)
@@ -816,6 +830,7 @@ static int ubd_remove(int n, char **erro
 		fake_gendisk[n] = NULL;
 	}
 
+	blk_cleanup_queue(ubd_dev->queue);
 	platform_device_unregister(&ubd_dev->pdev);
 	*ubd_dev = ((struct ubd) DEFAULT_UBD);
 	err = 0;
@@ -869,12 +884,6 @@ static int __init ubd_init(void)
 	if (register_blkdev(MAJOR_NR, "ubd"))
 		return -1;
 
-	ubd_queue = blk_init_queue(do_ubd_request, &ubd_io_lock);
-	if (!ubd_queue) {
-		unregister_blkdev(MAJOR_NR, "ubd");
-		return -1;
-	}
-		
 	if (fake_major != MAJOR_NR) {
 		char name[sizeof("ubd_nnn\0")];
 
@@ -1020,7 +1029,7 @@ static void cowify_req(struct io_thread_
 			   req->bitmap_words, bitmap_len);
 }
 
-/* Called with ubd_io_lock held */
+/* Called with dev->lock held */
 static int prepare_request(struct request *req, struct io_thread_req *io_req)
 {
 	struct gendisk *disk = req->rq_disk;
@@ -1039,6 +1048,7 @@ static int prepare_request(struct reques
 	offset = ((__u64) req->sector) << 9;
 	len = req->current_nr_sectors << 9;
 
+	io_req->req = req;
 	io_req->fds[0] = (ubd_dev->cow.file != NULL) ? ubd_dev->cow.fd : ubd_dev->fd;
 	io_req->fds[1] = ubd_dev->fd;
 	io_req->cow_offset = -1;
@@ -1060,7 +1070,7 @@ static int prepare_request(struct reques
 	return(0);
 }
 
-/* Called with ubd_io_lock held */
+/* Called with dev->lock held */
 static void do_ubd_request(request_queue_t *q)
 {
 	struct io_thread_req io_req;
_

Patches currently in -mm which might be from jdike@addtoit.com are

fix-uml-on-non-standard-vm-split-hosts.patch
uml-fix-mknod.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
