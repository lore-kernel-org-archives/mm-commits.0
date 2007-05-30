From: akpm@linux-foundation.org
Subject: + char-n_r3964-use-wait_event_interruptible.patch added to -mm tree
Date: Tue, 29 May 2007 17:08:37 -0700
Message-ID: <200705300008.l4U08beu015009@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbXE3AIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 20:08:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, dwmw2@infradead.org


The patch titled
     Char: n_r3964, use wait_event_interruptible
has been added to the -mm tree.  Its filename is
     char-n_r3964-use-wait_event_interruptible.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: n_r3964, use wait_event_interruptible
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_r3964.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff -puN drivers/char/n_r3964.c~char-n_r3964-use-wait_event_interruptible drivers/char/n_r3964.c
--- a/drivers/char/n_r3964.c~char-n_r3964-use-wait_event_interruptible
+++ a/drivers/char/n_r3964.c
@@ -1071,8 +1071,6 @@ static ssize_t r3964_read(struct tty_str
 	struct r3964_client_info *pClient;
 	struct r3964_message *pMsg;
 	struct r3964_client_message theMsg;
-	DECLARE_WAITQUEUE(wait, current);
-
 	int count;
 
 	TRACE_L("read()");
@@ -1086,16 +1084,8 @@ static ssize_t r3964_read(struct tty_str
 				return -EAGAIN;
 			}
 			/* block until there is a message: */
-			add_wait_queue(&pInfo->read_wait, &wait);
-repeat:
-			__set_current_state(TASK_INTERRUPTIBLE);
-			pMsg = remove_msg(pInfo, pClient);
-			if (!pMsg && !signal_pending(current)) {
-				schedule();
-				goto repeat;
-			}
-			__set_current_state(TASK_RUNNING);
-			remove_wait_queue(&pInfo->read_wait, &wait);
+			wait_event_interruptible(pInfo->read_wait,
+					(pMsg = remove_msg(pInfo, pClient)));
 		}
 
 		/* If we still haven't got a message, we must have been signalled */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-mxser_new-fix-sparse-warning.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
char-genrtc-use-wait_event_interruptible.patch
char-n_r3964-use-wait_event_interruptible.patch
char-ip2-use-msleep-for-sleeping.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
shrink_slab-handle-bad-shrinkers.patch
