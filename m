From: akpm@linux-foundation.org
Subject: + hrtimers-fix-a-complex-race-update.patch added to -mm tree
Date: Mon, 11 Oct 2010 17:15:00 -0700
Message-ID: <201010120013.o9C0Dcij026475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754778Ab0JLANz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 20:13:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sqazi@google.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hrtimers-fix-a-complex-race-update
has been added to the -mm tree.  Its filename is
     hrtimers-fix-a-complex-race-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimers-fix-a-complex-race-update
From: Salman Qazi <sqazi@google.com>

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/hrtimer.c~hrtimers-fix-a-complex-race-update kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-fix-a-complex-race-update
+++ a/kernel/hrtimer.c
@@ -1232,7 +1232,7 @@ static void __run_hrtimer(struct hrtimer
 		enqueue_hrtimer(timer, base);
 	}
 
-	BUG_ON(!(timer->state & HRTIMER_STATE_CALLBACK));
+	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
 
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
_

Patches currently in -mm which might be from sqazi@google.com are

hrtimers-fix-a-complex-race.patch
hrtimers-fix-a-complex-race-update.patch

