Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7F4C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiGRARx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiGRARI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C914DB4A4
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DCB9B80EEC
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF31C3411E;
        Mon, 18 Jul 2022 00:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103423;
        bh=o+qFeArSSIHSAmHcq82w8gYJjnKHkjtG8F2kjD/I0gY=;
        h=Date:To:From:Subject:From;
        b=VpkNj4q77FOW4kZHnSa72vczJc7fvUfsblaehN+NnmRjXzbm90dD8J3BZofQ1Ebou
         3v68AU15Tq3NJUe9YevmEhY5ZsIabdjOz2ZpVgB08ZlXDWNT6clQ70xaXKoIin9eGi
         dxbjnoPlJf1bpRYVs4EvfuQDPVjmpXjzceWS9io0=
Date:   Sun, 17 Jul 2022 17:17:02 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-kill-__transhuge_page_enabled.patch removed from -mm tree
Message-Id: <20220718001703.2CF31C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: thp: kill __transhuge_page_enabled()
has been removed from the -mm tree.  Its filename was
     mm-thp-kill-__transhuge_page_enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: kill __transhuge_page_enabled()
Date: Thu, 16 Jun 2022 10:48:38 -0700

The page fault path checks THP eligibility with __transhuge_page_enabled()
which does the similar thing as hugepage_vma_check(), so use
hugepage_vma_check() instead.

However page fault allows DAX and !anon_vma cases, so added a new flag,
in_pf, to hugepage_vma_check() to make page fault work correctly.

The in_pf flag is also used to skip shmem and file THP for page fault
since shmem handles THP in its own shmem_fault() and file THP allocation
on fault is not supported yet.

Also remove hugepage_vma_enabled() since hugepage_vma_check() is the only
caller now, it is not necessary to have a helper function.

Link: https://lkml.kernel.org/r/20220616174840.1202070-6-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |    2 -
 include/linux/huge_mm.h |   57 +-------------------------------------
 mm/huge_memory.c        |   51 ++++++++++++++++++++++++++--------
 mm/khugepaged.c         |    8 ++---
 mm/memory.c             |    7 +++-
 5 files changed, 52 insertions(+), 73 deletions(-)

--- a/fs/proc/task_mmu.c~mm-thp-kill-__transhuge_page_enabled
+++ a/fs/proc/task_mmu.c
@@ -863,7 +863,7 @@ static int show_smap(struct seq_file *m,
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %d\n",
-		   hugepage_vma_check(vma, vma->vm_flags, true));
+		   hugepage_vma_check(vma, vma->vm_flags, true, false));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
--- a/include/linux/huge_mm.h~mm-thp-kill-__transhuge_page_enabled
+++ a/include/linux/huge_mm.h
@@ -146,48 +146,6 @@ static inline bool transhuge_vma_suitabl
 	return true;
 }
 
-static inline bool transhuge_vma_enabled(struct vm_area_struct *vma,
-					  unsigned long vm_flags)
-{
-	/* Explicitly disabled through madvise. */
-	if ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-		return false;
-	return true;
-}
-
-/*
- * to be used on vmas which are known to support THP.
- * Use transparent_hugepage_active otherwise
- */
-static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
-{
-
-	/*
-	 * If the hardware/firmware marked hugepage support disabled.
-	 */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_NEVER_DAX))
-		return false;
-
-	if (!transhuge_vma_enabled(vma, vma->vm_flags))
-		return false;
-
-	if (vma_is_temporary_stack(vma))
-		return false;
-
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
-		return true;
-
-	if (vma_is_dax(vma))
-		return true;
-
-	if (transparent_hugepage_flags &
-				(1 << TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
-		return !!(vma->vm_flags & VM_HUGEPAGE);
-
-	return false;
-}
-
 static inline bool file_thp_enabled(struct vm_area_struct *vma)
 {
 	struct inode *inode;
@@ -204,7 +162,7 @@ static inline bool file_thp_enabled(stru
 
 bool hugepage_vma_check(struct vm_area_struct *vma,
 			unsigned long vm_flags,
-			bool smaps);
+			bool smaps, bool in_pf);
 
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
@@ -348,26 +306,15 @@ static inline bool folio_test_pmd_mappab
 	return false;
 }
 
-static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
-{
-	return false;
-}
-
 static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
 		unsigned long addr)
 {
 	return false;
 }
 
-static inline bool transhuge_vma_enabled(struct vm_area_struct *vma,
-					  unsigned long vm_flags)
-{
-	return false;
-}
-
 static inline bool hugepage_vma_check(struct vm_area_struct *vma,
 				       unsigned long vm_flags,
-				       bool smaps)
+				       bool smaps, bool in_pf)
 {
 	return false;
 }
--- a/mm/huge_memory.c~mm-thp-kill-__transhuge_page_enabled
+++ a/mm/huge_memory.c
@@ -71,27 +71,53 @@ unsigned long huge_zero_pfn __read_mostl
 
 bool hugepage_vma_check(struct vm_area_struct *vma,
 			unsigned long vm_flags,
-			bool smaps)
+			bool smaps, bool in_pf)
 {
 	if (!vma->vm_mm)		/* vdso */
 		return false;
 
-	if (!transhuge_vma_enabled(vma, vm_flags))
+	/*
+	 * Explicitly disabled through madvise or prctl, or some
+	 * architectures may disable THP for some mappings, for
+	 * example, s390 kvm.
+	 * */
+	if ((vm_flags & VM_NOHUGEPAGE) ||
+	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 		return false;
-
-	if (vm_flags & VM_NO_KHUGEPAGED)
+	/*
+	 * If the hardware/firmware marked hugepage support disabled.
+	 */
+	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_NEVER_DAX))
 		return false;
 
