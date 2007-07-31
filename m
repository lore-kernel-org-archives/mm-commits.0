From: akpm@linux-foundation.org
Subject: + uml-console-subsystem-tidying.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:29:54 -0700
Message-ID: <200707310129.l6V1TsY4008493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763500AbXGaBaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: console subsystem tidying
has been added to the -mm tree.  Its filename is
     uml-console-subsystem-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: console subsystem tidying
From: Jeff Dike <jdike@addtoit.com>

This does a lot of cleanup on the UML console system.  This patch should be
entirely non-functional.

The tidying is as follows:
	header cleanups - the includes should be closer to minimal and complete
	all printks now have a severity
	lots of style fixes
	fd_close is restructured a little in order to reduce the nesting
	some functions were calling the os_* wrappers when they can
call libc directly
	port_accept had a unnecessary variable
	it also tested a pid unecessarily before killing it
	some functions were made static
	xterm_free is gone, as it was identical to generic_free

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |  160 +++++++++++++++++-----------------
 arch/um/drivers/chan_user.c |  113 ++++++++++++------------
 arch/um/drivers/fd.c        |   74 +++++++--------
 arch/um/drivers/null.c      |   28 ++---
 arch/um/drivers/port_kern.c |   82 ++++++++---------
 arch/um/drivers/port_user.c |   73 +++++++--------
 arch/um/drivers/pty.c       |   14 ++
 arch/um/drivers/tty.c       |   37 ++++---
 arch/um/drivers/xterm.c     |   16 +--
 9 files changed, 297 insertions(+), 300 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-console-subsystem-tidying arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-console-subsystem-tidying
+++ a/arch/um/drivers/chan_kern.c
@@ -1,28 +1,19 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
-#include <linux/stddef.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/tty.h>
-#include <linux/string.h>
 #include <linux/tty_flip.h>
-#include <asm/irq.h>
 #include "chan_kern.h"
