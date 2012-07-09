From: akpm@linux-foundation.org
Subject: [merged] slab-move-full-state-transition-to-an-initcall.patch removed from -mm tree
Date: Mon, 09 Jul 2012 12:49:42 -0700
Message-ID: <20120709194943.AB824100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:53350 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab2GITtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 15:49:45 -0400
Received: by yhl10 with SMTP id 10so647362yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 12:49:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, penberg@cs.helsinki.fi, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: move FULL state transition to an initcall
has been removed from the -mm tree.  Its filename was
     slab-move-full-state-transition-to-an-initcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: slab: move FULL state transition to an initcall

During kmem_cache_init_late(), we transition to the LATE state, and after
some more work, to the FULL state, its last state

This is quite different from slub, that will only transition to its last
state (SYSFS), in a (late)initcall, after a lot more of the kernel is
ready.

This means that in slab, we have no way to taking actions dependent on the
initialization of other pieces of the kernel that are supposed to start
way after kmem_init_late(), such as cgroups initialization.

To achieve more consistency in this behavior, that patch only transitions
to the LATE state in kmem_init_late.  In my analysis, setup_cpu_cache()
should be happy to test for >= LATE, instead of == FULL.  It also has
passed some tests I've made.

We then only mark FULL state after the reap timers are in place, meaning
that no further setup is expected.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~slab-move-full-state-transition-to-an-initcall mm/slab.c
--- a/mm/slab.c~slab-move-full-state-transition-to-an-initcall
+++ a/mm/slab.c
@@ -1668,9 +1668,6 @@ void __init kmem_cache_init_late(void)
 			BUG();
 	mutex_unlock(&cache_chain_mutex);
 
-	/* Done! */
-	g_cpucache_up = FULL;
-
 	/*
 	 * Register a cpu startup notifier callback that initializes
 	 * cpu_cache_get for all new cpus
@@ -1700,6 +1697,9 @@ static int __init cpucache_init(void)
 	 */
 	for_each_online_cpu(cpu)
 		start_cpu_timer(cpu);
+
+	/* Done! */
+	g_cpucache_up = FULL;
 	return 0;
 }
 __initcall(cpucache_init);
@@ -2167,7 +2167,7 @@ static size_t calculate_slab_order(struc
 
 static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
-	if (g_cpucache_up == FULL)
+	if (g_cpucache_up >= LATE)
 		return enable_cpucache(cachep, gfp);
 
 	if (g_cpucache_up == NONE) {
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
memcg-fix-bad-behavior-in-use_hierarchy-file.patch

