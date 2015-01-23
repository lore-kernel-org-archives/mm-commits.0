From: akpm@linux-foundation.org
Subject: + cgroup-release-css-id-after-css_free.patch added to -mm tree
Date: Fri, 23 Jan 2015 12:45:26 -0800
Message-ID: <54c2b2e6.jqnrWZQOr2t8J3Ho%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbAWUp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jan 2015 15:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: release css->id after css_free
has been added to the -mm tree.  Its filename is
     cgroup-release-css-id-after-css_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cgroup-release-css-id-after-css_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cgroup-release-css-id-after-css_free.patch

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
Subject: cgroup: release css->id after css_free

Currently, we release css->id in css_release_work_fn, right before calling
css_free callback, so that when css_free is called, the id may have
already been reused for a new cgroup.

I am going to use css->id to create unique names for per memcg kmem
caches.  Since kmem caches are destroyed only on css_free, I need css->id
to be freed after css_free was called to avoid name clashes.  This patch
therefore moves css->id removal to css_free_work_fn.  To prevent
css_from_id from returning a pointer to a stale css, it makes
css_release_work_fn replace the css ptr at css_idr:css->id with NULL.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/cgroup.c~cgroup-release-css-id-after-css_free kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-release-css-id-after-css_free
+++ a/kernel/cgroup.c
@@ -4373,16 +4373,20 @@ static void css_free_work_fn(struct work
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, destroy_work);
+	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
 
 	percpu_ref_exit(&css->refcnt);
 
-	if (css->ss) {
+	if (ss) {
 		/* css free path */
+		int id = css->id;
+
 		if (css->parent)
 			css_put(css->parent);
 
-		css->ss->css_free(css);
+		ss->css_free(css);
+		cgroup_idr_remove(&ss->css_idr, id);
 		cgroup_put(cgrp);
 	} else {
 		/* cgroup free path */
@@ -4434,7 +4438,7 @@ static void css_release_work_fn(struct w
 
 	if (ss) {
 		/* css release path */
-		cgroup_idr_remove(&ss->css_idr, css->id);
+		cgroup_idr_replace(&ss->css_idr, NULL, css->id);
 		if (ss->css_released)
 			ss->css_released(css);
 	} else {
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

