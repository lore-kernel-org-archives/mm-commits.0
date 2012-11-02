From: akpm@linux-foundation.org
Subject: + memcg-use-static-branches-when-code-not-in-use.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:03:40 -0700
Message-ID: <20121102000341.0C39E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41242 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292Ab2KBADo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:03:44 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so194521eek.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:03:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: memcg: use static branches when code not in use
has been added to the -mm tree.  Its filename is
     memcg-use-static-branches-when-code-not-in-use.patch

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
Subject: memcg: use static branches when code not in use

We can use static branches to patch the code in or out when not used.

Because the _ACTIVE bit on kmem_accounted is only set after the increment
is done, we guarantee that the root memcg will always be selected for kmem
charges until all call sites are patched (see memcg_kmem_enabled).  This
guarantees that no mischarges are applied.

Static branch decrement happens when the last reference count from the
kmem accounting in memcg dies.  This will only happen when the charges
drop down to 0.

When that happens, we need to disable the static branch only on those
memcgs that enabled it.  To achieve this, we would be forced to complicate
the code by keeping track of which memcgs were the ones that actually
enabled limits, and which ones got it from its parents.

It is a lot simpler just to do static_key_slow_inc() on every child
that is accounted.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 +
 mm/memcontrol.c            |   79 +++++++++++++++++++++++++++++++++--
 2 files changed, 78 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-use-static-branches-when-code-not-in-use include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-use-static-branches-when-code-not-in-use
+++ a/include/linux/memcontrol.h
@@ -22,6 +22,7 @@
 #include <linux/cgroup.h>
 #include <linux/vm_event_item.h>
 #include <linux/hardirq.h>
+#include <linux/jump_label.h>
 
 struct mem_cgroup;
 struct page_cgroup;
@@ -410,9 +411,10 @@ static inline void sock_release_memcg(st
 #endif /* CONFIG_INET && CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_MEMCG_KMEM
+extern struct static_key memcg_kmem_enabled_key;
 static inline bool memcg_kmem_enabled(void)
 {
-	return true;
+	return static_key_false(&memcg_kmem_enabled_key);
 }
 
 /*
diff -puN mm/memcontrol.c~memcg-use-static-branches-when-code-not-in-use mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-static-branches-when-code-not-in-use
+++ a/mm/memcontrol.c
@@ -344,10 +344,13 @@ struct mem_cgroup {
 /* internal only representation about the status of kmem accounting. */
 enum {
 	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
+	KMEM_ACCOUNTED_ACTIVATED, /* static key enabled. */
 	KMEM_ACCOUNTED_DEAD, /* dead memcg with pending kmem charges */
 };
 
-#define KMEM_ACCOUNTED_MASK (1 << KMEM_ACCOUNTED_ACTIVE)
+/* We account when limit is on, but only after call sites are patched */
+#define KMEM_ACCOUNTED_MASK \
+		((1 << KMEM_ACCOUNTED_ACTIVE) | (1 << KMEM_ACCOUNTED_ACTIVATED))
 
 #ifdef CONFIG_MEMCG_KMEM
 static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
@@ -360,6 +363,11 @@ static bool memcg_kmem_is_active(struct 
 	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
 
+static void memcg_kmem_set_activated(struct mem_cgroup *memcg)
+{
+	set_bit(KMEM_ACCOUNTED_ACTIVATED, &memcg->kmem_account_flags);
+}
+
 static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
 {
 	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
@@ -530,6 +538,26 @@ static void disarm_sock_keys(struct mem_
 }
 #endif
 
+#ifdef CONFIG_MEMCG_KMEM
+struct static_key memcg_kmem_enabled_key;
+
+static void disarm_kmem_keys(struct mem_cgroup *memcg)
+{
+	if (memcg_kmem_is_active(memcg))
+		static_key_slow_dec(&memcg_kmem_enabled_key);
+}
+#else
+static void disarm_kmem_keys(struct mem_cgroup *memcg)
+{
+}
+#endif /* CONFIG_MEMCG_KMEM */
+
+static void disarm_static_keys(struct mem_cgroup *memcg)
+{
+	disarm_sock_keys(memcg);
+	disarm_kmem_keys(memcg);
+}
+
 static void drain_all_stock_async(struct mem_cgroup *memcg);
 
 static struct mem_cgroup_per_zone *
@@ -4195,6 +4223,8 @@ static int memcg_update_kmem_limit(struc
 {
 	int ret = -EINVAL;
 #ifdef CONFIG_MEMCG_KMEM
+	bool must_inc_static_branch = false;
+
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	/*
 	 * For simplicity, we won't allow this to be disabled.  It also can't
@@ -4225,7 +4255,15 @@ static int memcg_update_kmem_limit(struc
 		ret = res_counter_set_limit(&memcg->kmem, val);
 		VM_BUG_ON(ret);
 
-		memcg_kmem_set_active(memcg);
+		/*
+		 * After this point, kmem_accounted (that we test atomically in
+		 * the beginning of this conditional), is no longer 0. This
+		 * guarantees only one process will set the following boolean
+		 * to true. We don't need test_and_set because we're protected
+		 * by the set_limit_mutex anyway.
+		 */
+		memcg_kmem_set_activated(memcg);
+		must_inc_static_branch = true;
 		/*
 		 * kmem charges can outlive the cgroup. In the case of slab
 		 * pages, for instance, a page contain objects from various
@@ -4238,6 +4276,27 @@ static int memcg_update_kmem_limit(struc
 out:
 	mutex_unlock(&set_limit_mutex);
 	cgroup_unlock();
+
+	/*
+	 * We are by now familiar with the fact that we can't inc the static
+	 * branch inside cgroup_lock. See disarm functions for details. A
+	 * worker here is overkill, but also wrong: After the limit is set, we
+	 * must start accounting right away. Since this operation can't fail,
+	 * we can safely defer it to here - no rollback will be needed.
+	 *
+	 * The boolean used to control this is also safe, because
+	 * KMEM_ACCOUNTED_ACTIVATED guarantees that only one process will be
+	 * able to set it to true;
+	 */
+	if (must_inc_static_branch) {
+		static_key_slow_inc(&memcg_kmem_enabled_key);
+		/*
+		 * setting the active bit after the inc will guarantee no one
+		 * starts accounting before all call sites are patched
+		 */
+		memcg_kmem_set_active(memcg);
+	}
+
 #endif
 	return ret;
 }
@@ -4249,8 +4308,20 @@ static void memcg_propagate_kmem(struct 
 		return;
 	memcg->kmem_account_flags = parent->kmem_account_flags;
 #ifdef CONFIG_MEMCG_KMEM
-	if (memcg_kmem_is_active(memcg))
+	/*
+	 * When that happen, we need to disable the static branch only on those
+	 * memcgs that enabled it. To achieve this, we would be forced to
+	 * complicate the code by keeping track of which memcgs were the ones
+	 * that actually enabled limits, and which ones got it from its
+	 * parents.
+	 *
+	 * It is a lot simpler just to do static_key_slow_inc() on every child
+	 * that is accounted.
+	 */
+	if (memcg_kmem_is_active(memcg)) {
 		mem_cgroup_get(memcg);
+		static_key_slow_inc(&memcg_kmem_enabled_key);
+	}
 #endif
 }
 
@@ -5175,7 +5246,7 @@ static void free_work(struct work_struct
 	 * to move this code around, and make sure it is outside
 	 * the cgroup_lock.
 	 */
-	disarm_sock_keys(memcg);
+	disarm_static_keys(memcg);
 	if (size < PAGE_SIZE)
 		kfree(memcg);
 	else
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

