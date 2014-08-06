From: akpm@linux-foundation.org
Subject: [folded-merged] mm-memcontrol-rewrite-charge-api-fix-3.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 13:54:42 -0700
Message-ID: <53e29612.YxtJHKYjkXOIa+dI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:40196 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaHFUyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 16:54:43 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so416060ykq.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 13:54:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: uprobes: switch to new memcg charge protocol
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-charge-api-fix-3.patch

This patch was dropped because it was folded into mm-memcontrol-rewrite-charge-api.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: kernel: uprobes: switch to new memcg charge protocol

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/events/uprobes.c~mm-memcontrol-rewrite-charge-api-fix-3 kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-memcontrol-rewrite-charge-api-fix-3
+++ a/kernel/events/uprobes.c
@@ -167,6 +167,11 @@ static int __replace_page(struct vm_area
 	/* For mmu_notifiers */
 	const unsigned long mmun_start = addr;
 	const unsigned long mmun_end   = addr + PAGE_SIZE;
+	struct mem_cgroup *memcg;
+
+	err = mem_cgroup_try_charge(kpage, vma->vm_mm, GFP_KERNEL, &memcg);
+	if (err)
+		return err;
 
 	/* For try_to_free_swap() and munlock_vma_page() below */
 	lock_page(page);
@@ -179,6 +184,7 @@ static int __replace_page(struct vm_area
 
 	get_page(kpage);
 	page_add_new_anon_rmap(kpage, vma, addr);
+	mem_cgroup_commit_charge(kpage, memcg, false);
 	lru_cache_add_active_or_unevictable(kpage, vma);
 
 	if (!PageAnon(page)) {
@@ -201,6 +207,7 @@ static int __replace_page(struct vm_area
 
 	err = 0;
  unlock:
+	mem_cgroup_cancel_charge(kpage, memcg);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	unlock_page(page);
 	return err;
@@ -316,18 +323,11 @@ retry:
 	if (!new_page)
 		goto put_old;
 
-	if (mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL))
-		goto put_new;
-
 	__SetPageUptodate(new_page);
 	copy_highpage(new_page, old_page);
 	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
 
 	ret = __replace_page(vma, vaddr, old_page, new_page);
-	if (ret)
-		mem_cgroup_uncharge_page(new_page);
-
-put_new:
 	page_cache_release(new_page);
 put_old:
 	put_page(old_page);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-clear-page-mapping-in-migration.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim-fix.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-remove-all_unreclaimable-fix.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-update-the-description-for-vm_total_pages.patch
mm-vmscan-report-the-number-of-file-anon-pages-respectively.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
mm-oom-rename-zonelist-locking-functions.patch
mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch
mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
mm-memcontrol-clean-up-reclaim-size-variable-use-in-try_charge.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

