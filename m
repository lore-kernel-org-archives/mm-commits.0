From: akpm@linux-foundation.org
Subject: [folded-merged]
 slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch removed from
 -mm tree
Date: Thu, 12 Feb 2015 14:14:25 -0800
Message-ID: <54dd25c1.QYZv26eNHvhKojze%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbbBLWO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:14:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: suppress warnings caused by expansion of for_each_memcg_cache if !MEMCG_KMEM
has been removed from the -mm tree.  Its filename was
     slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch

This patch was dropped because it was folded into slab-link-memcg-caches-of-the-same-kind-into-a-list.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: suppress warnings caused by expansion of for_each_memcg_cache if !MEMCG_KMEM

   In file included from mm/slab_common.c:26:0:
   mm/slab_common.c: In function 'kmem_cache_destroy':
>> mm/slab.h:259:30: warning: right-hand operand of comma expression has no effect [-Wunused-value]
     for (iter = NULL, tmp = NULL, (root); 0; )
                                 ^
>> mm/slab_common.c:603:2: note: in expansion of macro 'for_each_memcg_cache_safe'
     for_each_memcg_cache_safe(c, c2, s) {
     ^

fixes: slab-link-memcg-caches-of-the-same-kind-into-a-list
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.h~slab-link-memcg-caches-of-the-same-kind-into-a-list-fix mm/slab.h
--- a/mm/slab.h~slab-link-memcg-caches-of-the-same-kind-into-a-list-fix
+++ a/mm/slab.h
@@ -254,9 +254,9 @@ extern void slab_init_memcg_params(struc
 #else /* !CONFIG_MEMCG_KMEM */
 
 #define for_each_memcg_cache(iter, root) \
-	for (iter = NULL, (root); 0; )
+	for ((void)(iter), (void)(root); 0; )
 #define for_each_memcg_cache_safe(iter, tmp, root) \
-	for (iter = NULL, tmp = NULL, (root); 0; )
+	for ((void)(iter), (void)(tmp), (void)(root); 0; )
 
 static inline bool is_root_cache(struct kmem_cache *s)
 {
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

