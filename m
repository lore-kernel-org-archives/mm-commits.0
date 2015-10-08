From: akpm@linux-foundation.org
Subject: +
 slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once.patch
 added to -mm tree
Date: Thu, 08 Oct 2015 14:19:10 -0700
Message-ID: <5616ddce.2ijU3wwMearecXFH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbbJHVTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 17:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: do not warn that cache is busy on destroy more than once
has been added to the -mm tree.  Its filename is
     slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

slab_common-rename-cache-create-destroy-helpers.patch
slab_common-clear-pointers-to-per-memcg-caches-on-destroy.patch
slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once.patch

