From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom_kill-count-global-and-memory-cgroup-oom-kills.patch removed from -mm
 tree
Date: Fri, 07 Jul 2017 12:11:17 -0700
Message-ID: <20170707191117.SzdJ34bTl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34642 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdGGTLS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guroan@gmail.com, khlebnikov@yandex-team.ru, mhocko@kernel.org, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com


The patch titled
     Subject: mm/oom_kill: count global and memory cgroup oom kills
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-count-global-and-memory-cgroup-oom-kills.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/oom_kill: count global and memory cgroup oom kills

Show count of oom killer invocations in /proc/vmstat and count of
processes killed in memory cgroup in knob "memory.events" (in
memory.oom_control for v1 cgroup).

Also describe difference between "oom" and "oom_kill" in memory cgroup
documentation.  Currently oom in memory cgroup kills tasks iff shortage
has happened inside page fault.

These counters helps in monitoring oom kills - for now
the only way is grepping for magic words in kernel log.

[akpm@linux-foundation.org: fix for mem_cgroup_count_vm_event() rename]
[akpm@linux-foundation.org: fix comment, per Konstantin]
Link: http://lkml.kernel.org/r/149570810989.203600.9492483715840752937.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Roman Guschin <guroan@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt   |   20 ++++++++++++++++----
 include/linux/memcontrol.h    |    5 ++++-
 include/linux/vm_event_item.h |    1 +
 mm/memcontrol.c               |    2 ++
 mm/oom_kill.c                 |    5 +++++
 mm/vmstat.c                   |    1 +
 6 files changed, 29 insertions(+), 5 deletions(-)

diff -puN Documentation/cgroup-v2.txt~mm-oom_kill-count-global-and-memory-cgroup-oom-kills Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-oom_kill-count-global-and-memory-cgroup-oom-kills
+++ a/Documentation/cgroup-v2.txt
@@ -852,13 +852,25 @@ PAGE_SIZE multiple when read back.
 
 		The number of times the cgroup's memory usage was
 		about to go over the max boundary.  If direct reclaim
-		fails to bring it down, the OOM killer is invoked.
+		fails to bring it down, the cgroup goes to OOM state.
 
 	  oom
 
-		The number of times the OOM killer has been invoked in
-		the cgroup.  This may not exactly match the number of
-		processes killed but should generally be close.
+		The number of time the cgroup's memory usage was
+		reached the limit and allocation was about to fail.
+
+		Depending on context result could be invocation of OOM
+		killer and retrying allocation or failing alloction.
+
+		Failed allocation in its turn could be returned into
+		userspace as -ENOMEM or siletly ignored in cases like
+		disk readahead.	 For now OOM in memory cgroup kills
+		tasks iff shortage has happened inside page fault.
+
+	  oom_kill
+
+		The number of processes belonging to this cgroup
+		killed by any kind of OOM killer.
 
   memory.stat
 
diff -puN include/linux/memcontrol.h~mm-oom_kill-count-global-and-memory-cgroup-oom-kills include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-oom_kill-count-global-and-memory-cgroup-oom-kills
+++ a/include/linux/memcontrol.h
@@ -582,8 +582,11 @@ static inline void count_memcg_event_mm(
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-	if (likely(memcg))
+	if (likely(memcg)) {
 		this_cpu_inc(memcg->stat->events[idx]);
+		if (idx == OOM_KILL)
+			cgroup_file_notify(&memcg->events_file);
+	}
 	rcu_read_unlock();
 }
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff -puN include/linux/vm_event_item.h~mm-oom_kill-count-global-and-memory-cgroup-oom-kills include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-oom_kill-count-global-and-memory-cgroup-oom-kills
+++ a/include/linux/vm_event_item.h
@@ -41,6 +41,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
 		PAGEOUTRUN, PGROTATED,
 		DROP_PAGECACHE, DROP_SLAB,
+		OOM_KILL,
 #ifdef CONFIG_NUMA_BALANCING
 		NUMA_PTE_UPDATES,
 		NUMA_HUGE_PTE_UPDATES,
diff -puN mm/memcontrol.c~mm-oom_kill-count-global-and-memory-cgroup-oom-kills mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom_kill-count-global-and-memory-cgroup-oom-kills
+++ a/mm/memcontrol.c
@@ -3573,6 +3573,7 @@ static int mem_cgroup_oom_control_read(s
 
 	seq_printf(sf, "oom_kill_disable %d\n", memcg->oom_kill_disable);
 	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
+	seq_printf(sf, "oom_kill %lu\n", memcg_sum_events(memcg, OOM_KILL));
 	return 0;
 }
 
@@ -5164,6 +5165,7 @@ static int memory_events_show(struct seq
 	seq_printf(m, "high %lu\n", memcg_sum_events(memcg, MEMCG_HIGH));
 	seq_printf(m, "max %lu\n", memcg_sum_events(memcg, MEMCG_MAX));
 	seq_printf(m, "oom %lu\n", memcg_sum_events(memcg, MEMCG_OOM));
+	seq_printf(m, "oom_kill %lu\n", memcg_sum_events(memcg, OOM_KILL));
 
 	return 0;
 }
diff -puN mm/oom_kill.c~mm-oom_kill-count-global-and-memory-cgroup-oom-kills mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-count-global-and-memory-cgroup-oom-kills
+++ a/mm/oom_kill.c
@@ -876,6 +876,11 @@ static void oom_kill_process(struct oom_
 	/* Get a reference to safely compare mm after task_unlock(victim) */
 	mm = victim->mm;
 	mmgrab(mm);
+
+	/* Raise event before sending signal: task reaper must see this */
+	count_vm_event(OOM_KILL);
+	count_memcg_event_mm(mm, OOM_KILL);
+
 	/*
 	 * We should send SIGKILL before setting TIF_MEMDIE in order to prevent
 	 * the OOM victim from depleting the memory reserves from the user
diff -puN mm/vmstat.c~mm-oom_kill-count-global-and-memory-cgroup-oom-kills mm/vmstat.c
--- a/mm/vmstat.c~mm-oom_kill-count-global-and-memory-cgroup-oom-kills
+++ a/mm/vmstat.c
@@ -1018,6 +1018,7 @@ const char * const vmstat_text[] = {
 
 	"drop_pagecache",
 	"drop_slab",
+	"oom_kill",
 
 #ifdef CONFIG_NUMA_BALANCING
 	"numa_pte_updates",
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are


