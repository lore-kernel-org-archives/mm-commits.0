From: akpm@linux-foundation.org
Subject: [folded-merged]
 slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch removed from
 -mm tree
Date: Wed, 06 Aug 2014 15:43:29 -0700
Message-ID: <53e2af91.NBkWho/SV9jTWxC7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:49299 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaHFWna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:43:30 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so839600pde.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:43:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@gentwo.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab-use-get_node-and-kmem_cache_node-functions-fix-2
has been removed from the -mm tree.  Its filename was
     slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch

This patch was dropped because it was folded into slab-use-get_node-and-kmem_cache_node-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slab-use-get_node-and-kmem_cache_node-functions-fix-2

mm/slab.c: In function 'slab_set_debugobj_lock_classes':
mm/slab.c:524: error: 'h' undeclared (first use in this function)
mm/slab.c:524: error: (Each undeclared identifier is reported only once
mm/slab.c:524: error: for each function it appears in.)
mm/slab.c:524: warning: left-hand operand of comma expression has no effect
mm/slab.c: In function 'cpuup_prepare':
mm/slab.c:1308: warning: passing argument 2 of 'slab_set_debugobj_lock_classes_node' makes pointer from integer without a cast
mm/slab.c:513: note: expected 'struct kmem_cache_node *' but argument is of type 'int'

Cc: Christoph Lameter <cl@gentwo.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions-fix-2 mm/slab.c
--- a/mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions-fix-2
+++ a/mm/slab.c
@@ -521,7 +521,7 @@ static void slab_set_debugobj_lock_class
 	int node;
 	struct kmem_cache_node *n;
 
-	for_each_kmem_cache_node(cachep, node, h)
+	for_each_kmem_cache_node(cachep, node, n)
 		slab_set_debugobj_lock_classes_node(cachep, n);
 }
 
@@ -1305,7 +1305,7 @@ static int cpuup_prepare(long cpu)
 		kfree(shared);
 		free_alien_cache(alien);
 		if (cachep->flags & SLAB_DEBUG_OBJECTS)
-			slab_set_debugobj_lock_classes_node(cachep, node);
+			slab_set_debugobj_lock_classes_node(cachep, n);
 		else if (!OFF_SLAB(cachep) &&
 			 !(cachep->flags & SLAB_DESTROY_BY_RCU))
 			on_slab_lock_classes_node(cachep, n);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

