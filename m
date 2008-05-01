From: akpm@linux-foundation.org
Subject: - resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:29 -0700
Message-ID: <200805010928.m419STUn030586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757964AbYEAJ2n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@skyrush.com, alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     Resume TTY on SUSP and fix CRNL order in N_TTY line discipline
has been removed from the -mm tree.  Its filename was
     resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Resume TTY on SUSP and fix CRNL order in N_TTY line discipline
From: Joe Peterson <joe@skyrush.com>

Refine these behaviors in the N_TTY line discipline:

1) Handle the signal characters consistently when received in a stopped TTY
   so that SUSP (typically ctrl-Z) behaves like INTR and QUIT in resuming a
   stopped TTY.

2) Adjust the order in which the IGNCR/ICRNL/INLCR processing is applied to
   be more logical and consistent with the behavior of other Unix systems.

Signed-off-by: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/char/n_tty.c~resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline
+++ a/drivers/char/n_tty.c
@@ -708,7 +708,7 @@ static inline void n_tty_receive_char(st
 
 	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) &&
 	    ((I_IXANY(tty) && c != START_CHAR(tty) && c != STOP_CHAR(tty)) ||
-	     c == INTR_CHAR(tty) || c == QUIT_CHAR(tty)))
+	     c == INTR_CHAR(tty) || c == QUIT_CHAR(tty) || c == SUSP_CHAR(tty)))
 		start_tty(tty);
 
 	if (tty->closing) {
@@ -746,13 +746,6 @@ static inline void n_tty_receive_char(st
 		return;
 	}
 
-	if (c == '\r') {
-		if (I_IGNCR(tty))
-			return;
-		if (I_ICRNL(tty))
-			c = '\n';
-	} else if (c == '\n' && I_INLCR(tty))
-		c = '\r';
 	if (I_IXON(tty)) {
 		if (c == START_CHAR(tty)) {
 			start_tty(tty);
@@ -763,6 +756,7 @@ static inline void n_tty_receive_char(st
 			return;
 		}
 	}
+
 	if (L_ISIG(tty)) {
 		int signal;
 		signal = SIGINT;
@@ -792,6 +786,15 @@ send_signal:
 			return;
 		}
 	}
+
+	if (c == '\r') {
+		if (I_IGNCR(tty))
+			return;
+		if (I_ICRNL(tty))
+			c = '\n';
+	} else if (c == '\n' && I_INLCR(tty))
+		c = '\r';
+
 	if (tty->icanon) {
 		if (c == ERASE_CHAR(tty) || c == KILL_CHAR(tty) ||
 		    (c == WERASE_CHAR(tty) && L_IEXTEN(tty))) {
_

Patches currently in -mm which might be from joe@skyrush.com are

origin.patch

