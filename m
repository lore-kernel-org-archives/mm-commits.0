From: akpm@linux-foundation.org
Subject: [merged] memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:40:44 -0800
Message-ID: <20121219204045.8FB62200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:51834 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2LSUku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:40:50 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so140078lbo.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:40:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: allow a memcg with kmem charges to be destructed
has been removed from the -mm tree.  Its filename was
     memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: allow a memcg with kmem charges to be destructed

Because the ultimate goal of the kmem tracking in memcg is to track slab
pages as well, we can't guarantee that we'll always be able to point a
page to a particular process, and migrate the charges along with it -
since in the common case, a page will contain data belonging to multiple
processes.

Because of that, when we destroy a memcg, we only make sure the
destruction will succeed by discounting the kmem charges from the user
charges when we try to empty the cgroup.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-allow-a-memcg-with-kmem-charges-to-be-destructed mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-allow-a-memcg-with-kmem-charges-to-be-destructed
+++ a/mm/memcontrol.c
@@ -547,6 +547,11 @@ static void disarm_kmem_keys(struct mem_
 {
 	if (memcg_kmem_is_active(memcg))
 		static_key_slow_dec(&memcg_kmem_enabled_key);
+	/*
+	 * This check can't live in kmem destruction function,
+	 * since the charges will outlive the cgroup
+	 */
+	WARN_ON(res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0);
 }
 #else
 static void disarm_kmem_keys(struct mem_cgroup *memcg)
@@ -4025,6 +4030,7 @@ static void mem_cgroup_force_empty_list(
 static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 {
 	int node, zid;
+	u64 usage;
 
 	do {
 		/* This is for making all *used* pages to be on LRU. */
@@ -4045,13 +4051,20 @@ static void mem_cgroup_reparent_charges(
 		cond_resched();
 
 		/*
+		 * Kernel memory may not necessarily be trackable to a specific
+		 * process. So they are not migrated, and therefore we can't
+		 * expect their value to drop to 0 here.
+		 * Having res filled up with kmem only is enough.
+		 *
 		 * This is a safety check because mem_cgroup_force_empty_list
 		 * could have raced with mem_cgroup_replace_page_cache callers
 		 * so the lru seemed empty but the page could have been added
 		 * right after the check. RES_USAGE should be safe as we always
 		 * charge before adding to the LRU.
 		 */
-	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0);
+		usage = res_counter_read_u64(&memcg->res, RES_USAGE) -
+			res_counter_read_u64(&memcg->kmem, RES_USAGE);
+	} while (usage > 0);
 }
 
 /*
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

