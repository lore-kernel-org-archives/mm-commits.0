From: akpm@linux-foundation.org
Subject: + mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 15:54:22 -0700
Message-ID: <55a5931e.10j4xo5qb/WsfSUS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbbGNWyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 18:54:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.cz, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: pass an oom order of -1 when triggered by sysrq
has been added to the -mm tree.  Its filename is
     mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: pass an oom order of -1 when triggered by sysrq

The force_kill member of struct oom_control isn't needed if an order of -1
is used instead.  This is the same as order == -1 in struct
compact_control which requires full memory compaction.

This patch introduces no functional change.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    3 +--
 include/linux/oom.h |    1 -
 mm/memcontrol.c     |    1 -
 mm/oom_kill.c       |    5 ++---
 mm/page_alloc.c     |    1 -
 5 files changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/tty/sysrq.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq
+++ a/drivers/tty/sysrq.c
@@ -358,8 +358,7 @@ static void moom_callback(struct work_st
 		.zonelist = node_zonelist(first_memory_node, gfp_mask),
 		.nodemask = NULL,
 		.gfp_mask = gfp_mask,
-		.order = 0,
-		.force_kill = true,
+		.order = -1,
 	};
 
 	mutex_lock(&oom_lock);
diff -puN include/linux/oom.h~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq
+++ a/include/linux/oom.h
@@ -17,7 +17,6 @@ struct oom_control {
 	nodemask_t	*nodemask;
 	gfp_t		gfp_mask;
 	int		order;
-	bool		force_kill;
 };
 
 /*
diff -puN mm/memcontrol.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq
+++ a/mm/memcontrol.c
@@ -1550,7 +1550,6 @@ static void mem_cgroup_out_of_memory(str
 		.nodemask = NULL,
 		.gfp_mask = gfp_mask,
 		.order = order,
-		.force_kill = false,
 	};
 	struct mem_cgroup *iter;
 	unsigned long chosen_points = 0;
diff -puN mm/oom_kill.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq
+++ a/mm/oom_kill.c
@@ -265,7 +265,7 @@ enum oom_scan_t oom_scan_process_thread(
 	 * Don't allow any other task to have access to the reserves.
 	 */
 	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
-		if (!oc->force_kill)
+		if (oc->order != -1)
 			return OOM_SCAN_ABORT;
 	}
 	if (!task->mm)
@@ -278,7 +278,7 @@ enum oom_scan_t oom_scan_process_thread(
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task_will_free_mem(task) && !oc->force_kill)
+	if (task_will_free_mem(task) && oc->order != -1)
 		return OOM_SCAN_ABORT;
 
 	return OOM_SCAN_OK;
@@ -718,7 +718,6 @@ void pagefault_out_of_memory(void)
 		.nodemask = NULL,
 		.gfp_mask = 0,
 		.order = 0,
-		.force_kill = false,
 	};
 
 	if (mem_cgroup_oom_synchronize(true))
diff -puN mm/page_alloc.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq
+++ a/mm/page_alloc.c
@@ -2696,7 +2696,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		.nodemask = ac->nodemask,
 		.gfp_mask = gfp_mask,
 		.order = order,
-		.force_kill = false,
 	};
 	struct page *page;
 
_

Patches currently in -mm which might be from rientjes@google.com are

slub-fix-spelling-succedd-to-succeed.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-improve-bulk-alloc-strategy.patch
slub-initial-bulk-free-implementation.patch
slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch
mm-slub-move-slab-initialization-into-irq-enabled-region.patch
mm-slub-fix-slab-double-free-in-case-of-duplicate-sysfs-filename.patch
mm-memblock-warn_on-when-nid-differs-from-overlap-region.patch
hugetlb-make-the-function-vma_shareable-bool.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-improve-__gfp_noretry-comment-based-on-implementation.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
mm-oom-organize-oom-context-into-struct.patch
mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq.patch
mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-utilc-add-kstrimdup.patch

