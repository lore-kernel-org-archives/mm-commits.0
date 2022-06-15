Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1643BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 20:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344427AbiFOU0s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 16:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344239AbiFOU0i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 16:26:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA8A53C42
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 13:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE2BCB8216F
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 20:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361A3C3411A;
        Wed, 15 Jun 2022 20:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655324790;
        bh=MR7K0hA01YFnNVZEbMFIrTYpjCz00m0uUms9or1e9vk=;
        h=Date:To:From:Subject:From;
        b=xZ2zHB7da1QzX+v34xJmIP89M8/fPiHPxC6Yd3q657wHMIApvv5VjC/Z0Fw9DiUKq
         LwZt5T5y5RSk3eEYCgxUVui8/4ehCtCkGmLCYkTfuB51dlvs9eU0d6GFyB2rEWPfLf
         SpV38+0wc2XQo9vjs5v37++WA7I/bSxuSeCmr7kM=
Date:   Wed, 15 Jun 2022 13:26:29 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-kill-transparent_hugepage_active.patch added to mm-unstable branch
Message-Id: <20220615202630.361A3C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: kill transparent_hugepage_active()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-kill-transparent_hugepage_active.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-kill-transparent_hugepage_active.patch

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
Subject: mm: thp: kill transparent_hugepage_active()
Date: Wed, 15 Jun 2022 10:29:23 -0700

The transparent_hugepage_active() was introduced to show THP eligibility
bit in smaps in proc, smaps is the only user.  But it actually does the
similar check as hugepage_vma_check() which is used by khugepaged.  We
definitely don't have to maintain two similar checks, so kill
transparent_hugepage_active().

This patch also fixed the wrong behavior for VM_NO_KHUGEPAGED vmas.

Also move hugepage_vma_check() to huge_memory.c and huge_mm.h since it is
not only for khugepaged anymore.

Link: https://lkml.kernel.org/r/20220615172926.546974-5-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c         |    2 -
 include/linux/huge_mm.h    |   11 +++++++
 include/linux/khugepaged.h |    2 -
 mm/huge_memory.c           |   50 ++++++++++++++++++++++++++++-------
 mm/khugepaged.c            |   48 ++-------------------------------
 5 files changed, 56 insertions(+), 57 deletions(-)

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
@@ -367,6 +369,13 @@ static inline bool transhuge_vma_enabled
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
@@ -69,21 +69,53 @@ static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 
-bool transparent_hugepage_active(struct vm_area_struct *vma)
+bool hugepage_vma_check(struct vm_area_struct *vma,
+			unsigned long vm_flags,
+			bool smaps)
 {
-	/* The addr is used to check if the vma size fits */
-	unsigned long addr = (vma->vm_end & HPAGE_PMD_MASK) - HPAGE_PMD_SIZE;
+	if (!transhuge_vma_enabled(vma, vm_flags))
+		return false;
+
+	if (vm_flags & VM_NO_KHUGEPAGED)
+		return false;
+
+	/* Don't run khugepaged against DAX vma */
+	if (vma_is_dax(vma))
+		return false;
 
-	if (!transhuge_vma_suitable(vma, addr))
+	/* Check alignment for file vma and size for both file and anon vma */
+	if (!transhuge_vma_suitable(vma, (vma->vm_end - HPAGE_PMD_SIZE)))
 		return false;
-	if (vma_is_anonymous(vma))
-		return __transparent_hugepage_enabled(vma);
-	if (vma_is_shmem(vma))
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
@@ -952,7 +912,7 @@ static int hugepage_vma_revalidate(struc
 
 	if (!transhuge_vma_suitable(vma, address))
 		return SCAN_ADDRESS_RANGE;
-	if (!hugepage_vma_check(vma, vma->vm_flags))
+	if (!hugepage_vma_check(vma, vma->vm_flags, false))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1438,7 +1398,7 @@ void collapse_pte_mapped_thp(struct mm_s
 	 * the valid THP. Add extra VM_HUGEPAGE so hugepage_vma_check()
 	 * will not fail the vma for missing VM_HUGEPAGE
 	 */
-	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE))
+	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE, false))
 		return;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2132,7 +2092,7 @@ static unsigned int khugepaged_scan_mm_s
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

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch
mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch
mm-thp-consolidate-vma-size-check-to-transhuge_vma_suitable.patch
mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch
mm-thp-kill-transparent_hugepage_active.patch
mm-thp-kill-__transhuge_page_enabled.patch
mm-khugepaged-reorg-some-khugepaged-helpers.patch
doc-proc-fix-the-description-to-thpeligible.patch

