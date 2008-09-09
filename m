From: akpm@linux-foundation.org
Subject: + xen-fix-pinning-when-not-using-split-pte-locks.patch added to -mm tree
Date: Tue, 09 Sep 2008 15:52:02 -0700
Message-ID: <200809092252.m89Mq2B9007467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbYIIWwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Sep 2008 18:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, alex.nixon@citrix.com, hugh@veritas.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu


The patch titled
     xen: fix pinning when not using split pte locks
has been added to the -mm tree.  Its filename is
     xen-fix-pinning-when-not-using-split-pte-locks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
x86-pgd_cdtor-cleanup.patch
x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch
mm-define-use_split_ptlocks-rather-than-repeating-expression.patch
xen-fix-pinning-when-not-using-split-pte-locks.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
add-phys_addr_t-for-holding-physical-addresses.patch
make-pfn_phys-explicitly-return-phys_addr_t.patch
redefine-resource_size_t-as-phys_addr_t.patch
drivers-net-xen-netfrontc-use-div_round_up.patch

