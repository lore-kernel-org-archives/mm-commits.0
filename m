From: akpm@linux-foundation.org
Subject: +
 mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch added to
 -mm tree
Date: Wed, 12 Mar 2014 14:03:59 -0700
Message-ID: <5320cbbf.XHDslp1hYnX+YP7x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaCLVEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 17:04:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Subject: + mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch added to -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 14:03:59 -0700


The patch titled
     Subject: mm: memcg: push !mm handling out to page cache charge function
has been added to the -mm tree.  Its filename is
     mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch

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
Subject: mm: memcg: push !mm handling out to page cache charge function

Only page cache charges can happen without an mm context, so push this
special case out of the inner core and into the cache charge function.

An ancient comment explains that the mm can also be NULL in case the task
is currently being migrated, but that is not actually true with the
current case, so just remove it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-push-mm-handling-out-to-page-cache-charge-function mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-push-mm-handling-out-to-page-cache-charge-function
+++ a/mm/memcontrol.c
@@ -2737,15 +2737,6 @@ static int __mem_cgroup_try_charge(struc
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
-
-	/*
-	 * We always charge the cgroup the mm_struct belongs to.
-	 * The mm_struct's mem_cgroup changes on task migration if the
-	 * thread group leader migrates. It's possible that mm is not
-	 * set, if so charge the root memcg (happens for pagecache usage).
-	 */
-	if (!*ptr && !mm)
-		*ptr = root_mem_cgroup;
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
@@ -4070,6 +4061,12 @@ int mem_cgroup_cache_charge(struct page
 		return 0;
 
 	if (!PageSwapCache(page)) {
+		/*
+		 * Page cache insertions can happen without an actual
+		 * task context, e.g. during disk probing on boot.
+		 */
+		if (!mm)
+			memcg = root_mem_cgroup;
 		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
 		if (ret != -ENOMEM)
 			__mem_cgroup_commit_charge(memcg, page, 1, type, false);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
lib-radix_tree-tree-node-interface-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
debugging-keep-track-of-page-owners.patch

