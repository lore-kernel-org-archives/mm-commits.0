From: akpm@linux-foundation.org
Subject: [merged] memcg-increment-static-branch-right-after-limit-set.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:35 -0800
Message-ID: <20130225205335.AFC9C5A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:54971 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759757Ab3BYUxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:36 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so159200yen.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: increment static branch right after limit set
has been removed from the -mm tree.  Its filename was
     memcg-increment-static-branch-right-after-limit-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: increment static branch right after limit set

We were deferring the kmemcg static branch increment to a later time, due
to a nasty dependency between the cpu_hotplug lock, taken by the jump
label update, and the cgroup_lock.

Now we no longer take the cgroup lock, and we can save ourselves the
trouble.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff -puN mm/memcontrol.c~memcg-increment-static-branch-right-after-limit-set mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-increment-static-branch-right-after-limit-set
+++ a/mm/memcontrol.c
@@ -4974,8 +4974,6 @@ static int memcg_update_kmem_limit(struc
 {
 	int ret = -EINVAL;
 #ifdef CONFIG_MEMCG_KMEM
-	bool must_inc_static_branch = false;
-
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	/*
 	 * For simplicity, we won't allow this to be disabled.  It also can't
@@ -5004,7 +5002,13 @@ static int memcg_update_kmem_limit(struc
 			res_counter_set_limit(&memcg->kmem, RESOURCE_MAX);
 			goto out;
 		}
-		must_inc_static_branch = true;
+		static_key_slow_inc(&memcg_kmem_enabled_key);
+		/*
+		 * setting the active bit after the inc will guarantee no one
+		 * starts accounting before all call sites are patched
+		 */
+		memcg_kmem_set_active(memcg);
+
 		/*
 		 * kmem charges can outlive the cgroup. In the case of slab
 		 * pages, for instance, a page contain objects from various
@@ -5017,27 +5021,6 @@ static int memcg_update_kmem_limit(struc
 out:
 	mutex_unlock(&set_limit_mutex);
 	mutex_unlock(&memcg_create_mutex);
-
-	/*
-	 * We are by now familiar with the fact that we can't inc the static
-	 * branch inside cgroup_lock. See disarm functions for details. A
-	 * worker here is overkill, but also wrong: After the limit is set, we
-	 * must start accounting right away. Since this operation can't fail,
-	 * we can safely defer it to here - no rollback will be needed.
-	 *
-	 * The boolean used to control this is also safe, because
-	 * KMEM_ACCOUNTED_ACTIVATED guarantees that only one process will be
-	 * able to set it to true;
-	 */
-	if (must_inc_static_branch) {
-		static_key_slow_inc(&memcg_kmem_enabled_key);
-		/*
-		 * setting the active bit after the inc will guarantee no one
-		 * starts accounting before all call sites are patched
-		 */
-		memcg_kmem_set_active(memcg);
-	}
