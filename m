From: akpm@linux-foundation.org
Subject: + vmalloc-eagerly-clear-ptes-on-vunmap-fix-2.patch added to -mm tree
Date: Tue, 30 Nov 2010 19:19:50 -0800
Message-ID: <201012010320.oB13KU9k026397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064Ab0LADVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Nov 2010 22:21:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, Trond.Myklebust@netapp.com, aelder@sgi.com, bjschuma@netapp.com, david@fromorbit.com, hch@lst.de, jeremy.fitzhardinge@citrix.com, npiggin@kernel.dk


The patch titled
     vmalloc: remove vmap_lazy_unmap flag
has been added to the -mm tree.  Its filename is
     vmalloc-eagerly-clear-ptes-on-vunmap-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: remove vmap_lazy_unmap flag
From: Jeremy Fitzhardinge <jeremy@goop.org>

Now that vmunmap no longer leaves stray ptes lying around, we don't need
the vmap_lazy_unmap flag any more.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Bryan Schumaker <bjschuma@netapp.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu.c      |    2 --
 include/linux/vmalloc.h |    2 --
 mm/vmalloc.c            |    5 -----
 3 files changed, 9 deletions(-)

diff -puN arch/x86/xen/mmu.c~vmalloc-eagerly-clear-ptes-on-vunmap-fix-2 arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~vmalloc-eagerly-clear-ptes-on-vunmap-fix-2
+++ a/arch/x86/xen/mmu.c
@@ -2415,8 +2415,6 @@ void __init xen_init_mmu_ops(void)
 	x86_init.paging.pagetable_setup_done = xen_pagetable_setup_done;
 	pv_mmu_ops = xen_mmu_ops;
 
-	vmap_lazy_unmap = false;
-
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
 }
 
diff -puN include/linux/vmalloc.h~vmalloc-eagerly-clear-ptes-on-vunmap-fix-2 include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~vmalloc-eagerly-clear-ptes-on-vunmap-fix-2
+++ a/include/linux/vmalloc.h
@@ -7,8 +7,6 @@
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 
-extern bool vmap_lazy_unmap;
-
 /* bits in flags of vmalloc's vm_struct below */
 #define VM_IOREMAP	0x00000001	/* ioremap() and friends */
 #define VM_ALLOC	0x00000002	/* vmalloc() */
diff -puN mm/vmalloc.c~vmalloc-eagerly-clear-ptes-on-vunmap-fix-2 mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-eagerly-clear-ptes-on-vunmap-fix-2
+++ a/mm/vmalloc.c
@@ -31,8 +31,6 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
-bool vmap_lazy_unmap __read_mostly = true;
-
 /*** Page table manipulation functions ***/
 
 static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end)
@@ -503,9 +501,6 @@ static unsigned long lazy_max_pages(void
 {
 	unsigned int log;
 
-	if (!vmap_lazy_unmap)
-		return 0;
