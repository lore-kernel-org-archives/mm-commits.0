From: akpm@linux-foundation.org
Subject: + mm-oom-add-description-of-struct-oom_control.patch added to -mm tree
Date: Tue, 14 Jul 2015 16:52:41 -0700
Message-ID: <55a5a0c9.QJc4MHXpvIRGL9w+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbbGNXwm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 19:52:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.cz, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: add description of struct oom_control
has been added to the -mm tree.  Its filename is
     mm-oom-add-description-of-struct-oom_control.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-add-description-of-struct-oom_control.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-add-description-of-struct-oom_control.patch

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
Subject: mm, oom: add description of struct oom_control

Describe the purpose of struct oom_control and what each member does.

Also make gfp_mask and order const since they are never manipulated or
passed to functions that discard the qualifier.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN include/linux/oom.h~mm-oom-add-description-of-struct-oom_control include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-add-description-of-struct-oom_control
+++ a/include/linux/oom.h
@@ -12,11 +12,25 @@ struct notifier_block;
 struct mem_cgroup;
 struct task_struct;
 
+/*
+ * Details of the page allocation that triggered the oom killer that are used to
+ * determine what should be killed.
+ */
 struct oom_control {
+	/* Used to determine cpuset */
 	struct zonelist *zonelist;
-	nodemask_t	*nodemask;
-	gfp_t		gfp_mask;
-	int		order;
+
+	/* Used to determine mempolicy */
+	nodemask_t *nodemask;
+
+	/* Used to determine cpuset and node locality requirement */
+	const gfp_t gfp_mask;
+
+	/*
+	 * order == -1 means the oom kill is required by sysrq, otherwise only
+	 * for display purposes.
+	 */
+	const int order;
 };
 
 /*
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

