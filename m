From: akpm@linux-foundation.org
Subject: - char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:15 -0700
Message-ID: <200805010930.m419UFNP030751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757932AbYEAJah (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     char: switch gs, cyclades and esp to return int for put_char
has been removed from the -mm tree.  Its filename was
     char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: switch gs, cyclades and esp to return int for put_char
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c        |    9 +++++----
 drivers/char/esp.c             |    9 ++++++---
 drivers/char/generic_serial.c  |   11 ++++++-----
 include/linux/generic_serial.h |    2 +-
 4 files changed, 18 insertions(+), 13 deletions(-)

diff -puN drivers/char/cyclades.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char
+++ a/drivers/char/cyclades.c
@@ -2814,7 +2814,7 @@ static int cy_write(struct tty_struct *t
  * done stuffing characters into the driver.  If there is no room
  * in the queue, the character is ignored.
  */
-static void cy_put_char(struct tty_struct *tty, unsigned char ch)
+static int cy_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
@@ -2824,15 +2824,15 @@ static void cy_put_char(struct tty_struc
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_put_char"))
-		return;
+		return 0;
 
 	if (!info->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->card->card_lock, flags);
 	if (info->xmit_cnt >= (int)(SERIAL_XMIT_SIZE - 1)) {
 		spin_unlock_irqrestore(&info->card->card_lock, flags);
-		return;
+		return 0;
 	}
 
 	info->xmit_buf[info->xmit_head++] = ch;
@@ -2841,6 +2841,7 @@ static void cy_put_char(struct tty_struc
 	info->idle_stats.xmit_bytes++;
 	info->idle_stats.xmit_idle = jiffies;
 	spin_unlock_irqrestore(&info->card->card_lock, flags);
+	return 1;
 }				/* cy_put_char */
 
 /*
diff -puN drivers/char/esp.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char drivers/char/esp.c
--- a/drivers/char/esp.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char
+++ a/drivers/char/esp.c
@@ -1156,24 +1156,27 @@ static void change_speed(struct esp_stru
 	spin_unlock_irqrestore(&info->lock, flags);
 }
 
-static void rs_put_char(struct tty_struct *tty, unsigned char ch)
+static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
 	unsigned long flags;
+	int ret = 0;
 
 	if (serial_paranoia_check(info, tty->name, "rs_put_char"))
-		return;
+		return 0;
 
 	if (!info->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->lock, flags);
 	if (info->xmit_cnt < ESP_XMIT_SIZE - 1) {
 		info->xmit_buf[info->xmit_head++] = ch;
 		info->xmit_head &= ESP_XMIT_SIZE-1;
 		info->xmit_cnt++;
+		ret = 1;
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
+	return ret;
 }
 
 static void rs_flush_chars(struct tty_struct *tty)
diff -puN drivers/char/generic_serial.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char drivers/char/generic_serial.c
--- a/drivers/char/generic_serial.c~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char
+++ a/drivers/char/generic_serial.c
@@ -48,19 +48,19 @@ static int gs_debug;
 module_param(gs_debug, int, 0644);
 
 
-void gs_put_char(struct tty_struct * tty, unsigned char ch)
+int gs_put_char(struct tty_struct * tty, unsigned char ch)
 {
 	struct gs_port *port;
 
 	func_enter (); 
 
-	if (!tty) return;
+	if (!tty) return 0;
 
 	port = tty->driver_data;
 
-	if (!port) return;
+	if (!port) return 0;
 
-	if (! (port->flags & ASYNC_INITIALIZED)) return;
+	if (! (port->flags & ASYNC_INITIALIZED)) return 0;
 
 	/* Take a lock on the serial tranmit buffer! */
 	mutex_lock(& port->port_write_mutex);
@@ -68,7 +68,7 @@ void gs_put_char(struct tty_struct * tty
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
 		/* Sorry, buffer is full, drop character. Update statistics???? -- REW */
 		mutex_unlock(&port->port_write_mutex);
-		return;
+		return 0;
 	}
 
 	port->xmit_buf[port->xmit_head++] = ch;
@@ -77,6 +77,7 @@ void gs_put_char(struct tty_struct * tty
 
 	mutex_unlock(&port->port_write_mutex);
 	func_exit ();
+	return 1;
 }
 
 
diff -puN include/linux/generic_serial.h~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char include/linux/generic_serial.h
--- a/include/linux/generic_serial.h~char-switch-gs-cyclades-and-esp-to-return-int-for-put_char
+++ a/include/linux/generic_serial.h
@@ -78,7 +78,7 @@ struct gs_port {
 #define GS_DEBUG_WRITE   0x00000040
 
 #ifdef __KERNEL__
-void gs_put_char(struct tty_struct *tty, unsigned char ch);
+int gs_put_char(struct tty_struct *tty, unsigned char ch);
 int  gs_write(struct tty_struct *tty, 
              const unsigned char *buf, int count);
 int  gs_write_room(struct tty_struct *tty);
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

