From: akpm@linux-foundation.org
Subject: + tty-fix-logic-change-introduced-by-wait_event_interruptible_timeout.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:46:07 -0800
Message-ID: <200712220646.lBM6k7qL021425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814AbXLVGqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:46:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ctusar@videon-central.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com


The patch titled
     tty: fix logic change introduced by wait_event_interruptible_timeout()
has been added to the -mm tree.  Its filename is
     tty-fix-logic-change-introduced-by-wait_event_interruptible_timeout.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

This change reverts the logic flow in tty_wait_until_sent() to match that
prior to the aforementioned commit.

Signed-off-by: Cory T. Tusar <ctusar@videon-central.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>
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

tty-fix-logic-change-introduced-by-wait_event_interruptible_timeout.patch
