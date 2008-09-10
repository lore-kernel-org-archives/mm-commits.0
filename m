From: akpm@linux-foundation.org
Subject: + tty-fix-echo-tab-erase-and-locking.patch added to -mm tree
Date: Wed, 10 Sep 2008 16:46:17 -0700
Message-ID: <200809102346.m8ANkHMC000536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbYIJXqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 19:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@skyrush.com, alan@lxorguk.ukuu.org.uk


The patch titled
     tty: fix echo tab erase and locking
has been added to the -mm tree.  Its filename is
     tty-fix-echo-tab-erase-and-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: fix echo tab erase and locking
From: Joe Peterson <joe@skyrush.com>

1) Fix tab erasure handling
2) Improve locking when working with the echo buffer
3) Remove the big kernel lock (BKL) from n_tty

Tab erasure handling is now more robust and able to handle non-zero
canon column cases more correctly.  This is done by making correct use
of what is known in the eraser function (read buffer contents) and what
is known at the time of processing the tab erasure (column state).

Also, better locking of the echo buffer will now prevent any attempts
to process partial multi-byte echo operations.  And since the echo
buffer code now isolates the tty column state code to the process_out*
and process_echoes functions, we can remove the big kernel lock (BKL)
and replace it with more modern mutex locks.

Signed-off-by: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c  |  227 +++++++++++++++++++++++-----------------
 drivers/char/tty_io.c |    7 -
 include/linux/tty.h   |    3 
 3 files changed, 140 insertions(+), 97 deletions(-)

diff -puN drivers/char/n_tty.c~tty-fix-echo-tab-erase-and-locking drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-fix-echo-tab-erase-and-locking
+++ a/drivers/char/n_tty.c
@@ -71,7 +71,7 @@
 #define ECHO_OP_START 0xff
 #define ECHO_OP_MOVE_BACK_COL 0x80
 #define ECHO_OP_SET_CANON_COL 0x81
