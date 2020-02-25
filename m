From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch added to -mm tree
Date: Mon, 24 Feb 2020 16:48:01 -0800
Message-ID: <20200225004801.VjcPXbTqY%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBYAsC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 19:48:02 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: kmem: cleanup memcg_kmem_uncharge_memcg() arguments
has been added to the -mm tree.  Its filename is
     mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: cleanup memcg_kmem_uncharge_memcg() arguments

Drop the unused page argument and put the memcg pointer at the first
place.  This make the function consistent with its peers:
__memcg_kmem_uncharge_memcg(), memcg_kmem_charge_memcg(), etc.

Link: http://lkml.kernel.org/r/20200109202659.752357-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/slab.h                  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments
+++ a/include/linux/memcontrol.h
@@ -1416,8 +1416,8 @@ static inline int memcg_kmem_charge_memc
 	return 0;
 }
 
-static inline void memcg_kmem_uncharge_memcg(struct page *page, int order,
-					     struct mem_cgroup *memcg)
+static inline void memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
+					     int order)
 {
 	if (memcg_kmem_enabled())
 		__memcg_kmem_uncharge_memcg(memcg, 1 << order);
--- a/mm/slab.h~mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments
+++ a/mm/slab.h
@@ -395,7 +395,7 @@ static __always_inline void memcg_unchar
 	if (likely(!mem_cgroup_is_root(memcg))) {
 		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
 		mod_lruvec_state(lruvec, cache_vmstat_idx(s), -(1 << order));
-		memcg_kmem_uncharge_memcg(page, order, memcg);
+		memcg_kmem_uncharge_memcg(memcg, order);
 	} else {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 				    -(1 << order));
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
