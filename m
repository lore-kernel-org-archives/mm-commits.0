From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:17:50 -0700
Message-ID: <20121008231751.ADA6920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:34834 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2JHXRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:17:54 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so36239eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:17:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-clean-up-mm_match_cgroup-signature-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch

This patch was dropped because it was folded into mm-memcg-clean-up-mm_match_cgroup-signature.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-clean-up-mm_match_cgroup-signature-fix

mm_match_cgroup is not a macro

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature-fix
+++ a/include/linux/memcontrol.h
@@ -90,8 +90,8 @@ bool mm_match_cgroup(const struct mm_str
 	bool match;
 
 	rcu_read_lock();
-	task_memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
-	match = __mem_cgroup_same_or_subtree(cgroup, task_memcg);
+	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
 	rcu_read_unlock();
 	return match;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
rbtree-performance-and-correctness-test.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-count-free-cma-pages.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
atomic-implement-generic-atomic_dec_if_positive.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

