Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF89C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245348AbiESWZk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245437AbiESWZd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06581663C8
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97FCC6166C
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE14AC385B8;
        Thu, 19 May 2022 22:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999132;
        bh=hsmJAUGvPBTtf1t2QqwWXzsrBcr0rng3P1QPdyJkNNs=;
        h=Date:To:From:Subject:From;
        b=oe5J8G1+iicIbEe/++YzfWpcrXteZlWseg24wqIqj8EYJ6qfKKYQ6IX9NjmDC0V2A
         O2aRoOspf0qe+CCs28QbC40GdhYUi1+boWQqvOwlCkRS3DxpS0Oq+mbNwxLuHN4i3w
         ltx9O64F4rfyzqBBrZBIojPwna/Ne53TPnZLtDKw=
Date:   Thu, 19 May 2022 15:25:31 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, songliubraving@fb.com,
        song@kernel.org, riel@surriel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch removed from -mm tree
Message-Id: <20220519222531.EE14AC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: khugepaged: introduce khugepaged_enter_vma() helper
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: introduce khugepaged_enter_vma() helper

The khugepaged_enter_vma_merge() actually does as the same thing as the
khugepaged_enter() section called by shmem_mmap(), so consolidate them
into one helper and rename it to khugepaged_enter_vma().

Link: https://lkml.kernel.org/r/20220510203222.24246-8-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastmil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <song@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h |    8 ++++----
 mm/khugepaged.c            |    6 +++---
 mm/mmap.c                  |    8 ++++----
 mm/shmem.c                 |   12 ++----------
 4 files changed, 13 insertions(+), 21 deletions(-)

--- a/include/linux/khugepaged.h~mm-khugepaged-introduce-khugepaged_enter_vma-helper
+++ a/include/linux/khugepaged.h
@@ -14,8 +14,8 @@ extern bool hugepage_vma_check(struct vm
 			       unsigned long vm_flags);
 extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
-				       unsigned long vm_flags);
+extern void khugepaged_enter_vma(struct vm_area_struct *vma,
+				 unsigned long vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 #ifdef CONFIG_SHMEM
 extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr);
@@ -72,8 +72,8 @@ static inline void khugepaged_enter(stru
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
@@ -505,8 +505,8 @@ void __khugepaged_enter(struct mm_struct
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
-			       unsigned long vm_flags)
+void khugepaged_enter_vma(struct vm_area_struct *vma,
+			  unsigned long vm_flags)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    khugepaged_enabled() &&
--- a/mm/mmap.c~mm-khugepaged-introduce-khugepaged_enter_vma-helper
+++ a/mm/mmap.c
@@ -1223,7 +1223,7 @@ struct vm_area_struct *vma_merge(struct
 					 end, prev->vm_pgoff, NULL, prev);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(prev, vm_flags);
+		khugepaged_enter_vma(prev, vm_flags);
 		return prev;
 	}
 
@@ -1250,7 +1250,7 @@ struct vm_area_struct *vma_merge(struct
 		}
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(area, vm_flags);
+		khugepaged_enter_vma(area, vm_flags);
 		return area;
 	}
 
@@ -2450,7 +2450,7 @@ int expand_upwards(struct vm_area_struct
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	khugepaged_enter_vma_merge(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma, vma->vm_flags);
 	validate_mm(mm);
 	return error;
 }
@@ -2528,7 +2528,7 @@ int expand_downwards(struct vm_area_stru
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
@@ -2232,11 +2232,7 @@ static int shmem_mmap(struct file *file,
 
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
 
@@ -4137,11 +4133,7 @@ int shmem_zero_setup(struct vm_area_stru
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

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch

