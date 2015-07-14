From: akpm@linux-foundation.org
Subject: + mm-oom-remove-unnecessary-variable.patch added to -mm tree
Date: Tue, 14 Jul 2015 16:52:43 -0700
Message-ID: <55a5a0cb.tFnjA7HxdpUNJ8SA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbbGNXwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 19:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.cz, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: remove unnecessary variable
has been added to the -mm tree.  Its filename is
     mm-oom-remove-unnecessary-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-remove-unnecessary-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-remove-unnecessary-variable.patch

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
Subject: mm, oom: remove unnecessary variable

The "killed" variable in out_of_memory() can be removed since the call to
oom_kill_process() where we should block to allow the process time to
exit is obvious.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-remove-unnecessary-variable mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-remove-unnecessary-variable
+++ a/mm/oom_kill.c
@@ -645,7 +645,6 @@ bool out_of_memory(struct oom_control *o
 	unsigned long freed = 0;
 	unsigned int uninitialized_var(points);
 	enum oom_constraint constraint = CONSTRAINT_NONE;
-	int killed = 0;
 
 	if (oom_killer_disabled)
 		return false;
@@ -653,7 +652,7 @@ bool out_of_memory(struct oom_control *o
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
 		/* Got some memory back in the last second. */
-		goto out;
+		return true;
 
 	/*
 	 * If current has a pending SIGKILL or is exiting, then automatically
@@ -666,7 +665,7 @@ bool out_of_memory(struct oom_control *o
 	if (current->mm &&
 	    (fatal_signal_pending(current) || task_will_free_mem(current))) {
 		mark_oom_victim(current);
-		goto out;
+		return true;
 	}
 
 	/*
@@ -684,7 +683,7 @@ bool out_of_memory(struct oom_control *o
 		get_task_struct(current);
 		oom_kill_process(oc, current, 0, totalpages, NULL,
 				 "Out of memory (oom_kill_allocating_task)");
-		goto out;
+		return true;
 	}
 
 	p = select_bad_process(oc, &points, totalpages);
@@ -696,16 +695,12 @@ bool out_of_memory(struct oom_control *o
 	if (p && p != (void *)-1UL) {
 		oom_kill_process(oc, p, points, totalpages, NULL,
 				 "Out of memory");
-		killed = 1;
-	}
-out:
-	/*
-	 * Give the killed threads a good chance of exiting before trying to
-	 * allocate memory again.
-	 */
-	if (killed)
+		/*
+		 * Give the killed process a good chance to exit before trying
+		 * to allocate memory again.
+		 */
 		schedule_timeout_killable(1);
-
+	}
 	return true;
 }
 
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
mm-oom-add-description-of-struct-oom_control.patch
mm-oom-remove-unnecessary-variable.patch
mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy.patch
mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch
mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy.patch
mm-zpool-allow-null-zpool-pointer-in-zpool_destroy_pool.patch
mm-zsmalloc-allow-null-pool-pointer-in-zs_destroy_pool.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch

