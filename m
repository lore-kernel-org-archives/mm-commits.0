From: akpm@linux-foundation.org
Subject: + tty-revert-part-of-the-termios-locking.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:11:28 -0700
Message-ID: <200808042111.m74LBSPk031065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756706AbYHDVM3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:12:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com, ckyoog@gmail.com


The patch titled
     tty: revert part of the termios locking
has been added to the -mm tree.  Its filename is
     tty-revert-part-of-the-termios-locking.patch

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
Subject: tty: revert part of the termios locking
From: Alan Cox <alan@redhat.com>

vt: deadlock workaround

2.6.26 corrected the mutex locking on tty resizing to fix the case where
you could get the tty/vt sizing out of sync.  That turns out to have a
deadlock.

The actual fix is really major and I've got it lined up as part of the ops
changes for 2.6.28 so for 2.6.26/2.6.27 it is safer to reintroduce this
ages old minor bug.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11234

Signed-off-by: Alan Cox <alan@redhat.com>
Reported-by: kouyu <ckyoog@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/vt.c~tty-revert-part-of-the-termios-locking drivers/char/vt.c
--- a/drivers/char/vt.c~tty-revert-part-of-the-termios-locking
+++ a/drivers/char/vt.c
@@ -916,7 +916,6 @@ int vc_resize(struct vc_data *vc, unsign
 		ws.ws_col = vc->vc_cols;
 		ws.ws_ypixel = vc->vc_scan_lines;
 
-		mutex_lock(&vc->vc_tty->termios_mutex);
 		spin_lock_irq(&vc->vc_tty->ctrl_lock);
 		if ((ws.ws_row != cws->ws_row || ws.ws_col != cws->ws_col))
 			pgrp = get_pid(vc->vc_tty->pgrp);
@@ -926,7 +925,6 @@ int vc_resize(struct vc_data *vc, unsign
 			put_pid(pgrp);
 		}
 		*cws = ws;
-		mutex_unlock(&vc->vc_tty->termios_mutex);
 	}
 
 	if (CON_IS_VISIBLE(vc))
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
tty-revert-part-of-the-termios-locking.patch
hamradio-add-missing-sanity-check-to-tty-operation.patch
fb-push-down-the-bkl-in-the-ioctl-handler.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch

