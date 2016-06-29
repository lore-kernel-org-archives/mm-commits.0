From: akpm@linux-foundation.org
Subject: [merged] score-get-rid-of-superfluous-__gfp_repeat.patch removed
 from -mm tree
Date: Tue, 28 Jun 2016 19:02:09 -0700
Message-ID: <57732c21.ymr7Bdm6g57fQ1xa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbcF2CCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, lennox.wu@gmail.com, liqin.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: get rid of superfluous __GFP_REPEAT
has been removed from the -mm tree.  Its filename was
     score-get-rid-of-superfluous-__gfp_repeat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: score: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

pte_alloc_one{_kernel} allocate PTE_ORDER which is 0.  This means that
this flag has never been actually useful here because it has always been
used only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-11-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/include/asm/pgalloc.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/score/include/asm/pgalloc.h~score-get-rid-of-superfluous-__gfp_repeat arch/score/include/asm/pgalloc.h
--- a/arch/score/include/asm/pgalloc.h~score-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/score/include/asm/pgalloc.h
@@ -42,8 +42,7 @@ static inline pte_t *pte_alloc_one_kerne
 {
 	pte_t *pte;
 
-	pte = (pte_t *) __get_free_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO,
-					PTE_ORDER);
+	pte = (pte_t *) __get_free_pages(GFP_KERNEL|__GFP_ZERO, PTE_ORDER);
 
 	return pte;
 }
@@ -53,7 +52,7 @@ static inline struct page *pte_alloc_one
 {
 	struct page *pte;
 
-	pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
+	pte = alloc_pages(GFP_KERNEL, PTE_ORDER);
 	if (!pte)
 		return NULL;
 	clear_highpage(pte);
_

Patches currently in -mm which might be from mhocko@suse.com are

arm-get-rid-of-superfluous-__gfp_repeat.patch
slab-make-gfp_slab_bug_mask-information-more-human-readable.patch
slab-do-not-panic-on-invalid-gfp_mask.patch
mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch
mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch
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

