From: akpm@linux-foundation.org
Subject: [merged] unicore32-get-rid-of-superfluous-__gfp_repeat.patch
 removed from -mm tree
Date: Tue, 28 Jun 2016 19:02:22 -0700
Message-ID: <57732c2e.Bin0ni9hE+I2cil9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbcF2CCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, gxt@mprc.pku.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: unicore32: get rid of superfluous __GFP_REPEAT
has been removed from the -mm tree.  Its filename was
     unicore32-get-rid-of-superfluous-__gfp_repeat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: unicore32: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

PGALLOC_GFP uses __GFP_REPEAT but it is only used in pte_alloc_one,
pte_alloc_one_kernel which does order-0 request.  This means that this
flag has never been actually useful here because it has always been used
only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-17-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/include/asm/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/unicore32/include/asm/pgalloc.h~unicore32-get-rid-of-superfluous-__gfp_repeat arch/unicore32/include/asm/pgalloc.h
--- a/arch/unicore32/include/asm/pgalloc.h~unicore32-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/unicore32/include/asm/pgalloc.h
@@ -28,7 +28,7 @@ extern void free_pgd_slow(struct mm_stru
 #define pgd_alloc(mm)			get_pgd_slow(mm)
 #define pgd_free(mm, pgd)		free_pgd_slow(mm, pgd)
 
-#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
+#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
 
 /*
  * Allocate one PTE table.
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

