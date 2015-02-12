From: akpm@linux-foundation.org
Subject: [folded-merged]
 slab-embed-memcg_cache_params-to-kmem_cache-fix.patch removed from -mm tree
Date: Thu, 12 Feb 2015 14:14:05 -0800
Message-ID: <54dd25ad.zNKL0Lp7KOOqNs8i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbbBLWOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:14:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: update_memcg_params: explicitly check that old array != NULL
has been removed from the -mm tree.  Its filename was
     slab-embed-memcg_cache_params-to-kmem_cache-fix.patch

This patch was dropped because it was folded into slab-embed-memcg_cache_params-to-kmem_cache.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: update_memcg_params: explicitly check that old array != NULL

mm/slab_common.c:166 update_memcg_params() warn: variable dereferenced before check 'old' (see line 162)

This warning is false-positive, because @old equals NULL iff
@memcg_nr_cache_ids equals 0. Moreover, this function had been acting in
exactly the same fashion before it was reworked by the culprit. Anyways,
let's add an explicit check if @old is not NULL before passing it to
@memcpy() to make static analysis tools happy.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/slab_common.c~slab-embed-memcg_cache_params-to-kmem_cache-fix mm/slab_common.c
--- a/mm/slab_common.c~slab-embed-memcg_cache_params-to-kmem_cache-fix
+++ a/mm/slab_common.c
@@ -152,15 +152,16 @@ static int update_memcg_params(struct km
 	if (!is_root_cache(s))
 		return 0;
 
-	old = rcu_dereference_protected(s->memcg_params.memcg_caches,
-					lockdep_is_held(&slab_mutex));
 	new = kzalloc(sizeof(struct memcg_cache_array) +
 		      new_array_size * sizeof(void *), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
-	memcpy(new->entries, old->entries,
-	       memcg_nr_cache_ids * sizeof(void *));
+	old = rcu_dereference_protected(s->memcg_params.memcg_caches,
+					lockdep_is_held(&slab_mutex));
+	if (old)
+		memcpy(new->entries, old->entries,
+		       memcg_nr_cache_ids * sizeof(void *));
 
 	rcu_assign_pointer(s->memcg_params.memcg_caches, new);
 	if (old)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-never-fail-to-shrink-cache-init-discard-list-after-freeing-slabs.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
memcg-cleanup-static-keys-decrement.patch

