Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C721FC6
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DUvFRQYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29495C433C9;
	Mon, 11 Dec 2023 00:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256032;
	bh=1C2+O1efXqLcWlXaLkEshT7vaAvQrtXAqWbuLRUg4G8=;
	h=Date:To:From:Subject:From;
	b=DUvFRQYgsmKEl21QT41OvxOEdtnIQ2L9JEdznEpJQqCgaU3yEsCGQDwYSyLFx2XDk
	 O2lWNI06EWeMWa46vzK73vjN1tlaZkEWt+SSO2mks2/S6Y/MN//PAVWEeX+DoAHNBI
	 MSEPbRKnzThTPvPlLAuAMusd2CoBDms798dM7Bt4=
Date: Sun, 10 Dec 2023 16:53:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,peterz@infradead.org,npiggin@gmail.com,mst@redhat.com,mjguzik@gmail.com,michael.christie@oracle.com,mathieu.desnoyers@efficios.com,Liam.Howlett@oracle.com,corbet@lwn.net,brauner@kernel.org,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch removed from -mm tree
Message-Id: <20231211005352.29495C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: radix tree test suite: align kmem_cache_alloc_bulk() with kernel behavior.
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: radix tree test suite: align kmem_cache_alloc_bulk() with kernel behavior.
Date: Fri, 27 Oct 2023 11:38:39 +0800

When kmem_cache_alloc_bulk() fails to allocate, leave the freed pointers
in the array.  This enables a more accurate simulation of the kernel's
behavior and allows for testing potential double-free scenarios.

Link: https://lkml.kernel.org/r/20231027033845.90608-5-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c |   45 +++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 12 deletions(-)

--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior
+++ a/tools/testing/radix-tree/linux.c
@@ -93,13 +93,9 @@ void *kmem_cache_alloc_lru(struct kmem_c
 	return p;
 }
 
-void kmem_cache_free_locked(struct kmem_cache *cachep, void *objp)
+void __kmem_cache_free_locked(struct kmem_cache *cachep, void *objp)
 {
 	assert(objp);
-	uatomic_dec(&nr_allocated);
-	uatomic_dec(&cachep->nr_allocated);
-	if (kmalloc_verbose)
-		printf("Freeing %p to slab\n", objp);
 	if (cachep->nr_objs > 10 || cachep->align) {
 		memset(objp, POISON_FREE, cachep->size);
 		free(objp);
@@ -111,6 +107,15 @@ void kmem_cache_free_locked(struct kmem_
 	}
 }
 
+void kmem_cache_free_locked(struct kmem_cache *cachep, void *objp)
+{
+	uatomic_dec(&nr_allocated);
+	uatomic_dec(&cachep->nr_allocated);
+	if (kmalloc_verbose)
+		printf("Freeing %p to slab\n", objp);
+	__kmem_cache_free_locked(cachep, objp);
+}
+
 void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 {
 	pthread_mutex_lock(&cachep->lock);
@@ -141,18 +146,17 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	if (kmalloc_verbose)
 		pr_debug("Bulk alloc %lu\n", size);
 
-	if (!(gfp & __GFP_DIRECT_RECLAIM)) {
-		if (cachep->non_kernel < size)
-			return 0;
-
-		cachep->non_kernel -= size;
-	}
-
 	pthread_mutex_lock(&cachep->lock);
 	if (cachep->nr_objs >= size) {
 		struct radix_tree_node *node;
 
 		for (i = 0; i < size; i++) {
+			if (!(gfp & __GFP_DIRECT_RECLAIM)) {
+				if (!cachep->non_kernel)
+					break;
+				cachep->non_kernel--;
+			}
+
 			node = cachep->objs;
 			cachep->nr_objs--;
 			cachep->objs = node->parent;
@@ -163,11 +167,19 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	} else {
 		pthread_mutex_unlock(&cachep->lock);
 		for (i = 0; i < size; i++) {
+			if (!(gfp & __GFP_DIRECT_RECLAIM)) {
+				if (!cachep->non_kernel)
+					break;
+				cachep->non_kernel--;
+			}
+
 			if (cachep->align) {
 				posix_memalign(&p[i], cachep->align,
 					       cachep->size);
 			} else {
 				p[i] = malloc(cachep->size);
+				if (!p[i])
+					break;
 			}
 			if (cachep->ctor)
 				cachep->ctor(p[i]);
@@ -176,6 +188,15 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 		}
 	}
 
+	if (i < size) {
+		size = i;
+		pthread_mutex_lock(&cachep->lock);
+		for (i = 0; i < size; i++)
+			__kmem_cache_free_locked(cachep, p[i]);
+		pthread_mutex_unlock(&cachep->lock);
+		return 0;
+	}
+
 	for (i = 0; i < size; i++) {
 		uatomic_inc(&nr_allocated);
 		uatomic_inc(&cachep->nr_allocated);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch
maple_tree-avoid-ascending-when-mas-min-is-also-the-parents-minimum.patch
maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch
maple_tree-delete-one-of-the-two-identical-checks.patch
maple_tree-simplify-mas_leaf_set_meta.patch

