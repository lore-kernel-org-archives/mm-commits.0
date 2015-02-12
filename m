From: akpm@linux-foundation.org
Subject: [merged]
 oom-add-helpers-for-setting-and-clearing-tif_memdie.patch removed from -mm
 tree
Date: Thu, 12 Feb 2015 11:37:00 -0800
Message-ID: <54dd00dc.3rLvF9QOruJWVvAR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbbBLThB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: add helpers for setting and clearing TIF_MEMDIE
has been removed from the -mm tree.  Its filename was
     oom-add-helpers-for-setting-and-clearing-tif_memdie.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: oom: add helpers for setting and clearing TIF_MEMDIE

This patchset addresses a race which was described in the changelog for
5695be142e20 ("OOM, PM: OOM killed task shouldn't escape PM suspend"):

: PM freezer relies on having all tasks frozen by the time devices are
: getting frozen so that no task will touch them while they are getting
: frozen.  But OOM killer is allowed to kill an already frozen task in order
: to handle OOM situtation.  In order to protect from late wake ups OOM
: killer is disabled after all tasks are frozen.  This, however, still keeps
: a window open when a killed task didn't manage to die by the time
: freeze_processes finishes.

The original patch hasn't closed the race window completely because that
would require a more complex solution as it can be seen by this patchset.

The primary motivation was to close the race condition between OOM killer
and PM freezer _completely_.  As Tejun pointed out, even though the race
condition is unlikely the harder it would be to debug weird bugs deep in
the PM freezer when the debugging options are reduced considerably.  I can
only speculate what might happen when a task is still runnable
unexpectedly.

On a plus side and as a side effect the oom enable/disable has a better
(full barrier) semantic without polluting hot paths.



I have tested the series in KVM with 100M RAM:
- many small tasks (20M anon mmap) which are triggering OOM continually
- s2ram which resumes automatically is triggered in a loop
	echo processors > /sys/power/pm_test
	while true
	do
		echo mem > /sys/power/state
		sleep 1s
	done
- simple module which allocates and frees 20M in 8K chunks. If it sees
  freezing(current) then it tries another round of allocation before calling
  try_to_freeze
- debugging messages of PM stages and OOM killer enable/disable/fail added
  and unmark_oom_victim is delayed by 1s after it clears TIF_MEMDIE and before
  it wakes up waiters.
- rebased on top of the current mmotm which means some necessary updates
  in mm/oom_kill.c. mark_tsk_oom_victim is now called under task_lock but
  I think this should be OK because __thaw_task shouldn't interfere with any
  locking down wake_up_process. Oleg?

As expected there are no OOM killed tasks after oom is disabled and
allocations requested by the kernel thread are failing after all the tasks
are frozen and OOM disabled.  I wasn't able to catch a race where
oom_killer_disable would really have to wait but I kinda expected the race
is really unlikely.

[  242.609330] Killed process 2992 (mem_eater) total-vm:24412kB, anon-rss:2164kB, file-rss:4kB
[  243.628071] Unmarking 2992 OOM victim. oom_victims: 1
[  243.636072] (elapsed 2.837 seconds) done.
[  243.641985] Trying to disable OOM killer
[  243.643032] Waiting for concurent OOM victims
[  243.644342] OOM killer disabled
[  243.645447] Freezing remaining freezable tasks ... (elapsed 0.005 seconds) done.
[  243.652983] Suspending console(s) (use no_console_suspend to debug)
[  243.903299] kmem_eater: page allocation failure: order:1, mode:0x204010
[...]
[  243.992600] PM: suspend of devices complete after 336.667 msecs
[  243.993264] PM: late suspend of devices complete after 0.660 msecs
[  243.994713] PM: noirq suspend of devices complete after 1.446 msecs
[  243.994717] ACPI: Preparing to enter system sleep state S3
[  243.994795] PM: Saving platform NVS memory
[  243.994796] Disabling non-boot CPUs ...

The first 2 patches are simple cleanups for OOM.  They should go in
regardless the rest IMO.

Patches 3 and 4 are trivial printk -> pr_info conversion and they should
go in ditto.

The main patch is the last one and I would appreciate acks from Tejun and
Rafael.  I think the OOM part should be OK (except for __thaw_task vs. 
task_lock where a look from Oleg would appreciated) but I am not so sure I
haven't screwed anything in the freezer code.  I have found several
surprises there.




This patch (of 5):

This patch is just a preparatory and it doesn't introduce any functional
change.

Note:
I am utterly unhappy about lowmemory killer abusing TIF_MEMDIE just to
wait for the oom victim and to prevent from new killing. This is
just a side effect of the flag. The primary meaning is to give the oom
victim access to the memory reserves and that shouldn't be necessary
here.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/lowmemorykiller.c |    7 +++++-
 include/linux/oom.h                       |    4 +++
 kernel/exit.c                             |    2 -
 mm/memcontrol.c                           |    2 -
 mm/oom_kill.c                             |   23 +++++++++++++++++---
 5 files changed, 32 insertions(+), 6 deletions(-)

