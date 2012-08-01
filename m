From: akpm@linux-foundation.org
Subject: [merged] mm-micro-optimise-slab-to-avoid-a-function-call.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:26 -0700
Message-ID: <20120801201626.D4F671E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2HAUQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:16:28 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:16:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: micro-optimise slab to avoid a function call
has been removed from the -mm tree.  Its filename was
     mm-micro-optimise-slab-to-avoid-a-function-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: micro-optimise slab to avoid a function call

Getting and putting objects in SLAB currently requires a function call but
the bulk of the work is related to PFMEMALLOC reserves which are only
consumed when network-backed storage is critical.  Use an inline function
to determine if the function call is required.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~mm-micro-optimise-slab-to-avoid-a-function-call mm/slab.c
--- a/mm/slab.c~mm-micro-optimise-slab-to-avoid-a-function-call
+++ a/mm/slab.c
@@ -118,6 +118,8 @@
 #include	<linux/memory.h>
 #include	<linux/prefetch.h>
 
+#include	<net/sock.h>
+
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
 #include	<asm/page.h>
@@ -965,7 +967,7 @@ out:
 	spin_unlock_irqrestore(&l3->list_lock, flags);
 }
 
-static void *ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
+static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 						gfp_t flags, bool force_refill)
 {
 	int i;
@@ -1012,7 +1014,20 @@ static void *ac_get_obj(struct kmem_cach
 	return objp;
 }
 
-static void ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
+static inline void *ac_get_obj(struct kmem_cache *cachep,
+			struct array_cache *ac, gfp_t flags, bool force_refill)
+{
+	void *objp;
+
+	if (unlikely(sk_memalloc_socks()))
+		objp = __ac_get_obj(cachep, ac, flags, force_refill);
+	else
+		objp = ac->entry[--ac->avail];
+
+	return objp;
+}
+
+static void *__ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
 								void *objp)
 {
 	if (unlikely(pfmemalloc_active)) {
@@ -1022,6 +1037,15 @@ static void ac_put_obj(struct kmem_cache
 			set_obj_pfmemalloc(&objp);
 	}
 
+	return objp;
+}
+
+static inline void ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
+								void *objp)
+{
+	if (unlikely(sk_memalloc_socks()))
+		objp = __ac_put_obj(cachep, ac, objp);
+
 	ac->entry[ac->avail++] = objp;
 }
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

