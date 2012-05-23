From: akpm@linux-foundation.org
Subject: + slab-move-full-state-transition-to-an-initcall.patch added to -mm tree
Date: Wed, 23 May 2012 15:50:18 -0700
Message-ID: <20120523225018.AFB84A033B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52237 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2EWWuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 18:50:21 -0400
Received: by wgbdt11 with SMTP id dt11so500251wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 15:50:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, penberg@cs.helsinki.fi, rientjes@google.com


The patch titled
     Subject: slab: move FULL state transition to an initcall
has been added to the -mm tree.  Its filename is
     slab-move-full-state-transition-to-an-initcall.patch

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
@@ -1695,9 +1695,6 @@ void __init kmem_cache_init_late(void)
 			BUG();
 	mutex_unlock(&cache_chain_mutex);
 
-	/* Done! */
-	g_cpucache_up = FULL;
-
 	/*
 	 * Register a cpu startup notifier callback that initializes
 	 * cpu_cache_get for all new cpus
@@ -1727,6 +1724,9 @@ static int __init cpucache_init(void)
 	 */
 	for_each_online_cpu(cpu)
 		start_cpu_timer(cpu);
+
+	/* Done! */
+	g_cpucache_up = FULL;
 	return 0;
 }
 __initcall(cpucache_init);
@@ -2194,7 +2194,7 @@ static size_t calculate_slab_order(struc
 
 static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
-	if (g_cpucache_up == FULL)
+	if (g_cpucache_up >= LATE)
 		return enable_cpucache(cachep, gfp);
 
 	if (g_cpucache_up == NONE) {
_
Subject: Subject: slab: move FULL state transition to an initcall

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
linux-next.patch
slab-move-full-state-transition-to-an-initcall.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
rescounters-add-res_counter_uncharge_until.patch
memcg-use-res_counter_uncharge_until-in-move_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch
memcg-dont-uncharge-in-mem_cgroup_move_account.patch
remove-__must_check-for-res_counter_charge_nofail.patch
memcg-always-free-struct-memcg-through-schedule_work.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time.patch
memcg-decrement-static-keys-at-real-destroy-time-v6.patch
memcg-decrement-static-keys-at-real-destroy-time-v6-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

