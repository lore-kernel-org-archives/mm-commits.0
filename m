From: akpm@linux-foundation.org
Subject: - uml-fix-i-o-hang-when-multiple-devices-are-in-use.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:09 -0700
Message-ID: <200703292337.l2TNb90G015075@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42943 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945909AbXC2XhS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix I/O hang when multiple devices are in use
has been removed from the -mm tree.  Its filename was
     uml-fix-i-o-hang-when-multiple-devices-are-in-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix I/O hang when multiple devices are in use
From: Jeff Dike <jdike@addtoit.com>

Commit 62f96cb01e8de7a5daee472e540f726db2801499 introduced per-devices
queues and locks, which was fine as far as it went, but left in place a
global which controlled access to submitting requests to the host.  This
should have been made per-device as well, since it causes I/O hangs when
multiple block devices are in use.

This patch fixes that by replacing the global with an activity flag in the
device structure in order to tell whether the queue is currently being run.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-fix-i-o-hang-when-multiple-devices-are-in-use arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-fix-i-o-hang-when-multiple-devices-are-in-use
+++ a/arch/um/drivers/ubd_kern.c
@@ -109,10 +109,6 @@ static inline void ubd_set_bit(__u64 bit
 
 static DEFINE_MUTEX(ubd_lock);
 
-/* XXX - this made sense in 2.4 days, now it's only used as a boolean, and
- * probably it doesn't make sense even for that. */
-static int do_ubd;
-
 static int ubd_open(struct inode * inode, struct file * filp);
 static int ubd_release(struct inode * inode, struct file * file);
 static int ubd_ioctl(struct inode * inode, struct file * file,
@@ -169,6 +165,7 @@ struct ubd {
 	struct platform_device pdev;
 	struct request_queue *queue;
 	spinlock_t lock;
+	int active;
 };
 
 #define DEFAULT_COW { \
@@ -190,6 +187,7 @@ struct ubd {
 	.shared =		0, \
         .cow =			DEFAULT_COW, \
 	.lock =			SPIN_LOCK_UNLOCKED,	\
+	.active =		0, \
 }
 
 /* Protected by ubd_lock */
@@ -507,7 +505,6 @@ static void ubd_handler(void)
 	struct ubd *dev;
 	int n;
 
-	do_ubd = 0;
 	n = os_read_file(thread_fd, &req, sizeof(req));
 	if(n != sizeof(req)){
 		printk(KERN_ERR "Pid %d - spurious interrupt in ubd_handler, "
@@ -517,6 +514,7 @@ static void ubd_handler(void)
 
 	rq = req.req;
 	dev = rq->rq_disk->private_data;
+	dev->active = 0;
 
 	ubd_finish(rq, req.error);
 	reactivate_fd(thread_fd, UBD_IRQ);
@@ -1081,11 +1079,12 @@ static void do_ubd_request(request_queue
 		}
 	}
 	else {
-		if(do_ubd || (req = elv_next_request(q)) == NULL)
+		struct ubd *dev = q->queuedata;
+		if(dev->active || (req = elv_next_request(q)) == NULL)
 			return;
 		err = prepare_request(req, &io_req);
 		if(!err){
-			do_ubd = 1;
+			dev->active = 1;
 			n = os_write_file(thread_fd, (char *) &io_req,
 					 sizeof(io_req));
 			if(n != sizeof(io_req))
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-unreasonably-long-udelay.patch
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
