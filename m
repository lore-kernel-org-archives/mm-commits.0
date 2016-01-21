From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-remove-double-kmem-page_counter-init.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:29:26 -0800
Message-ID: <56a169d6.wsSHrQPHY39HyCl8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbcAUX31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove double kmem page_counter init
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-double-kmem-page_counter-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: remove double kmem page_counter init

The kmem page_counter's limit is initialized to PAGE_COUNTER_MAX inside
mem_cgroup_css_online().  There is no need to repeat this from
memcg_propagate_kmem().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-double-kmem-page_counter-init mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-double-kmem-page_counter-init
+++ a/mm/memcontrol.c
@@ -2861,8 +2861,7 @@ static u64 mem_cgroup_read_u64(struct cg
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static int memcg_activate_kmem(struct mem_cgroup *memcg,
-			       unsigned long nr_pages)
+static int memcg_activate_kmem(struct mem_cgroup *memcg)
 {
 	int err = 0;
 	int memcg_id;
@@ -2897,13 +2896,6 @@ static int memcg_activate_kmem(struct me
 		goto out;
 	}
 
-	/*
-	 * We couldn't have accounted to this cgroup, because it hasn't got
-	 * activated yet, so this should succeed.
-	 */
-	err = page_counter_limit(&memcg->kmem, nr_pages);
-	VM_BUG_ON(err);
-
 	static_branch_inc(&memcg_kmem_enabled_key);
 	/*
 	 * A memory cgroup is considered kmem-active as soon as it gets
@@ -2924,10 +2916,14 @@ static int memcg_update_kmem_limit(struc
 	int ret;
 
 	mutex_lock(&memcg_limit_mutex);
-	if (!memcg_kmem_is_active(memcg))
-		ret = memcg_activate_kmem(memcg, limit);
-	else
-		ret = page_counter_limit(&memcg->kmem, limit);
+	/* Top-level cgroup doesn't propagate from root */
+	if (!memcg_kmem_is_active(memcg)) {
+		ret = memcg_activate_kmem(memcg);
+		if (ret)
+			goto out;
+	}
+	ret = page_counter_limit(&memcg->kmem, limit);
+out:
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
@@ -2946,7 +2942,7 @@ static int memcg_propagate_kmem(struct m
 	 * after this point, because it has at least one child already.
 	 */
 	if (memcg_kmem_is_active(parent))
-		ret = memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
+		ret = memcg_activate_kmem(memcg);
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

