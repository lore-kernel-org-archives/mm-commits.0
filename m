Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A631C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiDDXkc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiDDXkZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529474CD40
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 16:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A851061768
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 23:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A26C2BBE4;
        Mon,  4 Apr 2022 23:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649115492;
        bh=pJzk/vgLog4Zd1qbAZTH+T2egnZ050wcr01FP+eJy3A=;
        h=Date:To:From:Subject:From;
        b=EwPaPlNq+DMkI/pqHskIMluDeFTKd0ecwwKrdVnJ92LMMwxXiCHTLRuH5B+6f7wGU
         gFnvkwdvLAycH9YaSLiwq67Py2Yerd6/PEg3gQtZVKgo5z8J3JwY6yOgHoP/fxvZy1
         VhQnbD5VdTExx8Sp0TXarjGcASTdCYyyEzCy1jFo=
Date:   Mon, 04 Apr 2022 16:38:11 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, song@kernel.org, riel@surriel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch added to -mm tree
Message-Id: <20220404233812.08A26C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: introduce khugepaged_enter_vma() helper
has been added to the -mm tree.  Its filename is
     mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: introduce khugepaged_enter_vma() helper

The khugepaged_enter_vma_merge() actually does as the same thing as the
khugepaged_enter() section called by shmem_mmap(), so consolidate them
into one helper and rename it to khugepaged_enter_vma().

Link: https://lkml.kernel.org/r/20220404200250.321455-8-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <song@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h |    8 ++++----
 mm/khugepaged.c            |   26 +++++++++-----------------
 mm/mmap.c                  |    8 ++++----
 mm/shmem.c                 |   12 ++----------
 4 files changed, 19 insertions(+), 35 deletions(-)

--- a/include/linux/khugepaged.h~mm-khugepaged-introduce-khugepaged_enter_vma-helper
+++ a/include/linux/khugepaged.h
@@ -10,8 +10,8 @@ extern void khugepaged_destroy(void);
 extern int start_stop_khugepaged(void);
 extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
-				       unsigned long vm_flags);
+extern void khugepaged_enter_vma(struct vm_area_struct *vma,
+				 unsigned long vm_flags);
 extern void khugepaged_fork(struct mm_struct *mm,
 			    struct mm_struct *oldmm);
 extern void khugepaged_exit(struct mm_struct *mm);
@@ -49,8 +49,8 @@ static inline void khugepaged_enter(stru
 				    unsigned long vm_flags)
 {
 }
-static inline void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
-					      unsigned long vm_flags)
+static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
+					unsigned long vm_flags)
 {
 }
 static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
--- a/mm/khugepaged.c~mm-khugepaged-introduce-khugepaged_enter_vma-helper
+++ a/mm/khugepaged.c
@@ -365,7 +365,7 @@ int hugepage_madvise(struct vm_area_stru
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		khugepaged_enter_vma_merge(vma, *vm_flags);
+		khugepaged_enter_vma(vma, *vm_flags);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
@@ -505,23 +505,15 @@ void __khugepaged_enter(struct mm_struct
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
-			       unsigned long vm_flags)
+void khugepaged_enter_vma(struct vm_area_struct *vma,
+			  unsigned long vm_flags)
 {
-	unsigned long hstart, hend;
-
-	/*
-	 * khugepaged only supports read-only files for non-shmem files.
-	 * khugepaged does not yet work on special mappings. And
-	 * file-private shmem THP is not supported.
-	 */
-	if (!hugepage_vma_check(vma, vm_flags))
-		return;
-
-	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-	hend = vma->vm_end & HPAGE_PMD_MASK;
-	if (hstart < hend)
-		khugepaged_enter(vma, vm_flags);
+	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
+	    khugepaged_enabled() &&
+	    (((vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK) <
+	     (vma->vm_end & HPAGE_PMD_MASK)))
+		if (hugepage_vma_check(vma, vm_flags))
+			__khugepaged_enter(vma->vm_mm);
 }
 
 void __khugepaged_exit(struct mm_struct *mm)
--- a/mm/mmap.c~mm-khugepaged-introduce-khugepaged_enter_vma-helper
+++ a/mm/mmap.c
@@ -1232,7 +1232,7 @@ struct vm_area_struct *vma_merge(struct
 					 end, prev->vm_pgoff, NULL, prev);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(prev, vm_flags);
+		khugepaged_enter_vma(prev, vm_flags);
 		return prev;
 	}
 
@@ -1259,7 +1259,7 @@ struct vm_area_struct *vma_merge(struct
 		}
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(area, vm_flags);
+		khugepaged_enter_vma(area, vm_flags);
 		return area;
 	}
 
@@ -2477,7 +2477,7 @@ int expand_upwards(struct vm_area_struct
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	khugepaged_enter_vma_merge(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma, vma->vm_flags);
 	validate_mm(mm);
 	return error;
 }
@@ -2555,7 +2555,7 @@ int expand_downwards(struct vm_area_stru
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	khugepaged_enter_vma_merge(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma, vma->vm_flags);
 	validate_mm(mm);
 	return error;
 }
--- a/mm/shmem.c~mm-khugepaged-introduce-khugepaged_enter_vma-helper
+++ a/mm/shmem.c
@@ -2240,11 +2240,7 @@ static int shmem_mmap(struct file *file,
 
 	file_accessed(file);
 	vma->vm_ops = &shmem_vm_ops;
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-			((vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK) <
-			(vma->vm_end & HPAGE_PMD_MASK)) {
-		khugepaged_enter(vma, vma->vm_flags);
-	}
+	khugepaged_enter_vma(vma, vma->vm_flags);
 	return 0;
 }
 
@@ -4134,11 +4130,7 @@ int shmem_zero_setup(struct vm_area_stru
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
 
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-			((vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK) <
-			(vma->vm_end & HPAGE_PMD_MASK)) {
-		khugepaged_enter(vma, vma->vm_flags);
-	}
+	khugepaged_enter_vma(vma, vma->vm_flags);
 
 	return 0;
 }
_

Patches currently in -mm which might be from shy828301@gmail.com are

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

