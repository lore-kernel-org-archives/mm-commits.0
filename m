From: akpm@linux-foundation.org
Subject: + n_hdlc-fix-read-and-write-locking-update.patch added to -mm tree
Date: Mon, 25 Oct 2010 14:04:20 -0700
Message-ID: <201010252104.o9PL4KXv016277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759Ab0JYVFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 17:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, arnd@arndb.de, greg@kroah.com


The patch titled
     n_hdlc-fix-read-and-write-locking-update
has been added to the -mm tree.  Its filename is
     n_hdlc-fix-read-and-write-locking-update.patch

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
Subject: n_hdlc-fix-read-and-write-locking-update
From: Paul Fulghum <paulkf@microgate.com>

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_hdlc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/n_hdlc.c~n_hdlc-fix-read-and-write-locking-update drivers/char/n_hdlc.c
--- a/drivers/char/n_hdlc.c~n_hdlc-fix-read-and-write-locking-update
+++ a/drivers/char/n_hdlc.c
@@ -646,7 +646,7 @@ static ssize_t n_hdlc_tty_read(struct tt
 	}
 
 	remove_wait_queue(&tty->read_wait, &wait);
-	set_current_state(TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
 
 	return ret;
 	
@@ -719,7 +719,7 @@ static ssize_t n_hdlc_tty_write(struct t
 		}
 	}
 
-	set_current_state(TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&tty->write_wait, &wait);
 
 	if (!error) {		
_

Patches currently in -mm which might be from paulkf@microgate.com are

n_hdlc-fix-read-and-write-locking.patch
n_hdlc-fix-read-and-write-locking-update.patch
synclink_gt-fix-per-device-locking.patch
drivers-char-synclink_gtc-fix-information-leak-to-userland.patch
drivers-char-synclink_gtc-add-extended-sync-feature.patch

