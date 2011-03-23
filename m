From: akpm@linux-foundation.org
Subject: [merged] mm-numa-aware-alloc_task_struct_node.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:40 -0700
Message-ID: <201103232037.p2NKbGUQ028224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933394Ab1CWU5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, ak@linux.intel.com, davem@davemloft.net, dhowells@redhat.com, fenghua.yu@intel.com, linux-arch@vger.kernel.org, rusty@rustcorp.com.au, tj@kernel.org, tony.luck


The patch titled
     mm: NUMA aware alloc_task_struct_node()
has been removed from the -mm tree.  Its filename was
     mm-numa-aware-alloc_task_struct_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: NUMA aware alloc_task_struct_node()
From: Eric Dumazet <eric.dumazet@gmail.com>

All kthreads being created from a single helper task, they all use memory
from a single node for their kernel stack and task struct.

This patch suite creates kthread_create_on_cpu(), adding a 'cpu' parameter
to parameters already used by kthread_create().

This parameter serves in allocating memory for the new kthread on its
memory node if available.

Users of this new function are : ksoftirqd, kworker, migration, pktgend...


This patch:

Add a node parameter to alloc_task_struct(), and change its name to
alloc_task_struct_node()

This change is needed to allow NUMA aware kthread_create_on_cpu()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/processor.h        |    2 +-
 arch/frv/kernel/process.c               |    5 +++--
 arch/ia64/include/asm/thread_info.h     |    9 ++++++++-
 arch/um/include/asm/processor-generic.h |    2 +-
 kernel/fork.c                           |   10 ++++++----
 5 files changed, 19 insertions(+), 9 deletions(-)

diff -puN arch/frv/include/asm/processor.h~mm-numa-aware-alloc_task_struct_node arch/frv/include/asm/processor.h
--- a/arch/frv/include/asm/processor.h~mm-numa-aware-alloc_task_struct_node
+++ a/arch/frv/include/asm/processor.h
@@ -137,7 +137,7 @@ unsigned long get_wchan(struct task_stru
 #define	KSTK_ESP(tsk)	((tsk)->thread.frame0->sp)
 
 /* Allocation and freeing of basic task resources. */
-extern struct task_struct *alloc_task_struct(void);
+extern struct task_struct *alloc_task_struct_node(int node);
 extern void free_task_struct(struct task_struct *p);
 
 #define cpu_relax()    barrier()
diff -puN arch/frv/kernel/process.c~mm-numa-aware-alloc_task_struct_node arch/frv/kernel/process.c
--- a/arch/frv/kernel/process.c~mm-numa-aware-alloc_task_struct_node
+++ a/arch/frv/kernel/process.c
@@ -44,9 +44,10 @@ asmlinkage void ret_from_fork(void);
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-struct task_struct *alloc_task_struct(void)
+struct task_struct *alloc_task_struct_node(int node)
 {
-	struct task_struct *p = kmalloc(THREAD_SIZE, GFP_KERNEL);
+	struct task_struct *p = kmalloc_node(THREAD_SIZE, GFP_KERNEL, node);
+
 	if (p)
 		atomic_set((atomic_t *)(p+1), 1);
 	return p;
diff -puN arch/ia64/include/asm/thread_info.h~mm-numa-aware-alloc_task_struct_node arch/ia64/include/asm/thread_info.h
--- a/arch/ia64/include/asm/thread_info.h~mm-numa-aware-alloc_task_struct_node
+++ a/arch/ia64/include/asm/thread_info.h
@@ -84,7 +84,14 @@ struct thread_info {
 #define end_of_stack(p) (unsigned long *)((void *)(p) + IA64_RBS_OFFSET)
 
 #define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-#define alloc_task_struct()	((struct task_struct *)__get_free_pages(GFP_KERNEL | __GFP_COMP, KERNEL_STACK_SIZE_ORDER))
+#define alloc_task_struct_node(node)						\
+({										\
+	struct page *page = alloc_pages_node(node, GFP_KERNEL | __GFP_COMP,	\
+					     KERNEL_STACK_SIZE_ORDER);		\
+	struct task_struct *ret = page ? page_address(page) : NULL;		\
+										\
+	ret;
+})
 #define free_task_struct(tsk)	free_pages((unsigned long) (tsk), KERNEL_STACK_SIZE_ORDER)
 
 #endif /* !__ASSEMBLY */
diff -puN arch/um/include/asm/processor-generic.h~mm-numa-aware-alloc_task_struct_node arch/um/include/asm/processor-generic.h
--- a/arch/um/include/asm/processor-generic.h~mm-numa-aware-alloc_task_struct_node
+++ a/arch/um/include/asm/processor-generic.h
@@ -66,7 +66,7 @@ struct thread_struct {
 	.request		= { 0 } \
 }
 
-extern struct task_struct *alloc_task_struct(void);
+extern struct task_struct *alloc_task_struct_node(int node);
 
 static inline void release_thread(struct task_struct *task)
 {
diff -puN kernel/fork.c~mm-numa-aware-alloc_task_struct_node kernel/fork.c
--- a/kernel/fork.c~mm-numa-aware-alloc_task_struct_node
+++ a/kernel/fork.c
@@ -109,8 +109,10 @@ int nr_processes(void)
 }
 
 #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-# define alloc_task_struct()	kmem_cache_alloc(task_struct_cachep, GFP_KERNEL)
-# define free_task_struct(tsk)	kmem_cache_free(task_struct_cachep, (tsk))
+# define alloc_task_struct_node(node)		\
+		kmem_cache_alloc_node(task_struct_cachep, GFP_KERNEL, node)
+# define free_task_struct(tsk)			\
+		kmem_cache_free(task_struct_cachep, (tsk))
 static struct kmem_cache *task_struct_cachep;
 #endif
 
@@ -249,12 +251,12 @@ static struct task_struct *dup_task_stru
 	struct task_struct *tsk;
 	struct thread_info *ti;
 	unsigned long *stackend;
