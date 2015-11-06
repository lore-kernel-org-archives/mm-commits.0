From: akpm@linux-foundation.org
Subject: [merged]
 slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:38 -0800
Message-ID: <563d084e.wiHuwjODfzSD/hyR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161995AbbKFUGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: do not warn that cache is busy on destroy more than once
has been removed from the -mm tree.  Its filename was
     slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm/slab_common.c: do not warn that cache is busy on destroy more than once

Currently, when kmem_cache_destroy() is called for a global cache, we
print a warning for each per memcg cache attached to it that has active
objects (see shutdown_cache).  This is redundant, because it gives no new
information and only clutters the log.  If a cache being destroyed has
active objects, there must be a memory leak in the module that created the
cache, and it does not matter if the cache was used by users in memory
cgroups or not.

This patch moves the warning from shutdown_cache(), which is called for
shutting down both global and per memcg caches, to kmem_cache_destroy(),
so that the warning is only printed once if there are objects left in the
cache being destroyed.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/slab_common.c~slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once mm/slab_common.c
--- a/mm/slab_common.c~slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once
+++ a/mm/slab_common.c
@@ -451,12 +451,8 @@ EXPORT_SYMBOL(kmem_cache_create);
 static int shutdown_cache(struct kmem_cache *s,
 		struct list_head *release, bool *need_rcu_barrier)
 {
-	if (__kmem_cache_shutdown(s) != 0) {
-		printk(KERN_ERR "kmem_cache_destroy %s: "
-		       "Slab cache still has objects\n", s->name);
-		dump_stack();
+	if (__kmem_cache_shutdown(s) != 0)
 		return -EBUSY;
-	}
 
 	if (s->flags & SLAB_DESTROY_BY_RCU)
 		*need_rcu_barrier = true;
@@ -722,8 +718,13 @@ void kmem_cache_destroy(struct kmem_cach
 
 	err = shutdown_memcg_caches(s, &release, &need_rcu_barrier);
 	if (!err)
-		shutdown_cache(s, &release, &need_rcu_barrier);
+		err = shutdown_cache(s, &release, &need_rcu_barrier);
 
+	if (err) {
+		pr_err("kmem_cache_destroy %s: "
+		       "Slab cache still has objects\n", s->name);
+		dump_stack();
+	}
 out_unlock:
 	mutex_unlock(&slab_mutex);
 
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

memcg-simplify-charging-kmem-pages.patch
memcg-unify-slab-and-other-kmem-pages-charging.patch
memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch
mm-do-not-inc-nr_pagetable-if-ptlock_init-failed.patch

