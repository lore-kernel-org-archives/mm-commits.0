From: akpm@linux-foundation.org
Subject: + fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update.patch added to -mm tree
Date: Thu, 17 Jan 2008 16:12:11 -0800
Message-ID: <200801180012.m0I0CBFg021324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759363AbYARAMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 19:12:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@skyrush.com, alan@lxorguk.ukuu.org.uk


The patch titled
     fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline update
has been added to the -mm tree.  Its filename is
     fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update.patch

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
Subject: fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline update
From: Joe Peterson <joe@skyrush.com>

It fixes a couple of issues with ttys in the stopped state.

Signed-off-by: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/char/n_tty.c~fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update
+++ a/drivers/char/n_tty.c
@@ -695,14 +695,16 @@ static inline void n_tty_receive_char(st
 		return;
 	}
 	
-	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) && I_IXANY(tty))
-		start_tty(tty);
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
@@ -766,8 +768,6 @@ static inline void n_tty_receive_char(st
 		signal = SIGTSTP;
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
-			if (tty->stopped && !tty->flow_stopped && I_IXON(tty))
-				start_tty(tty);
 			/*
 			 * Echo character, and then send the signal.
 			 * Note that we do not use isig() here because we want
_

Patches currently in -mm which might be from joe@skyrush.com are

tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update.patch
