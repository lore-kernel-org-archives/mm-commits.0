From: akpm@linux-foundation.org
Subject: + n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:13:51 -0800
Message-ID: <200711200713.lAK7DpZB020421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52702 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbXKTHON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:14:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     n_tty: clean up old code to follow coding style and (mostly) checkpatch
has been added to the -mm tree.  Its filename is
     n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: n_tty: clean up old code to follow coding style and (mostly) checkpatch
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |  152 ++++++++++++++++++++---------------------
 1 file changed, 75 insertions(+), 77 deletions(-)

diff -puN drivers/char/n_tty.c~n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch
+++ a/drivers/char/n_tty.c
@@ -1,6 +1,6 @@
 /*
  * n_tty.c --- implements the N_TTY line discipline.
- * 
+ *
  * This code used to be in tty_io.c, but things are getting hairy
  * enough that it made sense to split things off.  (The N_TTY
  * processing has changed so much that it's hardly recognizable,
@@ -8,19 +8,19 @@
  *
  * Note that the open routine for N_TTY is guaranteed never to return
  * an error.  This is because Linux will fall back to setting a line
- * to N_TTY if it can not switch to any other line discipline.  
+ * to N_TTY if it can not switch to any other line discipline.
  *
  * Written by Theodore Ts'o, Copyright 1994.
- * 
+ *
  * This file also contains code originally written by Linus Torvalds,
  * Copyright 1991, 1992, 1993, and by Julian Cowley, Copyright 1994.
- * 
+ *
  * This file may be redistributed under the terms of the GNU General Public
  * License.
  *
  * Reduced memory usage for older ARM systems  - Russell King.
  *
- * 2000/01/20   Fixed SMP locking on put_tty_queue using bits of 
+ * 2000/01/20   Fixed SMP locking on put_tty_queue using bits of
  *		the patch by Andrew J. Kroll <ag784@freenet.buffalo.edu>
  *		who actually finally proved there really was a race.
  *
@@ -144,11 +144,11 @@ static void put_tty_queue(unsigned char 
  *	Can sleep, may be called under the atomic_read_lock mutex but
  *	this is not guaranteed.
  */
- 
-static void check_unthrottle(struct tty_struct * tty)
+
+static void check_unthrottle(struct tty_struct *tty)
 {
 	if (tty->count &&
-	    test_and_clear_bit(TTY_THROTTLED, &tty->flags) && 
+	    test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
 	    tty->driver->unthrottle)
 		tty->driver->unthrottle(tty);
 }
