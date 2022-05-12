Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0CBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 18:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357550AbiELSV0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 14:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357439AbiELSVY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 14:21:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9FB3F31A
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 11:21:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CF58B82AA1
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 18:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB14BC385B8;
        Thu, 12 May 2022 18:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652379680;
        bh=TDkVeO0UFlL+sAFl5KO5xy03O7xvUWOhIz5NFquplgM=;
        h=Date:To:From:Subject:From;
        b=Bl7fce1QtC2UImXW9b8lF1XBrttlhrhyvYr9+vBzpw0/4eIbKbC5rvTem7t9j8sQI
         o7bHPN5tGthJZ3j3E7ZNtSldXd4guK6UjTvaWhasJgUntofHzjNrPKhuYyaGKH5bm1
         o6/VS3S3IX9BF2Cni7pJtM0gU7Zy8s3ka9jiIqV4=
Date:   Thu, 12 May 2022 11:21:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch added to mm-unstable branch
Message-Id: <20220512182120.CB14BC385B8@smtp.kernel.org>
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

IIUC PVMW checks if the vma is possibly huge PMD mapped by
transparent_hugepage_active() and "pvmw->nr_pages >= HPAGE_PMD_NR".

Actually pvmw->nr_pages is returned by compound_nr() or folio_nr_pages(),
so the page should be THP as long as "pvmw->nr_pages >= HPAGE_PMD_NR". 
And it is guaranteed THP is allocated for valid VMA in the first place. 
But it may be not PMD mapped if the VMA is file VMA and it is not properly
aligned.  The transhuge_vma_suitable() is used to do such check, so
replace transparent_hugepage_active() to it, which is too heavy and
overkilling.

Link: https://lkml.kernel.org/r/20220512174551.81279-2-shy828301@gmail.com
Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_vma_mapped.c~mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable
+++ a/mm/page_vma_mapped.c
@@ -237,13 +237,14 @@ restart:
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
+			unsigned long haddr = pvmw->address & HPAGE_PMD_MASK;
 			/*
 			 * If PVMW_SYNC, take and drop THP pmd lock so that we
 			 * cannot return prematurely, while zap_huge_pmd() has
 			 * cleared *pmd but not decremented compound_mapcount().
 			 */
 			if ((pvmw->flags & PVMW_SYNC) &&
-			    transparent_hugepage_active(vma) &&
+			    transhuge_vma_suitable(vma, haddr) &&
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

