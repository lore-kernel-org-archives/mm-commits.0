From: akpm@linux-foundation.org
Subject: [merged] memcg-kmem-accounting-lifecycle-management.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:40:34 -0800
Message-ID: <20121219204035.7E23A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:36755 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2LSUkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:40:39 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so133800fae.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:40:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: kmem accounting lifecycle management
has been removed from the -mm tree.  Its filename was
     memcg-kmem-accounting-lifecycle-management.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: kmem accounting lifecycle management

Because kmem charges can outlive the cgroup, we need to make sure that we
won't free the memcg structure while charges are still in flight.  For
reviewing simplicity, the charge functions will issue mem_cgroup_get() at
every charge, and mem_cgroup_put() at every uncharge.

This can get expensive, however, and we can do better.  mem_cgroup_get()
only really needs to be issued once: when the first limit is set.  In the
same spirit, we only need to issue mem_cgroup_put() when the last charge
is gone.

We'll need an extra bit in kmem_account_flags for that:
KMEM_ACCOUNTED_DEAD.  it will be set when the cgroup dies, if there are
charges in the group.  If there aren't, we can proceed right away.

Our uncharge function will have to test that bit every time the charges
drop to 0.  Because that is not the likely output of res_counter_uncharge,
this should not impose a big hit on us: it is certainly much better than a
reference count decrease at every operation.

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

 mm/memcontrol.c |   57 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-kmem-accounting-lifecycle-management mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-kmem-accounting-lifecycle-management
+++ a/mm/memcontrol.c
@@ -346,6 +346,7 @@ struct mem_cgroup {
 /* internal only representation about the status of kmem accounting. */
 enum {
 	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
+	KMEM_ACCOUNTED_DEAD, /* dead memcg with pending kmem charges */
 };
 
 #define KMEM_ACCOUNTED_MASK (1 << KMEM_ACCOUNTED_ACTIVE)
@@ -355,6 +356,23 @@ static inline void memcg_kmem_set_active
 {
 	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
+
+static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+{
+	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
+}
+
+static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
+{
+	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
+		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_account_flags);
+}
+
+static bool memcg_kmem_test_and_clear_dead(struct mem_cgroup *memcg)
+{
+	return test_and_clear_bit(KMEM_ACCOUNTED_DEAD,
+				  &memcg->kmem_account_flags);
+}
 #endif
 
 /* Stuffs for move charges at task migration. */
@@ -2722,10 +2740,16 @@ static int memcg_charge_kmem(struct mem_
 
 static void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size)
 {
-	res_counter_uncharge(&memcg->kmem, size);
 	res_counter_uncharge(&memcg->res, size);
 	if (do_swap_account)
 		res_counter_uncharge(&memcg->memsw, size);
+
+	/* Not down to 0 */
+	if (res_counter_uncharge(&memcg->kmem, size))
+		return;
+
+	if (memcg_kmem_test_and_clear_dead(memcg))
+		mem_cgroup_put(memcg);
 }
 
 /*
@@ -2764,13 +2788,9 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 		return true;
 	}
 
-	mem_cgroup_get(memcg);
-
 	ret = memcg_charge_kmem(memcg, gfp, PAGE_SIZE << order);
 	if (!ret)
 		*_memcg = memcg;
-	else
-		mem_cgroup_put(memcg);
 
 	css_put(&memcg->css);
 	return (ret == 0);
@@ -2786,7 +2806,6 @@ void __memcg_kmem_commit_charge(struct p
 	/* The page allocation failed. Revert */
 	if (!page) {
 		memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
-		mem_cgroup_put(memcg);
 		return;
 	}
 
@@ -2827,7 +2846,6 @@ void __memcg_kmem_uncharge_pages(struct 
 
 	VM_BUG_ON(mem_cgroup_is_root(memcg));
 	memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
-	mem_cgroup_put(memcg);
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
@@ -4217,6 +4235,13 @@ static int memcg_update_kmem_limit(struc
 		VM_BUG_ON(ret);
 
 		memcg_kmem_set_active(memcg);
+		/*
+		 * kmem charges can outlive the cgroup. In the case of slab
+		 * pages, for instance, a page contain objects from various
+		 * processes, so it is unfeasible to migrate them away. We
+		 * need to reference count the memcg because of that.
+		 */
+		mem_cgroup_get(memcg);
 	} else
 		ret = res_counter_set_limit(&memcg->kmem, val);
 out:
@@ -4232,6 +4257,10 @@ static void memcg_propagate_kmem(struct 
 	if (!parent)
 		return;
 	memcg->kmem_account_flags = parent->kmem_account_flags;
+#ifdef CONFIG_MEMCG_KMEM
+	if (memcg_kmem_is_active(memcg))
+		mem_cgroup_get(memcg);
+#endif
 }
 
 /*
@@ -4920,6 +4949,20 @@ static int memcg_init_kmem(struct mem_cg
 static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
 {
 	mem_cgroup_sockets_destroy(memcg);
+
+	memcg_kmem_mark_dead(memcg);
+
+	if (res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0)
+		return;
+
+	/*
+	 * Charges already down to 0, undo mem_cgroup_get() done in the charge
+	 * path here, being careful not to race with memcg_uncharge_kmem: it is
+	 * possible that the charges went down to 0 between mark_dead and the
+	 * res_counter read, so in that case, we don't need the put
+	 */
+	if (memcg_kmem_test_and_clear_dead(memcg))
+		mem_cgroup_put(memcg);
 }
 #else
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

