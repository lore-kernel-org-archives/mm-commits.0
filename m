Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CADCC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiGRARw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiGRARI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB07512AFC
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 767AD60F43
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA79C341C0;
        Mon, 18 Jul 2022 00:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103421;
        bh=/XUxO9xXtC6yFLIb2XZrzmejPXGlSc9GYShUWWSrZss=;
        h=Date:To:From:Subject:From;
        b=YCgfDnNPrh79H12TeJ8rx45Ry64Wh+cq9BZAIkWWXRHznXvkZEn9Q8G2G8Wf7beQV
         3u8uhC4w83wt3hyLP/u2WQcnmHVkaOhUzXrl3QjwPaAECiNBJrl7hqsHiCfexdqfRX
         2nUuqFxmdf24sSRtP/u4Tf5hfQeDOTDSJMkaULi0=
Date:   Sun, 17 Jul 2022 17:17:01 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-kill-transparent_hugepage_active.patch removed from -mm tree
Message-Id: <20220718001701.BAA79C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: thp: kill transparent_hugepage_active()
has been removed from the -mm tree.  Its filename was
     mm-thp-kill-transparent_hugepage_active.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: kill transparent_hugepage_active()
Date: Thu, 16 Jun 2022 10:48:37 -0700

The transparent_hugepage_active() was introduced to show THP eligibility
bit in smaps in proc, smaps is the only user.  But it actually does the
similar check as hugepage_vma_check() which is used by khugepaged.  We
definitely don't have to maintain two similar checks, so kill
transparent_hugepage_active().

This patch also fixed the wrong behavior for VM_NO_KHUGEPAGED vmas.

Also move hugepage_vma_check() to huge_memory.c and huge_mm.h since it
is not only for khugepaged anymore.

[akpm@linux-foundation.org: check vma->vm_mm, per Zach]
[akpm@linux-foundation.org: add comment to vdso check]
Link: https://lkml.kernel.org/r/20220616174840.1202070-5-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c         |    2 -
 include/linux/huge_mm.h    |   16 ++++++----
 include/linux/khugepaged.h |    2 -
 mm/huge_memory.c           |   53 +++++++++++++++++++++++++++++------
 mm/khugepaged.c            |   48 ++-----------------------------
 5 files changed, 59 insertions(+), 62 deletions(-)

--- a/fs/proc/task_mmu.c~mm-thp-kill-transparent_hugepage_active
+++ a/fs/proc/task_mmu.c
@@ -863,7 +863,7 @@ static int show_smap(struct seq_file *m,
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %d\n",
-		   transparent_hugepage_active(vma));
+		   hugepage_vma_check(vma, vma->vm_flags, true));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
--- a/include/linux/huge_mm.h~mm-thp-kill-transparent_hugepage_active
+++ a/include/linux/huge_mm.h
@@ -202,7 +202,9 @@ static inline bool file_thp_enabled(stru
 	       !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
-bool transparent_hugepage_active(struct vm_area_struct *vma);
+bool hugepage_vma_check(struct vm_area_struct *vma,
+			unsigned long vm_flags,
+			bool smaps);
 
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
@@ -351,11 +353,6 @@ static inline bool __transparent_hugepag
 	return false;
 }
 