-#define ECHO_OP_TAB_ERASE 0x82
+#define ECHO_OP_ERASE_TAB 0x82
 
 static inline unsigned char *alloc_buf(void)
 {
@@ -188,9 +188,11 @@ static void reset_buffer_flags(struct tt
 	spin_lock_irqsave(&tty->read_lock, flags);
 	tty->read_head = tty->read_tail = tty->read_cnt = 0;
 	spin_unlock_irqrestore(&tty->read_lock, flags);
-	spin_lock_irqsave(&tty->echo_lock, flags);
+
+	mutex_lock(&tty->echo_lock);
 	tty->echo_pos = tty->echo_cnt = tty->echo_overrun = 0;
-	spin_unlock_irqrestore(&tty->echo_lock, flags);
+	mutex_unlock(&tty->echo_lock);
+
 	tty->canon_head = tty->canon_data = tty->erasing = 0;
 	memset(&tty->read_flags, 0, sizeof tty->read_flags);
 	n_tty_set_room(tty);
@@ -284,14 +286,11 @@ static inline int is_continuation(unsign
  *	do_output_char			-	output one character
  *	@c: character (or partial unicode symbol)
  *	@tty: terminal device
- *	@space: space available in write buffer
+ *	@space: space available in tty driver write buffer
  *
  *	This is a helper function that handles one output character
  *	(including special characters like TAB, CR, LF, etc.),
  *	putting the results in the tty driver's write buffer.
- *	It is assumed that the calling function does the required
- *	locking and has already determined the space left in the tty
- *	driver's write buffer.
  *
  *	Note that Linux currently ignores TABDLY, CRDLY, VTDLY, FFDLY
  *	and NLDLY.  They simply aren't relevant in the world today.
@@ -299,6 +298,9 @@ static inline int is_continuation(unsign
  *
  *	Returns the number of bytes of buffer space used or -1 if
  *	no space left.
+ *
+ *	Should be called under the output lock to protect column state and
+ *	space left in the tty driver buffer.
  */
 
 static int do_output_char(unsigned char c, struct tty_struct *tty, int space)
@@ -368,23 +370,21 @@ static int do_output_char(unsigned char 
  *	Perform OPOST processing.  Returns -1 when the output device is
  *	full and the character must be retried.
  *
- *	Called from both the receive and transmit sides and can be called
- *	re-entrantly.  Relies on lock_kernel for tty->column state.
- *	Since we rely on lock_kernel to prevent the tty_write_room from
- *	changing after it is obtained, an alternate means to ensure this
- *	would need to be implemented if the locking mechanism changed.
+ *	Called from write_chan under the tty layer write lock.
+ *	Also takes the output lock to protect column state and
+ *	space left in the tty driver buffer.
  */
 
 static int process_output(unsigned char c, struct tty_struct *tty)
 {
 	int	space, retval;
 
-	lock_kernel();
+	mutex_lock(&tty->output_lock);
 
 	space = tty_write_room(tty);
 	retval = do_output_char(c, tty, space);
 
-	unlock_kernel();
+	mutex_unlock(&tty->output_lock);
 	if (retval < 0)
 		return -1;
 	else
@@ -403,10 +403,8 @@ static int process_output(unsigned char 
  *	symbols for the console driver and thus improve performance.
  *
  *	Called from write_chan under the tty layer write lock.
- *	Relies on lock_kernel for the tty->column state.
- *	Since we rely on lock_kernel to prevent the tty_write_room from
- *	changing after it is obtained, an alternate means to ensure this
- *	would need to be implemented if the locking mechanism changed.
+ *	Also takes the output lock to protect column state and
+ *	space left in the tty driver buffer.
  */
 
 static ssize_t process_output_block(struct tty_struct *tty,
@@ -416,12 +414,12 @@ static ssize_t process_output_block(stru
 	int 	i;
 	const unsigned char *cp;
 
-	lock_kernel();
+	mutex_lock(&tty->output_lock);
 
 	space = tty_write_room(tty);
 	if (!space)
 	{
-		unlock_kernel();
+		mutex_unlock(&tty->output_lock);
 		return 0;
 	}
 	if (nr > space)
@@ -459,7 +457,7 @@ static ssize_t process_output_block(stru
 	}
 break_out:
 	i = tty->ops->write(tty, buf, i);
-	unlock_kernel();
+	mutex_unlock(&tty->output_lock);
 	return i;
 }
 
@@ -486,14 +484,9 @@ break_out:
  *	are prioritized.  Also, when control characters are echoed with a
  *	prefixed "^", the pair is treated atomically and thus not separated.
  *
- *	Like the process_output functions, this relies on lock_kernel.
- *	If this lock is ever removed, we should make sure this function
- *	is locked against other code that currently uses echo_lock,
- *	and we should also lock against normal tty output done in
- *	write_chan (so the control pairs do not get separated).  Also,
- *	since we rely on lock_kernel to prevent the tty_write_room from
- *	changing after it is obtained, an alternate means to ensure this
- *	would need to be implemented if the locking mechanism changed.
+ *	Takes the output lock to protect column state and space left
+ *	in the tty driver buffer.
+ *	Also takes the echo lock to protect the echo buffer.
  */
 
 static void process_echoes(struct tty_struct *tty)
@@ -505,7 +498,8 @@ static void process_echoes(struct tty_st
 	if (!tty->echo_cnt)
 		return;
 
-	lock_kernel();
+	mutex_lock(&tty->output_lock);
+	mutex_lock(&tty->echo_lock);
 
 	space = tty_write_room(tty);
 
@@ -530,44 +524,39 @@ static void process_echoes(struct tty_st
 			op = *opp;
 
 			switch (op) {
-				unsigned char lbyte, hbyte;
-				unsigned short rdiff;
-				int num_bs;
-				unsigned int col;
+				unsigned int num_chars, num_bs;
 
-			case ECHO_OP_TAB_ERASE:
-				/* Extract rdiff value from next two bytes */
-				if (++opp == buf_end)
-					opp -= N_TTY_BUF_SIZE;
-				lbyte = *opp;
+			case ECHO_OP_ERASE_TAB:
 				if (++opp == buf_end)
 					opp -= N_TTY_BUF_SIZE;
-				hbyte = *opp;
-				rdiff = (hbyte << 8) | lbyte;
+				num_chars = *opp;
 
-				col = tty->canon_column + rdiff;
+				/*
+				 * Determine how many columns to go back
+				 * in order to erase the tab.
+				 * This depends on the number of columns
+				 * used by other characters within the tab
+				 * area.  If this (modulo 8) count is from
+				 * the start of input rather than from a
+				 * previous tab, we offset by canon column.
+				 * Otherwise, tab spacing is normal.
+				 */
+				if (!(num_chars & 0x80))
+					num_chars += tty->canon_column;
+				num_bs = 8 - (num_chars & 7);
 
-				/* should never happen */
-				if (tty->column > 0x80000000)
-					tty->column = 0;
-
-				num_bs = tty->column - col;
-				if (num_bs < 0)
-					num_bs = 0;
 				if (num_bs > space) {
 					no_space_left = 1;
 					break;
 				}
-
-				/* Now backup to that column. */
-				while (tty->column > col) {
+				space -= num_bs;
+				while (num_bs--) {
 					tty_put_char(tty, '\b');
 					if (tty->column > 0)
 						tty->column--;
 				}
-				space -= num_bs;
-				cp += 4;
-				nr -= 4;
+				cp += 3;
+				nr -= 3;
 				break;
 
 			case ECHO_OP_SET_CANON_COL:
@@ -658,7 +647,8 @@ static void process_echoes(struct tty_st
 			tty->echo_overrun = 0;
 	}
 
-	unlock_kernel();
+	mutex_unlock(&tty->echo_lock);
+	mutex_unlock(&tty->output_lock);
 
 	if (tty->ops->flush_chars)
 		tty->ops->flush_chars(tty);
@@ -670,14 +660,13 @@ static void process_echoes(struct tty_st
  *	@tty: terminal device
  *
  *	Add a character or operation byte to the echo buffer.
+ *
+ *	Should be called under the echo lock to protect the echo buffer.
  */
 
 static void add_echo_byte(unsigned char c, struct tty_struct *tty)
 {
 	int	new_byte_pos;
-	unsigned long flags;
-
-	spin_lock_irqsave(&tty->echo_lock, flags);
 
 	if (tty->echo_cnt == N_TTY_BUF_SIZE) {
 		/* Circular buffer is already at capacity */
@@ -691,9 +680,9 @@ static void add_echo_byte(unsigned char 
 		{
 			if (tty->echo_buf[(tty->echo_pos + 1) &
 					  (N_TTY_BUF_SIZE - 1)] ==
-						ECHO_OP_TAB_ERASE) {
-				tty->echo_pos += 4;
-				tty->echo_cnt -= 3;
+						ECHO_OP_ERASE_TAB) {
+				tty->echo_pos += 3;
+				tty->echo_cnt -= 2;
 			} else {
 				tty->echo_pos += 2;
 				tty->echo_cnt -= 1;
@@ -711,8 +700,6 @@ static void add_echo_byte(unsigned char 
 	}
 
 	tty->echo_buf[new_byte_pos] = c;
-
-	spin_unlock_irqrestore(&tty->echo_lock, flags);
 }
 
 /**
@@ -720,12 +707,18 @@ static void add_echo_byte(unsigned char 
  *	@tty: terminal device
  *
  *	Add an operation to the echo buffer to move back one column.
+ *
+ *	Takes the echo lock to protect the echo buffer.
  */
 
 static void echo_move_back_col(struct tty_struct *tty)
 {
+	mutex_lock(&tty->echo_lock);
+
 	add_echo_byte(ECHO_OP_START, tty);
 	add_echo_byte(ECHO_OP_MOVE_BACK_COL, tty);
+
+	mutex_unlock(&tty->echo_lock);
 }
 
 /**
@@ -734,28 +727,55 @@ static void echo_move_back_col(struct tt
  *
  *	Add an operation to the echo buffer to set the canon column
  *	to the current column.
+ *
+ *	Takes the echo lock to protect the echo buffer.
  */
 
 static void echo_set_canon_col(struct tty_struct *tty)
 {
+	mutex_lock(&tty->echo_lock);
+
 	add_echo_byte(ECHO_OP_START, tty);
 	add_echo_byte(ECHO_OP_SET_CANON_COL, tty);
+
+	mutex_unlock(&tty->echo_lock);
 }
 
 /**
- *	echo_tab_erase	-	add operation to erase tabs
+ *	echo_erase_tab	-	add operation to erase a tab
+ *	@num_chars: number of character columns already used
+ *	@after_tab: true if num_chars starts after a previous tab
  *	@tty: terminal device
  *
- *	Add an operation to the echo buffer to set the canon column
- *	to the current column.
+ *	Add an operation to the echo buffer to erase a tab.
+ *
+ *	Called by the eraser function, which knows how many character
+ *	columns have been used since either a previous tab or the start
+ *	of input.  This information will be used later, along with
+ *	canon column (if applicable), to go back the correct number
+ *	of columns.
+ *
+ *	Takes the echo lock to protect the echo buffer.
  */
 
-static void echo_tab_erase(unsigned short rdiff, struct tty_struct *tty)
+static void echo_erase_tab(unsigned int num_chars, int after_tab,
+			   struct tty_struct *tty)
 {
+	mutex_lock(&tty->echo_lock);
+
 	add_echo_byte(ECHO_OP_START, tty);
-	add_echo_byte(ECHO_OP_TAB_ERASE, tty);
-	add_echo_byte(rdiff & 0xff, tty);
-	add_echo_byte(rdiff >> 8, tty);
+	add_echo_byte(ECHO_OP_ERASE_TAB, tty);
+
+	/* We only need to know this modulo 8 (tab spacing) */
+	num_chars &= 7;
+
+	/* Set the high bit as a flag if num_chars is after a previous tab */
+	if (after_tab)
+		num_chars |= 0x80;
+
+	add_echo_byte(num_chars, tty);
+
+	mutex_unlock(&tty->echo_lock);
 }
 
 /**
@@ -767,16 +787,22 @@ static void echo_tab_erase(unsigned shor
  *	L_ECHO(tty) is true. Called from the driver receive_buf path.
  *
  *	This variant does not treat control characters specially.
+ *
+ *	Takes the echo lock to protect the echo buffer.
  */
 
 static void echo_char_raw(unsigned char c, struct tty_struct *tty)
 {
+	mutex_lock(&tty->echo_lock);
+
 	if (c == ECHO_OP_START) {
 		add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(ECHO_OP_START, tty);
 	} else {
 		add_echo_byte(c, tty);
 	}
+
+	mutex_unlock(&tty->echo_lock);
 }
 
 /**
@@ -789,13 +815,24 @@ static void echo_char_raw(unsigned char 
  *
  *	This variant tags control characters to be possibly echoed as
  *	as "^X" (where X is the letter representing the control char).
+ *
+ *	Takes the echo lock to protect the echo buffer.
  */
 
 static void echo_char(unsigned char c, struct tty_struct *tty)
 {
-	if (iscntrl(c) && c != '\t')
+	mutex_lock(&tty->echo_lock);
+
+	if (c == ECHO_OP_START) {
+		add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(ECHO_OP_START, tty);
-	echo_char_raw(c, tty);
+	} else {
+		if (iscntrl(c) && c != '\t')
+			add_echo_byte(ECHO_OP_START, tty);
+		add_echo_byte(c, tty);
+	}
+
+	mutex_unlock(&tty->echo_lock);
 }
 
 static inline void finish_erasing(struct tty_struct *tty)
@@ -901,28 +938,32 @@ static void eraser(unsigned char c, stru
 			} else if (kill_type == ERASE && !L_ECHOE(tty)) {
 				echo_char(ERASE_CHAR(tty), tty);
 			} else if (c == '\t') {
-				unsigned short rdiff = 0;
-				unsigned long tail = tty->canon_head;
+				unsigned int num_chars = 0;
+				int after_tab = 0;
+				unsigned long tail = tty->read_head;
 
 				/*
-				 * Find number of columns from canon_head
-				 * to read_head.  This will later be
-				 * added to the canon_column to determine
-				 * how far to erase up to the cur column.
+				 * Count the columns used for characters
+				 * since the start of input or after a
+				 * previous tab.
+				 * This info is used to go back the correct
+				 * number of columns.
 				 */
-				while (tail != tty->read_head) {
+				while (tail != tty->canon_head) {
+					tail = (tail-1) & (N_TTY_BUF_SIZE-1);
 					c = tty->read_buf[tail];
-					if (c == '\t')
-						rdiff = (rdiff | 7) + 1;
+					if (c == '\t') {
+						after_tab = 1;
+						break;
+					}
 					else if (iscntrl(c)) {
 						if (L_ECHOCTL(tty))
-							rdiff += 2;
-					} else if (!is_continuation(c, tty))
-						rdiff++;
-					tail = (tail+1) & (N_TTY_BUF_SIZE-1);
+							num_chars += 2;
+					} else if (!is_continuation(c, tty)) {
+						num_chars++;
+					}
 				}
-
-				echo_tab_erase(rdiff, tty);
+				echo_erase_tab(num_chars, after_tab, tty);
 			} else {
 				if (iscntrl(c) && L_ECHOCTL(tty)) {
 					echo_char_raw('\b', tty);
@@ -1865,10 +1906,13 @@ do_it_again:
  *	@buf: userspace buffer pointer
  *	@nr: size of I/O
  *
- *	Write function of the terminal device. This is serialized with
+ *	Write function of the terminal device.  This is serialized with
  *	respect to other write callers but not to termios changes, reads
- *	and other such events. We must be careful with N_TTY as the receive
- *	code will echo characters, thus calling driver write methods.
+ *	and other such events.  Since the receive code will echo characters,
+ *	thus calling driver write methods, the output processing functions
+ *	called here, as well as the echo processing function, also take the
+ *	output lock to protect the column state and space left in the
+ *	tty driver buffer.
  *
  *	This code must be sure never to sleep through a hangup.
  */
@@ -2044,4 +2088,3 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.receive_buf     = n_tty_receive_buf,
 	.write_wakeup    = n_tty_write_wakeup
 };
-
diff -puN drivers/char/tty_io.c~tty-fix-echo-tab-erase-and-locking drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-fix-echo-tab-erase-and-locking
+++ a/drivers/char/tty_io.c
@@ -1111,9 +1111,7 @@ void tty_write_message(struct tty_struct
  *		Locks the line discipline as required
  *		Writes to the tty driver are serialized by the atomic_write_lock
  *	and are then processed in chunks to the device. The line discipline
- *	write method will not be involked in parallel for each device
- *		The line discipline write method is called under the big
- *	kernel lock for historical reasons. New code should not rely on this.
+ *	write method will not be involked in parallel for each device.
  */
 
 static ssize_t tty_write(struct file *file, const char __user *buf,
@@ -2781,9 +2779,10 @@ void initialize_tty_struct(struct tty_st
 	INIT_WORK(&tty->hangup_work, do_tty_hangup);
 	mutex_init(&tty->atomic_read_lock);
 	mutex_init(&tty->atomic_write_lock);
+	mutex_init(&tty->output_lock);
+	mutex_init(&tty->echo_lock);
 	spin_lock_init(&tty->read_lock);
 	spin_lock_init(&tty->ctrl_lock);
-	spin_lock_init(&tty->echo_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
 	INIT_WORK(&tty->SAK_work, do_SAK_work);
 
diff -puN include/linux/tty.h~tty-fix-echo-tab-erase-and-locking include/linux/tty.h
--- a/include/linux/tty.h~tty-fix-echo-tab-erase-and-locking
+++ a/include/linux/tty.h
@@ -271,10 +271,11 @@ struct tty_struct {
 	unsigned int canon_column;
 	struct mutex atomic_read_lock;
 	struct mutex atomic_write_lock;
+	struct mutex output_lock;
+	struct mutex echo_lock;
 	unsigned char *write_buf;
 	int write_cnt;
 	spinlock_t read_lock;
-	spinlock_t echo_lock;
 	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
 	struct tty_port *port;
_

Patches currently in -mm which might be from joe@skyrush.com are

tty-fix-loss-of-echoed-characters.patch
tty-minor-code-efficiency-and-style-cleanup.patch
tty-fix-echo-tab-erase-and-locking.patch
tty-fix-echo-tab-erase-and-locking-fix.patch

