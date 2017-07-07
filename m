From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-reset-cpu_slabs-pointer-in-deactivate_slab.patch removed from -mm
 tree
Date: Fri, 07 Jul 2017 12:07:51 -0700
Message-ID: <20170707190751.1kQ-O3NR8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60714 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751916AbdGGTHw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/slub: reset cpu_slab's pointer in deactivate_slab()
has been removed from the -mm tree.  Its filename was
     mm-slub-reset-cpu_slabs-pointer-in-deactivate_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/slub: reset cpu_slab's pointer in deactivate_slab()

Each time a slab is deactivated, the page and freelist pointer should be
reset.

This patch just merges these two options into deactivate_slab().

Link: http://lkml.kernel.org/r/20170507031215.3130-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/slub.c~mm-slub-reset-cpu_slabs-pointer-in-deactivate_slab mm/slub.c
--- a/mm/slub.c~mm-slub-reset-cpu_slabs-pointer-in-deactivate_slab
+++ a/mm/slub.c
@@ -1993,7 +1993,7 @@ static void init_kmem_cache_cpus(struct
  * Remove the cpu slab
  */
 static void deactivate_slab(struct kmem_cache *s, struct page *page,
-				void *freelist)
+				void *freelist, struct kmem_cache_cpu *c)
 {
 	enum slab_modes { M_NONE, M_PARTIAL, M_FULL, M_FREE };
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
@@ -2132,6 +2132,9 @@ redo:
 		discard_slab(s, page);
 		stat(s, FREE_SLAB);
 	}
+
+	c->page = NULL;
+	c->freelist = NULL;
 }
 
 /*
@@ -2266,11 +2269,9 @@ static void put_cpu_partial(struct kmem_
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	stat(s, CPUSLAB_FLUSH);
-	deactivate_slab(s, c->page, c->freelist);
+	deactivate_slab(s, c->page, c->freelist, c);
 
 	c->tid = next_tid(c->tid);
-	c->page = NULL;
-	c->freelist = NULL;
 }
 
 /*
@@ -2521,9 +2522,7 @@ redo:
 
 		if (unlikely(!node_match(page, searchnode))) {
 			stat(s, ALLOC_NODE_MISMATCH);
-			deactivate_slab(s, page, c->freelist);
-			c->page = NULL;
-			c->freelist = NULL;
+			deactivate_slab(s, page, c->freelist, c);
 			goto new_slab;
 		}
 	}
@@ -2534,9 +2533,7 @@ redo:
 	 * information when the page leaves the per-cpu allocator
 	 */
 	if (unlikely(!pfmemalloc_match(page, gfpflags))) {
-		deactivate_slab(s, page, c->freelist);
-		c->page = NULL;
-		c->freelist = NULL;
+		deactivate_slab(s, page, c->freelist, c);
 		goto new_slab;
 	}
 
@@ -2591,9 +2588,7 @@ new_slab:
 			!alloc_debug_processing(s, page, freelist, addr))
 		goto new_slab;	/* Slab failed checks. Next slab needed */
 
-	deactivate_slab(s, page, get_freepointer(s, freelist));
-	c->page = NULL;
-	c->freelist = NULL;
+	deactivate_slab(s, page, get_freepointer(s, freelist), c);
 	return freelist;
 }
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memory_hotplug-just-build-zonelist-for-new-added-node.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

