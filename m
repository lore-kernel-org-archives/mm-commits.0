From: akpm@linux-foundation.org
Subject: + mm-slab-free-kmem_cache_node-after-destroy-sysfs-file.patch
 added to -mm tree
Date: Fri, 05 Feb 2016 14:01:10 -0800
Message-ID: <56b51ba6.C/B2Vdg806ogD2+v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbcBEWBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 17:01:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsafonov@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab: free kmem_cache_node after destroy sysfs file
has been added to the -mm tree.  Its filename is
     mm-slab-free-kmem_cache_node-after-destroy-sysfs-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-free-kmem_cache_node-after-destroy-sysfs-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-free-kmem_cache_node-after-destroy-sysfs-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Safonov <dsafonov@virtuozzo.com>
Subject: mm: slab: free kmem_cache_node after destroy sysfs file

WHen slub_debug is enabled, alloc_calls_show() will try to track location
and user of slab objects on each online node.  kmem_cache_node structure
and cpu_cache/cpu_slub shouldn't be freed till there is the last reference
to sysfs file.

Fixes the following panic:
[43963.463055] BUG: unable to handle kernel
[43963.463090] NULL pointer dereference at 0000000000000020
[43963.463146] IP: [<ffffffff811c6959>] list_locations+0x169/0x4e0
[43963.463185] PGD 257304067 PUD 438456067 PMD 0
[43963.463220] Oops: 0000 [#1] SMP
[43963.463850] CPU: 3 PID: 973074 Comm: cat ve: 0 Not tainted 3.10.0-229.7.2.ovz.9.30-00007-japdoll-dirty #2 9.30
[43963.463913] Hardware name: DEPO Computers To Be Filled By O.E.M./H67DE3, BIOS L1.60c 07/14/2011
[43963.463976] task: ffff88042a5dc5b0 ti: ffff88037f8d8000 task.ti: ffff88037f8d8000
[43963.464036] RIP: 0010:[<ffffffff811c6959>]  [<ffffffff811c6959>] list_locations+0x169/0x4e0
[43963.464725] Call Trace:
[43963.464756]  [<ffffffff811c6d1d>] alloc_calls_show+0x1d/0x30
[43963.464793]  [<ffffffff811c15ab>] slab_attr_show+0x1b/0x30
[43963.464829]  [<ffffffff8125d27a>] sysfs_read_file+0x9a/0x1a0
[43963.464865]  [<ffffffff811e3c6c>] vfs_read+0x9c/0x170
[43963.464900]  [<ffffffff811e4798>] SyS_read+0x58/0xb0
[43963.464936]  [<ffffffff81612d49>] system_call_fastpath+0x16/0x1b
[43963.464970] Code: 5e 07 12 00 b9 00 04 00 00 3d 00 04 00 00 0f 4f c1 3d 00 04 00 00 89 45 b0 0f 84 c3 00 00 00 48 63 45 b0 49 8b 9c c4 f8 00 00 00 <48> 8b 43 20 48 85 c0 74 b6 48 89 df e8 46 37 44 00 48 8b 53 10
[43963.465119] RIP  [<ffffffff811c6959>] list_locations+0x169/0x4e0
[43963.465155]  RSP <ffff88037f8dbe28>
[43963.465185] CR2: 0000000000000020

Separated nodes structures and per-cpu freeing into __kmem_cache_release
and use it at kmem_cache_release.

Signed-off-by: Dmitry Safonov <dsafonov@virtuozzo.com>
Suggested-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |   11 ++++++++---
 mm/slab.h        |    1 +
 mm/slab_common.c |    1 +
 mm/slob.c        |    4 ++++
 mm/slub.c        |   26 +++++++++++---------------
 5 files changed, 25 insertions(+), 18 deletions(-)

diff -puN mm/slab.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file mm/slab.c
--- a/mm/slab.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file
+++ a/mm/slab.c
@@ -2302,13 +2302,19 @@ int __kmem_cache_shrink(struct kmem_cach
 
 int __kmem_cache_shutdown(struct kmem_cache *cachep)
 {
-	int i;
-	struct kmem_cache_node *n;
 	int rc = __kmem_cache_shrink(cachep, false);
 
 	if (rc)
 		return rc;
 
+	return 0;
+}
+
+void __kmem_cache_release(struct kmem_cache *cachep)
+{
+	int i;
+	struct kmem_cache_node *n;
+
 	free_percpu(cachep->cpu_cache);
 
 	/* NUMA: free the node structures */
@@ -2318,7 +2324,6 @@ int __kmem_cache_shutdown(struct kmem_ca
 		kfree(n);
 		cachep->node[i] = NULL;
 	}
-	return 0;
 }
 
 /*
diff -puN mm/slab.h~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file mm/slab.h
--- a/mm/slab.h~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file
+++ a/mm/slab.h
@@ -144,6 +144,7 @@ static inline unsigned long kmem_cache_f
 #define CACHE_CREATE_MASK (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS | SLAB_CACHE_FLAGS)
 
 int __kmem_cache_shutdown(struct kmem_cache *);
+void __kmem_cache_release(struct kmem_cache *);
 int __kmem_cache_shrink(struct kmem_cache *, bool);
 void slab_kmem_cache_release(struct kmem_cache *);
 
diff -puN mm/slab_common.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file
+++ a/mm/slab_common.c
@@ -697,6 +697,7 @@ static inline int shutdown_memcg_caches(
 
 void slab_kmem_cache_release(struct kmem_cache *s)
 {
+	__kmem_cache_release(s);
 	destroy_memcg_params(s);
 	kfree_const(s->name);
 	kmem_cache_free(kmem_cache, s);
diff -puN mm/slob.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file mm/slob.c
--- a/mm/slob.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file
+++ a/mm/slob.c
@@ -630,6 +630,10 @@ int __kmem_cache_shutdown(struct kmem_ca
 	return 0;
 }
 
+void __kmem_cache_release(struct kmem_cache *c)
+{
+}
+
 int __kmem_cache_shrink(struct kmem_cache *d, bool deactivate)
 {
 	return 0;
diff -puN mm/slub.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file mm/slub.c
--- a/mm/slub.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file
+++ a/mm/slub.c
@@ -3183,11 +3183,12 @@ static void early_kmem_cache_node_alloc(
 	__add_partial(n, page, DEACTIVATE_TO_HEAD);
 }
 
-static void free_kmem_cache_nodes(struct kmem_cache *s)
+void __kmem_cache_release(struct kmem_cache *s)
 {
 	int node;
 	struct kmem_cache_node *n;
 
+	free_percpu(s->cpu_slab);
 	for_each_kmem_cache_node(s, node, n) {
 		kmem_cache_free(kmem_cache_node, n);
 		s->node[node] = NULL;
@@ -3209,7 +3210,7 @@ static int init_kmem_cache_nodes(struct
 						GFP_KERNEL, node);
 
 		if (!n) {
-			free_kmem_cache_nodes(s);
+			__kmem_cache_release(s);
 			return 0;
 		}
 
@@ -3425,7 +3426,7 @@ static int kmem_cache_open(struct kmem_c
 	if (alloc_kmem_cache_cpus(s))
 		return 0;
 
-	free_kmem_cache_nodes(s);
+	__kmem_cache_release(s);
 error:
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slab %s size=%lu realsize=%u "
@@ -3465,7 +3466,7 @@ static void list_slab_objects(struct kme
 
 /*
  * Attempt to free all partial slabs on a node.
- * This is called from kmem_cache_close(). We must be the last thread
+ * This is called from __kmem_cache_shutdown(). We must be the last thread
  * using the cache and therefore we do not need to lock anymore.
  */
 static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
@@ -3478,7 +3479,7 @@ static void free_partial(struct kmem_cac
 			discard_slab(s, page);
 		} else {
 			list_slab_objects(s, page,
-			"Objects remaining in %s on kmem_cache_close()");
+			"Objects remaining in %s on __kmem_cache_shutdown()");
 		}
 	}
 }
@@ -3486,7 +3487,7 @@ static void free_partial(struct kmem_cac
 /*
  * Release all resources used by a slab cache.
  */
-static inline int kmem_cache_close(struct kmem_cache *s)
+int __kmem_cache_shutdown(struct kmem_cache *s)
 {
 	int node;
 	struct kmem_cache_node *n;
@@ -3498,16 +3499,9 @@ static inline int kmem_cache_close(struc
 		if (n->nr_partial || slabs_node(s, node))
 			return 1;
 	}
-	free_percpu(s->cpu_slab);
-	free_kmem_cache_nodes(s);
 	return 0;
 }
 
-int __kmem_cache_shutdown(struct kmem_cache *s)
-{
-	return kmem_cache_close(s);
-}
