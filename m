From: akpm@linux-foundation.org
Subject: + tty-fix-loss-of-echoed-characters.patch added to -mm tree
Date: Tue, 26 Aug 2008 14:07:11 -0700
Message-ID: <200808262107.m7QL7CbZ027701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYHZVH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 17:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@skyrush.com, alan@lxorguk.ukuu.org.uk


The patch titled
     tty: fix loss of echoed characters
has been added to the -mm tree.  Its filename is
     tty-fix-loss-of-echoed-characters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: fix loss of echoed characters
From: Joe Peterson <joe@skyrush.com>

Fix the loss of echoed (and other ldisc-generated characters) when the tty
is stopped or when the driver output buffer is full (happens frequently
for input during continuous program output, such as ^C).

Adds an "echo buffer" to the N_TTY line discipline that handles all
ldisc-generated output (including echoed characters).  Along with the loss
of characters, this also fixes the associated loss of sync between tty
output and the ldisc state when characters cannot be immediately written
to the tty driver.

The echo buffer stores (in addition to characters) state operations that
need to be done at the time of character output (like management of the
column position).  This allows echo to cooperate correctly with program
output, since the ldisc state remains consistent with actual characters
written.

Highlights are:

* Handles echo (and other ldisc output) when tty driver buffer is full
  - continuous program output can block echo
* Saves echo when tty is in stopped state (e.g. ^S)
  - (e.g.: ^Q will correctly cause held characters to be released for output)
* Control character pairs (e.g. "^C") are treated atomically and not
  split up by interleaved program output
* Line discipline state is kept consistent with characters sent to
  the tty driver

Signed-off-by: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c  |  652 +++++++++++++++++++++++++++++++---------
 drivers/char/tty_io.c |    1 
 drivers/char/vt.c     |    2 
 include/linux/tty.h   |    5 
 4 files changed, 527 insertions(+), 133 deletions(-)

diff -puN drivers/char/n_tty.c~tty-fix-loss-of-echoed-characters drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-fix-loss-of-echoed-characters
+++ a/drivers/char/n_tty.c
@@ -62,6 +62,17 @@
 #define TTY_THRESHOLD_THROTTLE		128 /* now based on remaining room */
 #define TTY_THRESHOLD_UNTHROTTLE 	128
 
+/*
+ * Special byte codes used in the echo buffer to represent operations
+ * or special handling of characters.  Bytes in the echo buffer that
+ * are not part of such special blocks are treated as normal character
+ * codes.
+ */
+#define ECHO_OP_START 0xff
+#define ECHO_OP_MOVE_BACK_COL 0x80
+#define ECHO_OP_SET_CANON_COL 0x81
+#define ECHO_OP_TAB_ERASE 0x82
+
 static inline unsigned char *alloc_buf(void)
 {
 	gfp_t prio = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
@@ -159,6 +170,7 @@ static void check_unthrottle(struct tty_
  *	and make sure the driver is unthrottled. Called
  *	from n_tty_open() and n_tty_flush_buffer().
  */
+
 static void reset_buffer_flags(struct tty_struct *tty)
 {
 	unsigned long flags;
@@ -166,6 +178,9 @@ static void reset_buffer_flags(struct tt
 	spin_lock_irqsave(&tty->read_lock, flags);
 	tty->read_head = tty->read_tail = tty->read_cnt = 0;
 	spin_unlock_irqrestore(&tty->read_lock, flags);
+	spin_lock_irqsave(&tty->echo_lock, flags);
+	tty->echo_pos = tty->echo_cnt = tty->echo_overrun = 0;
+	spin_unlock_irqrestore(&tty->echo_lock, flags);
 	tty->canon_head = tty->canon_data = tty->erasing = 0;
 	memset(&tty->read_flags, 0, sizeof tty->read_flags);
 	n_tty_set_room(tty);
@@ -254,89 +269,118 @@ static inline int is_continuation(unsign
 }
 
 /**
- *	opost			-	output post processor
+ *	do_output_char			-	output one character
  *	@c: character (or partial unicode symbol)
  *	@tty: terminal device
+ *	@space: space available in write buffer
  *
- *	Perform OPOST processing.  Returns -1 when the output device is
- *	full and the character must be retried. Note that Linux currently
- *	ignores TABDLY, CRDLY, VTDLY, FFDLY and NLDLY. They simply aren't
- *	relevant in the world today. If you ever need them, add them here.
+ *	This is a helper function that handles one output character
+ *	(including special characters like TAB, CR, LF, etc.),
+ *	putting the results in the tty driver's write buffer.
+ *	It is assumed that the calling function does the required
+ *	locking and has already determined the space left in the tty
+ *	driver's write buffer.
  *
- *	Called from both the receive and transmit sides and can be called
- *	re-entrantly. Relies on lock_kernel() for tty->column state.
+ *	Note that Linux currently ignores TABDLY, CRDLY, VTDLY, FFDLY
+ *	and NLDLY.  They simply aren't relevant in the world today.
+ *	If you ever need them, add them here.
+ *
+ *	Returns the number of bytes of buffer space used or -1 if
+ *	no space left.
  */
 
-static int opost(unsigned char c, struct tty_struct *tty)
+static int do_output_char(unsigned char c, struct tty_struct *tty, int space)
 {
-	int	space, spaces;
+	int	spaces;
 
-	space = tty_write_room(tty);
 	if (!space)
 		return -1;
 
-	lock_kernel();
-	if (O_OPOST(tty)) {
-		switch (c) {
-		case '\n':
-			if (O_ONLRET(tty))
-				tty->column = 0;
-			if (O_ONLCR(tty)) {
-				if (space < 2) {
-					unlock_kernel();
-					return -1;
-				}
-				tty_put_char(tty, '\r');
-				tty->column = 0;
-			}
-			tty->canon_column = tty->column;
-			break;
-		case '\r':
-			if (O_ONOCR(tty) && tty->column == 0) {
-				unlock_kernel();
-				return 0;
-			}
-			if (O_OCRNL(tty)) {
-				c = '\n';
-				if (O_ONLRET(tty))
-					tty->canon_column = tty->column = 0;
-				break;
-			}
+	switch (c) {
+	case '\n':
+		if (O_ONLRET(tty))
+			tty->column = 0;
+		if (O_ONLCR(tty)) {
+			if (space < 2)
+				return -1;
 			tty->canon_column = tty->column = 0;
+			tty_put_char(tty, '\r');
+			tty_put_char(tty, c);
+			return 2;
+		}
+		tty->canon_column = tty->column;
+		break;
+	case '\r':
+		if (O_ONOCR(tty) && tty->column == 0)
+			return 0;
+		if (O_OCRNL(tty)) {
+			c = '\n';
+			if (O_ONLRET(tty))
+				tty->canon_column = tty->column = 0;
 			break;
-		case '\t':
-			spaces = 8 - (tty->column & 7);
-			if (O_TABDLY(tty) == XTABS) {
-				if (space < spaces) {
-					unlock_kernel();
-					return -1;
-				}
-				tty->column += spaces;
-				tty->ops->write(tty, "        ", spaces);
-				unlock_kernel();
-				return 0;
-			}
+		}
+		tty->canon_column = tty->column = 0;
+		break;
+	case '\t':
+		spaces = 8 - (tty->column & 7);
+		if (O_TABDLY(tty) == XTABS) {
+			if (space < spaces)
+				return -1;
 			tty->column += spaces;
-			break;
-		case '\b':
-			if (tty->column > 0)
-				tty->column--;
-			break;
-		default:
-			if (O_OLCUC(tty))
-				c = toupper(c);
-			if (!iscntrl(c) && !is_continuation(c, tty))
-				tty->column++;
-			break;
+			tty->ops->write(tty, "        ", spaces);
+			return spaces;
 		}
+		tty->column += spaces;
+		break;
+	case '\b':
+		if (tty->column > 0)
+			tty->column--;
+		break;
+	default:
+		if (O_OLCUC(tty))
+			c = toupper(c);
+		if (!iscntrl(c) && !is_continuation(c, tty))
+			tty->column++;
+		break;
 	}
+
 	tty_put_char(tty, c);
+	return 1;
+}
+
+/**
+ *	process_output			-	output post processor
+ *	@c: character (or partial unicode symbol)
+ *	@tty: terminal device
+ *
+ *	Perform OPOST processing.  Returns -1 when the output device is
+ *	full and the character must be retried.
+ *
+ *	Called from both the receive and transmit sides and can be called
+ *	re-entrantly.  Relies on lock_kernel for tty->column state.
+ *	Since we rely on lock_kernel to prevent the tty_write_room from
+ *	changing after it is obtained, an alternate means to ensure this
+ *	would need to be implemented if the locking mechanism changed.
+ */
+
+static int process_output(unsigned char c, struct tty_struct *tty)
+{
+	int	space, retval;
+
+	lock_kernel();
+
+	space = tty_write_room(tty);
+	retval = do_output_char(c, tty, space);
+
 	unlock_kernel();
-	return 0;
+	if (retval < 0)
+		return -1;
+	else
+		return 0;
 }
 
 /**
- *	opost_block		-	block postprocess
+ *	process_output_block		-	block post processor
  *	@tty: terminal device
  *	@inbuf: user buffer
  *	@nr: number of bytes
@@ -346,24 +390,31 @@ static int opost(unsigned char c, struct
  *	the simple cases normally found and helps to generate blocks of
  *	symbols for the console driver and thus improve performance.
  *
- *	Called from write_chan under the tty layer write lock. Relies
- *	on lock_kernel for the tty->column state.
+ *	Called from write_chan under the tty layer write lock.
+ *	Relies on lock_kernel for the tty->column state.
+ *	Since we rely on lock_kernel to prevent the tty_write_room from
+ *	changing after it is obtained, an alternate means to ensure this
+ *	would need to be implemented if the locking mechanism changed.
  */
 
-static ssize_t opost_block(struct tty_struct *tty,
-		       const unsigned char *buf, unsigned int nr)
+static ssize_t process_output_block(struct tty_struct *tty,
+				    const unsigned char *buf, unsigned int nr)
 {
 	int	space;
 	int 	i;
 	const unsigned char *cp;
 
+	lock_kernel();
+
 	space = tty_write_room(tty);
 	if (!space)
+	{
+		unlock_kernel();
 		return 0;
+	}
 	if (nr > space)
 		nr = space;
 
-	lock_kernel();
 	for (i = 0, cp = buf; i < nr; i++, cp++) {
 		switch (*cp) {
 		case '\n':
@@ -395,38 +446,349 @@ static ssize_t opost_block(struct tty_st
 		}
 	}
 break_out:
-	if (tty->ops->flush_chars)
-		tty->ops->flush_chars(tty);
+	//if (tty->ops->flush_chars)
+	//	tty->ops->flush_chars(tty);
 	i = tty->ops->write(tty, buf, i);
+
 	unlock_kernel();
 	return i;
 }
 
+/**
+ *	process_echoes	-	write pending echoed characters
+ *	@tty: terminal device
+ *
+ *	Write echoed (and other ldisc-generated) characters to the
+ *	tty that have been stored previously in the echo buffer.
+ *
+ *	Characters generated by the ldisc (including echoes) need to
+ *	be buffered because the driver's write buffer can fill during
+ *	heavy program output.  Echoing straight to the driver will
+ *	often fail under these conditions, causing lost characters and
+ *	resulting mismatches of ldisc state information.
+ *
+ *	Since the ldisc state must represent the characters actually sent
+ *	to the driver at the time of the write, operations like certain
+ *	changes in column state are also saved in the buffer and executed
+ *	here.
+ *
+ *	A circular fifo buffer is used so that the most recent characters
+ *	are prioritized.  Also, when control characters are echoed with a
+ *	prefixed "^", the pair is treated atomically and thus not separated.
+ *
+ *	Like the process_output functions, this relies on lock_kernel.
+ *	If this lock is ever removed, we should make sure this function
+ *	is locked against other code that currently uses echo_lock,
+ *	and we should also lock against normal tty output done in
+ *	write_chan (so the control pairs do not get separated).  Also,
+ *	since we rely on lock_kernel to prevent the tty_write_room from
+ *	changing after it is obtained, an alternate means to ensure this
+ *	would need to be implemented if the locking mechanism changed.
+ */
+
+static void process_echoes(struct tty_struct *tty)
+{
+	int	space, num, nr;
+	unsigned char c;
+	unsigned char *cp, *buf_end;
+
+	if (!(num = tty->echo_cnt))
+		return;
+
+	lock_kernel();
+
+	space = tty_write_room(tty);
+
+	buf_end = tty->echo_buf + N_TTY_BUF_SIZE;
+	cp = tty->echo_buf + tty->echo_pos;
+	nr = num;
+	while (nr > 0) {
+		c = *cp;
+		if (c == ECHO_OP_START) {
+			unsigned char op;
+			unsigned char *opp;
+			int no_space_left = 0;
+
+			/*
+			 * If the buffer byte is the start of a multi-byte
+			 * operation, get the next byte, which is either the
+			 * op code or a control character value.
+			 */
+			opp = cp + 1;
+			if (opp == buf_end)
+				opp -= N_TTY_BUF_SIZE;
+			op = *opp;
+
+			switch (op) {
+				unsigned char lbyte, hbyte;
+				unsigned short rdiff;
+				int num_bs;
+				unsigned int col;
+
+			case ECHO_OP_TAB_ERASE:
+				/* Extract rdiff value from next two bytes */
+				if (++opp == buf_end)
+					opp -= N_TTY_BUF_SIZE;
+				lbyte = *opp;
+				if (++opp == buf_end)
+					opp -= N_TTY_BUF_SIZE;
+				hbyte = *opp;
+				rdiff = (hbyte << 8) | lbyte;
+
+				col = tty->canon_column + rdiff;
+
+				/* should never happen */
+				if (tty->column > 0x80000000)
+					tty->column = 0;
+
+				num_bs = tty->column - col;
+				if (num_bs < 0)
+					num_bs = 0;
+				if (num_bs > space) {
+					no_space_left = 1;
+					break;
+				}
+
+				/* Now backup to that column. */
+				while (tty->column > col) {
+					tty_put_char(tty, '\b');
+					if (tty->column > 0)
+						tty->column--;
+				}
+				space -= num_bs;
+				cp += 4;
+				nr -= 4;
+				break;
+
+			case ECHO_OP_SET_CANON_COL:
+				tty->canon_column = tty->column;
+				cp += 2;
+				nr -= 2;
+				break;
+
+			case ECHO_OP_MOVE_BACK_COL:
+				if (tty->column > 0)
+					tty->column--;
+				cp += 2;
+				nr -= 2;
+				break;
+
+			case ECHO_OP_START:
+				/* This is an escaped echo op start code */
+				if (!space) {
+					no_space_left = 1;
+					break;
+				}
+				tty_put_char(tty, ECHO_OP_START);
+				tty->column++;
+				space--;
+				cp += 2;
+				nr -= 2;
+				break;
+
+			default:
+				if (iscntrl(op)) {
+					if (L_ECHOCTL(tty)) {
+						/*
+						 * Ensure there is enough space
+						 * for the whole ctrl pair.
+						 */
+						if (space < 2) {
+							no_space_left = 1;
+							break;
+						}
+						tty_put_char(tty, '^');
+						tty_put_char(tty, op ^ 0100);
+						tty->column += 2;
+						space -= 2;
+					} else {
+						if (!space) {
+							no_space_left = 1;
+							break;
+						}
+						tty_put_char(tty, op);
+						space--;
+					}
+				}
+				/*
+				 * If above falls through, this was an
+				 * undefined op.
+				 */
+				cp += 2;
+				nr -= 2;
+			}
+
+			if (no_space_left)
+				break;
+		} else {
+			int retval;
+
+			if ((retval = do_output_char(c, tty, space)) < 0)
+				break;
+			space -= retval;
+			cp += 1;
+			nr -= 1;
+		}
+
+		/* When end of circular buffer reached, wrap around */
+		if (cp >= buf_end)
+			cp -= N_TTY_BUF_SIZE;
+	}
+
+	tty->echo_cnt = nr;
+	if (tty->echo_cnt == 0) {
+		tty->echo_pos = 0;
+		tty->echo_overrun = 0;
+	} else {
+		int num_processed = (num - nr);
+		tty->echo_pos += num_processed;
+		tty->echo_pos &= (N_TTY_BUF_SIZE - 1);
+		if (num_processed > 0)
+			tty->echo_overrun = 0;
+	}
+
+	unlock_kernel();
+
+	if (tty->ops->flush_chars)
+		tty->ops->flush_chars(tty);
+}
 
 /**
- *	echo_char	-	echo characters
+ *	add_echo_byte	-	add a byte to the echo buffer
+ *	@c: unicode byte to echo
+ *	@tty: terminal device
+ *
+ *	Add a character or operation byte to the echo buffer.
+ */
+
+static void add_echo_byte(unsigned char c, struct tty_struct *tty)
+{
+	int 	add_char_pos;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->echo_lock, flags);
+
+	add_char_pos = tty->echo_pos + tty->echo_cnt;
+	if (add_char_pos >= N_TTY_BUF_SIZE)
+		add_char_pos -= N_TTY_BUF_SIZE;
+
+	/* Detect overrun */
+	if (tty->echo_cnt == N_TTY_BUF_SIZE) {
+		/*
+		 * If the start position pointer needs to be advanced
+		 * due to running out of buffer space, be sure it is
+		 * done in such a way as to remove whole
+		 * operation byte groups.
+		 */
+		if (*(tty->echo_buf +
+		      (tty->echo_pos & (N_TTY_BUF_SIZE - 1))) == ECHO_OP_START)
+		{
+			if (*(tty->echo_buf +
+			      ((tty->echo_pos + 1) & (N_TTY_BUF_SIZE - 1))) == ECHO_OP_TAB_ERASE) {
+				tty->echo_pos += 4;
+				tty->echo_cnt -= 3;
+			} else {
+				tty->echo_pos += 2;
+				tty->echo_cnt -= 1;
+			}
+		} else
+			tty->echo_pos++;
+		tty->echo_pos &= (N_TTY_BUF_SIZE - 1);
+		tty->echo_overrun = 1;
+	} else
+		tty->echo_cnt++;
+
+	tty->echo_buf[add_char_pos] = c;
+
+	spin_unlock_irqrestore(&tty->echo_lock, flags);
+}
+
+/**
+ *	echo_move_back_col	-	add operation to move back a column
+ *	@tty: terminal device
+ *
+ *	Add an operation to the echo buffer to move back one column.
+ */
+
+static void echo_move_back_col(struct tty_struct *tty)
+{
+	add_echo_byte(ECHO_OP_START, tty);
+	add_echo_byte(ECHO_OP_MOVE_BACK_COL, tty);
+}
+
+/**
+ *	echo_set_canon_col	-	add operation to set the canon column
+ *	@tty: terminal device
+ *
+ *	Add an operation to the echo buffer to set the canon column
+ *	to the current column.
+ */
+
+static void echo_set_canon_col(struct tty_struct *tty)
+{
+	add_echo_byte(ECHO_OP_START, tty);
+	add_echo_byte(ECHO_OP_SET_CANON_COL, tty);
+}
+
+/**
+ *	echo_tab_erase	-	add operation to erase tabs
+ *	@tty: terminal device
+ *
+ *	Add an operation to the echo buffer to set the canon column
+ *	to the current column.
+ */
+
+static void echo_tab_erase(unsigned short rdiff, struct tty_struct *tty)
+{
+	add_echo_byte(ECHO_OP_START, tty);
+	add_echo_byte(ECHO_OP_TAB_ERASE, tty);
+	add_echo_byte(rdiff & 0xff, tty);
+	add_echo_byte(rdiff >> 8, tty);
+}
+
+/**
+ *	echo_char_raw	-	echo a character raw
  *	@c: unicode byte to echo
  *	@tty: terminal device
  *
  *	Echo user input back onto the screen. This must be called only when
  *	L_ECHO(tty) is true. Called from the driver receive_buf path.
+ *
+ *	This variant does not treat control characters specially.
  */
 
-static void echo_char(unsigned char c, struct tty_struct *tty)
+static void echo_char_raw(unsigned char c, struct tty_struct *tty)
 {
-	if (L_ECHOCTL(tty) && iscntrl(c) && c != '\t') {
-		tty_put_char(tty, '^');
-		tty_put_char(tty, c ^ 0100);
-		tty->column += 2;
+	if (c == ECHO_OP_START) {
+		add_echo_byte(ECHO_OP_START, tty);
+		add_echo_byte(ECHO_OP_START, tty);
 	} else
-		opost(c, tty);
+		add_echo_byte(c, tty);
+}
+
+/**
+ *	echo_char	-	echo a character
+ *	@c: unicode byte to echo
+ *	@tty: terminal device
+ *
+ *	Echo user input back onto the screen. This must be called only when
+ *	L_ECHO(tty) is true. Called from the driver receive_buf path.
+ *
+ *	This variant tags control characters to be possibly echoed as
+ *	as "^X" (where X is the letter representing the control char).
+ */
+
+static void echo_char(unsigned char c, struct tty_struct *tty)
+{
+	if (iscntrl(c) && c != '\t')
+		add_echo_byte(ECHO_OP_START, tty);
+	echo_char_raw(c, tty);
 }
 
 static inline void finish_erasing(struct tty_struct *tty)
 {
 	if (tty->erasing) {
-		tty_put_char(tty, '/');
-		tty->column++;
+		echo_char_raw('/', tty);
 		tty->erasing = 0;
 	}
 }
@@ -448,7 +810,7 @@ static void eraser(unsigned char c, stru
 	unsigned long flags;
 
 	if (tty->read_head == tty->canon_head) {
-		/* opost('\a', tty); */		/* what do you think? */
+		/* echo_char_raw('\a', tty); */ /* what do you think? */
 		return;
 	}
 	if (c == ERASE_CHAR(tty))
@@ -474,7 +836,7 @@ static void eraser(unsigned char c, stru
 			echo_char(KILL_CHAR(tty), tty);
 			/* Add a newline if ECHOK is on and ECHOKE is off. */
 			if (L_ECHOK(tty))
-				opost('\n', tty);
+				echo_char_raw('\n', tty);
 			return;
 		}
 		kill_type = KILL;
@@ -509,67 +871,58 @@ static void eraser(unsigned char c, stru
 		if (L_ECHO(tty)) {
 			if (L_ECHOPRT(tty)) {
 				if (!tty->erasing) {
-					tty_put_char(tty, '\\');
-					tty->column++;
+					echo_char_raw('\\', tty);
 					tty->erasing = 1;
 				}
 				/* if cnt > 1, output a multi-byte character */
 				echo_char(c, tty);
 				while (--cnt > 0) {
 					head = (head+1) & (N_TTY_BUF_SIZE-1);
-					tty_put_char(tty, tty->read_buf[head]);
+					echo_char_raw(tty->read_buf[head], tty);
+					echo_move_back_col(tty);
 				}
 			} else if (kill_type == ERASE && !L_ECHOE(tty)) {
 				echo_char(ERASE_CHAR(tty), tty);
 			} else if (c == '\t') {
-				unsigned int col = tty->canon_column;
+				unsigned short rdiff = 0;
 				unsigned long tail = tty->canon_head;
 
-				/* Find the column of the last char. */
+				/*
+				 * Find number of columns from canon_head
+				 * to read_head.  This will later be
+				 * added to the canon_column to determine
+				 * how far to erase up to the cur column.
+				 */
 				while (tail != tty->read_head) {
 					c = tty->read_buf[tail];
 					if (c == '\t')
-						col = (col | 7) + 1;
+						rdiff = (rdiff | 7) + 1;
 					else if (iscntrl(c)) {
 						if (L_ECHOCTL(tty))
-							col += 2;
+							rdiff += 2;
 					} else if (!is_continuation(c, tty))
-						col++;
+						rdiff++;
 					tail = (tail+1) & (N_TTY_BUF_SIZE-1);
 				}
 
-				/* should never happen */
-				if (tty->column > 0x80000000)
-					tty->column = 0;
-
-				/* Now backup to that column. */
-				while (tty->column > col) {
-					/* Can't use opost here. */
-					tty_put_char(tty, '\b');
-					if (tty->column > 0)
-						tty->column--;
-				}
+				echo_tab_erase(rdiff, tty);
 			} else {
 				if (iscntrl(c) && L_ECHOCTL(tty)) {
-					tty_put_char(tty, '\b');
-					tty_put_char(tty, ' ');
-					tty_put_char(tty, '\b');
-					if (tty->column > 0)
-						tty->column--;
+					echo_char_raw('\b', tty);
+					echo_char_raw(' ', tty);
+					echo_char_raw('\b', tty);
 				}
 				if (!iscntrl(c) || L_ECHOCTL(tty)) {
-					tty_put_char(tty, '\b');
-					tty_put_char(tty, ' ');
-					tty_put_char(tty, '\b');
-					if (tty->column > 0)
-						tty->column--;
+					echo_char_raw('\b', tty);
+					echo_char_raw(' ', tty);
+					echo_char_raw('\b', tty);
 				}
 			}
 		}
 		if (kill_type == ERASE)
 			break;
 	}
-	if (tty->read_head == tty->canon_head)
+	if (tty->read_head == tty->canon_head && L_ECHO(tty))
 		finish_erasing(tty);
 }
 
@@ -698,14 +1051,18 @@ static inline void n_tty_receive_char(st
 		c=tolower(c);
 
 	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) &&
-	    ((I_IXANY(tty) && c != START_CHAR(tty) && c != STOP_CHAR(tty)) ||
-	     c == INTR_CHAR(tty) || c == QUIT_CHAR(tty) || c == SUSP_CHAR(tty)))
+	    I_IXANY(tty) && c != START_CHAR(tty) && c != STOP_CHAR(tty) &&
+	    c != INTR_CHAR(tty) && c != QUIT_CHAR(tty) && c != SUSP_CHAR(tty)) {
 		start_tty(tty);
+		process_echoes(tty);
+	}
 
 	if (tty->closing) {
 		if (I_IXON(tty)) {
-			if (c == START_CHAR(tty))
+			if (c == START_CHAR(tty)) {
 				start_tty(tty);
+				process_echoes(tty);
+			}
 			else if (c == STOP_CHAR(tty))
 				stop_tty(tty);
 		}
@@ -719,17 +1076,20 @@ static inline void n_tty_receive_char(st
 	 * up.
 	 */
 	if (!test_bit(c, tty->process_char_map) || tty->lnext) {
-		finish_erasing(tty);
 		tty->lnext = 0;
 		if (L_ECHO(tty)) {
+			finish_erasing(tty);
 			if (tty->read_cnt >= N_TTY_BUF_SIZE-1) {
-				tty_put_char(tty, '\a'); /* beep if no space */
+				/* beep if no space */
+				echo_char_raw('\a', tty);
+				process_echoes(tty);
 				return;
 			}
 			/* Record the column of first canon char. */
 			if (tty->canon_head == tty->read_head)
-				tty->canon_column = tty->column;
+				echo_set_canon_col(tty);
 			echo_char(c, tty);
+			process_echoes(tty);
 		}
 		if (I_PARMRK(tty) && c == (unsigned char) '\377')
 			put_tty_queue(c, tty);
@@ -740,6 +1100,7 @@ static inline void n_tty_receive_char(st
 	if (I_IXON(tty)) {
 		if (c == START_CHAR(tty)) {
 			start_tty(tty);
+			process_echoes(tty);
 			return;
 		}
 		if (c == STOP_CHAR(tty)) {
@@ -760,7 +1121,6 @@ static inline void n_tty_receive_char(st
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
 			/*
-			 * Echo character, and then send the signal.
 			 * Note that we do not use isig() here because we want
 			 * the order to be:
 			 * 1) flush, 2) echo, 3) signal
@@ -769,8 +1129,12 @@ send_signal:
 				n_tty_flush_buffer(tty);
 				tty_driver_flush_buffer(tty);
 			}
-			if (L_ECHO(tty))
+			if (I_IXON(tty))
+				start_tty(tty);
+			if (L_ECHO(tty)) {
 				echo_char(c, tty);
+				process_echoes(tty);
+			}
 			if (tty->pgrp)
 				kill_pgrp(tty->pgrp, signal, 1);
 			return;
@@ -789,6 +1153,7 @@ send_signal:
 		if (c == ERASE_CHAR(tty) || c == KILL_CHAR(tty) ||
 		    (c == WERASE_CHAR(tty) && L_IEXTEN(tty))) {
 			eraser(c, tty);
+			process_echoes(tty);
 			return;
 		}
 		if (c == LNEXT_CHAR(tty) && L_IEXTEN(tty)) {
@@ -796,8 +1161,9 @@ send_signal:
 			if (L_ECHO(tty)) {
 				finish_erasing(tty);
 				if (L_ECHOCTL(tty)) {
-					tty_put_char(tty, '^');
-					tty_put_char(tty, '\b');
+					echo_char_raw('^', tty);
+					echo_char_raw('\b', tty);
+					process_echoes(tty);
 				}
 			}
 			return;
@@ -808,18 +1174,20 @@ send_signal:
 
 			finish_erasing(tty);
 			echo_char(c, tty);
-			opost('\n', tty);
+			echo_char_raw('\n', tty);
 			while (tail != tty->read_head) {
 				echo_char(tty->read_buf[tail], tty);
 				tail = (tail+1) & (N_TTY_BUF_SIZE-1);
 			}
+			process_echoes(tty);
 			return;
 		}
 		if (c == '\n') {
 			if (L_ECHO(tty) || L_ECHONL(tty)) {
 				if (tty->read_cnt >= N_TTY_BUF_SIZE-1)
-					tty_put_char(tty, '\a');
-				opost('\n', tty);
+					echo_char_raw('\a', tty);
+				echo_char_raw('\n', tty);
+				process_echoes(tty);
 			}
 			goto handle_newline;
 		}
@@ -836,11 +1204,12 @@ send_signal:
 			 */
 			if (L_ECHO(tty)) {
 				if (tty->read_cnt >= N_TTY_BUF_SIZE-1)
-					tty_put_char(tty, '\a');
+					echo_char_raw('\a', tty);
 				/* Record the column of first canon char. */
 				if (tty->canon_head == tty->read_head)
-					tty->canon_column = tty->column;
+					echo_set_canon_col(tty);
 				echo_char(c, tty);
+				process_echoes(tty);
 			}
 			/*
 			 * XXX does PARMRK doubling happen for
@@ -863,20 +1232,23 @@ handle_newline:
 		}
 	}
 
-	finish_erasing(tty);
 	if (L_ECHO(tty)) {
+		finish_erasing(tty);
 		if (tty->read_cnt >= N_TTY_BUF_SIZE-1) {
-			tty_put_char(tty, '\a'); /* beep if no space */
+			/* beep if no space */
+			echo_char_raw('\a', tty);
+			process_echoes(tty);
 			return;
 		}
 		if (c == '\n')
-			opost('\n', tty);
+			echo_char_raw('\n', tty);
 		else {
 			/* Record the column of first canon char. */
 			if (tty->canon_head == tty->read_head)
-				tty->canon_column = tty->column;
+				echo_set_canon_col(tty);
 			echo_char(c, tty);
 		}
+		process_echoes(tty);
 	}
 
 	if (I_PARMRK(tty) && c == (unsigned char) '\377')
@@ -897,6 +1269,9 @@ handle_newline:
 
 static void n_tty_write_wakeup(struct tty_struct *tty)
 {
+	/* Write out any echoed characters that are still pending */
+	process_echoes(tty);
+
 	if (tty->fasync) {
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 		kill_fasync(&tty->fasync, SIGIO, POLL_OUT);
@@ -1094,6 +1469,10 @@ static void n_tty_close(struct tty_struc
 		free_buf(tty->read_buf);
 		tty->read_buf = NULL;
 	}
+	if (tty->echo_buf) {
+		free_buf(tty->echo_buf);
+		tty->echo_buf = NULL;
+	}
 }
 
 /**
@@ -1111,13 +1490,19 @@ static int n_tty_open(struct tty_struct 
 	if (!tty)
 		return -EINVAL;
 
-	/* This one is ugly. Currently a malloc failure here can panic */
+	/* These are ugly. Currently a malloc failure here can panic */
 	if (!tty->read_buf) {
 		tty->read_buf = alloc_buf();
 		if (!tty->read_buf)
 			return -ENOMEM;
 	}
+	if (!tty->echo_buf) {
+		tty->echo_buf = alloc_buf();
+		if (!tty->echo_buf)
+			return -ENOMEM;
+	}
 	memset(tty->read_buf, 0, N_TTY_BUF_SIZE);
+	memset(tty->echo_buf, 0, N_TTY_BUF_SIZE);
 	reset_buffer_flags(tty);
 	tty->column = 0;
 	n_tty_set_termios(tty, NULL);
@@ -1473,6 +1858,9 @@ static ssize_t write_chan(struct tty_str
 			return retval;
 	}
 
+	/* Write out any echoed characters that are still pending */
+	process_echoes(tty);
+
 	add_wait_queue(&tty->write_wait, &wait);
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -1486,7 +1874,7 @@ static ssize_t write_chan(struct tty_str
 		}
 		if (O_OPOST(tty) && !(test_bit(TTY_HW_COOK_OUT, &tty->flags))) {
 			while (nr > 0) {
-				ssize_t num = opost_block(tty, b, nr);
+				ssize_t num = process_output_block(tty, b, nr);
 				if (num < 0) {
 					if (num == -EAGAIN)
 						break;
@@ -1498,7 +1886,7 @@ static ssize_t write_chan(struct tty_str
 				if (nr == 0)
 					break;
 				c = *b;
-				if (opost(c, tty) < 0)
+				if (process_output(c, tty) < 0)
 					break;
 				b++; nr--;
 			}
diff -puN drivers/char/tty_io.c~tty-fix-loss-of-echoed-characters drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-fix-loss-of-echoed-characters
+++ a/drivers/char/tty_io.c
@@ -2815,6 +2815,7 @@ static void initialize_tty_struct(struct
 	mutex_init(&tty->atomic_write_lock);
 	spin_lock_init(&tty->read_lock);
 	spin_lock_init(&tty->ctrl_lock);
+	spin_lock_init(&tty->echo_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
 	INIT_WORK(&tty->SAK_work, do_SAK_work);
 }
diff -puN drivers/char/vt.c~tty-fix-loss-of-echoed-characters drivers/char/vt.c
--- a/drivers/char/vt.c~tty-fix-loss-of-echoed-characters
+++ a/drivers/char/vt.c
@@ -2674,7 +2674,7 @@ static int con_write_room(struct tty_str
 {
 	if (tty->stopped)
 		return 0;
-	return 4096;		/* No limit, really; we're not buffering */
+	return 32768;		/* No limit, really; we're not buffering */
 }
 
 static int con_chars_in_buffer(struct tty_struct *tty)
diff -puN include/linux/tty.h~tty-fix-loss-of-echoed-characters include/linux/tty.h
--- a/include/linux/tty.h~tty-fix-loss-of-echoed-characters
+++ a/include/linux/tty.h
@@ -253,6 +253,7 @@ struct tty_struct {
 	unsigned int column;
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
 	unsigned char closing:1;
+	unsigned char echo_overrun:1;
 	unsigned short minimum_to_wake;
 	unsigned long overrun_time;
 	int num_overrun;
@@ -262,6 +263,9 @@ struct tty_struct {
 	int read_tail;
 	int read_cnt;
 	unsigned long read_flags[N_TTY_BUF_SIZE/(8*sizeof(unsigned long))];
+	unsigned char *echo_buf;
+	unsigned int echo_pos;
+	unsigned int echo_cnt;
 	int canon_data;
 	unsigned long canon_head;
 	unsigned int canon_column;
@@ -270,6 +274,7 @@ struct tty_struct {
 	unsigned char *write_buf;
 	int write_cnt;
 	spinlock_t read_lock;
+	spinlock_t echo_lock;
 	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
 	struct tty_port *port;
_

Patches currently in -mm which might be from joe@skyrush.com are

tty-fix-loss-of-echoed-characters.patch
tty-minor-code-efficiency-and-style-cleanup.patch

