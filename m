Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D21C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 20:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357794AbiEMUIW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 16:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346040AbiEMUIV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 16:08:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901E036168
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 13:08:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E97AB831AF
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 20:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7161C34113;
        Fri, 13 May 2022 20:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652472496;
        bh=a4J9xtrG5/ZFFug1hmU/1VkIeszldopwt3YOEvl/V7w=;
        h=Date:To:From:Subject:From;
        b=fMKt0JTLiuz0c49NT1L+KNX2TBPRSYTDo71EJl77RfywkSGb0YZOYAwY5iwz3d9Lj
         Qf+zlJeD4gmMcgwBv4iAayoCXmG5kVWPHIkzL9NyliBzN+z35ZpF8Ss0RaeUVP++gh
         Mhs6lgdasYsLKkQ6PZOr88QlspmXuZ43EFdYa0wo=
Date:   Fri, 13 May 2022 13:08:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch added to mm-unstable branch
Message-Id: <20220513200816.D7161C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pvmw: check possible huge PMD map by transhuge_vma_suitable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch

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
Subject: mm: pvmw: check possible huge PMD map by transhuge_vma_suitable()
Date: Fri, 13 May 2022 12:17:05 -0700

IIUC PVMW checks if the vma is possibly huge PMD mapped by
transparent_hugepage_active() and "pvmw->nr_pages >= HPAGE_PMD_NR".

Actually pvmw->nr_pages is returned by compound_nr() or
folio_nr_pages(), so the page should be THP as long as "pvmw->nr_pages
>= HPAGE_PMD_NR".  And it is guaranteed THP is allocated for valid VMA
in the first place.  But it may be not PMD mapped if the VMA is file
VMA and it is not properly aligned.  The transhuge_vma_suitable()
is used to do such check, so replace transparent_hugepage_active() to
it, which is too heavy and overkilling.

Link: https://lkml.kernel.org/r/20220513191705.457775-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    8 ++++++--
 mm/page_vma_mapped.c    |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/include/linux/huge_mm.h~mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable
+++ a/include/linux/huge_mm.h
@@ -117,8 +117,10 @@ extern struct kobj_attribute shmem_enabl
 extern unsigned long transparent_hugepage_flags;
 
 static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
-		unsigned long haddr)
+		unsigned long addr)
 {
+	unsigned long haddr;
+
 	/* Don't have to check pgoff for anonymous vma */
 	if (!vma_is_anonymous(vma)) {
 		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
@@ -126,6 +128,8 @@ static inline bool transhuge_vma_suitabl
 			return false;
 	}
 
+	haddr = addr & HPAGE_PMD_MASK;
+
 	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
 		return false;
 	return true;
@@ -342,7 +346,7 @@ static inline bool transparent_hugepage_
 }
 
 static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
-		unsigned long haddr)
+		unsigned long addr)
 {
 	return false;
 }
--- a/mm/page_vma_mapped.c~mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable
+++ a/mm/page_vma_mapped.c
@@ -243,7 +243,7 @@ restart:
 			 * cleared *pmd but not decremented compound_mapcount().
 			 */
 			if ((pvmw->flags & PVMW_SYNC) &&
-			    transparent_hugepage_active(vma) &&
+			    transhuge_vma_suitable(vma, pvmw->address) &&
 			    (pvmw->nr_pages >= HPAGE_PMD_NR)) {
 				spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
 
_

Patches currently in -mm which might be from shy828301@gmail.com are

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-make-hugepage_vma_check-non-static.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch
mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch

