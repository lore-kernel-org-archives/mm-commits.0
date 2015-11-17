From: akpm@linux-foundation.org
Subject: + slab-slub-adjust-kmem_cache_alloc_bulk-api.patch added to -mm
 tree
Date: Tue, 17 Nov 2015 15:13:47 -0800
Message-ID: <564bb4ab.nJyeje50kLyJx7kG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbbKQXNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 18:13:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab/slub: adjust kmem_cache_alloc_bulk API
has been added to the -mm tree.  Its filename is
     slab-slub-adjust-kmem_cache_alloc_bulk-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-slub-adjust-kmem_cache_alloc_bulk-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-slub-adjust-kmem_cache_alloc_bulk-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slab/slub: adjust kmem_cache_alloc_bulk API

Adjust kmem_cache_alloc_bulk API before we have any real users.

Adjust API to return type 'int' instead of previously type 'bool'.  This
is done to allow future extention of the bulk alloc API.

A future extention could be to allow SLUB to stop at a page boundry, when
specified by a flag, and then return the number of objects.

The advantage of this approach, would make it easier to make bulk alloc
run without local IRQs disabled.  With an approach of cmpxchg "stealing"
the entire c->freelist or page->freelist.  To avoid overshooting we would
stop processing at a slab-page boundry.  Else we always end up returning
some objects at the cost of another cmpxchg.

To keep compatible with future users of this API linking against an older
kernel when using the new flag, we need to return the number of allocated
objects with this API change.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 mm/slab.c            |    8 ++++----
 mm/slab.h            |    2 +-
 mm/slab_common.c     |    6 +++---
 mm/slob.c            |    2 +-
 mm/slub.c            |    8 ++++----
 6 files changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/slab.h~slab-slub-adjust-kmem_cache_alloc_bulk-api include/linux/slab.h
--- a/include/linux/slab.h~slab-slub-adjust-kmem_cache_alloc_bulk-api
+++ a/include/linux/slab.h
@@ -316,7 +316,7 @@ void kmem_cache_free(struct kmem_cache *
  * Note that interrupts must be enabled when calling these functions.
  */
 void kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
-bool kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
+int kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
 
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_kmalloc_alignment;
diff -puN mm/slab.c~slab-slub-adjust-kmem_cache_alloc_bulk-api mm/slab.c
--- a/mm/slab.c~slab-slub-adjust-kmem_cache_alloc_bulk-api
+++ a/mm/slab.c
@@ -3420,8 +3420,8 @@ void *kmem_cache_alloc(struct kmem_cache
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 /* Note that interrupts must be enabled when calling this function. */
-bool kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
-			   void **p)
+int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
+			  void **p)
 {
 	size_t i;
 
@@ -3431,11 +3431,11 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 
 		if (!x) {
 			__kmem_cache_free_bulk(s, i, p);
-			return false;
+			return 0;
 		}
 	}
 	local_irq_enable();
-	return true;
+	return i;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk);
 
diff -puN mm/slab.h~slab-slub-adjust-kmem_cache_alloc_bulk-api mm/slab.h
--- a/mm/slab.h~slab-slub-adjust-kmem_cache_alloc_bulk-api
+++ a/mm/slab.h
@@ -170,7 +170,7 @@ ssize_t slabinfo_write(struct file *file
  * may be allocated or freed using these operations.
  */
 void __kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
-bool __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
+int __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
 
 #ifdef CONFIG_MEMCG_KMEM
 /*
diff -puN mm/slab_common.c~slab-slub-adjust-kmem_cache_alloc_bulk-api mm/slab_common.c
--- a/mm/slab_common.c~slab-slub-adjust-kmem_cache_alloc_bulk-api
+++ a/mm/slab_common.c
@@ -112,7 +112,7 @@ void __kmem_cache_free_bulk(struct kmem_
 		kmem_cache_free(s, p[i]);
 }
 
-bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t nr,
+int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t nr,
 								void **p)
 {
 	size_t i;
@@ -121,10 +121,10 @@ bool __kmem_cache_alloc_bulk(struct kmem
 		void *x = p[i] = kmem_cache_alloc(s, flags);
 		if (!x) {
 			__kmem_cache_free_bulk(s, i, p);
-			return false;
+			return 0;
 		}
 	}
-	return true;
+	return i;
 }
 
 #ifdef CONFIG_MEMCG_KMEM
diff -puN mm/slob.c~slab-slub-adjust-kmem_cache_alloc_bulk-api mm/slob.c
--- a/mm/slob.c~slab-slub-adjust-kmem_cache_alloc_bulk-api
+++ a/mm/slob.c
@@ -617,7 +617,7 @@ void kmem_cache_free_bulk(struct kmem_ca
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
-bool kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
+int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 								void **p)
 {
 	return __kmem_cache_alloc_bulk(s, flags, size, p);
diff -puN mm/slub.c~slab-slub-adjust-kmem_cache_alloc_bulk-api mm/slub.c
--- a/mm/slub.c~slab-slub-adjust-kmem_cache_alloc_bulk-api
+++ a/mm/slub.c
@@ -2909,8 +2909,8 @@ void kmem_cache_free_bulk(struct kmem_ca
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
 /* Note that interrupts must be enabled when calling this function. */
-bool kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
-			   void **p)
+int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
+			  void **p)
 {
 	struct kmem_cache_cpu *c;
 	int i;
@@ -2959,12 +2959,12 @@ bool kmem_cache_alloc_bulk(struct kmem_c
 
 	/* memcg and kmem_cache debug support */
 	slab_post_alloc_hook(s, flags, size, p);
-	return true;
+	return i;
 error:
 	local_irq_enable();
 	slab_post_alloc_hook(s, flags, i, p);
 	__kmem_cache_free_bulk(s, i, p);
-	return false;
+	return 0;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk);
 
_

Patches currently in -mm which might be from brouer@redhat.com are

slub-mark-the-dangling-ifdef-else-of-config_slub_debug.patch
slab-implement-bulking-for-slab-allocator.patch
slub-support-for-bulk-free-with-slub-freelists.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist.patch
slub-fix-kmem-cgroup-bug-in-kmem_cache_alloc_bulk.patch
slub-add-missing-kmem-cgroup-support-to-kmem_cache_free_bulk.patch
slab-slub-adjust-kmem_cache_alloc_bulk-api.patch