-#include "kern.h"
-#include "irq_user.h"
-#include "sigio.h"
-#include "line.h"
 #include "os.h"
 
 #ifdef CONFIG_NOCONFIG_CHAN
 static void *not_configged_init(char *str, int device,
 				const struct chan_opts *opts)
 {
-	printk("Using a channel type which is configured out of "
+	printk(KERN_ERR "Using a channel type which is configured out of "
 	       "UML\n");
 	return NULL;
 }
@@ -30,34 +21,34 @@ static void *not_configged_init(char *st
 static int not_configged_open(int input, int output, int primary, void *data,
 			      char **dev_out)
 {
-	printk("Using a channel type which is configured out of "
+	printk(KERN_ERR "Using a channel type which is configured out of "
 	       "UML\n");
 	return -ENODEV;
 }
 
 static void not_configged_close(int fd, void *data)
 {
-	printk("Using a channel type which is configured out of "
+	printk(KERN_ERR "Using a channel type which is configured out of "
 	       "UML\n");
 }
 
 static int not_configged_read(int fd, char *c_out, void *data)
 {
-	printk("Using a channel type which is configured out of "
+	printk(KERN_ERR "Using a channel type which is configured out of "
 	       "UML\n");
 	return -EIO;
 }
 
 static int not_configged_write(int fd, const char *buf, int len, void *data)
 {
-	printk("Using a channel type which is configured out of "
+	printk(KERN_ERR "Using a channel type which is configured out of "
 	       "UML\n");
 	return -EIO;
 }
 
 static int not_configged_console_write(int fd, const char *buf, int len)
 {
-	printk("Using a channel type which is configured out of "
+	printk(KERN_ERR "Using a channel type which is configured out of "
 	       "UML\n");
 	return -EIO;
 }
@@ -65,14 +56,14 @@ static int not_configged_console_write(i
 static int not_configged_window_size(int fd, void *data, unsigned short *rows,
 				     unsigned short *cols)
 {
-	printk("Using a channel type which is configured out of "
+	printk(KERN_ERR "Using a channel type which is configured out of "
 	       "UML\n");
 	return -ENODEV;
 }
 
 static void not_configged_free(void *data)
 {
-	printk("Using a channel type which is configured out of "
+	printk(KERN_ERR "Using a channel type which is configured out of "
 	       "UML\n");
 }
 
@@ -91,14 +82,15 @@ static const struct chan_ops not_configg
 
 static void tty_receive_char(struct tty_struct *tty, char ch)
 {
-	if(tty == NULL) return;
+	if (tty == NULL)
+		return;
 
-	if(I_IXON(tty) && !I_IXOFF(tty) && !tty->raw) {
-		if(ch == STOP_CHAR(tty)){
+	if (I_IXON(tty) && !I_IXOFF(tty) && !tty->raw) {
+		if (ch == STOP_CHAR(tty)) {
 			stop_tty(tty);
 			return;
 		}
-		else if(ch == START_CHAR(tty)){
+		else if (ch == START_CHAR(tty)) {
 			start_tty(tty);
 			return;
 		}
@@ -111,14 +103,14 @@ static int open_one_chan(struct chan *ch
 {
 	int fd, err;
 
-	if(chan->opened)
+	if (chan->opened)
 		return 0;
 
-	if(chan->ops->open == NULL)
+	if (chan->ops->open == NULL)
 		fd = 0;
 	else fd = (*chan->ops->open)(chan->input, chan->output, chan->primary,
 				     chan->data, &chan->dev);
-	if(fd < 0)
+	if (fd < 0)
 		return fd;
 
 	err = os_set_fd_block(fd, 0);
@@ -139,10 +131,10 @@ int open_chan(struct list_head *chans)
 	struct chan *chan;
 	int ret, err = 0;
 
-	list_for_each(ele, chans){
+	list_for_each(ele, chans) {
 		chan = list_entry(ele, struct chan, list);
 		ret = open_one_chan(chan);
-		if(chan->primary)
+		if (chan->primary)
 			err = ret;
 	}
 	return err;
@@ -153,9 +145,9 @@ void chan_enable_winch(struct list_head 
 	struct list_head *ele;
 	struct chan *chan;
 
-	list_for_each(ele, chans){
+	list_for_each(ele, chans) {
 		chan = list_entry(ele, struct chan, list);
-		if(chan->primary && chan->output && chan->ops->winch){
+		if (chan->primary && chan->output && chan->ops->winch) {
 			register_winch(chan->fd, tty);
 			return;
 		}
@@ -168,7 +160,7 @@ int enable_chan(struct line *line)
 	struct chan *chan;
 	int err;
 
-	list_for_each(ele, &line->chan_list){
+	list_for_each(ele, &line->chan_list) {
 		chan = list_entry(ele, struct chan, list);
 		err = open_one_chan(chan);
 		if (err) {
@@ -178,7 +170,7 @@ int enable_chan(struct line *line)
 			continue;
 		}
 
-		if(chan->enabled)
+		if (chan->enabled)
 			continue;
 		err = line_setup_irq(chan->fd, chan->input, chan->output, line,
 				     chan);
@@ -215,12 +207,12 @@ void free_irqs(void)
 	list_splice_init(&irqs_to_free, &list);
 	spin_unlock_irqrestore(&irqs_to_free_lock, flags);
 
-	list_for_each(ele, &list){
+	list_for_each(ele, &list) {
 		chan = list_entry(ele, struct chan, free_list);
 
-		if(chan->input)
+		if (chan->input)
 			free_irq(chan->line->driver->read_irq, chan);
-		if(chan->output)
+		if (chan->output)
 			free_irq(chan->line->driver->write_irq, chan);
 		chan->enabled = 0;
 	}
@@ -230,22 +222,22 @@ static void close_one_chan(struct chan *
 {
 	unsigned long flags;
 
-	if(!chan->opened)
+	if (!chan->opened)
 		return;
 
-	if(delay_free_irq){
+	if (delay_free_irq) {
 		spin_lock_irqsave(&irqs_to_free_lock, flags);
 		list_add(&chan->free_list, &irqs_to_free);
 		spin_unlock_irqrestore(&irqs_to_free_lock, flags);
 	}
 	else {
-		if(chan->input)
+		if (chan->input)
 			free_irq(chan->line->driver->read_irq, chan);
-		if(chan->output)
+		if (chan->output)
 			free_irq(chan->line->driver->write_irq, chan);
 		chan->enabled = 0;
 	}
-	if(chan->ops->close != NULL)
+	if (chan->ops->close != NULL)
 		(*chan->ops->close)(chan->fd, chan->data);
 
 	chan->opened = 0;
@@ -274,7 +266,7 @@ void deactivate_chan(struct list_head *c
 	list_for_each(ele, chans) {
 		chan = list_entry(ele, struct chan, list);
 
-		if(chan->enabled && chan->input)
+		if (chan->enabled && chan->input)
 			deactivate_fd(chan->fd, irq);
 	}
 }
@@ -287,7 +279,7 @@ void reactivate_chan(struct list_head *c
 	list_for_each(ele, chans) {
 		chan = list_entry(ele, struct chan, list);
 
-		if(chan->enabled && chan->input)
+		if (chan->enabled && chan->input)
 			reactivate_fd(chan->fd, irq);
 	}
 }
@@ -303,6 +295,7 @@ int write_chan(struct list_head *chans, 
 		chan = list_entry(ele, struct chan, list);
 		if (!chan->output || (chan->ops->write == NULL))
 			continue;
+
 		n = chan->ops->write(chan->fd, buf, len, chan->data);
 		if (chan->primary) {
 			ret = n;
@@ -319,12 +312,14 @@ int console_write_chan(struct list_head 
 	struct chan *chan;
 	int n, ret = 0;
 
-	list_for_each(ele, chans){
+	list_for_each(ele, chans) {
 		chan = list_entry(ele, struct chan, list);
-		if(!chan->output || (chan->ops->console_write == NULL))
+		if (!chan->output || (chan->ops->console_write == NULL))
 			continue;
+
 		n = chan->ops->console_write(chan->fd, buf, len);
-		if(chan->primary) ret = n;
+		if (chan->primary)
+			ret = n;
 	}
 	return ret;
 }
@@ -334,10 +329,11 @@ int console_open_chan(struct line *line,
 	int err;
 
 	err = open_chan(&line->chan_list);
-	if(err)
+	if (err)
 		return err;
 
-	printk("Console initialized on /dev/%s%d\n", co->name, co->index);
+	printk(KERN_INFO "Console initialized on /dev/%s%d\n", co->name,
+	       co->index);
 	return 0;
 }
 
@@ -347,10 +343,10 @@ int chan_window_size(struct list_head *c
 	struct list_head *ele;
 	struct chan *chan;
 
-	list_for_each(ele, chans){
+	list_for_each(ele, chans) {
 		chan = list_entry(ele, struct chan, list);
-		if(chan->primary){
-			if(chan->ops->window_size == NULL)
+		if (chan->primary) {
+			if (chan->ops->window_size == NULL)
 				return 0;
 			return chan->ops->window_size(chan->fd, chan->data,
 						      rows_out, cols_out);
@@ -365,10 +361,11 @@ static void free_one_chan(struct chan *c
 
 	close_one_chan(chan, delay_free_irq);
 
-	if(chan->ops->free != NULL)
+	if (chan->ops->free != NULL)
 		(*chan->ops->free)(chan->data);
 
-	if(chan->primary && chan->output) ignore_sigio_fd(chan->fd);
+	if (chan->primary && chan->output)
+		ignore_sigio_fd(chan->fd);
 	kfree(chan);
 }
 
@@ -377,7 +374,7 @@ static void free_chan(struct list_head *
 	struct list_head *ele, *next;
 	struct chan *chan;
 
-	list_for_each_safe(ele, next, chans){
+	list_for_each_safe(ele, next, chans) {
 		chan = list_entry(ele, struct chan, list);
 		free_one_chan(chan, delay_free_irq);
 	}
@@ -388,14 +385,14 @@ static int one_chan_config_string(struct
 {
 	int n = 0;
 
-	if(chan == NULL){
+	if (chan == NULL) {
 		CONFIG_CHUNK(str, size, n, "none", 1);
 		return n;
 	}
 
 	CONFIG_CHUNK(str, size, n, chan->ops->type, 0);
 
-	if(chan->dev == NULL){
+	if (chan->dev == NULL) {
 		CONFIG_CHUNK(str, size, n, "", 1);
 		return n;
 	}
@@ -415,7 +412,7 @@ static int chan_pair_config_string(struc
 	str += n;
 	size -= n;
 
-	if(in == out){
+	if (in == out) {
 		CONFIG_CHUNK(str, size, n, "", 1);
 		return n;
 	}
@@ -435,13 +432,13 @@ int chan_config_string(struct list_head 
 	struct list_head *ele;
 	struct chan *chan, *in = NULL, *out = NULL;
 
-	list_for_each(ele, chans){
+	list_for_each(ele, chans) {
 		chan = list_entry(ele, struct chan, list);
-		if(!chan->primary)
+		if (!chan->primary)
 			continue;
-		if(chan->input)
+		if (chan->input)
 			in = chan;
-		if(chan->output)
+		if (chan->output)
 			out = chan;
 	}
 
@@ -500,27 +497,27 @@ static struct chan *parse_chan(struct li
 
 	ops = NULL;
 	data = NULL;
-	for(i = 0; i < ARRAY_SIZE(chan_table); i++){
+	for(i = 0; i < ARRAY_SIZE(chan_table); i++) {
 		entry = &chan_table[i];
-		if(!strncmp(str, entry->key, strlen(entry->key))){
+		if (!strncmp(str, entry->key, strlen(entry->key))) {
 			ops = entry->ops;
 			str += strlen(entry->key);
 			break;
 		}
 	}
-	if(ops == NULL){
+	if (ops == NULL) {
 		*error_out = "No match for configured backends";
 		return NULL;
 	}
 
 	data = (*ops->init)(str, device, opts);
-	if(data == NULL){
+	if (data == NULL) {
 		*error_out = "Configuration failed";
 		return NULL;
 	}
 
 	chan = kmalloc(sizeof(*chan), GFP_ATOMIC);
-	if(chan == NULL){
+	if (chan == NULL) {
 		*error_out = "Memory allocation failed";
 		return NULL;
 	}
@@ -546,26 +543,26 @@ int parse_chan_pair(char *str, struct li
 	struct chan *new, *chan;
 	char *in, *out;
 
-	if(!list_empty(chans)){
+	if (!list_empty(chans)) {
 		chan = list_entry(chans->next, struct chan, list);
 		free_chan(chans, 0);
 		INIT_LIST_HEAD(chans);
 	}
 
 	out = strchr(str, ',');
-	if(out != NULL){
+	if (out != NULL) {
 		in = str;
 		*out = '\0';
 		out++;
 		new = parse_chan(line, in, device, opts, error_out);
-		if(new == NULL)
+		if (new == NULL)
 			return -1;
 
 		new->input = 1;
 		list_add(&new->list, chans);
 
 		new = parse_chan(line, out, device, opts, error_out);
-		if(new == NULL)
+		if (new == NULL)
 			return -1;
 
 		list_add(&new->list, chans);
@@ -573,7 +570,7 @@ int parse_chan_pair(char *str, struct li
 	}
 	else {
 		new = parse_chan(line, str, device, opts, error_out);
-		if(new == NULL)
+		if (new == NULL)
 			return -1;
 
 		list_add(&new->list, chans);
@@ -588,9 +585,9 @@ int chan_out_fd(struct list_head *chans)
 	struct list_head *ele;
 	struct chan *chan;
 
-	list_for_each(ele, chans){
+	list_for_each(ele, chans) {
 		chan = list_entry(ele, struct chan, list);
-		if(chan->primary && chan->output)
+		if (chan->primary && chan->output)
 			return chan->fd;
 	}
 	return -1;
@@ -604,23 +601,25 @@ void chan_interrupt(struct list_head *ch
 	int err;
 	char c;
 
-	list_for_each_safe(ele, next, chans){
+	list_for_each_safe(ele, next, chans) {
 		chan = list_entry(ele, struct chan, list);
-		if(!chan->input || (chan->ops->read == NULL)) continue;
+		if (!chan->input || (chan->ops->read == NULL))
+			continue;
 		do {
 			if (tty && !tty_buffer_request_room(tty, 1)) {
 				schedule_delayed_work(task, 1);
 				goto out;
 			}
 			err = chan->ops->read(chan->fd, &c, chan->data);
-			if(err > 0)
+			if (err > 0)
 				tty_receive_char(tty, c);
-		} while(err > 0);
+		} while (err > 0);
 
-		if(err == 0) reactivate_fd(chan->fd, irq);
-		if(err == -EIO){
-			if(chan->primary){
-				if(tty != NULL)
+		if (err == 0)
+			reactivate_fd(chan->fd, irq);
+		if (err == -EIO) {
+			if (chan->primary) {
+				if (tty != NULL)
 					tty_hangup(tty);
 				close_chan(chans, 1);
 				return;
@@ -629,5 +628,6 @@ void chan_interrupt(struct list_head *ch
 		}
 	}
  out:
-	if(tty) tty_flip_buffer_push(tty);
+	if (tty)
+		tty_flip_buffer_push(tty);
 }
diff -puN arch/um/drivers/chan_user.c~uml-console-subsystem-tidying arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-console-subsystem-tidying
+++ a/arch/um/drivers/chan_user.c
@@ -1,25 +1,19 @@
 /* 
- * Copyright (C) 2000 - 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
-#include <unistd.h>
 #include <stdlib.h>
+#include <unistd.h>
 #include <errno.h>
-#include <termios.h>
-#include <string.h>
-#include <signal.h>
 #include <sched.h>
-#include <sys/stat.h>
+#include <signal.h>
+#include <termios.h>
 #include <sys/ioctl.h>
-#include <sys/socket.h>
-#include "kern_util.h"
 #include "chan_user.h"
-#include "user.h"
 #include "os.h"
-#include "choose-mode.h"
-#include "mode.h"
 #include "um_malloc.h"
+#include "user.h"
 
 void generic_close(int fd, void *unused)
 {
@@ -53,7 +47,7 @@ int generic_window_size(int fd, void *un
 	struct winsize size;
 	int ret;
 
-	if(ioctl(fd, TIOCGWINSZ, &size) < 0)
+	if (ioctl(fd, TIOCGWINSZ, &size) < 0)
 		return -errno;
 
 	ret = ((*rows_out != size.ws_row) || (*cols_out != size.ws_col));
@@ -74,7 +68,7 @@ int generic_console_write(int fd, const 
 	struct termios save, new;
 	int err;
 
-	if(isatty(fd)){
+	if (isatty(fd)) {
 		CATCH_EINTR(err = tcgetattr(fd, &save));
 		if (err)
 			goto error;
@@ -90,11 +84,11 @@ int generic_console_write(int fd, const 
 	err = generic_write(fd, buf, n, NULL);
 	/* Restore raw mode, in any case; we *must* ignore any error apart
 	 * EINTR, except for debug.*/
-	if(isatty(fd))
+	if (isatty(fd))
 		CATCH_EINTR(tcsetattr(fd, TCSAFLUSH, &save));
-	return(err);
+	return err;
 error:
-	return(-errno);
+	return -errno;
 }
 
 /*
@@ -137,56 +131,62 @@ static int winch_thread(void *arg)
 	pty_fd = data->pty_fd;
 	pipe_fd = data->pipe_fd;
 	count = os_write_file(pipe_fd, &c, sizeof(c));
-	if(count != sizeof(c))
-		printk("winch_thread : failed to write synchronization "
-		       "byte, err = %d\n", -count);
+	if (count != sizeof(c))
+		printk(UM_KERN_ERR "winch_thread : failed to write "
+		       "synchronization byte, err = %d\n", -count);
 
-	/* We are not using SIG_IGN on purpose, so don't fix it as I thought to
+	/*
+	 * We are not using SIG_IGN on purpose, so don't fix it as I thought to
 	 * do! If using SIG_IGN, the sigsuspend() call below would not stop on
-	 * SIGWINCH. */
+	 * SIGWINCH.
+	 */
 
 	signal(SIGWINCH, winch_handler);
 	sigfillset(&sigs);
 	/* Block all signals possible. */
-	if(sigprocmask(SIG_SETMASK, &sigs, NULL) < 0){
-		printk("winch_thread : sigprocmask failed, errno = %d\n", 
-		       errno);
+	if (sigprocmask(SIG_SETMASK, &sigs, NULL) < 0) {
+		printk(UM_KERN_ERR "winch_thread : sigprocmask failed, "
+		       "errno = %d\n", errno);
 		exit(1);
 	}
 	/* In sigsuspend(), block anything else than SIGWINCH. */
 	sigdelset(&sigs, SIGWINCH);
 
-	if(setsid() < 0){
-		printk("winch_thread : setsid failed, errno = %d\n", errno);
+	if (setsid() < 0) {
+		printk(UM_KERN_ERR "winch_thread : setsid failed, errno = %d\n",
+		       errno);
 		exit(1);
 	}
 
 	err = os_new_tty_pgrp(pty_fd, os_getpid());
-	if(err < 0){
-		printk("winch_thread : new_tty_pgrp failed on fd %d, "
-		       "err = %d\n", pty_fd, -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "winch_thread : new_tty_pgrp failed on "
+		       "fd %d err = %d\n", pty_fd, -err);
 		exit(1);
 	}
 
-	/* These are synchronization calls between various UML threads on the
+	/*
+	 * These are synchronization calls between various UML threads on the
 	 * host - since they are not different kernel threads, we cannot use
 	 * kernel semaphores. We don't use SysV semaphores because they are
-	 * persistent. */
+	 * persistent.
+	 */
 	count = os_read_file(pipe_fd, &c, sizeof(c));
-	if(count != sizeof(c))
-		printk("winch_thread : failed to read synchronization byte, "
-		       "err = %d\n", -count);
-
-	while(1){
-		/* This will be interrupted by SIGWINCH only, since
+	if (count != sizeof(c))
+		printk(UM_KERN_ERR "winch_thread : failed to read "
+		       "synchronization byte, err = %d\n", -count);
+
+	while(1) {
+		/*
+		 * This will be interrupted by SIGWINCH only, since
 		 * other signals are blocked.
 		 */
 		sigsuspend(&sigs);
 
 		count = os_write_file(pipe_fd, &c, sizeof(c));
-		if(count != sizeof(c))
-			printk("winch_thread : write failed, err = %d\n",
-			       -count);
+		if (count != sizeof(c))
+			printk(UM_KERN_ERR "winch_thread : write failed, "
+			       "err = %d\n", -count);
 	}
 }
 
@@ -198,36 +198,41 @@ static int winch_tramp(int fd, struct tt
 	char c;
 
 	err = os_pipe(fds, 1, 1);
-	if(err < 0){
-		printk("winch_tramp : os_pipe failed, err = %d\n", -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "winch_tramp : os_pipe failed, err = %d\n",
+		       -err);
 		goto out;
 	}
 
 	data = ((struct winch_data) { .pty_fd 		= fd,
 				      .pipe_fd 		= fds[1] } );
-	/* CLONE_FILES so this thread doesn't hold open files which are open
+	/*
+	 * CLONE_FILES so this thread doesn't hold open files which are open
 	 * now, but later closed in a different thread.  This is a
 	 * problem with /dev/net/tun, which if held open by this
 	 * thread, prevents the TUN/TAP device from being reused.
 	 */
 	err = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out);
-	if(err < 0){
-		printk("fork of winch_thread failed - errno = %d\n", -err);
+	if (err < 0) {
+		printk(UM_KERN_ERR "fork of winch_thread failed - errno = %d\n",
+		       -err);
 		goto out_close;
 	}
 
 	*fd_out = fds[0];
 	n = os_read_file(fds[0], &c, sizeof(c));
-	if(n != sizeof(c)){
-		printk("winch_tramp : failed to read synchronization byte\n");
-		printk("read failed, err = %d\n", -n);
-		printk("fd %d will not support SIGWINCH\n", fd);
-                err = -EINVAL;
+	if (n != sizeof(c)) {
+		printk(UM_KERN_ERR "winch_tramp : failed to read "
+		       "synchronization byte\n");
+		printk(UM_KERN_ERR "read failed, err = %d\n", -n);
+		printk(UM_KERN_ERR "fd %d will not support SIGWINCH\n", fd);
+		err = -EINVAL;
 		goto out_close;
 	}
 
 	if (os_set_fd_block(*fd_out, 0)) {
-		printk("winch_tramp: failed to set thread_fd non-blocking.\n");
+		printk(UM_KERN_ERR "winch_tramp: failed to set thread_fd "
+		       "non-blocking.\n");
 		goto out_close;
 	}
 
@@ -246,7 +251,7 @@ void register_winch(int fd, struct tty_s
 	int pid, thread, count, thread_fd = -1;
 	char c = 1;
 
-	if(!isatty(fd))
+	if (!isatty(fd))
 		return;
 
 	pid = tcgetpgrp(fd);
@@ -259,8 +264,8 @@ void register_winch(int fd, struct tty_s
 		register_winch_irq(thread_fd, fd, thread, tty, stack);
 
 		count = os_write_file(thread_fd, &c, sizeof(c));
-		if(count != sizeof(c))
-			printk("register_winch : failed to write "
+		if (count != sizeof(c))
+			printk(UM_KERN_ERR "register_winch : failed to write "
 			       "synchronization byte, err = %d\n", -count);
 	}
 }
diff -puN arch/um/drivers/fd.c~uml-console-subsystem-tidying arch/um/drivers/fd.c
--- a/arch/um/drivers/fd.c~uml-console-subsystem-tidying
+++ a/arch/um/drivers/fd.c
@@ -1,17 +1,19 @@
 /* 
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
-#include <stdio.h>
+#include <stddef.h>
 #include <stdlib.h>
-#include <unistd.h>
-#include <termios.h>
+#include <stdio.h>
 #include <errno.h>
-#include "user.h"
+#include <termios.h>
+#include <unistd.h>
 #include "chan_user.h"
-#include "os.h"
 #include "um_malloc.h"
+#include "user.h"
+#include "os.h"
+#include "kern_constants.h"
 
 struct fd_chan {
 	int fd;
@@ -26,22 +28,26 @@ static void *fd_init(char *str, int devi
 	char *end;
 	int n;
 
-	if(*str != ':'){
-		printk("fd_init : channel type 'fd' must specify a file "
-		       "descriptor\n");
-		return(NULL);
+	if (*str != ':') {
+		printk(UM_KERN_ERR "fd_init : channel type 'fd' must specify a "
+		       "file descriptor\n");
+		return NULL;
 	}
 	str++;
 	n = strtoul(str, &end, 0);
-	if((*end != '\0') || (end == str)){
-		printk("fd_init : couldn't parse file descriptor '%s'\n", str);
-		return(NULL);
+	if ((*end != '\0') || (end == str)) {
+		printk(UM_KERN_ERR "fd_init : couldn't parse file descriptor "
+		       "'%s'\n", str);
+		return NULL;
 	}
+
 	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
-	if(data == NULL) return(NULL);
+	if(data == NULL)
+		return NULL;
+
 	*data = ((struct fd_chan) { .fd  	= n,
 				    .raw  	= opts->raw });
-	return(data);
+	return data;
 }
 
 static int fd_open(int input, int output, int primary, void *d, char **dev_out)
@@ -49,18 +55,18 @@ static int fd_open(int input, int output
 	struct fd_chan *data = d;
 	int err;
 
-	if(data->raw && isatty(data->fd)){
+	if (data->raw && isatty(data->fd)) {
 		CATCH_EINTR(err = tcgetattr(data->fd, &data->tt));
-		if(err)
-			return(err);
+		if (err)
+			return err;
 
 		err = raw(data->fd);
-		if(err)
-			return(err);
+		if (err)
+			return err;
 	}
 	sprintf(data->str, "%d", data->fd);
 	*dev_out = data->str;
-	return(data->fd);
+	return data->fd;
 }
 
 static void fd_close(int fd, void *d)
@@ -68,13 +74,14 @@ static void fd_close(int fd, void *d)
 	struct fd_chan *data = d;
 	int err;
 
-	if(data->raw && isatty(fd)){
-		CATCH_EINTR(err = tcsetattr(fd, TCSAFLUSH, &data->tt));
-		if(err)
-			printk("Failed to restore terminal state - "
-			       "errno = %d\n", -err);
-		data->raw = 0;
-	}
+	if (!data->raw || !isatty(fd))
+		return;
+
+	CATCH_EINTR(err = tcsetattr(fd, TCSAFLUSH, &data->tt));
+	if (err)
+		printk(UM_KERN_ERR "Failed to restore terminal state - "
+		       "errno = %d\n", -err);
+	data->raw = 0;
 }
 
 const struct chan_ops fd_ops = {
@@ -89,14 +96,3 @@ const struct chan_ops fd_ops = {
 	.free		= generic_free,
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
diff -puN arch/um/drivers/null.c~uml-console-subsystem-tidying arch/um/drivers/null.c
--- a/arch/um/drivers/null.c~uml-console-subsystem-tidying
+++ a/arch/um/drivers/null.c
@@ -1,31 +1,36 @@
 /* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
-#include <stdlib.h>
+#include <stddef.h>
 #include <errno.h>
-#include "chan_user.h"
+#include <fcntl.h>
 #include "os.h"
+#include "chan_user.h"
 
 /* This address is used only as a unique identifer */
 static int null_chan;
 
 static void *null_init(char *str, int device, const struct chan_opts *opts)
 {
-	return(&null_chan);
+	return &null_chan;
 }
 
 static int null_open(int input, int output, int primary, void *d,
 		     char **dev_out)
 {
+	int fd;
+
 	*dev_out = NULL;
-	return(os_open_file(DEV_NULL, of_rdwr(OPENFLAGS()), 0));
+
+	fd = open(DEV_NULL, O_RDWR);
+	return (fd < 0) ? -errno : fd;
 }
 
 static int null_read(int fd, char *c_out, void *unused)
 {
-	return(-ENODEV);
+	return -ENODEV;
 }
 
 static void null_free(void *data)
@@ -44,14 +49,3 @@ const struct chan_ops null_ops = {
 	.free		= null_free,
 	.winch		= 0,
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
diff -puN arch/um/drivers/port_kern.c~uml-console-subsystem-tidying arch/um/drivers/port_kern.c
--- a/arch/um/drivers/port_kern.c~uml-console-subsystem-tidying
+++ a/arch/um/drivers/port_kern.c
@@ -1,24 +1,16 @@
 /*
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
-#include "linux/list.h"
-#include "linux/sched.h"
-#include "linux/slab.h"
+#include "linux/completion.h"
 #include "linux/interrupt.h"
-#include "linux/spinlock.h"
-#include "linux/errno.h"
+#include "linux/list.h"
 #include "asm/atomic.h"
-#include "asm/semaphore.h"
-#include "asm/errno.h"
-#include "kern_util.h"
-#include "kern.h"
-#include "irq_user.h"
-#include "irq_kern.h"
-#include "port.h"
 #include "init.h"
+#include "irq_kern.h"
 #include "os.h"
+#include "port.h"
 
 struct port_list {
 	struct list_head list;
@@ -53,8 +45,8 @@ static irqreturn_t pipe_interrupt(int ir
 	int fd;
 
 	fd = os_rcv_fd(conn->socket[0], &conn->helper_pid);
-	if(fd < 0){
-		if(fd == -EAGAIN)
+	if (fd < 0) {
+		if (fd == -EAGAIN)
 			return IRQ_NONE;
 
 		printk(KERN_ERR "pipe_interrupt : os_rcv_fd returned %d\n",
@@ -81,18 +73,18 @@ static irqreturn_t pipe_interrupt(int ir
 static int port_accept(struct port_list *port)
 {
 	struct connection *conn;
-	int fd, socket[2], pid, ret = 0;
+	int fd, socket[2], pid;
 
 	fd = port_connection(port->fd, socket, &pid);
-	if(fd < 0){
-		if(fd != -EAGAIN)
+	if (fd < 0) {
+		if (fd != -EAGAIN)
 			printk(KERN_ERR "port_accept : port_connection "
 			       "returned %d\n", -fd);
 		goto out;
 	}
 
 	conn = kmalloc(sizeof(*conn), GFP_ATOMIC);
-	if(conn == NULL){
+	if (conn == NULL) {
 		printk(KERN_ERR "port_accept : failed to allocate "
 		       "connection\n");
 		goto out_close;
@@ -104,17 +96,17 @@ static int port_accept(struct port_list 
 		  .telnetd_pid 	= pid,
 		  .port 	= port });
 
-	if(um_request_irq(TELNETD_IRQ, socket[0], IRQ_READ, pipe_interrupt,
+	if (um_request_irq(TELNETD_IRQ, socket[0], IRQ_READ, pipe_interrupt,
 			  IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			  "telnetd", conn)){
+			  "telnetd", conn)) {
 		printk(KERN_ERR "port_accept : failed to get IRQ for "
 		       "telnetd\n");
 		goto out_free;
 	}
 
-	if(atomic_read(&port->wait_count) == 0){
+	if (atomic_read(&port->wait_count) == 0) {
 		os_write_file(fd, NO_WAITER_MSG, sizeof(NO_WAITER_MSG));
-		printk("No one waiting for port\n");
+		printk(KERN_ERR "No one waiting for port\n");
 	}
 	list_add(&conn->list, &port->pending);
 	return 1;
@@ -123,28 +115,29 @@ static int port_accept(struct port_list 
 	kfree(conn);
  out_close:
 	os_close_file(fd);
-	if(pid != -1)
-		os_kill_process(pid, 1);
+	os_kill_process(pid, 1);
  out:
-	return ret;
+	return 0;
 }
 
 static DECLARE_MUTEX(ports_sem);
 static LIST_HEAD(ports);
 
-void port_work_proc(struct work_struct *unused)
+static void port_work_proc(struct work_struct *unused)
 {
 	struct port_list *port;
 	struct list_head *ele;
 	unsigned long flags;
 
 	local_irq_save(flags);
-	list_for_each(ele, &ports){
+	list_for_each(ele, &ports) {
 		port = list_entry(ele, struct port_list, list);
-		if(!port->has_connection)
+		if (!port->has_connection)
 			continue;
+
 		reactivate_fd(port->fd, ACCEPT_IRQ);
-		while(port_accept(port)) ;
+		while (port_accept(port))
+			;
 		port->has_connection = 0;
 	}
 	local_irq_restore(flags);
@@ -169,25 +162,27 @@ void *port_data(int port_num)
 	int fd;
 
 	down(&ports_sem);
-	list_for_each(ele, &ports){
+	list_for_each(ele, &ports) {
 		port = list_entry(ele, struct port_list, list);
-		if(port->port == port_num) goto found;
+		if (port->port == port_num)
+			goto found;
 	}
 	port = kmalloc(sizeof(struct port_list), GFP_KERNEL);
-	if(port == NULL){
+	if (port == NULL) {
 		printk(KERN_ERR "Allocation of port list failed\n");
 		goto out;
 	}
 
 	fd = port_listen_fd(port_num);
-	if(fd < 0){
+	if (fd < 0) {
 		printk(KERN_ERR "binding to port %d failed, errno = %d\n",
 		       port_num, -fd);
 		goto out_free;
 	}
-	if(um_request_irq(ACCEPT_IRQ, fd, IRQ_READ, port_interrupt,
+
+	if (um_request_irq(ACCEPT_IRQ, fd, IRQ_READ, port_interrupt,
 			  IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			  "port", port)){
+			  "port", port)) {
 		printk(KERN_ERR "Failed to get IRQ for port %d\n", port_num);
 		goto out_close;
 	}
@@ -206,7 +201,7 @@ void *port_data(int port_num)
 
  found:
 	dev = kmalloc(sizeof(struct port_dev), GFP_KERNEL);
-	if(dev == NULL){
+	if (dev == NULL) {
 		printk(KERN_ERR "Allocation of port device entry failed\n");
 		goto out;
 	}
@@ -233,9 +228,9 @@ int port_wait(void *data)
 	int fd;
 
 	atomic_inc(&port->wait_count);
-	while(1){
+	while (1) {
 		fd = -ERESTARTSYS;
-		if(wait_for_completion_interruptible(&port->done))
+		if (wait_for_completion_interruptible(&port->done))
 			goto out;
 
 		spin_lock(&port->lock);
@@ -258,7 +253,8 @@ int port_wait(void *data)
 		 */
 		free_irq(TELNETD_IRQ, conn);
 
-		if(conn->fd >= 0) break;
+		if (conn->fd >= 0)
+			break;
 		os_close_file(conn->fd);
 		kfree(conn);
 	}
@@ -276,9 +272,9 @@ void port_remove_dev(void *d)
 {
 	struct port_dev *dev = d;
 
-	if(dev->helper_pid != -1)
+	if (dev->helper_pid != -1)
 		os_kill_process(dev->helper_pid, 0);
-	if(dev->telnetd_pid != -1)
+	if (dev->telnetd_pid != -1)
 		os_kill_process(dev->telnetd_pid, 1);
 	dev->helper_pid = -1;
 	dev->telnetd_pid = -1;
@@ -297,7 +293,7 @@ static void free_port(void)
 	struct list_head *ele;
 	struct port_list *port;
 
-	list_for_each(ele, &ports){
+	list_for_each(ele, &ports) {
 		port = list_entry(ele, struct port_list, list);
 		free_irq_by_fd(port->fd);
 		os_close_file(port->fd);
diff -puN arch/um/drivers/port_user.c~uml-console-subsystem-tidying arch/um/drivers/port_user.c
--- a/arch/um/drivers/port_user.c~uml-console-subsystem-tidying
+++ a/arch/um/drivers/port_user.c
@@ -1,24 +1,20 @@
 /*
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
 #include <stdio.h>
-#include <stddef.h>
 #include <stdlib.h>
-#include <string.h>
 #include <errno.h>
-#include <unistd.h>
 #include <termios.h>
-#include <sys/socket.h>
-#include <sys/un.h>
+#include <unistd.h>
 #include <netinet/in.h>
-#include "kern_util.h"
-#include "user.h"
 #include "chan_user.h"
-#include "port.h"
+#include "kern_constants.h"
 #include "os.h"
+#include "port.h"
 #include "um_malloc.h"
+#include "user.h"
 
 struct port_chan {
 	int raw;
@@ -34,24 +30,25 @@ static void *port_init(char *str, int de
 	char *end;
 	int port;
 
-	if(*str != ':'){
-		printk("port_init : channel type 'port' must specify a "
-		       "port number\n");
+	if (*str != ':') {
+		printk(UM_KERN_ERR "port_init : channel type 'port' must "
+		       "specify a port number\n");
 		return NULL;
 	}
 	str++;
 	port = strtoul(str, &end, 0);
-	if((*end != '\0') || (end == str)){
-		printk("port_init : couldn't parse port '%s'\n", str);
+	if ((*end != '\0') || (end == str)) {
+		printk(UM_KERN_ERR "port_init : couldn't parse port '%s'\n",
+		       str);
 		return NULL;
 	}
 
 	kern_data = port_data(port);
-	if(kern_data == NULL)
+	if (kern_data == NULL)
 		return NULL;
 
 	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
-	if(data == NULL)
+	if (data == NULL)
 		goto err;
 
 	*data = ((struct port_chan) { .raw  		= opts->raw,
@@ -79,13 +76,13 @@ static int port_open(int input, int outp
 	int fd, err;
 
 	fd = port_wait(data->kernel_data);
-	if((fd >= 0) && data->raw){
+	if ((fd >= 0) && data->raw) {
 		CATCH_EINTR(err = tcgetattr(fd, &data->tt));
-		if(err)
+		if (err)
 			return err;
 
 		err = raw(fd);
-		if(err)
+		if (err)
 			return err;
 	}
 	*dev_out = data->dev;
@@ -119,11 +116,11 @@ int port_listen_fd(int port)
 	int fd, err, arg;
 
 	fd = socket(PF_INET, SOCK_STREAM, 0);
-	if(fd == -1)
+	if (fd == -1)
 		return -errno;
 
 	arg = 1;
-	if(setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &arg, sizeof(arg)) < 0){
+	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &arg, sizeof(arg)) < 0) {
 		err = -errno;
 		goto out;
 	}
@@ -131,23 +128,23 @@ int port_listen_fd(int port)
 	addr.sin_family = AF_INET;
 	addr.sin_port = htons(port);
 	addr.sin_addr.s_addr = htonl(INADDR_ANY);
-	if(bind(fd, (struct sockaddr *) &addr, sizeof(addr)) < 0){
+	if (bind(fd, (struct sockaddr *) &addr, sizeof(addr)) < 0) {
 		err = -errno;
 		goto out;
 	}
 
-	if(listen(fd, 1) < 0){
+	if (listen(fd, 1) < 0) {
 		err = -errno;
 		goto out;
 	}
 
 	err = os_set_fd_block(fd, 0);
-	if(err < 0)
+	if (err < 0)
 		goto out;
 
 	return fd;
  out:
-	os_close_file(fd);
+	close(fd);
 	return err;
 }
 
@@ -163,10 +160,10 @@ void port_pre_exec(void *arg)
 	dup2(data->sock_fd, 0);
 	dup2(data->sock_fd, 1);
 	dup2(data->sock_fd, 2);
-	os_close_file(data->sock_fd);
+	close(data->sock_fd);
 	dup2(data->pipe_fd, 3);
-	os_shutdown_socket(3, 1, 0);
-	os_close_file(data->pipe_fd);
+	shutdown(3, SHUT_RD);
+	close(data->pipe_fd);
 }
 
 int port_connection(int fd, int *socket, int *pid_out)
@@ -176,12 +173,12 @@ int port_connection(int fd, int *socket,
 			 "/usr/lib/uml/port-helper", NULL };
 	struct port_pre_exec_data data;
 
-	new = os_accept_connection(fd);
-	if(new < 0)
-		return new;
+	new = accept(fd, NULL, 0);
+	if (new < 0)
+		return -errno;
 
 	err = os_pipe(socket, 0, 0);
-	if(err < 0)
+	if (err < 0)
 		goto out_close;
 
 	data = ((struct port_pre_exec_data)
@@ -189,18 +186,18 @@ int port_connection(int fd, int *socket,
 		  .pipe_fd 		= socket[1] });
 
 	err = run_helper(port_pre_exec, &data, argv);
-	if(err < 0)
+	if (err < 0)
 		goto out_shutdown;
 
 	*pid_out = err;
 	return new;
 
  out_shutdown:
-	os_shutdown_socket(socket[0], 1, 1);
-	os_close_file(socket[0]);
-	os_shutdown_socket(socket[1], 1, 1);
-	os_close_file(socket[1]);
+	shutdown(socket[0], SHUT_RDWR);
+	close(socket[0]);
+	shutdown(socket[1], SHUT_RDWR);
+	close(socket[1]);
  out_close:
-	os_close_file(new);
+	close(new);
 	return err;
 }
diff -puN arch/um/drivers/pty.c~uml-console-subsystem-tidying arch/um/drivers/pty.c
--- a/arch/um/drivers/pty.c~uml-console-subsystem-tidying
+++ a/arch/um/drivers/pty.c
@@ -56,11 +56,11 @@ static int pts_open(int input, int outpu
 	if (data->raw) {
 		CATCH_EINTR(err = tcgetattr(fd, &data->tt));
 		if (err)
-			return err;
+			goto out_close;
 
 		err = raw(fd);
 		if (err)
-			return err;
+			goto out_close;
 	}
 
 	dev = ptsname(fd);
@@ -71,6 +71,10 @@ static int pts_open(int input, int outpu
 		(*data->announce)(dev, data->dev);
 
 	return fd;
+
+out_close:
+	close(fd);
+	return err;
 }
 
 static int getmaster(char *line)
@@ -119,10 +123,12 @@ static int pty_open(int input, int outpu
 	if (fd < 0)
 		return fd;
 
-	if(data->raw){
+	if (data->raw) {
 		err = raw(fd);
-		if (err)
+		if (err) {
+			close(fd);
 			return err;
+		}
 	}
 	
 	if (data->announce)
diff -puN arch/um/drivers/tty.c~uml-console-subsystem-tidying arch/um/drivers/tty.c
--- a/arch/um/drivers/tty.c~uml-console-subsystem-tidying
+++ a/arch/um/drivers/tty.c
@@ -1,16 +1,16 @@
 /*
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{linux.intel,addtoit}.com)
  * Licensed under the GPL
  */
 
-#include <stdio.h>
-#include <termios.h>
 #include <errno.h>
-#include <unistd.h>
+#include <fcntl.h>
+#include <termios.h>
 #include "chan_user.h"
-#include "user.h"
+#include "kern_constants.h"
 #include "os.h"
 #include "um_malloc.h"
+#include "user.h"
 
 struct tty_chan {
 	char *dev;
@@ -22,15 +22,15 @@ static void *tty_chan_init(char *str, in
 {
 	struct tty_chan *data;
 
-	if(*str != ':'){
-		printk("tty_init : channel type 'tty' must specify "
+	if (*str != ':') {
+		printk(UM_KERN_ERR "tty_init : channel type 'tty' must specify "
 		       "a device\n");
 		return NULL;
 	}
 	str++;
 
 	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
-	if(data == NULL)
+	if (data == NULL)
 		return NULL;
 	*data = ((struct tty_chan) { .dev 	= str,
 				     .raw 	= opts->raw });
@@ -42,19 +42,26 @@ static int tty_open(int input, int outpu
 		    char **dev_out)
 {
 	struct tty_chan *data = d;
-	int fd, err;
+	int fd, err, mode = 0;
 
-	fd = os_open_file(data->dev, of_set_rw(OPENFLAGS(), input, output), 0);
-	if(fd < 0)
-		return fd;
+	if (input && output)
+		mode = O_RDWR;
+	else if (input)
+		mode = O_RDONLY;
+	else if (output)
+		mode = O_WRONLY;
+
+	fd = open(data->dev, mode);
+	if (fd < 0)
+		return -errno;
 
-	if(data->raw){
+	if (data->raw) {
 		CATCH_EINTR(err = tcgetattr(fd, &data->tt));
-		if(err)
+		if (err)
 			return err;
 
 		err = raw(fd);
-		if(err)
+		if (err)
 			return err;
 	}
 
diff -puN arch/um/drivers/xterm.c~uml-console-subsystem-tidying arch/um/drivers/xterm.c
--- a/arch/um/drivers/xterm.c~uml-console-subsystem-tidying
+++ a/arch/um/drivers/xterm.c
@@ -3,18 +3,19 @@
  * Licensed under the GPL
  */
 
+#include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
-#include <string.h>
 #include <errno.h>
+#include <string.h>
 #include <termios.h>
 #include "chan_user.h"
+#include "kern_constants.h"
 #include "os.h"
-#include "init.h"
+#include "um_malloc.h"
 #include "user.h"
 #include "xterm.h"
-#include "kern_constants.h"
 
 struct xterm_chan {
 	int pid;
@@ -29,7 +30,7 @@ static void *xterm_init(char *str, int d
 {
 	struct xterm_chan *data;
 
-	data = malloc(sizeof(*data));
+	data = kmalloc(sizeof(*data), UM_GFP_KERNEL);
 	if (data == NULL)
 		return NULL;
 	*data = ((struct xterm_chan) { .pid 		= -1,
@@ -207,11 +208,6 @@ static void xterm_close(int fd, void *d)
 	os_close_file(fd);
 }
 
-static void xterm_free(void *d)
-{
-	free(d);
-}
-
 const struct chan_ops xterm_ops = {
 	.type		= "xterm",
 	.init		= xterm_init,
@@ -221,6 +217,6 @@ const struct chan_ops xterm_ops = {
 	.write		= generic_write,
 	.console_write	= generic_console_write,
 	.window_size	= generic_window_size,
-	.free		= xterm_free,
+	.free		= generic_free,
 	.winch		= 1,
 };
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-console-should-handle-spurious-irqs.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
