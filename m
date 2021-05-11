Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFD5C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374476191C
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhEKWSJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 18:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhEKWSJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 18:18:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AD33616EA;
        Tue, 11 May 2021 22:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620771422;
        bh=cmeiRYR+ntgNC2yzZVaD2+uyYSHV03UmXkzLAFRsLWE=;
        h=Date:From:To:Subject:From;
        b=CVdClbgZbdTReElxoQVbGpxq7L1eZzLqKe9gWX6W6SFFDVL2uuR8SZA4pMO8YZ2Fa
         W/48tVxh0m/S1aEm9zaxcoWU76OSCvGlLSVTPNTRo5lWvcXMISAktlziriyeolRUFo
         OuVDFbAY+BXrlw/k2Ox5vGl0JIW1YcyZsGmjcOc8=
Date:   Tue, 11 May 2021 15:17:01 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject:  +
 mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
 added to -mm tree
Message-ID: <20210511221701.242eEePvY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: use range flush that does TLB and page walk cache flush
has been added to the -mm tree.  Its filename is
     mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch

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
Subject: mm/mremap: use range flush that does TLB and page walk cache flush

Some architectures do have the concept of page walk cache which need to be
flush when updating higher levels of page tables.  A fast mremap that
involves moving page table pages instead of copying pte entries should
flush page walk cache since the old translation cache is no more valid.

Add new helper flush_pte_tlb_pwc_range() which invalidates both TLB and
page walk cache where TLB entries are mapped with page size PAGE_SIZE.

Link: https://lkml.kernel.org/r/20210422054323.150993-7-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/tlbflush.h |   10 ++++++++++
 mm/mremap.c                                   |   14 ++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/tlbflush.h~mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush
+++ a/arch/powerpc/include/asm/book3s/64/tlbflush.h
@@ -80,6 +80,16 @@ static inline void flush_hugetlb_tlb_ran
 	return flush_hugetlb_tlb_pwc_range(vma, start, end, false);
 }
 
+#define flush_pte_tlb_pwc_range flush_tlb_pwc_range
+static inline void flush_pte_tlb_pwc_range(struct vm_area_struct *vma,
+					   unsigned long start, unsigned long end)
+{
+	if (radix_enabled())
+		return radix__flush_tlb_pwc_range_psize(vma->vm_mm, start,
+							end, mmu_virtual_psize, true);
+	return hash__flush_tlb_range(vma, start, end);
+}
+
 static inline void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end)
 {
--- a/mm/mremap.c~mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush
+++ a/mm/mremap.c
@@ -210,6 +210,16 @@ static void move_ptes(struct vm_area_str
 		drop_rmap_locks(vma);
 }
 
+#ifndef flush_pte_tlb_pwc_range
+#define flush_pte_tlb_pwc_range flush_pte_tlb_pwc_range
+static inline void flush_pte_tlb_pwc_range(struct vm_area_struct *vma,
+					   unsigned long start,
+					   unsigned long end)
+{
+	return flush_tlb_range(vma, start, end);
+}
+#endif
+
 #ifdef CONFIG_HAVE_MOVE_PMD
 static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
@@ -260,7 +270,7 @@ static bool move_normal_pmd(struct vm_ar
 	VM_BUG_ON(!pmd_none(*new_pmd));
 	pmd_populate(mm, new_pmd, (pgtable_t)pmd_page_vaddr(pmd));
 
-	flush_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
+	flush_pte_tlb_pwc_range(vma, old_addr, old_addr + PMD_SIZE);
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
 	spin_unlock(old_ptl);
@@ -307,7 +317,7 @@ static bool move_normal_pud(struct vm_ar
 	VM_BUG_ON(!pud_none(*new_pud));
 
 	pud_populate(mm, new_pud, (pmd_t *)pud_page_vaddr(pud));
-	flush_tlb_range(vma, old_addr, old_addr + PUD_SIZE);
+	flush_pte_tlb_pwc_range(vma, old_addr, old_addr + PUD_SIZE);
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
 	spin_unlock(old_ptl);
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
powerpc-mm-book3s64-fix-possible-build-error.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
mm-mremap-move-tlb-flush-outside-page-table-lock.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-mm-enable-move-pmd-pud.patch

