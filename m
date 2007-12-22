From: akpm@linux-foundation.org
Subject: + fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:49:46 -0800
Message-ID: <200712220649.lBM6nkIp021564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbXLVGu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:50:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@skyrush.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Fix IXANY and restart after signal (e.g. ctrl-C) in n_tty line discipline
has been added to the -mm tree.  Its filename is
     fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/char/n_tty.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/char/n_tty.c~fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline
+++ a/drivers/char/n_tty.c
@@ -695,11 +695,8 @@ static inline void n_tty_receive_char(st
 		return;
 	}
 	
-	if (tty->stopped && !tty->flow_stopped &&
-	    I_IXON(tty) && I_IXANY(tty)) {
+	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) && I_IXANY(tty))
 		start_tty(tty);
-		return;
-	}
 	
 	if (I_ISTRIP(tty))
 		c &= 0x7f;
@@ -769,6 +766,8 @@ static inline void n_tty_receive_char(st
 		signal = SIGTSTP;
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
+			if (tty->stopped && !tty->flow_stopped && I_IXON(tty))
+				start_tty(tty);
 			/*
 			 * Echo character, and then send the signal.
 			 * Note that we do not use isig() here because we want
_

Patches currently in -mm which might be from joe@skyrush.com are

tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
