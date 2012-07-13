From: akpm@linux-foundation.org
Subject: + mm-fix-lost-kswapd-wakeup-in-kswapd_stop.patch added to -mm tree
Date: Fri, 13 Jul 2012 15:26:46 -0700
Message-ID: <20120713222646.D695A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:43350 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2GMW0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 18:26:48 -0400
Received: by qcqs25 with SMTP id s25so393375qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 15:26:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aaditya.kumar.30@gmail.com, aaditya.kumar@ap.sony.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan@kernel.org, stable@vger.kernel.org


The patch titled
     Subject: mm: fix lost kswapd wakeup in kswapd_stop()
has been added to the -mm tree.  Its filename is
     mm-fix-lost-kswapd-wakeup-in-kswapd_stop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Subject: mm: fix lost kswapd wakeup in kswapd_stop()

Offlining memory may block forever, waiting for kswapd() to wake up
because kswapd() does not check the event kthread->should_stop before
sleeping.

The proper pattern, from Documentation/memory-barriers.txt, is:

   ---  waker  ---
   event_indicated = 1;
   wake_up_process(event_daemon);

   ---  sleeper  ---
   for (;;) {
      set_current_state(TASK_UNINTERRUPTIBLE);
      if (event_indicated)
         break;
      schedule();
   }

   set_current_state() may be wrapped by:
      prepare_to_wait();

In the kswapd() case, event_indicated is kthread->should_stop.

=== offlining memory (waker) ===
   kswapd_stop()
      kthread_stop()
         kthread->should_stop = 1
         wake_up_process()
         wait_for_completion()


===  kswapd_try_to_sleep (sleeper) ===
   kswapd_try_to_sleep()
      prepare_to_wait()
           .
           .
      schedule()
           .
           .
      finish_wait()

The schedule() needs to be protected by a test of kthread->should_stop,
which is wrapped by kthread_should_stop().

Reproducer:
   Do heavy file I/O in background.
   Do a memory offline/online in a tight loop

Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-fix-lost-kswapd-wakeup-in-kswapd_stop mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-lost-kswapd-wakeup-in-kswapd_stop
+++ a/mm/vmscan.c
@@ -2706,7 +2706,10 @@ static void kswapd_try_to_sleep(pg_data_
 		 * them before going back to sleep.
 		 */
 		set_pgdat_percpu_threshold(pgdat, calculate_normal_threshold);
-		schedule();
+
+		if (!kthread_should_stop())
+			schedule();
+
 		set_pgdat_percpu_threshold(pgdat, calculate_pressure_threshold);
 	} else {
 		if (remaining)
_
Subject: Subject: mm: fix lost kswapd wakeup in kswapd_stop()

Patches currently in -mm which might be from aaditya.kumar.30@gmail.com are

mm-fix-lost-kswapd-wakeup-in-kswapd_stop.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch

