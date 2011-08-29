From: akpm@linux-foundation.org
Subject: + um-fix-free_winch-mess.patch added to -mm tree
Date: Mon, 29 Aug 2011 14:35:43 -0700
Message-ID: <201108292135.p7TLZhkP030274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755193Ab1H2Vg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 17:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, richard@nod.at, viro@zeniv.linux.org.uk


The patch titled
     um: fix free_winch() mess
has been added to the -mm tree.  Its filename is
     um-fix-free_winch-mess.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

um-fix-oopsable-race-in-line_close.patch
um-winch_interrupt-can-happen-inside-of-free_winch.patch
um-fix-free_winch-mess.patch
um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch.patch
um-fix-strrchr-problems.patch
um-clean-arch_ptrace-up-a-bit.patch
slab-leaks3-default-y.patch

