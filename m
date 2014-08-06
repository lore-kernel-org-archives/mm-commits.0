From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch removed from -mm
 tree
Date: Wed, 06 Aug 2014 13:54:44 -0700
Message-ID: <53e29614.P10HGOQYhApU1mj9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:41795 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaHFUyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 16:54:45 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so586464oac.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 13:54:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rewrite charge API: fix shmem_unuse
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch

This patch was dropped because it was folded into mm-memcontrol-rewrite-charge-api.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: memcontrol: rewrite charge API: fix shmem_unuse

Under shmem swapping and swapoff load, I sometimes hit the
VM_BUG_ON_PAGE(!page->mapping) in mem_cgroup_commit_charge() at
mm/memcontrol.c:6502!  Each time it has been a call from shmem_unuse().

Yes, there are some cases (most commonly when the page being unswapped is
in a file being unlinked and evicted at that time) when the charge should
not be committed.  In the old scheme, the page got uncharged again on
release; but in the new scheme, it hits that BUG beforehand.

It's a useful BUG, so adapt shmem_unuse() to allow for it.  Which needs
more info from shmem_unuse_inode(): so abuse -EAGAIN internally to replace
the previous !found state (-ENOENT would be a more natural code, but
that's exactly what you get when the swap has been evicted).

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/shmem.c~mm-memcontrol-rewrite-charge-api-fix-shmem_unuse mm/shmem.c
--- a/mm/shmem.c~mm-memcontrol-rewrite-charge-api-fix-shmem_unuse
+++ a/mm/shmem.c
@@ -604,7 +604,7 @@ static int shmem_unuse_inode(struct shme
 	radswap = swp_to_radix_entry(swap);
 	index = radix_tree_locate_item(&mapping->page_tree, radswap);
 	if (index == -1)
-		return 0;
+		return -EAGAIN;
 
 	/*
 	 * Move _head_ to start search for next from here.
@@ -663,7 +663,6 @@ static int shmem_unuse_inode(struct shme
 			spin_unlock(&info->lock);
 			swap_free(swap);
 		}
-		error = 1;	/* not an error, but entry was found */
 	}
 	return error;
 }
@@ -676,7 +675,6 @@ int shmem_unuse(swp_entry_t swap, struct
 	struct list_head *this, *next;
 	struct shmem_inode_info *info;
 	struct mem_cgroup *memcg;
-	int found = 0;
 	int error = 0;
 
 	/*
@@ -695,22 +693,24 @@ int shmem_unuse(swp_entry_t swap, struct
 	if (error)
 		goto out;
 	/* No radix_tree_preload: swap entry keeps a place for page in tree */
+	error = -EAGAIN;
 
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(this, next, &shmem_swaplist) {
 		info = list_entry(this, struct shmem_inode_info, swaplist);
 		if (info->swapped)
-			found = shmem_unuse_inode(info, swap, &page);
+			error = shmem_unuse_inode(info, swap, &page);
 		else
 			list_del_init(&info->swaplist);
 		cond_resched();
-		if (found)
+		if (error != -EAGAIN)
 			break;
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
 
-	if (found < 0) {
-		error = found;
+	if (error) {
+		if (error != -ENOMEM)
+			error = 0;
 		mem_cgroup_cancel_charge(page, memcg);
 	} else
 		mem_cgroup_commit_charge(page, memcg, true);
_

Patches currently in -mm which might be from hughd@google.com are

mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
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
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-clear-page-mapping-in-migration.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
mm-softdirty-respect-vm_softdirty-in-pte-holes.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
linux-next.patch
mm-allow-drivers-to-prevent-new-writable-mappings.patch
shm-add-sealing-api.patch
shm-add-memfd_create-syscall.patch
selftests-add-memfd_create-sealing-tests.patch
selftests-add-memfd-sealing-page-pinning-tests.patch
shm-wait-for-pins-to-be-released-when-sealing.patch
timer-provide-an-api-for-deferrable-timeout.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

