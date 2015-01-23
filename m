From: akpm@linux-foundation.org
Subject: + slab-use-css-id-for-naming-per-memcg-caches.patch added to -mm
 tree
Date: Fri, 23 Jan 2015 12:45:28 -0800
Message-ID: <54c2b2e8.bJXYEiBJUosUy/pb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbAWUp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jan 2015 15:45:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: use css id for naming per memcg caches
has been added to the -mm tree.  Its filename is
     slab-use-css-id-for-naming-per-memcg-caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-use-css-id-for-naming-per-memcg-caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-use-css-id-for-naming-per-memcg-caches.patch

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
Subject: slab: use css id for naming per memcg caches

Currently, we use mem_cgroup->kmemcg_id to guarantee kmem_cache->name
uniqueness.  This is correct, because kmemcg_id is only released on css
free after destroying all per memcg caches.

However, I am going to change that and release kmemcg_id on css offline,
because it is not wise to keep it for so long, wasting valuable entries of
memcg_cache_params->memcg_caches arrays.  Therefore, to preserve cache
name uniqueness, let us switch to css->id.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slab_common.c~slab-use-css-id-for-naming-per-memcg-caches mm/slab_common.c
--- a/mm/slab_common.c~slab-use-css-id-for-naming-per-memcg-caches
+++ a/mm/slab_common.c
@@ -487,6 +487,7 @@ void memcg_create_kmem_cache(struct mem_
 			     struct kmem_cache *root_cache)
 {
 	static char memcg_name_buf[NAME_MAX + 1]; /* protected by slab_mutex */
+	struct cgroup_subsys_state *css = mem_cgroup_css(memcg);
 	struct memcg_cache_array *arr;
 	struct kmem_cache *s = NULL;
 	char *cache_name;
@@ -509,10 +510,9 @@ void memcg_create_kmem_cache(struct mem_
 	if (arr->entries[idx])
 		goto out_unlock;
 
-	cgroup_name(mem_cgroup_css(memcg)->cgroup,
-		    memcg_name_buf, sizeof(memcg_name_buf));
+	cgroup_name(css->cgroup, memcg_name_buf, sizeof(memcg_name_buf));
 	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			       idx, memcg_name_buf);
+			       css->id, memcg_name_buf);
 	if (!cache_name)
 		goto out_unlock;
 
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
mm-memcontrol-remove-unnecessary-soft-limit-tree-node-test.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch

