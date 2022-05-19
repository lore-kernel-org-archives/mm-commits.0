Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD26C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245427AbiESWZi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245436AbiESWZd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11551663C5
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FFFC616A0
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17B8C385AA;
        Thu, 19 May 2022 22:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999130;
        bh=/c5wi2fs0/RWi3G3244SNiRYOOeNUJsB8oxQ0oKbADY=;
        h=Date:To:From:Subject:From;
        b=WG6ROPA0i1ZYSly4sxo+MziVYT8QkXMQVnhtnhXHZnNy2BaIS657i0hLq86MGSEp4
         I+Yy5ICayKtJuw1IMq3HSXc1V7YOegxNGIDRNXAiqhfF0t+FA2XzmeVwjMK5mjm/Is
         +UgA5T8PnMDWLtIYPO064TN0hExwml8330GvX5cs=
Date:   Thu, 19 May 2022 15:25:30 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, songliubraving@fb.com,
        song@kernel.org, riel@surriel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-make-hugepage_vma_check-non-static.patch removed from -mm tree
Message-Id: <20220519222530.D17B8C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: khugepaged: make hugepage_vma_check() non-static
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-make-hugepage_vma_check-non-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: make hugepage_vma_check() non-static

The hugepage_vma_check() could be reused by khugepaged_enter() and
khugepaged_enter_vma_merge(), but it is static in khugepaged.c.  Make it
non-static and declare it in khugepaged.h.

Link: https://lkml.kernel.org/r/20220510203222.24246-7-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
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

 include/linux/khugepaged.h |   14 ++++++--------
 mm/khugepaged.c            |   25 +++++++++----------------
 2 files changed, 15 insertions(+), 24 deletions(-)

--- a/include/linux/khugepaged.h~mm-khugepaged-make-hugepage_vma_check-non-static
+++ a/include/linux/khugepaged.h
@@ -3,8 +3,6 @@
 #define _LINUX_KHUGEPAGED_H
 
 #include <linux/sched/coredump.h> /* MMF_VM_HUGEPAGE */
-#include <linux/shmem_fs.h>
-
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern struct attribute_group khugepaged_attr_group;
@@ -12,6 +10,8 @@ extern struct attribute_group khugepaged
 extern int khugepaged_init(void);
 extern void khugepaged_destroy(void);
 extern int start_stop_khugepaged(void);
+extern bool hugepage_vma_check(struct vm_area_struct *vma,
+			       unsigned long vm_flags);
 extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
 extern void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
@@ -55,13 +55,11 @@ static inline void khugepaged_exit(struc
 static inline void khugepaged_enter(struct vm_area_struct *vma,
 				   unsigned long vm_flags)
 {
-	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
-		if ((khugepaged_always() ||
-		     (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) ||
-		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
-		    !(vm_flags & VM_NOHUGEPAGE) &&
-		    !test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
+	    khugepaged_enabled()) {
+		if (hugepage_vma_check(vma, vm_flags))
 			__khugepaged_enter(vma->vm_mm);
+	}
 }
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
--- a/mm/khugepaged.c~mm-khugepaged-make-hugepage_vma_check-non-static
+++ a/mm/khugepaged.c
@@ -437,8 +437,8 @@ static inline int khugepaged_test_exit(s
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static bool hugepage_vma_check(struct vm_area_struct *vma,
-			       unsigned long vm_flags)
+bool hugepage_vma_check(struct vm_area_struct *vma,
+			unsigned long vm_flags)
 {
 	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
@@ -508,20 +508,13 @@ void __khugepaged_enter(struct mm_struct
 void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
 			       unsigned long vm_flags)
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
+	     (vma->vm_end & HPAGE_PMD_MASK))) {
+		if (hugepage_vma_check(vma, vm_flags))
+			__khugepaged_enter(vma->vm_mm);
+	}
 }
 
 void __khugepaged_exit(struct mm_struct *mm)
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch

