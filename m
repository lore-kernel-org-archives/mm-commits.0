From: akpm@linux-foundation.org
Subject: [merged] sparc-get-rid-of-superfluous-__gfp_repeat.patch removed
 from -mm tree
Date: Tue, 28 Jun 2016 19:02:14 -0700
Message-ID: <57732c26.j/ezoagCEdvBt4Qg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbcF2CCP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:02:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: get rid of superfluous __GFP_REPEAT
has been removed from the -mm tree.  Its filename was
     sparc-get-rid-of-superfluous-__gfp_repeat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: sparc: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

{pud,pmd}_alloc_one is using __GFP_REPEAT but it always allocates from
pgtable_cache which is initialzed to PAGE_SIZE objects.  This means that
this flag has never been actually useful here because it has always been
used only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-13-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgalloc_64.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/sparc/include/asm/pgalloc_64.h~sparc-get-rid-of-superfluous-__gfp_repeat arch/sparc/include/asm/pgalloc_64.h
--- a/arch/sparc/include/asm/pgalloc_64.h~sparc-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/sparc/include/asm/pgalloc_64.h
@@ -41,8 +41,7 @@ static inline void __pud_populate(pud_t
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(pgtable_cache,
-				GFP_KERNEL|__GFP_REPEAT);
+	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
@@ -52,8 +51,7 @@ static inline void pud_free(struct mm_st
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(pgtable_cache,
-				GFP_KERNEL|__GFP_REPEAT);
+	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
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

