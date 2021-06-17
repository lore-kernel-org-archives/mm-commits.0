Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96985C2B9F4
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75021613E2
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhFQEHh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 00:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhFQEHh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Jun 2021 00:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1F38611CE;
        Thu, 17 Jun 2021 04:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623902730;
        bh=p0o4beVAnO06p9VXA5hcr/chfeEUX1LZMqSDxigYrB4=;
        h=Date:From:To:Subject:From;
        b=zMucVVZIL3T87I8SVqiq6NclTsiOgwDPLxoFQmL/sc89B1oUM+IxLBjA57lCHZthk
         NHzSNBkupPJBuEkVpAVpzt6tQ/R4J3sO5/UZJ3bGcvSe8JWDkx+5VYM8BxzHG7N7fR
         ToNnsHmKquVSIMj3HrnXLpDaIWyY5VwDQ7QMmNLw=
Date:   Wed, 16 Jun 2021 21:05:29 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  +
 powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
 added to -mm tree
Message-ID: <20210617040529.cgQJbYRwX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/book3s64/mm: update flush_tlb_range to flush page walk cache
has been added to the -mm tree.  Its filename is
     powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/book3s64/mm: update flush_tlb_range to flush page walk cache

flush_tlb_range is special in that we don't specify the page size used for
the translation.  Hence when flushing TLB we flush the translation cache
for all possible page sizes.  The kernel also uses the same interface when
moving page tables around.  Such a move requires us to flush the page walk
cache.

Instead of adding another interface to force page walk cache flush, update
flush_tlb_range to flush page walk cache if the range flushed is more than
the PMD range.  A page table move will always involve an invalidate range
more than PMD_SIZE.

Running microbenchmark with mprotect and parallel memory access didn't
show any observable performance impact.

Link: https://lkml.kernel.org/r/20210616045735.374532-3-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/tlbflush-radix.h |    2 
 arch/powerpc/mm/book3s64/radix_hugetlbpage.c        |    8 +
 arch/powerpc/mm/book3s64/radix_tlb.c                |   44 ++++++----
 3 files changed, 36 insertions(+), 18 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h~powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache
+++ a/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
@@ -60,6 +60,8 @@ extern void radix__flush_hugetlb_tlb_ran
 					   unsigned long start, unsigned long end);
 extern void radix__flush_tlb_range_psize(struct mm_struct *mm, unsigned long start,
 					 unsigned long end, int psize);
+void radix__flush_tlb_pwc_range_psize(struct mm_struct *mm, unsigned long start,
+				      unsigned long end, int psize);
 extern void radix__flush_pmd_tlb_range(struct vm_area_struct *vma,
 				       unsigned long start, unsigned long end);
 extern void radix__flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
