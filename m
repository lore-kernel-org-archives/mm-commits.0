From: akpm@linux-foundation.org
Subject: + slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch
 added to -mm tree
Date: Mon, 26 Jan 2015 15:22:18 -0800
Message-ID: <54c6cc2a.dr/SICRI7hxgdVqR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbbAZXWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 18:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: suppress warnings caused by expansion of for_each_memcg_cache if !MEMCG_KMEM
has been added to the -mm tree.  Its filename is
     slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch

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

mm-vmscan-fix-highidx-argument-type.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
mm-memcontrol-simplify-soft-limit-tree-init-code.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-embed-memcg_cache_params-to-kmem_cache-fix.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch

