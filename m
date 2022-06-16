Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7829AC43334
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 18:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiFPSXK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiFPSXJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 14:23:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08D92EA08
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 11:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E21AB82276
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 18:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD48CC34114;
        Thu, 16 Jun 2022 18:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655403786;
        bh=mIj7yV7OkfJH/jwzpd9BR4xz05Sfq4dzqQEliNEune8=;
        h=Date:To:From:Subject:From;
        b=F8y6CQAx6tDS9Uxl3k70Q9e1rVkFojFu2yUv8rrPQXko3zSAcprURk+sKqMz0TjtQ
         nuy/AOudBArGdHkgrcbQFYW37lDmNyJeR97J3mS2fHzQyIOVVFc4BalppGbQipfI8o
         O2qY4NCHV2dI0CiWKEaoks83lZLnRHjLOawPjKLA=
Date:   Thu, 16 Jun 2022 11:23:05 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch added to mm-unstable branch
Message-Id: <20220616182305.DD48CC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: consolidate vma size check to transhuge_vma_suitable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -944,7 +942,6 @@ static int hugepage_vma_revalidate(struc
 		struct vm_area_struct **vmap)
 {
 	struct vm_area_struct *vma;
-	unsigned long hstart, hend;
 
 	if (unlikely(khugepaged_test_exit(mm)))
 		return SCAN_ANY_PROCESS;
@@ -953,9 +950,7 @@ static int hugepage_vma_revalidate(struc
 	if (!vma)
 		return SCAN_VMA_NULL;
 
-	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-	hend = vma->vm_end & HPAGE_PMD_MASK;
-	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
+	if (!transhuge_vma_suitable(vma, address))
 		return SCAN_ADDRESS_RANGE;
 	if (!hugepage_vma_check(vma, vma->vm_flags))
 		return SCAN_VMA_CHECK;
@@ -2136,10 +2131,8 @@ skip:
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

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch
mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch
mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch
mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch
mm-thp-kill-transparent_hugepage_active.patch
mm-thp-kill-__transhuge_page_enabled.patch
mm-khugepaged-reorg-some-khugepaged-helpers.patch
doc-proc-fix-the-description-to-thpeligible.patch

