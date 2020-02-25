From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch
 added to -mm tree
Date: Mon, 24 Feb 2020 18:29:25 -0800
Message-ID: <20200225022925.eSSvn_rZJ%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgBYC31 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 21:29:27 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm-memcg-slab-introduce-mem_cgroup_from_obj-v2
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch

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
Subject: mm-memcg-slab-introduce-mem_cgroup_from_obj-v2

fix build issues

Link: http://lkml.kernel.org/r/20200225022154.GA573375@carbon.DHCP.thefacebook.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 +++++++-------
 mm/memcontrol.c            |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-introduce-mem_cgroup_from_obj-v2
+++ a/include/linux/memcontrol.h
@@ -420,8 +420,6 @@ struct lruvec *mem_cgroup_page_lruvec(st
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
-struct mem_cgroup *mem_cgroup_from_obj(void *p);
-
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 struct mem_cgroup *get_mem_cgroup_from_page(struct page *page);
@@ -914,11 +912,6 @@ static inline bool mm_match_cgroup(struc
 	return true;
 }
 
-static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
-{
-	return NULL;
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	return NULL;
@@ -1434,6 +1427,8 @@ static inline int memcg_cache_id(struct
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
+struct mem_cgroup *mem_cgroup_from_obj(void *p);
+
 #else
 
 static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
@@ -1475,6 +1470,11 @@ static inline void memcg_put_cache_ids(v
 {
 }
 
+static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+       return NULL;
+}
+
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/mm/memcontrol.c~mm-memcg-slab-introduce-mem_cgroup_from_obj-v2
+++ a/mm/memcontrol.c
@@ -2636,6 +2636,7 @@ static void commit_charge(struct page *p
 		unlock_page_lru(page, isolated);
 }
 
+#ifdef CONFIG_MEMCG_KMEM
 /*
  * Returns a pointer to the memory cgroup to which the kernel object is charged.
  *
@@ -2663,7 +2664,6 @@ struct mem_cgroup *mem_cgroup_from_obj(v
 	return page->mem_cgroup;
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
