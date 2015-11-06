From: akpm@linux-foundation.org
Subject: [folded-merged]
 memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch removed from
 -mm tree
Date: Thu, 05 Nov 2015 18:27:44 -0800
Message-ID: <563c1020.fmDMNIMwP0F6qdwt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFC1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:27:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, arnd@arndb.de, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2
has been removed from the -mm tree.  Its filename was
     memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch

This patch was dropped because it was folded into memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2

move mem_cgroup_from_kmem into list_lru.c

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   16 ----------------
 mm/list_lru.c              |   10 ++++++++++
 2 files changed, 10 insertions(+), 16 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2
+++ a/include/linux/memcontrol.h
@@ -828,16 +828,6 @@ static __always_inline void memcg_kmem_p
 	if (memcg_kmem_enabled())
 		__memcg_kmem_put_cache(cachep);
 }
-
-static __always_inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
-{
-	struct page *page;
-
-	if (!memcg_kmem_enabled())
-		return NULL;
-	page = virt_to_head_page(ptr);
-	return page->mem_cgroup;
-}
 #else
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
@@ -883,11 +873,5 @@ memcg_kmem_get_cache(struct kmem_cache *
 static inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
 {
 }
-
-static inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
-{
-	return NULL;
-}
 #endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
-
diff -puN mm/list_lru.c~memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2 mm/list_lru.c
--- a/mm/list_lru.c~memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2
+++ a/mm/list_lru.c
@@ -63,6 +63,16 @@ list_lru_from_memcg_idx(struct list_lru_
 	return &nlru->lru;
 }
 
+static __always_inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
+{
+	struct page *page;
+
+	if (!memcg_kmem_enabled())
+		return NULL;
+	page = virt_to_head_page(ptr);
+	return page->mem_cgroup;
+}
+
 static inline struct list_lru_one *
 list_lru_from_kmem(struct list_lru_node *nlru, void *ptr)
 {
_

Patches currently in -mm which might be from hughd@google.com are

memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
tmpfs-avoid-a-little-creat-and-stat-slowdown.patch
mm-documentation-a-little-tidying-in-proctxt.patch

