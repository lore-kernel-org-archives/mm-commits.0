Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A17C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiGDBJ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiGDBJ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704FF3890
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F251D6130D
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E094C341C6;
        Mon,  4 Jul 2022 01:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896964;
        bh=ZooDSssqDqaf7bPy3QSQAv4EwGE6lFjoS+CuwRXx2Bw=;
        h=Date:To:From:Subject:From;
        b=2GAQpwcrwC8K7iL0drJvGN+AssNs9DnckxiraWnMA3lpF9TdXxnZiKyL1NkvuZV9E
         biEG/3TQEVwNsBsdjU7f4aKKpSkBdnIzdDKqp/gtm7jDPrCgr/GrV4MYpEEtNE1W9x
         5eETAJpp+MCYffIxP7okNcJySslsbIkcJy7ffMbM=
Date:   Sun, 03 Jul 2022 18:09:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch removed from -mm tree
Message-Id: <20220704010924.4E094C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_vma_mapped.c: check possible huge PMD map with transhuge_vma_suitable()
has been removed from the -mm tree.  Its filename was
     mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm/page_vma_mapped.c: check possible huge PMD map with transhuge_vma_suitable()
Date: Fri, 13 May 2022 12:17:05 -0700

IIUC page_vma_mapped_walk() checks if the vma is possibly huge PMD mapped
with transparent_hugepage_active() and "pvmw->nr_pages >= HPAGE_PMD_NR".

Actually pvmw->nr_pages is returned by compound_nr() or folio_nr_pages(),
so the page should be THP as long as "pvmw->nr_pages >= HPAGE_PMD_NR". 
And it is guaranteed THP is allocated for valid VMA in the first place. 
But it may be not PMD mapped if the VMA is file VMA and it is not properly
aligned.  The transhuge_vma_suitable() is used to do such check, so
replace transparent_hugepage_active() to it, which is too heavy and
overkilling.

Link: https://lkml.kernel.org/r/20220513191705.457775-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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

mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch
mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch
mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch
mm-thp-kill-transparent_hugepage_active.patch
mm-thp-kill-__transhuge_page_enabled.patch
mm-khugepaged-reorg-some-khugepaged-helpers.patch
doc-proc-fix-the-description-to-thpeligible.patch

