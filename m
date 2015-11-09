From: akpm@linux-foundation.org
Subject: [folded-merged] remove-abs64-fix.patch removed from -mm tree
Date: Mon, 09 Nov 2015 14:52:16 -0800
Message-ID: <564123a0.lUy7XGFPNa8IO7/A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbKIWwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 17:52:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: remove-abs64-fix
has been removed from the -mm tree.  Its filename was
     remove-abs64-fix.patch

This patch was dropped because it was folded into remove-abs64.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: remove-abs64-fix

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/walkera0701.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/joystick/walkera0701.c~remove-abs64-fix drivers/input/joystick/walkera0701.c
--- a/drivers/input/joystick/walkera0701.c~remove-abs64-fix
+++ a/drivers/input/joystick/walkera0701.c
@@ -150,7 +150,7 @@ static void walkera0701_irq_handler(void
 		if (w->counter == 24) {	/* full frame */
 			walkera0701_parse_frame(w);
 			w->counter = NO_SYNC;
-			if (abs64(pulse_time - SYNC_PULSE) < RESERVE)	/* new frame sync */
+			if (abs(pulse_time - SYNC_PULSE) < RESERVE)	/* new frame sync */
 				w->counter = 0;
 		} else {
 			if ((pulse_time > (ANALOG_MIN_PULSE - RESERVE)
@@ -161,7 +161,7 @@ static void walkera0701_irq_handler(void
 			} else
 				w->counter = NO_SYNC;
 		}
-	} else if (abs64(pulse_time - SYNC_PULSE - BIN0_PULSE) <
+	} else if (abs(pulse_time - SYNC_PULSE - BIN0_PULSE) <
 				RESERVE + BIN1_PULSE - BIN0_PULSE)	/* frame sync .. */
 		w->counter = 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-abs64.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
remove-abs64-fix-fix-fix-fix.patch

