Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B4BC433E0
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 20:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2736614A7
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 20:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhCBU6h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Mar 2021 15:58:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240251AbhCBA0x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Mar 2021 19:26:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6830160C40;
        Tue,  2 Mar 2021 00:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614644772;
        bh=ohXh7w8VGo7tM1qCdkLeFQN8yRPotLEL1zRg+87SCqU=;
        h=Date:From:To:Subject:From;
        b=Pz/xvZV73zot7dUPC4sjoqFblEI4aZAIVrVre96mMCqSgSNu2cuAHBoOMTlpfKwOM
         /dKaMwiwv75ETESIT/7Btlnaz1gV3F3/pPvI1J6Kp7qnCtDbQuZaZCsWXp/T8hjOie
         SGFGEBAE7IR0UjvojUgX0oaNOb6RMW80PuOQ8CJI=
Date:   Mon, 01 Mar 2021 16:26:10 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, adobriyan@gmail.com, almasrymina@google.com,
        anshuman.khandual@arm.com, axelrasmussen@google.com,
        cannonmatthews@google.com, catalin.marinas@arm.com,
        chinwen.chang@mediatek.com, dgilbert@redhat.com, jannh@google.com,
        jglisse@redhat.com, kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mingo@redhat.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        oupton@google.com, peterx@redhat.com, rientjes@google.com,
        rostedt@goodmis.org, rppt@linux.vnet.ibm.com, ruprecht@google.com,
        shawn@anastas.io, shli@fb.com, steven.price@arm.com,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, walken@google.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  +
 hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch added
 to -mm tree
Message-ID: <20210302002610.j36GHEBey%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/userfaultfd: forbid huge pmd sharing when uffd enabled
has been added to the -mm tree.  Its filename is
     hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: hugetlb/userfaultfd: forbid huge pmd sharing when uffd enabled

Huge pmd sharing could bring problem to userfaultfd.  The thing is that
userfaultfd is running its logic based on the special bits on page table
entries, however the huge pmd sharing could potentially share page table
entries for different address ranges.  That could cause issues on either:

  - When sharing huge pmd page tables for an uffd write protected range, the
    newly mapped huge pmd range will also be write protected unexpectedly, or,

  - When we try to write protect a range of huge pmd shared range, we'll first
    do huge_pmd_unshare() in hugetlb_change_protection(), however that also
    means the UFFDIO_WRITEPROTECT could be silently skipped for the shared
    region, which could lead to data loss.

Since at it, a few other things are done altogether:

  - Move want_pmd_share() from mm/hugetlb.c into linux/hugetlb.h, because
    that's definitely something that arch code would like to use too

  - ARM64 currently directly check against CONFIG_ARCH_WANT_HUGE_PMD_SHARE when
    trying to share huge pmd.  Switch to the want_pmd_share() helper.

Since at it, move vma_shareable() from huge_pmd_share() into want_pmd_share().

Link: https://lkml.kernel.org/r/20210218231202.15426-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Adam Ruprecht <ruprecht@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michal Koutn" <mkoutny@suse.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shawn Anastasio <shawn@anastas.io>
Cc: Steven Price <steven.price@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c   |    3 +--
 include/linux/hugetlb.h       |    2 ++
 include/linux/userfaultfd_k.h |    9 +++++++++
 mm/hugetlb.c                  |   20 ++++++++++++++------
 4 files changed, 26 insertions(+), 8 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -284,8 +284,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 		 */
 		ptep = pte_alloc_map(mm, pmdp, addr);
 	} else if (sz == PMD_SIZE) {
-		if (IS_ENABLED(CONFIG_ARCH_WANT_HUGE_PMD_SHARE) &&
-		    pud_none(READ_ONCE(*pudp)))
+		if (want_pmd_share(vma, addr) && pud_none(READ_ONCE(*pudp)))
 			ptep = huge_pmd_share(mm, vma, addr, pudp);
 		else
 			ptep = (pte_t *)pmd_alloc(mm, pudp, addr);
--- a/include/linux/hugetlb.h~hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled
+++ a/include/linux/hugetlb.h
@@ -1040,4 +1040,6 @@ static inline __init void hugetlb_cma_ch
 }
 #endif
 
+bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr);
+
 #endif /* _LINUX_HUGETLB_H */
--- a/include/linux/userfaultfd_k.h~hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled
+++ a/include/linux/userfaultfd_k.h
@@ -52,6 +52,15 @@ static inline bool is_mergeable_vm_userf
 	return vma->vm_userfaultfd_ctx.ctx == vm_ctx.ctx;
 }
 
+/*
+ * Never enable huge pmd sharing on uffd-wp registered vmas, because uffd-wp
+ * protect information is per pgtable entry.
+ */
+static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & VM_UFFD_WP;
+}
+
 static inline bool userfaultfd_missing(struct vm_area_struct *vma)
 {
 	return vma->vm_flags & VM_UFFD_MISSING;
--- a/mm/hugetlb.c~hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled
+++ a/mm/hugetlb.c
@@ -5234,6 +5234,18 @@ static bool vma_shareable(struct vm_area
 	return false;
 }
 
+bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
+{
+#ifndef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+	return false;
+#endif
+#ifdef CONFIG_USERFAULTFD
+	if (uffd_disable_huge_pmd_share(vma))
+		return false;
+#endif
+	return vma_shareable(vma, addr);
+}
+
 /*
  * Determine if start,end range within vma could be mapped by shared pmd.
  * If yes, adjust start and end to cover range associated with possible
@@ -5290,9 +5302,6 @@ pte_t *huge_pmd_share(struct mm_struct *
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (!vma_shareable(vma, addr))
-		return (pte_t *)pmd_alloc(mm, pud, addr);
-
 	i_mmap_assert_locked(mapping);
 	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
@@ -5356,7 +5365,7 @@ int huge_pmd_unshare(struct mm_struct *m
 	*addr = ALIGN(*addr, HPAGE_SIZE * PTRS_PER_PTE) - HPAGE_SIZE;
 	return 1;
 }
-#define want_pmd_share()	(1)
+
 #else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct vma,
 		      unsigned long addr, pud_t *pud)
@@ -5374,7 +5383,6 @@ void adjust_range_if_pmd_sharing_possibl
 				unsigned long *start, unsigned long *end)
 {
 }
-#define want_pmd_share()	(0)
 #endif /* CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
 
 #ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
@@ -5396,7 +5404,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 			pte = (pte_t *)pud;
 		} else {
 			BUG_ON(sz != PMD_SIZE);
-			if (want_pmd_share() && pud_none(*pud))
+			if (want_pmd_share(vma, addr) && pud_none(*pud))
 				pte = huge_pmd_share(mm, vma, addr, pud);
 			else
 				pte = (pte_t *)pmd_alloc(mm, pud, addr);
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch

