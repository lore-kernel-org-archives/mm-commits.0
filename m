Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C87CCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbiGRARq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbiGRARI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EC312A82
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13BD160F44
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A284C341C0;
        Mon, 18 Jul 2022 00:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103419;
        bh=pUFYXh86YNfZA1TP2qKPrYfbdWKQbkBsydk4dShq0fc=;
        h=Date:To:From:Subject:From;
        b=N437gL/bRa4HguRDvGmvZ+h0AGdGztKWO4OKUhyVHS33TjLVW6gJdFYpmIVOmN+lD
         TwxesCvdh5RLOMx7c9rp16IwCl+oy971JyLmpri4BnipaMUhaFrO949uhJEvdWkde3
         TrSr4TKl1w9sBbZ+NOYVZ/oXofeRnmaQgsn2VwSo=
Date:   Sun, 17 Jul 2022 17:16:58 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch removed from -mm tree
Message-Id: <20220718001659.6A284C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: thp: consolidate vma size check to transhuge_vma_suitable
has been removed from the -mm tree.  Its filename was
     mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: consolidate vma size check to transhuge_vma_suitable
Date: Thu, 16 Jun 2022 10:48:35 -0700

There are couple of places that check whether the vma size is ok for THP
or whether address fits, they are open coded and duplicate, use
transhuge_vma_suitable() to do the job by passing in (vma->end -
HPAGE_PMD_SIZE).

Move vma size check into hugepage_vma_check().  This will make
khugepaged_enter() is as same as khugepaged_enter_vma().  There is just
one caller for khugepaged_enter(), replace it to khugepaged_enter_vma()
and remove khugepaged_enter().

Link: https://lkml.kernel.org/r/20220616174840.1202070-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h    |   11 +++++++++++
 include/linux/khugepaged.h |   14 --------------
 mm/huge_memory.c           |    2 +-
 mm/khugepaged.c            |   19 ++++++-------------
 4 files changed, 18 insertions(+), 28 deletions(-)

--- a/include/linux/huge_mm.h~mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable
+++ a/include/linux/huge_mm.h
@@ -116,6 +116,17 @@ extern struct kobj_attribute shmem_enabl
 
 extern unsigned long transparent_hugepage_flags;
 
+/*
+ * Do the below checks:
+ *   - For file vma, check if the linear page offset of vma is
+ *     HPAGE_PMD_NR aligned within the file.  The hugepage is
+ *     guaranteed to be hugepage-aligned within the file, but we must
+ *     check that the PMD-aligned addresses in the VMA map to
+ *     PMD-aligned offsets within the file, else the hugepage will
+ *     not be PMD-mappable.
+ *   - For all vmas, check if the haddr is in an aligned HPAGE_PMD_SIZE
+ *     area.
+ */
 static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
 		unsigned long addr)
 {
--- a/include/linux/khugepaged.h~mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable
+++ a/include/linux/khugepaged.h
@@ -51,16 +51,6 @@ static inline void khugepaged_exit(struc
 	if (test_bit(MMF_VM_HUGEPAGE, &mm->flags))
 		__khugepaged_exit(mm);
 }
-
-static inline void khugepaged_enter(struct vm_area_struct *vma,
-				   unsigned long vm_flags)
-{
-	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
-	    khugepaged_enabled()) {
-		if (hugepage_vma_check(vma, vm_flags))
-			__khugepaged_enter(vma->vm_mm);
-	}
-}
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
@@ -68,10 +58,6 @@ static inline void khugepaged_fork(struc
 static inline void khugepaged_exit(struct mm_struct *mm)
 {
 }
-static inline void khugepaged_enter(struct vm_area_struct *vma,
-				    unsigned long vm_flags)
-{
-}
 static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
 					unsigned long vm_flags)
 {
--- a/mm/huge_memory.c~mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable
+++ a/mm/huge_memory.c
@@ -726,7 +726,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 		return VM_FAULT_FALLBACK;
 	if (unlikely(anon_vma_prepare(vma)))
 		return VM_FAULT_OOM;
-	khugepaged_enter(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma, vma->vm_flags);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
--- a/mm/khugepaged.c~mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable
+++ a/mm/khugepaged.c
@@ -443,8 +443,8 @@ bool hugepage_vma_check(struct vm_area_s
 	if (vma_is_dax(vma))
 		return false;
 
-	if (vma->vm_file && !IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) -
-				vma->vm_pgoff, HPAGE_PMD_NR))
+	/* Check alignment for file vma and size for both file and anon vma */
+	if (!transhuge_vma_suitable(vma, (vma->vm_end - HPAGE_PMD_SIZE)))
 		return false;
 
 	/* Enabled via shmem mount options or sysfs settings. */
@@ -505,9 +505,7 @@ void khugepaged_enter_vma(struct vm_area
 			  unsigned long vm_flags)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
-	    khugepaged_enabled() &&
-	    (((vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK) <
-	     (vma->vm_end & HPAGE_PMD_MASK))) {
+	    khugepaged_enabled()) {
 		if (hugepage_vma_check(vma, vm_flags))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -948,7 +946,6 @@ static int hugepage_vma_revalidate(struc
 		struct vm_area_struct **vmap)
 {
 	struct vm_area_struct *vma;
-	unsigned long hstart, hend;
 
 	if (unlikely(khugepaged_test_exit(mm)))
 		return SCAN_ANY_PROCESS;
@@ -957,9 +954,7 @@ static int hugepage_vma_revalidate(struc
 	if (!vma)
 		return SCAN_VMA_NULL;
 
-	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-	hend = vma->vm_end & HPAGE_PMD_MASK;
-	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
+	if (!transhuge_vma_suitable(vma, address))
 		return SCAN_ADDRESS_RANGE;
 	if (!hugepage_vma_check(vma, vma->vm_flags))
 		return SCAN_VMA_CHECK;
@@ -2135,10 +2130,8 @@ skip:
 			progress++;
 			continue;
 		}
-		hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-		hend = vma->vm_end & HPAGE_PMD_MASK;
-		if (hstart >= hend)
-			goto skip;
+		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
+		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
 		if (khugepaged_scan.address > hend)
 			goto skip;
 		if (khugepaged_scan.address < hstart)
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch

