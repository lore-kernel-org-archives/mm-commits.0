From: akpm@linux-foundation.org
Subject: - xen-fix-pinning-when-not-using-split-pte-locks.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:28:43 -0700
Message-ID: <200810092228.m99MShVV006103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYJIW3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, alex.nixon@citrix.com, hugh@veritas.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     xen: fix pinning when not using split pte locks
has been removed from the -mm tree.  Its filename was
     xen-fix-pinning-when-not-using-split-pte-locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xen: fix pinning when not using split pte locks
From: Jeremy Fitzhardinge <jeremy@goop.org>

We only pin PTE pages when using split PTE locks, so don't do the
pin/unpin when attaching/detaching pte pages to a pinned pagetable.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Alex Nixon <alex.nixon@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/enlighten.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/xen/enlighten.c~xen-fix-pinning-when-not-using-split-pte-locks arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~xen-fix-pinning-when-not-using-split-pte-locks
+++ a/arch/x86/xen/enlighten.c
@@ -858,7 +858,7 @@ static void xen_alloc_ptpage(struct mm_s
 
 		if (!PageHighMem(page)) {
 			make_lowmem_page_readonly(__va(PFN_PHYS((unsigned long)pfn)));
-			if (level == PT_PTE)
+			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
 				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
 		} else
 			/* make sure there are no stray mappings of
@@ -926,7 +926,7 @@ static void xen_release_ptpage(unsigned 
 
 	if (PagePinned(page)) {
 		if (!PageHighMem(page)) {
-			if (level == PT_PTE)
+			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
 				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 		}
_

Patches currently in -mm which might be from jeremy@goop.org are

git-tip.patch
git-block.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
drivers-net-xen-netfrontc-use-div_round_up.patch

