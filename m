From: akpm@linux-foundation.org
Subject: [merged]
 mm-fault-inject-take-over-bootstrap-kmem_cache-check.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:38 -0700
Message-ID: <56e9b9c2.p+l/E4DJqES0kWnI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fault-inject take over bootstrap kmem_cache check
has been removed from the -mm tree.  Its filename was
     mm-fault-inject-take-over-bootstrap-kmem_cache-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: mm: fault-inject take over bootstrap kmem_cache check

Remove the SLAB specific function slab_should_failslab(), by moving the
check against fault-injection for the bootstrap slab, into the shared
function should_failslab() (used by both SLAB and SLUB).

This is a step towards sharing alloc_hook's between SLUB and SLAB.

This bootstrap slab "kmem_cache" is used for allocating struct kmem_cache
objects to the allocator itself.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    5 ++---
 mm/failslab.c                |   12 +++++++++---
 mm/slab.c                    |   12 ++----------
 mm/slab.h                    |    2 +-
 4 files changed, 14 insertions(+), 17 deletions(-)

diff -puN include/linux/fault-inject.h~mm-fault-inject-take-over-bootstrap-kmem_cache-check include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~mm-fault-inject-take-over-bootstrap-kmem_cache-check
+++ a/include/linux/fault-inject.h
@@ -62,10 +62,9 @@ static inline struct dentry *fault_creat
 #endif /* CONFIG_FAULT_INJECTION */
 
 #ifdef CONFIG_FAILSLAB
-extern bool should_failslab(size_t size, gfp_t gfpflags, unsigned long flags);
+extern bool should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 #else
-static inline bool should_failslab(size_t size, gfp_t gfpflags,
-				unsigned long flags)
+static inline bool should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 {
 	return false;
 }
diff -puN mm/failslab.c~mm-fault-inject-take-over-bootstrap-kmem_cache-check mm/failslab.c
--- a/mm/failslab.c~mm-fault-inject-take-over-bootstrap-kmem_cache-check
+++ a/mm/failslab.c
@@ -1,5 +1,7 @@
 #include <linux/fault-inject.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
+#include "slab.h"
 
 static struct {
 	struct fault_attr attr;
@@ -11,18 +13,22 @@ static struct {
 	.cache_filter = false,
 };
 
-bool should_failslab(size_t size, gfp_t gfpflags, unsigned long cache_flags)
+bool should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 {
+	/* No fault-injection for bootstrap cache */
+	if (unlikely(s == kmem_cache))
+		return false;
+
 	if (gfpflags & __GFP_NOFAIL)
 		return false;
 
 	if (failslab.ignore_gfp_reclaim && (gfpflags & __GFP_RECLAIM))
 		return false;
 
-	if (failslab.cache_filter && !(cache_flags & SLAB_FAILSLAB))
+	if (failslab.cache_filter && !(s->flags & SLAB_FAILSLAB))
 		return false;
 
-	return should_fail(&failslab.attr, size);
+	return should_fail(&failslab.attr, s->object_size);
 }
 
 static int __init setup_failslab(char *str)
diff -puN mm/slab.c~mm-fault-inject-take-over-bootstrap-kmem_cache-check mm/slab.c
--- a/mm/slab.c~mm-fault-inject-take-over-bootstrap-kmem_cache-check
+++ a/mm/slab.c
@@ -2926,14 +2926,6 @@ static void *cache_alloc_debugcheck_afte
 #define cache_alloc_debugcheck_after(a,b,objp,d) (objp)
 #endif
 
-static bool slab_should_failslab(struct kmem_cache *cachep, gfp_t flags)
-{
-	if (unlikely(cachep == kmem_cache))
-		return false;
-
-	return should_failslab(cachep->object_size, flags, cachep->flags);
-}
-
 static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
 	void *objp;
@@ -3155,7 +3147,7 @@ slab_alloc_node(struct kmem_cache *cache
 
 	lockdep_trace_alloc(flags);
 
-	if (slab_should_failslab(cachep, flags))
+	if (should_failslab(cachep, flags))
 		return NULL;
 
 	cachep = memcg_kmem_get_cache(cachep, flags);
@@ -3243,7 +3235,7 @@ slab_alloc(struct kmem_cache *cachep, gf
 
 	lockdep_trace_alloc(flags);
 
-	if (slab_should_failslab(cachep, flags))
+	if (should_failslab(cachep, flags))
 		return NULL;
 
 	cachep = memcg_kmem_get_cache(cachep, flags);
diff -puN mm/slab.h~mm-fault-inject-take-over-bootstrap-kmem_cache-check mm/slab.h
--- a/mm/slab.h~mm-fault-inject-take-over-bootstrap-kmem_cache-check
+++ a/mm/slab.h
@@ -360,7 +360,7 @@ static inline struct kmem_cache *slab_pr
 	lockdep_trace_alloc(flags);
 	might_sleep_if(gfpflags_allow_blocking(flags));
 
-	if (should_failslab(s->object_size, flags, s->flags))
+	if (should_failslab(s, flags))
 		return NULL;
 
 	return memcg_kmem_get_cache(s, flags);
_

Patches currently in -mm which might be from brouer@redhat.com are


