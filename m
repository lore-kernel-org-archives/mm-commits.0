From: akpm@linux-foundation.org
Subject: - synclink-series-switch-to-int-put_char-method.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:29 -0700
Message-ID: <200805010930.m419UTlB030769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757329AbYEAJa4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     synclink series: switch to int put_char method
has been removed from the -mm tree.  Its filename was
     synclink-series-switch-to-int-put_char-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink series: switch to int put_char method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink.c    |   11 ++++++-----
 drivers/char/synclink_gt.c |   14 +++++++++-----
 drivers/char/synclinkmp.c  |   11 +++++++----
 3 files changed, 22 insertions(+), 14 deletions(-)

diff -puN drivers/char/synclink.c~synclink-series-switch-to-int-put_char-method drivers/char/synclink.c
--- a/drivers/char/synclink.c~synclink-series-switch-to-int-put_char-method
+++ a/drivers/char/synclink.c
@@ -2026,10 +2026,11 @@ static void mgsl_change_params(struct mg
  * 		
  * Return Value:	None
  */
-static void mgsl_put_char(struct tty_struct *tty, unsigned char ch)
+static int mgsl_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct mgsl_struct *info = (struct mgsl_struct *)tty->driver_data;
 	unsigned long flags;
+	int ret;
 
 	if ( debug_level >= DEBUG_LEVEL_INFO ) {
 		printk( "%s(%d):mgsl_put_char(%d) on %s\n",
@@ -2037,23 +2038,23 @@ static void mgsl_put_char(struct tty_str
 	}		
 	
 	if (mgsl_paranoia_check(info, tty->name, "mgsl_put_char"))
-		return;
+		return 0;
 
 	if (!tty || !info->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->irq_spinlock,flags);
 	
 	if ( (info->params.mode == MGSL_MODE_ASYNC ) || !info->tx_active ) {
-	
 		if (info->xmit_cnt < SERIAL_XMIT_SIZE - 1) {
 			info->xmit_buf[info->xmit_head++] = ch;
 			info->xmit_head &= SERIAL_XMIT_SIZE-1;
 			info->xmit_cnt++;
+			ret = 1;
 		}
 	}
-	
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
+	return ret;
 	
 }	/* end of mgsl_put_char() */
 
diff -puN drivers/char/synclink_gt.c~synclink-series-switch-to-int-put_char-method drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink-series-switch-to-int-put_char-method
+++ a/drivers/char/synclink_gt.c
@@ -151,7 +151,7 @@ static void hangup(struct tty_struct *tt
 static void set_termios(struct tty_struct *tty, struct ktermios *old_termios);
 
 static int  write(struct tty_struct *tty, const unsigned char *buf, int count);
-static void put_char(struct tty_struct *tty, unsigned char ch);
+static int put_char(struct tty_struct *tty, unsigned char ch);
 static void send_xchar(struct tty_struct *tty, char ch);
 static void wait_until_sent(struct tty_struct *tty, int timeout);
 static int  write_room(struct tty_struct *tty);
@@ -912,20 +912,24 @@ cleanup:
 	return ret;
 }
 
-static void put_char(struct tty_struct *tty, unsigned char ch)
+static int put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct slgt_info *info = tty->driver_data;
 	unsigned long flags;
+	int ret;
 
 	if (sanity_check(info, tty->name, "put_char"))
-		return;
+		return 0;
 	DBGINFO(("%s put_char(%d)\n", info->device_name, ch));
 	if (!info->tx_buf)
-		return;
+		return 0;
 	spin_lock_irqsave(&info->lock,flags);
-	if (!info->tx_active && (info->tx_count < info->max_frame_size))
+	if (!info->tx_active && (info->tx_count < info->max_frame_size)) {
 		info->tx_buf[info->tx_count++] = ch;
+		ret = 1;
+	}
 	spin_unlock_irqrestore(&info->lock,flags);
+	return ret;
 }
 
 static void send_xchar(struct tty_struct *tty, char ch)
diff -puN drivers/char/synclinkmp.c~synclink-series-switch-to-int-put_char-method drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~synclink-series-switch-to-int-put_char-method
+++ a/drivers/char/synclinkmp.c
@@ -519,7 +519,7 @@ static void hangup(struct tty_struct *tt
 static void set_termios(struct tty_struct *tty, struct ktermios *old_termios);
 
 static int  write(struct tty_struct *tty, const unsigned char *buf, int count);
-static void put_char(struct tty_struct *tty, unsigned char ch);
+static int put_char(struct tty_struct *tty, unsigned char ch);
 static void send_xchar(struct tty_struct *tty, char ch);
 static void wait_until_sent(struct tty_struct *tty, int timeout);
 static int  write_room(struct tty_struct *tty);
@@ -1045,10 +1045,11 @@ cleanup:
 
 /* Add a character to the transmit buffer.
  */
-static void put_char(struct tty_struct *tty, unsigned char ch)
+static int put_char(struct tty_struct *tty, unsigned char ch)
 {
 	SLMP_INFO *info = (SLMP_INFO *)tty->driver_data;
 	unsigned long flags;
+	int ret = 0;
 
 	if ( debug_level >= DEBUG_LEVEL_INFO ) {
 		printk( "%s(%d):%s put_char(%d)\n",
@@ -1056,10 +1057,10 @@ static void put_char(struct tty_struct *
 	}
 
 	if (sanity_check(info, tty->name, "put_char"))
-		return;
+		return 0;
 
 	if (!info->tx_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->lock,flags);
 
@@ -1071,10 +1072,12 @@ static void put_char(struct tty_struct *
 			if (info->tx_put >= info->max_frame_size)
 				info->tx_put -= info->max_frame_size;
 			info->tx_count++;
+			ret = 1;
 		}
 	}
 
 	spin_unlock_irqrestore(&info->lock,flags);
+	return ret;
 }
 
 /* Send a high-priority XON/XOFF character
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

