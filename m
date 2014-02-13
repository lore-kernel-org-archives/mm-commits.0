From: akpm@linux-foundation.org
Subject: +
 memcg-reparent-charges-of-children-before-processing-parent.patch added to
 -mm tree
Date: Thu, 13 Feb 2014 14:58:00 -0800
Message-ID: <52fd4df8.+MayerF3bu9cjhPh%akpm__12647.8155413226$1392332295$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBMW6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 17:58:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org, mhocko@suse.cz, hughd@google.com, hannes@cmpxchg.org, filbranden@google.com

Subject: + memcg-reparent-charges-of-children-before-processing-parent.patch added to -mm tree
To: filbranden@google.com,hannes@cmpxchg.org,hughd@google.com,mhocko@suse.cz,stable@vger.kernel.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 14:58:00 -0800


The patch titled
     Subject: memcg: reparent charges of children before processing parent
has been added to the -mm tree.  Its filename is
     memcg-reparent-charges-of-children-before-processing-parent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-reparent-charges-of-children-before-processing-parent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-reparent-charges-of-children-before-processing-parent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-reparent-charges-of-children-before-processing-parent.patch
linux-next.patch

