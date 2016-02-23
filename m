From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-free-kmem_cache_node-after-destroy-sysfs-file.patch removed from
 -mm tree
Date: Tue, 23 Feb 2016 12:49:58 -0800
Message-ID: <56ccc5f6.HNTzNtVYE/PXliHI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbcBWUt7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 15:49:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsafonov@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab: free kmem_cache_node after destroy sysfs file
has been removed from the -mm tree.  Its filename was
     mm-slab-free-kmem_cache_node-after-destroy-sysfs-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dsafonov@virtuozzo.com>
Subject: mm: slab: free kmem_cache_node after destroy sysfs file

When slub_debug alloc_calls_show is enabled we will try to track location
and user of slab object on each online node, kmem_cache_node structure and
cpu_cache/cpu_slub shouldn't be freed till there is the last reference to
sysfs file.

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

Separated __kmem_cache_release from __kmem_cache_shutdown which now called
on slab_kmem_cache_release (after the last reference to sysfs file object
has dropped).

Reintroduced locking in free_partial as sysfs file might access cache's
partial list after shutdowning - partiall revert of the commit
69cb8e6b7c2982 ("slub: free slabs without holding locks") Zap
__remove_partial and use remove_partial (w/o underscores) as free_partial
now takes list_lock which s partial revert for commit 1e4dd9461fabfb
("slub: do not assert not having lock in removing freed partial")

Signed-off-by: Dmitry Safonov <dsafonov@virtuozzo.com>
Suggested-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |   12 ++++++------
 mm/slab.h        |    1 +
 mm/slab_common.c |    1 +
 mm/slob.c        |    4 ++++
 mm/slub.c        |   38 +++++++++++++++++---------------------
 5 files changed, 29 insertions(+), 27 deletions(-)

diff -puN mm/slab.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file mm/slab.c
--- a/mm/slab.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file
+++ a/mm/slab.c
@@ -2275,7 +2275,7 @@ __kmem_cache_create (struct kmem_cache *
 
 	err = setup_cpu_cache(cachep, gfp);
 	if (err) {
-		__kmem_cache_shutdown(cachep);
+		__kmem_cache_release(cachep);
 		return err;
 	}
 
@@ -2414,12 +2414,13 @@ int __kmem_cache_shrink(struct kmem_cach
 
 int __kmem_cache_shutdown(struct kmem_cache *cachep)
 {
+	return __kmem_cache_shrink(cachep, false);
+}
+
+void __kmem_cache_release(struct kmem_cache *cachep)
+{
 	int i;
 	struct kmem_cache_node *n;
-	int rc = __kmem_cache_shrink(cachep, false);
-
-	if (rc)
-		return rc;
 
 	free_percpu(cachep->cpu_cache);
 
@@ -2430,7 +2431,6 @@ int __kmem_cache_shutdown(struct kmem_ca
 		kfree(n);
 		cachep->node[i] = NULL;
 	}
-	return 0;
 }
 
 /*
diff -puN mm/slab.h~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file mm/slab.h
--- a/mm/slab.h~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file
+++ a/mm/slab.h
@@ -140,6 +140,7 @@ static inline unsigned long kmem_cache_f
 #define CACHE_CREATE_MASK (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS | SLAB_CACHE_FLAGS)
 
 int __kmem_cache_shutdown(struct kmem_cache *);
+void __kmem_cache_release(struct kmem_cache *);
 int __kmem_cache_shrink(struct kmem_cache *, bool);
 void slab_kmem_cache_release(struct kmem_cache *);
 
diff -puN mm/slab_common.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file
+++ a/mm/slab_common.c
@@ -693,6 +693,7 @@ static inline int shutdown_memcg_caches(
 
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
@@ -1592,18 +1592,12 @@ static inline void add_partial(struct km
 	__add_partial(n, page, tail);
 }
 
-static inline void
-__remove_partial(struct kmem_cache_node *n, struct page *page)
-{
-	list_del(&page->lru);
-	n->nr_partial--;
-}
-
 static inline void remove_partial(struct kmem_cache_node *n,
 					struct page *page)
 {
 	lockdep_assert_held(&n->list_lock);
-	__remove_partial(n, page);
+	list_del(&page->lru);
+	n->nr_partial--;
 }
 
 /*
@@ -3184,6 +3178,12 @@ static void free_kmem_cache_nodes(struct
 	}
 }
 
+void __kmem_cache_release(struct kmem_cache *s)
+{
+	free_percpu(s->cpu_slab);
+	free_kmem_cache_nodes(s);
+}
+
 static int init_kmem_cache_nodes(struct kmem_cache *s)
 {
 	int node;
@@ -3443,28 +3443,31 @@ static void list_slab_objects(struct kme
 
 /*
  * Attempt to free all partial slabs on a node.
- * This is called from kmem_cache_close(). We must be the last thread
- * using the cache and therefore we do not need to lock anymore.
+ * This is called from __kmem_cache_shutdown(). We must take list_lock
+ * because sysfs file might still access partial list after the shutdowning.
  */
 static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
 {
 	struct page *page, *h;
 
+	BUG_ON(irqs_disabled());
+	spin_lock_irq(&n->list_lock);
 	list_for_each_entry_safe(page, h, &n->partial, lru) {
 		if (!page->inuse) {
-			__remove_partial(n, page);
+			remove_partial(n, page);
 			discard_slab(s, page);
 		} else {
 			list_slab_objects(s, page,
-			"Objects remaining in %s on kmem_cache_close()");
+			"Objects remaining in %s on __kmem_cache_shutdown()");
 		}
 	}
+	spin_unlock_irq(&n->list_lock);
 }
 
 /*
  * Release all resources used by a slab cache.
  */
-static inline int kmem_cache_close(struct kmem_cache *s)
+int __kmem_cache_shutdown(struct kmem_cache *s)
 {
 	int node;
 	struct kmem_cache_node *n;
@@ -3476,16 +3479,9 @@ static inline int kmem_cache_close(struc
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
