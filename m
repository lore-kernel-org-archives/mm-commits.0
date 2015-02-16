From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch removed from
 -mm tree
Date: Mon, 16 Feb 2015 12:15:46 -0800
Message-ID: <54e24ff2.dA9bgMf9I4cL6iXY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbbBPUQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.hajda@samsung.com, cl@linux.com, geert@linux-m68k.org, greg@kroah.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mturquette@linaro.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: convert cache name allocations to kstrdup_const
has been removed from the -mm tree.  Its filename was
     mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrzej Hajda <a.hajda@samsung.com>
Subject: mm/slab: convert cache name allocations to kstrdup_const

slab frequently performs duplication of strings located in read-only
memory section.  Replacing kstrdup by kstrdup_const allows to avoid such
operations.

[akpm@linux-foundation.org: make the handling of kmem_cache.name const-correct]
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/slab_common.c~mm-slab-convert-cache-name-allocations-to-kstrdup_const mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-convert-cache-name-allocations-to-kstrdup_const
+++ a/mm/slab_common.c
@@ -295,8 +295,8 @@ unsigned long calculate_alignment(unsign
 }
 
 static struct kmem_cache *
-do_kmem_cache_create(char *name, size_t object_size, size_t size, size_t align,
-		     unsigned long flags, void (*ctor)(void *),
+do_kmem_cache_create(const char *name, size_t object_size, size_t size,
+		     size_t align, unsigned long flags, void (*ctor)(void *),
 		     struct mem_cgroup *memcg, struct kmem_cache *root_cache)
 {
 	struct kmem_cache *s;
@@ -363,7 +363,7 @@ kmem_cache_create(const char *name, size
 		  unsigned long flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s;
-	char *cache_name;
+	const char *cache_name;
 	int err;
 
 	get_online_cpus();
@@ -390,7 +390,7 @@ kmem_cache_create(const char *name, size
 	if (s)
 		goto out_unlock;
 
-	cache_name = kstrdup(name, GFP_KERNEL);
+	cache_name = kstrdup_const(name, GFP_KERNEL);
 	if (!cache_name) {
 		err = -ENOMEM;
 		goto out_unlock;
@@ -401,7 +401,7 @@ kmem_cache_create(const char *name, size
 				 flags, ctor, NULL, NULL);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
-		kfree(cache_name);
+		kfree_const(cache_name);
 	}
 
 out_unlock:
@@ -607,7 +607,7 @@ void memcg_destroy_kmem_caches(struct me
 void slab_kmem_cache_release(struct kmem_cache *s)
 {
 	destroy_memcg_params(s);
-	kfree(s->name);
+	kfree_const(s->name);
 	kmem_cache_free(kmem_cache, s);
 }
 
_

Patches currently in -mm which might be from a.hajda@samsung.com are

origin.patch

