From: akpm@linux-foundation.org
Subject: [merged]
 memcg-reparent-charges-of-children-before-processing-parent.patch removed
 from -mm tree
Date: Thu, 06 Mar 2014 12:37:32 -0800
Message-ID: <5318dc8c.jJ9YT6fThFCfYfn7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaCFUhd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org, mhocko@suse.cz, hughd@google.com, hannes@cmpxchg.org, burian@muenster.de, filbranden@google.com

Subject: [merged] memcg-reparent-charges-of-children-before-processing-parent.patch removed from -mm tree
To: filbranden@google.com,burian@muenster.de,hannes@cmpxchg.org,hughd@google.com,mhocko@suse.cz,stable@vger.kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:32 -0800


The patch titled
     Subject: memcg: reparent charges of children before processing parent
has been removed from the -mm tree.  Its filename was
     memcg-reparent-charges-of-children-before-processing-parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Filipe Brandenburger <filbranden@google.com>
Subject: memcg: reparent charges of children before processing parent

Sometimes the cleanup after memcg hierarchy testing gets stuck in
mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.

There may turn out to be several causes, but a major cause is this: the
workitem to offline parent can get run before workitem to offline child;
parent's mem_cgroup_reparent_charges() circles around waiting for the
child's pages to be reparented to its lrus, but it's holding cgroup_mutex
which prevents the child from reaching its mem_cgroup_reparent_charges().

Further testing showed that an ordered workqueue for cgroup_destroy_wq is
not always good enough: percpu_ref_kill_and_confirm's call_rcu_sched stage
on the way can mess up the order before reaching the workqueue.

Instead, when offlining a memcg, call mem_cgroup_reparent_charges() on all
its children (and grandchildren, in the correct order) to have their
charges reparented first.

Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
Signed-off-by: Filipe Brandenburger <filbranden@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[v3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-reparent-charges-of-children-before-processing-parent mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reparent-charges-of-children-before-processing-parent
+++ a/mm/memcontrol.c
@@ -6595,6 +6595,7 @@ static void mem_cgroup_css_offline(struc
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup_event *event, *tmp;
+	struct cgroup_subsys_state *iter;
 
 	/*
 	 * Unregister events and notify userspace.
@@ -6611,7 +6612,14 @@ static void mem_cgroup_css_offline(struc
 	kmem_cgroup_css_offline(memcg);
 
 	mem_cgroup_invalidate_reclaim_iterators(memcg);
-	mem_cgroup_reparent_charges(memcg);
+
+	/*
+	 * This requires that offlining is serialized.  Right now that is
+	 * guaranteed because css_killed_work_fn() holds the cgroup_mutex.
+	 */
+	css_for_each_descendant_post(iter, css)
+		mem_cgroup_reparent_charges(mem_cgroup_from_css(iter));
+
 	mem_cgroup_destroy_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
 }
_

Patches currently in -mm which might be from filbranden@google.com are

origin.patch