diff -puN drivers/staging/android/lowmemorykiller.c~oom-add-helpers-for-setting-and-clearing-tif_memdie drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~oom-add-helpers-for-setting-and-clearing-tif_memdie
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -160,7 +160,12 @@ static unsigned long lowmem_scan(struct
 			     selected->pid, selected->comm,
 			     selected_oom_score_adj, selected_tasksize);
 		lowmem_deathpending_timeout = jiffies + HZ;
-		set_tsk_thread_flag(selected, TIF_MEMDIE);
+		/*
+		 * FIXME: lowmemorykiller shouldn't abuse global OOM killer
+		 * infrastructure. There is no real reason why the selected
+		 * task should have access to the memory reserves.
+		 */
+		mark_tsk_oom_victim(selected);
 		send_sig(SIGKILL, selected, 0);
 		rem += selected_tasksize;
 	}
diff -puN include/linux/oom.h~oom-add-helpers-for-setting-and-clearing-tif_memdie include/linux/oom.h
--- a/include/linux/oom.h~oom-add-helpers-for-setting-and-clearing-tif_memdie
+++ a/include/linux/oom.h
@@ -47,6 +47,10 @@ static inline bool oom_task_origin(const
 	return !!(p->signal->oom_flags & OOM_FLAG_ORIGIN);
 }
 
+extern void mark_tsk_oom_victim(struct task_struct *tsk);
+
+extern void unmark_oom_victim(void);
+
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
diff -puN kernel/exit.c~oom-add-helpers-for-setting-and-clearing-tif_memdie kernel/exit.c
--- a/kernel/exit.c~oom-add-helpers-for-setting-and-clearing-tif_memdie
+++ a/kernel/exit.c
@@ -435,7 +435,7 @@ static void exit_mm(struct task_struct *
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
-	clear_thread_flag(TIF_MEMDIE);
+	unmark_oom_victim();
 }
 
 static struct task_struct *find_alive_thread(struct task_struct *p)
diff -puN mm/memcontrol.c~oom-add-helpers-for-setting-and-clearing-tif_memdie mm/memcontrol.c
--- a/mm/memcontrol.c~oom-add-helpers-for-setting-and-clearing-tif_memdie
+++ a/mm/memcontrol.c
@@ -1556,7 +1556,7 @@ static void mem_cgroup_out_of_memory(str
 	 * quickly exit and free its memory.
 	 */
 	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
-		set_thread_flag(TIF_MEMDIE);
+		mark_tsk_oom_victim(current);
 		return;
 	}
 
diff -puN mm/oom_kill.c~oom-add-helpers-for-setting-and-clearing-tif_memdie mm/oom_kill.c
--- a/mm/oom_kill.c~oom-add-helpers-for-setting-and-clearing-tif_memdie
+++ a/mm/oom_kill.c
@@ -416,6 +416,23 @@ void note_oom_kill(void)
 	atomic_inc(&oom_kills);
 }
 
+/**
+ * mark_tsk_oom_victim - marks the given taks as OOM victim.
+ * @tsk: task to mark
+ */
+void mark_tsk_oom_victim(struct task_struct *tsk)
+{
+	set_tsk_thread_flag(tsk, TIF_MEMDIE);
+}
+
+/**
+ * unmark_oom_victim - unmarks the current task as OOM victim.
+ */
+void unmark_oom_victim(void)
+{
+	clear_thread_flag(TIF_MEMDIE);
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /*
  * Must be called while holding a reference to p, which will be released upon
@@ -440,7 +457,7 @@ void oom_kill_process(struct task_struct
 	 */
 	task_lock(p);
 	if (p->mm && task_will_free_mem(p)) {
-		set_tsk_thread_flag(p, TIF_MEMDIE);
+		mark_tsk_oom_victim(p);
 		task_unlock(p);
 		put_task_struct(p);
 		return;
@@ -495,7 +512,7 @@ void oom_kill_process(struct task_struct
 
 	/* mm cannot safely be dereferenced after task_unlock(victim) */
 	mm = victim->mm;
-	set_tsk_thread_flag(victim, TIF_MEMDIE);
+	mark_tsk_oom_victim(victim);
 	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
 		task_pid_nr(victim), victim->comm, K(victim->mm->total_vm),
 		K(get_mm_counter(victim->mm, MM_ANONPAGES)),
@@ -652,7 +669,7 @@ void out_of_memory(struct zonelist *zone
 	 */
 	if (current->mm &&
 	    (fatal_signal_pending(current) || task_will_free_mem(current))) {
-		set_thread_flag(TIF_MEMDIE);
+		mark_tsk_oom_victim(current);
 		return;
 	}
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
memcg-cleanup-static-keys-decrement.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

