From: akpm@linux-foundation.org
Subject: + oom-do-not-live-lock-on-frozen-tasks.patch added to -mm tree
Date: Fri, 28 Oct 2011 15:23:47 -0700
Message-ID: <201110282223.p9SMNl50018144@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:35310 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1J1WYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:24:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, rientjes@google.com, rjw@sisk.pl


The patch titled
     Subject: oom: do not live lock on frozen tasks
has been added to the -mm tree.  Its filename is
     oom-do-not-live-lock-on-frozen-tasks.patch

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
From: Michal Hocko <mhocko@suse.cz>
Subject: oom: do not live lock on frozen tasks

Konstantin Khlebnikov has reported (https://lkml.org/lkml/2011/8/23/45)
that OOM can end up in a live lock if select_bad_process picks up a frozen
task.

Unfortunately we cannot mark such processes as unkillable to ignore them
because we could panic the system even though there is a chance that
somebody could thaw the process so we can make a forward process (e.g. a
process from another cpuset or with a different nodemask).

Let's thaw an OOM selected frozen process right after we've sent fatal
signal from oom_kill_task.

Thawing is safe if the frozen task doesn't access any suspended device
(e.g.  by ioctl) on the way out to the userspace where we handle the
signal and die.  Note, we are not interested in the kernel threads because
they are not oom killable.

Accessing suspended devices by a userspace processes shouldn't be an issue
because devices are suspended only after userspace is already frozen and
oom is disabled at that time.

Other than that userspace accesses the fridge only from the signal
handling routines so we are able to handle SIGKILL without any negative
side effects or we always check for pending signals after we return from
try_to_freeze (e.g.  in lguest).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/oom_kill.c~oom-do-not-live-lock-on-frozen-tasks mm/oom_kill.c
--- a/mm/oom_kill.c~oom-do-not-live-lock-on-frozen-tasks
+++ a/mm/oom_kill.c
@@ -462,10 +462,15 @@ static int oom_kill_task(struct task_str
 				task_pid_nr(q), q->comm);
 			task_unlock(q);
 			force_sig(SIGKILL, q);
+
+			if (frozen(q))
+				thaw_process(q);
 		}
 
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 	force_sig(SIGKILL, p);
+	if (frozen(p))
+		thaw_process(p);
 
 	return 0;
 }
_
Subject: Subject: oom: do not live lock on frozen tasks

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks.patch
oom-thaw-threads-if-oom-killed-thread-is-frozen-before-deferring.patch
oom-do-not-live-lock-on-frozen-tasks.patch
cgroup-kmemleak-annotate-alloc_page-for-cgroup-allocations.patch
memcg-rename-mem-variable-to-memcg.patch
memcg-fix-oom-schedule_timeout.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch
memcg-close-race-between-charge-and-putback.patch

