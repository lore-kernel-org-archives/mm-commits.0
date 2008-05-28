From: akpm@linux-foundation.org
Subject: + vt-fix-vc_resize-locking.patch added to -mm tree
Date: Wed, 28 May 2008 16:06:33 -0700
Message-ID: <200805282306.m4SN6XUE004989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134AbYE1XHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 19:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, alan@redhat.com, ebiederm@xmission.com, oleg@tv-sign.ru


The patch titled
     vt: fix vc_resize locking
has been added to the -mm tree.  Its filename is
     vt-fix-vc_resize-locking.patch

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
Subject: vt: fix vc_resize locking
From: Nick Piggin <npiggin@suse.de>

Lockdep says we can't take tasklist lock or sighand lock inside ctrl_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/char/vt.c~vt-fix-vc_resize-locking drivers/char/vt.c
--- a/drivers/char/vt.c~vt-fix-vc_resize-locking
+++ a/drivers/char/vt.c
@@ -909,7 +909,7 @@ int vc_resize(struct vc_data *vc, unsign
 
 	if (vc->vc_tty) {
 		struct winsize ws, *cws = &vc->vc_tty->winsize;
-		unsigned long flags;
+		struct pid *pgrp = NULL;
 
 		memset(&ws, 0, sizeof(ws));
 		ws.ws_row = vc->vc_rows;
@@ -917,11 +917,14 @@ int vc_resize(struct vc_data *vc, unsign
 		ws.ws_ypixel = vc->vc_scan_lines;
 
 		mutex_lock(&vc->vc_tty->termios_mutex);
-		spin_lock_irqsave(&vc->vc_tty->ctrl_lock, flags);
-		if ((ws.ws_row != cws->ws_row || ws.ws_col != cws->ws_col) &&
-		    vc->vc_tty->pgrp)
+		spin_lock_irq(&vc->vc_tty->ctrl_lock);
+		if ((ws.ws_row != cws->ws_row || ws.ws_col != cws->ws_col))
+			pgrp = get_pid(vc->vc_tty->pgrp);
+		spin_unlock_irq(&vc->vc_tty->ctrl_lock);
+		if (pgrp) {
 			kill_pgrp(vc->vc_tty->pgrp, SIGWINCH, 1);
-		spin_unlock_irqrestore(&vc->vc_tty->ctrl_lock, flags);
+			put_pid(pgrp);
+		}
 		*cws = ws;
 		mutex_unlock(&vc->vc_tty->termios_mutex);
 	}
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

