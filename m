Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DAA15B12F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854781; cv=none; b=C6mJTQwJ1cGUZKcaMyhBSmcu6GGWiEMFDIh4x0D3ApxRF+YTuLooYaj2FSAd24izF/OI3DBcoGwz6EeAfVyshFyc6PPlOGbNR7JbCFllbUd/izuhp5al5dnDG+pxn3Rl5hfGaU3pzCVNrK0gN+hLv3qWrnnjGyPv8rbgesagmys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854781; c=relaxed/simple;
	bh=goqunIumfiyQYqZNVtW2d17odhCILcAo6wuSh8sqtzI=;
	h=Date:To:From:Subject:Message-Id; b=poTWGFBC8ZzRWG1JyPzVNPjjt7xoLMrNbUHrQztHdB4pLyBufLMED+O0wgQEQPknXfP4y1bf2ecBrN9XKOtLPFHRPPQCb+oCmyer1Kxg4aNY6KSMzOkd4gZNC0hUETqgKM8gejRMSJ7AVMINSXdXiF6T8eDLMJR2GRBHFDActgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uf4802R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uf4802R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39822C4CECF;
	Wed,  6 Nov 2024 00:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854781;
	bh=goqunIumfiyQYqZNVtW2d17odhCILcAo6wuSh8sqtzI=;
	h=Date:To:From:Subject:From;
	b=Uf4802R3zZgmgX1TPTD2uIJxusYx3O2Vcl2Wq8ROK1zJEbR13xW4BOCW4EbGtfwSB
	 doxXanCohtuRnvYvk9M3e7xrxOYz2KIY2xhdCJlyJ1Nv74ppdPW1LB0he9yYnL7w8E
	 gjWhE4KNhsnvGgct0/biQ+irwIMysRdsiNZbUjYI=
Date: Tue, 05 Nov 2024 16:59:40 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch removed from -mm tree
Message-Id: <20241106005941.39822C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: consolidate common checks in hugetlb_get_unmapped_area
has been removed from the -mm tree.  Its filename was
     mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: remove now-unused local]
 Link: https://lore.kernel.org/oe-kbuild-all/202410081210.uNLbf3Jk-lkp@intel.com/
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
 arch/mips/include/asm/hugetlb.h      |    5 -----
 arch/parisc/include/asm/hugetlb.h    |   15 ---------------
 arch/s390/include/asm/hugetlb.h      |   17 -----------------
 arch/sh/include/asm/hugetlb.h        |   15 ---------------
 fs/hugetlbfs/inode.c                 |    8 ++++++--
 include/asm-generic/hugetlb.h        |    7 -------
 7 files changed, 6 insertions(+), 66 deletions(-)

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
@@ -17,12 +17,7 @@ static inline int prepare_hugepage_range
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


