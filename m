From: akpm@linux-foundation.org
Subject: - uml-batch-i-o-requests.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:12 -0700
Message-ID: <200705080007.l4807CGA009260@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967415AbXEHAHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     uml: batch I/O requests
has been removed from the -mm tree.  Its filename was
     uml-batch-i-o-requests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: batch I/O requests
From: Jeff Dike <jdike@addtoit.com>

Send as many I/O requests to the I/O thread as possible, even though it will
still only handle one at a time.  This provides an opportunity to reduce
latency by starting one request before the previous one has been finished in
the driver.

Request handling is somewhat modernized by requesting sg pieces of a request
and handling them separately, finishing off the entire request after all the
pieces are done.

When a request queue stalls, normally because its pipe to the I/O thread is
full, it is put on the restart list.  This list is processed by starting up
the queues on it whenever there is some indication that progress might be
possible again.  Currently, this happens in the driver interrupt routine. 
Some requests have been finished, so there is likely to be room in the pipe
again.

This almost doubles throughput when copying data between devices, but made no
noticable difference on anything else I tried.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |  174 +++++++++++++++++++----------------
 1 file changed, 98 insertions(+), 76 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-batch-i-o-requests arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-batch-i-o-requests
+++ a/arch/um/drivers/ubd_kern.c
@@ -149,7 +149,10 @@ struct cow {
         int data_offset;
 };
 
+#define MAX_SG 64
+
 struct ubd {
+	struct list_head restart;
 	/* name (and fd, below) of the file opened for writing, either the
 	 * backing or the cow file. */
 	char *file;
@@ -164,7 +167,9 @@ struct ubd {
 	struct platform_device pdev;
 	struct request_queue *queue;
 	spinlock_t lock;
-	int active;
+	struct scatterlist sg[MAX_SG];
+	struct request *request;
+	int start_sg, end_sg;
 };
 
 #define DEFAULT_COW { \
@@ -186,7 +191,9 @@ struct ubd {
 	.shared =		0, \
         .cow =			DEFAULT_COW, \
 	.lock =			SPIN_LOCK_UNLOCKED,	\
-	.active =		0, \
+	.request =		NULL, \
+	.start_sg =		0, \
+	.end_sg =		0, \
 }
 
 /* Protected by ubd_lock */
@@ -466,60 +473,67 @@ static void do_ubd_request(request_queue
 /* Only changed by ubd_init, which is an initcall. */
 int thread_fd = -1;
 
-/* call ubd_finish if you need to serialize */
-static void __ubd_finish(struct request *req, int error)
+static void ubd_end_request(struct request *req, int bytes, int uptodate)
 {
-	int nsect;
-
-	if(error){
-		end_request(req, 0);
-		return;
+	if (!end_that_request_first(req, uptodate, bytes >> 9)) {
+		struct ubd *dev = req->rq_disk->private_data;
+		unsigned long flags;
+
+		add_disk_randomness(req->rq_disk);
+		spin_lock_irqsave(&dev->lock, flags);
+		end_that_request_last(req, uptodate);
+		spin_unlock_irqrestore(&dev->lock, flags);
 	}
-	nsect = req->current_nr_sectors;
-	req->sector += nsect;
-	req->buffer += nsect << 9;
-	req->errors = 0;
-	req->nr_sectors -= nsect;
-	req->current_nr_sectors = 0;
-	end_request(req, 1);
 }
 
 /* Callable only from interrupt context - otherwise you need to do
  * spin_lock_irq()/spin_lock_irqsave() */
-static inline void ubd_finish(struct request *req, int error)
+static inline void ubd_finish(struct request *req, int bytes)
 {
-	struct ubd *dev = req->rq_disk->private_data;
-
-	spin_lock(&dev->lock);
-	__ubd_finish(req, error);
-	spin_unlock(&dev->lock);
+	if(bytes < 0){
+		ubd_end_request(req, 0, 0);
+		return;
+	}
+	ubd_end_request(req, bytes, 1);
 }
 
+static LIST_HEAD(restart);
+
 /* XXX - move this inside ubd_intr. */
 /* Called without dev->lock held, and only in interrupt context. */
 static void ubd_handler(void)
 {
 	struct io_thread_req req;
 	struct request *rq;
-	struct ubd *dev;
+	struct ubd *ubd;
+	struct list_head *list, *next_ele;
+	unsigned long flags;
 	int n;
 
-	n = os_read_file_k(thread_fd, &req, sizeof(req));
-	if(n != sizeof(req)){
-		printk(KERN_ERR "Pid %d - spurious interrupt in ubd_handler, "
-		       "err = %d\n", os_getpid(), -n);
-		return;
-	}
-
-	rq = req.req;
-	dev = rq->rq_disk->private_data;
-	dev->active = 0;
+	while(1){
+		n = os_read_file_k(thread_fd, &req, sizeof(req));
+		if(n != sizeof(req)){
+			if(n == -EAGAIN)
+				break;
+			printk(KERN_ERR "spurious interrupt in ubd_handler, "
+			       "err = %d\n", -n);
+			return;
+		}
 
-	ubd_finish(rq, req.error);
+		rq = req.req;
+		rq->nr_sectors -= req.length >> 9;
+		if(rq->nr_sectors == 0)
+			ubd_finish(rq, rq->hard_nr_sectors << 9);
+	}
 	reactivate_fd(thread_fd, UBD_IRQ);
-	spin_lock(&dev->lock);
-	do_ubd_request(dev->queue);
-	spin_unlock(&dev->lock);
+
+	list_for_each_safe(list, next_ele, &restart){
+		ubd = container_of(list, struct ubd, restart);
+		list_del_init(&ubd->restart);
+		spin_lock_irqsave(&ubd->lock, flags);
+		do_ubd_request(ubd->queue);
+		spin_unlock_irqrestore(&ubd->lock, flags);
+	}
 }
 
 static irqreturn_t ubd_intr(int irq, void *dev)
@@ -684,6 +698,8 @@ static int ubd_add(int n, char **error_o
 
 	ubd_dev->size = ROUND_BLOCK(ubd_dev->size);
 
+	INIT_LIST_HEAD(&ubd_dev->restart);
+
 	err = -ENOMEM;
 	ubd_dev->queue = blk_init_queue(do_ubd_request, &ubd_dev->lock);
 	if (ubd_dev->queue == NULL) {
@@ -692,6 +708,7 @@ static int ubd_add(int n, char **error_o
 	}
 	ubd_dev->queue->queuedata = ubd_dev;
 
+	blk_queue_max_hw_segments(ubd_dev->queue, MAX_SG);
 	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";
@@ -1029,26 +1046,16 @@ static void cowify_req(struct io_thread_
 }
 
 /* Called with dev->lock held */
-static int prepare_request(struct request *req, struct io_thread_req *io_req)
+static void prepare_request(struct request *req, struct io_thread_req *io_req,
+			    unsigned long long offset, int page_offset,
+			    int len, struct page *page)
 {
 	struct gendisk *disk = req->rq_disk;
 	struct ubd *ubd_dev = disk->private_data;
-	__u64 offset;
-	int len;
-
-	/* This should be impossible now */
-	if((rq_data_dir(req) == WRITE) && !ubd_dev->openflags.w){
-		printk("Write attempted on readonly ubd device %s\n",
-		       disk->disk_name);
-		end_request(req, 0);
-		return(1);
-	}
-
-	offset = ((__u64) req->sector) << 9;
-	len = req->current_nr_sectors << 9;
 
 	io_req->req = req;
-	io_req->fds[0] = (ubd_dev->cow.file != NULL) ? ubd_dev->cow.fd : ubd_dev->fd;
+	io_req->fds[0] = (ubd_dev->cow.file != NULL) ? ubd_dev->cow.fd :
+		ubd_dev->fd;
 	io_req->fds[1] = ubd_dev->fd;
 	io_req->cow_offset = -1;
 	io_req->offset = offset;
@@ -1059,14 +1066,13 @@ static int prepare_request(struct reques
 	io_req->op = (rq_data_dir(req) == READ) ? UBD_READ : UBD_WRITE;
 	io_req->offsets[0] = 0;
 	io_req->offsets[1] = ubd_dev->cow.data_offset;
-	io_req->buffer = req->buffer;
+	io_req->buffer = page_address(page) + page_offset;
 	io_req->sectorsize = 1 << 9;
 
 	if(ubd_dev->cow.file != NULL)
-		cowify_req(io_req, ubd_dev->cow.bitmap, ubd_dev->cow.bitmap_offset,
-			   ubd_dev->cow.bitmap_len);
+		cowify_req(io_req, ubd_dev->cow.bitmap,
+			   ubd_dev->cow.bitmap_offset, ubd_dev->cow.bitmap_len);
 
-	return(0);
 }
 
 /* Called with dev->lock held */
@@ -1074,29 +1080,45 @@ static void do_ubd_request(request_queue
 {
 	struct io_thread_req io_req;
 	struct request *req;
-	int err, n;
+	int n;
 
-	if(thread_fd == -1){
-		while((req = elv_next_request(q)) != NULL){
-			err = prepare_request(req, &io_req);
-			if(!err){
-				do_io(&io_req);
-				__ubd_finish(req, io_req.error);
-			}
-		}
-	}
-	else {
+	while(1){
 		struct ubd *dev = q->queuedata;
-		if(dev->active || (req = elv_next_request(q)) == NULL)
-			return;
-		err = prepare_request(req, &io_req);
-		if(!err){
-			dev->active = 1;
-			n = os_write_file_k(thread_fd, &io_req, sizeof(io_req));
-			if(n != sizeof(io_req))
-				printk("write to io thread failed, "
-				       "errno = %d\n", -n);
+		if(dev->end_sg == 0){
+			struct request *req = elv_next_request(q);
+			if(req == NULL)
+				return;
+
+			dev->request = req;
+			blkdev_dequeue_request(req);
+			dev->start_sg = 0;
+			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
+		}
+
+		req = dev->request;
+		while(dev->start_sg < dev->end_sg){
+			struct scatterlist *sg = &dev->sg[dev->start_sg];
+
+			prepare_request(req, &io_req,
+					(unsigned long long) req->sector << 9,
+					sg->offset, sg->length, sg->page);
+
+			n = os_write_file_k(thread_fd, (char *) &io_req,
+					    sizeof(io_req));
+			if(n != sizeof(io_req)){
+				if(n != -EAGAIN)
+					printk("write to io thread failed, "
+					       "errno = %d\n", -n);
+				else if(list_empty(&dev->restart))
+					list_add(&dev->restart, &restart);
+				return;
+			}
+
+			req->sector += sg->length >> 9;
+			dev->start_sg++;
 		}
+		dev->end_sg = 0;
+		dev->request = NULL;
 	}
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