-	/* Don't run khugepaged against DAX vma */
+	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
 	if (vma_is_dax(vma))
+		return in_pf;
+
+	/*
+	 * Special VMA and hugetlb VMA.
+	 * Must be checked after dax since some dax mappings may have
+	 * VM_MIXEDMAP set.
+	 */
+	if (vm_flags & VM_NO_KHUGEPAGED)
 		return false;
 
-	/* Check alignment for file vma and size for both file and anon vma */
-	if (!transhuge_vma_suitable(vma, (vma->vm_end - HPAGE_PMD_SIZE)))
+	/*
+	 * Check alignment for file vma and size for both file and anon vma.
+	 *
+	 * Skip the check for page fault. Huge fault does the check in fault
+	 * handlers. And this check is not suitable for huge PUD fault.
+	 */
+	if (!in_pf &&
+	    !transhuge_vma_suitable(vma, (vma->vm_end - HPAGE_PMD_SIZE)))
 		return false;
 
-	/* Enabled via shmem mount options or sysfs settings. */
-	if (shmem_file(vma->vm_file))
+	/*
+	 * Enabled via shmem mount options or sysfs settings.
+	 * Must be done before hugepage flags check since shmem has its
+	 * own flags.
+	 */
+	if (!in_pf && shmem_file(vma->vm_file))
 		return shmem_huge_enabled(vma);
 
 	if (!khugepaged_enabled())
@@ -102,7 +128,7 @@ bool hugepage_vma_check(struct vm_area_s
 		return false;
 
 	/* Only regular file is valid */
-	if (file_thp_enabled(vma))
+	if (!in_pf && file_thp_enabled(vma))
 		return true;
 
 	if (!vma_is_anonymous(vma))
@@ -114,9 +140,12 @@ bool hugepage_vma_check(struct vm_area_s
 	/*
 	 * THPeligible bit of smaps should show 1 for proper VMAs even
 	 * though anon_vma is not initialized yet.
+	 *
+	 * Allow page fault since anon_vma may be not initialized until
+	 * the first page fault.
 	 */
 	if (!vma->anon_vma)
-		return smaps;
+		return (smaps || in_pf);
 
 	return true;
 }
--- a/mm/khugepaged.c~mm-thp-kill-__transhuge_page_enabled
+++ a/mm/khugepaged.c
@@ -466,7 +466,7 @@ void khugepaged_enter_vma(struct vm_area
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    khugepaged_enabled()) {
-		if (hugepage_vma_check(vma, vm_flags, false))
+		if (hugepage_vma_check(vma, vm_flags, false, false))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -916,7 +916,7 @@ static int hugepage_vma_revalidate(struc
 
 	if (!transhuge_vma_suitable(vma, address))
 		return SCAN_ADDRESS_RANGE;
-	if (!hugepage_vma_check(vma, vma->vm_flags, false))
+	if (!hugepage_vma_check(vma, vma->vm_flags, false, false))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1401,7 +1401,7 @@ void collapse_pte_mapped_thp(struct mm_s
 	 * the valid THP. Add extra VM_HUGEPAGE so hugepage_vma_check()
 	 * will not fail the vma for missing VM_HUGEPAGE
 	 */
-	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE, false))
+	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE, false, false))
 		return;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2091,7 +2091,7 @@ static unsigned int khugepaged_scan_mm_s
 			progress++;
 			break;
 		}
-		if (!hugepage_vma_check(vma, vma->vm_flags, false)) {
+		if (!hugepage_vma_check(vma, vma->vm_flags, false, false)) {
 skip:
 			progress++;
 			continue;
--- a/mm/memory.c~mm-thp-kill-__transhuge_page_enabled
+++ a/mm/memory.c
@@ -4970,6 +4970,7 @@ static vm_fault_t __handle_mm_fault(stru
 		.gfp_mask = __get_fault_gfp_mask(vma),
 	};
 	struct mm_struct *mm = vma->vm_mm;
+	unsigned long vm_flags = vma->vm_flags;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	vm_fault_t ret;
@@ -4983,7 +4984,8 @@ static vm_fault_t __handle_mm_fault(stru
 	if (!vmf.pud)
 		return VM_FAULT_OOM;
 retry_pud:
-	if (pud_none(*vmf.pud) && __transparent_hugepage_enabled(vma)) {
+	if (pud_none(*vmf.pud) &&
+	    hugepage_vma_check(vma, vm_flags, false, true)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -5016,7 +5018,8 @@ retry_pud:
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
-	if (pmd_none(*vmf.pmd) && __transparent_hugepage_enabled(vma)) {
+	if (pmd_none(*vmf.pmd) &&
+	    hugepage_vma_check(vma, vm_flags, false, true)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch

