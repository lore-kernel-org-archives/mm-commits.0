From: akpm@linux-foundation.org
Subject: + mm-memcontrol-per-lruvec-stats-infrastructure-fix-2.patch added to -mm tree
Date: Mon, 05 Jun 2017 14:32:06 -0700
Message-ID: <5935cdd6.9YG1wtZmKvd9z5VN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50700 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdFEVcH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 17:32:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, linux@roeck-us.net, mhocko@suse.com, riel@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: per-lruvec stats infrastructure fix 2
has been added to the -mm tree.  Its filename is
     mm-memcontrol-per-lruvec-stats-infrastructure-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-per-lruvec-stats-infrastructure-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-per-lruvec-stats-infrastructure-fix-2.patch

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
Subject: mm: memcontrol: per-lruvec stats infrastructure fix 2

Even with the previous fix routing !page->mem_cgroup stats to the root
cgroup, we still see crashes in certain configurations as the root is not
initialized for the earliest possible accounting sites in certain
configurations.

Don't track uncharged pages at all, not even in the root.  This takes care
of early accounting as well as special pages that aren't tracked.

Because we still need to account at the pgdat level, we can no longer
implement the lruvec_page_state functions on top of the lruvec_state ones.
But that's okay.  It was a little silly to look up the nodeinfo and
descend to the lruvec, only to container_of() back to the nodeinfo where
the lruvec_stat structure is sitting.

Link: http://lkml.kernel.org/r/20170605175254.GA8547@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-per-lruvec-stats-infrastructure-fix-2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-per-lruvec-stats-infrastructure-fix-2
+++ a/include/linux/memcontrol.h
@@ -596,27 +596,27 @@ static inline void mod_lruvec_state(stru
 static inline void __mod_lruvec_page_state(struct page *page,
 					   enum node_stat_item idx, int val)
 {
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
+	struct mem_cgroup_per_node *pn;
 
-	/* Special pages in the VM aren't charged, use root */
-	memcg = page->mem_cgroup ? : root_mem_cgroup;
-
-	lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
-	__mod_lruvec_state(lruvec, idx, val);
+	__mod_node_page_state(page_pgdat(page), idx, val);
+	if (mem_cgroup_disabled() || !page->mem_cgroup)
+		return;
+	__mod_memcg_state(page->mem_cgroup, idx, val);
+	pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
+	__this_cpu_add(pn->lruvec_stat->count[idx], val);
 }
 
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-
-	/* Special pages in the VM aren't charged, use root */
-	memcg = page->mem_cgroup ? : root_mem_cgroup;
+	struct mem_cgroup_per_node *pn;
 
-	lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);
-	mod_lruvec_state(lruvec, idx, val);
+	mod_node_page_state(page_pgdat(page), idx, val);
+	if (mem_cgroup_disabled() || !page->mem_cgroup)
+		return;
+	mod_memcg_state(page->mem_cgroup, idx, val);
+	pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
+	this_cpu_add(pn->lruvec_stat->count[idx], val);
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
mm-memcontrol-use-the-node-native-slab-memory-counters.patch
mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
mm-memcontrol-per-lruvec-stats-infrastructure.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix.patch
mm-memcontrol-per-lruvec-stats-infrastructure-fix-2.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch

