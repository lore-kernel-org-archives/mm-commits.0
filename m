Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC073C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 22:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiD0XAq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238530AbiD0W5y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 18:57:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477858E186
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 15:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D357161E8C
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 22:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093DDC385A9;
        Wed, 27 Apr 2022 22:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651100030;
        bh=cy1W4OjaqAa0oomoT3JnXKjpM660eQNYPxrXHqKVDCI=;
        h=Date:To:From:Subject:From;
        b=X9ndRu/VC7e7XwsstrSJKJoSFhSYA1Qq/bWQ+d5bcEn5FKt2ItLO5CAqZ0mNQvY0I
         bv3UW0wOSG65oFLAl5GllW/yqvAYl1MBgCCE4G4jquSjnESRf2MawAr2P4Ct1ltCYc
         JPCHbEtT4nulgT4wdNfjqC8tp8w4lzHaeXE7XEBE=
Date:   Wed, 27 Apr 2022 15:53:49 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, song@kernel.org, riel@surriel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc.patch removed from -mm tree
Message-Id: <20220427225350.093DDC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: move some khugepaged_* functions to khugepaged.c
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: move some khugepaged_* functions to khugepaged.c

To reuse hugepage_vma_check() for khugepaged_enter() so that we could
remove some duplicate code.  But moving hugepage_vma_check() to
khugepaged.h needs to include huge_mm.h in it, it seems not optimal to
bloat khugepaged.h.

And the khugepaged_* functions actually are wrappers for some non-inline
functions, so it seems the benefits are not too much to keep them inline.

So move the khugepaged_* functions to khugepaged.c, any callers just need
to include khugepaged.h which is quite small.  For example, the following
patches will call khugepaged_enter() in filemap page fault path for
regular filesystems to make readonly FS THP collapse more consistent.  The
filemap.c just needs to include khugepaged.h.

Link: https://lkml.kernel.org/r/20220404200250.321455-7-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Song Liu <song@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h |   37 +++++------------------------------
 mm/khugepaged.c            |   20 ++++++++++++++++++
 2 files changed, 26 insertions(+), 31 deletions(-)

--- a/include/linux/khugepaged.h~mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc
+++ a/include/linux/khugepaged.h
@@ -2,10 +2,6 @@
 #ifndef _LINUX_KHUGEPAGED_H
 #define _LINUX_KHUGEPAGED_H
 
-#include <linux/sched/coredump.h> /* MMF_VM_HUGEPAGE */
-#include <linux/shmem_fs.h>
-
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern struct attribute_group khugepaged_attr_group;
 
@@ -16,6 +12,12 @@ extern void __khugepaged_enter(struct mm
 extern void __khugepaged_exit(struct mm_struct *mm);
 extern void khugepaged_enter_vma_merge(struct vm_area_struct *vma,
 				       unsigned long vm_flags);
+extern void khugepaged_fork(struct mm_struct *mm,
+			    struct mm_struct *oldmm);
+extern void khugepaged_exit(struct mm_struct *mm);
+extern void khugepaged_enter(struct vm_area_struct *vma,
+			     unsigned long vm_flags);
+
 extern void khugepaged_min_free_kbytes_update(void);
 #ifdef CONFIG_SHMEM
 extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr);
@@ -33,36 +35,9 @@ static inline void collapse_pte_mapped_t
 #define khugepaged_always()				\
 	(transparent_hugepage_flags &			\
 	 (1<<TRANSPARENT_HUGEPAGE_FLAG))
-#define khugepaged_req_madv()					\
-	(transparent_hugepage_flags &				\
-	 (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
 #define khugepaged_defrag()					\
 	(transparent_hugepage_flags &				\
 	 (1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG))
-
-static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
-{
-	if (test_bit(MMF_VM_HUGEPAGE, &oldmm->flags))
-		__khugepaged_enter(mm);
-}
-
-static inline void khugepaged_exit(struct mm_struct *mm)
-{
-	if (test_bit(MMF_VM_HUGEPAGE, &mm->flags))
-		__khugepaged_exit(mm);
-}
-
-static inline void khugepaged_enter(struct vm_area_struct *vma,
-				   unsigned long vm_flags)
-{
-	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
-		if ((khugepaged_always() ||
-		     (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) ||
-		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
-		    !(vm_flags & VM_NOHUGEPAGE) &&
-		    !test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-			__khugepaged_enter(vma->vm_mm);
-}
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
--- a/mm/khugepaged.c~mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc
+++ a/mm/khugepaged.c
@@ -556,6 +556,26 @@ void __khugepaged_exit(struct mm_struct
 	}
 }
 
+void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
+{
+	if (test_bit(MMF_VM_HUGEPAGE, &oldmm->flags))
+		__khugepaged_enter(mm);
+}
+
+void khugepaged_exit(struct mm_struct *mm)
+{
+	if (test_bit(MMF_VM_HUGEPAGE, &mm->flags))
+		__khugepaged_exit(mm);
+}
+
+void khugepaged_enter(struct vm_area_struct *vma, unsigned long vm_flags)
+{
+	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
+	    khugepaged_enabled())
+		if (hugepage_vma_check(vma, vm_flags))
+			__khugepaged_enter(vma->vm_mm);
+}
+
 static void release_pte_page(struct page *page)
 {
 	mod_node_page_state(page_pgdat(page),
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

