From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-fix-build-error-around-the-usage-of-kmem_caches.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:37:17 -0700
Message-ID: <20200403203717.3OCTcHu4C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUhS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org, vdavydov.dev@gmail.com


The patch titled
     Subject: mm, memcg: fix build error around the usage of kmem_caches
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-build-error-around-the-usage-of-kmem_caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, memcg: fix build error around the usage of kmem_caches

When I manually set default n to MEMCG_KMEM in init/Kconfig, bellow error
occurs,

mm/slab_common.c: In function 'memcg_slab_start':
mm/slab_common.c:1530:30: error: 'struct mem_cgroup' has no member named
'kmem_caches'
  return seq_list_start(&memcg->kmem_caches, *pos);
                              ^
mm/slab_common.c: In function 'memcg_slab_next':
mm/slab_common.c:1537:32: error: 'struct mem_cgroup' has no member named
'kmem_caches'
  return seq_list_next(p, &memcg->kmem_caches, pos);
                                ^
mm/slab_common.c: In function 'memcg_slab_show':
mm/slab_common.c:1551:16: error: 'struct mem_cgroup' has no member named
'kmem_caches'
  if (p == memcg->kmem_caches.next)
                ^
  CC      arch/x86/xen/smp.o
mm/slab_common.c: In function 'memcg_slab_start':
mm/slab_common.c:1531:1: warning: control reaches end of non-void function
[-Wreturn-type]
 }
 ^
mm/slab_common.c: In function 'memcg_slab_next':
mm/slab_common.c:1538:1: warning: control reaches end of non-void function
[-Wreturn-type]
 }
 ^

That's because kmem_caches is defined only when CONFIG_MEMCG_KMEM is set,
while memcg_slab_start() will use it no matter CONFIG_MEMCG_KMEM is defined
or not.

By the way, the reason I mannuly undefined CONFIG_MEMCG_KMEM is to verify
whether my some other code change is still stable when CONFIG_MEMCG_KMEM is
not set. Unfortunately, the existing code has been already unstable since
v4.11.

Link: http://lkml.kernel.org/r/1580970260-2045-1-git-send-email-laoar.shao@gmail.com
Fixes: bc2791f857e1 ("slab: link memcg kmem_caches on their associated memory cgroup")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |    3 ++-
 mm/slab_common.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-build-error-around-the-usage-of-kmem_caches
+++ a/mm/memcontrol.c
@@ -4792,7 +4792,8 @@ static struct cftype mem_cgroup_legacy_f
 		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
-#if defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG)
+#if defined(CONFIG_MEMCG_KMEM) && \
+	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))
 	{
 		.name = "kmem.slabinfo",
 		.seq_start = memcg_slab_start,
--- a/mm/slab_common.c~mm-memcg-fix-build-error-around-the-usage-of-kmem_caches
+++ a/mm/slab_common.c
@@ -1521,7 +1521,7 @@ void dump_unreclaimable_slab(void)
 	mutex_unlock(&slab_mutex);
 }
 
-#if defined(CONFIG_MEMCG)
+#if defined(CONFIG_MEMCG_KMEM)
 void *memcg_slab_start(struct seq_file *m, loff_t *pos)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
_

Patches currently in -mm which might be from laoar.shao@gmail.com are
