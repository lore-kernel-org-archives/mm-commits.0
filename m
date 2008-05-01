From: akpm@linux-foundation.org
Subject: - strip-fix-up-strip-for-the-new-order.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:47 -0700
Message-ID: <200805010930.m419UlqR030800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757624AbYEAJby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, davem@davemloft.net, jeff@garzik.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     strip: Fix up strip for the new order
has been removed from the -mm tree.  Its filename was
     strip-fix-up-strip-for-the-new-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: strip: Fix up strip for the new order
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Use the tty baud functions
- Call driver termios methods directly holding the right locking
- Check for a write method

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/strip.c |   70 ++++++++++++---------------------
 1 file changed, 26 insertions(+), 44 deletions(-)

diff -puN drivers/net/wireless/strip.c~strip-fix-up-strip-for-the-new-order drivers/net/wireless/strip.c
--- a/drivers/net/wireless/strip.c~strip-fix-up-strip-for-the-new-order
+++ a/drivers/net/wireless/strip.c
@@ -768,41 +768,17 @@ static __u8 *UnStuffData(__u8 * src, __u
 /* General routines for STRIP						*/
 
 /*
- * get_baud returns the current baud rate, as one of the constants defined in
- * termbits.h
- * If the user has issued a baud rate override using the 'setserial' command
- * and the logical current rate is set to 38.4, then the true baud rate
- * currently in effect (57.6 or 115.2) is returned.
- */
-static unsigned int get_baud(struct tty_struct *tty)
-{
-	if (!tty || !tty->termios)
-		return (0);
-	if ((tty->termios->c_cflag & CBAUD) == B38400 && tty->driver_data) {
-		struct async_struct *info =
-		    (struct async_struct *) tty->driver_data;
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
-			return (B57600);
-		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-			return (B115200);
-	}
-	return (tty->termios->c_cflag & CBAUD);
-}
-
-/*
  * set_baud sets the baud rate to the rate defined by baudcode
- * Note: The rate B38400 should be avoided, because the user may have
- * issued a 'setserial' speed override to map that to a different speed.
- * We could achieve a true rate of 38400 if we needed to by cancelling
- * any user speed override that is in place, but that might annoy the
- * user, so it is simplest to just avoid using 38400.
- */
-static void set_baud(struct tty_struct *tty, unsigned int baudcode)
-{
-	struct ktermios old_termios = *(tty->termios);
-	tty->termios->c_cflag &= ~CBAUD;	/* Clear the old baud setting */
-	tty->termios->c_cflag |= baudcode;	/* Set the new baud setting */
-	tty->driver->set_termios(tty, &old_termios);
+ */
+static void set_baud(struct tty_struct *tty, speed_t baudrate)
+{
+	struct ktermios old_termios;
+
+	mutex_lock(&tty->termios_mutex);
+	old_termios =*(tty->termios);
+	tty_encode_baud_rate(tty, baudrate, baudrate);
+	tty->ops->set_termios(tty, &old_termios);
+	mutex_unlock(&tty->termios_mutex);
 }
 
 /*
@@ -1217,7 +1193,7 @@ static void ResetRadio(struct strip *str
 	strip_info->watchdog_doreset = jiffies + 1 * HZ;
 
 	/* If the user has selected a baud rate above 38.4 see what magic we have to do */
-	if (strip_info->user_baud > B38400) {
+	if (strip_info->user_baud > 38400) {
 		/*
 		 * Subtle stuff: Pay attention :-)
 		 * If the serial port is currently at the user's selected (>38.4) rate,
@@ -1227,17 +1203,17 @@ static void ResetRadio(struct strip *str
 		 * issued the ATS304 command last time through, so this time we restore
 		 * the user's selected rate and issue the normal starmode reset string.
 		 */
-		if (strip_info->user_baud == get_baud(tty)) {
+		if (strip_info->user_baud == tty_get_baud_rate(tty)) {
 			static const char b0[] = "ate0q1s304=57600\r";
 			static const char b1[] = "ate0q1s304=115200\r";
 			static const StringDescriptor baudstring[2] =
 			    { {b0, sizeof(b0) - 1}
 			, {b1, sizeof(b1) - 1}
 			};
-			set_baud(tty, B19200);
-			if (strip_info->user_baud == B57600)
+			set_baud(tty, 19200);
+			if (strip_info->user_baud == 57600)
 				s = baudstring[0];
-			else if (strip_info->user_baud == B115200)
+			else if (strip_info->user_baud == 115200)
 				s = baudstring[1];
 			else
 				s = baudstring[1];	/* For now */
@@ -1245,7 +1221,7 @@ static void ResetRadio(struct strip *str
 			set_baud(tty, strip_info->user_baud);
 	}
 
-	tty->driver->write(tty, s.string, s.length);
+	tty->ops->write(tty, s.string, s.length);
 #ifdef EXT_COUNTERS
 	strip_info->tx_ebytes += s.length;
 #endif
@@ -1267,7 +1243,7 @@ static void strip_write_some_more(struct
 
 	if (strip_info->tx_left > 0) {
 		int num_written =
-		    tty->driver->write(tty, strip_info->tx_head,
+		    tty->ops->write(tty, strip_info->tx_head,
 				      strip_info->tx_left);
 		strip_info->tx_left -= num_written;
 		strip_info->tx_head += num_written;
@@ -2457,7 +2433,7 @@ static int strip_open_low(struct net_dev
 	strip_info->working = FALSE;
 	strip_info->firmware_level = NoStructure;
 	strip_info->next_command = CompatibilityCommand;
-	strip_info->user_baud = get_baud(strip_info->tty);
+	strip_info->user_baud = tty_get_baud_rate(strip_info->tty);
 
 	printk(KERN_INFO "%s: Initializing Radio.\n",
 	       strip_info->dev->name);
@@ -2632,6 +2608,13 @@ static int strip_open(struct tty_struct 
 		return -EEXIST;
 
 	/*
+	 * We need a write method.
+	 */
+
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
+
+	/*
 	 * OK.  Find a free STRIP channel to use.
 	 */
 	if ((strip_info = strip_alloc()) == NULL)
@@ -2652,8 +2635,7 @@ static int strip_open(struct tty_struct 
 	tty->disc_data = strip_info;
 	tty->receive_room = 65536;
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
 
 	/*
 	 * Restore default settings
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

