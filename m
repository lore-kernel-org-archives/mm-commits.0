From: akpm@linux-foundation.org
Subject: + slab-embed-memcg_cache_params-to-kmem_cache-fix.patch added to
 -mm tree
Date: Mon, 26 Jan 2015 12:10:35 -0800
Message-ID: <54c69f3b.bh3ZC45GBMX8ib8C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbAZUKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 15:10:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: update_memcg_params: explicitly check that old array != NULL
has been added to the -mm tree.  Its filename is
     slab-embed-memcg_cache_params-to-kmem_cache-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-embed-memcg_cache_params-to-kmem_cache-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-embed-memcg_cache_params-to-kmem_cache-fix.patch

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
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch

