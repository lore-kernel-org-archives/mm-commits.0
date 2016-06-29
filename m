From: akpm@linux-foundation.org
Subject: [merged] arm64-get-rid-of-superfluous-__gfp_repeat.patch removed
 from -mm tree
Date: Tue, 28 Jun 2016 19:01:56 -0700
Message-ID: <57732c14.eIEmuB2La6757vEm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbcF2CB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:01:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: get rid of superfluous __GFP_REPEAT
has been removed from the -mm tree.  Its filename was
     arm64-get-rid-of-superfluous-__gfp_repeat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: arm64: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

{pte,pmd,pud}_alloc_one{_kernel}, late_pgtable_alloc use PGALLOC_GFP for
__get_free_page (aka order-0).

pgd_alloc is slightly more complex because it allocates from pgd_cache if
PGD_SIZE != PAGE_SIZE and PGD_SIZE depends on the configuration
(CONFIG_ARM64_VA_BITS, PAGE_SHIFT and CONFIG_PGTABLE_LEVELS).

As per
config PGTABLE_LEVELS
	int
	default 2 if ARM64_16K_PAGES && ARM64_VA_BITS_36
	default 2 if ARM64_64K_PAGES && ARM64_VA_BITS_42
	default 3 if ARM64_64K_PAGES && ARM64_VA_BITS_48
	default 3 if ARM64_4K_PAGES && ARM64_VA_BITS_39
	default 3 if ARM64_16K_PAGES && ARM64_VA_BITS_47
	default 4 if !ARM64_64K_PAGES && ARM64_VA_BITS_48

we should have the following options

CONFIG_ARM64_VA_BITS:48 CONFIG_PGTABLE_LEVELS:4 PAGE_SIZE:4k size:4096 pages:1
CONFIG_ARM64_VA_BITS:48 CONFIG_PGTABLE_LEVELS:4 PAGE_SIZE:16k size:16 pages:1
CONFIG_ARM64_VA_BITS:48 CONFIG_PGTABLE_LEVELS:3 PAGE_SIZE:64k size:512 pages:1
CONFIG_ARM64_VA_BITS:47 CONFIG_PGTABLE_LEVELS:3 PAGE_SIZE:16k size:16384 pages:1
CONFIG_ARM64_VA_BITS:42 CONFIG_PGTABLE_LEVELS:2 PAGE_SIZE:64k size:65536 pages:1
CONFIG_ARM64_VA_BITS:39 CONFIG_PGTABLE_LEVELS:3 PAGE_SIZE:4k size:4096 pages:1
CONFIG_ARM64_VA_BITS:36 CONFIG_PGTABLE_LEVELS:2 PAGE_SIZE:16k size:16384 pages:1

All of them fit into a single page (aka order-0).  This means that this
flag has never been actually useful here because it has always been used
only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-6-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm64/include/asm/pgalloc.h~arm64-get-rid-of-superfluous-__gfp_repeat arch/arm64/include/asm/pgalloc.h
--- a/arch/arm64/include/asm/pgalloc.h~arm64-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/arm64/include/asm/pgalloc.h
@@ -26,7 +26,7 @@
 
 #define check_pgt_cache()		do { } while (0)
 
-#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
+#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
 #define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
 
 #if CONFIG_PGTABLE_LEVELS > 2
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

