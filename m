From: akpm@osdl.org
Subject: - tty-switch-to-ktermios-and-new-framework.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:19 -0800
Message-ID: <200612082008.kB8K8JiC002600@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58216 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946078AbWLHUIe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty: switch to ktermios and new framework
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios-and-new-framework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: switch to ktermios and new framework
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This is the core of the switch to the new framework.  I've split it from the
driver patches which are mostly search/replace and would encourage people to
give this one a good hard stare.

The references to BOTHER and ISHIFT are the termios values that must be
defined by a platform once it wants to turn on "new style" ioctl support.  The
code patches here ensure that providing

1. The termios overlays the ktermios in memory
2. The only new kernel only fields are c_ispeed/c_ospeed (or none)

the existing behaviour is retained.  This is true for the patches at this
point in time.

Future patches will define BOTHER, ISHIFT and enable newer termios structures
for each architecture, and once they are all done some of the ifdefs also
vanish.

[akpm@osdl.org: warning fix]
[akpm@osdl.org: IRDA fix]
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c              |  137 +++-----------
 drivers/char/tty_ioctl.c           |  258 +++++++++++++++++++++++++--
 include/linux/tty.h                |    9 
 include/linux/tty_driver.h         |   12 -
 include/linux/tty_ldisc.h          |    4 
 include/net/irda/ircomm_tty.h      |    2 
 net/irda/ircomm/ircomm_tty_ioctl.c |    2 
 7 files changed, 297 insertions(+), 127 deletions(-)

diff -puN drivers/char/tty_io.c~tty-switch-to-ktermios-and-new-framework drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-switch-to-ktermios-and-new-framework
+++ a/drivers/char/tty_io.c
@@ -109,13 +109,15 @@
 #define TTY_PARANOIA_CHECK 1
 #define CHECK_TTY_COUNT 1
 
-struct termios tty_std_termios = {	/* for the benefit of tty drivers  */
+struct ktermios tty_std_termios = {	/* for the benefit of tty drivers  */
 	.c_iflag = ICRNL | IXON,
 	.c_oflag = OPOST | ONLCR,
 	.c_cflag = B38400 | CS8 | CREAD | HUPCL,
 	.c_lflag = ISIG | ICANON | ECHO | ECHOE | ECHOK |
 		   ECHOCTL | ECHOKE | IEXTEN,
-	.c_cc = INIT_C_CC
+	.c_cc = INIT_C_CC,
+	.c_ispeed = 38400,
+	.c_ospeed = 38400
 };
 
 EXPORT_SYMBOL(tty_std_termios);
@@ -1239,6 +1241,22 @@ void tty_ldisc_flush(struct tty_struct *
 }
 
 EXPORT_SYMBOL_GPL(tty_ldisc_flush);
+
+/**
+ *	tty_reset_termios	-	reset terminal state
+ *	@tty: tty to reset
+ *
+ *	Restore a terminal to the driver default state
+ */
+
+static void tty_reset_termios(struct tty_struct *tty)
+{
+	mutex_lock(&tty->termios_mutex);
+	*tty->termios = tty->driver->init_termios;
+	tty->termios->c_ispeed = tty_termios_input_baud_rate(tty->termios);
+	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
+	mutex_unlock(&tty->termios_mutex);
+}
 	
 /**
  *	do_tty_hangup		-	actual handler for hangup events
@@ -1327,11 +1345,7 @@ static void do_tty_hangup(struct work_st
 	 * N_TTY.
 	 */
 	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS)
