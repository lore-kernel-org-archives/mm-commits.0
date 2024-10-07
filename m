Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A4C189BBD
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 21:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728335271; cv=none; b=KUA6XwfiZf7sHCtirhrX1RrdZt6eZcuwnyU3Lg5KvD01eb5b0arTyrMupyrdPIp+63dYSKLuAt/PgDvI8CJ2rFLRlzjvcObA68dCpCyJiLQsUs+yEV+kGwmfHognjaIAlhEb0z/ugMSJWFMwU6yMljXOude9pqTQv08hSSv3wHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728335271; c=relaxed/simple;
	bh=liYRdgG3szBE64mFBbxSczLYoFTzQOnH19CyZfrcEuw=;
	h=Date:To:From:Subject:Message-Id; b=eUY5gXGJ8Lqh0zbE2qMPS2t3Ztlj3vID0JTPgrCKmiysVHQfydPiKEb0qHy02qkGv4vGVXB6g9maDp4qqLQ+YwiLZRUHtwLQVo4TLuG2+Bk8qy726z6ld+i94J/jqEKiR7eFIbBHYb1syEoxNfDXUQFE5PBZC9swH9SiJocIZng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RED1gCx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RED1gCx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55727C4CEC6;
	Mon,  7 Oct 2024 21:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728335271;
	bh=liYRdgG3szBE64mFBbxSczLYoFTzQOnH19CyZfrcEuw=;
	h=Date:To:From:Subject:From;
	b=RED1gCx7koWU3b+JOwwHAyoOTkplkoYghxVfLQ8fcd3Vl/ZcVPnwJGvqZweYJxiVp
	 R+6WYa4WUw9AdqC7e89sOPP+vHbmv4Ue5MZ2bJ2ePkufNwX1/8MCXmEOs2PrXYxHDj
	 ElMpxPAG+q//IDBd/hE2OR9chUKHzQr+O/Zj0cOo=
Date: Mon, 07 Oct 2024 14:07:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch added to mm-unstable branch
Message-Id: <20241007210751.55727C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: consolidate common checks in hugetlb_get_unmapped_area
has been added to the -mm mm-unstable branch.  Its filename is
     mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm: consolidate common checks in hugetlb_get_unmapped_area
Date: Mon, 7 Oct 2024 09:50:37 +0200

prepare_hugepage_range() performs almost the same checks for all
architectures that define it, with the exception of mips and loongarch
that also check for overflows.

The rest checks for the addr and len to be properly aligned, so we can
move that to hugetlb_get_unmapped_area() and get rid of a fair amount of
duplicated code.

Link: https://lkml.kernel.org/r/20241007075037.267650-10-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/hugetlb.h |    5 -----
 arch/mips/include/asm/hugetlb.h      |    4 ----
 arch/parisc/include/asm/hugetlb.h    |   15 ---------------
 arch/s390/include/asm/hugetlb.h      |   17 -----------------
 arch/sh/include/asm/hugetlb.h        |   15 ---------------
 fs/hugetlbfs/inode.c                 |    8 ++++++--
 include/asm-generic/hugetlb.h        |    7 -------
 7 files changed, 6 insertions(+), 65 deletions(-)

--- a/arch/loongarch/include/asm/hugetlb.h~mm-consolidate-common-checks-in-hugetlb_get_unmapped_area
+++ a/arch/loongarch/include/asm/hugetlb.h
@@ -16,12 +16,7 @@ static inline int prepare_hugepage_range
 					 unsigned long len)
 {
 	unsigned long task_size = STACK_TOP;
-	struct hstate *h = hstate_file(file);
 
-	if (len & ~huge_page_mask(h))
-		return -EINVAL;
-	if (addr & ~huge_page_mask(h))
-		return -EINVAL;
 	if (len > task_size)
 		return -ENOMEM;
 	if (task_size - len < addr)
--- a/arch/mips/include/asm/hugetlb.h~mm-consolidate-common-checks-in-hugetlb_get_unmapped_area
+++ a/arch/mips/include/asm/hugetlb.h
@@ -19,10 +19,6 @@ static inline int prepare_hugepage_range
 	unsigned long task_size = STACK_TOP;
 	struct hstate *h = hstate_file(file);
 
-	if (len & ~huge_page_mask(h))
-		return -EINVAL;
-	if (addr & ~huge_page_mask(h))
-		return -EINVAL;
 	if (len > task_size)
 		return -ENOMEM;
 	if (task_size - len < addr)
--- a/arch/parisc/include/asm/hugetlb.h~mm-consolidate-common-checks-in-hugetlb_get_unmapped_area
+++ a/arch/parisc/include/asm/hugetlb.h
@@ -12,21 +12,6 @@ void set_huge_pte_at(struct mm_struct *m
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep);
 
-/*
- * If the arch doesn't supply something else, assume that hugepage
- * size aligned regions are ok without further preparation.
- */
-#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
-static inline int prepare_hugepage_range(struct file *file,
-			unsigned long addr, unsigned long len)
-{
-	if (len & ~HPAGE_MASK)
-		return -EINVAL;
-	if (addr & ~HPAGE_MASK)
-		return -EINVAL;
-	return 0;
-}
-
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
--- a/arch/s390/include/asm/hugetlb.h~mm-consolidate-common-checks-in-hugetlb_get_unmapped_area
+++ a/arch/s390/include/asm/hugetlb.h
@@ -25,23 +25,6 @@ extern pte_t huge_ptep_get(struct mm_str
 extern pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 			      unsigned long addr, pte_t *ptep);
 
-/*
- * If the arch doesn't supply something else, assume that hugepage
- * size aligned regions are ok without further preparation.
- */
-#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
-static inline int prepare_hugepage_range(struct file *file,
-			unsigned long addr, unsigned long len)
-{
-	struct hstate *h = hstate_file(file);
-
-	if (len & ~huge_page_mask(h))
-		return -EINVAL;
-	if (addr & ~huge_page_mask(h))
-		return -EINVAL;
-	return 0;
-}
-
 static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
 	clear_bit(PG_arch_1, &folio->flags);
--- a/arch/sh/include/asm/hugetlb.h~mm-consolidate-common-checks-in-hugetlb_get_unmapped_area
+++ a/arch/sh/include/asm/hugetlb.h
@@ -5,21 +5,6 @@
 #include <asm/cacheflush.h>
 #include <asm/page.h>
 
-/*
- * If the arch doesn't supply something else, assume that hugepage
- * size aligned regions are ok without further preparation.
- */
-#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
-static inline int prepare_hugepage_range(struct file *file,
-			unsigned long addr, unsigned long len)
-{
-	if (len & ~HPAGE_MASK)
-		return -EINVAL;
-	if (addr & ~HPAGE_MASK)
-		return -EINVAL;
-	return 0;
-}
-
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
--- a/fs/hugetlbfs/inode.c~mm-consolidate-common-checks-in-hugetlb_get_unmapped_area
+++ a/fs/hugetlbfs/inode.c
@@ -181,8 +181,12 @@ hugetlb_get_unmapped_area(struct file *f
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
-	if ((flags & MAP_FIXED) && prepare_hugepage_range(file, addr, len))
-		return -EINVAL;
+	if (flags & MAP_FIXED) {
+		if (addr & ~huge_page_mask(h))
+			return -EINVAL;
+		if (prepare_hugepage_range(file, addr, len))
+			return -EINVAL;
+	}
 	if (addr)
 		addr0 = ALIGN(addr, huge_page_size(h));
 
--- a/include/asm-generic/hugetlb.h~mm-consolidate-common-checks-in-hugetlb_get_unmapped_area
+++ a/include/asm-generic/hugetlb.h
@@ -123,13 +123,6 @@ static inline int huge_pte_none_mostly(p
 static inline int prepare_hugepage_range(struct file *file,
 		unsigned long addr, unsigned long len)
 {
-	struct hstate *h = hstate_file(file);
-
-	if (len & ~huge_page_mask(h))
-		return -EINVAL;
-	if (addr & ~huge_page_mask(h))
-		return -EINVAL;
-
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch
arch-sparc-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch
mm-drop-hugetlb_get_unmapped_area_-functions.patch
arch-s390-clean-up-hugetlb-definitions.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch

