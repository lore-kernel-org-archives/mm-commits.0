From: akpm@linux-foundation.org
Subject: + walk-system-ram-range-fix.patch added to -mm tree
Date: Tue, 15 Sep 2009 17:33:27 -0700
Message-ID: <200909160033.n8G0XRXn018083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbZIPAdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Sep 2009 20:33:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, hugh.dickins@tiscali.co.uk, ralf@linux-mips.org, xiyou.wangcong@gmail.com


The patch titled
     walk-system-ram-range-fix
has been added to the -mm tree.  Its filename is
     walk-system-ram-range-fix.patch

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
Subject: walk-system-ram-range-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

walk-system-ram-range.patch renames walk_memory_resource()
to be walk_system_ram_range().
But powerpc has its own one and it's exported.
(Because ehea driver (IBM's one) uses this, powerpc export this.)

> arch/powerpc/mm/mem.c:169: error: ‘walk_memory_resource’ undeclared here (not in a function)
> cc1: warnings being treated as errors
> arch/powerpc/mm/mem.c:169: error: type defaults to ‘int’ in declaration of ‘walk_memory_resource’
> make[1]: *** [arch/powerpc/mm/mem.o] Error 1
>
The patch failed to update powerpc's EXPORT_SYMBOL, this patch fixes it.

Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/mm/mem.c~walk-system-ram-range-fix arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~walk-system-ram-range-fix
+++ a/arch/powerpc/mm/mem.c
@@ -166,7 +166,7 @@ walk_system_ram_range(unsigned long star
 	}
 	return ret;
 }
-EXPORT_SYMBOL_GPL(walk_memory_resource);
+EXPORT_SYMBOL_GPL(walk_system_ram_range);
 
 /*
  * Initialize the bootmem system and give it all the memory we
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

proc-kcore-work-around-a-bug.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback-fix.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
revert-proc-kcore-work-around-a-bug.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
kcore-proc-kcore-should-use-vread.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
mm-do-batched-scans-for-mem_cgroup.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
mm-fix-numa-accounting-in-numastattxt.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
mm-munlock-avoid-zero_page.patch
mm-hugetlbfs_pagecache_present.patch
mm-zero_page-without-pte_special.patch
mm-move-highest_memmap_pfn.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-types.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
walk-system-ram-range-fix.patch
kcore-use-registerd-physmem-information.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
kcore-register-module-area-in-generic-way.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

