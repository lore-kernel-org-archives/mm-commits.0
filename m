From: akpm@linux-foundation.org
Subject: + tty-add-compat_ioctl.patch added to -mm tree
Date: Thu, 03 May 2007 17:29:49 -0700
Message-ID: <200705040029.l440TnaG025805@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767497AbXEDAaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 20:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, arnd@arndb.de


The patch titled
     tty: add compat_ioctl
has been added to the -mm tree.  Its filename is
     tty-add-compat_ioctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: add compat_ioctl
From: Paul Fulghum <paulkf@microgate.com>

Add compat_ioctl method for tty code to allow processing of 32 bit ioctl
calls on 64 bit systems by tty core, tty drivers, and line disciplines.

Based on patch by Arnd Bergmann:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0511.0/1732.html

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c       |   29 +++++++++++-------------
 drivers/char/tty_io.c      |   41 ++++++++++++++++++++++++++++++++---
 include/linux/tty_driver.h |    9 +++++++
 include/linux/tty_ldisc.h  |    7 +++++
 4 files changed, 67 insertions(+), 19 deletions(-)

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
@@ -151,6 +151,11 @@ static int tty_open(struct inode *, stru
 static int tty_release(struct inode *, struct file *);
 int tty_ioctl(struct inode * inode, struct file * file,
 	      unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
+long tty_compat_ioctl(struct file * file, unsigned int cmd, unsigned long arg);
+#else
+#define tty_compat_ioctl NULL
+#endif
 static int tty_fasync(int fd, struct file * filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
@@ -1143,8 +1148,8 @@ static unsigned int hung_up_tty_poll(str
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static int hung_up_tty_ioctl(struct inode * inode, struct file * file,
-			     unsigned int cmd, unsigned long arg)
+static long hung_up_tty_ioctl(struct file * file,
+			      unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
@@ -1155,6 +1160,7 @@ static const struct file_operations tty_
 	.write		= tty_write,
 	.poll		= tty_poll,
 	.ioctl		= tty_ioctl,
+	.compat_ioctl	= tty_compat_ioctl,
 	.open		= tty_open,
 	.release	= tty_release,
 	.fasync		= tty_fasync,
@@ -1167,6 +1173,7 @@ static const struct file_operations ptmx
 	.write		= tty_write,
 	.poll		= tty_poll,
 	.ioctl		= tty_ioctl,
+	.compat_ioctl	= tty_compat_ioctl,
 	.open		= ptmx_open,
 	.release	= tty_release,
 	.fasync		= tty_fasync,
@@ -1179,6 +1186,7 @@ static const struct file_operations cons
 	.write		= redirected_tty_write,
 	.poll		= tty_poll,
 	.ioctl		= tty_ioctl,
+	.compat_ioctl	= tty_compat_ioctl,
 	.open		= tty_open,
 	.release	= tty_release,
 	.fasync		= tty_fasync,
@@ -1189,7 +1197,8 @@ static const struct file_operations hung
 	.read		= hung_up_tty_read,
 	.write		= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
-	.ioctl		= hung_up_tty_ioctl,
+	.unlocked_ioctl = hung_up_tty_ioctl,
+	.compat_ioctl	= hung_up_tty_ioctl,
 	.release	= tty_release,
 };
 
@@ -3360,6 +3369,31 @@ int tty_ioctl(struct inode * inode, stru
 	return retval;
 }
 
+#ifdef CONFIG_COMPAT
+long tty_compat_ioctl(struct file * file, unsigned int cmd, unsigned long arg)
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
@@ -3692,6 +3726,7 @@ void tty_set_operations(struct tty_drive
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

drivers-char-synclinkc-check-kmalloc-return-value.patch
synclink_gt-use-dynamic-tty-device-registration.patch
tty-add-compat_ioctl.patch
tty-add-compat_ioctl-fix.patch
