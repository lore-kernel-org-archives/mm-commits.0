Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C192213248
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450023; cv=none; b=f7wEfBLkIDcvQzvRGQ4kd9aTp3b1zZKsVLXsxz/U6jAc+QjykWTcD0JuMJa15hL49PUZNB1lK0wG/jwtPvsak1C+e0avumfwx8srymsNJSDms5aPfbGVFhfWsxft/i+KZTv/AmQesYiKUg3gmqW4hJ7t20HJqUuvGtJZi1OAozA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450023; c=relaxed/simple;
	bh=oDjAjEmqoSWoXIwv7hXEOn0W/IhFr+ULU5/G8/dHPJ8=;
	h=Date:To:From:Subject:Message-Id; b=d2sk6zCqmIUUBpCcsBl4KzjO+ya+7U6WZIYbnVJeisluKfuVgpIB71SX3b0MdMb/Nov6WnF4q0hRYfYXUxIJeRaz+vP5kSmCrdjE4g7Xvr3GqGr8F6aWjrco6l6KGacdgVwclDS6QtKfSssAHUJgtd7pEZIuY7anbevPKBIY1GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XkhJNGzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XkhJNGzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD83C4CEE3;
	Sun, 13 Jul 2025 23:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450023;
	bh=oDjAjEmqoSWoXIwv7hXEOn0W/IhFr+ULU5/G8/dHPJ8=;
	h=Date:To:From:Subject:From;
	b=XkhJNGzwos+jF09JJHfHld3xVvR55QFB6I2L/B6YHt0+c834KAY30RLT4u2dDI1AI
	 KRdIJaz2Fa4/rZOQnSADpf/Bvth4vFOHqTQzie2491ruKWaR0TG83e1TNHcMFD7XtJ
	 CuCCuC5XRWhdrxX4W4sVCpphTMx1AOpnCuq8226E=
Date: Sun, 13 Jul 2025 16:40:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,tsbogend@alpha.franken.de,pfalcato@suse.de,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jgg@nvidia.com,jannh@google.com,david@redhat.com,chenhuacai@kernel.org,anshuman.khandual@arm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-prepare_hugepage_range.patch removed from -mm tree
Message-Id: <20250713234023.0CD83C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove prepare_hugepage_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-prepare_hugepage_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
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


