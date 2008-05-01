From: akpm@linux-foundation.org
Subject: + serial-access-after-null-check-at-uart_flush_buffer.patch added to -mm tree
Date: Thu, 01 May 2008 09:13:00 -0700
Message-ID: <200805011613.m41GD0Yh013969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728AbYEAQNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 12:13:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@i-love.sakura.ne.jppenguin-kernel@i-love.sakura.ne.jp


The patch titled
     serial: access after NULL check in uart_flush_buffer()
has been added to the -mm tree.  Its filename is
     serial-access-after-null-check-at-uart_flush_buffer.patch

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
Subject: serial: access after NULL check in uart_flush_buffer()
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

I noticed that

  static void uart_flush_buffer(struct tty_struct *tty)
  {
  	struct uart_state *state = tty->driver_data;
  	struct uart_port *port = state->port;
  	unsigned long flags;

  	/*
  	 * This means you called this function _after_ the port was
  	 * closed.  No cookie for you.
  	 */
  	if (!state || !state->info) {
  		WARN_ON(1);
  		return;
  	}

is too late for checking state != NULL.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~serial-access-after-null-check-at-uart_flush_buffer drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-access-after-null-check-at-uart_flush_buffer
+++ a/drivers/serial/serial_core.c
@@ -556,7 +556,7 @@ static int uart_chars_in_buffer(struct t
 static void uart_flush_buffer(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
-	struct uart_port *port = state->port;
+	struct uart_port *port;
 	unsigned long flags;
 
 	/*
@@ -568,6 +568,7 @@ static void uart_flush_buffer(struct tty
 		return;
 	}
 
+	port = state->port;
 	pr_debug("uart_flush_buffer(%d) called\n", tty->index);
 
 	spin_lock_irqsave(&port->lock, flags);
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

origin.patch
serial-access-after-null-check-at-uart_flush_buffer.patch

