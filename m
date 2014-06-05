From: akpm@linux-foundation.org
Subject: [merged]
 slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:49:51 -0700
Message-ID: <5390c9df.8biQT2bqPfLK/Tsz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaFETtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, wency@cn.fujitsu.com, toshi.kani@hp.com, tangchen@cn.fujitsu.com, rientjes@google.com, rafael.j.wysocki@intel.com, qiuxishi@huawei.com, penberg@kernel.org, liuj97@gmail.com, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, cl@linux.com, vdavydov@parallels.com

Subject: [merged] slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux.com,isimatu.yasuaki@jp.fujitsu.com,laijs@cn.fujitsu.com,liuj97@gmail.com,penberg@kernel.org,qiuxishi@huawei.com,rafael.j.wysocki@intel.com,rientjes@google.com,tangchen@cn.fujitsu.com,toshi.kani@hp.com,wency@cn.fujitsu.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:51 -0700


The patch titled
     Subject: slab: get_online_mems for kmem_cache_{create,destroy,shrink}
has been removed from the -mm tree.  Its filename was
     slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: get_online_mems for kmem_cache_{create,destroy,shrink}

When we create a sl[au]b cache, we allocate kmem_cache_node structures for
each online NUMA node.  To handle nodes taken online/offline, we register
memory hotplug notifier and allocate/free kmem_cache_node corresponding to
the node that changes its state for each kmem cache.

To synchronize between the two paths we hold the slab_mutex during both
the cache creationg/destruction path and while tuning per-node parts of
kmem caches in memory hotplug handler, but that's not quite right, because
it does not guarantee that a newly created cache will have all
kmem_cache_nodes initialized in case it races with memory hotplug.  For
instance, in case of slub:

    CPU0                            CPU1
    ----                            ----
    kmem_cache_create:              online_pages:
     __kmem_cache_create:            slab_memory_callback:
                                      slab_mem_going_online_callback:
                                       lock slab_mutex
                                       for each slab_caches list entry
                                           allocate kmem_cache node
                                       unlock slab_mutex
      lock slab_mutex
      init_kmem_cache_nodes:
       for_each_node_state(node, N_NORMAL_MEMORY)
           allocate kmem_cache node
      add kmem_cache to slab_caches list
      unlock slab_mutex
                                    online_pages (continued):
                                     node_states_set_node

As a result we'll get a kmem cache with not all kmem_cache_nodes
allocated.

To avoid issues like that we should hold get/put_online_mems() during the
whole kmem cache creation/destruction/shrink paths, just like we deal with
cpu hotplug.  This patch does the trick.

Note, that after it's applied, there is no need in taking the slab_mutex
for kmem_cache_shrink any more, so it is removed from there.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |   26 ++------------------------
 mm/slab.h        |    1 +
 mm/slab_common.c |   35 +++++++++++++++++++++++++++++++++--
 mm/slob.c        |    3 +--
 mm/slub.c        |    5 ++---
 5 files changed, 39 insertions(+), 31 deletions(-)

diff -puN mm/slab.c~slab-get_online_mems-for-kmem_cache_createdestroyshrink mm/slab.c
--- a/mm/slab.c~slab-get_online_mems-for-kmem_cache_createdestroyshrink
+++ a/mm/slab.c
@@ -2480,8 +2480,7 @@ out:
 	return nr_freed;
 }
 
-/* Called with slab_mutex held to protect against cpu hotplug */
-static int __cache_shrink(struct kmem_cache *cachep)
+int __kmem_cache_shrink(struct kmem_cache *cachep)
 {
 	int ret = 0, i = 0;
 	struct kmem_cache_node *n;
@@ -2502,32 +2501,11 @@ static int __cache_shrink(struct kmem_ca
 	return (ret ? 1 : 0);
 }
 
-/**
- * kmem_cache_shrink - Shrink a cache.
- * @cachep: The cache to shrink.
- *
- * Releases as many slabs as possible for a cache.
- * To help debugging, a zero exit status indicates all slabs were released.
- */
-int kmem_cache_shrink(struct kmem_cache *cachep)
-{
-	int ret;
-	BUG_ON(!cachep || in_interrupt());
-
-	get_online_cpus();
-	mutex_lock(&slab_mutex);
-	ret = __cache_shrink(cachep);
-	mutex_unlock(&slab_mutex);
-	put_online_cpus();
-	return ret;
-}
-EXPORT_SYMBOL(kmem_cache_shrink);
-
 int __kmem_cache_shutdown(struct kmem_cache *cachep)
 {
 	int i;
 	struct kmem_cache_node *n;
-	int rc = __cache_shrink(cachep);
+	int rc = __kmem_cache_shrink(cachep);
 
 	if (rc)
 		return rc;
diff -puN mm/slab.h~slab-get_online_mems-for-kmem_cache_createdestroyshrink mm/slab.h
--- a/mm/slab.h~slab-get_online_mems-for-kmem_cache_createdestroyshrink
+++ a/mm/slab.h
@@ -91,6 +91,7 @@ __kmem_cache_alias(const char *name, siz
 #define CACHE_CREATE_MASK (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS | SLAB_CACHE_FLAGS)
 
 int __kmem_cache_shutdown(struct kmem_cache *);
+int __kmem_cache_shrink(struct kmem_cache *);
 void slab_kmem_cache_release(struct kmem_cache *);
 
 struct seq_file;
diff -puN mm/slab_common.c~slab-get_online_mems-for-kmem_cache_createdestroyshrink mm/slab_common.c
--- a/mm/slab_common.c~slab-get_online_mems-for-kmem_cache_createdestroyshrink
+++ a/mm/slab_common.c
@@ -205,6 +205,8 @@ kmem_cache_create(const char *name, size
 	int err;
 
 	get_online_cpus();
+	get_online_mems();
+
 	mutex_lock(&slab_mutex);
 
 	err = kmem_cache_sanity_check(name, size);
@@ -239,6 +241,8 @@ kmem_cache_create(const char *name, size
 
 out_unlock:
 	mutex_unlock(&slab_mutex);
+
+	put_online_mems();
 	put_online_cpus();
 
 	if (err) {
@@ -272,6 +276,8 @@ void kmem_cache_create_memcg(struct mem_
 	char *cache_name;
 
 	get_online_cpus();
+	get_online_mems();
+
 	mutex_lock(&slab_mutex);
 
 	/*
@@ -295,6 +301,8 @@ void kmem_cache_create_memcg(struct mem_
 
 out_unlock:
 	mutex_unlock(&slab_mutex);
+
+	put_online_mems();
 	put_online_cpus();
 }
 
@@ -328,6 +336,8 @@ void slab_kmem_cache_release(struct kmem
 void kmem_cache_destroy(struct kmem_cache *s)
 {
 	get_online_cpus();
+	get_online_mems();
+
 	mutex_lock(&slab_mutex);
 
 	s->refcount--;
@@ -359,15 +369,36 @@ void kmem_cache_destroy(struct kmem_cach
 #else
 	slab_kmem_cache_release(s);
 #endif
-	goto out_put_cpus;
+	goto out;
 
 out_unlock:
 	mutex_unlock(&slab_mutex);
-out_put_cpus:
+out:
+	put_online_mems();
 	put_online_cpus();
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
+/**
+ * kmem_cache_shrink - Shrink a cache.
+ * @cachep: The cache to shrink.
+ *
+ * Releases as many slabs as possible for a cache.
+ * To help debugging, a zero exit status indicates all slabs were released.
+ */
+int kmem_cache_shrink(struct kmem_cache *cachep)
+{
+	int ret;
+
+	get_online_cpus();
+	get_online_mems();
+	ret = __kmem_cache_shrink(cachep);
+	put_online_mems();
+	put_online_cpus();
+	return ret;
+}
+EXPORT_SYMBOL(kmem_cache_shrink);
+
 int slab_is_available(void)
 {
 	return slab_state >= UP;
diff -puN mm/slob.c~slab-get_online_mems-for-kmem_cache_createdestroyshrink mm/slob.c
--- a/mm/slob.c~slab-get_online_mems-for-kmem_cache_createdestroyshrink
+++ a/mm/slob.c
@@ -620,11 +620,10 @@ int __kmem_cache_shutdown(struct kmem_ca
 	return 0;
 }
 
-int kmem_cache_shrink(struct kmem_cache *d)
+int __kmem_cache_shrink(struct kmem_cache *d)
 {
 	return 0;
 }
-EXPORT_SYMBOL(kmem_cache_shrink);
 
 struct kmem_cache kmem_cache_boot = {
 	.name = "kmem_cache",
diff -puN mm/slub.c~slab-get_online_mems-for-kmem_cache_createdestroyshrink mm/slub.c
--- a/mm/slub.c~slab-get_online_mems-for-kmem_cache_createdestroyshrink
+++ a/mm/slub.c
@@ -3398,7 +3398,7 @@ EXPORT_SYMBOL(kfree);
  * being allocated from last increasing the chance that the last objects
  * are freed in them.
  */
-int kmem_cache_shrink(struct kmem_cache *s)
+int __kmem_cache_shrink(struct kmem_cache *s)
 {
 	int node;
 	int i;
@@ -3454,7 +3454,6 @@ int kmem_cache_shrink(struct kmem_cache
 	kfree(slabs_by_inuse);
 	return 0;
 }
-EXPORT_SYMBOL(kmem_cache_shrink);
 
 static int slab_mem_going_offline_callback(void *arg)
 {
@@ -3462,7 +3461,7 @@ static int slab_mem_going_offline_callba
 
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list)
-		kmem_cache_shrink(s);
+		__kmem_cache_shrink(s);
 	mutex_unlock(&slab_mutex);
 
 	return 0;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

