From: akpm@linux-foundation.org
Subject: + ldisc-n_tty-export-all-n_tty-ldisc-methods.patch added to -mm tree
Date: Wed, 26 Nov 2008 15:53:27 -0800
Message-ID: <200811262353.mAQNrRxr013098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588AbYKZXyu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 18:54:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, alan@lxorguk.ukuu.org.uk, davej@redhat.com, dwmw2@infradead.org, greg@kroah.com, hpa@zytor.com, kay.sievers@vrfy.org, mingo@elte.hu, mtk.manpages@gmail.com, randy.dunlap@oracle.com, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     ldisc n_tty: export all N_TTY ldisc methods
has been added to the -mm tree.  Its filename is
     ldisc-n_tty-export-all-n_tty-ldisc-methods.patch

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
Subject: ldisc n_tty: export all N_TTY ldisc methods
From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |   32 +++++++++++++++++++++-----------
 include/linux/tty.h  |   16 ++++++++++++++++
 2 files changed, 37 insertions(+), 11 deletions(-)

diff -puN drivers/char/n_tty.c~ldisc-n_tty-export-all-n_tty-ldisc-methods drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~ldisc-n_tty-export-all-n_tty-ldisc-methods
+++ a/drivers/char/n_tty.c
@@ -42,8 +42,8 @@
 #include <linux/ctype.h>
 #include <linux/mm.h>
 #include <linux/string.h>
+#include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/poll.h>
 #include <linux/bitops.h>
 #include <linux/audit.h>
 #include <linux/file.h>
