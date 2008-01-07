From: akpm@linux-foundation.org
Subject: - tty-fix-logic-change-introduced-by-wait_event_interruptible_timeout.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:24 -0800
Message-ID: <200801072139.m07Ld4SZ013536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758768AbYAGVjg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:39:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ctusar@videon-central.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     tty: fix logic change introduced by wait_event_interruptible_timeout()
has been removed from the -mm tree.  Its filename was
     tty-fix-logic-change-introduced-by-wait_event_interruptible_timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: fix logic change introduced by wait_event_interruptible_timeout()
From: "Cory T. Tusar" <ctusar@videon-central.com>

Commit 5a52bd4a2dcb570333ce6fe2e16cd311650dbdc8 introduced a subtle logic
change in tty_wait_until_sent().  The original version would only error out
of the 'do { ...  } while (timeout)' loop if signal_pending() evaluated to
true; a timeout or break due to an empty buffer would fall out of the loop
and into the tty->driver->wait_until_sent handling.  The current
implementation will error out on either a pending signal or an empty
buffer, falling through to the tty->driver->wait_until_sent handling only
on a timeout.

The ->wait_until_sent() will not be reached if the buffer empties before
timeout jiffies have elapsed.  This behavior differs from that prior to commit
5a52bd4a2dcb570333ce6fe2e16cd311650dbdc8.

I turned this up while using a little serial download utility to bootstrap an
ARM-based eval board.  The util worked fine on 2.6.22.x, but consistently
failed on 2.6.23.x.  Once I'd determined that, I narrowed things down with git
bisect, and found the above difference in logic in tty_wait_until_sent() by
inspection.

This change reverts the logic flow in tty_wait_until_sent() to match that
prior to the aforementioned commit.

Signed-off-by: Cory T. Tusar <ctusar@videon-central.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tty_ioctl.c~tty-fix-logic-change-introduced-by-wait_event_interruptible_timeout drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-fix-logic-change-introduced-by-wait_event_interruptible_timeout
+++ a/drivers/char/tty_ioctl.c
@@ -62,7 +62,7 @@ void tty_wait_until_sent(struct tty_stru
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
 	if (wait_event_interruptible_timeout(tty->write_wait,
-			!tty->driver->chars_in_buffer(tty), timeout))
+			!tty->driver->chars_in_buffer(tty), timeout) < 0)
 		return;
 	if (tty->driver->wait_until_sent)
 		tty->driver->wait_until_sent(tty, timeout);
_

Patches currently in -mm which might be from ctusar@videon-central.com are
