From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-rewrite-uncharge-api-fix-clear-page-mapping-in-migration.patch removed from -mm tree
Date: Wed, 06 Aug 2014 14:01:19 -0700
Message-ID: <53e2979f.WaffIq/qJKpj762v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:55135 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaHFVBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 17:01:20 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so584707oif.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 14:01:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rewrite uncharge API fix - clear page->mapping in migration
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-uncharge-api-fix-clear-page-mapping-in-migration.patch

This patch was dropped because it was folded into mm-memcontrol-rewrite-uncharge-api.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: rewrite uncharge API fix - clear page->mapping in migration

The page->mapping reset in migration was conditionalized so that a later
uncharge could use PageAnon() to figure out the page type.  But after "mm:
memcontrol: rewrite uncharge API fix - double migration", the old page is
uncharged directly in mem_cgroup_migrate() and so this is no longer
necessary.

Once all fixups are folded into the "rewrite uncharge API" patch,
there will be no reason and no explanation for this change anymore, so
revert it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/migrate.c~mm-memcontrol-rewrite-uncharge-api-fix-clear-page-mapping-in-migration mm/migrate.c
--- a/mm/migrate.c~mm-memcontrol-rewrite-uncharge-api-fix-clear-page-mapping-in-migration
+++ a/mm/migrate.c
@@ -778,14 +778,12 @@ static int move_to_new_page(struct page
 		rc = fallback_migrate_page(mapping, newpage, page, mode);
 
 	if (rc != MIGRATEPAGE_SUCCESS) {
-		if (!PageAnon(newpage))
-			newpage->mapping = NULL;
+		newpage->mapping = NULL;
 	} else {
 		mem_cgroup_migrate(page, newpage, false);
 		if (remap_swapcache)
 			remove_migration_ptes(page, newpage);
-		if (!PageAnon(page))
-			page->mapping = NULL;
+		page->mapping = NULL;
 	}
 
 	unlock_page(newpage);
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
mm-memcontrol-rewrite-uncharge-api.patch
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

