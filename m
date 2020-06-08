From: akpm@linux-foundation.org
Subject: [merged]
 mm-gupc-convert-to-use-get_user_pagepages_fast_only.patch removed from -mm
 tree
Date: Mon, 08 Jun 2020 15:32:08 -0700
Message-ID: <20200608223208.LCFjx_Q_8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgFHWcK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.shishkin@linux.intel.com, aneesh.kumar@linux.ibm.com, benh@kernel.crashing.org, jhubbard@nvidia.com, jolsa@redhat.com, jrdr.linux@gmail.com, mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, namhyung@kernel.org, paulus@ozlabs.org, pbonzini@redhat.com, peterz@infradead.org, rppt@linux.ibm.com, sfr@canb.auug.org.au, willy@infradead.org


The patch titled
     Subject: mm/gup.c: convert to use get_user_{page|pages}_fast_only()
has been removed from the -mm tree.  Its filename was
     mm-gupc-convert-to-use-get_user_pagepages_fast_only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: mm/gup.c: convert to use get_user_{page|pages}_fast_only()

API __get_user_pages_fast() renamed to get_user_pages_fast_only() to align
with pin_user_pages_fast_only().

As part of this we will get rid of write parameter.  Instead caller will
pass FOLL_WRITE to get_user_pages_fast_only().  This will not change any
existing functionality of the API.

All the callers are changed to pass FOLL_WRITE.

Also introduce get_user_page_fast_only(), and use it in a few places that
hard-code nr_pages to 1.

Updated the documentation of the API.

Link: http://lkml.kernel.org/r/1590396812-31277-1-git-send-email-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Paul Mackerras <paulus@ozlabs.org>		[arch/powerpc/kvm]
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_64_mmu_hv.c    |    2 -
 arch/powerpc/kvm/book3s_64_mmu_radix.c |    2 -
 arch/powerpc/perf/callchain_64.c       |    4 ---
 include/linux/mm.h                     |   10 ++++++-
 kernel/events/core.c                   |    4 +--
 mm/gup.c                               |   29 ++++++++++++-----------
 virt/kvm/kvm_main.c                    |    8 ++----
 7 files changed, 32 insertions(+), 27 deletions(-)

