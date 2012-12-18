From: akpm@linux-foundation.org
Subject: [folded-dropped] memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:14:43 -0800
Message-ID: <20121218221444.09BB782004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:63431 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab2LRWOq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:14:46 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so145131vba.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:14:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: move include of workqueue.h to top of slab.h file
has been removed from the -mm tree.  Its filename was
     memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch

This patch was dropped because it was folded into memcg-destroy-memcg-caches.patch

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: move include of workqueue.h to top of slab.h file

Suggested by akpm. I originally decided to put it closer to the use of
the work struct, but let's move it to top.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/slab.h~memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file include/linux/slab.h
--- a/include/linux/slab.h~memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file
+++ a/include/linux/slab.h
@@ -11,6 +11,8 @@
 
 #include <linux/gfp.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
+
 
 /*
  * Flags to pass to kmem_cache_create().
@@ -179,8 +181,6 @@ void kmem_cache_free(struct kmem_cache *
 #ifndef ARCH_SLAB_MINALIGN
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
-
-#include <linux/workqueue.h>
 /*
  * This is the main placeholder for memcg-related information in kmem caches.
  * struct kmem_cache will hold a pointer to it, so the memory cost while
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
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
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
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

