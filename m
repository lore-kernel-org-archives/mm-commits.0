From: akpm@linux-foundation.org
Subject: - tty-add-compat_ioctl.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:05 -0700
Message-ID: <200705120534.l4C5Y5WK002165@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755066AbXELFeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     tty: add compat_ioctl
has been removed from the -mm tree.  Its filename was
     tty-add-compat_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: add compat_ioctl
From: Paul Fulghum <paulkf@microgate.com>

Add compat_ioctl method for tty code to allow processing of 32 bit ioctl
calls on 64 bit systems by tty core, tty drivers, and line disciplines.

Based on patch by Arnd Bergmann:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0511.0/1732.html

[akpm@linux-foundation.org: make things static]
Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c       |   29 ++++++++++-------------
 drivers/char/tty_io.c      |   43 ++++++++++++++++++++++++++++++++---
 include/linux/tty_driver.h |    9 +++++++
 include/linux/tty_ldisc.h  |    7 +++++
 4 files changed, 69 insertions(+), 19 deletions(-)

diff -puN drivers/char/n_tty.c~tty-add-compat_ioctl drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-add-compat_ioctl
+++ a/drivers/char/n_tty.c
@@ -1544,21 +1544,18 @@ static unsigned int normal_poll(struct t
 }
 
 struct tty_ldisc tty_ldisc_N_TTY = {
-	TTY_LDISC_MAGIC,	/* magic */
-	"n_tty",		/* name */
-	0,			/* num */
-	0,			/* flags */
-	n_tty_open,		/* open */
-	n_tty_close,		/* close */
-	n_tty_flush_buffer,	/* flush_buffer */
-	n_tty_chars_in_buffer,	/* chars_in_buffer */
-	read_chan,		/* read */
-	write_chan,		/* write */
-	n_tty_ioctl,		/* ioctl */
-	n_tty_set_termios,	/* set_termios */
-	normal_poll,		/* poll */
-	NULL,			/* hangup */
-	n_tty_receive_buf,	/* receive_buf */
-	n_tty_write_wakeup	/* write_wakeup */
+	.magic           = TTY_LDISC_MAGIC,
+	.name            = "n_tty",
+	.open            = n_tty_open,
+	.close           = n_tty_close,
+	.flush_buffer    = n_tty_flush_buffer,
+	.chars_in_buffer = n_tty_chars_in_buffer,
+	.read            = read_chan,
+	.write           = write_chan,
+	.ioctl           = n_tty_ioctl,
+	.set_termios     = n_tty_set_termios,
+	.poll            = normal_poll,
+	.receive_buf     = n_tty_receive_buf,
+	.write_wakeup    = n_tty_write_wakeup
 };
 
diff -puN drivers/char/tty_io.c~tty-add-compat_ioctl drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-add-compat_ioctl
+++ a/drivers/char/tty_io.c
@@ -151,6 +151,12 @@ static int tty_open(struct inode *, stru
 static int tty_release(struct inode *, struct file *);
 int tty_ioctl(struct inode * inode, struct file * file,
 	      unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
+static long tty_compat_ioctl(struct file * file, unsigned int cmd,
+				unsigned long arg);
+#else
+#define tty_compat_ioctl NULL
+#endif
 static int tty_fasync(int fd, struct file * filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
@@ -1143,8 +1149,8 @@ static unsigned int hung_up_tty_poll(str
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static int hung_up_tty_ioctl(struct inode * inode, struct file * file,
-			     unsigned int cmd, unsigned long arg)
+static long hung_up_tty_ioctl(struct file * file,
+			      unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
@@ -1155,6 +1161,7 @@ static const struct file_operations tty_
 	.write		= tty_write,
 	.poll		= tty_poll,
 	.ioctl		= tty_ioctl,
+	.compat_ioctl	= tty_compat_ioctl,
 	.open		= tty_open,
 	.release	= tty_release,
 	.fasync		= tty_fasync,
@@ -1167,6 +1174,7 @@ static const struct file_operations ptmx
 	.write		= tty_write,
 	.poll		= tty_poll,
 	.ioctl		= tty_ioctl,
+	.compat_ioctl	= tty_compat_ioctl,
 	.open		= ptmx_open,
 	.release	= tty_release,
 	.fasync		= tty_fasync,
@@ -1179,6 +1187,7 @@ static const struct file_operations cons
 	.write		= redirected_tty_write,
 	.poll		= tty_poll,
 	.ioctl		= tty_ioctl,
+	.compat_ioctl	= tty_compat_ioctl,
 	.open		= tty_open,
 	.release	= tty_release,
 	.fasync		= tty_fasync,
@@ -1189,7 +1198,8 @@ static const struct file_operations hung
 	.read		= hung_up_tty_read,
 	.write		= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
-	.ioctl		= hung_up_tty_ioctl,
+	.unlocked_ioctl = hung_up_tty_ioctl,
+	.compat_ioctl	= hung_up_tty_ioctl,
 	.release	= tty_release,
 };
 
@@ -3357,6 +3367,32 @@ int tty_ioctl(struct inode * inode, stru
 	return retval;
 }
 
+#ifdef CONFIG_COMPAT
+static long tty_compat_ioctl(struct file * file, unsigned int cmd,
+				unsigned long arg)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct tty_struct *tty = file->private_data;
+	struct tty_ldisc *ld;
+	int retval = -ENOIOCTLCMD;
+
+	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
+		return -EINVAL;
+
+	if (tty->driver->compat_ioctl) {
+		retval = (tty->driver->compat_ioctl)(tty, file, cmd, arg);
+		if (retval != -ENOIOCTLCMD)
+			return retval;
+	}
+
+	ld = tty_ldisc_ref_wait(tty);
+	if (ld->compat_ioctl)
+		retval = ld->compat_ioctl(tty, file, cmd, arg);
+	tty_ldisc_deref(ld);
+
+	return retval;
+}
+#endif
 
 /*
  * This implements the "Secure Attention Key" ---  the idea is to
@@ -3689,6 +3725,7 @@ void tty_set_operations(struct tty_drive
 	driver->write_room = op->write_room;
 	driver->chars_in_buffer = op->chars_in_buffer;
 	driver->ioctl = op->ioctl;
+	driver->compat_ioctl = op->compat_ioctl;
 	driver->set_termios = op->set_termios;
 	driver->throttle = op->throttle;
 	driver->unthrottle = op->unthrottle;
diff -puN include/linux/tty_driver.h~tty-add-compat_ioctl include/linux/tty_driver.h
--- a/include/linux/tty_driver.h~tty-add-compat_ioctl
+++ a/include/linux/tty_driver.h
@@ -52,6 +52,11 @@
  * 	This routine allows the tty driver to implement
  *	device-specific ioctl's.  If the ioctl number passed in cmd
  * 	is not recognized by the driver, it should return ENOIOCTLCMD.
+ *
+ * long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
+ * 	                unsigned int cmd, unsigned long arg);
+ *
+ * 	implement ioctl processing for 32 bit process on 64 bit system
  * 
  * void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
  *
@@ -132,6 +137,8 @@ struct tty_operations {
 	int  (*chars_in_buffer)(struct tty_struct *tty);
 	int  (*ioctl)(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg);
+	long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
+			     unsigned int cmd, unsigned long arg);
 	void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
 	void (*throttle)(struct tty_struct * tty);
 	void (*unthrottle)(struct tty_struct * tty);
@@ -193,6 +200,8 @@ struct tty_driver {
 	int  (*chars_in_buffer)(struct tty_struct *tty);
 	int  (*ioctl)(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg);
+	long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
+			     unsigned int cmd, unsigned long arg);
 	void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
 	void (*throttle)(struct tty_struct * tty);
 	void (*unthrottle)(struct tty_struct * tty);
diff -puN include/linux/tty_ldisc.h~tty-add-compat_ioctl include/linux/tty_ldisc.h
--- a/include/linux/tty_ldisc.h~tty-add-compat_ioctl
+++ a/include/linux/tty_ldisc.h
@@ -59,6 +59,11 @@
  * 	low-level driver can "grab" an ioctl request before the line
  * 	discpline has a chance to see it.
  * 
+ * long	(*compat_ioctl)(struct tty_struct * tty, struct file * file,
+ * 		        unsigned int cmd, unsigned long arg);
+ *
+ *      Process ioctl calls from 32-bit process on 64-bit system
+ *
  * void	(*set_termios)(struct tty_struct *tty, struct ktermios * old);
  *
  * 	This function notifies the line discpline that a change has
@@ -118,6 +123,8 @@ struct tty_ldisc {
 			 const unsigned char * buf, size_t nr);	
 	int	(*ioctl)(struct tty_struct * tty, struct file * file,
 			 unsigned int cmd, unsigned long arg);
+	long	(*compat_ioctl)(struct tty_struct * tty, struct file * file,
+				unsigned int cmd, unsigned long arg);
 	void	(*set_termios)(struct tty_struct *tty, struct ktermios * old);
 	unsigned int (*poll)(struct tty_struct *, struct file *,
 			     struct poll_table_struct *);
_

Patches currently in -mm which might be from paulkf@microgate.com are

origin.patch
tty-flush-flip-buffer-on-ldisc-input-queue-flush.patch
