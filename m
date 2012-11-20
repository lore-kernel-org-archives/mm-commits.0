From: akpm@linux-foundation.org
Subject: + mm-oom-remove-statically-defined-arch-functions-of-same-name.patch added to -mm tree
Date: Tue, 20 Nov 2012 15:17:08 -0800
Message-ID: <20121120231709.59D7F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59325 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2KTXRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 18:17:11 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so750340qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 15:17:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, benh@kernel.crashing.org, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, lethal@linux-sh.org, mhocko@suse.cz, mingo@redhat.com, paulus@samba.org, tglx@linutronix.de


The patch titled
     Subject: mm, oom: remove statically defined arch functions of same name
has been added to the -mm tree.  Its filename is
     mm-oom-remove-statically-defined-arch-functions-of-same-name.patch

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
Subject: mm, oom: remove statically defined arch functions of same name

out_of_memory() is a globally defined function to call the oom killer. 
x86, sh, and powerpc all use a function of the same name within file scope
in their respective fault.c unnecessarily.  Inline the functions into the
pagefault handlers to clean the code up.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/fault.c |   27 ++++++++++++---------------
 arch/sh/mm/fault.c      |   19 +++++++------------
 arch/x86/mm/fault.c     |   23 ++++++++---------------
 3 files changed, 27 insertions(+), 42 deletions(-)

diff -puN arch/powerpc/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name arch/powerpc/mm/fault.c
--- a/arch/powerpc/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name
+++ a/arch/powerpc/mm/fault.c
@@ -113,19 +113,6 @@ static int store_updates_sp(struct pt_re
 #define MM_FAULT_CONTINUE	-1
 #define MM_FAULT_ERR(sig)	(sig)
 
-static int out_of_memory(struct pt_regs *regs)
-{
-	/*
-	 * We ran out of memory, or some other thing happened to us that made
-	 * us unable to handle the page fault gracefully.
-	 */
-	up_read(&current->mm->mmap_sem);
-	if (!user_mode(regs))
-		return MM_FAULT_ERR(SIGKILL);
-	pagefault_out_of_memory();
-	return MM_FAULT_RETURN;
-}
-
 static int do_sigbus(struct pt_regs *regs, unsigned long address)
 {
 	siginfo_t info;
@@ -169,8 +156,18 @@ static int mm_fault_error(struct pt_regs
 		return MM_FAULT_CONTINUE;
 
 	/* Out of memory */
-	if (fault & VM_FAULT_OOM)
-		return out_of_memory(regs);
+	if (fault & VM_FAULT_OOM) {
+		up_read(&current->mm->mmap_sem);
+
+		/*
+		 * We ran out of memory, or some other thing happened to us that
+		 * made us unable to handle the page fault gracefully.
+		 */
+		if (!user_mode(regs))
+			return MM_FAULT_ERR(SIGKILL);
+		pagefault_out_of_memory();
+		return MM_FAULT_RETURN;
+	}
 
 	/* Bus error. x86 handles HWPOISON here, we'll add this if/when
 	 * we support the feature in HW
diff -puN arch/sh/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name arch/sh/mm/fault.c
--- a/arch/sh/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name
+++ a/arch/sh/mm/fault.c
@@ -301,17 +301,6 @@ bad_area_access_error(struct pt_regs *re
 	__bad_area(regs, error_code, address, SEGV_ACCERR);
 }
 
-static void out_of_memory(void)
-{
-	/*
-	 * We ran out of memory, call the OOM killer, and return the userspace
-	 * (which will retry the fault, or kill us if we got oom-killed):
-	 */
-	up_read(&current->mm->mmap_sem);
-
-	pagefault_out_of_memory();
-}
-
 static void
 do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address)
 {
@@ -353,8 +342,14 @@ mm_fault_error(struct pt_regs *regs, uns
 			no_context(regs, error_code, address);
 			return 1;
 		}
+		up_read(&current->mm->mmap_sem);
 
-		out_of_memory();
+		/*
+		 * We ran out of memory, call the OOM killer, and return the
+		 * userspace (which will retry the fault, or kill us if we got
+		 * oom-killed):
+		 */
+		pagefault_out_of_memory();
 	} else {
 		if (fault & VM_FAULT_SIGBUS)
 			do_sigbus(regs, error_code, address);
diff -puN arch/x86/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~mm-oom-remove-statically-defined-arch-functions-of-same-name
+++ a/arch/x86/mm/fault.c
@@ -803,20 +803,6 @@ bad_area_access_error(struct pt_regs *re
 	__bad_area(regs, error_code, address, SEGV_ACCERR);
 }
 
-/* TODO: fixup for "mm-invoke-oom-killer-from-page-fault.patch" */
-static void
-out_of_memory(struct pt_regs *regs, unsigned long error_code,
-	      unsigned long address)
-{
-	/*
-	 * We ran out of memory, call the OOM killer, and return the userspace
-	 * (which will retry the fault, or kill us if we got oom-killed):
-	 */
-	up_read(&current->mm->mmap_sem);
-
-	pagefault_out_of_memory();
-}
-
 static void
 do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 	  unsigned int fault)
@@ -879,7 +865,14 @@ mm_fault_error(struct pt_regs *regs, uns
 			return 1;
 		}
 
-		out_of_memory(regs, error_code, address);
+		up_read(&current->mm->mmap_sem);
+
+		/*
+		 * We ran out of memory, call the OOM killer, and return the
+		 * userspace (which will retry the fault, or kill us if we got
+		 * oom-killed):
+		 */
+		pagefault_out_of_memory();
 	} else {
 		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
 			     VM_FAULT_HWPOISON_LARGE))
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-export-a-function-to-get-vm-committed-memory.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
irq-tsk-comm-is-an-array.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-clean-up-__collapse_huge_page_isolate.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears-simplify-ida-initialization.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-mempolicy-remove-duplicate-code.patch
mm-cleanup-register_node.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
mm-memcg-avoid-unnecessary-function-call-when-memcg-is-disabled.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-oom-ensure-sysrqf-always-passes-valid-zonelist.patch
mm-oom-cleanup-pagefault-oom-handler.patch
mm-oom-remove-redundant-sleep-in-pagefault-oom-handler.patch
mm-oom-remove-statically-defined-arch-functions-of-same-name.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

