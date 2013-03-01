From: akpm@linux-foundation.org
Subject: [merged] slub-correctly-bootstrap-boot-caches.patch removed from -mm tree
Date: Fri, 01 Mar 2013 12:47:14 -0800
Message-ID: <20130301204714.C225431C24F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:58792 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3CAUrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 15:47:16 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so378541vch.2
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 12:47:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, StMichalke@web.de, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: correctly bootstrap boot caches
has been removed from the -mm tree.  Its filename was
     slub-correctly-bootstrap-boot-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

