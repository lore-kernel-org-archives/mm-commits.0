Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D92C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE07A6146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbhGABuU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhGABuU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7146961468;
        Thu,  1 Jul 2021 01:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104071;
        bh=Gejd49g/3PZP7EBCE7UH0eF7UTw+4D8cMEdYvAsz9Fs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=necjXPqNSulMiNg7K01BJXyjFxDkvWABAWhZsAWm9wP+/2EKRLvtW6T2NeLf6GtEm
         VOJZpXxf2TB5QLkvkKolufV4y/OAudUVGXnPPwceKzN7EPaVnREBfu48ki8kIfqp7z
         zDuJXcEW2/ljwaUHpihLmLZEtoSMia+sSP4dJa/w=
Date:   Wed, 30 Jun 2021 18:47:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        david@redhat.com, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, riel@surriel.com,
        shy828301@gmail.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 014/192] mm/huge_memory.c: add missing read-only
 THP checking in transparent_hugepage_enabled()
Message-ID: <20210701014750.ckJ1rS67A%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: add missing read-only THP checking in transparent_hugepage_enabled()

Since commit 99cb0dbd47a1 ("mm,thp: add read-only THP support for
(non-shmem) FS"), read-only THP file mapping is supported.  But it forgot
to add checking for it in transparent_hugepage_enabled().  To fix it, we
add checking for read-only THP file mapping and also introduce helper
transhuge_vma_enabled() to check whether thp is enabled for specified vma
to reduce duplicated code.  We rename transparent_hugepage_enabled to
transparent_hugepage_active to make the code easier to follow as suggested
by David Hildenbrand.

[linmiaohe@huawei.com: define transhuge_vma_enabled next to transhuge_vma_suitable]
  Link: https://lkml.kernel.org/r/20210514093007.4117906-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210511134857.1581273-4-linmiaohe@huawei.com
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |    2 -
 include/linux/huge_mm.h |   57 +++++++++++++++++++++++---------------
 mm/huge_memory.c        |   11 ++++++-
 mm/khugepaged.c         |    4 --
 mm/shmem.c              |    3 --
 5 files changed, 48 insertions(+), 29 deletions(-)

--- a/fs/proc/task_mmu.c~mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled
+++ a/fs/proc/task_mmu.c
@@ -832,7 +832,7 @@ static int show_smap(struct seq_file *m,
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %d\n",
-		   transparent_hugepage_enabled(vma));
+		   transparent_hugepage_active(vma));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
--- a/include/linux/huge_mm.h~mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled
+++ a/include/linux/huge_mm.h
@@ -115,9 +115,34 @@ extern struct kobj_attribute shmem_enabl
 
 extern unsigned long transparent_hugepage_flags;
 
+static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
+		unsigned long haddr)
+{
+	/* Don't have to check pgoff for anonymous vma */
+	if (!vma_is_anonymous(vma)) {
+		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
+				HPAGE_PMD_NR))
+			return false;
+	}
+
+	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
+		return false;
+	return true;
+}
+
+static inline bool transhuge_vma_enabled(struct vm_area_struct *vma,
+					  unsigned long vm_flags)
+{
+	/* Explicitly disabled through madvise. */
+	if ((vm_flags & VM_NOHUGEPAGE) ||
+	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+		return false;
+	return true;
+}
+
 /*
  * to be used on vmas which are known to support THP.
- * Use transparent_hugepage_enabled otherwise
+ * Use transparent_hugepage_active otherwise
  */
 static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
@@ -128,15 +153,12 @@ static inline bool __transparent_hugepag
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_NEVER_DAX))
 		return false;
 
-	if (vma->vm_flags & VM_NOHUGEPAGE)
+	if (!transhuge_vma_enabled(vma, vma->vm_flags))
 		return false;
 
 	if (vma_is_temporary_stack(vma))
 		return false;
 
-	if (test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-		return false;
-
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
 		return true;
 
@@ -150,22 +172,7 @@ static inline bool __transparent_hugepag
 	return false;
 }
 
-bool transparent_hugepage_enabled(struct vm_area_struct *vma);
-
-static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
-		unsigned long haddr)
-{
-	/* Don't have to check pgoff for anonymous vma */
-	if (!vma_is_anonymous(vma)) {
-		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR))
-			return false;
-	}
-
-	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
-		return false;
-	return true;
-}
+bool transparent_hugepage_active(struct vm_area_struct *vma);
 
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
@@ -352,7 +359,7 @@ static inline bool __transparent_hugepag
 	return false;
 }
 
-static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
+static inline bool transparent_hugepage_active(struct vm_area_struct *vma)
 {
 	return false;
 }
@@ -362,6 +369,12 @@ static inline bool transhuge_vma_suitabl
 {
 	return false;
 }
+
+static inline bool transhuge_vma_enabled(struct vm_area_struct *vma,
+					  unsigned long vm_flags)
+{
+	return false;
+}
 
 static inline void prep_transhuge_page(struct page *page) {}
 
--- a/mm/huge_memory.c~mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled
+++ a/mm/huge_memory.c
@@ -64,7 +64,14 @@ static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 
-bool transparent_hugepage_enabled(struct vm_area_struct *vma)
+static inline bool file_thp_enabled(struct vm_area_struct *vma)
+{
+	return transhuge_vma_enabled(vma, vma->vm_flags) && vma->vm_file &&
+	       !inode_is_open_for_write(vma->vm_file->f_inode) &&
+	       (vma->vm_flags & VM_EXEC);
+}
+
+bool transparent_hugepage_active(struct vm_area_struct *vma)
 {
 	/* The addr is used to check if the vma size fits */
 	unsigned long addr = (vma->vm_end & HPAGE_PMD_MASK) - HPAGE_PMD_SIZE;
@@ -75,6 +82,8 @@ bool transparent_hugepage_enabled(struct
 		return __transparent_hugepage_enabled(vma);
 	if (vma_is_shmem(vma))
 		return shmem_huge_enabled(vma);
+	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
+		return file_thp_enabled(vma);
 
 	return false;
 }
--- a/mm/khugepaged.c~mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled
+++ a/mm/khugepaged.c
@@ -442,9 +442,7 @@ static inline int khugepaged_test_exit(s
 static bool hugepage_vma_check(struct vm_area_struct *vma,
 			       unsigned long vm_flags)
 {
-	/* Explicitly disabled through madvise. */
-	if ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
 
 	/* Enabled via shmem mount options or sysfs settings. */
--- a/mm/shmem.c~mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled
+++ a/mm/shmem.c
@@ -4040,8 +4040,7 @@ bool shmem_huge_enabled(struct vm_area_s
 	loff_t i_size;
 	pgoff_t off;
 
-	if ((vma->vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+	if (!transhuge_vma_enabled(vma, vma->vm_flags))
 		return false;
 	if (shmem_huge == SHMEM_HUGE_FORCE)
 		return true;
_
