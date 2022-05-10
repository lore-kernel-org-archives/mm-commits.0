Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E04C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 21:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiEJVKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 17:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiEJVKg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 17:10:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACD8293B67
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 14:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06BB66176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 21:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3FFC385CA;
        Tue, 10 May 2022 21:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652217034;
        bh=8FswODgLv4SlSIp9mTfiNVGayYyoyl5n2/c++4/cpvc=;
        h=Date:To:From:Subject:From;
        b=bMzG8PjcVkGq19xYjuuQJUJwSLVyrTEir0vg21SX9sp3P/UVPOrCNif96bMZszzTu
         3AXHrFAvkwZ7Hbtx9UrQWpFufQR2el/bN+Z/1UGnzqeIHZpUVIbYgFkUOTk6De8SBs
         xw2wW48i/rhxcTZBmdpNoTCZb/57VFoOFd70g7HQ=
Date:   Tue, 10 May 2022 14:10:33 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, songliubraving@fb.com,
        song@kernel.org, riel@surriel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch added to mm-unstable branch
Message-Id: <20220510211034.5E3FFC385CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: introduce khugepaged_enter_vma() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch

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
 mm/mmap.c                  |   12 ++++++------
 mm/shmem.c                 |   12 ++----------
 4 files changed, 15 insertions(+), 23 deletions(-)

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
@@ -1122,7 +1122,7 @@ struct vm_area_struct *vma_merge(struct
 					 end, prev->vm_pgoff, NULL, prev);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(prev, vm_flags);
+		khugepaged_enter_vma(prev, vm_flags);
 		return prev;
 	}
 
@@ -1149,7 +1149,7 @@ struct vm_area_struct *vma_merge(struct
 		}
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(area, vm_flags);
+		khugepaged_enter_vma(area, vm_flags);
 		return area;
 	}
 
@@ -2046,7 +2046,7 @@ int expand_upwards(struct vm_area_struct
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	khugepaged_enter_vma_merge(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma, vma->vm_flags);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -2127,7 +2127,7 @@ int expand_downwards(struct vm_area_stru
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	khugepaged_enter_vma_merge(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma, vma->vm_flags);
 	return error;
 }
 
@@ -2635,7 +2635,7 @@ unsigned long mmap_region(struct file *f
 	/* Actually expand, if possible */
 	if (vma &&
 	    !vma_expand(&mas, vma, merge_start, merge_end, vm_pgoff, next)) {
-		khugepaged_enter_vma_merge(vma, vm_flags);
+		khugepaged_enter_vma(vma, vm_flags);
 		goto expanded;
 	}
 
@@ -3051,7 +3051,7 @@ static int do_brk_flags(struct ma_state
 			anon_vma_interval_tree_post_update_vma(vma);
 			anon_vma_unlock_write(vma->anon_vma);
 		}
-		khugepaged_enter_vma_merge(vma, flags);
+		khugepaged_enter_vma(vma, flags);
 		goto out;
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

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-make-hugepage_vma_check-non-static.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

