From: akpm@linux-foundation.org
Subject: + memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch added to -mm tree
Date: Wed, 14 Nov 2012 16:59:20 -0800
Message-ID: <20121115005920.84ADD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:61647 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab2KOA7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 19:59:21 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so122266yen.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 16:59:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: memcg: add comments clarifying aspects of cache attribute propagation
has been added to the -mm tree.  Its filename is
     memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch

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
Subject: memcg: add comments clarifying aspects of cache attribute propagation

This patch clarifies two aspects of cache attribute propagation.

First, the expected context for the for_each_memcg_cache macro in
memcontrol.h.  The usages already in the codebase are safe.  In mm/slub.c,
it is trivially safe because the lock is acquired right before the loop. 
In mm/slab.c, it is less so: the lock is acquired by an outer function a
few steps back in the stack, so a VM_BUG_ON() is added to make sure it is
indeed safe.

A comment is also added to detail why we are returning the value of the
parent cache and ignoring the children's when we propagate the attributes.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++++
 mm/slab.c                  |    1 +
 mm/slub.c                  |   21 +++++++++++++++++----
 3 files changed, 24 insertions(+), 4 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation
+++ a/include/linux/memcontrol.h
@@ -415,6 +415,12 @@ static inline void sock_release_memcg(st
 extern struct static_key memcg_kmem_enabled_key;
 
 extern int memcg_limited_groups_array_size;
+
+/*
+ * Helper macro to loop through all memcg-specific caches. Callers must still
+ * check if the cache is valid (it is either valid or NULL).
+ * the slab_mutex must be held when looping through those caches
+ */
 #define for_each_memcg_cache_index(_idx)	\
 	for ((_idx) = 0; i < memcg_limited_groups_array_size; (_idx)++)
 
diff -puN mm/slab.c~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation mm/slab.c
--- a/mm/slab.c~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation
+++ a/mm/slab.c
@@ -4154,6 +4154,7 @@ static int do_tune_cpucache(struct kmem_
 	if ((ret < 0) || !is_root_cache(cachep))
 		return ret;
 
+	VM_BUG_ON(!mutex_is_locked(&slab_mutex));
 	for_each_memcg_cache_index(i) {
 		c = cache_from_memcg(cachep, i);
 		if (c)
diff -puN mm/slub.c~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation mm/slub.c
--- a/mm/slub.c~memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation
+++ a/mm/slub.c
@@ -5191,12 +5191,25 @@ static ssize_t slab_attr_store(struct ko
 		if (s->max_attr_size < len)
 			s->max_attr_size = len;
 
+		/*
+		 * This is a best effort propagation, so this function's return
+		 * value will be determined by the parent cache only. This is
+		 * basically because not all attributes will have a well
+		 * defined semantics for rollbacks - most of the actions will
+		 * have permanent effects.
+		 *
+		 * Returning the error value of any of the children that fail
+		 * is not 100 % defined, in the sense that users seeing the
+		 * error code won't be able to know anything about the state of
+		 * the cache.
+		 *
+		 * Only returning the error code for the parent cache at least
+		 * has well defined semantics. The cache being written to
+		 * directly either failed or succeeded, in which case we loop
+		 * through the descendants with best-effort propagation.
+		 */
 		for_each_memcg_cache_index(i) {
 			struct kmem_cache *c = cache_from_memcg(s, i);
-			/*
-			 * This function's return value is determined by the
-			 * parent cache only
-			 */
 			if (c)
 				attribute->store(c, buf, len);
 		}
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

