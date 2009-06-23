From: akpm@linux-foundation.org
Subject: + n_hdlc-add-buffer-flushing.patch added to -mm tree
Date: Mon, 22 Jun 2009 21:52:07 -0700
Message-ID: <200906230452.n5N4q7Cu014809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbZFWEwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 00:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org


The patch titled
     n_hdlc: add buffer flushing
has been added to the -mm tree.  Its filename is
     n_hdlc-add-buffer-flushing.patch

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
Subject: n_hdlc: add buffer flushing
From: Paul Fulghum <paulkf@microgate.com>

Add flush_buffer tty callback to flush rx buffers.
Add TCFLSH ioctl processing to flush tx buffers.
Increase default tx buffers from 1 to 3.
Remove unneeded flush_buffer call in open callback.
Remove vendor specific CVS version string.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_hdlc.c |   46 ++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff -puN drivers/char/n_hdlc.c~n_hdlc-add-buffer-flushing drivers/char/n_hdlc.c
--- a/drivers/char/n_hdlc.c~n_hdlc-add-buffer-flushing
+++ a/drivers/char/n_hdlc.c
@@ -10,7 +10,6 @@
  *	Paul Mackerras <Paul.Mackerras@cs.anu.edu.au>
  *
  * Original release 01/11/99
- * $Id: n_hdlc.c,v 4.8 2003/05/06 21:18:51 paulkf Exp $
  *
  * This code is released under the GNU General Public License (GPL)
  *
@@ -79,7 +78,6 @@
  */
 
 #define HDLC_MAGIC 0x239e
-#define HDLC_VERSION "$Revision: 4.8 $"
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -114,7 +112,7 @@
 #define MAX_HDLC_FRAME_SIZE 65535 
 #define DEFAULT_RX_BUF_COUNT 10
 #define MAX_RX_BUF_COUNT 60
-#define DEFAULT_TX_BUF_COUNT 1
+#define DEFAULT_TX_BUF_COUNT 3
 
 struct n_hdlc_buf {
 	struct n_hdlc_buf *link;
@@ -199,6 +197,31 @@ static void n_hdlc_tty_wakeup(struct tty
 #define tty2n_hdlc(tty)	((struct n_hdlc *) ((tty)->disc_data))
 #define n_hdlc2tty(n_hdlc)	((n_hdlc)->tty)
 
+static void flush_rx_queue(struct tty_struct *tty)
+{
+	struct n_hdlc *n_hdlc = tty2n_hdlc(tty);
+	struct n_hdlc_buf *buf;
+
+	while ((buf = n_hdlc_buf_get(&n_hdlc->rx_buf_list)))
+		n_hdlc_buf_put(&n_hdlc->rx_free_buf_list, buf);
+}
+
+static void flush_tx_queue(struct tty_struct *tty)
+{
+	struct n_hdlc *n_hdlc = tty2n_hdlc(tty);
+	struct n_hdlc_buf *buf;
+	unsigned long flags;
+
+	while ((buf = n_hdlc_buf_get(&n_hdlc->tx_buf_list)))
+		n_hdlc_buf_put(&n_hdlc->tx_free_buf_list, buf);
+ 	spin_lock_irqsave(&n_hdlc->tx_buf_list.spinlock, flags);
+	if (n_hdlc->tbuf) {
+		n_hdlc_buf_put(&n_hdlc->tx_free_buf_list, n_hdlc->tbuf);
+		n_hdlc->tbuf = NULL;
+	}
+	spin_unlock_irqrestore(&n_hdlc->tx_buf_list.spinlock, flags);
+}
+
 static struct tty_ldisc_ops n_hdlc_ldisc = {
 	.owner		= THIS_MODULE,
 	.magic		= TTY_LDISC_MAGIC,
@@ -211,6 +234,7 @@ static struct tty_ldisc_ops n_hdlc_ldisc
 	.poll		= n_hdlc_tty_poll,
 	.receive_buf	= n_hdlc_tty_receive,
 	.write_wakeup	= n_hdlc_tty_wakeup,
+	.flush_buffer   = flush_rx_queue,
 };
 
 /**
@@ -341,10 +365,7 @@ static int n_hdlc_tty_open (struct tty_s
 	set_bit(TTY_NO_WRITE_SPLIT,&tty->flags);
 #endif
 	
-	/* Flush any pending characters in the driver and discipline. */
-	if (tty->ldisc->ops->flush_buffer)
-		tty->ldisc->ops->flush_buffer(tty);
-
+	/* flush receive data from driver */
 	tty_driver_flush_buffer(tty);
 		
 	if (debuglevel >= DEBUG_LEVEL_INFO)	
@@ -763,6 +784,14 @@ static int n_hdlc_tty_ioctl(struct tty_s
 		error = put_user(count, (int __user *)arg);
 		break;
 
+	case TCFLSH:
+		switch (arg) {
+		case TCIOFLUSH:
+		case TCOFLUSH:
+			flush_tx_queue(tty);
+		}
+		/* fall through to default */
+
 	default:
 		error = n_tty_ioctl_helper(tty, file, cmd, arg);
 		break;
@@ -919,8 +948,7 @@ static struct n_hdlc_buf* n_hdlc_buf_get
 }	/* end of n_hdlc_buf_get() */
 
 static char hdlc_banner[] __initdata =
-	KERN_INFO "HDLC line discipline: version " HDLC_VERSION
-	", maxframe=%u\n";
+	KERN_INFO "HDLC line discipline maxframe=%u\n";
 static char hdlc_register_ok[] __initdata =
 	KERN_INFO "N_HDLC line discipline registered.\n";
 static char hdlc_register_fail[] __initdata =
_

Patches currently in -mm which might be from paulkf@microgate.com are

origin.patch
n_hdlc-add-buffer-flushing.patch

