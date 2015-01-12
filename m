From: akpm@linux-foundation.org
Subject: + oom-add-helpers-for-setting-and-clearing-tif_memdie.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:59:53 -0800
Message-ID: <54b45ff9.VrnQ+TiDcfrcrbAC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbALX7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: add helpers for setting and clearing TIF_MEMDIE
has been added to the -mm tree.  Its filename is
     oom-add-helpers-for-setting-and-clearing-tif_memdie.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-add-helpers-for-setting-and-clearing-tif_memdie.patch

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
Subject: oom: add helpers for setting and clearing TIF_MEMDIE

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
@@ -1581,7 +1581,7 @@ static void mem_cgroup_out_of_memory(str
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

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
vmscan-per-memory-cgroup-slab-shrinkers-fix.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

