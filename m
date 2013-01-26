From: akpm@linux-foundation.org
Subject: + memcg-increment-static-branch-right-after-limit-set.patch added to -mm tree
Date: Fri, 25 Jan 2013 16:02:23 -0800
Message-ID: <20130126000224.34C175A4273@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:39771 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3AZACZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 19:02:25 -0500
Received: by mail-qa0-f73.google.com with SMTP id dx4so9832qab.2
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 16:02:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org


The patch titled
     Subject: memcg: increment static branch right after limit set
has been added to the -mm tree.  Its filename is
     memcg-increment-static-branch-right-after-limit-set.patch

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
@@ -4972,8 +4972,6 @@ static int memcg_update_kmem_limit(struc
 {
 	int ret = -EINVAL;
 #ifdef CONFIG_MEMCG_KMEM
-	bool must_inc_static_branch = false;
-
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	/*
 	 * For simplicity, we won't allow this to be disabled.  It also can't
@@ -5002,7 +5000,13 @@ static int memcg_update_kmem_limit(struc
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
@@ -5015,27 +5019,6 @@ static int memcg_update_kmem_limit(struc
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