@@ -157,7 +157,7 @@ static void check_unthrottle(struct tty_
  *	reset_buffer_flags	-	reset buffer state
  *	@tty: terminal to reset
  *
- *	Reset the read buffer counters, clear the flags, 
+ *	Reset the read buffer counters, clear the flags,
  *	and make sure the driver is unthrottled. Called
  *	from n_tty_open() and n_tty_flush_buffer().
  */
@@ -186,12 +186,12 @@ static void reset_buffer_flags(struct tt
  *	FIXME: tty->ctrl_status is not spinlocked and relies on
  *	lock_kernel() still.
  */
- 
-static void n_tty_flush_buffer(struct tty_struct * tty)
+
+static void n_tty_flush_buffer(struct tty_struct *tty)
 {
 	/* clear everything and unthrottle the driver */
 	reset_buffer_flags(tty);
-	
+
 	if (!tty->link)
 		return;
 
@@ -206,9 +206,9 @@ static void n_tty_flush_buffer(struct tt
  *	@tty: tty device
  *
  *	Report the number of characters buffered to be delivered to user
- *	at this instant in time. 
+ *	at this instant in time.
  */
- 
+
 static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
 {
 	unsigned long flags;
@@ -234,7 +234,7 @@ static ssize_t n_tty_chars_in_buffer(str
  *	character. We use this to correctly compute the on screen size
  *	of the character when printing
  */
- 
+
 static inline int is_utf8_continuation(unsigned char c)
 {
 	return (c & 0xc0) == 0x80;
@@ -247,7 +247,7 @@ static inline int is_utf8_continuation(u
  *	Returns true if the utf8 character 'c' is a multibyte continuation
  *	character and the terminal is in unicode mode.
  */
- 
+
 static inline int is_continuation(unsigned char c, struct tty_struct *tty)
 {
 	return I_IUTF8(tty) && is_utf8_continuation(c);
@@ -266,7 +266,7 @@ static inline int is_continuation(unsign
  *	Called from both the receive and transmit sides and can be called
  *	re-entrantly. Relies on lock_kernel() still.
  */
- 
+
 static int opost(unsigned char c, struct tty_struct *tty)
 {
 	int	space, spaces;
@@ -339,9 +339,9 @@ static int opost(unsigned char c, struct
  *
  *	Called from write_chan under the tty layer write lock.
  */
- 
-static ssize_t opost_block(struct tty_struct * tty,
-		       const unsigned char * buf, unsigned int nr)
+
+static ssize_t opost_block(struct tty_struct *tty,
+		       const unsigned char *buf, unsigned int nr)
 {
 	int	space;
 	int 	i;
@@ -386,7 +386,7 @@ static ssize_t opost_block(struct tty_st
 break_out:
 	if (tty->driver->flush_chars)
 		tty->driver->flush_chars(tty);
-	i = tty->driver->write(tty, buf, i);	
+	i = tty->driver->write(tty, buf, i);
 	return i;
 }
 
@@ -398,7 +398,7 @@ break_out:
  *
  *	Queue a byte to the driver layer for output
  */
- 
+
 static inline void put_char(unsigned char c, struct tty_struct *tty)
 {
 	tty->driver->put_char(tty, c);
@@ -409,7 +409,7 @@ static inline void put_char(unsigned cha
  *	@c: unicode byte to echo
  *	@tty: terminal device
  *
- *	Echo user input back onto the screen. This must be called only when 
+ *	Echo user input back onto the screen. This must be called only when
  *	L_ECHO(tty) is true. Called from the driver receive_buf path.
  */
 
@@ -441,7 +441,7 @@ static inline void finish_erasing(struct
  *	present in the stream from the driver layer. Handles the complexities
  *	of UTF-8 multibyte symbols.
  */
- 
+
 static void eraser(unsigned char c, struct tty_struct *tty)
 {
 	enum { ERASE, WERASE, KILL } kill_type;
@@ -541,7 +541,7 @@ static void eraser(unsigned char c, stru
 
 				/* should never happen */
 				if (tty->column > 0x80000000)
-					tty->column = 0; 
+					tty->column = 0;
 
 				/* Now backup to that column. */
 				while (tty->column > col) {
@@ -585,7 +585,7 @@ static void eraser(unsigned char c, stru
  *	settings and character used. Called from the driver receive_buf
  *	path so serialized.
  */
- 
+
 static inline void isig(int sig, struct tty_struct *tty, int flush)
 {
 	if (tty->pgrp)
@@ -606,7 +606,7 @@ static inline void isig(int sig, struct 
  *
  *	Called from the receive_buf path so single threaded.
  */
- 
+
 static inline void n_tty_receive_break(struct tty_struct *tty)
 {
 	if (I_IGNBRK(tty))
@@ -635,7 +635,7 @@ static inline void n_tty_receive_break(s
  *	need locking as num_overrun and overrun_time are function
  *	private.
  */
- 
+
 static inline void n_tty_receive_overrun(struct tty_struct *tty)
 {
 	char buf[64];
@@ -662,9 +662,8 @@ static inline void n_tty_receive_overrun
 static inline void n_tty_receive_parity_error(struct tty_struct *tty,
 					      unsigned char c)
 {
-	if (I_IGNPAR(tty)) {
+	if (I_IGNPAR(tty))
 		return;
-	}
 	if (I_PARMRK(tty)) {
 		put_tty_queue('\377', tty);
 		put_tty_queue('\0', tty);
@@ -682,7 +681,7 @@ static inline void n_tty_receive_parity_
  *	@c: character
  *
  *	Process an individual character of input received from the driver.
- *	This is serialized with respect to itself by the rules for the 
+ *	This is serialized with respect to itself by the rules for the
  *	driver above.
  */
 
@@ -694,17 +693,17 @@ static inline void n_tty_receive_char(st
 		put_tty_queue(c, tty);
 		return;
 	}
-	
+
 	if (tty->stopped && !tty->flow_stopped &&
 	    I_IXON(tty) && I_IXANY(tty)) {
 		start_tty(tty);
 		return;
 	}
-	
+
 	if (I_ISTRIP(tty))
 		c &= 0x7f;
 	if (I_IUCLC(tty) && L_IEXTEN(tty))
-		c=tolower(c);
+		c = tolower(c);
 
 	if (tty->closing) {
 		if (I_IXON(tty)) {
@@ -740,7 +739,7 @@ static inline void n_tty_receive_char(st
 		put_tty_queue(c, tty);
 		return;
 	}
-		
+
 	if (c == '\r') {
 		if (I_IGNCR(tty))
 			return;
@@ -812,8 +811,8 @@ send_signal:
 			goto handle_newline;
 		}
 		if (c == EOF_CHAR(tty)) {
-		        if (tty->canon_head != tty->read_head)
-			        set_bit(TTY_PUSH, &tty->flags);
+			if (tty->canon_head != tty->read_head)
+				set_bit(TTY_PUSH, &tty->flags);
 			c = __DISABLED_CHAR;
 			goto handle_newline;
 		}
@@ -837,7 +836,7 @@ send_signal:
 			if (I_PARMRK(tty) && c == (unsigned char) '\377')
 				put_tty_queue(c, tty);
 
-		handle_newline:
+handle_newline:
 			spin_lock_irqsave(&tty->read_lock, flags);
 			set_bit(tty->read_head, tty->read_flags);
 			put_tty_queue_nolock(c, tty);
@@ -850,7 +849,7 @@ send_signal:
 			return;
 		}
 	}
-	
+
 	finish_erasing(tty);
 	if (L_ECHO(tty)) {
 		if (tty->read_cnt >= N_TTY_BUF_SIZE-1) {
@@ -871,7 +870,7 @@ send_signal:
 		put_tty_queue(c, tty);
 
 	put_tty_queue(c, tty);
-}	
+}
 
 
 /**
@@ -885,12 +884,10 @@ send_signal:
 
 static void n_tty_write_wakeup(struct tty_struct *tty)
 {
-	if (tty->fasync)
-	{
- 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+	if (tty->fasync) {
+		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 		kill_fasync(&tty->fasync, SIGIO, POLL_OUT);
 	}
-	return;
 }
 
 /**
@@ -905,7 +902,7 @@ static void n_tty_write_wakeup(struct tt
  *	not from interrupt context. The driver is responsible for making
  *	calls one at a time and in order (or using flush_to_ldisc)
  */
- 
+
 static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			      char *fp, int count)
 {
@@ -937,7 +934,7 @@ static void n_tty_receive_buf(struct tty
 		tty->read_cnt += i;
 		spin_unlock_irqrestore(&tty->read_lock, cpuflags);
 	} else {
-		for (i=count, p = cp, f = fp; i; i--, p++) {
+		for (i = count, p = cp, f = fp; i; i--, p++) {
 			if (f)
 				flags = *f++;
 			switch (flags) {
@@ -955,7 +952,7 @@ static void n_tty_receive_buf(struct tty
 				n_tty_receive_overrun(tty);
 				break;
 			default:
-				printk("%s: unknown flag %d\n",
+				printk(KERN_ERR "%s: unknown flag %d\n",
 				       tty_name(tty, buf), flags);
 				break;
 			}
@@ -988,7 +985,7 @@ static void n_tty_receive_buf(struct tty
 int is_ignored(int sig)
 {
 	return (sigismember(&current->blocked, sig) ||
-	        current->sighand->action[sig-1].sa.sa_handler == SIG_IGN);
+		current->sighand->action[sig-1].sa.sa_handler == SIG_IGN);
 }
 
 /**
@@ -998,16 +995,16 @@ int is_ignored(int sig)
  *
  *	Called by the tty layer when the user changes termios flags so
  *	that the line discipline can plan ahead. This function cannot sleep
- *	and is protected from re-entry by the tty layer. The user is 
+ *	and is protected from re-entry by the tty layer. The user is
  *	guaranteed that this function will not be re-entered or in progress
  *	when the ldisc is closed.
  */
- 
-static void n_tty_set_termios(struct tty_struct *tty, struct ktermios * old)
+
+static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	if (!tty)
 		return;
-	
+
 	tty->icanon = (L_ICANON(tty) != 0);
 	if (test_bit(TTY_HW_COOK_IN, &tty->flags)) {
 		tty->raw = 1;
@@ -1072,12 +1069,12 @@ static void n_tty_set_termios(struct tty
  *	n_tty_close		-	close the ldisc for this tty
  *	@tty: device
  *
- *	Called from the terminal layer when this line discipline is 
- *	being shut down, either because of a close or becsuse of a 
+ *	Called from the terminal layer when this line discipline is
+ *	being shut down, either because of a close or becsuse of a
  *	discipline change. The function will not be called while other
  *	ldisc methods are in progress.
  */
- 
+
 static void n_tty_close(struct tty_struct *tty)
 {
 	n_tty_flush_buffer(tty);
@@ -1091,7 +1088,7 @@ static void n_tty_close(struct tty_struc
  *	n_tty_open		-	open an ldisc
  *	@tty: terminal to open
  *
- *	Called when this line discipline is being attached to the 
+ *	Called when this line discipline is being attached to the
  *	terminal device. Can sleep. Called serialized so that no
  *	other events will occur in parallel. No further open will occur
  *	until a close.
@@ -1144,7 +1141,7 @@ static inline int input_available_p(stru
  *	Called under the tty->atomic_read_lock sem
  *
  */
- 
+
 static int copy_from_read_buf(struct tty_struct *tty,
 				      unsigned char __user **b,
 				      size_t *nr)
@@ -1173,7 +1170,8 @@ static int copy_from_read_buf(struct tty
 	return retval;
 }
 
-extern ssize_t redirected_tty_write(struct file *,const char *,size_t,loff_t *);
+extern ssize_t redirected_tty_write(struct file *, const char *,
+							size_t, loff_t *);
 
 /**
  *	job_control		-	check job control
@@ -1181,10 +1179,10 @@ extern ssize_t redirected_tty_write(stru
  *	@file: file handle
  *
  *	Perform job control management checks on this file/tty descriptor
- *	and if appropriate send any needed signals and return a negative 
+ *	and if appropriate send any needed signals and return a negative
  *	error code if action should be taken.
  */
- 
+
 static int job_control(struct tty_struct *tty, struct file *file)
 {
 	/* Job control check -- must be done at start and after
@@ -1195,7 +1193,7 @@ static int job_control(struct tty_struct
 	if (file->f_op->write != redirected_tty_write &&
 	    current->signal->tty == tty) {
 		if (!tty->pgrp)
-			printk("read_chan: no tty->pgrp!\n");
+			printk(KERN_ERR "read_chan: no tty->pgrp!\n");
 		else if (task_pgrp(current) != tty->pgrp) {
 			if (is_ignored(SIGTTIN) ||
 			    is_current_pgrp_orphaned())
@@ -1207,7 +1205,7 @@ static int job_control(struct tty_struct
 	}
 	return 0;
 }
- 
+
 
 /**
  *	read_chan		-	read function for tty
@@ -1223,7 +1221,7 @@ static int job_control(struct tty_struct
  *
  *	This code must be sure never to sleep through a hangup.
  */
- 
+
 static ssize_t read_chan(struct tty_struct *tty, struct file *file,
 			 unsigned char __user *buf, size_t nr)
 {
@@ -1239,14 +1237,14 @@ static ssize_t read_chan(struct tty_stru
 do_it_again:
 
 	if (!tty->read_buf) {
-		printk("n_tty_read_chan: called with read_buf == NULL?!?\n");
+		printk(KERN_ERR "n_tty_read_chan: read_buf == NULL?!?\n");
 		return -EIO;
 	}
 
 	c = job_control(tty, file);
-	if(c < 0)
+	if (c < 0)
 		return c;
-	
+
 	minimum = time = 0;
 	timeout = MAX_SCHEDULE_TIMEOUT;
 	if (!tty->icanon) {
@@ -1274,8 +1272,7 @@ do_it_again:
 	if (file->f_flags & O_NONBLOCK) {
 		if (!mutex_trylock(&tty->atomic_read_lock))
 			return -EAGAIN;
-	}
-	else {
+	} else {
 		if (mutex_lock_interruptible(&tty->atomic_read_lock))
 			return -ERESTARTSYS;
 	}
@@ -1301,11 +1298,11 @@ do_it_again:
 		   so that any interrupt will set the state back to
 		   TASK_RUNNING. */
 		set_current_state(TASK_INTERRUPTIBLE);
-		
+
 		if (((minimum - (b - buf)) < tty->minimum_to_wake) &&
 		    ((minimum - (b - buf)) >= 1))
 			tty->minimum_to_wake = (minimum - (b - buf));
-		
+
 		if (!input_available_p(tty, 0)) {
 			if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
 				retval = -EIO;
@@ -1342,7 +1339,7 @@ do_it_again:
 		if (tty->icanon) {
 			/* N.B. avoid overrun if nr == 0 */
 			while (nr && tty->read_cnt) {
- 				int eol;
+				int eol;
 
 				eol = test_and_clear_bit(tty->read_tail,
 						tty->read_flags);
@@ -1414,7 +1411,7 @@ do_it_again:
 	if (size) {
 		retval = size;
 		if (nr)
-	       		clear_bit(TTY_PUSH, &tty->flags);
+			clear_bit(TTY_PUSH, &tty->flags);
 	} else if (test_and_clear_bit(TTY_PUSH, &tty->flags))
 		 goto do_it_again;
 
@@ -1437,9 +1434,9 @@ do_it_again:
  *
  *	This code must be sure never to sleep through a hangup.
  */
- 
-static ssize_t write_chan(struct tty_struct * tty, struct file * file,
-			  const unsigned char * buf, size_t nr)
+
+static ssize_t write_chan(struct tty_struct *tty, struct file *file,
+			  const unsigned char *buf, size_t nr)
 {
 	const unsigned char *b = buf;
 	DECLARE_WAITQUEUE(wait, current);
@@ -1529,8 +1526,9 @@ break_out:
  *	recompute the new limits. Possibly set_termios should issue
  *	a read wakeup to fix this bug.
  */
- 
-static unsigned int normal_poll(struct tty_struct * tty, struct file * file, poll_table *wait)
+
+static unsigned int normal_poll(struct tty_struct *tty, struct file *file,
+							poll_table *wait)
 {
 	unsigned int mask = 0;
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

termios-document-callback-more-clearly.patch
revert-keyspan-init-termios-properly.patch
git-arm.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
ahci-invalid-use-of-writel-readl-with-iomap.patch
libata-core-list-more-documentation-sources-for-reference.patch
libata-iordy-handling.patch
libata-sff-tf_load.patch
pata_ali-add-mitac-8317-and-derivatives.patch
pata_ali-lots-of-problems-still-showing-up-with-small-atapi-dma.patch
pata_hpt37x-fix-cable-detect-bug-spotted-by-sergei.patch
pata_isapnp-polled-devices.patch
pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch
pata_ninja32-cardbus-ata-initial-support.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
git-scsi-rc-fixes.patch
initio-fix-conflict-when-loading-driver.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
tty-add-the-new-termios2-ioctls-to-the-compatible.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
