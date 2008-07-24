From: akpm@linux-foundation.org
Subject: - arch-um-kernel-irqc-clean-up-some-functions.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:50 -0700
Message-ID: <200807242325.m6ONPo35010922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755751AbYGXX0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     arch/um/kernel/irq.c: clean up some functions
has been removed from the -mm tree.  Its filename was
     arch-um-kernel-irqc-clean-up-some-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/um/kernel/irq.c: clean up some functions
From: WANG Cong <xiyou.wangcong@gmail.com>

Make activate_fd() and free_irq_by_irq_and_dev() static.  Remove
init_aio_irq() since it has no users.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/irq_kern.h |    2 --
 arch/um/include/irq_user.h |    2 --
 arch/um/kernel/irq.c       |   35 ++---------------------------------
 3 files changed, 2 insertions(+), 37 deletions(-)

diff -puN arch/um/include/irq_kern.h~arch-um-kernel-irqc-clean-up-some-functions arch/um/include/irq_kern.h
--- a/arch/um/include/irq_kern.h~arch-um-kernel-irqc-clean-up-some-functions
+++ a/arch/um/include/irq_kern.h
@@ -13,8 +13,6 @@ extern int um_request_irq(unsigned int i
 			  irq_handler_t handler,
 			  unsigned long irqflags,  const char * devname,
 			  void *dev_id);
-extern int init_aio_irq(int irq, char *name,
-			irq_handler_t handler);
 
 #endif
 
diff -puN arch/um/include/irq_user.h~arch-um-kernel-irqc-clean-up-some-functions arch/um/include/irq_user.h
--- a/arch/um/include/irq_user.h~arch-um-kernel-irqc-clean-up-some-functions
+++ a/arch/um/include/irq_user.h
@@ -21,8 +21,6 @@ struct irq_fd {
 enum { IRQ_READ, IRQ_WRITE };
 
 extern void sigio_handler(int sig, struct uml_pt_regs *regs);
-extern int activate_fd(int irq, int fd, int type, void *dev_id);
-extern void free_irq_by_irq_and_dev(unsigned int irq, void *dev_id);
 extern void free_irq_by_fd(int fd);
 extern void reactivate_fd(int fd, int irqnum);
 extern void deactivate_fd(int fd, int irqnum);
diff -puN arch/um/kernel/irq.c~arch-um-kernel-irqc-clean-up-some-functions arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~arch-um-kernel-irqc-clean-up-some-functions
+++ a/arch/um/kernel/irq.c
@@ -102,7 +102,7 @@ void sigio_handler(int sig, struct uml_p
 
 static DEFINE_SPINLOCK(irq_lock);
 
-int activate_fd(int irq, int fd, int type, void *dev_id)
+static int activate_fd(int irq, int fd, int type, void *dev_id)
 {
 	struct pollfd *tmp_pfd;
 	struct irq_fd *new_fd, *irq_fd;
@@ -216,7 +216,7 @@ static int same_irq_and_dev(struct irq_f
 	return ((irq->irq == data->irq) && (irq->id == data->dev));
 }
 
-void free_irq_by_irq_and_dev(unsigned int irq, void *dev)
+static void free_irq_by_irq_and_dev(unsigned int irq, void *dev)
 {
 	struct irq_and_dev data = ((struct irq_and_dev) { .irq  = irq,
 							  .dev  = dev });
@@ -403,37 +403,6 @@ void __init init_IRQ(void)
 	}
 }
 
-int init_aio_irq(int irq, char *name, irq_handler_t handler)
-{
-	int fds[2], err;
-
-	err = os_pipe(fds, 1, 1);
-	if (err) {
-		printk(KERN_ERR "init_aio_irq - os_pipe failed, err = %d\n",
-		       -err);
-		goto out;
-	}
-
-	err = um_request_irq(irq, fds[0], IRQ_READ, handler,
-			     IRQF_DISABLED | IRQF_SAMPLE_RANDOM, name,
-			     (void *) (long) fds[0]);
-	if (err) {
-		printk(KERN_ERR "init_aio_irq - : um_request_irq failed, "
-		       "err = %d\n",
-		       err);
-		goto out_close;
-	}
-
-	err = fds[1];
-	goto out;
-
- out_close:
-	os_close_file(fds[0]);
-	os_close_file(fds[1]);
- out:
-	return err;
-}
