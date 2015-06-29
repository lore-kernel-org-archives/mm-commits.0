From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:38:13 -0700
Message-ID: <5591acb5.Vwo6s7RuW9eCbJK8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbbF2UiO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aarcange@redhat.com, david@fromorbit.com, mhocko@suse.cz, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom_kill: clean up victim marking and exiting interfaces
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: oom_kill: clean up victim marking and exiting interfaces

Rename unmark_oom_victim() to exit_oom_victim().  Marking and unmarking
are related in functionality, but the interface is not symmetrical at all:
one is an internal OOM killer function used during the killing, the other
is for an OOM victim to signal its own death on exit later on.  This has
locking implications, see follow-up changes.

While at it, rename mark_tsk_oom_victim() to mark_oom_victim(), which
is easier on the eye.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/lowmemorykiller.c |    2 +-
 include/linux/oom.h                       |    7 ++++---
 kernel/exit.c                             |    2 +-
 mm/memcontrol.c                           |    2 +-
 mm/oom_kill.c                             |   16 +++++++---------
 5 files changed, 14 insertions(+), 15 deletions(-)

diff -puN drivers/staging/android/lowmemorykiller.c~mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -165,7 +165,7 @@ static unsigned long lowmem_scan(struct
 		 * infrastructure. There is no real reason why the selected
 		 * task should have access to the memory reserves.
 		 */
-		mark_tsk_oom_victim(selected);
+		mark_oom_victim(selected);
 		send_sig(SIGKILL, selected, 0);
 		rem += selected_tasksize;
 	}
diff -puN include/linux/oom.h~mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces include/linux/oom.h
--- a/include/linux/oom.h~mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces
+++ a/include/linux/oom.h
@@ -47,9 +47,7 @@ static inline bool oom_task_origin(const
 	return !!(p->signal->oom_flags & OOM_FLAG_ORIGIN);
 }
 
-extern void mark_tsk_oom_victim(struct task_struct *tsk);
-
-extern void unmark_oom_victim(void);
+extern void mark_oom_victim(struct task_struct *tsk);
 
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
@@ -75,6 +73,9 @@ extern enum oom_scan_t oom_scan_process_
 
 extern bool out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *mask, bool force_kill);
+
+extern void exit_oom_victim(void);
+
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
diff -puN kernel/exit.c~mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces kernel/exit.c
--- a/kernel/exit.c~mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces
+++ a/kernel/exit.c
@@ -436,7 +436,7 @@ static void exit_mm(struct task_struct *
 	mm_update_next_owner(mm);
 	mmput(mm);
 	if (test_thread_flag(TIF_MEMDIE))
-		unmark_oom_victim();
+		exit_oom_victim();
 }
 
 static struct task_struct *find_alive_thread(struct task_struct *p)
diff -puN mm/memcontrol.c~mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces
+++ a/mm/memcontrol.c
@@ -1536,7 +1536,7 @@ static void mem_cgroup_out_of_memory(str
 	 * quickly exit and free its memory.
 	 */
 	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
-		mark_tsk_oom_victim(current);
+		mark_oom_victim(current);
 		return;
 	}
 
diff -puN mm/oom_kill.c~mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces
+++ a/mm/oom_kill.c
@@ -408,13 +408,13 @@ bool oom_killer_disabled __read_mostly;
 static DECLARE_RWSEM(oom_sem);
 
 /**
- * mark_tsk_oom_victim - marks the given task as OOM victim.
+ * mark_oom_victim - mark the given task as OOM victim
  * @tsk: task to mark
  *
  * Has to be called with oom_sem taken for read and never after
  * oom has been disabled already.
  */
-void mark_tsk_oom_victim(struct task_struct *tsk)
+void mark_oom_victim(struct task_struct *tsk)
 {
 	WARN_ON(oom_killer_disabled);
 	/* OOM killer might race with memcg OOM */
@@ -431,11 +431,9 @@ void mark_tsk_oom_victim(struct task_str
 }
 
 /**
- * unmark_oom_victim - unmarks the current task as OOM victim.
- *
- * Wakes up all waiters in oom_killer_disable()
+ * exit_oom_victim - note the exit of an OOM victim
  */
-void unmark_oom_victim(void)
+void exit_oom_victim(void)
 {
 	if (!test_and_clear_thread_flag(TIF_MEMDIE))
 		return;
@@ -515,7 +513,7 @@ void oom_kill_process(struct task_struct
 	 */
 	task_lock(p);
 	if (p->mm && task_will_free_mem(p)) {
-		mark_tsk_oom_victim(p);
+		mark_oom_victim(p);
 		task_unlock(p);
 		put_task_struct(p);
 		return;
@@ -570,7 +568,7 @@ void oom_kill_process(struct task_struct
 
 	/* mm cannot safely be dereferenced after task_unlock(victim) */
 	mm = victim->mm;
-	mark_tsk_oom_victim(victim);
+	mark_oom_victim(victim);
 	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
 		task_pid_nr(victim), victim->comm, K(victim->mm->total_vm),
 		K(get_mm_counter(victim->mm, MM_ANONPAGES)),
@@ -728,7 +726,7 @@ static void __out_of_memory(struct zonel
 	 */
 	if (current->mm &&
 	    (fatal_signal_pending(current) || task_will_free_mem(current))) {
-		mark_tsk_oom_victim(current);
+		mark_oom_victim(current);
 		return;
 	}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch

