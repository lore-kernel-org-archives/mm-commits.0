From: akpm@linux-foundation.org
Subject: [folded] mm-oom-reduce-dependency-on-tasklist_lock-fix-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:31:57 -0700
Message-ID: <20120731233157.8E74AA028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57717 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab2GaXcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:32:00 -0400
Received: by fat25 with SMTP id 25so296721fat.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:31:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-reduce-dependency-on-tasklist_lock-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-oom-reduce-dependency-on-tasklist_lock-fix-fix.patch

This patch was dropped because it was folded into mm-oom-reduce-dependency-on-tasklist_lock.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm-oom-reduce-dependency-on-tasklist_lock-fix-fix

Need to drop rcu lock before returning from select_bad_process() for
OOM_SCAN_ABORT.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/oom_kill.c~mm-oom-reduce-dependency-on-tasklist_lock-fix-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-reduce-dependency-on-tasklist_lock-fix-fix
+++ a/mm/oom_kill.c
@@ -361,6 +361,7 @@ static struct task_struct *select_bad_pr
 		case OOM_SCAN_CONTINUE:
 			continue;
 		case OOM_SCAN_ABORT:
+			rcu_read_unlock();
 			return ERR_PTR(-1UL);
 		case OOM_SCAN_OK:
 			break;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing.patch
mm-oom-replace-some-information-in-tasklist-dump.patch
memcg-rename-config-variables.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-oom-move-declaration-for-mem_cgroup_out_of_memory-to-oomh.patch
mm-oom-introduce-helper-function-to-process-threads-during-scan.patch
mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads.patch
mm-oom-reduce-dependency-on-tasklist_lock.patch
mm-memcg-move-all-oom-handling-to-memcontrolc.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch
mm-memcg-push-down-pageswapcache-check-into-uncharge-entry-functions.patch
mm-memcg-only-check-for-pageswapcache-when-uncharging-anon.patch
mm-memcg-move-swapin-charge-functions-above-callsites.patch
mm-memcg-remove-unneeded-shmem-charge-type.patch
mm-memcg-remove-needless-mm-fixup-to-init_mm-when-charging.patch
mm-memcg-split-swapin-charge-function-into-private-and-public-part.patch
mm-memcg-only-check-swap-cache-pages-for-repeated-charging.patch
mm-memcg-only-check-anon-swapin-page-charges-for-swap-cache.patch
mm-sparse-optimize-sparse_index_alloc.patch
mm-sparse-more-check-on-mem_section-number.patch

