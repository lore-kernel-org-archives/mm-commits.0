From: akpm@linux-foundation.org
Subject: + restart_syscall-use-freezable-blocking-call.patch added to -mm
 tree
Date: Mon, 30 Mar 2015 15:43:58 -0700
Message-ID: <5519d1ae.dIrBbagJ3pnFt9J+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbbC3Wn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Mar 2015 18:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maninder1.s@samsung.com, rjw@rjwysocki.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/time/hrtimer.c: restart_syscall: use freezable blocking call
has been added to the -mm tree.  Its filename is
     restart_syscall-use-freezable-blocking-call.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/restart_syscall-use-freezable-blocking-call.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/restart_syscall-use-freezable-blocking-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: kernel/time/hrtimer.c: restart_syscall: use freezable blocking call

Avoid waking up every thread sleeping in a restart_syscall call during
suspend and resume by calling a freezable blocking call.  Previous patches
modified the freezer to avoid sending wakeups to threads that are blocked
in freezable blocking calls.

Ref: https://lkml.org/lkml/2013/5/1/424

Backtrace: 
[<c03e3924>] (__schedule+0x0/0x5d8) from [<c03e3f88>] (schedule+0x8c/0x90)
[<c03e3efc>] (schedule+0x0/0x90) from [<c03e3150>] (schedule_hrtimeout_range_clock+0xdc/0x110)
[<c03e3074>] (schedule_hrtimeout_range_clock+0x0/0x110) from [<c03e31a0>] (schedule_hrtimeout_range+0x1c/0x20)
 r9:d16c9be0 r8:8b7d9c2c r7:00000000 r6:00000000 r5:d16c8028
[<c03e3184>] (schedule_hrtimeout_range+0x0/0x20) from [<c015778c>] (poll_schedule_timeout+0x48/0x6c)
[<c0157744>] (poll_schedule_timeout+0x0/0x6c) from [<c0158994>] (do_sys_poll+0x2c8/0x378) r5:d16c9f78 r4:00000000
[<c01586cc>] (do_sys_poll+0x0/0x378) from [<c0158a84>] (do_restart_poll+0x40/0x5c)
[<c0158a44>] (do_restart_poll+0x0/0x5c) from [<c005710c>] (sys_restart_syscall+0x2c/0x30) r4:fffffe7a
[<c00570e0>] (sys_restart_syscall+0x0/0x30) from [<c001a180>] (ret_fast_syscall+0x0/0x48)


Signed-off-by: Yogesh Gaur <yn.gaur <at> samsung.com>
Signed-off-by: Amit Arora <amit.arora <at> samsung.com>
Reviewed-by : Ajeet Yadav <ajeet.y <at> samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/hrtimer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/time/hrtimer.c~restart_syscall-use-freezable-blocking-call kernel/time/hrtimer.c
--- a/kernel/time/hrtimer.c~restart_syscall-use-freezable-blocking-call
+++ a/kernel/time/hrtimer.c
@@ -1767,7 +1767,7 @@ schedule_hrtimeout_range_clock(ktime_t *
 	 * A NULL parameter means "infinite"
 	 */
 	if (!expires) {
-		schedule();
+		freezable_schedule();
 		return -EINTR;
 	}
 
@@ -1781,7 +1781,7 @@ schedule_hrtimeout_range_clock(ktime_t *
 		t.task = NULL;
 
 	if (likely(t.task))
-		schedule();
+		freezable_schedule();
 
 	hrtimer_cancel(&t.timer);
 	destroy_hrtimer_on_stack(&t.timer);
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

restart_syscall-use-freezable-blocking-call.patch

