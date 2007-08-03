From: akpm@linux-foundation.org
Subject: + uml-console-tidying.patch added to -mm tree
Date: Fri, 03 Aug 2007 10:31:39 -0700
Message-ID: <200708031731.l73HVdrA019520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508AbXHCRb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 13:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: console tidying
has been added to the -mm tree.  Its filename is
     uml-console-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: console tidying
From: Jeff Dike <jdike@addtoit.com>

Tidy line.c:
	The includes are more minimal
	Lots of style fixes
	All the printks have severities
	Removed some commented-out code
	Deleted a useless printk when ioctl is called
	Fixed some whitespace damage

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |  228 +++++++++++++++++++--------------------
 1 files changed, 114 insertions(+), 114 deletions(-)

diff -puN arch/um/drivers/line.c~uml-console-tidying arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-console-tidying
+++ a/arch/um/drivers/line.c
@@ -1,22 +1,14 @@
 /*
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/kernel.h"
-#include "linux/sched.h"
-#include "linux/slab.h"
-#include "linux/list.h"
+#include "linux/irqreturn.h"
 #include "linux/kd.h"
-#include "linux/interrupt.h"
-#include "asm/uaccess.h"
 #include "chan_kern.h"
+#include "irq_kern.h"
 #include "irq_user.h"
-#include "line.h"
-#include "kern.h"
-#include "kern_util.h"
 #include "os.h"
-#include "irq_kern.h"
 
 #define LINE_BUFSIZE 4096
 
@@ -35,12 +27,13 @@ static void line_timer_cb(struct work_st
 {
 	struct line *line = container_of(work, struct line, task.work);
 
-	if(!line->throttled)
+	if (!line->throttled)
 		chan_interrupt(&line->chan_list, &line->task, line->tty,
 			       line->driver->read_irq);
 }
 
-/* Returns the free space inside the ring buffer of this line.
+/*
+ * Returns the free space inside the ring buffer of this line.
  *
  * Should be called while holding line->lock (this does not modify datas).
  */
@@ -107,11 +100,12 @@ static int buffer_data(struct line *line
 {
 	int end, room;
 
-	if(line->buffer == NULL){
+	if (line->buffer == NULL) {
 		line->buffer = kmalloc(LINE_BUFSIZE, GFP_ATOMIC);
 		if (line->buffer == NULL) {
-			printk("buffer_data - atomic allocation failed\n");
-			return(0);
+			printk(KERN_ERR "buffer_data - atomic allocation "
+			       "failed\n");
+			return 0;
 		}
 		line->head = line->buffer;
 		line->tail = line->buffer;
@@ -122,7 +116,7 @@ static int buffer_data(struct line *line
 
 	end = line->buffer + LINE_BUFSIZE - line->tail;
 
-	if (len < end){
+	if (len < end) {
 		memcpy(line->tail, buf, len);
 		line->tail += len;
 	}
@@ -162,8 +156,10 @@ static int flush_buffer(struct line *lin
 		if (n < 0)
 			return n;
 		if (n == count) {
-			/* We have flushed from ->head to buffer end, now we
-			 * must flush only from the beginning to ->tail.*/
+			/*
+			 * We have flushed from ->head to buffer end, now we
+			 * must flush only from the beginning to ->tail.
+			 */
 			line->head = line->buffer;
 		} else {
 			line->head += n;
@@ -175,7 +171,7 @@ static int flush_buffer(struct line *lin
 	n = write_chan(&line->chan_list, line->head, count,
 		       line->driver->write_irq);
 
-	if(n < 0)
+	if (n < 0)
 		return n;
 
 	line->head += n;
@@ -189,19 +185,18 @@ void line_flush_buffer(struct tty_struct
 	int err;
 
 	/*XXX: copied from line_write, verify if it is correct!*/
-	if(tty->stopped)
+	if (tty->stopped)
 		return;
 
 	spin_lock_irqsave(&line->lock, flags);
 	err = flush_buffer(line);
-	/*if (err == 1)
-		err = 0;*/
 	spin_unlock_irqrestore(&line->lock, flags);
-	//return err;
 }
 
-/* We map both ->flush_chars and ->put_char (which go in pair) onto ->flush_buffer
- * and ->write. Hope it's not that bad.*/
+/*
+ * We map both ->flush_chars and ->put_char (which go in pair) onto
+ * ->flush_buffer and ->write. Hope it's not that bad.
+ */
 void line_flush_chars(struct tty_struct *tty)
 {
 	line_flush_buffer(tty);
@@ -218,7 +213,7 @@ int line_write(struct tty_struct *tty, c
 	unsigned long flags;
 	int n, ret = 0;
 
-	if(tty->stopped)
+	if (tty->stopped)
 		return 0;
 
 	spin_lock_irqsave(&line->lock, flags);
@@ -254,17 +249,17 @@ static const struct {
 } tty_ioctls[] = {
 	/* don't print these, they flood the log ... */
 	{ TCGETS,      NULL,       "TCGETS"      },
-        { TCSETS,      NULL,       "TCSETS"      },
-        { TCSETSW,     NULL,       "TCSETSW"     },
-        { TCFLSH,      NULL,       "TCFLSH"      },
-        { TCSBRK,      NULL,       "TCSBRK"      },
+	{ TCSETS,      NULL,       "TCSETS"      },
+	{ TCSETSW,     NULL,       "TCSETSW"     },
+	{ TCFLSH,      NULL,       "TCFLSH"      },
+	{ TCSBRK,      NULL,       "TCSBRK"      },
 
 	/* general tty stuff */
-        { TCSETSF,     KERN_DEBUG, "TCSETSF"     },
-        { TCGETA,      KERN_DEBUG, "TCGETA"      },
-        { TIOCMGET,    KERN_DEBUG, "TIOCMGET"    },
-        { TCSBRKP,     KERN_DEBUG, "TCSBRKP"     },
-        { TIOCMSET,    KERN_DEBUG, "TIOCMSET"    },
+	{ TCSETSF,     KERN_DEBUG, "TCSETSF"     },
+	{ TCGETA,      KERN_DEBUG, "TCGETA"      },
+	{ TIOCMGET,    KERN_DEBUG, "TIOCMGET"    },
+	{ TCSBRKP,     KERN_DEBUG, "TCSBRKP"     },
+	{ TIOCMSET,    KERN_DEBUG, "TIOCMSET"    },
 
 	/* linux-specific ones */
 	{ TIOCLINUX,   KERN_INFO,  "TIOCLINUX"   },
@@ -321,12 +316,7 @@ int line_ioctl(struct tty_struct *tty, s
 		for (i = 0; i < ARRAY_SIZE(tty_ioctls); i++)
 			if (cmd == tty_ioctls[i].cmd)
 				break;
-		if (i < ARRAY_SIZE(tty_ioctls)) {
-			if (NULL != tty_ioctls[i].level)
-				printk("%s%s: %s: ioctl %s called\n",
-				       tty_ioctls[i].level, __FUNCTION__,
-				       tty->name, tty_ioctls[i].name);
-		} else {
+		if (i == ARRAY_SIZE(tty_ioctls)) {
 			printk(KERN_ERR "%s: %s: unknown ioctl: 0x%x\n",
 			       __FUNCTION__, tty->name, cmd);
 		}
@@ -352,11 +342,12 @@ void line_unthrottle(struct tty_struct *
 	chan_interrupt(&line->chan_list, &line->task, tty,
 		       line->driver->read_irq);
 
-	/* Maybe there is enough stuff pending that calling the interrupt
+	/*
+	 * Maybe there is enough stuff pending that calling the interrupt
 	 * throttles us again.  In this case, line->throttled will be 1
 	 * again and we shouldn't turn the interrupt back on.
 	 */
-	if(!line->throttled)
+	if (!line->throttled)
 		reactivate_chan(&line->chan_list, line->driver->read_irq);
 }
 
@@ -367,27 +358,30 @@ static irqreturn_t line_write_interrupt(
 	struct tty_struct *tty = line->tty;
 	int err;
 
-	/* Interrupts are disabled here because we registered the interrupt with
-	 * IRQF_DISABLED (see line_setup_irq).*/
+	/*
+	 * Interrupts are disabled here because we registered the interrupt with
+	 * IRQF_DISABLED (see line_setup_irq).
+	 */
 
 	spin_lock(&line->lock);
 	err = flush_buffer(line);
 	if (err == 0) {
 		return IRQ_NONE;
-	} else if(err < 0) {
+	} else if (err < 0) {
 		line->head = line->buffer;
 		line->tail = line->buffer;
 	}
 	spin_unlock(&line->lock);
 
-	if(tty == NULL)
+	if (tty == NULL)
 		return IRQ_NONE;
 
 	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) &&
 	   (tty->ldisc.write_wakeup != NULL))
 		(tty->ldisc.write_wakeup)(tty);
 
-	/* BLOCKING mode
+	/*
+	 * BLOCKING mode
 	 * In blocking mode, everything sleeps on tty->write_wait.
 	 * Sleeping in the console driver would break non-blocking
 	 * writes.
@@ -417,7 +411,8 @@ int line_setup_irq(int fd, int input, in
 	return err;
 }
 
-/* Normally, a driver like this can rely mostly on the tty layer
+/*
+ * Normally, a driver like this can rely mostly on the tty layer
  * locking, particularly when it comes to the driver structure.
  * However, in this case, mconsole requests can come in "from the
  * side", and race with opens and closes.
@@ -439,11 +434,11 @@ int line_open(struct line *lines, struct
 	int err = -ENODEV;
 
 	spin_lock(&line->count_lock);
-	if(!line->valid)
+	if (!line->valid)
 		goto out_unlock;
 
 	err = 0;
-	if(tty->count > 1)
+	if (tty->count > 1)
 		goto out_unlock;
 
 	spin_unlock(&line->count_lock);
@@ -457,7 +452,7 @@ int line_open(struct line *lines, struct
 
 	INIT_DELAYED_WORK(&line->task, line_timer_cb);
 
-	if(!line->sigio){
+	if (!line->sigio) {
 		chan_enable_winch(&line->chan_list, tty);
 		line->sigio = 1;
 	}
@@ -478,20 +473,21 @@ void line_close(struct tty_struct *tty, 
 {
 	struct line *line = tty->driver_data;
 
-	/* If line_open fails (and tty->driver_data is never set),
+	/*
+	 * If line_open fails (and tty->driver_data is never set),
 	 * tty_open will call line_close.  So just return in this case.
 	 */
-	if(line == NULL)
+	if (line == NULL)
 		return;
 
 	/* We ignore the error anyway! */
 	flush_buffer(line);
 
 	spin_lock(&line->count_lock);
-	if(!line->valid)
+	if (!line->valid)
 		goto out_unlock;
 
-	if(tty->count > 1)
+	if (tty->count > 1)
 		goto out_unlock;
 
 	spin_unlock(&line->count_lock);
@@ -499,10 +495,10 @@ void line_close(struct tty_struct *tty, 
 	line->tty = NULL;
 	tty->driver_data = NULL;
 
-	if(line->sigio){
+	if (line->sigio) {
 		unregister_winch(tty);
 		line->sigio = 0;
-        }
+	}
 
 	return;
 
@@ -526,12 +522,12 @@ static int setup_one_line(struct line *l
 
 	spin_lock(&line->count_lock);
 
-	if(line->tty != NULL){
+	if (line->tty != NULL) {
 		*error_out = "Device is already open";
 		goto out;
 	}
 
-	if (line->init_pri <= init_prio){
+	if (line->init_pri <= init_prio) {
 		line->init_pri = init_prio;
 		if (!strcmp(init, "none"))
 			line->valid = 0;
@@ -546,7 +542,8 @@ out:
 	return err;
 }
 
-/* Common setup code for both startup command line and mconsole initialization.
+/*
+ * Common setup code for both startup command line and mconsole initialization.
  * @lines contains the array (of size @num) to modify;
  * @init is the setup string;
  * @error_out is an error string in the case of failure;
@@ -558,14 +555,16 @@ int line_setup(struct line *lines, unsig
 	int i, n, err;
 	char *end;
 
-	if(*init == '=') {
-		/* We said con=/ssl= instead of con#=, so we are configuring all
-		 * consoles at once.*/
+	if (*init == '=') {
+		/*
+		 * We said con=/ssl= instead of con#=, so we are configuring all
+		 * consoles at once.
+		 */
 		n = -1;
 	}
 	else {
 		n = simple_strtoul(init, &end, 0);
-		if(*end != '='){
+		if (*end != '=') {
 			*error_out = "Couldn't parse device number";
 			return -EINVAL;
 		}
@@ -577,16 +576,16 @@ int line_setup(struct line *lines, unsig
 		*error_out = "Device number out of range";
 		return -EINVAL;
 	}
-	else if (n >= 0){
+	else if (n >= 0) {
 		err = setup_one_line(lines, n, init, INIT_ONE, error_out);
-		if(err)
+		if (err)
 			return err;
 	}
 	else {
-		for(i = 0; i < num; i++){
+		for(i = 0; i < num; i++) {
 			err = setup_one_line(lines, i, init, INIT_ALL,
 					     error_out);
-			if(err)
+			if (err)
 				return err;
 		}
 	}
@@ -600,18 +599,18 @@ int line_config(struct line *lines, unsi
 	char *new;
 	int n;
 
-	if(*str == '='){
+	if (*str == '=') {
 		*error_out = "Can't configure all devices from mconsole";
 		return -EINVAL;
 	}
 
 	new = kstrdup(str, GFP_KERNEL);
-	if(new == NULL){
+	if (new == NULL) {
 		*error_out = "Failed to allocate memory";
 		return -ENOMEM;
 	}
 	n = line_setup(lines, num, new, error_out);
-	if(n < 0)
+	if (n < 0)
 		return n;
 
 	line = &lines[n];
@@ -626,12 +625,12 @@ int line_get_config(char *name, struct l
 	int dev, n = 0;
 
 	dev = simple_strtoul(name, &end, 0);
-	if((*end != '\0') || (end == name)){
+	if ((*end != '\0') || (end == name)) {
 		*error_out = "line_get_config failed to parse device number";
 		return 0;
 	}
 
-	if((dev < 0) || (dev >= num)){
+	if ((dev < 0) || (dev >= num)) {
 		*error_out = "device number out of range";
 		return 0;
 	}
@@ -639,9 +638,9 @@ int line_get_config(char *name, struct l
 	line = &lines[dev];
 
 	spin_lock(&line->count_lock);
-	if(!line->valid)
+	if (!line->valid)
 		CONFIG_CHUNK(str, size, n, "none", 1);
-	else if(line->tty == NULL)
+	else if (line->tty == NULL)
 		CONFIG_CHUNK(str, size, n, line->init_str, 1);
 	else n = chan_config_string(&line->chan_list, str, size, error_out);
 	spin_unlock(&line->count_lock);
@@ -652,16 +651,16 @@ int line_get_config(char *name, struct l
 int line_id(char **str, int *start_out, int *end_out)
 {
 	char *end;
-        int n;
+	int n;
 
 	n = simple_strtoul(*str, &end, 0);
-	if((*end != '\0') || (end == *str))
-                return -1;
+	if ((*end != '\0') || (end == *str))
+		return -1;
 
-        *str = end;
-        *start_out = n;
-        *end_out = n;
-        return n;
+	*str = end;
+	*start_out = n;
+	*end_out = n;
+	return n;
 }
 
 int line_remove(struct line *lines, unsigned int num, int n, char **error_out)
@@ -671,7 +670,7 @@ int line_remove(struct line *lines, unsi
 
 	sprintf(config, "%d=none", n);
 	err = line_setup(lines, num, config, error_out);
-	if(err >= 0)
+	if (err >= 0)
 		err = 0;
 	return err;
 }
@@ -697,14 +696,14 @@ struct tty_driver *register_lines(struct
 	tty_set_operations(driver, ops);
 
 	if (tty_register_driver(driver)) {
-		printk("%s: can't register %s driver\n",
-		       __FUNCTION__,line_driver->name);
+		printk(KERN_ERR "register_lines : can't register %s driver\n",
+		       line_driver->name);
 		put_tty_driver(driver);
 		return NULL;
 	}
 
-	for(i = 0; i < nlines; i++){
-		if(!lines[i].valid)
+	for(i = 0; i < nlines; i++) {
+		if (!lines[i].valid)
 			tty_unregister_device(driver, i);
 	}
 
@@ -721,20 +720,20 @@ void lines_init(struct line *lines, int 
 	char *error;
 	int i;
 
-	for(i = 0; i < nlines; i++){
+	for(i = 0; i < nlines; i++) {
 		line = &lines[i];
 		INIT_LIST_HEAD(&line->chan_list);
 
-		if(line->init_str == NULL)
+		if (line->init_str == NULL)
 			continue;
 
 		line->init_str = kstrdup(line->init_str, GFP_KERNEL);
-		if(line->init_str == NULL)
-			printk("lines_init - kstrdup returned NULL\n");
+		if (line->init_str == NULL)
+			printk(KERN_ERR "lines_init - kstrdup returned NULL\n");
 
-		if(parse_chan_pair(line->init_str, line, i, opts, &error)){
-			printk("parse_chan_pair failed for device %d : %s\n",
-			       i, error);
+		if (parse_chan_pair(line->init_str, line, i, opts, &error)) {
+			printk(KERN_ERR "parse_chan_pair failed for "
+			       "device %d : %s\n", i, error);
 			line->valid = 0;
 		}
 	}
@@ -772,14 +771,14 @@ static irqreturn_t winch_interrupt(int i
 	int err;
 	char c;
 
-	if(winch->fd != -1){
+	if (winch->fd != -1) {
 		err = generic_read(winch->fd, &c, NULL);
-		if(err < 0){
-			if(err != -EAGAIN){
-				printk("winch_interrupt : read failed, "
-				       "errno = %d\n", -err);
-				printk("fd %d is losing SIGWINCH support\n",
-				       winch->tty_fd);
+		if (err < 0) {
+			if (err != -EAGAIN) {
+				printk(KERN_ERR "winch_interrupt : "
+				       "read failed, errno = %d\n", -err);
+				printk(KERN_ERR "fd %d is losing SIGWINCH "
+				       "support\n", winch->tty_fd);
 				free_winch(winch, 0);
 				return IRQ_HANDLED;
 			}
@@ -794,7 +793,7 @@ static irqreturn_t winch_interrupt(int i
 		kill_pgrp(tty->pgrp, SIGWINCH, 1);
 	}
  out:
-	if(winch->fd != -1)
+	if (winch->fd != -1)
 		reactivate_fd(winch->fd, WINCH_IRQ);
 	return IRQ_HANDLED;
 }
@@ -806,7 +805,7 @@ void register_winch_irq(int fd, int tty_
 
 	winch = kmalloc(sizeof(*winch), GFP_KERNEL);
 	if (winch == NULL) {
-		printk("register_winch_irq - kmalloc failed\n");
+		printk(KERN_ERR "register_winch_irq - kmalloc failed\n");
 		goto cleanup;
 	}
 
@@ -820,7 +819,8 @@ void register_winch_irq(int fd, int tty_
 	if (um_request_irq(WINCH_IRQ, fd, IRQ_READ, winch_interrupt,
 			   IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			   "winch", winch) < 0) {
-		printk("register_winch_irq - failed to register IRQ\n");
+		printk(KERN_ERR "register_winch_irq - failed to register "
+		       "IRQ\n");
 		goto out_free;
 	}
 
@@ -846,13 +846,13 @@ static void unregister_winch(struct tty_
 
 	spin_lock(&winch_handler_lock);
 
-	list_for_each(ele, &winch_handlers){
+	list_for_each(ele, &winch_handlers) {
 		winch = list_entry(ele, struct winch, list);
-                if(winch->tty == tty){
+		if (winch->tty == tty) {
 			free_winch(winch, 1);
 			break;
-                }
-        }
+		}
+	}
 	spin_unlock(&winch_handler_lock);
 }
 
@@ -863,7 +863,7 @@ static void winch_cleanup(void)
 
 	spin_lock(&winch_handler_lock);
 
-	list_for_each_safe(ele, next, &winch_handlers){
+	list_for_each_safe(ele, next, &winch_handlers) {
 		winch = list_entry(ele, struct winch, list);
 		free_winch(winch, 1);
 	}
@@ -878,13 +878,13 @@ char *add_xterm_umid(char *base)
 	int len;
 
 	umid = get_umid();
-	if(*umid == '\0')
+	if (*umid == '\0')
 		return base;
 
 	len = strlen(base) + strlen(" ()") + strlen(umid) + 1;
 	title = kmalloc(len, GFP_KERNEL);
-	if(title == NULL){
-		printk("Failed to allocate buffer for xterm title\n");
+	if (title == NULL) {
+		printk(KERN_ERR "Failed to allocate buffer for xterm title\n");
 		return base;
 	}
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