--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c~mm-gupc-convert-to-use-get_user_pagepages_fast_only
+++ a/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -581,7 +581,7 @@ int kvmppc_book3s_hv_page_fault(struct k
 	 * We always ask for write permission since the common case
 	 * is that the page is writable.
 	 */
-	if (__get_user_pages_fast(hva, 1, 1, &page) == 1) {
+	if (get_user_page_fast_only(hva, FOLL_WRITE, &page)) {
 		write_ok = true;
 	} else {
 		/* Call KVM generic code to do the slow-path check */
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c~mm-gupc-convert-to-use-get_user_pagepages_fast_only
+++ a/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -795,7 +795,7 @@ int kvmppc_book3s_instantiate_page(struc
 	 * is that the page is writable.
 	 */
 	hva = gfn_to_hva_memslot(memslot, gfn);
-	if (!kvm_ro && __get_user_pages_fast(hva, 1, 1, &page) == 1) {
+	if (!kvm_ro && get_user_page_fast_only(hva, FOLL_WRITE, &page)) {
 		upgrade_write = true;
 	} else {
 		unsigned long pfn;
--- a/arch/powerpc/perf/callchain_64.c~mm-gupc-convert-to-use-get_user_pagepages_fast_only
+++ a/arch/powerpc/perf/callchain_64.c
@@ -30,11 +30,9 @@ int read_user_stack_slow(void __user *pt
 	unsigned long addr = (unsigned long) ptr;
 	unsigned long offset;
 	struct page *page;
-	int nrpages;
 	void *kaddr;
 
-	nrpages = __get_user_pages_fast(addr, 1, 1, &page);
-	if (nrpages == 1) {
+	if (get_user_page_fast_only(addr, FOLL_WRITE, &page)) {
 		kaddr = page_address(page);
 
 		/* align address to page boundary */
--- a/include/linux/mm.h~mm-gupc-convert-to-use-get_user_pagepages_fast_only
+++ a/include/linux/mm.h
@@ -1824,10 +1824,16 @@ extern int mprotect_fixup(struct vm_area
 /*
  * doesn't attempt to fault and will return short.
  */
-int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
-			  struct page **pages);
+int get_user_pages_fast_only(unsigned long start, int nr_pages,
+			     unsigned int gup_flags, struct page **pages);
 int pin_user_pages_fast_only(unsigned long start, int nr_pages,
 			     unsigned int gup_flags, struct page **pages);
+
+static inline bool get_user_page_fast_only(unsigned long addr,
+			unsigned int gup_flags, struct page **pagep)
+{
+	return get_user_pages_fast_only(addr, 1, gup_flags, pagep) == 1;
+}
 /*
  * per-process(per-mm_struct) statistics.
  */
--- a/kernel/events/core.c~mm-gupc-convert-to-use-get_user_pagepages_fast_only
+++ a/kernel/events/core.c
@@ -6934,12 +6934,12 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * Walking the pages tables for user address.
 		 * Interrupts are disabled, so it prevents any tear down
 		 * of the page tables.
-		 * Try IRQ-safe __get_user_pages_fast first.
+		 * Try IRQ-safe get_user_page_fast_only first.
 		 * If failed, leave phys_addr as 0.
 		 */
 		if (current->mm != NULL) {
 			pagefault_disable();
-			if (__get_user_pages_fast(virt, 1, 0, &p) == 1)
+			if (get_user_page_fast_only(virt, 0, &p))
 				phys_addr = page_to_phys(p) + virt % PAGE_SIZE;
 			pagefault_enable();
 		}
--- a/mm/gup.c~mm-gupc-convert-to-use-get_user_pagepages_fast_only
+++ a/mm/gup.c
@@ -2294,7 +2294,7 @@ pte_unmap:
  * to be special.
  *
  * For a futex to be placed on a THP tail page, get_futex_key requires a
- * __get_user_pages_fast implementation that can pin pages. Thus it's still
+ * get_user_pages_fast_only implementation that can pin pages. Thus it's still
  * useful to have gup_huge_pmd even if we can't operate on ptes.
  */
 static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
@@ -2699,7 +2699,7 @@ static inline void gup_pgd_range(unsigne
 
 #ifndef gup_fast_permitted
 /*
- * Check if it's allowed to use __get_user_pages_fast() for the range, or
+ * Check if it's allowed to use get_user_pages_fast_only() for the range, or
  * we need to fall back to the slow version:
  */
 static bool gup_fast_permitted(unsigned long start, unsigned long end)
@@ -2811,8 +2811,14 @@ static int internal_get_user_pages_fast(
 
 	return ret;
 }
-
-/*
+/**
+ * get_user_pages_fast_only() - pin user pages in memory
+ * @start:      starting user address
+ * @nr_pages:   number of pages from start to pin
+ * @gup_flags:  flags modifying pin behaviour
+ * @pages:      array that receives pointers to the pages pinned.
+ *              Should be at least nr_pages long.
+ *
  * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall back to
  * the regular GUP.
  * Note a difference with get_user_pages_fast: this always returns the
@@ -2825,8 +2831,8 @@ static int internal_get_user_pages_fast(
  * access can get ambiguous page results. If you call this function without
  * 'write' set, you'd better be sure that you're ok with that ambiguity.
  */
-int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
-			  struct page **pages)
+int get_user_pages_fast_only(unsigned long start, int nr_pages,
+			     unsigned int gup_flags, struct page **pages)
 {
 	int nr_pinned;
 	/*
@@ -2836,10 +2842,7 @@ int __get_user_pages_fast(unsigned long
 	 * FOLL_FAST_ONLY is required in order to match the API description of
 	 * this routine: no fall back to regular ("slow") GUP.
 	 */
-	unsigned int gup_flags = FOLL_GET | FOLL_FAST_ONLY;
-
-	if (write)
-		gup_flags |= FOLL_WRITE;
+	gup_flags |= FOLL_GET | FOLL_FAST_ONLY;
 
 	nr_pinned = internal_get_user_pages_fast(start, nr_pages, gup_flags,
 						 pages);
@@ -2855,7 +2858,7 @@ int __get_user_pages_fast(unsigned long
 
 	return nr_pinned;
 }
-EXPORT_SYMBOL_GPL(__get_user_pages_fast);
+EXPORT_SYMBOL_GPL(get_user_pages_fast_only);
 
 /**
  * get_user_pages_fast() - pin user pages in memory
@@ -2926,8 +2929,8 @@ int pin_user_pages_fast(unsigned long st
 EXPORT_SYMBOL_GPL(pin_user_pages_fast);
 
 /*
- * This is the FOLL_PIN equivalent of __get_user_pages_fast(). Behavior is the
- * same, except that this one sets FOLL_PIN instead of FOLL_GET.
+ * This is the FOLL_PIN equivalent of get_user_pages_fast_only(). Behavior
+ * is the same, except that this one sets FOLL_PIN instead of FOLL_GET.
  *
  * The API rules are the same, too: no negative values may be returned.
  */
--- a/virt/kvm/kvm_main.c~mm-gupc-convert-to-use-get_user_pagepages_fast_only
+++ a/virt/kvm/kvm_main.c
@@ -1740,7 +1740,6 @@ static bool hva_to_pfn_fast(unsigned lon
 			    bool *writable, kvm_pfn_t *pfn)
 {
 	struct page *page[1];
-	int npages;
 
 	/*
 	 * Fast pin a writable pfn only if it is a write fault request
@@ -1750,8 +1749,7 @@ static bool hva_to_pfn_fast(unsigned lon
 	if (!(write_fault || writable))
 		return false;
 
-	npages = __get_user_pages_fast(addr, 1, 1, page);
-	if (npages == 1) {
+	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
 		*pfn = page_to_pfn(page[0]);
 
 		if (writable)
@@ -1791,7 +1789,7 @@ static int hva_to_pfn_slow(unsigned long
 	if (unlikely(!write_fault) && writable) {
 		struct page *wpage;
 
-		if (__get_user_pages_fast(addr, 1, 1, &wpage) == 1) {
+		if (get_user_page_fast_only(addr, FOLL_WRITE, &wpage)) {
 			*writable = true;
 			put_page(page);
 			page = wpage;
@@ -2003,7 +2001,7 @@ int gfn_to_page_many_atomic(struct kvm_m
 	if (entry < nr_pages)
 		return 0;
 
-	return __get_user_pages_fast(addr, nr_pages, 1, pages);
+	return get_user_pages_fast_only(addr, nr_pages, FOLL_WRITE, pages);
 }
 EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
 
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are
