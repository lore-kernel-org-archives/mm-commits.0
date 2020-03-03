From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-fork-fix-kernel=5Fstack-memcg-stats-for-various-stack-i?=
 =?US-ASCII?Q?mplementations.patch?= added to -mm tree
Date: Tue, 03 Mar 2020 15:41:49 -0800
Message-ID: <20200303234149.Wk24li3AP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbgCCXlv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 18:41:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@linux.ibm.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, stable@vger.kernel.org


The patch titled
     Subject: mm: fork: fix kernel_stack memcg stats for various stack implementations
has been added to the -mm tree.  Its filename is
     mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations.patch

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
Subject: mm: fork: fix kernel_stack memcg stats for various stack implementations

Depending on CONFIG_VMAP_STACK and the THREAD_SIZE / PAGE_SIZE ratio the
space for task stacks can be allocated using __vmalloc_node_range(),
alloc_pages_node() and kmem_cache_alloc_node().  In the first and the
second cases page->mem_cgroup pointer is set, but in the third it's not:
memcg membership of a slab page should be determined using the
memcg_from_slab_page() function, which looks at
page->slab_cache->memcg_params.memcg .  In this case, using
mod_memcg_page_state() (as in account_kernel_stack()) is incorrect:
page->mem_cgroup pointer is NULL even for pages charged to a non-root
memory cgroup.

It can lead to kernel_stack per-memcg counters permanently showing 0 on
some architectures (depending on the configuration).

In order to fix it, let's introduce a mod_memcg_obj_state() helper, which
takes a pointer to a kernel object as a first argument, uses
mem_cgroup_from_obj() to get a RCU-protected memcg pointer and calls
mod_memcg_state().  It allows to handle all possible configurations
(CONFIG_VMAP_STACK and various THREAD_SIZE/PAGE_SIZE values) without
spilling any memcg/kmem specifics into fork.c .

Note: this patch has been first posted as a part of the new slab
controller patchset.  This is a slightly updated version: the fixes tag
has been added and the commit log was extended by the advice of Johannes
Weiner.  Because it's a fix that makes sense by itself, I'm re-posting it
as a standalone patch.

Link: http://lkml.kernel.org/r/20200303233550.251375-1-guro@fb.com
Fixes: 4d96ba353075 ("mm: memcg/slab: stop setting page->mem_cgroup pointer for slab pages")
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 kernel/fork.c              |    4 ++--
 mm/memcontrol.c            |   11 +++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations
+++ a/include/linux/memcontrol.h
@@ -695,6 +695,7 @@ static inline unsigned long lruvec_page_
 void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
+void mod_memcg_obj_state(void *p, int idx, int val);
 
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
@@ -1123,6 +1124,10 @@ static inline void __mod_lruvec_slab_sta
 	__mod_node_page_state(page_pgdat(page), idx, val);
 }
 
+static inline void mod_memcg_obj_state(void *p, int idx, int val)
+{
+}
+
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
--- a/kernel/fork.c~mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations
+++ a/kernel/fork.c
@@ -397,8 +397,8 @@ static void account_kernel_stack(struct
 		mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
 				    THREAD_SIZE / 1024 * account);
 
-		mod_memcg_page_state(first_page, MEMCG_KERNEL_STACK_KB,
-				     account * (THREAD_SIZE / 1024));
+		mod_memcg_obj_state(stack, MEMCG_KERNEL_STACK_KB,
+				    account * (THREAD_SIZE / 1024));
 	}
 }
 
--- a/mm/memcontrol.c~mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations
+++ a/mm/memcontrol.c
@@ -777,6 +777,17 @@ void __mod_lruvec_slab_state(void *p, en
 	rcu_read_unlock();
 }
 
+void mod_memcg_obj_state(void *p, int idx, int val)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_obj(p);
+	if (memcg)
+		mod_memcg_state(memcg, idx, val);
+	rcu_read_unlock();
+}
+
 /**
  * __count_memcg_events - account VM events in a cgroup
  * @memcg: the memory cgroup
_

Patches currently in -mm which might be from guro@fb.com are

mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
