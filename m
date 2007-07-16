From: akpm@linux-foundation.org
Subject: - char-n_r3964-use-wait_event_interruptible.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:03 -0700
Message-ID: <200707162055.l6GKt3Og001879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758430AbXGPVPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Char: n_r3964, use wait_event_interruptible
has been removed from the -mm tree.  Its filename was
     char-n_r3964-use-wait_event_interruptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: n_r3964, use wait_event_interruptible
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_r3964.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

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

origin.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
char-istallion-initlocking-fixes-try-2.patch
stallion-remove-unneeded-lock_kernel.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