--- a/arch/powerpc/mm/book3s64/radix_hugetlbpage.c~powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache
+++ a/arch/powerpc/mm/book3s64/radix_hugetlbpage.c
@@ -32,7 +32,13 @@ void radix__flush_hugetlb_tlb_range(stru
 	struct hstate *hstate = hstate_file(vma->vm_file);
 
 	psize = hstate_get_psize(hstate);
-	radix__flush_tlb_range_psize(vma->vm_mm, start, end, psize);
+	/*
+	 * Flush PWC even if we get PUD_SIZE hugetlb invalidate to keep this simpler.
+	 */
+	if (end - start >= PUD_SIZE)
+		radix__flush_tlb_pwc_range_psize(vma->vm_mm, start, end, psize);
+	else
+		radix__flush_tlb_range_psize(vma->vm_mm, start, end, psize);
 }
 
 /*
--- a/arch/powerpc/mm/book3s64/radix_tlb.c~powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache
+++ a/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -989,14 +989,13 @@ static unsigned long tlb_local_single_pa
 
 static inline void __radix__flush_tlb_range(struct mm_struct *mm,
 					    unsigned long start, unsigned long end)
-
 {
 	unsigned long pid;
 	unsigned int page_shift = mmu_psize_defs[mmu_virtual_psize].shift;
 	unsigned long page_size = 1UL << page_shift;
 	unsigned long nr_pages = (end - start) >> page_shift;
 	bool fullmm = (end == TLB_FLUSH_ALL);
-	bool flush_pid;
+	bool flush_pid, flush_pwc = false;
 	enum tlb_flush_type type;
 
 	pid = mm->context.id;
@@ -1015,8 +1014,16 @@ static inline void __radix__flush_tlb_ra
 		flush_pid = nr_pages > tlb_single_page_flush_ceiling;
 	else
 		flush_pid = nr_pages > tlb_local_single_page_flush_ceiling;
+	/*
+	 * full pid flush already does the PWC flush. if it is not full pid
+	 * flush check the range is more than PMD and force a pwc flush
+	 * mremap() depends on this behaviour.
+	 */
+	if (!flush_pid && (end - start) >= PMD_SIZE)
+		flush_pwc = true;
 
 	if (!mmu_has_feature(MMU_FTR_GTSE) && type == FLUSH_TYPE_GLOBAL) {
+		unsigned long type = H_RPTI_TYPE_TLB;
 		unsigned long tgt = H_RPTI_TARGET_CMMU;
 		unsigned long pg_sizes = psize_to_rpti_pgsize(mmu_virtual_psize);
 
@@ -1024,19 +1031,20 @@ static inline void __radix__flush_tlb_ra
 			pg_sizes |= psize_to_rpti_pgsize(MMU_PAGE_2M);
 		if (atomic_read(&mm->context.copros) > 0)
 			tgt |= H_RPTI_TARGET_NMMU;
-		pseries_rpt_invalidate(pid, tgt, H_RPTI_TYPE_TLB, pg_sizes,
-				       start, end);
+		if (flush_pwc)
+			type |= H_RPTI_TYPE_PWC;
+		pseries_rpt_invalidate(pid, tgt, type, pg_sizes, start, end);
 	} else if (flush_pid) {
+		/*
+		 * We are now flushing a range larger than PMD size force a RIC_FLUSH_ALL
+		 */
 		if (type == FLUSH_TYPE_LOCAL) {
-			_tlbiel_pid(pid, RIC_FLUSH_TLB);
+			_tlbiel_pid(pid, RIC_FLUSH_ALL);
 		} else {
 			if (cputlb_use_tlbie()) {
-				if (mm_needs_flush_escalation(mm))
-					_tlbie_pid(pid, RIC_FLUSH_ALL);
-				else
-					_tlbie_pid(pid, RIC_FLUSH_TLB);
+				_tlbie_pid(pid, RIC_FLUSH_ALL);
 			} else {
-				_tlbiel_pid_multicast(mm, pid, RIC_FLUSH_TLB);
+				_tlbiel_pid_multicast(mm, pid, RIC_FLUSH_ALL);
 			}
 		}
 	} else {
@@ -1052,6 +1060,9 @@ static inline void __radix__flush_tlb_ra
 
 		if (type == FLUSH_TYPE_LOCAL) {
 			asm volatile("ptesync": : :"memory");
+			if (flush_pwc)
+				/* For PWC, only one flush is needed */
+				__tlbiel_pid(pid, 0, RIC_FLUSH_PWC);
 			__tlbiel_va_range(start, end, pid, page_size, mmu_virtual_psize);
 			if (hflush)
 				__tlbiel_va_range(hstart, hend, pid,
@@ -1059,6 +1070,8 @@ static inline void __radix__flush_tlb_ra
 			ppc_after_tlbiel_barrier();
 		} else if (cputlb_use_tlbie()) {
 			asm volatile("ptesync": : :"memory");
+			if (flush_pwc)
+				__tlbie_pid(pid, RIC_FLUSH_PWC);
 			__tlbie_va_range(start, end, pid, page_size, mmu_virtual_psize);
 			if (hflush)
 				__tlbie_va_range(hstart, hend, pid,
@@ -1066,10 +1079,10 @@ static inline void __radix__flush_tlb_ra
 			asm volatile("eieio; tlbsync; ptesync": : :"memory");
 		} else {
 			_tlbiel_va_range_multicast(mm,
-					start, end, pid, page_size, mmu_virtual_psize, false);
+					start, end, pid, page_size, mmu_virtual_psize, flush_pwc);
 			if (hflush)
 				_tlbiel_va_range_multicast(mm,
-					hstart, hend, pid, PMD_SIZE, MMU_PAGE_2M, false);
+					hstart, hend, pid, PMD_SIZE, MMU_PAGE_2M, flush_pwc);
 		}
 	}
 out:
@@ -1143,9 +1156,6 @@ void radix__flush_all_lpid_guest(unsigne
 	_tlbie_lpid_guest(lpid, RIC_FLUSH_ALL);
 }
 
-static void radix__flush_tlb_pwc_range_psize(struct mm_struct *mm, unsigned long start,
-				  unsigned long end, int psize);
-
 void radix__tlb_flush(struct mmu_gather *tlb)
 {
 	int psize = 0;
@@ -1252,8 +1262,8 @@ void radix__flush_tlb_range_psize(struct
 	return __radix__flush_tlb_range_psize(mm, start, end, psize, false);
 }
 
-static void radix__flush_tlb_pwc_range_psize(struct mm_struct *mm, unsigned long start,
-				  unsigned long end, int psize)
+void radix__flush_tlb_pwc_range_psize(struct mm_struct *mm, unsigned long start,
+				      unsigned long end, int psize)
 {
 	__radix__flush_tlb_range_psize(mm, start, end, psize, true);
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch
mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-convert-huge-pud-move-to-separate-helper.patch
mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
powerpc-mm-enable-have_move_pmd-support.patch

