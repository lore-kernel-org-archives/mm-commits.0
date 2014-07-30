From: akpm@linux-foundation.org
Subject: + mm-oom-remove-unnecessary-exit_state-check.patch added to -mm
 tree
Date: Wed, 30 Jul 2014 14:08:02 -0700
Message-ID: <53d95eb2.lMWVardGechejpbt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:45365 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaG3VIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jul 2014 17:08:04 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so175196qap.2
        for <mm-commits@vger.kernel.org>; Wed, 30 Jul 2014 14:08:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: remove unnecessary exit_state check
has been added to the -mm tree.  Its filename is
     mm-oom-remove-unnecessary-exit_state-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-remove-unnecessary-exit_state-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-remove-unnecessary-exit_state-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: remove unnecessary exit_state check

The oom killer scans each process and determines whether it is eligible for oom
kill or whether the oom killer should abort because of concurrent memory
freeing.  It will abort when an eligible process is found to have TIF_MEMDIE
set, meaning it has already been oom killed and we're waiting for it to exit.

Processes with task->mm == NULL should not be considered because they are either
kthreads or have already detached their memory and killing them would not lead
to memory freeing.  That memory is only freed after exit_mm() has returned,
however, and not when task->mm is first set to NULL.

Clear TIF_MEMDIE after exit_mm()'s mmput() so that an oom killed process is no
longer considered for oom kill, but only until exit_mm() has returned.  This was
fragile in the past because it relied on exit_notify() to be reached before no
longer considering TIF_MEMDIE processes.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    1 +
 mm/oom_kill.c |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/exit.c~mm-oom-remove-unnecessary-exit_state-check kernel/exit.c
--- a/kernel/exit.c~mm-oom-remove-unnecessary-exit_state-check
+++ a/kernel/exit.c
@@ -455,6 +455,7 @@ static void exit_mm(struct task_struct *
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
+	clear_thread_flag(TIF_MEMDIE);
 }
 
 /*
diff -puN mm/oom_kill.c~mm-oom-remove-unnecessary-exit_state-check mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-remove-unnecessary-exit_state-check
+++ a/mm/oom_kill.c
@@ -256,8 +256,6 @@ enum oom_scan_t oom_scan_process_thread(
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill)
 {
-	if (task->exit_state)
-		return OOM_SCAN_CONTINUE;
 	if (oom_unkillable_task(task, NULL, nodemask))
 		return OOM_SCAN_CONTINUE;
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-thp-do-not-allow-thp-faults-to-avoid-cpuset-restrictions.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
score-ptrace-remove-the-macros-which-not-be-used-currently.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-defer-slab_destroy-in-free_block-v4.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
mm-trivial-comment-cleanup-in-slabc.patch
mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
mm-vmalloc-constify-allocation-mask.patch
mmhugetlb-make-unmap_ref_private-return-void.patch
mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-make-copy_pte_range-static-again.patch
mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-remove-unnecessary-check-for-null-zonelist.patch
mm-oom-rename-zonelist-locking-functions.patch
mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix.patch
mm-oom-remove-unnecessary-exit_state-check.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
lib-add-size-unit-t-p-e-to-memparse.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

