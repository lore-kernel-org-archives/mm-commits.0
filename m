From: akpm@linux-foundation.org
Subject: + mm-mempolicy-remove-duplicate-code.patch added to -mm tree
Date: Wed, 07 Nov 2012 11:36:58 -0800
Message-ID: <20121107193659.06BE6200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:40162 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2KGThB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 14:37:01 -0500
Received: by mail-ea0-f202.google.com with SMTP id q10so132257eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 11:36:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm, mempolicy: remove duplicate code
has been added to the -mm tree.  Its filename is
     mm-mempolicy-remove-duplicate-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempolicy: remove duplicate code

Remove some duplicate code and simplify alloc_pages_vma().  No functional
change.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-remove-duplicate-code mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-remove-duplicate-code
+++ a/mm/mempolicy.c
@@ -1942,7 +1942,6 @@ alloc_pages_vma(gfp_t gfp, int order, st
 		unsigned long addr, int node)
 {
 	struct mempolicy *pol;
-	struct zonelist *zl;
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 
@@ -1961,23 +1960,11 @@ retry_cpuset:
 
 		return page;
 	}
-	zl = policy_zonelist(gfp, pol, node);
-	if (unlikely(mpol_needs_cond_ref(pol))) {
-		/*
-		 * slow path: ref counted shared policy
-		 */
-		struct page *page =  __alloc_pages_nodemask(gfp, order,
-						zl, policy_nodemask(gfp, pol));
-		__mpol_put(pol);
-		if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
-			goto retry_cpuset;
-		return page;
-	}
-	/*
-	 * fast path:  default or task policy
-	 */
-	page = __alloc_pages_nodemask(gfp, order, zl,
+	page = __alloc_pages_nodemask(gfp, order,
+				      policy_zonelist(gfp, pol, node),
 				      policy_nodemask(gfp, pol));
+	if (unlikely(mpol_needs_cond_ref(pol)))
+		__mpol_put(pol);
 	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
 		goto retry_cpuset;
 	return page;
_

Patches currently in -mm which might be from rientjes@google.com are

mm-bugfix-set-current-reclaim_state-to-null-while-returning-from-kswapd.patch
linux-next.patch
mm-fix-build-warning-for-uninitialized-value.patch
irq-tsk-comm-is-an-array.patch
irq-tsk-comm-is-an-array-fix.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-clean-up-__collapse_huge_page_isolate.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch
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
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
mm-mempolicy-remove-duplicate-code.patch

