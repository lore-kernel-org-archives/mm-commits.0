From: akpm@linux-foundation.org
Subject: [merged] arm-get-rid-of-superfluous-__gfp_repeat.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 11:58:27 -0700
Message-ID: <57990453.E709sjyOzgqc9rSz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbcG0S63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:58:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: get rid of superfluous __GFP_REPEAT
has been removed from the -mm tree.  Its filename was
     arm-get-rid-of-superfluous-__gfp_repeat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: arm: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

PGALLOC_GFP uses __GFP_REPEAT but none of the allocation which uses this
flag is for more than order-2.  This means that this flag has never been
actually useful here because it has always been used only for
PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-5-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgalloc.h |    2 +-
 arch/arm/mm/pgd.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/include/asm/pgalloc.h~arm-get-rid-of-superfluous-__gfp_repeat arch/arm/include/asm/pgalloc.h
--- a/arch/arm/include/asm/pgalloc.h~arm-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/arm/include/asm/pgalloc.h
@@ -57,7 +57,7 @@ static inline void pud_populate(struct m
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
-#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
+#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
 
 static inline void clean_pte_table(pte_t *pte)
 {
diff -puN arch/arm/mm/pgd.c~arm-get-rid-of-superfluous-__gfp_repeat arch/arm/mm/pgd.c
--- a/arch/arm/mm/pgd.c~arm-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/arm/mm/pgd.c
@@ -23,7 +23,7 @@
 #define __pgd_alloc()	kmalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL)
 #define __pgd_free(pgd)	kfree(pgd)
 #else
-#define __pgd_alloc()	(pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_REPEAT, 2)
+#define __pgd_alloc()	(pgd_t *)__get_free_pages(GFP_KERNEL, 2)
 #define __pgd_free(pgd)	free_pages((unsigned long)pgd, 2)
 #endif
 
_

Patches currently in -mm which might be from mhocko@suse.com are

proc-oom-drop-bogus-task_lock-and-mm-check.patch
proc-oom-drop-bogus-sighand-lock.patch
proc-oom_adj-extract-oom_score_adj-setting-into-a-helper.patch
mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch
mm-oom-skip-vforked-tasks-from-being-selected.patch
mm-oom-kill-all-tasks-sharing-the-mm.patch
mm-oom-fortify-task_will_free_mem.patch
mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch
mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch
mm-oom-fortify-task_will_free_mem-fix.patch
freezer-oom-check-tif_memdie-on-the-correct-task.patch
cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements.patch

