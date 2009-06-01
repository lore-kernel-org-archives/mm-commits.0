From: akpm@linux-foundation.org
Subject: + pl2303-usb_serial-implement-sysrq-handling-on-break.patch added to -mm tree
Date: Mon, 01 Jun 2009 16:27:23 -0700
Message-ID: <200906012327.n51NRO96013025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbZFAX1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 19:27:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason.wessel@windriver.com, greg@kroah.com


The patch titled
     usb_serial: pl2303: implement sysrq handling on break
has been added to the -mm tree.  Its filename is
     pl2303-usb_serial-implement-sysrq-handling-on-break.patch

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
pl2303-usb_serial-implement-sysrq-handling-on-break.patch
usb_serial-only-allow-sysrq-on-a-console-port.patch
frv-duplicate-output_buffer-of-e03.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch

