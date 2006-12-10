From: akpm@osdl.org
Subject: + uml-fix-net_kern-workqueue-abuse.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:02:35 -0800
Message-ID: <200612102002.kBAK2ZqV001699@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56581 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762439AbWLJUCk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:02:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, jdike@addtoit.com


The patch titled
     uml: fix net_kern workqueue abuse
has been added to the -mm tree.  Its filename is
     uml-fix-net_kern-workqueue-abuse.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix net_kern workqueue abuse
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fix up the work on stack and exit scope trouble by placing the work_struct
in the uml_net_private data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/net_kern.c |   15 +++++++++------
 arch/um/include/net_kern.h |    2 ++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-fix-net_kern-workqueue-abuse arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-fix-net_kern-workqueue-abuse
+++ a/arch/um/drivers/net_kern.c
@@ -72,9 +72,11 @@ static int uml_net_rx(struct net_device 
 	return pkt_len;
 }
 
-static void uml_dev_close(void* dev)
+static void uml_dev_close(struct work_struct *work)
 {
-	dev_close( (struct net_device *) dev);
+	struct uml_net_private *lp =
+		container_of(work, struct uml_net_private, work);
+	dev_close(lp->dev);
 }
 
 irqreturn_t uml_net_interrupt(int irq, void *dev_id)
@@ -89,7 +91,6 @@ irqreturn_t uml_net_interrupt(int irq, v
 	spin_lock(&lp->lock);
 	while((err = uml_net_rx(dev)) > 0) ;
 	if(err < 0) {
-		DECLARE_WORK(close_work, uml_dev_close, dev);
 		printk(KERN_ERR 
 		       "Device '%s' read returned %d, shutting it down\n", 
 		       dev->name, err);
@@ -97,9 +98,10 @@ irqreturn_t uml_net_interrupt(int irq, v
 		 * again lp->lock.
 		 * And dev_close() can be safely called multiple times on the
 		 * same device, since it tests for (dev->flags & IFF_UP). So
-		 * there's no harm in delaying the device shutdown. */
-		schedule_work(&close_work);
-#error this is not permitted - close_work will go out of scope
+		 * there's no harm in delaying the device shutdown.
+		 * Furthermore, the workqueue will not re-enqueue an already
+		 * enqueued work item. */
+		schedule_work(&lp->work);
 		goto out;
 	}
 	reactivate_fd(lp->fd, UM_ETH_IRQ);
@@ -366,6 +368,7 @@ static int eth_configure(int n, void *in
 	/* This points to the transport private data. It's still clear, but we
 	 * must memset it to 0 *now*. Let's help the drivers. */
 	memset(lp, 0, size);
+	INIT_WORK(&lp->work, uml_dev_close);
 
 	/* sysfs register */
 	if (!driver_registered) {
diff -puN arch/um/include/net_kern.h~uml-fix-net_kern-workqueue-abuse arch/um/include/net_kern.h
--- a/arch/um/include/net_kern.h~uml-fix-net_kern-workqueue-abuse
+++ a/arch/um/include/net_kern.h
@@ -11,6 +11,7 @@
 #include <linux/skbuff.h>
 #include <linux/socket.h>
 #include <linux/list.h>
+#include <linux/workqueue.h>
 
 struct uml_net {
 	struct list_head list;
@@ -26,6 +27,7 @@ struct uml_net_private {
 	struct net_device *dev;
 	struct timer_list tl;
 	struct net_device_stats stats;
+	struct work_struct work;
 	int fd;
 	unsigned char mac[ETH_ALEN];
 	unsigned short (*protocol)(struct sk_buff *);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-export-get_current_tty.patch
uml-fix-net_kern-workqueue-abuse.patch

