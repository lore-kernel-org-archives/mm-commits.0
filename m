From: akpm@linux-foundation.org
Subject: [folded-merged]
 slab-use-get_node-and-kmem_cache_node-functions-fix.patch removed from -mm
 tree
Date: Wed, 06 Aug 2014 15:43:27 -0700
Message-ID: <53e2af8f.Ftk/Dp4nOJ4u0V3n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:57622 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaHFWn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:43:28 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so613195obc.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:43:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@gentwo.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab-use-get_node-and-kmem_cache_node-functions-fix
has been removed from the -mm tree.  Its filename was
     slab-use-get_node-and-kmem_cache_node-functions-fix.patch

This patch was dropped because it was folded into slab-use-get_node-and-kmem_cache_node-functions.patch

------------------------------------------------------
From: Christoph Lameter <cl@gentwo.org>
Subject: slab-use-get_node-and-kmem_cache_node-functions-fix

On Thu, 12 Jun 2014, Joonsoo Kim wrote:

> > @@ -3759,8 +3746,8 @@ fail:
> >  		/* Cache is not active yet. Roll back what we did */
> >  		node--;
> >  		while (node >= 0) {
> > -			if (cachep->node[node]) {
> > -				n = cachep->node[node];
> > +			if (get_node(cachep, node)) {
> > +				n = get_node(cachep, node);
>
> Could you do this as following?
>
> n = get_node(cachep, node);
> if (n) {
>         ...
> }

Sure....

Subject: slab: Fixes to earlier patch

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions-fix mm/slab.c
--- a/mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions-fix
+++ a/mm/slab.c
@@ -561,8 +561,8 @@ static inline void on_slab_lock_classes(
 	struct kmem_cache_node *n;
 
 	VM_BUG_ON(OFF_SLAB(cachep));
-	for_each_kmem_cache_node(cachep, node, h)
-		on_slab_lock_classes_node(cachep, h);
+	for_each_kmem_cache_node(cachep, node, n)
+		on_slab_lock_classes_node(cachep, n);
 }
 
 static inline void __init init_lock_keys(void)
@@ -586,7 +586,7 @@ static inline void on_slab_lock_classes(
 }
 
 static inline void on_slab_lock_classes_node(struct kmem_cache *cachep,
-	int node, struct kmem_cache_node *n)
+	struct kmem_cache_node *n)
 {
 }
 
@@ -823,7 +823,7 @@ static inline bool is_slab_pfmemalloc(st
 static void recheck_pfmemalloc_active(struct kmem_cache *cachep,
 						struct array_cache *ac)
 {
-	struct kmem_cache_node *n = get_node(cachep,numa_mem_id());
+	struct kmem_cache_node *n = get_node(cachep, numa_mem_id());
 	struct page *page;
 	unsigned long flags;
 
@@ -1308,7 +1308,7 @@ static int cpuup_prepare(long cpu)
 			slab_set_debugobj_lock_classes_node(cachep, node);
 		else if (!OFF_SLAB(cachep) &&
 			 !(cachep->flags & SLAB_DESTROY_BY_RCU))
-			on_slab_lock_classes_node(cachep, node, n);
+			on_slab_lock_classes_node(cachep, n);
 	}
 	init_node_lock_keys(node);
 
@@ -3807,9 +3807,8 @@ fail:
 		/* Cache is not active yet. Roll back what we did */
 		node--;
 		while (node >= 0) {
-			if (get_node(cachep, node)) {
-				n = get_node(cachep, node);
