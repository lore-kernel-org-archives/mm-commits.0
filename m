From: akpm@linux-foundation.org
Subject: + mm-memcontrol-per-lruvec-stats-infrastructure-fix-3.patch added to -mm tree
Date: Mon, 05 Jun 2017 14:33:27 -0700
Message-ID: <5935ce27.CnIoO1TyIXHth30D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdFEVd2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 17:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, linux@roeck-us.net, mhocko@suse.com, riel@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: per-lruvec stats infrastructure fix 3
has been added to the -mm tree.  Its filename is
     mm-memcontrol-per-lruvec-stats-infrastructure-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-per-lruvec-stats-infrastructure-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-per-lruvec-stats-infrastructure-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-memcontrol-per-lruvec-stats-infrastructure-fix.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix-2.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix-3.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch

