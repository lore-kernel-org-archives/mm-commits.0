From: akpm@linux-foundation.org
Subject: [merged] slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:41:36 -0800
Message-ID: <20121219204137.63E2C20005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43061 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab2LSUll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:41:41 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so133902bkc.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:41:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sl[au]b: always get the cache from its page in kmem_cache_free()
has been removed from the -mm tree.  Its filename was
     slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: sl[au]b: always get the cache from its page in kmem_cache_free()

struct page already has this information.  If we start chaining caches,
this information will always be more trustworthy than whatever is passed
into the function.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 ++++
 mm/slab.c                  |    6 ++++-
 mm/slab.h                  |   39 +++++++++++++++++++++++++++++++++++
 mm/slob.c                  |    2 -
 mm/slub.c                  |   15 ++-----------
 5 files changed, 53 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~slb-always-get-the-cache-from-its-page-in-kmem_cache_free include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~slb-always-get-the-cache-from-its-page-in-kmem_cache_free
+++ a/include/linux/memcontrol.h
@@ -554,6 +554,11 @@ memcg_kmem_get_cache(struct kmem_cache *
 	return __memcg_kmem_get_cache(cachep, gfp);
 }
 #else
+static inline bool memcg_kmem_enabled(void)
+{
+	return false;
+}
+
 static inline bool
 memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
 {
diff -puN mm/slab.c~slb-always-get-the-cache-from-its-page-in-kmem_cache_free mm/slab.c
--- a/mm/slab.c~slb-always-get-the-cache-from-its-page-in-kmem_cache_free
+++ a/mm/slab.c
@@ -87,7 +87,6 @@
  */
 
 #include	<linux/slab.h>
-#include	"slab.h"
 #include	<linux/mm.h>
 #include	<linux/poison.h>
 #include	<linux/swap.h>
@@ -128,6 +127,8 @@
 
 #include	"internal.h"
 
+#include	"slab.h"
+
 /*
  * DEBUG	- 1 for kmem_cache_create() to honour; SLAB_RED_ZONE & SLAB_POISON.
  *		  0 for faster, smaller code (especially in the critical paths).
@@ -3883,6 +3884,9 @@ EXPORT_SYMBOL(__kmalloc);
 void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 {
 	unsigned long flags;
+	cachep = cache_from_obj(cachep, objp);
+	if (!cachep)
+		return;
 
 	local_irq_save(flags);
 	debug_check_no_locks_freed(objp, cachep->object_size);
diff -puN mm/slab.h~slb-always-get-the-cache-from-its-page-in-kmem_cache_free mm/slab.h
--- a/mm/slab.h~slb-always-get-the-cache-from-its-page-in-kmem_cache_free
+++ a/mm/slab.h
@@ -116,6 +116,13 @@ static inline bool cache_match_memcg(str
 	return (is_root_cache(cachep) && !memcg) ||
 				(cachep->memcg_params->memcg == memcg);
 }
+
+static inline bool slab_equal_or_root(struct kmem_cache *s,
+					struct kmem_cache *p)
+{
+	return (p == s) ||
+		(s->memcg_params && (p == s->memcg_params->root_cache));
+}
 #else
 static inline bool is_root_cache(struct kmem_cache *s)
 {
@@ -127,5 +134,37 @@ static inline bool cache_match_memcg(str
 {
 	return true;
 }
+
+static inline bool slab_equal_or_root(struct kmem_cache *s,
+				      struct kmem_cache *p)
+{
+	return true;
+}
 #endif
+
+static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
+{
+	struct kmem_cache *cachep;
+	struct page *page;
+
+	/*
+	 * When kmemcg is not being used, both assignments should return the
+	 * same value. but we don't want to pay the assignment price in that
+	 * case. If it is not compiled in, the compiler should be smart enough
+	 * to not do even the assignment. In that case, slab_equal_or_root
+	 * will also be a constant.
+	 */
+	if (!memcg_kmem_enabled() && !unlikely(s->flags & SLAB_DEBUG_FREE))
+		return s;
+
+	page = virt_to_head_page(x);
+	cachep = page->slab_cache;
+	if (slab_equal_or_root(cachep, s))
+		return cachep;
+
+	pr_err("%s: Wrong slab cache. %s but object is from %s\n",
+		__FUNCTION__, cachep->name, s->name);
+	WARN_ON_ONCE(1);
+	return s;
+}
 #endif
diff -puN mm/slob.c~slb-always-get-the-cache-from-its-page-in-kmem_cache_free mm/slob.c
--- a/mm/slob.c~slb-always-get-the-cache-from-its-page-in-kmem_cache_free
+++ a/mm/slob.c
@@ -58,7 +58,6 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include "slab.h"
 
 #include <linux/mm.h>
 #include <linux/swap.h> /* struct reclaim_state */
@@ -73,6 +72,7 @@
 
 #include <linux/atomic.h>
 
+#include "slab.h"
 /*
  * slob_block has a field 'units', which indicates size of block if +ve,
  * or offset of next block if -ve (in SLOB_UNITs).
diff -puN mm/slub.c~slb-always-get-the-cache-from-its-page-in-kmem_cache_free mm/slub.c
--- a/mm/slub.c~slb-always-get-the-cache-from-its-page-in-kmem_cache_free
+++ a/mm/slub.c
@@ -2611,19 +2611,10 @@ redo:
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
 {
-	struct page *page;
-
-	page = virt_to_head_page(x);
-
-	if (kmem_cache_debug(s) && page->slab_cache != s) {
-		pr_err("kmem_cache_free: Wrong slab cache. %s but object"
-			" is from  %s\n", page->slab_cache->name, s->name);
-		WARN_ON_ONCE(1);
+	s = cache_from_obj(s, x);
+	if (!s)
 		return;
-	}
-
-	slab_free(s, page, x, _RET_IP_);
