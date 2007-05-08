From: akpm@linux-foundation.org
Subject: - uml-send-pointers-instead-of-structures-to-i-o-thread.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:15 -0700
Message-ID: <200705080007.l4807FRo009264@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967410AbXEHAHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: send pointers instead of structures to I/O thread
has been removed from the -mm tree.  Its filename was
     uml-send-pointers-instead-of-structures-to-i-o-thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: send pointers instead of structures to I/O thread
From: Jeff Dike <jdike@addtoit.com>

Instead of writing entire structures between UML and the I/O thread, we send
pointers.  This cuts down on the amount of data being copied and possibly
allows more requests to be pending between the two.

This requires that the requests be kmalloced and freed instead of living on
the stack.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |   41 ++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-send-pointers-instead-of-structures-to-i-o-thread arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-send-pointers-instead-of-structures-to-i-o-thread
+++ a/arch/um/drivers/ubd_kern.c
@@ -503,7 +503,7 @@ static LIST_HEAD(restart);
 /* Called without dev->lock held, and only in interrupt context. */
 static void ubd_handler(void)
 {
-	struct io_thread_req req;
+	struct io_thread_req *req;
 	struct request *rq;
 	struct ubd *ubd;
 	struct list_head *list, *next_ele;
@@ -511,7 +511,8 @@ static void ubd_handler(void)
 	int n;
 
 	while(1){
-		n = os_read_file_k(thread_fd, &req, sizeof(req));
+		n = os_read_file_k(thread_fd, &req,
+				   sizeof(struct io_thread_req *));
 		if(n != sizeof(req)){
 			if(n == -EAGAIN)
 				break;
@@ -520,10 +521,11 @@ static void ubd_handler(void)
 			return;
 		}
 
-		rq = req.req;
-		rq->nr_sectors -= req.length >> 9;
+		rq = req->req;
+		rq->nr_sectors -= req->length >> 9;
 		if(rq->nr_sectors == 0)
 			ubd_finish(rq, rq->hard_nr_sectors << 9);
+		kfree(req);
 	}
 	reactivate_fd(thread_fd, UBD_IRQ);
 
@@ -1078,7 +1080,7 @@ static void prepare_request(struct reque
 /* Called with dev->lock held */
 static void do_ubd_request(request_queue_t *q)
 {
-	struct io_thread_req io_req;
+	struct io_thread_req *io_req;
 	struct request *req;
 	int n;
 
@@ -1099,13 +1101,20 @@ static void do_ubd_request(request_queue
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
-			prepare_request(req, &io_req,
+			io_req = kmalloc(sizeof(struct io_thread_req),
+					 GFP_KERNEL | GFP_ATOMIC);
+			if(io_req == NULL){
+				if(list_empty(&dev->restart))
+					list_add(&dev->restart, &restart);
+				return;
+			}
+			prepare_request(req, io_req,
 					(unsigned long long) req->sector << 9,
 					sg->offset, sg->length, sg->page);
 
-			n = os_write_file_k(thread_fd, (char *) &io_req,
-					    sizeof(io_req));
-			if(n != sizeof(io_req)){
+			n = os_write_file_k(thread_fd, &io_req,
+					    sizeof(struct io_thread_req *));
+			if(n != sizeof(struct io_thread_req *)){
 				if(n != -EAGAIN)
 					printk("write to io thread failed, "
 					       "errno = %d\n", -n);
@@ -1437,13 +1446,14 @@ static int io_count = 0;
 
 int io_thread(void *arg)
 {
-	struct io_thread_req req;
+	struct io_thread_req *req;
 	int n;
 
 	ignore_sigwinch_sig();
 	while(1){
-		n = os_read_file_k(kernel_fd, &req, sizeof(req));
-		if(n != sizeof(req)){
+		n = os_read_file_k(kernel_fd, &req,
+				 sizeof(struct io_thread_req *));
+		if(n != sizeof(struct io_thread_req *)){
 			if(n < 0)
 				printk("io_thread - read failed, fd = %d, "
 				       "err = %d\n", kernel_fd, -n);
@@ -1454,9 +1464,10 @@ int io_thread(void *arg)
 			continue;
 		}
 		io_count++;
-		do_io(&req);
-		n = os_write_file_k(kernel_fd, &req, sizeof(req));
-		if(n != sizeof(req))
+		do_io(req);
+		n = os_write_file_k(kernel_fd, &req,
+				  sizeof(struct io_thread_req *));
+		if(n != sizeof(struct io_thread_req *))
 			printk("io_thread - write failed, fd = %d, err = %d\n",
 			       kernel_fd, -n);
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
