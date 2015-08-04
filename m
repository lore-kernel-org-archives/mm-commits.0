From: akpm@linux-foundation.org
Subject: +
 watchdog-use-park-unpark-functions-in-update_watchdog_all_cpus.patch added
 to -mm tree
Date: Tue, 04 Aug 2015 15:59:02 -0700
Message-ID: <55c143b6.WOsmAI5TywPQ9tp6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbbHDW7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 18:59:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, a.p.zijlstra@chello.nl, atomlin@redhat.com, cmetcalf@ezchip.com, dzickus@redhat.com, eranian@google.com, fweisbec@gmail.com, jolsa@kernel.org, linux@roeck-us.net, mhocko@suse.cz, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: use park/unpark functions in update_watchdog_all_cpus()
has been added to the -mm tree.  Its filename is
     watchdog-use-park-unpark-functions-in-update_watchdog_all_cpus.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-use-park-unpark-functions-in-update_watchdog_all_cpus.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-use-park-unpark-functions-in-update_watchdog_all_cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: use park/unpark functions in update_watchdog_all_cpus()

Remove update_watchdog() and restart_watchdog_hrtimer() since these
functions are no longer needed.  Changes of parameters such as the sample
period are honored at the time when the watchdog threads are being
unparked.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Stephane Eranian <eranian@google.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   40 ++--------------------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff -puN kernel/watchdog.c~watchdog-use-park-unpark-functions-in-update_watchdog_all_cpus kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-use-park-unpark-functions-in-update_watchdog_all_cpus
+++ a/kernel/watchdog.c
@@ -745,46 +745,10 @@ void watchdog_resume(void)
 	mutex_unlock(&watchdog_proc_mutex);
 }
 
-static void restart_watchdog_hrtimer(void *info)
-{
-	struct hrtimer *hrtimer = raw_cpu_ptr(&watchdog_hrtimer);
-	int ret;
-
-	/*
-	 * No need to cancel and restart hrtimer if it is currently executing
-	 * because it will reprogram itself with the new period now.
-	 * We should never see it unqueued here because we are running per-cpu
-	 * with interrupts disabled.
-	 */
-	ret = hrtimer_try_to_cancel(hrtimer);
-	if (ret == 1)
-		hrtimer_start(hrtimer, ns_to_ktime(sample_period),
-				HRTIMER_MODE_REL_PINNED);
-}
-
-static void update_watchdog(int cpu)
-{
-	/*
-	 * Make sure that perf event counter will adopt to a new
-	 * sampling period. Updating the sampling period directly would
-	 * be much nicer but we do not have an API for that now so
-	 * let's use a big hammer.
-	 * Hrtimer will adopt the new period on the next tick but this
-	 * might be late already so we have to restart the timer as well.
-	 */
-	watchdog_nmi_disable(cpu);
-	smp_call_function_single(cpu, restart_watchdog_hrtimer, NULL, 1);
-	watchdog_nmi_enable(cpu);
-}
-
 static void update_watchdog_all_cpus(void)
 {
-	int cpu;
