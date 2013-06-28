From: akpm@linux-foundation.org
Subject: + memcg-use-css_get-put-for-swap-memcg.patch added to -mm tree
Date: Fri, 28 Jun 2013 16:00:31 -0700
Message-ID: <51ce158f.Lpf5i24IKoYjoLhL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab3F1XAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 19:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, glommer@openvz.org, lizefan@huawei.com

Subject: + memcg-use-css_get-put-for-swap-memcg.patch added to -mm tree
To: lizefan@huawei.com,glommer@openvz.org,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 16:00:31 -0700


The patch titled
     Subject: memcg: use css_get/put for swap memcg
has been added to the -mm tree.  Its filename is
     memcg-use-css_get-put-for-swap-memcg.patch

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
@@ -6710,6 +6713,7 @@ static void __mem_cgroup_clear_mc(void)
 {
 	struct mem_cgroup *from = mc.from;
 	struct mem_cgroup *to = mc.to;
+	int i;
 
 	/* we must uncharge all the leftover precharges from mc.to */
 	if (mc.precharge) {
@@ -6730,7 +6734,9 @@ static void __mem_cgroup_clear_mc(void)
 		if (!mem_cgroup_is_root(mc.from))
 			res_counter_uncharge(&mc.from->memsw,
 						PAGE_SIZE * mc.moved_swap);
-		__mem_cgroup_put(mc.from, mc.moved_swap);
+
+		for (i = 0; i < mc.moved_swap; i++)
+			css_put(&mc.from->css);
 
 		if (!mem_cgroup_is_root(mc.to)) {
 			/*
@@ -6740,7 +6746,7 @@ static void __mem_cgroup_clear_mc(void)
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

