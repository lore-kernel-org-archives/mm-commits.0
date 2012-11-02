From: akpm@linux-foundation.org
Subject: + mm-add-a-__gfp_kmemcg-flag.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:03:14 -0700
Message-ID: <20121102000314.A0457100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63248 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292Ab2KBADQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:03:16 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so366461vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:03:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: mm: add a __GFP_KMEMCG flag
has been added to the -mm tree.  Its filename is
     mm-add-a-__gfp_kmemcg-flag.patch

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
Subject: mm: add a __GFP_KMEMCG flag

This flag is used to indicate to the callees that this allocation is a
kernel allocation in process context, and should be accounted to current's
memcg.  It takes numerical place of the of the recently removed
__GFP_NO_KSWAPD.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: JoonSoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h             |    3 ++-
 include/trace/events/gfpflags.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-add-a-__gfp_kmemcg-flag include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-a-__gfp_kmemcg-flag
+++ a/include/linux/gfp.h
@@ -31,6 +31,7 @@ struct vm_area_struct;
 #define ___GFP_THISNODE		0x40000u
 #define ___GFP_RECLAIMABLE	0x80000u
 #define ___GFP_NOTRACK		0x200000u
+#define ___GFP_KMEMCG		0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
 #define ___GFP_WRITE		0x1000000u
 
@@ -87,7 +88,7 @@ struct vm_area_struct;
 
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
-
+#define __GFP_KMEMCG	((__force gfp_t)___GFP_KMEMCG) /* Allocation comes from a memcg-accounted resource */
 /*
  * This may seem redundant, but it's a way of annotating false positives vs.
  * allocations that simply cannot be supported (e.g. page tables).
diff -puN include/trace/events/gfpflags.h~mm-add-a-__gfp_kmemcg-flag include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~mm-add-a-__gfp_kmemcg-flag
+++ a/include/trace/events/gfpflags.h
@@ -36,6 +36,7 @@
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
 	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
+	{(unsigned long)__GFP_KMEMCG,		"GFP_KMEMCG"},		\
 	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
 	) : "GFP_NOWAIT"
 
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
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
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