@@ -211,7 +211,7 @@ static void reset_buffer_flags(struct tt
  *	Locking: ctrl_lock, read_lock.
  */
 
-static void n_tty_flush_buffer(struct tty_struct *tty)
+void n_tty_flush_buffer(struct tty_struct *tty)
 {
 	unsigned long flags;
 	/* clear everything and unthrottle the driver */
@@ -227,6 +227,7 @@ static void n_tty_flush_buffer(struct tt
 	}
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 }
+EXPORT_SYMBOL_GPL(n_tty_flush_buffer);
 
 /**
  *	n_tty_chars_in_buffer	-	report available bytes
@@ -238,7 +239,7 @@ static void n_tty_flush_buffer(struct tt
  *	Locking: read_lock
  */
 
-static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
+ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
 {
 	unsigned long flags;
 	ssize_t n = 0;
@@ -254,6 +255,7 @@ static ssize_t n_tty_chars_in_buffer(str
 	spin_unlock_irqrestore(&tty->read_lock, flags);
 	return n;
 }
+EXPORT_SYMBOL_GPL(n_tty_chars_in_buffer);
 
 /**
  *	is_utf8_continuation	-	utf8 multibyte check
@@ -1347,7 +1349,7 @@ handle_newline:
  *	IO must be woken up
  */
 
-static void n_tty_write_wakeup(struct tty_struct *tty)
+void n_tty_write_wakeup(struct tty_struct *tty)
 {
 	/* Write out any echoed characters that are still pending */
 	process_echoes(tty);
@@ -1357,6 +1359,7 @@ static void n_tty_write_wakeup(struct tt
 		kill_fasync(&tty->fasync, SIGIO, POLL_OUT);
 	}
 }
+EXPORT_SYMBOL_GPL(n_tty_write_wakeup);
 
 /**
  *	n_tty_receive_buf	-	data receive
@@ -1371,7 +1374,7 @@ static void n_tty_write_wakeup(struct tt
  *	calls one at a time and in order (or using flush_to_ldisc)
  */
 
-static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
+void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			      char *fp, int count)
 {
 	const unsigned char *p;
@@ -1445,6 +1448,7 @@ static void n_tty_receive_buf(struct tty
 	if (tty->receive_room < TTY_THRESHOLD_THROTTLE)
 		tty_throttle(tty);
 }
+EXPORT_SYMBOL_GPL(n_tty_receive_buf);
 
 int is_ignored(int sig)
 {
@@ -1466,7 +1470,7 @@ int is_ignored(int sig)
  *	Locking: Caller holds tty->termios_mutex
  */
 
-static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
+void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	int canon_change = 1;
 	BUG_ON(!tty);
@@ -1545,6 +1549,7 @@ static void n_tty_set_termios(struct tty
 	wake_up_interruptible(&tty->write_wait);
 	wake_up_interruptible(&tty->read_wait);
 }
+EXPORT_SYMBOL_GPL(n_tty_set_termios);
 
 /**
  *	n_tty_close		-	close the ldisc for this tty
@@ -1556,7 +1561,7 @@ static void n_tty_set_termios(struct tty
  *	ldisc methods are in progress.
  */
 
-static void n_tty_close(struct tty_struct *tty)
+void n_tty_close(struct tty_struct *tty)
 {
 	n_tty_flush_buffer(tty);
 	if (tty->read_buf) {
@@ -1568,6 +1573,7 @@ static void n_tty_close(struct tty_struc
 		tty->echo_buf = NULL;
 	}
 }
+EXPORT_SYMBOL_GPL(n_tty_close);
 
 /**
  *	n_tty_open		-	open an ldisc
@@ -1579,7 +1585,7 @@ static void n_tty_close(struct tty_struc
  *	until a close.
  */
 
-static int n_tty_open(struct tty_struct *tty)
+int n_tty_open(struct tty_struct *tty)
 {
 	if (!tty)
 		return -EINVAL;
@@ -1604,6 +1610,7 @@ static int n_tty_open(struct tty_struct 
 	tty->closing = 0;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(n_tty_open);
 
 static inline int input_available_p(struct tty_struct *tty, int amt)
 {
@@ -1718,7 +1725,7 @@ static int job_control(struct tty_struct
  *	This code must be sure never to sleep through a hangup.
  */
 
-static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
+ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 			 unsigned char __user *buf, size_t nr)
 {
 	unsigned char __user *b = buf;
@@ -1918,6 +1925,7 @@ do_it_again:
 	n_tty_set_room(tty);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(n_tty_read);
 
 /**
  *	n_tty_write		-	write function for tty
@@ -1941,7 +1949,7 @@ do_it_again:
  *		  lock themselves)
  */
 
-static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
+ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			   const unsigned char *buf, size_t nr)
 {
 	const unsigned char *b = buf;
@@ -2016,6 +2024,7 @@ break_out:
 	remove_wait_queue(&tty->write_wait, &wait);
 	return (b - buf) ? b - buf : retval;
 }
+EXPORT_SYMBOL_GPL(n_tty_write);
 
 /**
  *	n_tty_poll		-	poll method for N_TTY
@@ -2031,7 +2040,7 @@ break_out:
  *	Called without the kernel lock held - fine
  */
 
-static unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
+unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
 							poll_table *wait)
 {
 	unsigned int mask = 0;
@@ -2058,6 +2067,7 @@ static unsigned int n_tty_poll(struct tt
 		mask |= POLLOUT | POLLWRNORM;
 	return mask;
 }
+EXPORT_SYMBOL_GPL(n_tty_poll);
 
 static unsigned long inq_canon(struct tty_struct *tty)
 {
diff -puN include/linux/tty.h~ldisc-n_tty-export-all-n_tty-ldisc-methods include/linux/tty.h
--- a/include/linux/tty.h~ldisc-n_tty-export-all-n_tty-ldisc-methods
+++ a/include/linux/tty.h
@@ -13,6 +13,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
+#include <linux/poll.h>
 
 #include <asm/system.h>
 
@@ -455,6 +456,21 @@ extern void tty_ldisc_begin(void);
 /* This last one is just for the tty layer internals and shouldn't be used elsewhere */
 extern void tty_ldisc_enable(struct tty_struct *tty);
 
+extern void n_tty_flush_buffer(struct tty_struct *tty);
+extern ssize_t n_tty_chars_in_buffer(struct tty_struct *tty);
+extern void n_tty_write_wakeup(struct tty_struct *tty);
+extern void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
+			char *fp, int count);
+extern void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old);
+extern void n_tty_close(struct tty_struct *tty);
+extern int n_tty_open(struct tty_struct *tty);
+extern ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
+			unsigned char __user *buf, size_t nr);
+extern ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
+			const unsigned char *buf, size_t nr);
+extern unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
+			poll_table *wait);
+
 
 /* n_tty.c */
 extern struct tty_ldisc_ops tty_ldisc_N_TTY;
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch

