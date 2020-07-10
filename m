From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch added to -mm
 tree
Date: Thu, 09 Jul 2020 17:15:45 -0700
Message-ID: <20200710001545.pqOdoXX80%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgGJAPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 20:15:47 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laoar.shao@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, rientjes@google.com


The patch titled
     Subject: mm, oom: make the calculation of oom badness more accurate
has been added to the -mm tree.  Its filename is
     mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, oom: make the calculation of oom badness more accurate

Recently we found an issue on our production environment that when memcg
oom is triggered the oom killer doesn't chose the process with largest
resident memory but chose the first scanned process.  Note that all
processes in this memcg have the same oom_score_adj, so the oom killer
should chose the process with largest resident memory.

Bellow is part of the oom info, which is enough to analyze this issue.
[7516987.983223] memory: usage 16777216kB, limit 16777216kB, failcnt 52843037
[7516987.983224] memory+swap: usage 16777216kB, limit 9007199254740988kB, failcnt 0
[7516987.983225] kmem: usage 301464kB, limit 9007199254740988kB, failcnt 0
[...]
[7516987.983293] [ pid ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
[7516987.983510] [ 5740]     0  5740      257        1    32768        0          -998 pause
[7516987.983574] [58804]     0 58804     4594      771    81920        0          -998 entry_point.bas
[7516987.983577] [58908]     0 58908     7089      689    98304        0          -998 cron
[7516987.983580] [58910]     0 58910    16235     5576   163840        0          -998 supervisord
[7516987.983590] [59620]     0 59620    18074     1395   188416        0          -998 sshd
[7516987.983594] [59622]     0 59622    18680     6679   188416        0          -998 python
[7516987.983598] [59624]     0 59624  1859266     5161   548864        0          -998 odin-agent
[7516987.983600] [59625]     0 59625   707223     9248   983040        0          -998 filebeat
[7516987.983604] [59627]     0 59627   416433    64239   774144        0          -998 odin-log-agent
[7516987.983607] [59631]     0 59631   180671    15012   385024        0          -998 python3
[7516987.983612] [61396]     0 61396   791287     3189   352256        0          -998 client
[7516987.983615] [61641]     0 61641  1844642    29089   946176        0          -998 client
[7516987.983765] [ 9236]     0  9236     2642      467    53248        0          -998 php_scanner
[7516987.983911] [42898]     0 42898    15543      838   167936        0          -998 su
[7516987.983915] [42900]  1000 42900     3673      867    77824        0          -998 exec_script_vr2
[7516987.983918] [42925]  1000 42925    36475    19033   335872        0          -998 python
[7516987.983921] [57146]  1000 57146     3673      848    73728        0          -998 exec_script_J2p
[7516987.983925] [57195]  1000 57195   186359    22958   491520        0          -998 python2
[7516987.983928] [58376]  1000 58376   275764    14402   290816        0          -998 rosmaster
[7516987.983931] [58395]  1000 58395   155166     4449   245760        0          -998 rosout
[7516987.983935] [58406]  1000 58406 18285584  3967322 37101568        0          -998 data_sim
[7516987.984221] oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=3aa16c9482ae3a6f6b78bda68a55d32c87c99b985e0f11331cddf05af6c4d753,mems_allowed=0-1,oom_memcg=/kubepods/podf1c273d3-9b36-11ea-b3df-246e9693c184,task_memcg=/kubepods/podf1c273d3-9b36-11ea-b3df-246e9693c184/1f246a3eeea8f70bf91141eeaf1805346a666e225f823906485ea0b6c37dfc3d,task=pause,pid=5740,uid=0
[7516987.984254] Memory cgroup out of memory: Killed process 5740 (pause) total-vm:1028kB, anon-rss:4kB, file-rss:0kB, shmem-rss:0kB
[7516988.092344] oom_reaper: reaped process 5740 (pause), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB

We can find that the first scanned process 5740 (pause) was killed, but
its rss is only one page.  That is because, when we calculate the oom
badness in oom_badness(), we always ignore the negtive point and convert
all of these negtive points to 1.  Now as oom_score_adj of all the
processes in this targeted memcg have the same value -998, the points of
these processes are all negtive value.  As a result, the first scanned
process will be killed.

The oom_socre_adj (-998) in this memcg is set by kubelet, because it is a
a Guaranteed pod, which has higher priority to prevent from being killed
by system oom.

To fix this issue, we should make the calculation of oom point more
accurate.  We can achieve it by convert the chosen_point from 'unsigned
long' to 'long'.

Link: http://lkml.kernel.org/r/1594309987-9919-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    1 +
 fs/proc/base.c      |    7 ++++++-
 include/linux/oom.h |    4 ++--
 mm/memcontrol.c     |    1 +
 mm/oom_kill.c       |   19 ++++++++-----------
 mm/page_alloc.c     |    1 +
 6 files changed, 19 insertions(+), 14 deletions(-)

--- a/drivers/tty/sysrq.c~mm-oom-make-the-calculation-of-oom-badness-more-accurate
+++ a/drivers/tty/sysrq.c
@@ -382,6 +382,7 @@ static void moom_callback(struct work_st
 		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = -1,
+		.chosen_points = LONG_MIN,
 	};
 
 	mutex_lock(&oom_lock);
--- a/fs/proc/base.c~mm-oom-make-the-calculation-of-oom-badness-more-accurate
+++ a/fs/proc/base.c
@@ -551,8 +551,13 @@ static int proc_oom_score(struct seq_fil
 {
 	unsigned long totalpages = totalram_pages() + total_swap_pages;
 	unsigned long points = 0;
+	long badness;
 
-	points = oom_badness(task, totalpages) * 1000 / totalpages;
+	badness = oom_badness(task, totalpages);
+	if (badness != LONG_MIN) {
+		/* Let's keep the range of points as [0, 2000]. */
+		points = (1000 + badness * 1000 / (long)totalpages) * 2 / 3;
+	}
 	seq_printf(m, "%lu\n", points);
 
 	return 0;
--- a/include/linux/oom.h~mm-oom-make-the-calculation-of-oom-badness-more-accurate
+++ a/include/linux/oom.h
@@ -48,7 +48,7 @@ struct oom_control {
 	/* Used by oom implementation, do not set */
 	unsigned long totalpages;
 	struct task_struct *chosen;
-	unsigned long chosen_points;
+	long chosen_points;
 
 	/* Used to print the constraint info. */
 	enum oom_constraint constraint;
@@ -107,7 +107,7 @@ static inline vm_fault_t check_stable_ad
 
 bool __oom_reap_task_mm(struct mm_struct *mm);
 
-extern unsigned long oom_badness(struct task_struct *p,
+long oom_badness(struct task_struct *p,
 		unsigned long totalpages);
 
 extern bool out_of_memory(struct oom_control *oc);
--- a/mm/memcontrol.c~mm-oom-make-the-calculation-of-oom-badness-more-accurate
+++ a/mm/memcontrol.c
@@ -1666,6 +1666,7 @@ static bool mem_cgroup_out_of_memory(str
 		.memcg = memcg,
 		.gfp_mask = gfp_mask,
 		.order = order,
+		.chosen_points = LONG_MIN,
 	};
 	bool ret;
 
--- a/mm/oom_kill.c~mm-oom-make-the-calculation-of-oom-badness-more-accurate
+++ a/mm/oom_kill.c
@@ -196,17 +196,17 @@ static bool is_dump_unreclaim_slabs(void
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom failures.
  */
-unsigned long oom_badness(struct task_struct *p, unsigned long totalpages)
+long oom_badness(struct task_struct *p, unsigned long totalpages)
 {
 	long points;
 	long adj;
 
 	if (oom_unkillable_task(p))
-		return 0;
+		return LONG_MIN;
 
 	p = find_lock_task_mm(p);
 	if (!p)
-		return 0;
+		return LONG_MIN;
 
 	/*
 	 * Do not even consider tasks which are explicitly marked oom
@@ -218,7 +218,7 @@ unsigned long oom_badness(struct task_st
 			test_bit(MMF_OOM_SKIP, &p->mm->flags) ||
 			in_vfork(p)) {
 		task_unlock(p);
-		return 0;
+		return LONG_MIN;
 	}
 
 	/*
@@ -233,11 +233,7 @@ unsigned long oom_badness(struct task_st
 	adj *= totalpages / 1000;
 	points += adj;
 
-	/*
-	 * Never return 0 for an eligible task regardless of the root bonus and
-	 * oom_score_adj (oom_score_adj can't be OOM_SCORE_ADJ_MIN here).
-	 */
-	return points > 0 ? points : 1;
+	return points;
 }
 
 static const char * const oom_constraint_text[] = {
@@ -336,12 +332,12 @@ static int oom_evaluate_task(struct task
 	 * killed first if it triggers an oom, then select it.
 	 */
 	if (oom_task_origin(task)) {
-		points = ULONG_MAX;
+		points = LONG_MAX;
 		goto select;
 	}
 
 	points = oom_badness(task, oc->totalpages);
-	if (!points || points < oc->chosen_points)
+	if (points == LONG_MIN || points < oc->chosen_points)
 		goto next;
 
 select:
@@ -1128,6 +1124,7 @@ void pagefault_out_of_memory(void)
 		.memcg = NULL,
 		.gfp_mask = 0,
 		.order = 0,
+		.chosen_points = LONG_MIN,
 	};
 
 	if (mem_cgroup_oom_synchronize(true))
--- a/mm/page_alloc.c~mm-oom-make-the-calculation-of-oom-badness-more-accurate
+++ a/mm/page_alloc.c
@@ -3915,6 +3915,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = order,
+		.chosen_points = LONG_MIN,
 	};
 	struct page *page;
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch
