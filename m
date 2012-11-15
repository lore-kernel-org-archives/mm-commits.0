From: akpm@linux-foundation.org
Subject: + memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch added to -mm tree
Date: Wed, 14 Nov 2012 16:58:45 -0800
Message-ID: <20121115005846.1E79D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:33938 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946032Ab2KOA6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 19:58:47 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so121781yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 16:58:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: memcg: replace __always_inline with plain inline
has been added to the -mm tree.  Its filename is
     memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: replace __always_inline with plain inline

Following the pattern found in the allocators, where we do our best to the
fast paths function-call free, all the externally visible functions for
kmemcg were marked __always_inline.

It is fair to say, however, that this should be up to the compiler.  We
will still keep as much of the flag testing as we can in memcontrol.h to
give the compiler the option to inline it, but won't force it.

I tested this with 4.7.2, it will inline all three functions anyway when
compiling with -O2, and will refrain from it when compiling with -Os. 
This seems like a good behavior.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline
+++ a/include/linux/memcontrol.h
@@ -444,7 +444,7 @@ void __memcg_kmem_uncharge_pages(struct 
  * We return true automatically if this allocation is not to be accounted to
  * any memcg.
  */
-static __always_inline bool
+static inline bool
 memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
 {
 	if (!memcg_kmem_enabled())
@@ -476,7 +476,7 @@ memcg_kmem_newpage_charge(gfp_t gfp, str
  *
  * there is no need to specify memcg here, since it is embedded in page_cgroup
  */
-static __always_inline void
+static inline void
 memcg_kmem_uncharge_pages(struct page *page, int order)
 {
 	if (memcg_kmem_enabled())
@@ -494,7 +494,7 @@ memcg_kmem_uncharge_pages(struct page *p
  * charges. Otherwise, it will commit the memcg given by @memcg to the
  * corresponding page_cgroup.
  */
-static __always_inline void
+static inline void
 memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg, int order)
 {
 	if (memcg_kmem_enabled() && memcg)
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears-simplify-ida-initialization.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch

