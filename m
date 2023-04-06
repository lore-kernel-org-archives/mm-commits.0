Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC481C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbjDFDES (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbjDFDD6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:03:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430119764
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF2B864125
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D82FC433D2;
        Thu,  6 Apr 2023 03:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750224;
        bh=zSNQ5VeNRiSXaonuREY9/MvjX9/wtfkMhHSKCkdxpVQ=;
        h=Date:To:From:Subject:From;
        b=SkTQI/S74yyRGD9QyYgWFkiAZl7jUYlCl9aCdmnPpDp44m/8g1m6OZI1ywEQhzwco
         jiChdcF+oaRhW2snXz9J2yxwfyzuNN+eH9Q/tsibw6t2Cksu3UDcg+iQkUiU64r1Dd
         NJLLGZb/M6p53gs616IIZ+ehFY1q5QYZTVF+bs5w=
Date:   Wed, 05 Apr 2023 20:03:43 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-conditionally-write-lock-vma-in-free_pgtables.patch removed from -mm tree
Message-Id: <20230406030344.2D82FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: conditionally write-lock VMA in free_pgtables
has been removed from the -mm tree.  Its filename was
     mm-conditionally-write-lock-vma-in-free_pgtables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: conditionally write-lock VMA in free_pgtables
Date: Mon, 27 Feb 2023 09:36:18 -0800

Normally free_pgtables needs to lock affected VMAs except for the case
when VMAs were isolated under VMA write-lock.  munmap() does just that,
isolating while holding appropriate locks and then downgrading mmap_lock
and dropping per-VMA locks before freeing page tables.  Add a parameter to
free_pgtables for such scenario.

Link: https://lkml.kernel.org/r/20230227173632.3292573-20-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 mm/memory.c   |    6 +++++-
 mm/mmap.c     |    5 +++--
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/mm/internal.h~mm-conditionally-write-lock-vma-in-free_pgtables
+++ a/mm/internal.h
@@ -105,7 +105,7 @@ void folio_activate(struct folio *folio)
 
 void free_pgtables(struct mmu_gather *tlb, struct maple_tree *mt,
 		   struct vm_area_struct *start_vma, unsigned long floor,
-		   unsigned long ceiling);
+		   unsigned long ceiling, bool mm_wr_locked);
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
 struct zap_details;
--- a/mm/memory.c~mm-conditionally-write-lock-vma-in-free_pgtables
+++ a/mm/memory.c
@@ -362,7 +362,7 @@ void free_pgd_range(struct mmu_gather *t
 
 void free_pgtables(struct mmu_gather *tlb, struct maple_tree *mt,
 		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling)
+		   unsigned long ceiling, bool mm_wr_locked)
 {
 	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
 
@@ -380,6 +380,8 @@ void free_pgtables(struct mmu_gather *tl
 		 * Hide vma from rmap and truncate_pagecache before freeing
 		 * pgtables
 		 */
+		if (mm_wr_locked)
+			vma_start_write(vma);
 		unlink_anon_vmas(vma);
 		unlink_file_vma(vma);
 
@@ -394,6 +396,8 @@ void free_pgtables(struct mmu_gather *tl
 			       && !is_vm_hugetlb_page(next)) {
 				vma = next;
 				next = mas_find(&mas, ceiling - 1);
+				if (mm_wr_locked)
+					vma_start_write(vma);
 				unlink_anon_vmas(vma);
 				unlink_file_vma(vma);
 			}
--- a/mm/mmap.c~mm-conditionally-write-lock-vma-in-free_pgtables
+++ a/mm/mmap.c
@@ -2167,7 +2167,8 @@ static void unmap_region(struct mm_struc
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, mt, vma, start, end, mm_wr_locked);
 	free_pgtables(&tlb, mt, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-				 next ? next->vm_start : USER_PGTABLES_CEILING);
+				 next ? next->vm_start : USER_PGTABLES_CEILING,
+				 mm_wr_locked);
 	tlb_finish_mmu(&tlb);
 }
 
@@ -3064,7 +3065,7 @@ void exit_mmap(struct mm_struct *mm)
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmap_write_lock(mm);
 	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
-		      USER_PGTABLES_CEILING);
+		      USER_PGTABLES_CEILING, true);
 	tlb_finish_mmu(&tlb);
 
 	/*
_

Patches currently in -mm which might be from surenb@google.com are


