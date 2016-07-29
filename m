From: akpm@linux-foundation.org
Subject: [merged] mm-fix-memcg-stack-accounting-for-sub-page-stacks.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:56:39 -0700
Message-ID: <579ba6e7.UFsPrkU1y/zoWZtC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcG2S4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, hannes@cmpxchg.org, jpoimboe@redhat.com, mhocko@kernel.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix memcg stack accounting for sub-page stacks
has been removed from the -mm tree.  Its filename was
     mm-fix-memcg-stack-accounting-for-sub-page-stacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: mm: fix memcg stack accounting for sub-page stacks

We should account for stacks regardless of stack size, and we need to
account in sub-page units if THREAD_SIZE < PAGE_SIZE.  Change the units to
kilobytes and Move it into account_kernel_stack().

Fixes: 12580e4b54ba8 ("mm: memcontrol: report kernel stack usage in cgroup2 memory.stat")
Link: http://lkml.kernel.org/r/9b5314e3ee5eda61b0317ec1563768602c1ef438.1468523549.git.luto@kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 kernel/fork.c              |   19 ++++++++-----------
 mm/memcontrol.c            |    2 +-
 3 files changed, 10 insertions(+), 13 deletions(-)

diff -puN include/linux/memcontrol.h~mm-fix-memcg-stack-accounting-for-sub-page-stacks include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-fix-memcg-stack-accounting-for-sub-page-stacks
+++ a/include/linux/memcontrol.h
@@ -52,7 +52,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
 	/* default hierarchy stats */
-	MEMCG_KERNEL_STACK = MEM_CGROUP_STAT_NSTATS,
+	MEMCG_KERNEL_STACK_KB = MEM_CGROUP_STAT_NSTATS,
 	MEMCG_SLAB_RECLAIMABLE,
 	MEMCG_SLAB_UNRECLAIMABLE,
 	MEMCG_SOCK,
diff -puN kernel/fork.c~mm-fix-memcg-stack-accounting-for-sub-page-stacks kernel/fork.c
--- a/kernel/fork.c~mm-fix-memcg-stack-accounting-for-sub-page-stacks
+++ a/kernel/fork.c
@@ -165,20 +165,12 @@ static unsigned long *alloc_thread_stack
 	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
 					     THREAD_SIZE_ORDER);
 
-	if (page)
-		memcg_kmem_update_page_stat(page, MEMCG_KERNEL_STACK,
-					    1 << THREAD_SIZE_ORDER);
-
 	return page ? page_address(page) : NULL;
 }
 
 static inline void free_thread_stack(unsigned long *stack)
 {
-	struct page *page = virt_to_page(stack);
-
-	memcg_kmem_update_page_stat(page, MEMCG_KERNEL_STACK,
-				    -(1 << THREAD_SIZE_ORDER));
-	__free_pages(page, THREAD_SIZE_ORDER);
+	__free_pages(virt_to_page(stack), THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_stack_cache;
@@ -223,10 +215,15 @@ static struct kmem_cache *mm_cachep;
 
 static void account_kernel_stack(unsigned long *stack, int account)
 {
-	struct zone *zone = page_zone(virt_to_page(stack));
+	/* All stack pages are in the same zone and belong to the same memcg. */
+	struct page *first_page = virt_to_page(stack);
 
-	mod_zone_page_state(zone, NR_KERNEL_STACK_KB,
+	mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
 			    THREAD_SIZE / 1024 * account);
+
+	memcg_kmem_update_page_stat(
+		first_page, MEMCG_KERNEL_STACK_KB,
+		account * (THREAD_SIZE / 1024));
 }
 
 void free_task(struct task_struct *tsk)
diff -puN mm/memcontrol.c~mm-fix-memcg-stack-accounting-for-sub-page-stacks mm/memcontrol.c
--- a/mm/memcontrol.c~mm-fix-memcg-stack-accounting-for-sub-page-stacks
+++ a/mm/memcontrol.c
@@ -5171,7 +5171,7 @@ static int memory_stat_show(struct seq_f
 	seq_printf(m, "file %llu\n",
 		   (u64)stat[MEM_CGROUP_STAT_CACHE] * PAGE_SIZE);
 	seq_printf(m, "kernel_stack %llu\n",
-		   (u64)stat[MEMCG_KERNEL_STACK] * PAGE_SIZE);
+		   (u64)stat[MEMCG_KERNEL_STACK_KB] * 1024);
 	seq_printf(m, "slab %llu\n",
 		   (u64)(stat[MEMCG_SLAB_RECLAIMABLE] +
 			 stat[MEMCG_SLAB_UNRECLAIMABLE]) * PAGE_SIZE);
_

Patches currently in -mm which might be from luto@kernel.org are

signal-consolidate-tstlf_restore_sigmask-code.patch

