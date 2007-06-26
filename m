From: akpm@linux-foundation.org
Subject: + uml-xterm-driver-tidying.patch added to -mm tree
Date: Tue, 26 Jun 2007 15:05:39 -0700
Message-ID: <200706262205.l5QM5d7G003181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757374AbXFZWFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 18:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: xterm driver tidying
has been added to the -mm tree.  Its filename is
     uml-xterm-driver-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: xterm driver tidying
From: Jeff Dike <jdike@addtoit.com>

Major tidying of the xterm console driver:
	got rid of the tt-mode gdb support
	tidied up the includes
	fixed lots of style violations
	replaced os_* calls with glibc calls in xterm.c
	all printk calls now have a severity indicator
	the error paths of xterm_open are closer to being right

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ssl.c           |    2 
 arch/um/drivers/stdio_console.c |    2 
 arch/um/drivers/xterm.c         |  173 +++++++++++++++---------------
 arch/um/drivers/xterm_kern.c    |   49 ++------
 arch/um/include/chan_user.h     |    2 
 5 files changed, 105 insertions(+), 123 deletions(-)

diff -puN arch/um/drivers/ssl.c~uml-xterm-driver-tidying arch/um/drivers/ssl.c
--- a/arch/um/drivers/ssl.c~uml-xterm-driver-tidying
+++ a/arch/um/drivers/ssl.c
@@ -42,8 +42,6 @@ static struct chan_opts opts = {
 	.announce 	= ssl_announce,
 	.xterm_title	= "Serial Line #%d",
 	.raw		= 1,
-	.tramp_stack 	= 0,
-	.in_kernel 	= 1,
 };
 
 static int ssl_config(char *str, char **error_out);
diff -puN arch/um/drivers/stdio_console.c~uml-xterm-driver-tidying arch/um/drivers/stdio_console.c
--- a/arch/um/drivers/stdio_console.c~uml-xterm-driver-tidying
+++ a/arch/um/drivers/stdio_console.c
@@ -46,8 +46,6 @@ static struct chan_opts opts = {
 	.announce 	= stdio_announce,
 	.xterm_title	= "Virtual Console #%d",
 	.raw		= 1,
-	.tramp_stack 	= 0,
-	.in_kernel 	= 1,
 };
 
 static int con_config(char *str, char **error_out);
diff -puN arch/um/drivers/xterm.c~uml-xterm-driver-tidying arch/um/drivers/xterm.c
--- a/arch/um/drivers/xterm.c~uml-xterm-driver-tidying
+++ a/arch/um/drivers/xterm.c
@@ -1,22 +1,20 @@
 /* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include <stdio.h>
 #include <stdlib.h>
+#include <stdio.h>
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
 #include <termios.h>
-#include <signal.h>
-#include <sched.h>
-#include <sys/socket.h>
-#include "kern_util.h"
 #include "chan_user.h"
-#include "user.h"
 #include "os.h"
+#include "init.h"
+#include "user.h"
 #include "xterm.h"
+#include "kern_constants.h"
 
 struct xterm_chan {
 	int pid;
@@ -25,25 +23,21 @@ struct xterm_chan {
 	int device;
 	int raw;
 	struct termios tt;
-	unsigned long stack;
-	int direct_rcv;
 };
 
-/* Not static because it's called directly by the tt mode gdb code */
-void *xterm_init(char *str, int device, const struct chan_opts *opts)
+static void *xterm_init(char *str, int device, const struct chan_opts *opts)
 {
 	struct xterm_chan *data;
 
 	data = malloc(sizeof(*data));
-	if(data == NULL) return(NULL);
-	*data = ((struct xterm_chan) { .pid 		= -1, 
+	if (data == NULL)
+		return NULL;
+	*data = ((struct xterm_chan) { .pid 		= -1,
 				       .helper_pid 	= -1,
-				       .device 		= device, 
+				       .device 		= device,
 				       .title 		= opts->xterm_title,
-				       .raw  		= opts->raw,
-				       .stack 		= opts->tramp_stack,
-				       .direct_rcv 	= !opts->in_kernel } );
-	return(data);
+				       .raw  		= opts->raw } );
+	return data;
 }
 
 /* Only changed by xterm_setup, which is a setup */
@@ -57,16 +51,22 @@ static int __init xterm_setup(char *line
 	terminal_emulator = line;
 
 	line = strchr(line, ',');
-	if(line == NULL) return(0);
+	if (line == NULL)
+		return 0;
+
 	*line++ = '\0';
-	if(*line) title_switch = line;
+	if (*line)
+		title_switch = line;
 
 	line = strchr(line, ',');
-	if(line == NULL) return(0);
+	if (line == NULL)
+		return 0;
+
 	*line++ = '\0';
-	if(*line) exec_switch = line;
+	if (*line)
+		exec_switch = line;
 
-	return(0);
+	return 0;
 }
 
 __uml_setup("xterm=", xterm_setup,
@@ -82,114 +82,128 @@ __uml_setup("xterm=", xterm_setup,
 "    are 'xterm=gnome-terminal,-t,-x'.\n\n"
 );
 
-/* XXX This badly needs some cleaning up in the error paths
- * Not static because it's called directly by the tt mode gdb code
- */
-int xterm_open(int input, int output, int primary, void *d,
+static int xterm_open(int input, int output, int primary, void *d,
 		      char **dev_out)
 {
 	struct xterm_chan *data = d;
-	unsigned long stack;
 	int pid, fd, new, err;
 	char title[256], file[] = "/tmp/xterm-pipeXXXXXX";
-	char *argv[] = { terminal_emulator, title_switch, title, exec_switch, 
+	char *argv[] = { terminal_emulator, title_switch, title, exec_switch,
 			 "/usr/lib/uml/port-helper", "-uml-socket",
 			 file, NULL };
 
-	if(os_access(argv[4], OS_ACC_X_OK) < 0)
+	if (access(argv[4], X_OK) < 0)
 		argv[4] = "port-helper";
 
 	/* Check that DISPLAY is set, this doesn't guarantee the xterm
 	 * will work but w/o it we can be pretty sure it won't. */
-	if (!getenv("DISPLAY")) {
-		printk("xterm_open: $DISPLAY not set.\n");
+	if (getenv("DISPLAY") == NULL) {
+		printk(UM_KERN_ERR "xterm_open: $DISPLAY not set.\n");
 		return -ENODEV;
 	}
 
+	/*
+	 * This business of getting a descriptor to a temp file,
+	 * deleting the file and closing the descriptor is just to get
+	 * a known-unused name for the Unix socket that we really
+	 * want.
+	 */
 	fd = mkstemp(file);
-	if(fd < 0){
+	if (fd < 0) {
 		err = -errno;
-		printk("xterm_open : mkstemp failed, errno = %d\n", errno);
+		printk(UM_KERN_ERR "xterm_open : mkstemp failed, errno = %d\n",
+		       errno);
 		return err;
 	}
 
-	if(unlink(file)){
+	if (unlink(file)) {
 		err = -errno;
-		printk("xterm_open : unlink failed, errno = %d\n", errno);
+		printk(UM_KERN_ERR "xterm_open : unlink failed, errno = %d\n",
+		       errno);
 		return err;
 	}
-	os_close_file(fd);
+	close(fd);
 
 	fd = os_create_unix_socket(file, sizeof(file), 1);
-	if(fd < 0){
-		printk("xterm_open : create_unix_socket failed, errno = %d\n", 
-		       -fd);
-		return(fd);
+	if (fd < 0) {
+		printk(UM_KERN_ERR "xterm_open : create_unix_socket failed, "
+		       "errno = %d\n", -fd);
+		return fd;
 	}
 
 	sprintf(title, data->title, data->device);
-	stack = data->stack;
-	pid = run_helper(NULL, NULL, argv, &stack);
-	if(pid < 0){
-		printk("xterm_open : run_helper failed, errno = %d\n", -pid);
-		return(pid);
+	pid = run_helper(NULL, NULL, argv, NULL);
+	if (pid < 0) {
+		err = pid;
+		printk(UM_KERN_ERR "xterm_open : run_helper failed, "
+		       "errno = %d\n", -err);
+		goto out_close1;
 	}
 
-	if (data->direct_rcv) {
-		new = os_rcv_fd(fd, &data->helper_pid);
-	} else {
-		err = os_set_fd_block(fd, 0);
-		if(err < 0){
-			printk("xterm_open : failed to set descriptor "
-			       "non-blocking, err = %d\n", -err);
-			return(err);
-		}
-		new = xterm_fd(fd, &data->helper_pid);
+	err = os_set_fd_block(fd, 0);
+	if (err < 0) {
+		printk(UM_KERN_ERR "xterm_open : failed to set descriptor "
+		       "non-blocking, err = %d\n", -err);
+		goto out_kill;
 	}
-	if(new < 0){
-		printk("xterm_open : os_rcv_fd failed, err = %d\n", -new);
-		goto out;
+
+	new = xterm_fd(fd, &data->helper_pid);
+	if (new < 0) {
+		err = new;
+		printk(UM_KERN_ERR "xterm_open : os_rcv_fd failed, err = %d\n",
+		       -err);
+		goto out_kill;
 	}
 
 	err = os_set_fd_block(new, 0);
 	if (err) {
-		printk("xterm_open : failed to set xterm descriptor "
-		       "non-blocking, err = %d\n", -err);
-		goto out;
+		printk(UM_KERN_ERR "xterm_open : failed to set xterm "
+		       "descriptor non-blocking, err = %d\n", -err);
+		goto out_close2;
 	}
 
 	CATCH_EINTR(err = tcgetattr(new, &data->tt));
-	if(err){
+	if (err) {
 		new = err;
-		goto out;
+		goto out_close2;
 	}
 
-	if(data->raw){
+	if (data->raw) {
 		err = raw(new);
-		if(err){
+		if (err) {
 			new = err;
-			goto out;
+			goto out_close2;
 		}
 	}
 
+	unlink(file);
 	data->pid = pid;
 	*dev_out = NULL;
- out:
-	unlink(file);
-	return(new);
+
+	return new;
+
+ out_close2:
+	close(new);
+ out_kill:
+	os_kill_process(pid, 1);
+ out_close1:
+	close(fd);
+
+	return err;
 }
 
-/* Not static because it's called directly by the tt mode gdb code */
-void xterm_close(int fd, void *d)
+static void xterm_close(int fd, void *d)
 {
 	struct xterm_chan *data = d;
 	
-	if(data->pid != -1) 
+	if (data->pid != -1)
 		os_kill_process(data->pid, 1);
 	data->pid = -1;
-	if(data->helper_pid != -1) 
+
+	if (data->helper_pid != -1)
 		os_kill_process(data->helper_pid, 0);
 	data->helper_pid = -1;
+
 	os_close_file(fd);
 }
 
@@ -210,14 +224,3 @@ const struct chan_ops xterm_ops = {
 	.free		= xterm_free,
 	.winch		= 1,
 };
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/xterm_kern.c~uml-xterm-driver-tidying arch/um/drivers/xterm_kern.c
--- a/arch/um/drivers/xterm_kern.c~uml-xterm-driver-tidying
+++ a/arch/um/drivers/xterm_kern.c
@@ -1,18 +1,14 @@
 /* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/errno.h"
-#include "linux/slab.h"
-#include "linux/signal.h"
-#include "linux/interrupt.h"
-#include "asm/irq.h"
-#include "irq_user.h"
+#include <linux/slab.h>
+#include <linux/completion.h>
+#include <linux/irqreturn.h>
+#include <asm/irq.h>
 #include "irq_kern.h"
-#include "kern_util.h"
 #include "os.h"
-#include "xterm.h"
 
 struct xterm_wait {
 	struct completion ready;
@@ -27,12 +23,13 @@ static irqreturn_t xterm_interrupt(int i
 	int fd;
 
 	fd = os_rcv_fd(xterm->fd, &xterm->pid);
-	if(fd == -EAGAIN)
-		return(IRQ_NONE);
+	if (fd == -EAGAIN)
+		return IRQ_NONE;
 
 	xterm->new_fd = fd;
 	complete(&xterm->ready);
-	return(IRQ_HANDLED);
+
+	return IRQ_HANDLED;
 }
 
 int xterm_fd(int socket, int *pid_out)
@@ -41,22 +38,21 @@ int xterm_fd(int socket, int *pid_out)
 	int err, ret;
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
-	if(data == NULL){
+	if (data == NULL) {
 		printk(KERN_ERR "xterm_fd : failed to allocate xterm_wait\n");
-		return(-ENOMEM);
+		return -ENOMEM;
 	}
 
 	/* This is a locked semaphore... */
-	*data = ((struct xterm_wait) 
-		{ .fd 		= socket,
-		  .pid 		= -1,
-		  .new_fd 	= -1 });
+	*data = ((struct xterm_wait) { .fd 		= socket,
+				       .pid 		= -1,
+				       .new_fd	 	= -1 });
 	init_completion(&data->ready);
 
-	err = um_request_irq(XTERM_IRQ, socket, IRQ_READ, xterm_interrupt, 
+	err = um_request_irq(XTERM_IRQ, socket, IRQ_READ, xterm_interrupt,
 			     IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			     "xterm", data);
-	if (err){
+	if (err) {
 		printk(KERN_ERR "xterm_fd : failed to get IRQ for xterm, "
 		       "err = %d\n",  err);
 		ret = err;
@@ -76,16 +72,5 @@ int xterm_fd(int socket, int *pid_out)
  out:
 	kfree(data);
 
-	return(ret);
+	return ret;
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/chan_user.h~uml-xterm-driver-tidying arch/um/include/chan_user.h
--- a/arch/um/include/chan_user.h~uml-xterm-driver-tidying
+++ a/arch/um/include/chan_user.h
@@ -12,8 +12,6 @@ struct chan_opts {
 	void (*const announce)(char *dev_name, int dev);
 	char *xterm_title;
 	const int raw;
-	const unsigned long tramp_stack;
-	const int in_kernel;
 };
 
 enum chan_init_pri { INIT_STATIC, INIT_ALL, INIT_ONE };
_

Patches currently in -mm which might be from jdike@addtoit.com are

tun-tap-allow-group-ownership-of-tun-tap-devices.patch
hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage.patch
add-generic-exit-time-stack-depth-checking-to-config_debug_stack_usage-fix.patch
uml-xterm-driver-tidying.patch
uml-pty-channel-tidying.patch
uml-handle-errors-on-opening-host-side-of-consoles.patch
uml-sigio-support-cleanup.patch
uml-eliminate-kernel-allocator-wrappers.patch
