From: akpm@linux-foundation.org
Subject: + posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch added to -mm tree
Date: Mon, 28 Jul 2008 21:51:53 -0700
Message-ID: <200807290451.m6T4prvx014930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbYG2ExR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 00:53:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, markmc@redhat.com, mingo@elte.hu, oliver.pntr@gmail.com, roland@redhat.com, stable@kernel.org, tglx@linutronix.de


The patch titled
     posix-timers: do_schedule_next_timer: fix the setting of ->si_overrun
has been added to the -mm tree.  Its filename is
     posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch

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
Subject: posix-timers: do_schedule_next_timer: fix the setting of ->si_overrun
From: Oleg Nesterov <oleg@tv-sign.ru>

do_schedule_next_timer() sets info->si_overrun = timr->it_overrun_last,
this discards the already accumulated overruns.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mark McLoughlin <markmc@redhat.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/posix-timers.c~posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun
+++ a/kernel/posix-timers.c
@@ -304,7 +304,7 @@ void do_schedule_next_timer(struct sigin
 		else
 			schedule_next_timer(timr);
 
-		info->si_overrun = timr->it_overrun_last;
+		info->si_overrun += timr->it_overrun_last;
 	}
 
 	if (timr)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch

