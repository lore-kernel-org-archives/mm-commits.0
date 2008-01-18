From: akpm@linux-foundation.org
Subject: + maps4-add-proc-pid-pagemap-interface-fix.patch added to -mm tree
Date: Thu, 17 Jan 2008 17:08:31 -0800
Message-ID: <200801180108.m0I18VKC023815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757616AbYARBI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 20:08:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com


The patch titled
     Subject: Re: 2.6.24-rc8-mm1: powerpc oopses
has been added to the -mm tree.  Its filename is
     maps4-add-proc-pid-pagemap-interface-fix.patch

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

git-x86.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
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
drivers-char-randomcwrite_pool-cond_resched-needed.patch
