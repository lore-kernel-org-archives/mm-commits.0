From: akpm@linux-foundation.org
Subject: + memcg-fix-wrong-pointer-initialization-at-page-migration-when-memcg-is-disabled.patch added to -mm tree
Date: Wed, 28 Oct 2009 22:38:15 -0700
Message-ID: <200910290538.n9T5cFH6004916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364AbZJ2Fiy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Oct 2009 01:38:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, Lee.Schermerhorn@hp.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, stable@kernel.org


The patch titled
     memcg: fix wrong pointer initialization at page migration when memcg is disabled.
has been added to the -mm tree.  Its filename is
     memcg-fix-wrong-pointer-initialization-at-page-migration-when-memcg-is-disabled.patch

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
Subject: memcg: fix wrong pointer initialization at page migration when memcg is disabled.
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Lee Schermerhorn reported that he saw bad pointer dereference in
mem_cgroup_end_migration() when he disabled memcg by boot option.

memcg's page migration logic works as

	mem_cgroup_prepare_migration(page, &ptr);
	do page migration
	mem_cgroup_end_migration(page, ptr);

Now, ptr is not initialized in prepare_migration when memcg is disabled
by boot option. This causes panic in end_migration. This patch fixes it.

Reported-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~memcg-fix-wrong-pointer-initialization-at-page-migration-when-memcg-is-disabled mm/migrate.c
--- a/mm/migrate.c~memcg-fix-wrong-pointer-initialization-at-page-migration-when-memcg-is-disabled
+++ a/mm/migrate.c
@@ -602,7 +602,7 @@ static int unmap_and_move(new_page_t get
 	struct page *newpage = get_new_page(page, private, &result);
 	int rcu_locked = 0;
 	int charge = 0;
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem = NULL;
 
 	if (!newpage)
 		return -ENOMEM;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-dont-call-pte_unmap-against-an-improper-pte.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
memcg-fix-wrong-pointer-initialization-at-page-migration-when-memcg-is-disabled.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
memcg-coalesce-uncharge-during-unmap-truncate.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-coalesce-charging-via-percpu-storage-fix-2.patch
memcg-make-memcgs-file-mapped-consistent-with-global-vm.patch

