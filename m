From: akpm@linux-foundation.org
Subject: + uml-sigio-support-cleanup.patch added to -mm tree
Date: Tue, 26 Jun 2007 13:37:21 -0700
Message-ID: <200706262037.l5QKbL84001631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758170AbXFZUiA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 16:38:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: SIGIO support cleanup
has been added to the -mm tree.  Its filename is
     uml-sigio-support-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: SIGIO support cleanup
From: Jeff Dike <jdike@addtoit.com>

Cleanup of the SIGWINCH support.

Some code and comment reformatting.

The stack used for SIGWINCH threads was leaked.  This is now fixed by storing
it with the pid and other information, and freeing it when the thread is
killed.

If something goes wrong with a WIGWINCH thread, and this is discovered in the
interrupt handler, the winch record would leak.  It is now freed, except that
the IRQ isn't freed.  This is hard to do from interrupt context.  This has the
side-effect that the IRQ system maintains a reference to the freed structure,
but that shouldn't cause a problem since the descriptor is disabled.

register_winch_irq is now much better about cleaning up after an
initialization failure.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c     |   70 ++++++++++++++++--------------
 arch/um/drivers/line.c          |   60 ++++++++++++++++---------
 arch/um/include/chan_user.h     |    3 -
 arch/um/os-Linux/skas/process.c |    2 
 4 files changed, 80 insertions(+), 55 deletions(-)

diff -puN arch/um/drivers/chan_user.c~uml-sigio-support-cleanup arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-sigio-support-cleanup
+++ a/arch/um/drivers/chan_user.c
@@ -51,19 +51,21 @@ error:
 /*
  * UML SIGWINCH handling
  *
- * The point of this is to handle SIGWINCH on consoles which have host ttys and
- * relay them inside UML to whatever might be running on the console and cares
- * about the window size (since SIGWINCH notifies about terminal size changes).
+ * The point of this is to handle SIGWINCH on consoles which have host
+ * ttys and relay them inside UML to whatever might be running on the
+ * console and cares about the window size (since SIGWINCH notifies
+ * about terminal size changes).
  *
- * So, we have a separate thread for each host tty attached to a UML device
- * (side-issue - I'm annoyed that one thread can't have multiple controlling
- * ttys for purposed of handling SIGWINCH, but I imagine there are other reasons
- * that doesn't make any sense).
+ * So, we have a separate thread for each host tty attached to a UML
+ * device (side-issue - I'm annoyed that one thread can't have
+ * multiple controlling ttys for the purpose of handling SIGWINCH, but
+ * I imagine there are other reasons that doesn't make any sense).
  *
- * SIGWINCH can't be received synchronously, so you have to set up to receive it
- * as a signal.  That being the case, if you are going to wait for it, it is
- * convenient to sit in sigsuspend() and wait for the signal to bounce you out of
- * it (see below for how we make sure to exit only on SIGWINCH).
+ * SIGWINCH can't be received synchronously, so you have to set up to
+ * receive it as a signal.  That being the case, if you are going to
+ * wait for it, it is convenient to sit in sigsuspend() and wait for
+ * the signal to bounce you out of it (see below for how we make sure
+ * to exit only on SIGWINCH).
  */
 
 static void winch_handler(int sig)
@@ -112,7 +114,8 @@ static int winch_thread(void *arg)
 
 	err = os_new_tty_pgrp(pty_fd, os_getpid());
 	if(err < 0){
-		printk("winch_thread : new_tty_pgrp failed, err = %d\n", -err);
+		printk("winch_thread : new_tty_pgrp failed on fd %d, "
+		       "err = %d\n", pty_fd, -err);
 		exit(1);
 	}
 
@@ -126,8 +129,9 @@ static int winch_thread(void *arg)
 		       "err = %d\n", -count);
 
 	while(1){
-		/* This will be interrupted by SIGWINCH only, since other signals
-		 * are blocked.*/
+		/* This will be interrupted by SIGWINCH only, since
+		 * other signals are blocked.
+		 */
 		sigsuspend(&sigs);
 
 		count = os_write_file(pipe_fd, &c, sizeof(c));
@@ -137,10 +141,10 @@ static int winch_thread(void *arg)
 	}
 }
 
-static int winch_tramp(int fd, struct tty_struct *tty, int *fd_out)
+static int winch_tramp(int fd, struct tty_struct *tty, int *fd_out,
+		       unsigned long *stack_out)
 {
 	struct winch_data data;
-	unsigned long stack;
 	int fds[2], n, err;
 	char c;
 
@@ -153,9 +157,11 @@ static int winch_tramp(int fd, struct tt
 	data = ((struct winch_data) { .pty_fd 		= fd,
 				      .pipe_fd 		= fds[1] } );
 	/* CLONE_FILES so this thread doesn't hold open files which are open
-	 * now, but later closed.  This is a problem with /dev/net/tun.
+	 * now, but later closed in a different thread.  This is a
+	 * problem with /dev/net/tun, which if held open by this
+	 * thread, prevents the TUN/TAP device from being reused.
 	 */
-	err = run_helper_thread(winch_thread, &data, CLONE_FILES, &stack, 0);
+	err = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out, 0);
 	if(err < 0){
 		printk("fork of winch_thread failed - errno = %d\n", -err);
 		goto out_close;
@@ -181,25 +187,25 @@ static int winch_tramp(int fd, struct tt
 
 void register_winch(int fd, struct tty_struct *tty)
 {
-	int pid, thread, thread_fd = -1;
-	int count;
+	unsigned long stack;
+	int pid, thread, count, thread_fd = -1;
 	char c = 1;
 
 	if(!isatty(fd))
 		return;
 
 	pid = tcgetpgrp(fd);
-	if(!CHOOSE_MODE_PROC(is_tracer_winch, is_skas_winch, pid, fd,
-			     tty) && (pid == -1)){
-		thread = winch_tramp(fd, tty, &thread_fd);
-		if(thread > 0){
-			register_winch_irq(thread_fd, fd, thread, tty);
-
-			count = os_write_file(thread_fd, &c, sizeof(c));
-			if(count != sizeof(c))
-				printk("register_winch : failed to write "
-				       "synchronization byte, err = %d\n",
-					-count);
-		}
+	if (!CHOOSE_MODE_PROC(is_tracer_winch, is_skas_winch, pid, fd, tty) &&
+	    (pid == -1)) {
+		thread = winch_tramp(fd, tty, &thread_fd, &stack);
+		if (thread < 0)
+			return;
+
+		register_winch_irq(thread_fd, fd, thread, tty, stack);
+
+		count = os_write_file(thread_fd, &c, sizeof(c));
+		if(count != sizeof(c))
+			printk("register_winch : failed to write "
+			       "synchronization byte, err = %d\n", -count);
 	}
 }
diff -puN arch/um/drivers/line.c~uml-sigio-support-cleanup arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-sigio-support-cleanup
+++ a/arch/um/drivers/line.c
@@ -749,8 +749,24 @@ struct winch {
 	int tty_fd;
 	int pid;
 	struct tty_struct *tty;
+	unsigned long stack;
 };
 
+static void free_winch(struct winch *winch, int free_irq_ok)
+{
+	list_del(&winch->list);
+
+	if (winch->pid != -1)
+		os_kill_process(winch->pid, 1);
+	if (winch->fd != -1)
+		os_close_file(winch->fd);
+	if (winch->stack != 0)
+		free_stack(winch->stack, 0);
+	if (free_irq_ok)
+		free_irq(WINCH_IRQ, winch);
+	kfree(winch);
+}
+
 static irqreturn_t winch_interrupt(int irq, void *data)
 {
 	struct winch *winch = data;
@@ -767,12 +783,13 @@ static irqreturn_t winch_interrupt(int i
 				       "errno = %d\n", -err);
 				printk("fd %d is losing SIGWINCH support\n",
 				       winch->tty_fd);
+				free_winch(winch, 0);
 				return IRQ_HANDLED;
 			}
 			goto out;
 		}
 	}
-	tty  = winch->tty;
+	tty = winch->tty;
 	if (tty != NULL) {
 		line = tty->driver_data;
 		chan_window_size(&line->chan_list, &tty->winsize.ws_row,
@@ -785,43 +802,44 @@ static irqreturn_t winch_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-void register_winch_irq(int fd, int tty_fd, int pid, struct tty_struct *tty)
+void register_winch_irq(int fd, int tty_fd, int pid, struct tty_struct *tty,
+			unsigned long stack)
 {
 	struct winch *winch;
 
 	winch = kmalloc(sizeof(*winch), GFP_KERNEL);
 	if (winch == NULL) {
 		printk("register_winch_irq - kmalloc failed\n");
-		return;
+		goto cleanup;
 	}
 
 	*winch = ((struct winch) { .list  	= LIST_HEAD_INIT(winch->list),
 				   .fd  	= fd,
 				   .tty_fd 	= tty_fd,
 				   .pid  	= pid,
-				   .tty 	= tty });
+				   .tty 	= tty,
+				   .stack	= stack });
+
+	if (um_request_irq(WINCH_IRQ, fd, IRQ_READ, winch_interrupt,
+			   IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
+			   "winch", winch) < 0) {
+		printk("register_winch_irq - failed to register IRQ\n");
+		goto out_free;
+	}
 
 	spin_lock(&winch_handler_lock);
 	list_add(&winch->list, &winch_handlers);
 	spin_unlock(&winch_handler_lock);
 
-	if(um_request_irq(WINCH_IRQ, fd, IRQ_READ, winch_interrupt,
-			  IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			  "winch", winch) < 0)
-		printk("register_winch_irq - failed to register IRQ\n");
-}
-
-static void free_winch(struct winch *winch)
-{
-	list_del(&winch->list);
-
-	if(winch->pid != -1)
-		os_kill_process(winch->pid, 1);
-	if(winch->fd != -1)
-		os_close_file(winch->fd);
+	return;
 
-	free_irq(WINCH_IRQ, winch);
+ out_free:
 	kfree(winch);
+ cleanup:
+	os_kill_process(pid, 1);
+	os_close_file(fd);
+	if (stack != 0)
+		free_stack(stack, 0);
 }
 
 static void unregister_winch(struct tty_struct *tty)
@@ -834,7 +852,7 @@ static void unregister_winch(struct tty_
 	list_for_each(ele, &winch_handlers){
 		winch = list_entry(ele, struct winch, list);
                 if(winch->tty == tty){
-			free_winch(winch);
+			free_winch(winch, 1);
 			break;
                 }
         }
@@ -850,7 +868,7 @@ static void winch_cleanup(void)
 
 	list_for_each_safe(ele, next, &winch_handlers){
 		winch = list_entry(ele, struct winch, list);
-		free_winch(winch);
+		free_winch(winch, 1);
 	}
 
 	spin_unlock(&winch_handler_lock);
diff -puN arch/um/include/chan_user.h~uml-sigio-support-cleanup arch/um/include/chan_user.h
--- a/arch/um/include/chan_user.h~uml-sigio-support-cleanup
+++ a/arch/um/include/chan_user.h
@@ -44,7 +44,8 @@ extern void generic_free(void *data);
 
 struct tty_struct;
 extern void register_winch(int fd,  struct tty_struct *tty);
-extern void register_winch_irq(int fd, int tty_fd, int pid, struct tty_struct *tty);
+extern void register_winch_irq(int fd, int tty_fd, int pid,
+			       struct tty_struct *tty, unsigned long stack);
 
 #define __channel_help(fn, prefix) \
 __uml_help(fn, prefix "[0-9]*=<channel description>\n" \
diff -puN arch/um/os-Linux/skas/process.c~uml-sigio-support-cleanup arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-sigio-support-cleanup
+++ a/arch/um/os-Linux/skas/process.c
@@ -41,7 +41,7 @@ int is_skas_winch(int pid, int fd, void 
 	if(pid != os_getpgrp())
 		return(0);
 
-	register_winch_irq(-1, fd, -1, data);
+	register_winch_irq(-1, fd, -1, data, 0);
 	return(1);
 }
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

tun-tap-allow-group-ownership-of-tun-tap-devices.patch
hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage-fix.patch
uml-pty-channel-tidying.patch
uml-handle-errors-on-opening-host-side-of-consoles.patch
uml-sigio-support-cleanup.patch
uml-eliminate-kernel-allocator-wrappers.patch
