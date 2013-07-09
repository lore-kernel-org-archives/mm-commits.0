From: akpm@linux-foundation.org
Subject: [merged] memcg-use-css_get-put-for-swap-memcg.patch removed from
 -mm tree
Date: Tue, 09 Jul 2013 16:20:43 -0700
Message-ID: <51dc9acb.Bepg319Bz3NOA1o7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3GIXUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, glommer@openvz.org, lizefan@huawei.com

Subject: [merged] memcg-use-css_get-put-for-swap-memcg.patch removed from -mm tree
To: lizefan@huawei.com,glommer@openvz.org,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:43 -0700


The patch titled
     Subject: memcg: use css_get/put for swap memcg
has been removed from the -mm tree.  Its filename was
     memcg-use-css_get-put-for-swap-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: use css_get/put for swap memcg

Use css_get/put instead of mem_cgroup_get/put. A simple replacement
will do.

The historical reason that memcg has its own refcnt instead of always
using css_get/put, is that cgroup couldn't be removed if there're still
css refs, so css refs can't be used as long-lived reference.  The
situation has changed so that rmdir a cgroup will succeed regardless css
refs, but won't be freed until css refs goes down to 0.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-css_get-put-for-swap-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-css_get-put-for-swap-memcg
+++ a/mm/memcontrol.c
@@ -4231,12 +4231,12 @@ __mem_cgroup_uncharge_common(struct page
 	unlock_page_cgroup(pc);
 	/*
 	 * even after unlock, we have memcg->res.usage here and this memcg
-	 * will never be freed.
+	 * will never be freed, so it's safe to call css_get().
 	 */
 	memcg_check_events(memcg, page);
 	if (do_swap_account && ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT) {
 		mem_cgroup_swap_statistics(memcg, true);
-		mem_cgroup_get(memcg);
+		css_get(&memcg->css);
 	}
 	/*
 	 * Migration does not charge the res_counter for the
@@ -4348,7 +4348,7 @@ mem_cgroup_uncharge_swapcache(struct pag
 
 	/*
 	 * record memcg information,  if swapout && memcg != NULL,
-	 * mem_cgroup_get() was called in uncharge().
+	 * css_get() was called in uncharge().
 	 */
 	if (do_swap_account && swapout && memcg)
 		swap_cgroup_record(ent, css_id(&memcg->css));
@@ -4379,7 +4379,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 		if (!mem_cgroup_is_root(memcg))
 			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 		mem_cgroup_swap_statistics(memcg, false);
-		mem_cgroup_put(memcg);
+		css_put(&memcg->css);
 	}
 	rcu_read_unlock();
 }
@@ -4413,11 +4413,14 @@ static int mem_cgroup_move_swap_account(
 		 * This function is only called from task migration context now.
 		 * It postpones res_counter and refcount handling till the end
 		 * of task migration(mem_cgroup_clear_mc()) for performance
-		 * improvement. But we cannot postpone mem_cgroup_get(to)
-		 * because if the process that has been moved to @to does
-		 * swap-in, the refcount of @to might be decreased to 0.
+		 * improvement. But we cannot postpone css_get(to)  because if
+		 * the process that has been moved to @to does swap-in, the
+		 * refcount of @to might be decreased to 0.
+		 *
+		 * We are in attach() phase, so the cgroup is guaranteed to be
+		 * alive, so we can just call css_get().
 		 */
-		mem_cgroup_get(to);
+		css_get(&to->css);
 		return 0;
 	}
 	return -EINVAL;
@@ -6718,6 +6721,7 @@ static void __mem_cgroup_clear_mc(void)
 {
 	struct mem_cgroup *from = mc.from;
 	struct mem_cgroup *to = mc.to;
+	int i;
 
 	/* we must uncharge all the leftover precharges from mc.to */
 	if (mc.precharge) {
@@ -6738,7 +6742,9 @@ static void __mem_cgroup_clear_mc(void)
 		if (!mem_cgroup_is_root(mc.from))
 			res_counter_uncharge(&mc.from->memsw,
 						PAGE_SIZE * mc.moved_swap);
-		__mem_cgroup_put(mc.from, mc.moved_swap);
+
+		for (i = 0; i < mc.moved_swap; i++)
+			css_put(&mc.from->css);
 
 		if (!mem_cgroup_is_root(mc.to)) {
 			/*
@@ -6748,7 +6754,7 @@ static void __mem_cgroup_clear_mc(void)
 			res_counter_uncharge(&mc.to->res,
 						PAGE_SIZE * mc.moved_swap);
 		}
-		/* we've already done mem_cgroup_get(mc.to) */
+		/* we've already done css_get(mc.to) */
 		mc.moved_swap = 0;
 	}
 	memcg_oom_recover(from);
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
linux-next.patch

