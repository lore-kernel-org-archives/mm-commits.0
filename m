From: akpm@linux-foundation.org
Subject: [patch 10/14] mm, mempolicy: task->mempolicy must be NULL before
 dropping final reference
Date: Thu, 01 Sep 2016 16:15:07 -0700
Message-ID: <57c8b67b.gQb0Co3uK0couuNe%akpm__45276.4135938652$1472771719$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59879 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbcIAXPI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2016 19:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, stable@vger.kernel.org, vegard.nossum@oracle.com

From: David Rientjes <rientjes@google.com>
Subject: mm, mempolicy: task->mempolicy must be NULL before dropping final reference

KASAN allocates memory from the page allocator as part of
kmem_cache_free(), and that can reference current->mempolicy through any
number of allocation functions.  It needs to be NULL'd out before the
final reference is dropped to prevent a use-after-free bug:

	BUG: KASAN: use-after-free in alloc_pages_current+0x363/0x370 at addr ffff88010b48102c
	CPU: 0 PID: 15425 Comm: trinity-c2 Not tainted 4.8.0-rc2+ #140
	...
	Call Trace:
		dump_stack
		kasan_object_err
		kasan_report_error
		__asan_report_load2_noabort
		alloc_pages_current	<-- use after free
		depot_save_stack
		save_stack
		kasan_slab_free
		kmem_cache_free
		__mpol_put		<-- free
		do_exit

This patch sets current->mempolicy to NULL before dropping the final
reference.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1608301442180.63329@chino.kir.corp.google.com
Fixes: cd11016e5f52 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>	[4.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    4 ++++
 kernel/exit.c             |    7 +------
 mm/mempolicy.c            |   17 +++++++++++++++++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicy-task-mempolicy-must-be-null-before-dropping-final-reference include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-task-mempolicy-must-be-null-before-dropping-final-reference
+++ a/include/linux/mempolicy.h
@@ -195,6 +195,7 @@ static inline bool vma_migratable(struct
 }
 
 extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
+extern void mpol_put_task_policy(struct task_struct *);
 
 #else
 
@@ -297,5 +298,8 @@ static inline int mpol_misplaced(struct
 	return -1; /* no node preference */
 }
 
+static inline void mpol_put_task_policy(struct task_struct *task)
+{
+}
 #endif /* CONFIG_NUMA */
 #endif
diff -puN kernel/exit.c~mm-mempolicy-task-mempolicy-must-be-null-before-dropping-final-reference kernel/exit.c
--- a/kernel/exit.c~mm-mempolicy-task-mempolicy-must-be-null-before-dropping-final-reference
+++ a/kernel/exit.c
@@ -848,12 +848,7 @@ void do_exit(long code)
 	TASKS_RCU(preempt_enable());
 	exit_notify(tsk, group_dead);
 	proc_exit_connector(tsk);
-#ifdef CONFIG_NUMA
-	task_lock(tsk);
-	mpol_put(tsk->mempolicy);
-	tsk->mempolicy = NULL;
-	task_unlock(tsk);
-#endif
+	mpol_put_task_policy(tsk);
 #ifdef CONFIG_FUTEX
 	if (unlikely(current->pi_state_cache))
 		kfree(current->pi_state_cache);
diff -puN mm/mempolicy.c~mm-mempolicy-task-mempolicy-must-be-null-before-dropping-final-reference mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-task-mempolicy-must-be-null-before-dropping-final-reference
+++ a/mm/mempolicy.c
@@ -2336,6 +2336,23 @@ out:
 	return ret;
 }
 
+/*
+ * Drop the (possibly final) reference to task->mempolicy.  It needs to be
+ * dropped after task->mempolicy is set to NULL so that any allocation done as
+ * part of its kmem_cache_free(), such as by KASAN, doesn't reference a freed
+ * policy.
+ */
+void mpol_put_task_policy(struct task_struct *task)
+{
+	struct mempolicy *pol;
+
+	task_lock(task);
+	pol = task->mempolicy;
+	task->mempolicy = NULL;
+	task_unlock(task);
+	mpol_put(pol);
+}
+
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
 	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
_
