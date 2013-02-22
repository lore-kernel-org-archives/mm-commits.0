From: akpm@linux-foundation.org
Subject: + slub-correctly-bootstrap-boot-caches.patch added to -mm tree
Date: Fri, 22 Feb 2013 13:16:31 -0800
Message-ID: <20130222211631.B430431C194@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:58829 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab3BVVQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 16:16:33 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so107554vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 13:16:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, StMichalke@web.de, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, tj@kernel.org


The patch titled
     Subject: slub: correctly bootstrap boot caches
has been added to the -mm tree.  Its filename is
     slub-correctly-bootstrap-boot-caches.patch

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
Subject: slub: correctly bootstrap boot caches

After we create a boot cache, we may allocate from it until it is
bootstraped.  This will move the page from the partial list to the cpu
slab list.  If this happens, the loop:

	list_for_each_entry(p, &n->partial, lru)

that we use to scan for all partial pages will yield nothing, and the
pages will keep pointing to the boot cpu cache, which is of course,
invalid.  To do that, we should flush the cache to make sure that the cpu
slab is back to the partial list.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Reported-by: Steffen Michalke <StMichalke@web.de>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/slub.c~slub-correctly-bootstrap-boot-caches mm/slub.c
--- a/mm/slub.c~slub-correctly-bootstrap-boot-caches
+++ a/mm/slub.c
@@ -3552,6 +3552,12 @@ static struct kmem_cache * __init bootst
 
 	memcpy(s, static_cache, kmem_cache->object_size);
 
+	/*
+	 * This runs very early, and only the boot processor is supposed to be
+	 * up.  Even if it weren't true, IRQs are not up so we couldn't fire
+	 * IPIs around.
+	 */
+	__flush_cpu_slab(s, smp_processor_id());
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 		struct page *p;
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-fast-hierarchy-aware-child-test-fix-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-stop-warning-on-memcg_propagate_kmem.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

