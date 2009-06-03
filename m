From: akpm@linux-foundation.org
Subject: [merged] pl2303-usb_serial-implement-sysrq-handling-on-break.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:40 -0700
Message-ID: <200906032002.n53K2eYC001974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716AbZFCUC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:02:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.wessel@windriver.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb_serial: pl2303: implement sysrq handling on break
has been removed from the -mm tree.  Its filename was
     pl2303-usb_serial-implement-sysrq-handling-on-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb_serial: pl2303: implement sysrq handling on break
From: Jason Wessel <jason.wessel@windriver.com>

Add callbacks to process the sysrq when using a pl2303 usb device as a
console.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/pl2303.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/usb/serial/pl2303.c~pl2303-usb_serial-implement-sysrq-handling-on-break drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~pl2303-usb_serial-implement-sysrq-handling-on-break
+++ a/drivers/usb/serial/pl2303.c
@@ -927,6 +927,8 @@ static void pl2303_update_line_status(st
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->line_status = data[status_idx];
 	spin_unlock_irqrestore(&priv->lock, flags);
+	if (priv->line_status & UART_BREAK_ERROR)
+		usb_serial_handle_break(port);
 	wake_up_interruptible(&priv->delta_msr_wait);
 }
 
@@ -1037,7 +1039,8 @@ static void pl2303_read_bulk_callback(st
 		if (line_status & UART_OVERRUN_ERROR)
 			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 		for (i = 0; i < urb->actual_length; ++i)
-			tty_insert_flip_char(tty, data[i], tty_flag);
+			if (!usb_serial_handle_sysrq_char(port, data[i]))
+				tty_insert_flip_char(tty, data[i], tty_flag);
 		tty_flip_buffer_push(tty);
 	}
 	tty_kref_put(tty);
_

Patches currently in -mm which might be from jason.wessel@windriver.com are

linux-next.patch
frv-duplicate-output_buffer-of-e03.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch

