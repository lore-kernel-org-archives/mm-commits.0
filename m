From: akpm@linux-foundation.org
Subject: + uml-send-pointers-instead-of-structures-to-i-o-thread.patch added to -mm tree
Date: Wed, 11 Apr 2007 13:25:39 -0700
Message-ID: <200704112025.l3BKPdtv013564@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59344 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965291AbXDKUZo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 16:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: send pointers instead of structures to I/O thread
has been added to the -mm tree.  Its filename is
     uml-send-pointers-instead-of-structures-to-i-o-thread.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 26 insertions(+), 15 deletions(-)

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

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-tidy-processc-fix.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
uml-batch-i-o-requests.patch
uml-send-pointers-instead-of-structures-to-i-o-thread.patch
uml-dump-core-on-panic.patch
uml-dont-try-to-handle-signals-on-initial-process-stack.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
