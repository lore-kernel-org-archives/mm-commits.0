From: akpm@linux-foundation.org
Subject: + n_tty-loss-of-sync-following-a-buffer-overflow.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:55:04 -0700
Message-ID: <200803120455.m2C4t4Aw010881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbYCLEzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:55:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Rupesh.Sugathan@gmail.com, alan@lxorguk.ukuu.org.uk, paulkf@microgate.com


The patch titled
     n_tty: loss of sync following a buffer overflow
has been added to the -mm tree.  Its filename is
     n_tty-loss-of-sync-following-a-buffer-overflow.patch

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
Subject: n_tty: loss of sync following a buffer overflow
From: Rupesh Sugathan <Rupesh.Sugathan@gmail.com>

There seems to be a synchronization issue with the n_tty.c driver when working
in canonical mode.

The n_tty rightly discards data received following a buffer overflow and hence
the tty->read_cnt is not updated.  However, the newline characters received
following a buffer overflow seems to increment the tty->canon_data index. 
This may result in a loss of sync between the tty->canon_data & tty->read_cnt
while processing read in the read_chan().  This loss of sync might be
irrecoverable even when the data is later received at a slower rate.

I am not very sure if there is any deliberate rationale to process the
newlines even when the buffer has overflown.

Signed-off-by: Rupesh Sugathan <Rupesh.Sugathan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/char/n_tty.c~n_tty-loss-of-sync-following-a-buffer-overflow drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~n_tty-loss-of-sync-following-a-buffer-overflow
+++ a/drivers/char/n_tty.c
@@ -850,15 +850,17 @@ send_signal:
 				put_tty_queue(c, tty);
 
 handle_newline:
-			spin_lock_irqsave(&tty->read_lock, flags);
-			set_bit(tty->read_head, tty->read_flags);
-			put_tty_queue_nolock(c, tty);
-			tty->canon_head = tty->read_head;
-			tty->canon_data++;
-			spin_unlock_irqrestore(&tty->read_lock, flags);
-			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
-			if (waitqueue_active(&tty->read_wait))
-				wake_up_interruptible(&tty->read_wait);
+			if (tty->read_cnt < N_TTY_BUF_SIZE) {
+				spin_lock_irqsave(&tty->read_lock, flags);
+				set_bit(tty->read_head, tty->read_flags);
+				put_tty_queue_nolock(c, tty);
+				tty->canon_head = tty->read_head;
+				tty->canon_data++;
+				spin_unlock_irqrestore(&tty->read_lock, flags);
+				kill_fasync(&tty->fasync, SIGIO, POLL_IN);
+				if (waitqueue_active(&tty->read_wait))
+					wake_up_interruptible(&tty->read_wait);
+			}
 			return;
 		}
 	}
_

Patches currently in -mm which might be from Rupesh.Sugathan@gmail.com are

n_tty-loss-of-sync-following-a-buffer-overflow.patch

