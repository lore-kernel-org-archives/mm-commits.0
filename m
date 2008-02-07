From: akpm@linux-foundation.org
Subject: - fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:13 -0800
Message-ID: <200802070024.m170OsVb006668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935010AbYBGAot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@skyrush.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Fix IXANY and restart after signal (e.g. ctrl-C) in n_tty line discipline
has been removed from the -mm tree.  Its filename was
     fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix IXANY and restart after signal (e.g. ctrl-C) in n_tty line discipline
From: Joe Peterson <joe@skyrush.com>

Fix two N_TTY line discipline issues related to resuming a stopped TTY
(typically done with ctrl-S):

1) Fix handling of character that resumes a stopped TTY (with IXANY)

With "stty ixany", the TTY line discipline would lose the first character
after the stop, so typing, for example, "hi^Sthere" resulted in "hihere"
(the 't' would cause the resume after ^S, but it would then be thrown away
rather than processed as an input character).  This was inconsistent with
the behavior of other Unix systems.

2) Fix interrupt signal (e.g. ctrl-C) behavior in stopped TTYs

With "stty -ixany" (often the default), interrupt signals were ignored
in a stopped TTY until the TTY was resumed with the start char (typically
ctrl-Q), which was inconsistent with the behavior of other Unix systems.

Signed-off-by: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/char/n_tty.c~fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline
+++ a/drivers/char/n_tty.c
@@ -695,17 +695,16 @@ static inline void n_tty_receive_char(st
 		return;
 	}
 	
-	if (tty->stopped && !tty->flow_stopped &&
-	    I_IXON(tty) && I_IXANY(tty)) {
-		start_tty(tty);
-		return;
-	}
-	
 	if (I_ISTRIP(tty))
 		c &= 0x7f;
 	if (I_IUCLC(tty) && L_IEXTEN(tty))
 		c=tolower(c);
 
+	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) &&
+	    ((I_IXANY(tty) && c != START_CHAR(tty) && c != STOP_CHAR(tty)) ||
+	     c == INTR_CHAR(tty) || c == QUIT_CHAR(tty)))
+		start_tty(tty);
+
 	if (tty->closing) {
 		if (I_IXON(tty)) {
 			if (c == START_CHAR(tty))
_

Patches currently in -mm which might be from joe@skyrush.com are

origin.patch
