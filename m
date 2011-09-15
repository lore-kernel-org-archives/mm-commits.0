From: akpm@linux-foundation.org
Subject: [merged] um-fix-free_winch-mess.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:35:52 -0700
Message-ID: <201109151935.p8FJZqh5009638@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934604Ab1IOTgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, richard@nod.at, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     um: fix free_winch() mess
has been removed from the -mm tree.  Its filename was
     um-fix-free_winch-mess.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: fix free_winch() mess
From: Al Viro <viro@ftp.linux.org.uk>

while not doing free_irq() from irq handler is commendable, kfree() on the
data passed to said handler before free_irq() is Not Good(tm).  Freeing
the stack it's being run on is also not nice...  Solution: delay actually
freeing stuff.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff -puN arch/um/drivers/line.c~um-fix-free_winch-mess arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~um-fix-free_winch-mess
+++ a/arch/um/drivers/line.c
@@ -721,43 +721,53 @@ struct winch {
 	int pid;
 	struct tty_struct *tty;
 	unsigned long stack;
+	struct work_struct work;
 };
 
-static void free_winch(struct winch *winch, int free_irq_ok)
+static void __free_winch(struct work_struct *work)
 {
-	int fd = winch->fd;
-	winch->fd = -1;
-	if (free_irq_ok)
-		free_irq(WINCH_IRQ, winch);
-
-	list_del(&winch->list);
+	struct winch *winch = container_of(work, struct winch, work);
+	free_irq(WINCH_IRQ, winch);
 
 	if (winch->pid != -1)
 		os_kill_process(winch->pid, 1);
-	if (fd != -1)
-		os_close_file(fd);
 	if (winch->stack != 0)
 		free_stack(winch->stack, 0);
 	kfree(winch);
 }
 
+static void free_winch(struct winch *winch)
+{
+	int fd = winch->fd;
+	winch->fd = -1;
+	if (fd != -1)
+		os_close_file(fd);
+	list_del(&winch->list);
+	__free_winch(&winch->work);
+}
+
 static irqreturn_t winch_interrupt(int irq, void *data)
 {
 	struct winch *winch = data;
 	struct tty_struct *tty;
 	struct line *line;
+	int fd = winch->fd;
 	int err;
 	char c;
 
-	if (winch->fd != -1) {
-		err = generic_read(winch->fd, &c, NULL);
+	if (fd != -1) {
+		err = generic_read(fd, &c, NULL);
 		if (err < 0) {
 			if (err != -EAGAIN) {
+				winch->fd = -1;
+				list_del(&winch->list);
+				os_close_file(fd);
 				printk(KERN_ERR "winch_interrupt : "
 				       "read failed, errno = %d\n", -err);
 				printk(KERN_ERR "fd %d is losing SIGWINCH "
 				       "support\n", winch->tty_fd);
-				free_winch(winch, 0);
+				INIT_WORK(&winch->work, __free_winch);
+				schedule_work(&winch->work);
 				return IRQ_HANDLED;
 			}
 			goto out;
@@ -829,7 +839,7 @@ static void unregister_winch(struct tty_
 	list_for_each_safe(ele, next, &winch_handlers) {
 		winch = list_entry(ele, struct winch, list);
 		if (winch->tty == tty) {
-			free_winch(winch, 1);
+			free_winch(winch);
 			break;
 		}
 	}
@@ -845,7 +855,7 @@ static void winch_cleanup(void)
 
 	list_for_each_safe(ele, next, &winch_handlers) {
 		winch = list_entry(ele, struct winch, list);
-		free_winch(winch, 1);
+		free_winch(winch);
 	}
 
 	spin_unlock(&winch_handler_lock);
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
slab-leaks3-default-y.patch