-	{
-		mutex_lock(&tty->termios_mutex);
-		*tty->termios = tty->driver->init_termios;
-		mutex_unlock(&tty->termios_mutex);
-	}
+		tty_reset_termios(tty);
 	
 	/* Defer ldisc switch */
 	/* tty_deferred_ldisc_switch(N_TTY);
@@ -1870,8 +1884,8 @@ static int init_dev(struct tty_driver *d
 	struct tty_struct **ret_tty)
 {
 	struct tty_struct *tty, *o_tty;
-	struct termios *tp, **tp_loc, *o_tp, **o_tp_loc;
-	struct termios *ltp, **ltp_loc, *o_ltp, **o_ltp_loc;
+	struct ktermios *tp, **tp_loc, *o_tp, **o_tp_loc;
+	struct ktermios *ltp, **ltp_loc, *o_ltp, **o_ltp_loc;
 	int retval = 0;
 
 	/* check whether we're reopening an existing tty */
@@ -1918,7 +1932,7 @@ static int init_dev(struct tty_driver *d
 	}
 
 	if (!*tp_loc) {
-		tp = (struct termios *) kmalloc(sizeof(struct termios),
+		tp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
 						GFP_KERNEL);
 		if (!tp)
 			goto free_mem_out;
@@ -1926,11 +1940,11 @@ static int init_dev(struct tty_driver *d
 	}
 
 	if (!*ltp_loc) {
-		ltp = (struct termios *) kmalloc(sizeof(struct termios),
+		ltp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
 						 GFP_KERNEL);
 		if (!ltp)
 			goto free_mem_out;
-		memset(ltp, 0, sizeof(struct termios));
+		memset(ltp, 0, sizeof(struct ktermios));
 	}
 
 	if (driver->type == TTY_DRIVER_TYPE_PTY) {
@@ -1951,19 +1965,19 @@ static int init_dev(struct tty_driver *d
 		}
 
 		if (!*o_tp_loc) {
-			o_tp = (struct termios *)
-				kmalloc(sizeof(struct termios), GFP_KERNEL);
+			o_tp = (struct ktermios *)
+				kmalloc(sizeof(struct ktermios), GFP_KERNEL);
 			if (!o_tp)
 				goto free_mem_out;
 			*o_tp = driver->other->init_termios;
 		}
 
 		if (!*o_ltp_loc) {
-			o_ltp = (struct termios *)
-				kmalloc(sizeof(struct termios), GFP_KERNEL);
+			o_ltp = (struct ktermios *)
+				kmalloc(sizeof(struct ktermios), GFP_KERNEL);
 			if (!o_ltp)
 				goto free_mem_out;
-			memset(o_ltp, 0, sizeof(struct termios));
+			memset(o_ltp, 0, sizeof(struct ktermios));
 		}
 
 		/*
@@ -2002,6 +2016,9 @@ static int init_dev(struct tty_driver *d
 		*ltp_loc = ltp;
 	tty->termios = *tp_loc;
 	tty->termios_locked = *ltp_loc;
+	/* Compatibility until drivers always set this */
+	tty->termios->c_ispeed = tty_termios_input_baud_rate(tty->termios);
+	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
 	driver->refcount++;
 	tty->count++;
 
@@ -2104,7 +2121,7 @@ release_mem_out:
 static void release_mem(struct tty_struct *tty, int idx)
 {
 	struct tty_struct *o_tty;
-	struct termios *tp;
+	struct ktermios *tp;
 	int devpts = tty->driver->flags & TTY_DRIVER_DEVPTS_MEM;
 
 	if ((o_tty = tty->link) != NULL) {
@@ -3458,84 +3475,6 @@ static void flush_to_ldisc(struct work_s
 	tty_ldisc_deref(disc);
 }
 
-/*
- * Routine which returns the baud rate of the tty
- *
- * Note that the baud_table needs to be kept in sync with the
- * include/asm/termbits.h file.
- */
-static int baud_table[] = {
-	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
-	9600, 19200, 38400, 57600, 115200, 230400, 460800,
-#ifdef __sparc__
-	76800, 153600, 307200, 614400, 921600
-#else
-	500000, 576000, 921600, 1000000, 1152000, 1500000, 2000000,
-	2500000, 3000000, 3500000, 4000000
-#endif
-};
-
-static int n_baud_table = ARRAY_SIZE(baud_table);
-
-/**
- *	tty_termios_baud_rate
- *	@termios: termios structure
- *
- *	Convert termios baud rate data into a speed. This should be called
- *	with the termios lock held if this termios is a terminal termios
- *	structure. May change the termios data.
- *
- *	Locking: none
- */
- 
-int tty_termios_baud_rate(struct termios *termios)
-{
-	unsigned int cbaud;
-	
-	cbaud = termios->c_cflag & CBAUD;
-
-	if (cbaud & CBAUDEX) {
-		cbaud &= ~CBAUDEX;
-
-		if (cbaud < 1 || cbaud + 15 > n_baud_table)
-			termios->c_cflag &= ~CBAUDEX;
-		else
-			cbaud += 15;
-	}
-	return baud_table[cbaud];
-}
-
-EXPORT_SYMBOL(tty_termios_baud_rate);
-
-/**
- *	tty_get_baud_rate	-	get tty bit rates
- *	@tty: tty to query
- *
- *	Returns the baud rate as an integer for this terminal. The
- *	termios lock must be held by the caller and the terminal bit
- *	flags may be updated.
- *
- *	Locking: none
- */
- 
-int tty_get_baud_rate(struct tty_struct *tty)
-{
-	int baud = tty_termios_baud_rate(tty->termios);
-
-	if (baud == 38400 && tty->alt_speed) {
-		if (!tty->warned) {
-			printk(KERN_WARNING "Use of setserial/setrocket to "
-					    "set SPD_* flags is deprecated\n");
-			tty->warned = 1;
-		}
-		baud = tty->alt_speed;
-	}
-	
-	return baud;
-}
-
-EXPORT_SYMBOL(tty_get_baud_rate);
-
 /**
  *	tty_flip_buffer_push	-	terminal
  *	@tty: tty to push
@@ -3758,8 +3697,8 @@ int tty_register_driver(struct tty_drive
 
 	if (p) {
 		driver->ttys = (struct tty_struct **)p;
-		driver->termios = (struct termios **)(p + driver->num);
-		driver->termios_locked = (struct termios **)(p + driver->num * 2);
+		driver->termios = (struct ktermios **)(p + driver->num);
+		driver->termios_locked = (struct ktermios **)(p + driver->num * 2);
 	} else {
 		driver->ttys = NULL;
 		driver->termios = NULL;
@@ -3798,7 +3737,7 @@ EXPORT_SYMBOL(tty_register_driver);
 int tty_unregister_driver(struct tty_driver *driver)
 {
 	int i;
-	struct termios *tp;
+	struct ktermios *tp;
 	void *p;
 
 	if (driver->refcount)
diff -puN drivers/char/tty_ioctl.c~tty-switch-to-ktermios-and-new-framework drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-switch-to-ktermios-and-new-framework
+++ a/drivers/char/tty_ioctl.c
@@ -36,6 +36,7 @@
 #define TERMIOS_FLUSH	1
 #define TERMIOS_WAIT	2
 #define TERMIOS_TERMIO	4
+#define TERMIOS_OLD	8
 
 
 /**
@@ -84,9 +85,9 @@ stop_waiting:
 
 EXPORT_SYMBOL(tty_wait_until_sent);
 
-static void unset_locked_termios(struct termios *termios,
-				 struct termios *old,
-				 struct termios *locked)
+static void unset_locked_termios(struct ktermios *termios,
+				 struct ktermios *old,
+				 struct ktermios *locked)
 {
 	int	i;
 	
@@ -105,8 +106,204 @@ static void unset_locked_termios(struct 
 	for (i=0; i < NCCS; i++)
 		termios->c_cc[i] = locked->c_cc[i] ?
 			old->c_cc[i] : termios->c_cc[i];
+	/* FIXME: What should we do for i/ospeed */
 }
 
+/*
+ * Routine which returns the baud rate of the tty
+ *
+ * Note that the baud_table needs to be kept in sync with the
+ * include/asm/termbits.h file.
+ */
+static const speed_t baud_table[] = {
+	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
+	9600, 19200, 38400, 57600, 115200, 230400, 460800,
+#ifdef __sparc__
+	76800, 153600, 307200, 614400, 921600
+#else
+	500000, 576000, 921600, 1000000, 1152000, 1500000, 2000000,
+	2500000, 3000000, 3500000, 4000000
+#endif
+};
+
+#ifndef __sparc__
+static const tcflag_t baud_bits[] = {
+	B0, B50, B75, B110, B134, B150, B200, B300, B600,
+	B1200, B1800, B2400, B4800, B9600, B19200, B38400,
+	B57600, B115200, B230400, B460800, B500000, B576000,
+	B921600, B1000000, B1152000, B1500000, B2000000, B2500000,
+	B3000000, B3500000, B4000000
+};
+#else
+static const tcflag_t baud_bits[] = {
+	B0, B50, B75, B110, B134, B150, B200, B300, B600,
+	B1200, B1800, B2400, B4800, B9600, B19200, B38400,
+	B57600, B115200, B230400, B460800, B76800, B153600,
+	B307200, B614400, B921600
+};
+#endif
+
+static int n_baud_table = ARRAY_SIZE(baud_table);
+
+/**
+ *	tty_termios_baud_rate
+ *	@termios: termios structure
+ *
+ *	Convert termios baud rate data into a speed. This should be called
+ *	with the termios lock held if this termios is a terminal termios
+ *	structure. May change the termios data. Device drivers can call this
+ *	function but should use ->c_[io]speed directly as they are updated.
+ *
+ *	Locking: none
+ */
+
+speed_t tty_termios_baud_rate(struct ktermios *termios)
+{
+	unsigned int cbaud;
+
+	cbaud = termios->c_cflag & CBAUD;
+
+#ifdef BOTHER
+	/* Magic token for arbitary speed via c_ispeed/c_ospeed */
+	if (cbaud == BOTHER)
+		return termios->c_ospeed;
+#endif
+	if (cbaud & CBAUDEX) {
+		cbaud &= ~CBAUDEX;
+
+		if (cbaud < 1 || cbaud + 15 > n_baud_table)
+			termios->c_cflag &= ~CBAUDEX;
+		else
+			cbaud += 15;
+	}
+	return baud_table[cbaud];
+}
+
+EXPORT_SYMBOL(tty_termios_baud_rate);
+
+/**
+ *	tty_termios_input_baud_rate
+ *	@termios: termios structure
+ *
+ *	Convert termios baud rate data into a speed. This should be called
+ *	with the termios lock held if this termios is a terminal termios
+ *	structure. May change the termios data. Device drivers can call this
+ *	function but should use ->c_[io]speed directly as they are updated.
+ *
+ *	Locking: none
+ */
+
+speed_t tty_termios_input_baud_rate(struct ktermios *termios)
+{
+#ifdef IBSHIFT
+	unsigned int cbaud = (termios->c_cflag >> IBSHIFT) & CBAUD;
+
+	if (cbaud == B0)
+		return tty_termios_baud_rate(termios);
+
+	/* Magic token for arbitary speed via c_ispeed*/
+	if (cbaud == BOTHER)
+		return termios->c_ispeed;
+
+	if (cbaud & CBAUDEX) {
+		cbaud &= ~CBAUDEX;
+
+		if (cbaud < 1 || cbaud + 15 > n_baud_table)
+			termios->c_cflag &= ~(CBAUDEX << IBSHIFT);
+		else
+			cbaud += 15;
+	}
+	return baud_table[cbaud];
+#else
+	return tty_termios_baud_rate(termios);
+#endif
+}
+
+EXPORT_SYMBOL(tty_termios_input_baud_rate);
+
+#ifdef BOTHER
+
+/**
+ *	tty_termios_encode_baud_rate
+ *	@termios: termios structure
+ *	@ispeed: input speed
+ *	@ospeed: output speed
+ *
+ *	Encode the speeds set into the passed termios structure. This is
+ *	used as a library helper for drivers os that they can report back
+ *	the actual speed selected when it differs from the speed requested
+ *
+ *	For now input and output speed must agree.
+ *
+ *	Locking: Caller should hold termios lock. This is already held
+ *	when calling this function from the driver termios handler.
+ */
+
+void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed_t obaud)
+{
+	int i = 0;
+	int ifound = 0, ofound = 0;
+
+	termios->c_ispeed = ibaud;
+	termios->c_ospeed = obaud;
+
+	termios->c_cflag &= ~CBAUD;
+	/* Identical speed means no input encoding (ie B0 << IBSHIFT)*/
+	if (termios->c_ispeed == termios->c_ospeed)
+		ifound = 1;
+
+	do {
+		if (obaud == baud_table[i]) {
+			termios->c_cflag |= baud_bits[i];
+			ofound = 1;
+			/* So that if ibaud == obaud we don't set it */
+			continue;
+		}
+		if (ibaud == baud_table[i]) {
+			termios->c_cflag |= (baud_bits[i] << IBSHIFT);
+			ifound = 1;
+		}
+	}
+	while(++i < n_baud_table);
+	if (!ofound)
+		termios->c_cflag |= BOTHER;
+	if (!ifound)
+		termios->c_cflag |= (BOTHER << IBSHIFT);
+}
+
+EXPORT_SYMBOL_GPL(tty_termios_encode_baud_rate);
+
+#endif
+
+/**
+ *	tty_get_baud_rate	-	get tty bit rates
+ *	@tty: tty to query
+ *
+ *	Returns the baud rate as an integer for this terminal. The
+ *	termios lock must be held by the caller and the terminal bit
+ *	flags may be updated.
+ *
+ *	Locking: none
+ */
+
+speed_t tty_get_baud_rate(struct tty_struct *tty)
+{
+	speed_t baud = tty_termios_baud_rate(tty->termios);
+
+	if (baud == 38400 && tty->alt_speed) {
+		if (!tty->warned) {
+			printk(KERN_WARNING "Use of setserial/setrocket to "
+					    "set SPD_* flags is deprecated\n");
+			tty->warned = 1;
+		}
+		baud = tty->alt_speed;
+	}
+
+	return baud;
+}
+
+EXPORT_SYMBOL(tty_get_baud_rate);
+
 /**
  *	change_termios		-	update termios values
  *	@tty: tty to update
@@ -119,10 +316,10 @@ static void unset_locked_termios(struct 
  *	Locking: termios_sem
  */
 
-static void change_termios(struct tty_struct * tty, struct termios * new_termios)
+static void change_termios(struct tty_struct * tty, struct ktermios * new_termios)
 {
 	int canon_change;
-	struct termios old_termios = *tty->termios;
+	struct ktermios old_termios = *tty->termios;
 	struct tty_ldisc *ld;
 	
 	/*
@@ -195,7 +392,7 @@ static void change_termios(struct tty_st
 
 static int set_termios(struct tty_struct * tty, void __user *arg, int opt)
 {
-	struct termios tmp_termios;
+	struct ktermios tmp_termios;
 	struct tty_ldisc *ld;
 	int retval = tty_check_change(tty);
 
@@ -203,16 +400,28 @@ static int set_termios(struct tty_struct
 		return retval;
 
 	if (opt & TERMIOS_TERMIO) {
-		memcpy(&tmp_termios, tty->termios, sizeof(struct termios));
+		memcpy(&tmp_termios, tty->termios, sizeof(struct ktermios));
 		if (user_termio_to_kernel_termios(&tmp_termios,
 						(struct termio __user *)arg))
 			return -EFAULT;
+#ifdef TCGETS2
+	} else if (opt & TERMIOS_OLD) {
+		memcpy(&tmp_termios, tty->termios, sizeof(struct termios));
+		if (user_termios_to_kernel_termios_1(&tmp_termios,
+						(struct termios_v1 __user *)arg))
+			return -EFAULT;
+#endif
 	} else {
 		if (user_termios_to_kernel_termios(&tmp_termios,
 						(struct termios __user *)arg))
 			return -EFAULT;
 	}
 
+	/* If old style Bfoo values are used then load c_ispeed/c_ospeed with the real speed
+	   so its unconditionally usable */
+	tmp_termios.c_ispeed = tty_termios_input_baud_rate(&tmp_termios);
+	tmp_termios.c_ospeed = tty_termios_baud_rate(&tmp_termios);
+
 	ld = tty_ldisc_ref(tty);
 	
 	if (ld != NULL) {
@@ -286,8 +495,8 @@ static int get_sgttyb(struct tty_struct 
 	struct sgttyb tmp;
 
 	mutex_lock(&tty->termios_mutex);
-	tmp.sg_ispeed = 0;
-	tmp.sg_ospeed = 0;
+	tmp.sg_ispeed = tty->c_ispeed;
+	tmp.sg_ospeed = tty->c_ospeed;
 	tmp.sg_erase = tty->termios->c_cc[VERASE];
 	tmp.sg_kill = tty->termios->c_cc[VKILL];
 	tmp.sg_flags = get_sgflags(tty);
@@ -296,7 +505,7 @@ static int get_sgttyb(struct tty_struct 
 	return copy_to_user(sgttyb, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
-static void set_sgflags(struct termios * termios, int flags)
+static void set_sgflags(struct ktermios * termios, int flags)
 {
 	termios->c_iflag = ICRNL | IXON;
 	termios->c_oflag = 0;
@@ -337,7 +546,7 @@ static int set_sgttyb(struct tty_struct 
 {
 	int retval;
 	struct sgttyb tmp;
-	struct termios termios;
+	struct ktermios termios;
 
 	retval = tty_check_change(tty);
 	if (retval)
@@ -351,6 +560,10 @@ static int set_sgttyb(struct tty_struct 
 	termios.c_cc[VERASE] = tmp.sg_erase;
 	termios.c_cc[VKILL] = tmp.sg_kill;
 	set_sgflags(&termios, tmp.sg_flags);
+	/* Try and encode into Bfoo format */
+#ifdef BOTHER
+	tty_termios_encode_baud_rate(&termios, termios.c_ispeed, termios.c_ospeed);
+#endif
 	mutex_unlock(&tty->termios_mutex);
 	change_termios(tty, &termios);
 	return 0;
@@ -481,16 +694,33 @@ int n_tty_ioctl(struct tty_struct * tty,
 		case TIOCSLTC:
 			return set_ltchars(real_tty, p);
 #endif
+		case TCSETSF:
+			return set_termios(real_tty, p,  TERMIOS_FLUSH | TERMIOS_WAIT | TERMIOS_OLD);
+		case TCSETSW:
+			return set_termios(real_tty, p, TERMIOS_WAIT | TERMIOS_OLD);
+		case TCSETS:
+			return set_termios(real_tty, p, TERMIOS_OLD);
+#ifndef TCGETS2
 		case TCGETS:
 			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios))
 				return -EFAULT;
 			return 0;
-		case TCSETSF:
+#else
+		case TCGETS:
+			if (kernel_termios_to_user_termios_1((struct termios_v1 __user *)arg, real_tty->termios))
+				return -EFAULT;
+			return 0;
+		case TCGETS2:
+			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios))
+				return -EFAULT;
+			return 0;
+		case TCSETSF2:
 			return set_termios(real_tty, p,  TERMIOS_FLUSH | TERMIOS_WAIT);
-		case TCSETSW:
+		case TCSETSW2:
 			return set_termios(real_tty, p, TERMIOS_WAIT);
-		case TCSETS:
+		case TCSETS2:
 			return set_termios(real_tty, p, 0);
+#endif
 		case TCGETA:
 			return get_termio(real_tty, p);
 		case TCSETAF:
diff -puN include/linux/tty.h~tty-switch-to-ktermios-and-new-framework include/linux/tty.h
--- a/include/linux/tty.h~tty-switch-to-ktermios-and-new-framework
+++ a/include/linux/tty.h
@@ -175,7 +175,7 @@ struct tty_struct {
 	int index;
 	struct tty_ldisc ldisc;
 	struct mutex termios_mutex;
-	struct termios *termios, *termios_locked;
+	struct ktermios *termios, *termios_locked;
 	char name[64];
 	int pgrp;
 	int session;
@@ -258,7 +258,7 @@ struct tty_struct {
 
 extern void tty_write_flush(struct tty_struct *);
 
-extern struct termios tty_std_termios;
+extern struct ktermios tty_std_termios;
 
 extern int kmsg_redirect;
 
@@ -293,8 +293,9 @@ extern int tty_hung_up_p(struct file * f
 extern void do_SAK(struct tty_struct *tty);
 extern void disassociate_ctty(int priv);
 extern void tty_flip_buffer_push(struct tty_struct *tty);
-extern int tty_get_baud_rate(struct tty_struct *tty);
-extern int tty_termios_baud_rate(struct termios *termios);
+extern speed_t tty_get_baud_rate(struct tty_struct *tty);
+extern speed_t tty_termios_baud_rate(struct ktermios *termios);
+extern speed_t tty_termios_input_baud_rate(struct ktermios *termios);
 
 extern struct tty_ldisc *tty_ldisc_ref(struct tty_struct *);
 extern void tty_ldisc_deref(struct tty_ldisc *);
diff -puN include/linux/tty_driver.h~tty-switch-to-ktermios-and-new-framework include/linux/tty_driver.h
--- a/include/linux/tty_driver.h~tty-switch-to-ktermios-and-new-framework
+++ a/include/linux/tty_driver.h
@@ -53,7 +53,7 @@
  *	device-specific ioctl's.  If the ioctl number passed in cmd
  * 	is not recognized by the driver, it should return ENOIOCTLCMD.
  * 
- * void (*set_termios)(struct tty_struct *tty, struct termios * old);
+ * void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
  *
  * 	This routine allows the tty driver to be notified when
  * 	device's termios settings have changed.  Note that a
@@ -132,7 +132,7 @@ struct tty_operations {
 	int  (*chars_in_buffer)(struct tty_struct *tty);
 	int  (*ioctl)(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg);
-	void (*set_termios)(struct tty_struct *tty, struct termios * old);
+	void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
 	void (*throttle)(struct tty_struct * tty);
 	void (*unthrottle)(struct tty_struct * tty);
 	void (*stop)(struct tty_struct *tty);
@@ -165,7 +165,7 @@ struct tty_driver {
 	int	num;		/* number of devices allocated */
 	short	type;		/* type of tty driver */
 	short	subtype;	/* subtype of tty driver */
-	struct termios init_termios; /* Initial termios */
+	struct ktermios init_termios; /* Initial termios */
 	int	flags;		/* tty driver flags */
 	int	refcount;	/* for loadable tty drivers */
 	struct proc_dir_entry *proc_entry; /* /proc fs entry */
@@ -175,8 +175,8 @@ struct tty_driver {
 	 * Pointer to the tty data structures
 	 */
 	struct tty_struct **ttys;
-	struct termios **termios;
-	struct termios **termios_locked;
+	struct ktermios **termios;
+	struct ktermios **termios_locked;
 	void *driver_state;	/* only used for the PTY driver */
 	
 	/*
@@ -193,7 +193,7 @@ struct tty_driver {
 	int  (*chars_in_buffer)(struct tty_struct *tty);
 	int  (*ioctl)(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg);
-	void (*set_termios)(struct tty_struct *tty, struct termios * old);
+	void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
 	void (*throttle)(struct tty_struct * tty);
 	void (*unthrottle)(struct tty_struct * tty);
 	void (*stop)(struct tty_struct *tty);
diff -puN include/linux/tty_ldisc.h~tty-switch-to-ktermios-and-new-framework include/linux/tty_ldisc.h
--- a/include/linux/tty_ldisc.h~tty-switch-to-ktermios-and-new-framework
+++ a/include/linux/tty_ldisc.h
@@ -59,7 +59,7 @@
  * 	low-level driver can "grab" an ioctl request before the line
  * 	discpline has a chance to see it.
  * 
- * void	(*set_termios)(struct tty_struct *tty, struct termios * old);
+ * void	(*set_termios)(struct tty_struct *tty, struct ktermios * old);
  *
  * 	This function notifies the line discpline that a change has
  * 	been made to the termios structure.
@@ -118,7 +118,7 @@ struct tty_ldisc {
 			 const unsigned char * buf, size_t nr);	
 	int	(*ioctl)(struct tty_struct * tty, struct file * file,
 			 unsigned int cmd, unsigned long arg);
-	void	(*set_termios)(struct tty_struct *tty, struct termios * old);
+	void	(*set_termios)(struct tty_struct *tty, struct ktermios * old);
 	unsigned int (*poll)(struct tty_struct *, struct file *,
 			     struct poll_table_struct *);
 	int	(*hangup)(struct tty_struct *tty);
diff -puN include/net/irda/ircomm_tty.h~tty-switch-to-ktermios-and-new-framework include/net/irda/ircomm_tty.h
--- a/include/net/irda/ircomm_tty.h~tty-switch-to-ktermios-and-new-framework
+++ a/include/net/irda/ircomm_tty.h
@@ -126,7 +126,7 @@ extern int ircomm_tty_tiocmset(struct tt
 extern int ircomm_tty_ioctl(struct tty_struct *tty, struct file *file, 
 			    unsigned int cmd, unsigned long arg);
 extern void ircomm_tty_set_termios(struct tty_struct *tty, 
-				   struct termios *old_termios);
+				   struct ktermios *old_termios);
 extern hashbin_t *ircomm_tty;
 
 #endif
diff -puN net/irda/ircomm/ircomm_tty_ioctl.c~tty-switch-to-ktermios-and-new-framework net/irda/ircomm/ircomm_tty_ioctl.c
--- a/net/irda/ircomm/ircomm_tty_ioctl.c~tty-switch-to-ktermios-and-new-framework
+++ a/net/irda/ircomm/ircomm_tty_ioctl.c
@@ -146,7 +146,7 @@ static void ircomm_tty_change_speed(stru
  *    do something rational.
  */
 void ircomm_tty_set_termios(struct tty_struct *tty, 
-			    struct termios *old_termios)
+			    struct ktermios *old_termios)
 {
 	struct ircomm_tty_cb *self = (struct ircomm_tty_cb *) tty->driver_data;
 	unsigned int cflag = tty->termios->c_cflag;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
termios-enable-new-style-termios-ioctls-on-x86-64.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch
ide-more-conversion-to-pci_get-apis.patch
pdc202xx_new-fix-pio-mode-setup.patch
sl82c105-straighten-up-ide-control-status-register-caching.patch
igafb-switch-to-pci_get-api.patch
tty-switch-to-ktermios-nozomi-fix.patch
ata-fix-platform_device_register_simple-error-check.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pci-quirks-fix-the-festering-mess-that-claims-to-handle-ide-quirks-ide-fix.patch
pci-fix-multiple-problems-with-via-hardware.patch
via-sb600-sata-quirk.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
ide-complete-switch-to-pci_get.patch
ide-hpt3xxn-clocking-fixes.patch
ide-fix-hpt37x-timing-tables.patch
ide-optimize-hpt37x-timing-tables.patch
ide-fix-hpt3xx-hotswap-support.patch
ide-fix-the-case-of-multiple-hpt3xx-chips-present.patch
ide-hpt3xx-fix-pci-clock-detection.patch
ide-hpt3xx-fix-pci-clock-detection-fix-2.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
ide-cd-handle-strange-interrupt-on-the-intel-esb2.patch

