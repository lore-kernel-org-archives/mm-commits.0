From: akpm@linux-foundation.org
Subject: + watchdog-update-watchdog_tresh-properly.patch added to -mm tree
Date: Mon, 29 Jul 2013 14:04:29 -0700
Message-ID: <51f6d8dd.ho07jAkwWB3BjATN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3G2VEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 17:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org, fweisbec@gmail.com, dzickus@redhat.com, mhocko@suse.cz

Subject: + watchdog-update-watchdog_tresh-properly.patch added to -mm tree
To: mhocko@suse.cz,dzickus@redhat.com,fweisbec@gmail.com,mingo@kernel.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 14:04:29 -0700


The patch titled
     Subject: watchdog: update watchdog_tresh properly
has been added to the -mm tree.  Its filename is
     watchdog-update-watchdog_tresh-properly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-update-watchdog_tresh-properly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-update-watchdog_tresh-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: watchdog: update watchdog_tresh properly

watchdog_tresh controls how often nmi perf event counter checks per-cpu
hrtimer_interrupts counter and blows up if the counter hasn't changed
since the last check.  The counter is updated by per-cpu watchdog_hrtimer
hrtimer which is scheduled with 2/5 watchdog_thresh period which
guarantees that hrtimer is scheduled 2 times per the main period.  Both
hrtimer and perf event are started together when the watchdog is enabled.

So far so good. But...

But what happens when watchdog_thresh is updated from sysctl handler?

proc_dowatchdog will set a new sampling period and hrtimer callback
(watchdog_timer_fn) will use the new value in the next round.  The
problem, however, is that nobody tells the perf event that the sampling
period has changed so it is ticking with the period configured when it has
been set up.

This might result in an ear ripping dissonance between perf and hrtimer
parts if the watchdog_thresh is increased.  And even worse it might lead
to KABOOM if the watchdog is configured to panic on such a spurious
lockup.

This patch fixes the issue by updating both nmi perf even counter and
hrtimers if the threshold value has changed.

The nmi one is disabled and then reinitialized from scratch.  This has an
unpleasant side effect that the allocation of the new event might fail
theoretically so the hard lockup detector would be disabled for such cpus.
 On the other hand such a memory allocation failure is very unlikely
because the original event is deallocated right before.  It would be much
nicer if we just changed perf event period but there doesn't seem to be
any API to do that right now.  It is also unfortunate that
perf_event_alloc uses GFP_KERNEL allocation unconditionally so we cannot
use on_each_cpu() and do the same thing from the per-cpu context.  The
update from the current CPU should be safe because perf_event_disable
removes the event atomically before it clears the per-cpu watchdog_ev so
it cannot change anything under running handler feet.

The hrtimer is simply restarted (thanks to Don Zickus who has pointed this
out) if it is queued because we cannot rely it will fire&adopt to the new
sampling period before a new nmi event triggers (when the treshold is
decreased).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   53 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff -puN kernel/watchdog.c~watchdog-update-watchdog_tresh-properly kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-update-watchdog_tresh-properly
+++ a/kernel/watchdog.c
@@ -486,7 +486,52 @@ static struct smp_hotplug_thread watchdo
 	.unpark			= watchdog_enable,
 };
 
-static int watchdog_enable_all_cpus(void)
+static void restart_watchdog_hrtimer(void *info)
+{
+	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
+	int ret;
+
+	/*
+	 * No need to cancel and restart hrtimer if it is currently executing
+	 * because it will reprogram itself with the new period now.
+	 * We should never see it unqueued here because we are running per-cpu
+	 * with interrupts disabled.
+	 */
+	ret = hrtimer_try_to_cancel(hrtimer);
+	if (ret == 1)
+		hrtimer_start(hrtimer, ns_to_ktime(sample_period),
+				HRTIMER_MODE_REL_PINNED);
+}
+
+static void update_timers(int cpu)
+{
+	struct call_single_data data = {.func = restart_watchdog_hrtimer};
+	/*
+	 * Make sure that perf event counter will adopt to a new
+	 * sampling period. Updating the sampling period directly would
+	 * be much nicer but we do not have an API for that now so
+	 * let's use a big hammer.
+	 * Hrtimer will adopt the new period on the next tick but this
+	 * might be late already so we have to restart the timer as well.
+	 */
+	watchdog_nmi_disable(cpu);
+	__smp_call_function_single(cpu, &data, 1);
+	watchdog_nmi_enable(cpu);
+}
+
+static void update_timers_all_cpus(void)
+{
+	int cpu;
+
+	get_online_cpus();
+	preempt_disable();
+	for_each_online_cpu(cpu)
+		update_timers(cpu);
+	preempt_enable();
+	put_online_cpus();
+}
+
+static int watchdog_enable_all_cpus(bool sample_period_changed)
 {
 	int err = 0;
 
@@ -496,6 +541,8 @@ static int watchdog_enable_all_cpus(void
 			pr_err("Failed to create watchdog threads, disabled\n");
 		else
 			watchdog_running = 1;
+	} else if (sample_period_changed) {
+		update_timers_all_cpus();
 	}
 
 	return err;
@@ -537,7 +584,7 @@ int proc_dowatchdog(struct ctl_table *ta
 	 * watchdog_*_all_cpus() function takes care of this.
 	 */
 	if (watchdog_user_enabled && watchdog_thresh)
-		err = watchdog_enable_all_cpus();
+		err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
 	else
 		watchdog_disable_all_cpus();
 
@@ -565,5 +612,5 @@ void __init lockup_detector_init(void)
 #endif
 
 	if (watchdog_user_enabled)
-		watchdog_enable_all_cpus();
+		watchdog_enable_all_cpus(false);
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

vmpressure-change-vmpressure-sr_lock-to-spinlock.patch
vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined-checkpatch-fixes.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
mm-fix-potential-null-pointer-dereference.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch

