From: akpm@linux-foundation.org
Subject: +
 memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch added to -mm tree
Date: Fri, 21 Feb 2014 14:29:16 -0800
Message-ID: <5307d33c.aWv1lDhR8GcJ9imM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaBUW3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 17:29:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, vdavydov@parallels.com

Subject: + memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch added to -mm tree
To: vdavydov@parallels.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 14:29:16 -0800


The patch titled
     Subject: memcg, slab: do not destroy children caches if parent has aliases
has been added to the -mm tree.  Its filename is
     memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg, slab: do not destroy children caches if parent has aliases

Currently we destroy children caches at the very beginning of
kmem_cache_destroy().  This is wrong, because the root cache will not
necessarily be destroyed in the end - if it has aliases (refcount > 0),
kmem_cache_destroy() will simply decrement its refcount and return.  In
this case, at best we will get a bunch of warnings in dmesg, like this
one:

  kmem_cache_destroy kmalloc-32:0: Slab cache still has objects
  CPU: 1 PID: 7139 Comm: modprobe Tainted: G    B   W    3.13.0+ #117
  Hardware name:
   ffff88007d7a6368 ffff880039b07e48 ffffffff8168cc2e ffff88007d7a6d68
   ffff88007d7a6300 ffff880039b07e68 ffffffff81175e9f 0000000000000000
   ffff88007d7a6300 ffff880039b07e98 ffffffff811b67c7 ffff88003e803c00
  Call Trace:
   [<ffffffff8168cc2e>] dump_stack+0x49/0x5b
   [<ffffffff81175e9f>] kmem_cache_destroy+0xdf/0xf0
   [<ffffffff811b67c7>] kmem_cache_destroy_memcg_children+0x97/0xc0
   [<ffffffff81175dcf>] kmem_cache_destroy+0xf/0xf0
   [<ffffffffa0130b21>] xfs_mru_cache_uninit+0x21/0x30 [xfs]
   [<ffffffffa01893ea>] exit_xfs_fs+0x2e/0xc44 [xfs]
   [<ffffffff810eeb58>] SyS_delete_module+0x198/0x1f0
   [<ffffffff816994f9>] system_call_fastpath+0x16/0x1b

At worst - if kmem_cache_destroy() will race with an allocation from a
memcg cache - the kernel will panic.

This patch fixes this by moving children caches destruction after the
check if the cache has aliases.  Plus, it forbids destroying a root cache
if it still has children caches, because each children cache keeps a
reference to its parent.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 --
 mm/memcontrol.c            |   13 ++----
 mm/slab_common.c           |   75 +++++++++++++++++++++++------------
 3 files changed, 57 insertions(+), 37 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases
+++ a/include/linux/memcontrol.h
@@ -513,7 +513,7 @@ struct kmem_cache *
 __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 
 void mem_cgroup_destroy_cache(struct kmem_cache *cachep);
-void kmem_cache_destroy_memcg_children(struct kmem_cache *s);
+int __kmem_cache_destroy_memcg_children(struct kmem_cache *s);
 
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
@@ -667,10 +667,6 @@ memcg_kmem_get_cache(struct kmem_cache *
 {
 	return cachep;
 }
-
-static inline void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN mm/memcontrol.c~memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases
+++ a/mm/memcontrol.c
@@ -3420,15 +3420,10 @@ void mem_cgroup_destroy_cache(struct kme
 	schedule_work(&cachep->memcg_params->destroy);
 }
 
-void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
+int __kmem_cache_destroy_memcg_children(struct kmem_cache *s)
 {
 	struct kmem_cache *c;
-	int i;
-
-	if (!s->memcg_params)
-		return;
-	if (!s->memcg_params->is_root_cache)
-		return;
+	int i, failed = 0;
 
 	/*
 	 * If the cache is being destroyed, we trust that there is no one else
@@ -3462,8 +3457,12 @@ void kmem_cache_destroy_memcg_children(s
 		c->memcg_params->dead = false;
 		cancel_work_sync(&c->memcg_params->destroy);
 		kmem_cache_destroy(c);
+
+		if (cache_from_memcg_idx(s, i))
+			failed++;
 	}
 	mutex_unlock(&activate_kmem_mutex);
+	return failed;
 }
 
 static void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
diff -puN mm/slab_common.c~memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases mm/slab_common.c
--- a/mm/slab_common.c~memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases
+++ a/mm/slab_common.c
@@ -301,39 +301,64 @@ out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 }
+
+static int kmem_cache_destroy_memcg_children(struct kmem_cache *s)
+{
+	int rc;
+
+	if (!s->memcg_params ||
+	    !s->memcg_params->is_root_cache)
+		return 0;
+
+	mutex_unlock(&slab_mutex);
+	rc = __kmem_cache_destroy_memcg_children(s);
+	mutex_lock(&slab_mutex);
+
+	return rc;
+}
+#else
+static int kmem_cache_destroy_memcg_children(struct kmem_cache *s)
+{
+	return 0;
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-	/* Destroy all the children caches if we aren't a memcg cache */
-	kmem_cache_destroy_memcg_children(s);
-
 	get_online_cpus();
 	mutex_lock(&slab_mutex);
+
 	s->refcount--;
-	if (!s->refcount) {
-		list_del(&s->list);
-		memcg_unregister_cache(s);
-
-		if (!__kmem_cache_shutdown(s)) {
-			mutex_unlock(&slab_mutex);
-			if (s->flags & SLAB_DESTROY_BY_RCU)
-				rcu_barrier();
-
-			memcg_free_cache_params(s);
-			kfree(s->name);
-			kmem_cache_free(kmem_cache, s);
-		} else {
-			list_add(&s->list, &slab_caches);
-			memcg_register_cache(s);
-			mutex_unlock(&slab_mutex);
-			printk(KERN_ERR "kmem_cache_destroy %s: Slab cache still has objects\n",
-				s->name);
-			dump_stack();
-		}
-	} else {
-		mutex_unlock(&slab_mutex);
+	if (s->refcount)
+		goto out_unlock;
+
+	if (kmem_cache_destroy_memcg_children(s) != 0)
+		goto out_unlock;
+
+	list_del(&s->list);
+	memcg_unregister_cache(s);
+
+	if (__kmem_cache_shutdown(s) != 0) {
+		list_add(&s->list, &slab_caches);
+		memcg_register_cache(s);
+		printk(KERN_ERR "kmem_cache_destroy %s: "
+		       "Slab cache still has objects\n", s->name);
+		dump_stack();
+		goto out_unlock;
 	}
+
+	mutex_unlock(&slab_mutex);
+	if (s->flags & SLAB_DESTROY_BY_RCU)
+		rcu_barrier();
+
+	memcg_free_cache_params(s);
+	kfree(s->name);
+	kmem_cache_free(kmem_cache, s);
+	goto out_put_cpus;
+
+out_unlock:
+	mutex_unlock(&slab_mutex);
+out_put_cpus:
 	put_online_cpus();
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
linux-next.patch

