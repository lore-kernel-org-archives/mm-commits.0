From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 15:29:32 -0800
Message-ID: <56a169dc.cHpnP52Rfc6L7H4F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbcAUX3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: separate kmem code from legacy tcp accounting code
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: separate kmem code from legacy tcp accounting code

The cgroup2 memory controller will include important in-kernel memory
consumers per default, including socket memory, but it will no longer
carry the historic tcp control interface.

Separate the kmem state init from the tcp control interface init in
preparation for that.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code
+++ a/mm/memcontrol.c
@@ -2946,17 +2946,6 @@ static int memcg_propagate_kmem(struct m
 	return ret;
 }
 
-static int memcg_init_kmem(struct mem_cgroup *memcg)
-{
-	int ret;
-
-	ret = memcg_propagate_kmem(memcg);
-	if (ret)
-		return ret;
-
-	return tcp_init_cgroup(memcg);
-}
-
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 	struct cgroup_subsys_state *css;
@@ -3009,7 +2998,6 @@ static void memcg_free_kmem(struct mem_c
 		static_branch_dec(&memcg_kmem_enabled_key);
 		WARN_ON(page_counter_read(&memcg->kmem));
 	}
-	tcp_destroy_cgroup(memcg);
 }
 #else
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
@@ -3017,16 +3005,9 @@ static int memcg_update_kmem_limit(struc
 {
 	return -EINVAL;
 }
-static int memcg_init_kmem(struct mem_cgroup *memcg)
-{
-	return 0;
-}
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 }
-static void memcg_free_kmem(struct mem_cgroup *memcg)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 /*
@@ -4263,9 +4244,14 @@ mem_cgroup_css_online(struct cgroup_subs
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-	ret = memcg_init_kmem(memcg);
+#ifdef CONFIG_MEMCG_KMEM
+	ret = memcg_propagate_kmem(memcg);
 	if (ret)
 		return ret;
+	ret = tcp_init_cgroup(memcg);
+	if (ret)
+		return ret;
+#endif
 
 #ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
@@ -4317,11 +4303,16 @@ static void mem_cgroup_css_free(struct c
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	memcg_free_kmem(memcg);
 #ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
 #endif
+
+#ifdef CONFIG_MEMCG_KMEM
+	memcg_free_kmem(memcg);
+	tcp_destroy_cgroup(memcg);
+#endif
+
 	__mem_cgroup_free(memcg);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

