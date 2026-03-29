Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5F52571A0
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744964; cv=none; b=nP7WsjhhALPXoV4kuMVpQwZkxW7rmqdi7Mz/7AirBDrmF9cTzzy/Qa7GSVqYrT0ZBP+ZWwgQQFkbUDT39qQ5gud3LGvE+GbD00xCb8lADgLlVrmNLiDYOmKHgzY+syCZVHUNtY2pwaDBrcm9O141+pONvijKqASjaAbq8HVeNs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744964; c=relaxed/simple;
	bh=qzEFDKMK/xSahvV+0PED8Vcc8D5QsRqutpztMGSCAt0=;
	h=Date:To:From:Subject:Message-Id; b=Weyz+z1IssUAWA6WOxzXewvJuva9iL0qkDbtz7Ppo7M23xT9JZIMguXxXwxHsZcD4QKhg2Q+n4ExOJ0CxfYCvWZGIF44uc6CwZctiBFuD9DA5mcUw+to2oxGknGeMTEBcoL++z6wZBNOcNcX8qfENssOg1tFdn6POvkXnjhMcJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2oTR/bPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2oTR/bPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D02C4CEF7;
	Sun, 29 Mar 2026 00:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744963;
	bh=qzEFDKMK/xSahvV+0PED8Vcc8D5QsRqutpztMGSCAt0=;
	h=Date:To:From:Subject:From;
	b=2oTR/bPPTt6GBRRu3sk4AsaBgqgSzqrAHnMXl6h2deSGyeJzRnFDmz+wiWRhs1DVs
	 rKUd6d8mLeRvMLROF3ZBVI+mlKdEGC9XJVFiLIgpNqxZ2kL7nyqimtUOr/8DL5T0M2
	 Wc+aUMEhlgJRgdnZflOkTodu5hJqv4ovdvx8mEus=
Date: Sat, 28 Mar 2026 17:42:43 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-to-return-bool-for-pudp_test_and_clear_young.patch removed from -mm tree
Message-Id: <20260329004243.C5D02C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change to return bool for pudp_test_and_clear_young()
has been removed from the -mm tree.  Its filename was
     mm-change-to-return-bool-for-pudp_test_and_clear_young.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: change to return bool for pudp_test_and_clear_young()
Date: Sat, 21 Mar 2026 14:42:53 +0800

The pudp_test_and_clear_young() is used to clear the young flag, returning
whether the young flag was set for this PUD entry.  Change the return type
to bool to make the intention clearer.

Link: https://lkml.kernel.org/r/2c56fe52c1bf9404145274d7e91d4a65060f6c7c.1774075004.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |   10 +++++-----
 arch/powerpc/mm/book3s64/pgtable.c           |    4 ++--
 arch/riscv/include/asm/pgtable.h             |    4 ++--
 arch/x86/include/asm/pgtable.h               |    4 ++--
 arch/x86/mm/pgtable.c                        |    6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-change-to-return-bool-for-pudp_test_and_clear_young
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1172,13 +1172,13 @@ static inline bool __pmdp_test_and_clear
 	return ((old & _PAGE_ACCESSED) != 0);
 }
 
-static inline int __pudp_test_and_clear_young(struct mm_struct *mm,
-					      unsigned long addr, pud_t *pudp)
+static inline bool __pudp_test_and_clear_young(struct mm_struct *mm,
+		unsigned long addr, pud_t *pudp)
 {
 	unsigned long old;
 
 	if ((pud_raw(*pudp) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
-		return 0;
+		return false;
 	old = pud_hugepage_update(mm, addr, pudp, _PAGE_ACCESSED, 0);
 	return ((old & _PAGE_ACCESSED) != 0);
 }
@@ -1303,8 +1303,8 @@ extern int pudp_set_access_flags(struct
 bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp);
 #define __HAVE_ARCH_PUDP_TEST_AND_CLEAR_YOUNG
-extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long address, pud_t *pudp);
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp);
 
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
--- a/arch/powerpc/mm/book3s64/pgtable.c~mm-change-to-return-bool-for-pudp_test_and_clear_young
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -104,8 +104,8 @@ bool pmdp_test_and_clear_young(struct vm
 	return __pmdp_test_and_clear_young(vma->vm_mm, address, pmdp);
 }
 
-int pudp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long address, pud_t *pudp)
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp)
 {
 	return __pudp_test_and_clear_young(vma->vm_mm, address, pudp);
 }
--- a/arch/riscv/include/asm/pgtable.h~mm-change-to-return-bool-for-pudp_test_and_clear_young
+++ a/arch/riscv/include/asm/pgtable.h
@@ -1109,8 +1109,8 @@ static inline int pudp_set_access_flags(
 	return ptep_set_access_flags(vma, address, (pte_t *)pudp, pud_pte(entry), dirty);
 }
 
-static inline int pudp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address, pud_t *pudp)
+static inline bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp)
 {
 	return ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
 }
--- a/arch/x86/include/asm/pgtable.h~mm-change-to-return-bool-for-pudp_test_and_clear_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -1297,8 +1297,8 @@ extern int pudp_set_access_flags(struct
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp);
-extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
-				     unsigned long addr, pud_t *pudp);
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pudp);
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
 bool pmdp_clear_flush_young(struct vm_area_struct *vma,
--- a/arch/x86/mm/pgtable.c~mm-change-to-return-bool-for-pudp_test_and_clear_young
+++ a/arch/x86/mm/pgtable.c
@@ -470,10 +470,10 @@ bool pmdp_test_and_clear_young(struct vm
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-int pudp_test_and_clear_young(struct vm_area_struct *vma,
-			      unsigned long addr, pud_t *pudp)
+bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pudp)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if (pud_young(*pudp))
 		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