-static inline bool transparent_hugepage_active(struct vm_area_struct *vma)
-{
-	return false;
-}
-
 static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
 		unsigned long addr)
 {
@@ -367,6 +364,13 @@ static inline bool transhuge_vma_enabled
 {
 	return false;
 }
+
+static inline bool hugepage_vma_check(struct vm_area_struct *vma,
+				       unsigned long vm_flags,
+				       bool smaps)
+{
+	return false;
+}
 
 static inline void prep_transhuge_page(struct page *page) {}
 
--- a/include/linux/khugepaged.h~mm-thp-kill-transparent_hugepage_active
+++ a/include/linux/khugepaged.h
@@ -10,8 +10,6 @@ extern struct attribute_group khugepaged
 extern int khugepaged_init(void);
 extern void khugepaged_destroy(void);
 extern int start_stop_khugepaged(void);
-extern bool hugepage_vma_check(struct vm_area_struct *vma,
-			       unsigned long vm_flags);
 extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
 extern void khugepaged_enter_vma(struct vm_area_struct *vma,
--- a/mm/huge_memory.c~mm-thp-kill-transparent_hugepage_active
+++ a/mm/huge_memory.c
@@ -69,21 +69,56 @@ static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 
-bool transparent_hugepage_active(struct vm_area_struct *vma)
+bool hugepage_vma_check(struct vm_area_struct *vma,
+			unsigned long vm_flags,
+			bool smaps)
 {
-	/* The addr is used to check if the vma size fits */
-	unsigned long addr = (vma->vm_end & HPAGE_PMD_MASK) - HPAGE_PMD_SIZE;
+	if (!vma->vm_mm)		/* vdso */
+		return false;
+
+	if (!transhuge_vma_enabled(vma, vm_flags))
+		return false;
+
+	if (vm_flags & VM_NO_KHUGEPAGED)
+		return false;
 
-	if (!transhuge_vma_suitable(vma, addr))
+	/* Don't run khugepaged against DAX vma */
+	if (vma_is_dax(vma))
 		return false;
-	if (vma_is_anonymous(vma))
-		return __transparent_hugepage_enabled(vma);
-	if (vma_is_shmem(vma))
+
+	/* Check alignment for file vma and size for both file and anon vma */
+	if (!transhuge_vma_suitable(vma, (vma->vm_end - HPAGE_PMD_SIZE)))
+		return false;
+
+	/* Enabled via shmem mount options or sysfs settings. */
+	if (shmem_file(vma->vm_file))
 		return shmem_huge_enabled(vma);
-	if (transhuge_vma_enabled(vma, vma->vm_flags) && file_thp_enabled(vma))
+
+	if (!khugepaged_enabled())
+		return false;
+
+	/* THP settings require madvise. */
+	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
+		return false;
+
+	/* Only regular file is valid */
+	if (file_thp_enabled(vma))
 		return true;
 
-	return false;
+	if (!vma_is_anonymous(vma))
+		return false;
+
+	if (vma_is_temporary_stack(vma))
+		return false;
+
+	/*
+	 * THPeligible bit of smaps should show 1 for proper VMAs even
+	 * though anon_vma is not initialized yet.
+	 */
+	if (!vma->anon_vma)
+		return smaps;
+
+	return true;
 }
 
 static bool get_huge_zero_page(void)
--- a/mm/khugepaged.c~mm-thp-kill-transparent_hugepage_active
+++ a/mm/khugepaged.c
@@ -430,46 +430,6 @@ static inline int khugepaged_test_exit(s
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-bool hugepage_vma_check(struct vm_area_struct *vma,
-			unsigned long vm_flags)
-{
-	if (!transhuge_vma_enabled(vma, vm_flags))
-		return false;
-
-	if (vm_flags & VM_NO_KHUGEPAGED)
-		return false;
-
-	/* Don't run khugepaged against DAX vma */
-	if (vma_is_dax(vma))
-		return false;
-
-	/* Check alignment for file vma and size for both file and anon vma */
-	if (!transhuge_vma_suitable(vma, (vma->vm_end - HPAGE_PMD_SIZE)))
-		return false;
-
-	/* Enabled via shmem mount options or sysfs settings. */
-	if (shmem_file(vma->vm_file))
-		return shmem_huge_enabled(vma);
-
-	if (!khugepaged_enabled())
-		return false;
-
-	/* THP settings require madvise. */
-	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
-		return false;
-
-	/* Only regular file is valid */
-	if (file_thp_enabled(vma))
-		return true;
-
-	if (!vma->anon_vma || !vma_is_anonymous(vma))
-		return false;
-	if (vma_is_temporary_stack(vma))
-		return false;
-
-	return true;
-}
-
 void __khugepaged_enter(struct mm_struct *mm)
 {
 	struct mm_slot *mm_slot;
@@ -506,7 +466,7 @@ void khugepaged_enter_vma(struct vm_area
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    khugepaged_enabled()) {
-		if (hugepage_vma_check(vma, vm_flags))
+		if (hugepage_vma_check(vma, vm_flags, false))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -956,7 +916,7 @@ static int hugepage_vma_revalidate(struc
 
 	if (!transhuge_vma_suitable(vma, address))
 		return SCAN_ADDRESS_RANGE;
-	if (!hugepage_vma_check(vma, vma->vm_flags))
+	if (!hugepage_vma_check(vma, vma->vm_flags, false))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1441,7 +1401,7 @@ void collapse_pte_mapped_thp(struct mm_s
 	 * the valid THP. Add extra VM_HUGEPAGE so hugepage_vma_check()
 	 * will not fail the vma for missing VM_HUGEPAGE
 	 */
-	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE))
+	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE, false))
 		return;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2131,7 +2091,7 @@ static unsigned int khugepaged_scan_mm_s
 			progress++;
 			break;
 		}
-		if (!hugepage_vma_check(vma, vma->vm_flags)) {
+		if (!hugepage_vma_check(vma, vma->vm_flags, false)) {
 skip:
 			progress++;
 			continue;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch

