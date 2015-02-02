From: akpm@linux-foundation.org
Subject: + memcg-shmem-fix-shmem-migration-to-use-lrucare.patch added to
 -mm tree
Date: Mon, 02 Feb 2015 13:50:37 -0800
Message-ID: <54cff12d./iQN7VxjowHp/0MQ%akpm__30674.3183559322$1422913849$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbbBBVui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2015 16:50:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, airlied@gmail.com, chris@chris-wilson.co.uk, hughd@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, shmem: fix shmem migration to use lrucare
has been added to the -mm tree.  Its filename is
     memcg-shmem-fix-shmem-migration-to-use-lrucare.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-shmem-fix-shmem-migration-to-use-lrucare.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-shmem-fix-shmem-migration-to-use-lrucare.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, shmem: fix shmem migration to use lrucare

It has been reported that 965GM might trigger

VM_BUG_ON_PAGE(!lrucare && PageLRU(oldpage), oldpage)

in mem_cgroup_migrate when shmem wants to replace a swap cache page
because of shmem_should_replace_page (the page is allocated from an
inappropriate zone).  shmem_replace_page expects that the oldpage is not
on LRU list and calls mem_cgroup_migrate without lrucare.  This is
obviously incorrect because swapcache pages might be on the LRU list (e.g.
 swapin readahead page).

Fix this by enabling lrucare for the migration in shmem_replace_page. 
Also clarify that lrucare should be used even if one of the pages might be
on LRU list.

The BUG_ON will trigger only when CONFIG_DEBUG_VM is enabled but even
without that the migration code might leave the old page on an
inappropriate memcg' LRU which is not that critical because the page would
get removed with its last reference but it is still confusing.

Fixes: 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-by: Dave Airlie <airlied@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[3.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 mm/shmem.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-shmem-fix-shmem-migration-to-use-lrucare mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-shmem-fix-shmem-migration-to-use-lrucare
+++ a/mm/memcontrol.c
@@ -5773,7 +5773,7 @@ void mem_cgroup_uncharge_list(struct lis
  * mem_cgroup_migrate - migrate a charge to another page
  * @oldpage: currently charged page
  * @newpage: page to transfer the charge to
- * @lrucare: both pages might be on the LRU already
+ * @lrucare: either or both pages might be on the LRU already
  *
  * Migrate the charge from @oldpage to @newpage.
  *
diff -puN mm/shmem.c~memcg-shmem-fix-shmem-migration-to-use-lrucare mm/shmem.c
--- a/mm/shmem.c~memcg-shmem-fix-shmem-migration-to-use-lrucare
+++ a/mm/shmem.c
@@ -1013,7 +1013,7 @@ static int shmem_replace_page(struct pag
 		 */
 		oldpage = newpage;
 	} else {
-		mem_cgroup_migrate(oldpage, newpage, false);
+		mem_cgroup_migrate(oldpage, newpage, true);
 		lru_cache_add_anon(newpage);
 		*pagep = newpage;
 	}
_

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-shmem-fix-shmem-migration-to-use-lrucare.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file-fix.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-memcontrol-simplify-soft-limit-tree-init-code.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch
vmstat-reduce-time-interval-to-stat-update-on-idle-cpu.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

