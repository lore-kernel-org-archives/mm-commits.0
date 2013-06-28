From: akpm@linux-foundation.org
Subject: + memcg-use-css_get-put-when-charging-uncharging-kmem.patch added to -mm tree
Date: Fri, 28 Jun 2013 16:00:29 -0700
Message-ID: <51ce158d.eEpQwtTXspNSshp9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3F1XAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 19:00:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@openvz.org, lizefan@huawei.com

Subject: + memcg-use-css_get-put-when-charging-uncharging-kmem.patch added to -mm tree
To: lizefan@huawei.com,glommer@openvz.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 16:00:29 -0700


The patch titled
     Subject: memcg: use css_get/put when charging/uncharging kmem
has been added to the -mm tree.  Its filename is
     memcg-use-css_get-put-when-charging-uncharging-kmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: use css_get/put when charging/uncharging kmem

Use css_get/put instead of mem_cgroup_get/put.

We can't do a simple replacement, because here mem_cgroup_put() is called
during mem_cgroup_css_free(), while mem_cgroup_css_free() won't be called
until css refcnt goes down to 0.

Instead we increment css refcnt in mem_cgroup_css_offline(), and then
check if there's still kmem charges.  If not, css refcnt will be
decremented immediately, otherwise the refcnt will be released after the
last kmem allocation is uncahred.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   70 +++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 25 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-css_get-put-when-charging-uncharging-kmem mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-css_get-put-when-charging-uncharging-kmem
+++ a/mm/memcontrol.c
@@ -406,6 +406,11 @@ static void memcg_kmem_clear_activated(s
 
 static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
 {
+	/*
+	 * We need to call css_get() first, because memcg_uncharge_kmem()
+	 * will call css_put() if it sees the memcg is dead.
+	 */
+	smp_wmb();
 	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
 		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_account_flags);
 }
@@ -3050,8 +3055,16 @@ static void memcg_uncharge_kmem(struct m
 	if (res_counter_uncharge(&memcg->kmem, size))
 		return;
 
+	/*
+	 * Releases a reference taken in kmem_cgroup_css_offline in case
+	 * this last uncharge is racing with the offlining code or it is
+	 * outliving the memcg existence.
+	 *
+	 * The memory barrier imposed by test&clear is paired with the
+	 * explicit one in memcg_kmem_mark_dead().
+	 */
 	if (memcg_kmem_test_and_clear_dead(memcg))
-		mem_cgroup_put(memcg);
+		css_put(&memcg->css);
 }
 
 void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep)
@@ -5183,14 +5196,6 @@ static int memcg_update_kmem_limit(struc
 		 * starts accounting before all call sites are patched
 		 */
 		memcg_kmem_set_active(memcg);
-
-		/*
-		 * kmem charges can outlive the cgroup. In the case of slab
-		 * pages, for instance, a page contain objects from various
-		 * processes, so it is unfeasible to migrate them away. We
-		 * need to reference count the memcg because of that.
-		 */
-		mem_cgroup_get(memcg);
 	} else
 		ret = res_counter_set_limit(&memcg->kmem, val);
 out:
@@ -5223,12 +5228,10 @@ static int memcg_propagate_kmem(struct m
 		goto out;
 
 	/*
-	 * destroy(), called if we fail, will issue static_key_slow_inc() and
-	 * mem_cgroup_put() if kmem is enabled. We have to either call them
-	 * unconditionally, or clear the KMEM_ACTIVE flag. I personally find
-	 * this more consistent, since it always leads to the same destroy path
+	 * __mem_cgroup_free() will issue static_key_slow_dec() because this
+	 * memcg is active already. If the later initialization fails then the
+	 * cgroup core triggers the cleanup so we do not have to do it here.
 	 */
-	mem_cgroup_get(memcg);
 	static_key_slow_inc(&memcg_kmem_enabled_key);
 
 	mutex_lock(&set_limit_mutex);
@@ -5913,23 +5916,38 @@ static int memcg_init_kmem(struct mem_cg
 	return mem_cgroup_sockets_init(memcg, ss);
 }
 
-static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
+static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
 {
-	mem_cgroup_sockets_destroy(memcg);
+	if (!memcg_kmem_is_active(memcg))
+		return;
+
+	/*
+	 * kmem charges can outlive the cgroup. In the case of slab
+	 * pages, for instance, a page contain objects from various
+	 * processes. As we prevent from taking a reference for every
+	 * such allocation we have to be careful when doing uncharge
+	 * (see memcg_uncharge_kmem) and here during offlining.
+	 *
+	 * The idea is that that only the _last_ uncharge which sees
+	 * the dead memcg will drop the last reference. An additional
+	 * reference is taken here before the group is marked dead
+	 * which is then paired with css_put during uncharge resp. here.
+	 *
+	 * Although this might sound strange as this path is called from
+	 * css_offline() when the referencemight have dropped down to 0
+	 * and shouldn't be incremented anymore (css_tryget would fail)
+	 * we do not have other options because of the kmem allocations
+	 * lifetime.
+	 */
+	css_get(&memcg->css);
 
 	memcg_kmem_mark_dead(memcg);
 
 	if (res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0)
 		return;
 
-	/*
-	 * Charges already down to 0, undo mem_cgroup_get() done in the charge
-	 * path here, being careful not to race with memcg_uncharge_kmem: it is
-	 * possible that the charges went down to 0 between mark_dead and the
-	 * res_counter read, so in that case, we don't need the put
-	 */
 	if (memcg_kmem_test_and_clear_dead(memcg))
-		mem_cgroup_put(memcg);
+		css_put(&memcg->css);
 }
 #else
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
@@ -5937,7 +5955,7 @@ static int memcg_init_kmem(struct mem_cg
 	return 0;
 }
 
-static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
+static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
 {
 }
 #endif
@@ -6370,6 +6388,8 @@ static void mem_cgroup_css_offline(struc
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
+	kmem_cgroup_css_offline(memcg);
+
 	mem_cgroup_invalidate_reclaim_iterators(memcg);
 	mem_cgroup_reparent_charges(memcg);
 	mem_cgroup_destroy_all_caches(memcg);
@@ -6379,7 +6399,7 @@ static void mem_cgroup_css_free(struct c
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
-	kmem_cgroup_destroy(memcg);
+	mem_cgroup_sockets_destroy(memcg);
 
 	mem_cgroup_put(memcg);
 }
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
linux-next.patch
memcg-update-todo-list-in-documentation.patch
revert-memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-kmem-fix-reference-count-handling-on-the-error-path.patch
memcg-use-css_get-in-sock_update_memcg.patch
memcg-dont-use-mem_cgroup_get-when-creating-a-kmemcg-cache.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-for-swap-memcg.patch
memcg-dont-need-to-get-a-reference-to-the-parent.patch
memcg-kill-memcg-refcnt.patch
memcg-dont-need-to-free-memcg-via-rcu-or-workqueue.patch

