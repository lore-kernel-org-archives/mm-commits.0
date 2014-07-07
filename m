From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
 added to -mm tree
Date: Mon, 07 Jul 2014 13:04:09 -0700
Message-ID: <53bafd39.sUzRPtXHIZIu7XTO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47918 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaGGUEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 16:04:11 -0400
Received: by mail-vc0-f202.google.com with SMTP id id10so682768vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 13:04:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rewrite uncharge API fix - migrate before re-mapping
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: rewrite uncharge API fix - migrate before re-mapping

Mapped file accounting depends on the the page being charged already,
or it won't get accounted properly, and the mapped file counter will
underflow during unmap later on.

Move mem_cgroup_migrate() before remove_migration_ptes().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping mm/migrate.c
--- a/mm/migrate.c~mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping
+++ a/mm/migrate.c
@@ -781,11 +781,11 @@ static int move_to_new_page(struct page
 		if (!PageAnon(newpage))
 			newpage->mapping = NULL;
 	} else {
+		mem_cgroup_migrate(page, newpage, false);
 		if (remap_swapcache)
 			remove_migration_ptes(page, newpage);
 		if (!PageAnon(page))
 			page->mapping = NULL;
-		mem_cgroup_migrate(page, newpage, false);
 	}
 
 	unlock_page(newpage);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
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
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration.patch
mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

