From: akpm@linux-foundation.org
Subject: +
 slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove.patch added to
 -mm tree
Date: Fri, 03 Feb 2017 15:15:42 -0800
Message-ID: <58950f1e.WXBNlDHZmap2XokL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39086 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753113AbdBCXPo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 18:15:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: separate out sysfs_slab_release() from sysfs_slab_remove()
has been added to the -mm tree.  Its filename is
     slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: slub: separate out sysfs_slab_release() from sysfs_slab_remove()

Separate out slub sysfs removal and release, and call the former earlier
from __kmem_cache_shutdown().  There's no reason to defer sysfs removal
through RCU and this will later allow us to remove sysfs files way earlier
during memory cgroup offline instead of release.

Link: http://lkml.kernel.org/r/20170117235411.9408-3-tj@kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    4 ++--
 mm/slab_common.c         |    2 +-
 mm/slub.c                |   12 ++++++++++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff -puN include/linux/slub_def.h~slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove
+++ a/include/linux/slub_def.h
@@ -113,9 +113,9 @@ struct kmem_cache {
 
 #ifdef CONFIG_SYSFS
 #define SLAB_SUPPORTS_SYSFS
-void sysfs_slab_remove(struct kmem_cache *);
+void sysfs_slab_release(struct kmem_cache *);
 #else
-static inline void sysfs_slab_remove(struct kmem_cache *s)
+static inline void sysfs_slab_release(struct kmem_cache *s)
 {
 }
 #endif
diff -puN mm/slab_common.c~slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove mm/slab_common.c
--- a/mm/slab_common.c~slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove
+++ a/mm/slab_common.c
@@ -483,7 +483,7 @@ static void release_caches(struct list_h
 
 	list_for_each_entry_safe(s, s2, release, list) {
 #ifdef SLAB_SUPPORTS_SYSFS
-		sysfs_slab_remove(s);
+		sysfs_slab_release(s);
 #else
 		slab_kmem_cache_release(s);
 #endif
diff -puN mm/slub.c~slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove mm/slub.c
--- a/mm/slub.c~slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove
+++ a/mm/slub.c
@@ -214,11 +214,13 @@ enum track_item { TRACK_ALLOC, TRACK_FRE
 static int sysfs_slab_add(struct kmem_cache *);
 static int sysfs_slab_alias(struct kmem_cache *, const char *);
 static void memcg_propagate_slab_attrs(struct kmem_cache *s);
+static void sysfs_slab_remove(struct kmem_cache *s);
 #else
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
 static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
 							{ return 0; }
 static inline void memcg_propagate_slab_attrs(struct kmem_cache *s) { }
+static inline void sysfs_slab_remove(struct kmem_cache *s) { }
 #endif
 
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
@@ -3683,6 +3685,7 @@ int __kmem_cache_shutdown(struct kmem_ca
 		if (n->nr_partial || slabs_node(s, node))
 			return 1;
 	}
+	sysfs_slab_remove(s);
 	return 0;
 }
 
@@ -5633,7 +5636,7 @@ out_del_kobj:
 	goto out;
 }
 
-void sysfs_slab_remove(struct kmem_cache *s)
+static void sysfs_slab_remove(struct kmem_cache *s)
 {
 	if (slab_state < FULL)
 		/*
@@ -5647,7 +5650,12 @@ void sysfs_slab_remove(struct kmem_cache
 #endif
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
-	kobject_put(&s->kobj);
+}
+
+void sysfs_slab_release(struct kmem_cache *s)
+{
+	if (slab_state >= FULL)
+		kobject_put(&s->kobj);
 }
 
 /*
_

Patches currently in -mm which might be from tj@kernel.org are

revert-slub-move-synchronize_sched-out-of-slab_mutex-on-shrink.patch
slub-separate-out-sysfs_slab_release-from-sysfs_slab_remove.patch
slab-remove-synchronous-rcu_barrier-call-in-memcg-cache-release-path.patch
slab-reorganize-memcg_cache_params.patch
slab-link-memcg-kmem_caches-on-their-associated-memory-cgroup.patch
slab-implement-slab_root_caches-list.patch
slab-introduce-__kmemcg_cache_deactivate.patch
slab-remove-synchronous-synchronize_sched-from-memcg-cache-deactivation-path.patch
slab-remove-slub-sysfs-interface-files-early-for-empty-memcg-caches.patch
slab-use-memcg_kmem_cache_wq-for-slab-destruction-operations.patch

