From: akpm@linux-foundation.org
Subject: - uml-fix-request-sector-update.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:51:00 -0700
Message-ID: <200707162051.l6GKp0mv001357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759137AbXGPVYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix request->sector update
has been removed from the -mm tree.  Its filename was
     uml-fix-request-sector-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix request->sector update
From: Jeff Dike <jdike@addtoit.com>

It is theoretically possible for a request to finish and be freed between
writing it to the I/O thread and updating the sector count.  In this case, the
update will dereference a freed pointer.

To avoid this, I delay the update until processing the next sg segment, when
the request pointer is known to be good.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-fix-request-sector-update arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-fix-request-sector-update
+++ a/arch/um/drivers/ubd_kern.c
@@ -1083,7 +1083,7 @@ static void do_ubd_request(request_queue
 {
 	struct io_thread_req *io_req;
 	struct request *req;
-	int n;
+	int n, last_sectors;
 
 	while(1){
 		struct ubd *dev = q->queuedata;
@@ -1099,9 +1099,11 @@ static void do_ubd_request(request_queue
 		}
 
 		req = dev->request;
+		last_sectors = 0;
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
+			req->sector += last_sectors;
 			io_req = kmalloc(sizeof(struct io_thread_req),
 					 GFP_ATOMIC);
 			if(io_req == NULL){
@@ -1113,6 +1115,7 @@ static void do_ubd_request(request_queue
 					(unsigned long long) req->sector << 9,
 					sg->offset, sg->length, sg->page);
 
+			last_sectors = sg->length >> 9;
 			n = os_write_file(thread_fd, &io_req,
 					  sizeof(struct io_thread_req *));
 			if(n != sizeof(struct io_thread_req *)){
@@ -1124,7 +1127,6 @@ static void do_ubd_request(request_queue
 				return;
 			}
 
-			req->sector += sg->length >> 9;
 			dev->start_sg++;
 		}
 		dev->end_sg = 0;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
hostfs-convert-to-new-aops.patch
