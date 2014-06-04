From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:52:07 -0700
Message-ID: <538fa317.GIMi1hX6c8jFtQpW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaFDWwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, iskra@mcs.anl.gov, gong.chen@linux.jf.intel.com, bp@suse.de, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: [folded-merged] mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-fix.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org,bp@suse.de,gong.chen@linux.jf.intel.com,iskra@mcs.anl.gov,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:52:07 -0700


The patch titled
     Subject: mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-fix.patch

This patch was dropped because it was folded into mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-fix

We don't need this rcu_read_lock().

Cc: Tony Luck <tony.luck@intel.com>
Cc: Kamil Iskra <iskra@mcs.anl.gov>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Chen Gong <gong.chen@linux.jf.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-fix
+++ a/mm/memory-failure.c
@@ -384,19 +384,18 @@ static void kill_procs(struct list_head
  * Find a dedicated thread which is supposed to handle SIGBUS(BUS_MCEERR_AO)
  * on behalf of the thread group. Return task_struct of the (first found)
  * dedicated thread if found, and return NULL otherwise.
+ *
+ * We already hold read_lock(&tasklist_lock) in the caller, so we don't
+ * have to call rcu_read_lock/unlock() in this function.
  */
 static struct task_struct *find_early_kill_thread(struct task_struct *tsk)
 {
 	struct task_struct *t;
 
-	rcu_read_lock();
 	for_each_thread(tsk, t)
 		if ((t->flags & PF_MCE_PROCESS) && (t->flags & PF_MCE_EARLY))
-			goto found;
-	t = NULL;
-found:
-	rcu_read_unlock();
-	return t;
+			return t;
+	return NULL;
 }
 
 /*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch
pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch
hugetlb-restrict-hugepage_migration_support-to-x86_64.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-memory-failurec-move-comment.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
hwpoison-remove-unused-global-variable-in-do_machine_check.patch
hugetlb-rename-hugepage_migration_support-to-_supported.patch
memory-failure-send-right-signal-code-to-correct-thread.patch
memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch

