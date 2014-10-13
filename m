From: akpm@linux-foundation.org
Subject: [merged] mm-slab-support-slab-merge.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:54 -0700
Message-ID: <543c178e.rVosA7ZCeW8mBsQk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaJMSSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: support slab merge
has been removed from the -mm tree.  Its filename was
     mm-slab-support-slab-merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: support slab merge

Slab merge is good feature to reduce fragmentation.  If new creating slab
have similar size and property with exsitent slab, this feature reuse it
rather than creating new one.  As a result, objects are packed into fewer
slabs so that fragmentation is reduced.

Below is result of my testing.

* After boot, sleep 20; cat /proc/meminfo | grep Slab

<Before>
Slab: 25136 kB

<After>
Slab: 24364 kB

We can save 3% memory used by slab.

For supporting this feature in SLAB, we need to implement SLAB specific
kmem_cache_flag() and __kmem_cache_alias(), because SLUB implements some
SLUB specific processing related to debug flag and object size change on
these functions.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   26 ++++++++++++++++++++++++++
 mm/slab.h |    2 +-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-support-slab-merge mm/slab.c
--- a/mm/slab.c~mm-slab-support-slab-merge
+++ a/mm/slab.c
@@ -2104,6 +2104,32 @@ static int __init_refok setup_cpu_cache(
 	return 0;
 }
 
+unsigned long kmem_cache_flags(unsigned long object_size,
+	unsigned long flags, const char *name,
+	void (*ctor)(void *))
+{
+	return flags;
+}
+
+struct kmem_cache *
+__kmem_cache_alias(const char *name, size_t size, size_t align,
+		   unsigned long flags, void (*ctor)(void *))
+{
+	struct kmem_cache *cachep;
+
+	cachep = find_mergeable(size, align, flags, name, ctor);
+	if (cachep) {
+		cachep->refcount++;
+
+		/*
+		 * Adjust the object sizes so that we clear
+		 * the complete object on kzalloc.
+		 */
+		cachep->object_size = max_t(int, cachep->object_size, size);
+	}
+	return cachep;
+}
+
 /**
  * __kmem_cache_create - Create a cache.
  * @cachep: cache management descriptor
diff -puN mm/slab.h~mm-slab-support-slab-merge mm/slab.h
--- a/mm/slab.h~mm-slab-support-slab-merge
+++ a/mm/slab.h
@@ -92,7 +92,7 @@ struct mem_cgroup;
 int slab_unmergeable(struct kmem_cache *s);
 struct kmem_cache *find_mergeable(size_t size, size_t align,
 		unsigned long flags, const char *name, void (*ctor)(void *));
-#ifdef CONFIG_SLUB
+#ifndef CONFIG_SLOB
 struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
 		   unsigned long flags, void (*ctor)(void *));
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
page-owners-correct-page-order-when-to-free-page.patch

