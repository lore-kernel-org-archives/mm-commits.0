From: akpm@linux-foundation.org
Subject: - tty-flush-flip-buffer-on-ldisc-input-queue-flush.patch removed from -mm tree
Date: Sat, 12 May 2007 22:14:25 -0700
Message-ID: <200705130514.l4D5EP1m022713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756590AbXEMFOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 01:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, alan@redhat.com, tritemio@gmail.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     tty: flush flip buffer on ldisc input queue flush
has been removed from the -mm tree.  Its filename was
     tty-flush-flip-buffer-on-ldisc-input-queue-flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: flush flip buffer on ldisc input queue flush
From: Paul Fulghum <paulkf@microgate.com>

Flush the tty flip buffer when the line discipline input queue is flushed,
including the user call tcflush(TCIFLUSH/TCIOFLUSH).  This prevents
unexpected stale data after a user application calls tcflush().

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Antonino Ingargiola <tritemio@gmail.com>
Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN drivers/char/tty_io.c~tty-flush-flip-buffer-on-ldisc-input-queue-flush drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-flush-flip-buffer-on-ldisc-input-queue-flush
+++ a/drivers/char/tty_io.c
@@ -369,6 +369,29 @@ static void tty_buffer_free(struct tty_s
 }
 
 /**
+ *	tty_buffer_flush		-	flush full tty buffers
+ *	@tty: tty to flush
+ *
+ *	flush all the buffers containing receive data
+ *
+ *	Locking: none
+ */
+
+static void tty_buffer_flush(struct tty_struct *tty)
+{
+	struct tty_buffer *thead;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->buf.lock, flags);
+	while((thead = tty->buf.head) != NULL) {
+		tty->buf.head = thead->next;
+		tty_buffer_free(tty, thead);
+	}
+	tty->buf.tail = NULL;
+	spin_unlock_irqrestore(&tty->buf.lock, flags);
+}
+
+/**
  *	tty_buffer_find		-	find a free tty buffer
  *	@tty: tty owning the buffer
  *	@size: characters wanted
@@ -1248,6 +1271,7 @@ void tty_ldisc_flush(struct tty_struct *
 			ld->flush_buffer(tty);
 		tty_ldisc_deref(ld);
 	}
+	tty_buffer_flush(tty);
 }
 
 EXPORT_SYMBOL_GPL(tty_ldisc_flush);
@@ -3350,6 +3374,15 @@ int tty_ioctl(struct inode * inode, stru
 		case TIOCMBIC:
 		case TIOCMBIS:
 			return tty_tiocmset(tty, file, cmd, p);
+		case TCFLSH:
+			switch (arg) {
+			case TCIFLUSH:
+			case TCIOFLUSH:
+				/* flush tty buffer and allow ldisc to process ioctl */
+				tty_buffer_flush(tty);
+				break;
+			}
+			break;
 	}
 	if (tty->driver->ioctl) {
 		retval = (tty->driver->ioctl)(tty, file, cmd, arg);
_

Patches currently in -mm which might be from paulkf@microgate.com are
