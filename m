From: akpm@linux-foundation.org
Subject: [merged]
 memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:53:13 -0700
Message-ID: <534461b9.0cTsWSsejSIpCqL4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbaDHUxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:53:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz

Subject: [merged] memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch removed from -mm tree
To: mhocko@suse.cz,hannes@cmpxchg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:53:13 -0700


The patch titled
     Subject: memcg: do not replicate get_mem_cgroup_from_mm in __mem_cgroup_try_charge
has been removed from the -mm tree.  Its filename was
     memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: do not replicate get_mem_cgroup_from_mm in __mem_cgroup_try_charge

__mem_cgroup_try_charge duplicates get_mem_cgroup_from_mm for charges
which came without a memcg.  The only reason seems to be a tiny
optimization when css_tryget is not called if the charge can be consumed
from the stock.  Nevertheless css_tryget is very cheap since it has been
reworked to use per-cpu counting so this optimization doesn't give us
anything these days.

So let's drop the code duplication so that the code is more readable.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   50 +++++-----------------------------------------
 1 file changed, 6 insertions(+), 44 deletions(-)

diff -puN mm/memcontrol.c~memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge
+++ a/mm/memcontrol.c
@@ -2697,52 +2697,14 @@ static int __mem_cgroup_try_charge(struc
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
-		if (mem_cgroup_is_root(memcg))
-			goto done;
-		if (consume_stock(memcg, nr_pages))
-			goto done;
 		css_get(&memcg->css);
 	} else {
-		struct task_struct *p;
-
-		rcu_read_lock();
-		p = rcu_dereference(mm->owner);
-		/*
-		 * Because we don't have task_lock(), "p" can exit.
-		 * In that case, "memcg" can point to root or p can be NULL with
-		 * race with swapoff. Then, we have small risk of mis-accouning.
-		 * But such kind of mis-account by race always happens because
-		 * we don't have cgroup_mutex(). It's overkill and we allo that
-		 * small race, here.
-		 * (*) swapoff at el will charge against mm-struct not against
-		 * task-struct. So, mm->owner can be NULL.
-		 */
-		memcg = mem_cgroup_from_task(p);
-		if (!memcg)
-			memcg = root_mem_cgroup;
-		if (mem_cgroup_is_root(memcg)) {
-			rcu_read_unlock();
-			goto done;
-		}
-		if (consume_stock(memcg, nr_pages)) {
-			/*
-			 * It seems dagerous to access memcg without css_get().
-			 * But considering how consume_stok works, it's not
-			 * necessary. If consume_stock success, some charges
-			 * from this memcg are cached on this cpu. So, we
-			 * don't need to call css_get()/css_tryget() before
-			 * calling consume_stock().
-			 */
-			rcu_read_unlock();
-			goto done;
-		}
-		/* after here, we may be blocked. we need to get refcnt */
-		if (!css_tryget(&memcg->css)) {
-			rcu_read_unlock();
-			goto again;
-		}
-		rcu_read_unlock();
+		memcg = get_mem_cgroup_from_mm(mm);
 	}
+	if (mem_cgroup_is_root(memcg))
+		goto done;
+	if (consume_stock(memcg, nr_pages))
+		goto done;
 
 	do {
 		bool invoke_oom = oom && !nr_oom_retries;
@@ -2778,8 +2740,8 @@ again:
 
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
-	css_put(&memcg->css);
 done:
+	css_put(&memcg->css);
 	*ptr = memcg;
 	return 0;
 nomem:
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch

