From: akpm@linux-foundation.org
Subject: - fix-serial-buffer-memory-leak-fix.patch removed from -mm tree
Date: Fri, 10 Aug 2007 12:45:43 -0700
Message-ID: <200708101945.l7AJjho4005259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56123 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584AbXHJTqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Aug 2007 15:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com, laurentp@cse-semaphore.com, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     fix-serial-buffer-memory-leak-fix
has been removed from the -mm tree.  Its filename was
     fix-serial-buffer-memory-leak-fix.patch

This patch was dropped because it was folded into fix-serial-buffer-memory-leak.patch

------------------------------------------------------
Subject: fix-serial-buffer-memory-leak-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@redhat.com>
Cc: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/tty_io.c~fix-serial-buffer-memory-leak-fix drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~fix-serial-buffer-memory-leak-fix
+++ a/drivers/char/tty_io.c
@@ -412,10 +412,10 @@ static void tty_buffer_flush(struct tty_
 	if (test_bit(TTY_FLUSHING, &tty->flags)) {
 		set_bit(TTY_FLUSHPENDING, &tty->flags);
 		spin_unlock_irqrestore(&tty->buf.lock, flags);
-		wait_event(tty->read_wait, test_bit(TTY_FLUSHPENDING, &tty->flags) == 0);
- 		return;
-	}
-	else
+		wait_event(tty->read_wait,
+				test_bit(TTY_FLUSHPENDING, &tty->flags) == 0);
+		return;
+	} else
 		__tty_buffer_flush(tty);
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fbcon-kill-compile-warning.patch
fix-serial-buffer-memory-leak.patch
fix-serial-buffer-memory-leak-fix.patch
mtdchar-build-fix.patch
fix-compilation-with-gcc-42-fix.patch
