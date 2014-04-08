From: akpm@linux-foundation.org
Subject: [merged] slub-rework-sysfs-layout-for-memcg-caches.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:44:33 -0700
Message-ID: <53446dc1.q7Uv8ogK5ZRZmBPq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbaDHVoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, vdavydov@parallels.com

Subject: [merged] slub-rework-sysfs-layout-for-memcg-caches.patch removed from -mm tree
To: vdavydov@parallels.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:44:33 -0700


The patch titled
     Subject: slub: rework sysfs layout for memcg caches
has been removed from the -mm tree.  Its filename was
     slub-rework-sysfs-layout-for-memcg-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: rework sysfs layout for memcg caches

Currently, we try to arrange sysfs entries for memcg caches in the same
manner as for global caches.  Apart from turning /sys/kernel/slab into a
mess when there are a lot of kmem-active memcgs created, it actually does
not work properly - we won't create more than one link to a memcg cache in
case its parent is merged with another cache.  For instance, if A is a
root cache merged with another root cache B, we will have the following
sysfs setup:

  X
  A -> X
  B -> X

where X is some unique id (see create_unique_id()).  Now if memcgs M and N
start to allocate from cache A (or B, which is the same), we will get:

  X
  X:M
  X:N
  A -> X
  B -> X
  A:M -> X:M
  A:N -> X:N

Since B is an alias for A, we won't get entries B:M and B:N, which is
confusing.

It is more logical to have entries for memcg caches under the
corresponding root cache's sysfs directory.  This would allow us to keep
sysfs layout clean, and avoid such inconsistencies like one described
above.

This patch does the trick.  It creates a "cgroup" kset in each root cache
kobject to keep its children caches there.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    3 +++
 mm/slub.c                |   26 +++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff -puN include/linux/slub_def.h~slub-rework-sysfs-layout-for-memcg-caches include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-rework-sysfs-layout-for-memcg-caches
+++ a/include/linux/slub_def.h
@@ -87,6 +87,9 @@ struct kmem_cache {
 #ifdef CONFIG_MEMCG_KMEM
 	struct memcg_cache_params *memcg_params;
 	int max_attr_size; /* for propagation, maximum size of a stored attr */
+#ifdef CONFIG_SYSFS
+	struct kset *memcg_kset;
+#endif
 #endif
 
 #ifdef CONFIG_NUMA
diff -puN mm/slub.c~slub-rework-sysfs-layout-for-memcg-caches mm/slub.c
--- a/mm/slub.c~slub-rework-sysfs-layout-for-memcg-caches
+++ a/mm/slub.c
@@ -5138,6 +5138,15 @@ static const struct kset_uevent_ops slab
 
 static struct kset *slab_kset;
 
+static inline struct kset *cache_kset(struct kmem_cache *s)
+{
+#ifdef CONFIG_MEMCG_KMEM
+	if (!is_root_cache(s))
+		return s->memcg_params->root_cache->memcg_kset;
+#endif
+	return slab_kset;
+}
+
 #define ID_STR_LENGTH 64
 
 /* Create a unique string id for a slab cache:
@@ -5203,7 +5212,7 @@ static int sysfs_slab_add(struct kmem_ca
 		name = create_unique_id(s);
 	}
 
-	s->kobj.kset = slab_kset;
+	s->kobj.kset = cache_kset(s);
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
 	if (err) {
 		kobject_put(&s->kobj);
@@ -5216,6 +5225,18 @@ static int sysfs_slab_add(struct kmem_ca
 		kobject_put(&s->kobj);
 		return err;
 	}
+
+#ifdef CONFIG_MEMCG_KMEM
+	if (is_root_cache(s)) {
+		s->memcg_kset = kset_create_and_add("cgroup", NULL, &s->kobj);
+		if (!s->memcg_kset) {
+			kobject_del(&s->kobj);
+			kobject_put(&s->kobj);
+			return -ENOMEM;
+		}
+	}
+#endif
+
 	kobject_uevent(&s->kobj, KOBJ_ADD);
 	if (!unmergeable) {
 		/* Setup first alias */
@@ -5234,6 +5255,9 @@ static void sysfs_slab_remove(struct kme
 		 */
 		return;
 
+#ifdef CONFIG_MEMCG_KMEM
+	kset_unregister(s->memcg_kset);
+#endif
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
 	kobject_put(&s->kobj);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch

