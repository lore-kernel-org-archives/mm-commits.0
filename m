From: akpm@linux-foundation.org
Subject: +
 slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch
 added to -mm tree
Date: Thu, 15 May 2014 14:06:20 -0700
Message-ID: <53752c4c.saWi0eahpwASatAf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaEOVGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 17:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, cl@linux-foundation.org, vdavydov@parallels.com

Subject: + slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch added to -mm tree
To: vdavydov@parallels.com,cl@linux-foundation.org,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 14:06:20 -0700


The patch titled
     Subject: slab: delete cache from list after __kmem_cache_shutdown succeeds
has been added to the -mm tree.  Its filename is
     slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch

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

slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
mm-get-rid-of-__gfp_kmemcg-fix.patch
slab-document-kmalloc_order.patch
memcg-un-export-__memcg_kmem_get_cache.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
memcg-get-rid-of-memcg_create_cache_name.patch
memcg-memcg_kmem_create_cache-make-memcg_name_buf.patch
memcg-cleanup-kmem-cache-creation-destruction-functions-naming.patch
slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch

