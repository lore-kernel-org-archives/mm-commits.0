From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-per-lruvec-stats-infrastructure-fix-3.patch removed from -mm
 tree
Date: Thu, 06 Jul 2017 15:23:25 -0700
Message-ID: <595eb85d.wYS2xGgMWf8UXDT/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33322 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdGFWXb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:23:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, linux@roeck-us.net, mhocko@suse.com, riel@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: per-lruvec stats infrastructure fix 3
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-per-lruvec-stats-infrastructure-fix-3.patch

This patch was dropped because it was folded into mm-memcontrol-per-lruvec-stats-infrastructure.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: per-lruvec stats infrastructure fix 3

As pointed out by Vladimir, there is a missing free_percpu() for the
lruvec_stat object in the memcg's per node info.  Add this.

Link: http://lkml.kernel.org/r/20170605175354.GB8547@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-per-lruvec-stats-infrastructure-fix-3 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-per-lruvec-stats-infrastructure-fix-3
+++ a/mm/memcontrol.c
@@ -4139,7 +4139,10 @@ static int alloc_mem_cgroup_per_node_inf
 
 static void free_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
-	kfree(memcg->nodeinfo[node]);
+	struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
+
+	free_percpu(pn->lruvec_stat);
+	kfree(pn);
 }
 
 static void __mem_cgroup_free(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
mm-memcontrol-use-the-node-native-slab-memory-counters.patch
mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
mm-memcontrol-per-lruvec-stats-infrastructure.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch

