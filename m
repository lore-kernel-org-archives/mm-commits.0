From: akpm@linux-foundation.org
Subject: - maps4-add-proc-pid-pagemap-interface-fix.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:47:31 -0800
Message-ID: <200802040347.m143lCGM012393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55061 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbYBDDrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 22:47:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Re: 2.6.24-rc8-mm1: powerpc oopses
has been removed from the -mm tree.  Its filename was
     maps4-add-proc-pid-pagemap-interface-fix.patch

This patch was dropped because it was folded into maps4-add-proc-pid-pagemap-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Subject: Re: 2.6.24-rc8-mm1: powerpc oopses
From: Matt Mackall <mpm@selenic.com>

On Thu, 2008-01-17 at 16:29 -0800, Andrew Morton wrote:
> Do we need `offset' at all?

Looks like no.

I wonder if there's a good argument for adding a pte_offset_val() which
would let us do:

pteval = pte_offset_val(pmd, addr);

and shrink the map/unmap window and overhead here and possibly
elsewhere?

Anyway, updated but still untested patch now with revealing comment:


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~maps4-add-proc-pid-pagemap-interface-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps4-add-proc-pid-pagemap-interface-fix
+++ a/fs/proc/task_mmu.c
@@ -583,18 +583,19 @@ static int pagemap_pte_range(pmd_t *pmd,
 	pte_t *pte;
 	int err = 0;
 
-	pte = pte_offset_map(pmd, addr);
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
+	for (; addr != end; addr += PAGE_SIZE) {
 		u64 pfn = PM_NOT_PRESENT;
+		pte = pte_offset_map(pmd, addr);
 		if (is_swap_pte(*pte))
 			pfn = swap_pte_to_pagemap_entry(*pte);
 		else if (pte_present(*pte))
 			pfn = pte_pfn(*pte);
+		/* unmap so we're not in atomic when we copy to userspace */
+		pte_unmap(pte);
 		err = add_to_pagemap(addr, pfn, pm);
 		if (err)
 			return err;
 	}
-	pte_unmap(pte - 1);
 
 	cond_resched();
 
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-pid-pagemap-interface-fix.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
remove-unused-code-from-mm-tiny-shmemc.patch
slob-fix-free-block-merging-at-head-of-subpage.patch
slob-reduce-external-fragmentation-by-using-three-free-lists.patch
slob-correct-kconfig-description.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
random-add-async-notification-support-to-dev-random.patch
