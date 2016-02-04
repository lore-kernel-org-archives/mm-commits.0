From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch added
 to -mm tree
Date: Thu, 04 Feb 2016 15:07:49 -0800
Message-ID: <56b3d9c5.+mXZOi1EqX6RPC25%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbcBDXHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:07:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: report kernel stack usage in cgroup2 memory.stat
has been added to the -mm tree.  Its filename is
     mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: report kernel stack usage in cgroup2 memory.stat

Show how much memory is allocated to kernel stacks.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |    4 ++++
 include/linux/memcontrol.h  |    1 +
 kernel/fork.c               |   10 +++++++++-
 mm/memcontrol.c             |    2 ++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff -puN Documentation/cgroup-v2.txt~mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat
+++ a/Documentation/cgroup-v2.txt
@@ -843,6 +843,10 @@ PAGE_SIZE multiple when read back.
 		Amount of memory used to cache filesystem data,
 		including tmpfs and shared memory.
 
+	  kernel_stack
+
+		Amount of memory allocated to kernel stacks.
+
 	  slab
 
 		Amount of memory used for storing in-kernel data
diff -puN include/linux/memcontrol.h~mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat
+++ a/include/linux/memcontrol.h
@@ -55,6 +55,7 @@ enum mem_cgroup_stat_index {
 	MEMCG_SOCK = MEM_CGROUP_STAT_NSTATS,
 	MEMCG_SLAB_RECLAIMABLE,
 	MEMCG_SLAB_UNRECLAIMABLE,
+	MEMCG_KERNEL_STACK,
 	MEMCG_NR_STAT,
 };
 
diff -puN kernel/fork.c~mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat kernel/fork.c
--- a/kernel/fork.c~mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat
+++ a/kernel/fork.c
@@ -164,12 +164,20 @@ static struct thread_info *alloc_thread_
 	struct page *page = alloc_kmem_pages_node(node, THREADINFO_GFP,
 						  THREAD_SIZE_ORDER);
 
+	if (page)
+		memcg_kmem_update_page_stat(page, MEMCG_KERNEL_STACK,
+					    1 << THREAD_SIZE_ORDER);
+
 	return page ? page_address(page) : NULL;
 }
 
 static inline void free_thread_info(struct thread_info *ti)
 {
-	free_kmem_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+	struct page *page = virt_to_page(ti);
+
+	memcg_kmem_update_page_stat(page, MEMCG_KERNEL_STACK,
+				    -(1 << THREAD_SIZE_ORDER));
+	__free_kmem_pages(page, THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_info_cache;
diff -puN mm/memcontrol.c~mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat
+++ a/mm/memcontrol.c
@@ -5100,6 +5100,8 @@ static int memory_stat_show(struct seq_f
 		   (u64)stat[MEM_CGROUP_STAT_RSS] * PAGE_SIZE);
 	seq_printf(m, "file %llu\n",
 		   (u64)stat[MEM_CGROUP_STAT_CACHE] * PAGE_SIZE);
+	seq_printf(m, "kernel_stack %llu\n",
+		   (u64)stat[MEMCG_KERNEL_STACK] * PAGE_SIZE);
 	seq_printf(m, "slab %llu\n",
 		   (u64)(stat[MEMCG_SLAB_RECLAIMABLE] +
 			 stat[MEMCG_SLAB_UNRECLAIMABLE]) * PAGE_SIZE);
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch

