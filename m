From: akpm@linux-foundation.org
Subject: + mm-remove-unused-token-argument-from-apply_to_page_range-callback.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:17:40 -0800
Message-ID: <201101280017.p0S0HfOO008217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab1A1ASU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:18:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk


The patch titled
     mm: remove unused "token" argument from apply_to_page_range callback.
has been added to the -mm tree.  Its filename is
     mm-remove-unused-token-argument-from-apply_to_page_range-callback.patch

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
Subject: mm: remove unused "token" argument from apply_to_page_range callback.
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

We've had apply_to_page_range() for a while, which is a general way to
apply a function to ptes across a range of addresses - including
allocating any missing parts of the pagetable as needed.  This logic is
replicated in a number of places throughout the kernel, but it hasn't been
widely replaced by this function, partly because of concerns about the
overhead of calling the function once per pte.

This series adds apply_to_page_range_batch() (and reimplements
apply_to_page_range() in terms of it), which calls the pte operation
function once per pte page, moving the inner loop into the callback
function.

apply_to_page_range(_batch) also calls its callback with lazy mmu updates
enabled, which allows batching of the operations in environments where
this is beneficial (ie, virtualization).  The only caveat this introduces
is callbacks can't expect to immediately see the effects of the pte
updates in memory.

Since this is effectively identical to the code in lib/ioremap.c and
mm/vmalloc.c (twice!), I replace their open-coded variants.  I'm sure
there are others places in the kernel which could do with this (I only
stumbled over ioremap by accident).

I also add a minor optimisation to vunmap_page_range() to use a plain
pte_clear() rather than the more expensive and unnecessary
ptep_get_and_clear().


This patch:

The `token' argument is basically the struct page of the pte_t * passed
into the callback.  But there's no need to pass that, since it can be
fairly easily derived from the pte_t * itself if needed (and no current
users need to do that anyway).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/grant-table.c |    6 ++----
 arch/x86/xen/mmu.c         |    3 +--
 include/linux/mm.h         |    3 +--
 mm/memory.c                |    2 +-
 mm/vmalloc.c               |    2 +-
 5 files changed, 6 insertions(+), 10 deletions(-)

diff -puN arch/x86/xen/grant-table.c~mm-remove-unused-token-argument-from-apply_to_page_range-callback arch/x86/xen/grant-table.c
--- a/arch/x86/xen/grant-table.c~mm-remove-unused-token-argument-from-apply_to_page_range-callback
+++ a/arch/x86/xen/grant-table.c
@@ -44,8 +44,7 @@
 
 #include <asm/pgtable.h>
 
-static int map_pte_fn(pte_t *pte, struct page *pmd_page,
-		      unsigned long addr, void *data)
+static int map_pte_fn(pte_t *pte, unsigned long addr, void *data)
 {
 	unsigned long **frames = (unsigned long **)data;
 
@@ -54,8 +53,7 @@ static int map_pte_fn(pte_t *pte, struct
 	return 0;
 }
 
-static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
-			unsigned long addr, void *data)
+static int unmap_pte_fn(pte_t *pte, unsigned long addr, void *data)
 {
 
 	set_pte_at(&init_mm, addr, pte, __pte(0));
diff -puN arch/x86/xen/mmu.c~mm-remove-unused-token-argument-from-apply_to_page_range-callback arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~mm-remove-unused-token-argument-from-apply_to_page_range-callback
+++ a/arch/x86/xen/mmu.c
@@ -2292,8 +2292,7 @@ struct remap_data {
 	struct mmu_update *mmu_update;
 };
 
-static int remap_area_mfn_pte_fn(pte_t *ptep, pgtable_t token,
-				 unsigned long addr, void *data)
+static int remap_area_mfn_pte_fn(pte_t *ptep, unsigned long addr, void *data)
 {
 	struct remap_data *rmd = data;
 	pte_t pte = pte_mkspecial(pfn_pte(rmd->mfn++, rmd->prot));
diff -puN include/linux/mm.h~mm-remove-unused-token-argument-from-apply_to_page_range-callback include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-unused-token-argument-from-apply_to_page_range-callback
+++ a/include/linux/mm.h
@@ -1539,8 +1539,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 
-typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
-			void *data);
+typedef int (*pte_fn_t)(pte_t *pte, unsigned long addr, void *data);
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
 			       unsigned long size, pte_fn_t fn, void *data);
 
diff -puN mm/memory.c~mm-remove-unused-token-argument-from-apply_to_page_range-callback mm/memory.c
--- a/mm/memory.c~mm-remove-unused-token-argument-from-apply_to_page_range-callback
+++ a/mm/memory.c
@@ -2032,7 +2032,7 @@ static int apply_to_pte_range(struct mm_
 	token = pmd_pgtable(*pmd);
 
 	do {
-		err = fn(pte++, token, addr, data);
+		err = fn(pte++, addr, data);
 		if (err)
 			break;
 	} while (addr += PAGE_SIZE, addr != end);
diff -puN mm/vmalloc.c~mm-remove-unused-token-argument-from-apply_to_page_range-callback mm/vmalloc.c
--- a/mm/vmalloc.c~mm-remove-unused-token-argument-from-apply_to_page_range-callback
+++ a/mm/vmalloc.c
@@ -2113,7 +2113,7 @@ void  __attribute__((weak)) vmalloc_sync
 }
 
 
-static int f(pte_t *pte, pgtable_t table, unsigned long addr, void *data)
+static int f(pte_t *pte, unsigned long addr, void *data)
 {
 	/* apply_to_page_range() does all the hard work. */
 	return 0;
_

Patches currently in -mm which might be from jeremy.fitzhardinge@citrix.com are

linux-next.patch
mm-remove-unused-token-argument-from-apply_to_page_range-callback.patch
mm-add-apply_to_page_range_batch.patch
ioremap-use-apply_to_page_range_batch-for-ioremap_page_range.patch
vmalloc-use-plain-pte_clear-for-unmaps.patch
vmalloc-use-apply_to_page_range_batch-for-vunmap_page_range.patch
vmalloc-use-apply_to_page_range_batch-for-vmap_page_range_noflush.patch
vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area.patch
xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch
xen-grant-table-use-apply_to_page_range_batch.patch

