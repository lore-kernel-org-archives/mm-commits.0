Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4AE1E8322
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 21:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751058725; cv=none; b=XvyHNS17Mwdn+gcrb8JDRGepJv6OrAi9byJ58MBJtY6H4lUuYs2+KP746fW7Zhz5/wVHJ+55cfTyktZ08i6kRPcqMus20jPpkPf0xsgM0qi2nDnQZ4PQojrGV0jAw51oIC/7XaJOTdvXGb4eCb7+jEMipddS+DzYBhSF/q7KDSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751058725; c=relaxed/simple;
	bh=Z8jDwY3PijRfj/17HCTkRtkqInZDhNkzQxEGK0CN75o=;
	h=Date:To:From:Subject:Message-Id; b=sxHCiY0iwg6/drkR8+f72Kq1LU9GYG+BtIYT2lRFLHodM0qE5CQ6fKqTOQ+GHYfo6jLKEeVR38tOaDv2FyXREf9aH2f9njpswTbvxsHA7ceqi4E2VfuLQGlN8aP9bARo3lyREL9vJrQInKxPhzQ7yRCjVUc2V6tAAoyU+AhhN9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Qx9Lvid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Qx9Lvid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04836C4CEE3;
	Fri, 27 Jun 2025 21:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751058725;
	bh=Z8jDwY3PijRfj/17HCTkRtkqInZDhNkzQxEGK0CN75o=;
	h=Date:To:From:Subject:From;
	b=2Qx9LvidNGIZvQ7y/BLuNhNfYMKx0lsCPaGRziF0YDzUdYOyue4sYxrC4sz52WjuF
	 xj66rGGULUx6fXMHp4xtBmm3YKYamLIVNrmrmzDgp4cmrea8cE+M6soIIdOmmW/irm
	 GlYyQiEDA7yqvM37sRfPOyzShvvyo6x3R96Sfk3Y=
Date: Fri, 27 Jun 2025 14:12:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,tsbogend@alpha.franken.de,pfalcato@suse.de,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jgg@nvidia.com,jannh@google.com,david@redhat.com,chenhuacai@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-prepare_hugepage_range.patch added to mm-new branch
Message-Id: <20250627211205.04836C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: remove prepare_hugepage_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-remove-prepare_hugepage_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-prepare_hugepage_range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: remove prepare_hugepage_range()
Date: Fri, 27 Jun 2025 12:07:07 -0400

Only mips and loongarch implemented this API, however what it does was
checking against stack overflow for either len or addr.  That's already
done in arch's arch_get_unmapped_area*() functions, even though it may not
be 100% identical checks.

For example, for both of the architectures, there will be a trivial
difference on how stack top was defined.  The old code uses STACK_TOP
which may be slightly smaller than TASK_SIZE on either of them, but the
hope is that shouldn't be a problem.

It means the whole API is pretty much obsolete at least now, remove it
completely.

Link: https://lkml.kernel.org/r/20250627160707.2124580-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/hugetlb.h |   14 --------------
 arch/mips/include/asm/hugetlb.h      |   14 --------------
 fs/hugetlbfs/inode.c                 |    8 ++------
 include/asm-generic/hugetlb.h        |    8 --------
 include/linux/hugetlb.h              |    6 ------
 5 files changed, 2 insertions(+), 48 deletions(-)

--- a/arch/loongarch/include/asm/hugetlb.h~mm-hugetlb-remove-prepare_hugepage_range
+++ a/arch/loongarch/include/asm/hugetlb.h
@@ -10,20 +10,6 @@
 
 uint64_t pmd_to_entrylo(unsigned long pmd_val);
 
-#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
-static inline int prepare_hugepage_range(struct file *file,
-					 unsigned long addr,
-					 unsigned long len)
-{
-	unsigned long task_size = STACK_TOP;
-
-	if (len > task_size)
-		return -ENOMEM;
-	if (task_size - len < addr)
-		return -EINVAL;
-	return 0;
-}
-
 #define __HAVE_ARCH_HUGE_PTE_CLEAR
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
 				  pte_t *ptep, unsigned long sz)
--- a/arch/mips/include/asm/hugetlb.h~mm-hugetlb-remove-prepare_hugepage_range
+++ a/arch/mips/include/asm/hugetlb.h
@@ -11,20 +11,6 @@
 
 #include <asm/page.h>
 
-#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
-static inline int prepare_hugepage_range(struct file *file,
-					 unsigned long addr,
-					 unsigned long len)
-{
-	unsigned long task_size = STACK_TOP;
-
-	if (len > task_size)
-		return -ENOMEM;
-	if (task_size - len < addr)
-		return -EINVAL;
-	return 0;
-}
-
 #define __HAVE_ARCH_HUGE_PTEP_GET_AND_CLEAR
 static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 					    unsigned long addr, pte_t *ptep,
--- a/fs/hugetlbfs/inode.c~mm-hugetlb-remove-prepare_hugepage_range
+++ a/fs/hugetlbfs/inode.c
@@ -179,12 +179,8 @@ hugetlb_get_unmapped_area(struct file *f
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
-	if (flags & MAP_FIXED) {
-		if (addr & ~huge_page_mask(h))
-			return -EINVAL;
-		if (prepare_hugepage_range(file, addr, len))
-			return -EINVAL;
-	}
+	if ((flags & MAP_FIXED) && (addr & ~huge_page_mask(h)))
+		return -EINVAL;
 	if (addr)
 		addr0 = ALIGN(addr, huge_page_size(h));
 
--- a/include/asm-generic/hugetlb.h~mm-hugetlb-remove-prepare_hugepage_range
+++ a/include/asm-generic/hugetlb.h
@@ -114,14 +114,6 @@ static inline int huge_pte_none_mostly(p
 }
 #endif
 
-#ifndef __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
-static inline int prepare_hugepage_range(struct file *file,
-		unsigned long addr, unsigned long len)
-{
-	return 0;
-}
-#endif
-
 #ifndef __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 		unsigned long addr, pte_t *ptep)
--- a/include/linux/hugetlb.h~mm-hugetlb-remove-prepare_hugepage_range
+++ a/include/linux/hugetlb.h
@@ -359,12 +359,6 @@ static inline void hugetlb_show_meminfo_
 {
 }
 
-static inline int prepare_hugepage_range(struct file *file,
-				unsigned long addr, unsigned long len)
-{
-	return -EINVAL;
-}
-
 static inline void hugetlb_vma_lock_read(struct vm_area_struct *vma)
 {
 }
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch
selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix.patch
mm-hugetlb-remove-prepare_hugepage_range.patch
mm-deduplicate-mm_get_unmapped_area.patch

