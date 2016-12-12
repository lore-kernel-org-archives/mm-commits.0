From: akpm@linux-foundation.org
Subject: + mm-add-vfree_atomic-fix-fix.patch added to -mm tree
Date: Mon, 12 Dec 2016 14:41:46 -0800
Message-ID: <584f27aa.qb9E/Je650SbVEiq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751697AbcLLWlC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 17:41:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-vfree_atomic-fix-fix
has been added to the -mm tree.  Its filename is
     mm-add-vfree_atomic-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-vfree_atomic-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-vfree_atomic-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-vfree_atomic-fix-fix

tweak comment grammar

Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-add-vfree_atomic-fix-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-add-vfree_atomic-fix-fix
+++ a/mm/vmalloc.c
@@ -1491,10 +1491,9 @@ static inline void __vfree_deferred(cons
 {
 	/*
 	 * Use raw_cpu_ptr() because this can be called from preemptible
-	 * context. Preemption is absolutely fine here, because llist_add()
-	 * implementation is lockless, so it works even if we adding to list
-	 * of the other cpu.
-	 * schedule_work() should be fine with this too.
+	 * context. Preemption is absolutely fine here, because the llist_add()
+	 * implementation is lockless, so it works even if we are adding to
+	 * nother cpu's list.  schedule_work() should be fine with this too.
 	 */
 	struct vfree_deferred *p = raw_cpu_ptr(&vfree_deferred);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-add-vfree_atomic-fix-fix.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

