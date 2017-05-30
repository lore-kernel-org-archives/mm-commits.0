From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch added
 to -mm tree
Date: Tue, 30 May 2017 13:53:49 -0700
Message-ID: <592ddbdd.sx9HCXo0PQLn26aM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdE3Uxu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 16:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, josef@toxicpanda.com, mhocko@suse.com, riel@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use generic mod_memcg_page_state for kmem pages
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch

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
Subject: mm: memcontrol: use generic mod_memcg_page_state for kmem pages

The kmem-specific functions do the same thing. Switch and drop.

Link: http://lkml.kernel.org/r/20170530181724.27197-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 -----------------
 kernel/fork.c              |    8 ++++----
 mm/slab.h                  |   16 ++++++++--------
 3 files changed, 12 insertions(+), 29 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages
+++ a/include/linux/memcontrol.h
@@ -929,19 +929,6 @@ static inline int memcg_cache_id(struct
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
-/**
- * memcg_kmem_update_page_stat - update kmem page state statistics
- * @page: the page
- * @idx: page state item to account
- * @val: number of pages (positive or negative)
- */
-static inline void memcg_kmem_update_page_stat(struct page *page,
-				enum memcg_stat_item idx, int val)
-{
-	if (memcg_kmem_enabled() && page->mem_cgroup)
-		this_cpu_add(page->mem_cgroup->stat->count[idx], val);
-}
-
 #else
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
@@ -964,10 +951,6 @@ static inline void memcg_put_cache_ids(v
 {
 }
 
-static inline void memcg_kmem_update_page_stat(struct page *page,
-				enum memcg_stat_item idx, int val)
-{
-}
 #endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN kernel/fork.c~mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages kernel/fork.c
--- a/kernel/fork.c~mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages
+++ a/kernel/fork.c
@@ -326,8 +326,8 @@ static void account_kernel_stack(struct
 		}
 
 		/* All stack pages belong to the same memcg. */
-		memcg_kmem_update_page_stat(vm->pages[0], MEMCG_KERNEL_STACK_KB,
-					    account * (THREAD_SIZE / 1024));
+		mod_memcg_page_state(vm->pages[0], MEMCG_KERNEL_STACK_KB,
+				     account * (THREAD_SIZE / 1024));
 	} else {
 		/*
 		 * All stack pages are in the same zone and belong to the
@@ -338,8 +338,8 @@ static void account_kernel_stack(struct
 		mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
 				    THREAD_SIZE / 1024 * account);
 
-		memcg_kmem_update_page_stat(first_page, MEMCG_KERNEL_STACK_KB,
-					    account * (THREAD_SIZE / 1024));
+		mod_memcg_page_state(first_page, MEMCG_KERNEL_STACK_KB,
+				     account * (THREAD_SIZE / 1024));
 	}
 }
 
diff -puN mm/slab.h~mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages mm/slab.h
--- a/mm/slab.h~mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages
+++ a/mm/slab.h
@@ -285,10 +285,10 @@ static __always_inline int memcg_charge_
 	if (ret)
 		return ret;
 
-	memcg_kmem_update_page_stat(page,
-			(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-			NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-			1 << order);
+	mod_memcg_page_state(page,
+			     (s->flags & SLAB_RECLAIM_ACCOUNT) ?
+			     NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
+			     1 << order);
 	return 0;
 }
 
@@ -298,10 +298,10 @@ static __always_inline void memcg_unchar
 	if (!memcg_kmem_enabled())
 		return;
 
-	memcg_kmem_update_page_stat(page,
-			(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-			NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-			-(1 << order));
+	mod_memcg_page_state(page,
+			     (s->flags & SLAB_RECLAIM_ACCOUNT) ?
+			     NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
+			     -(1 << order));
 	memcg_kmem_uncharge(page, order);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-delete-unused-pgdat_reclaimable_pages.patch
mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
mm-memcontrol-use-the-node-native-slab-memory-counters.patch
mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
mm-memcontrol-per-lruvec-stats-infrastructure.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch

