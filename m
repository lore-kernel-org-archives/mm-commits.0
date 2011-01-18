From: akpm@linux-foundation.org
Subject: [folded] n_hdlc-fix-read-and-write-locking-update.patch removed from -mm tree
Date: Tue, 18 Jan 2011 14:03:02 -0800
Message-ID: <201101182203.p0IM32oN007969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139Ab1ARWDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 17:03:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     n_hdlc-fix-read-and-write-locking-update
has been removed from the -mm tree.  Its filename was
     n_hdlc-fix-read-and-write-locking-update.patch

This patch was dropped because it was folded into n_hdlc-fix-read-and-write-locking.patch

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

 drivers/tty/n_hdlc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/tty/n_hdlc.c~n_hdlc-fix-read-and-write-locking-update drivers/tty/n_hdlc.c
--- a/drivers/tty/n_hdlc.c~n_hdlc-fix-read-and-write-locking-update
+++ a/drivers/tty/n_hdlc.c
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

