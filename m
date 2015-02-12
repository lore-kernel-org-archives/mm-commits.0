From: akpm@linux-foundation.org
Subject: [merged]
 swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:36:03 -0800
Message-ID: <54dd00a3.wZevHD8EGb5DDKmN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbBLTgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: swap: remove unused mem_cgroup_uncharge_swapcache declaration
has been removed from the -mm tree.  Its filename was
     swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: swap: remove unused mem_cgroup_uncharge_swapcache declaration

The body of this function was removed by commit 0a31bc97c80c ("mm:
memcontrol: rewrite uncharge API").

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   15 ---------------
 mm/shmem.c           |    2 +-
 2 files changed, 1 insertion(+), 16 deletions(-)

diff -puN include/linux/swap.h~swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration include/linux/swap.h
--- a/include/linux/swap.h~swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration
+++ a/include/linux/swap.h
@@ -437,16 +437,6 @@ extern int reuse_swap_page(struct page *
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
-#ifdef CONFIG_MEMCG
-extern void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
-#else
-static inline void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
-{
-}
-#endif
-
 #else /* CONFIG_SWAP */
 
 #define swap_address_space(entry)		(NULL)
@@ -547,11 +537,6 @@ static inline swp_entry_t get_swap_page(
 	return entry;
 }
 
-static inline void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
-{
-}
-
 #endif /* CONFIG_SWAP */
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff -puN mm/shmem.c~swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration mm/shmem.c
--- a/mm/shmem.c~swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration
+++ a/mm/shmem.c
@@ -1131,7 +1131,7 @@ repeat:
 			 * truncated or holepunched since swap was confirmed.
 			 * shmem_undo_range() will have done some of the
 			 * unaccounting, now delete_from_swap_cache() will do
-			 * the rest (including mem_cgroup_uncharge_swapcache).
+			 * the rest.
 			 * Reset swap.val? No, leave it so "failed" goes back to
 			 * "repeat": reading a hole and writing should succeed.
 			 */
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-embed-memcg_cache_params-to-kmem_cache-fix.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-never-fail-to-shrink-cache-init-discard-list-after-freeing-slabs.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
memcg-cleanup-static-keys-decrement.patch

