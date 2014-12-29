From: akpm@linux-foundation.org
Subject: +
 swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch added to -mm tree
Date: Mon, 29 Dec 2014 14:03:36 -0800
Message-ID: <54a1cfb8.uErvCNaMnV3S2OUd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaL2WDh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Dec 2014 17:03:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: swap: remove unused mem_cgroup_uncharge_swapcache declaration
has been added to the -mm tree.  Its filename is
     swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch

