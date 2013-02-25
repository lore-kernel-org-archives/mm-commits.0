From: akpm@linux-foundation.org
Subject: [merged] memcg-move-memcg_stock-initialization-to-mem_cgroup_init.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:06 -0800
Message-ID: <20130225205506.AFFE45A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:40761 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab3BYUzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:08 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so347484ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move memcg_stock initialization to mem_cgroup_init
has been removed from the -mm tree.  Its filename was
     memcg-move-memcg_stock-initialization-to-mem_cgroup_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: move memcg_stock initialization to mem_cgroup_init

memcg_stock are currently initialized during the root cgroup allocation
which is OK but it pointlessly pollutes memcg allocation code with
something that can be called when the memcg subsystem is initialized by
mem_cgroup_init along with other controller specific parts.

This patch wraps the current memcg_stock initialization code into a helper
calls it from the controller subsystem initialization code.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-move-memcg_stock-initialization-to-mem_cgroup_init mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-memcg_stock-initialization-to-mem_cgroup_init
+++ a/mm/memcontrol.c
@@ -2296,6 +2296,17 @@ static void drain_local_stock(struct wor
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 }
 
+static void __init memcg_stock_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct memcg_stock_pcp *stock =
+					&per_cpu(memcg_stock, cpu);
+		INIT_WORK(&stock->work, drain_local_stock);
+	}
+}
+
 /*
  * Cache charges(val) which is from res_counter, to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
@@ -6092,15 +6103,7 @@ mem_cgroup_css_alloc(struct cgroup *cont
 
 	/* root ? */
 	if (cont->parent == NULL) {
-		int cpu;
-
 		root_mem_cgroup = memcg;
-		for_each_possible_cpu(cpu) {
-			struct memcg_stock_pcp *stock =
-						&per_cpu(memcg_stock, cpu);
-			INIT_WORK(&stock->work, drain_local_stock);
-		}
