From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:02 -0700
Message-ID: <56f03f8a.5yLVG3pdsGQ8QYso%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbcCUT4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: report kernel stack usage in cgroup2 memory.stat
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 include/linux/memcontrol.h  |    3 ++-
 kernel/fork.c               |   10 +++++++++-
 mm/memcontrol.c             |    2 ++
 4 files changed, 17 insertions(+), 2 deletions(-)

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
@@ -52,9 +52,10 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
 	/* default hierarchy stats */
-	MEMCG_SOCK = MEM_CGROUP_STAT_NSTATS,
+	MEMCG_KERNEL_STACK = MEM_CGROUP_STAT_NSTATS,
 	MEMCG_SLAB_RECLAIMABLE,
 	MEMCG_SLAB_UNRECLAIMABLE,
+	MEMCG_SOCK,
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
@@ -5106,6 +5106,8 @@ static int memory_stat_show(struct seq_f
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

mm-oom_reaper-implement-oom-victims-queuing-fix.patch

