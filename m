From: akpm@linux-foundation.org
Subject: [merged]
 slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:15 -0700
Message-ID: <5390ca6f.3EWP4Evag5k3MbVI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaFETwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, cl@linux-foundation.org, vdavydov@parallels.com

Subject: [merged] slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux-foundation.org,penberg@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:15 -0700


The patch titled
     Subject: slab: delete cache from list after __kmem_cache_shutdown succeeds
has been removed from the -mm tree.  Its filename was
     slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: delete cache from list after __kmem_cache_shutdown succeeds

Currently, on kmem_cache_destroy we delete the cache from the slab_list
before __kmem_cache_shutdown, inserting it back to the list on failure. 
Initially, this was done, because we could release the slab_mutex in
__kmem_cache_shutdown to delete sysfs slub entry, but since commit
41a212859a4d ("slub: use sysfs'es release mechanism for kmem_cache") we
remove sysfs entry later in kmem_cache_destroy after dropping the
slab_mutex, so that no implementation of __kmem_cache_shutdown can ever
release the lock.  Therefore we can simplify the code a bit by moving
list_del after __kmem_cache_shutdown.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab_common.c~slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds mm/slab_common.c
--- a/mm/slab_common.c~slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds
+++ a/mm/slab_common.c
@@ -346,15 +346,15 @@ void kmem_cache_destroy(struct kmem_cach
 	if (memcg_cleanup_cache_params(s) != 0)
 		goto out_unlock;
 
-	list_del(&s->list);
 	if (__kmem_cache_shutdown(s) != 0) {
-		list_add(&s->list, &slab_caches);
 		printk(KERN_ERR "kmem_cache_destroy %s: "
 		       "Slab cache still has objects\n", s->name);
 		dump_stack();
 		goto out_unlock;
 	}
 
+	list_del(&s->list);
+
 	mutex_unlock(&slab_mutex);
 	if (s->flags & SLAB_DESTROY_BY_RCU)
 		rcu_barrier();
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

