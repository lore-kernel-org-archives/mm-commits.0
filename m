From: akpm@linux-foundation.org
Subject: +
 mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch added to -mm tree
Date: Mon, 02 Jun 2014 15:45:14 -0700
Message-ID: <538cfe7a.MLonCuTFnalEFyev%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaFBWpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 18:45:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, stable@vger.kernel.org, iskra@mcs.anl.gov, gong.chen@linux.jf.intel.com, bp@suse.de, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: + mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org,bp@suse.de,gong.chen@linux.jf.intel.com,iskra@mcs.anl.gov,stable@vger.kernel.org,tony.luck@intel.com
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 15:45:14 -0700


The patch titled
     Subject: mm/memory-failure.c: support use of a dedicated thread to handle SIGBUS(BUS_MCEERR_AO)
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: support use of a dedicated thread to handle SIGBUS(BUS_MCEERR_AO)

Currently memory error handler handles action optional errors in the
deferred manner by default.  And if a recovery aware application wants to
handle it immediately, it can do it by setting PF_MCE_EARLY flag. 
However, such signal can be sent only to the main thread, so it's
problematic if the application wants to have a dedicated thread to handler
such signals.

So this patch adds dedicated thread support to memory error handler.  We
have PF_MCE_EARLY flags for each thread separately, so with this patch AO
signal is sent to the thread with PF_MCE_EARLY flag set, not the main
thread.  If you want to implement a dedicated thread, you call prctl() to
set PF_MCE_EARLY on the thread.

Memory error handler collects processes to be killed, so this patch lets
it check PF_MCE_EARLY flag on each thread in the collecting routines.

No behavioral change for all non-early kill cases.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: Kamil Iskra <iskra@mcs.anl.gov>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Chen Gong <gong.chen@linux.jf.intel.com>
Cc: <stable@vger.kernel.org>	[3.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hwpoison.txt |    5 ++
 mm/memory-failure.c           |   58 +++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 15 deletions(-)

diff -puN Documentation/vm/hwpoison.txt~mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao Documentation/vm/hwpoison.txt
--- a/Documentation/vm/hwpoison.txt~mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao
+++ a/Documentation/vm/hwpoison.txt
@@ -84,6 +84,11 @@ PR_MCE_KILL
 		PR_MCE_KILL_EARLY: Early kill
 		PR_MCE_KILL_LATE:  Late kill
 		PR_MCE_KILL_DEFAULT: Use system global default
+	Note that if you want to have a dedicated thread which handles
+	the SIGBUS(BUS_MCEERR_AO) on behalf of the process, you should
+	call prctl(PR_MCE_KILL_EARLY) on the designated thread. Otherwise,
+	the SIGBUS is sent to the main thread.
+
 PR_MCE_KILL_GET
 	return current mode
 
diff -puN mm/memory-failure.c~mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao
+++ a/mm/memory-failure.c
@@ -380,15 +380,44 @@ static void kill_procs(struct list_head
 	}
 }
 
-static int task_early_kill(struct task_struct *tsk, int force_early)
+/*
+ * Find a dedicated thread which is supposed to handle SIGBUS(BUS_MCEERR_AO)
+ * on behalf of the thread group. Return task_struct of the (first found)
+ * dedicated thread if found, and return NULL otherwise.
+ */
+static struct task_struct *find_early_kill_thread(struct task_struct *tsk)
+{
+	struct task_struct *t;
+	rcu_read_lock();
+	for_each_thread(tsk, t)
+		if ((t->flags & PF_MCE_PROCESS) && (t->flags & PF_MCE_EARLY))
+			goto found;
+	t = NULL;
+found:
+	rcu_read_unlock();
+	return t;
+}
+
+/*
+ * Determine whether a given process is "early kill" process which expects
+ * to be signaled when some page under the process is hwpoisoned.
+ * Return task_struct of the dedicated thread (main thread unless explicitly
+ * specified) if the process is "early kill," and otherwise returns NULL.
+ */
+static struct task_struct *task_early_kill(struct task_struct *tsk,
+					   int force_early)
 {
+	struct task_struct *t;
 	if (!tsk->mm)
-		return 0;
+		return NULL;
 	if (force_early)
-		return 1;
-	if (tsk->flags & PF_MCE_PROCESS)
-		return !!(tsk->flags & PF_MCE_EARLY);
-	return sysctl_memory_failure_early_kill;
+		return tsk;
+	t = find_early_kill_thread(tsk);
+	if (t)
+		return t;
+	if (sysctl_memory_failure_early_kill)
+		return tsk;
+	return NULL;
 }
 
 /*
@@ -410,16 +439,16 @@ static void collect_procs_anon(struct pa
 	read_lock(&tasklist_lock);
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
-
-		if (!task_early_kill(tsk, force_early))
+		struct task_struct *t = task_early_kill(tsk, force_early);
+		if (!t)
 			continue;
 		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
 					       pgoff, pgoff) {
 			vma = vmac->vma;
 			if (!page_mapped_in_vma(page, vma))
 				continue;
-			if (vma->vm_mm == tsk->mm)
-				add_to_kill(tsk, page, vma, to_kill, tkc);
+			if (vma->vm_mm == t->mm)
+				add_to_kill(t, page, vma, to_kill, tkc);
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -440,10 +469,9 @@ static void collect_procs_file(struct pa
 	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
 		pgoff_t pgoff = page_pgoff(page);
-
-		if (!task_early_kill(tsk, force_early))
+		struct task_struct *t = task_early_kill(tsk, force_early);
+		if (!t)
 			continue;
-
 		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
 				      pgoff) {
 			/*
@@ -453,8 +481,8 @@ static void collect_procs_file(struct pa
 			 * Assume applications who requested early kill want
 			 * to be informed of all such data corruptions.
 			 */
-			if (vma->vm_mm == tsk->mm)
-				add_to_kill(tsk, page, vma, to_kill, tkc);
+			if (vma->vm_mm == t->mm)
+				add_to_kill(t, page, vma, to_kill, tkc);
 		}
 	}
 	read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch
pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch
hugetlb-restrict-hugepage_migration_support-to-x86_64.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-pagewalkc-move-pte-null-check.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
mm-memory-failurec-move-comment.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
hwpoison-remove-unused-global-variable-in-do_machine_check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
hugetlb-rename-hugepage_migration_support-to-_supported.patch
memory-failure-send-right-signal-code-to-correct-thread.patch
memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

