From: akpm@linux-foundation.org
Subject: + slab-use-get_node-and-kmem_cache_node-functions-fix.patch added to -mm tree
Date: Tue, 17 Jun 2014 14:18:00 -0700
Message-ID: <53a0b088.EX+RmL0awYmiAIaF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907AbaFQVSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com, cl@gentwo.org


The patch titled
     Subject: slab-use-get_node-and-kmem_cache_node-functions-fix
has been added to the -mm tree.  Its filename is
     slab-use-get_node-and-kmem_cache_node-functions-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-use-get_node-and-kmem_cache_node-functions-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-use-get_node-and-kmem_cache_node-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 
@@ -3804,9 +3804,8 @@ fail:
 		/* Cache is not active yet. Roll back what we did */
 		node--;
 		while (node >= 0) {
-			if (get_node(cachep, node)) {
-				n = get_node(cachep, node);
