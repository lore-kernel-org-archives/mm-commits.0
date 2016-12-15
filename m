From: akpm@linux-foundation.org
Subject: [merged] radix-tree-test-suite-cache-recently-freed-objects.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:49:25 -0800
Message-ID: <5852e5b5.YdaTz5EBEsoVxRw3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754074AbcLOSt3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: cache recently freed objects
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-cache-recently-freed-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix tree test suite: cache recently freed objects

The kmem_cache_alloc implementation simply allocates new memory from
malloc() and calls the ctor, which zeroes out the entire object.  This
means it cannot spot bugs where the object isn't properly reinitialised
before being freed.

Add a small (11 objects) cache before freeing objects back to malloc. 
This is enough to let us write a test to catch it, although the memory
allocator is now aware of the structure of the radix tree node, since it
chains free objects through ->private_data (like the percpu cache does).

Link: http://lkml.kernel.org/r/1481667692-14500-2-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c      |   48 ++++++++++++++++++++----
 tools/testing/radix-tree/linux/slab.h |    5 --
 2 files changed, 41 insertions(+), 12 deletions(-)

diff -puN tools/testing/radix-tree/linux.c~radix-tree-test-suite-cache-recently-freed-objects tools/testing/radix-tree/linux.c
--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-cache-recently-freed-objects
+++ a/tools/testing/radix-tree/linux.c
@@ -1,16 +1,27 @@
 #include <stdlib.h>
 #include <string.h>
 #include <malloc.h>
+#include <pthread.h>
 #include <unistd.h>
 #include <assert.h>
 
 #include <linux/mempool.h>
+#include <linux/poison.h>
 #include <linux/slab.h>
+#include <linux/radix-tree.h>
 #include <urcu/uatomic.h>
 
 int nr_allocated;
 int preempt_count;
 
+struct kmem_cache {
+	pthread_mutex_t lock;
+	int size;
+	int nr_objs;
+	void *objs;
+	void (*ctor)(void *);
+};
+
 void *mempool_alloc(mempool_t *pool, int gfp_mask)
 {
 	return pool->alloc(gfp_mask, pool->data);
@@ -34,24 +45,44 @@ mempool_t *mempool_create(int min_nr, me
 
 void *kmem_cache_alloc(struct kmem_cache *cachep, int flags)
 {
-	void *ret;
+	struct radix_tree_node *node;
 
 	if (flags & __GFP_NOWARN)
 		return NULL;
 
-	ret = malloc(cachep->size);
-	if (cachep->ctor)
-		cachep->ctor(ret);
+	pthread_mutex_lock(&cachep->lock);
+	if (cachep->nr_objs) {
+		cachep->nr_objs--;
+		node = cachep->objs;
+		cachep->objs = node->private_data;
+		pthread_mutex_unlock(&cachep->lock);
+		node->private_data = NULL;
+	} else {
+		pthread_mutex_unlock(&cachep->lock);
+		node = malloc(cachep->size);
+		if (cachep->ctor)
+			cachep->ctor(node);
+	}
+
 	uatomic_inc(&nr_allocated);
-	return ret;
+	return node;
 }
 
 void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 {
 	assert(objp);
 	uatomic_dec(&nr_allocated);
-	memset(objp, 0, cachep->size);
-	free(objp);
+	pthread_mutex_lock(&cachep->lock);
+	if (cachep->nr_objs > 10) {
+		memset(objp, POISON_FREE, cachep->size);
+		free(objp);
+	} else {
+		struct radix_tree_node *node = objp;
+		cachep->nr_objs++;
+		node->private_data = cachep->objs;
+		cachep->objs = node;
+	}
+	pthread_mutex_unlock(&cachep->lock);
 }
 
 void *kmalloc(size_t size, gfp_t gfp)
@@ -75,7 +106,10 @@ kmem_cache_create(const char *name, size
 {
 	struct kmem_cache *ret = malloc(sizeof(*ret));
 
+	pthread_mutex_init(&ret->lock, NULL);
 	ret->size = size;
+	ret->nr_objs = 0;
+	ret->objs = NULL;
 	ret->ctor = ctor;
 	return ret;
 }
diff -puN tools/testing/radix-tree/linux/slab.h~radix-tree-test-suite-cache-recently-freed-objects tools/testing/radix-tree/linux/slab.h
--- a/tools/testing/radix-tree/linux/slab.h~radix-tree-test-suite-cache-recently-freed-objects
+++ a/tools/testing/radix-tree/linux/slab.h
@@ -10,11 +10,6 @@
 void *kmalloc(size_t size, gfp_t);
 void kfree(void *);
 
-struct kmem_cache {
-	int size;
-	void (*ctor)(void *);
-};
