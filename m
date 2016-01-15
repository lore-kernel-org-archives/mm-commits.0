From: akpm@linux-foundation.org
Subject: [merged] slab-add-slab_account-flag.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:32:19 -0800
Message-ID: <56997373.kQYdeRNOJ8bs94iE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbcAOWcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: add SLAB_ACCOUNT flag
has been removed from the -mm tree.  Its filename was
     slab-add-slab_account-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: slab: add SLAB_ACCOUNT flag

Currently, if we want to account all objects of a particular kmem cache,
we have to pass __GFP_ACCOUNT to each kmem_cache_alloc call, which is
inconvenient.  This patch introduces SLAB_ACCOUNT flag which if passed to
kmem_cache_create will force accounting for every allocation from this
cache even if __GFP_ACCOUNT is not passed.

This patch does not make any of the existing caches use this flag - it
will be done later in the series.

Note, a cache with SLAB_ACCOUNT cannot be merged with a cache w/o
SLAB_ACCOUNT, because merged caches share the same kmem_cache struct
and hence cannot have different sets of SLAB_* flags.  Thus using this
flag will probably reduce the number of merged slabs even if kmem
accounting is not used (only compiled in).

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Suggested-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 +++++++--------
 include/linux/slab.h       |    5 +++++
 mm/memcontrol.c            |    8 +++++++-
 mm/slab.h                  |    5 +++--
 mm/slab_common.c           |    3 ++-
 mm/slub.c                  |    2 ++
 6 files changed, 26 insertions(+), 12 deletions(-)

diff -puN include/linux/memcontrol.h~slab-add-slab_account-flag include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~slab-add-slab_account-flag
+++ a/include/linux/memcontrol.h
@@ -766,15 +766,13 @@ static inline int memcg_cache_id(struct
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
-struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep);
+struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 void __memcg_kmem_put_cache(struct kmem_cache *cachep);
 
-static inline bool __memcg_kmem_bypass(gfp_t gfp)
+static inline bool __memcg_kmem_bypass(void)
 {
 	if (!memcg_kmem_enabled())
 		return true;
-	if (!(gfp & __GFP_ACCOUNT))
-		return true;
 	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
 		return true;
 	return false;
@@ -791,7 +789,9 @@ static inline bool __memcg_kmem_bypass(g
 static __always_inline int memcg_kmem_charge(struct page *page,
 					     gfp_t gfp, int order)
 {
-	if (__memcg_kmem_bypass(gfp))
+	if (__memcg_kmem_bypass())
+		return 0;
+	if (!(gfp & __GFP_ACCOUNT))
 		return 0;
 	return __memcg_kmem_charge(page, gfp, order);
 }
@@ -810,16 +810,15 @@ static __always_inline void memcg_kmem_u
 /**
  * memcg_kmem_get_cache: selects the correct per-memcg cache for allocation
  * @cachep: the original global kmem cache
- * @gfp: allocation flags.
  *
  * All memory allocated from a per-memcg cache is charged to the owner memcg.
  */
 static __always_inline struct kmem_cache *
 memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
-	if (__memcg_kmem_bypass(gfp))
+	if (__memcg_kmem_bypass())
 		return cachep;
-	return __memcg_kmem_get_cache(cachep);
+	return __memcg_kmem_get_cache(cachep, gfp);
 }
 
 static __always_inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
diff -puN include/linux/slab.h~slab-add-slab_account-flag include/linux/slab.h
--- a/include/linux/slab.h~slab-add-slab_account-flag
+++ a/include/linux/slab.h
@@ -86,6 +86,11 @@
 #else
 # define SLAB_FAILSLAB		0x00000000UL
 #endif
+#ifdef CONFIG_MEMCG_KMEM
+# define SLAB_ACCOUNT		0x04000000UL	/* Account to memcg */
+#else
+# define SLAB_ACCOUNT		0x00000000UL
+#endif
 
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
diff -puN mm/memcontrol.c~slab-add-slab_account-flag mm/memcontrol.c
--- a/mm/memcontrol.c~slab-add-slab_account-flag
+++ a/mm/memcontrol.c
@@ -2356,7 +2356,7 @@ static void memcg_schedule_kmem_cache_cr
  * Can't be called in interrupt context or from kernel threads.
  * This function needs to be called with rcu_read_lock() held.
  */
-struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep)
+struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *memcg_cachep;
@@ -2364,6 +2364,12 @@ struct kmem_cache *__memcg_kmem_get_cach
 
 	VM_BUG_ON(!is_root_cache(cachep));
 
+	if (cachep->flags & SLAB_ACCOUNT)
+		gfp |= __GFP_ACCOUNT;
+
+	if (!(gfp & __GFP_ACCOUNT))
+		return cachep;
+
 	if (current->memcg_kmem_skip_account)
 		return cachep;
 
diff -puN mm/slab.h~slab-add-slab_account-flag mm/slab.h
--- a/mm/slab.h~slab-add-slab_account-flag
+++ a/mm/slab.h
@@ -128,10 +128,11 @@ static inline unsigned long kmem_cache_f
 
 #if defined(CONFIG_SLAB)
 #define SLAB_CACHE_FLAGS (SLAB_MEM_SPREAD | SLAB_NOLEAKTRACE | \
-			  SLAB_RECLAIM_ACCOUNT | SLAB_TEMPORARY | SLAB_NOTRACK)
+			  SLAB_RECLAIM_ACCOUNT | SLAB_TEMPORARY | \
+			  SLAB_NOTRACK | SLAB_ACCOUNT)
 #elif defined(CONFIG_SLUB)
 #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
-			  SLAB_TEMPORARY | SLAB_NOTRACK)
+			  SLAB_TEMPORARY | SLAB_NOTRACK | SLAB_ACCOUNT)
 #else
 #define SLAB_CACHE_FLAGS (0)
 #endif
diff -puN mm/slab_common.c~slab-add-slab_account-flag mm/slab_common.c
--- a/mm/slab_common.c~slab-add-slab_account-flag
+++ a/mm/slab_common.c
@@ -37,7 +37,8 @@ struct kmem_cache *kmem_cache;
 		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE | \
 		SLAB_FAILSLAB)
 
-#define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | SLAB_NOTRACK)
+#define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
+			 SLAB_NOTRACK | SLAB_ACCOUNT)
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
diff -puN mm/slub.c~slab-add-slab_account-flag mm/slub.c
--- a/mm/slub.c~slab-add-slab_account-flag
+++ a/mm/slub.c
@@ -5362,6 +5362,8 @@ static char *create_unique_id(struct kme
 		*p++ = 'F';
 	if (!(s->flags & SLAB_NOTRACK))
 		*p++ = 't';
+	if (s->flags & SLAB_ACCOUNT)
+		*p++ = 'A';
 	if (p != name + 1)
 		*p++ = '-';
 	p += sprintf(p, "%07d", s->size);
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-add-page_check_address_transhuge-helper.patch
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch
mm-memcontrol-charge-swap-to-cgroup2.patch
mm-vmscan-pass-memcg-to-get_scan_count.patch
mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
documentation-cgroup-add-memoryswapcurrentmax-description.patch

