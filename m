Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD30280A56
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744962; cv=none; b=Jk77UlorYK8/cMsKSrC5zRPJxA/1S3OMATVDGM44N+IYsnHmCWu38qL8u6RzoyylAOC3BiFV0plYZbCzLQnBwDwEh7dWg1ZA4yI993LozwXJnpcg6kmfSSx2H6pzXUkA3qmr2IqdoSuV7pToY8v5g/EXRx/detz3riEOu7JGUGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744962; c=relaxed/simple;
	bh=LgTvnbOP6DcIcF6U4yzbTNXuSrcTpMYlHNlzEdfQW2o=;
	h=Date:To:From:Subject:Message-Id; b=sZppbU6YRfRUUPFMzAOjMIp6cBam64QqGNEpBnCjmokRb5Xy94NlxULAJJcg+JkDQ7HgYwwRYzW052brRRkj2EpUZJ6cDjPdtjea92fVR93ZbG2fvEAjY02yIr6lIStPD7irqRetU1XnKiiDHZz3w8OMLubrEoQRTkf0y/EK4Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uXS/qY9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uXS/qY9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4C2C4CEF7;
	Sun, 29 Mar 2026 00:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744962;
	bh=LgTvnbOP6DcIcF6U4yzbTNXuSrcTpMYlHNlzEdfQW2o=;
	h=Date:To:From:Subject:From;
	b=uXS/qY9LI0W7m0mM5nQAXK+1xJtMT1GXOY7RKDDhG1sLMx9jNrl2mIMm8AKsh6h7P
	 aX9zNokXPi3GioKW8gB/qsKcWFAge2ClM8a83bAdC8ofzwpPVJYdNtqaqzp0h2RvEE
	 tiANELYa1ATkHlArJZhYi9BmPCHvtH+9U01BigyI=
Date: Sat, 28 Mar 2026 17:42:42 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-to-return-bool-for-pmdp_clear_flush_young.patch removed from -mm tree
Message-Id: <20260329004242.8C4C2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change to return bool for pmdp_clear_flush_young()
has been removed from the -mm tree.  Its filename was
     mm-change-to-return-bool-for-pmdp_clear_flush_young.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: change to return bool for pmdp_clear_flush_young()
Date: Sat, 21 Mar 2026 14:42:52 +0800

The pmdp_clear_flush_young() is used to clear the young flag and flush the
TLB, returning whether the young flag was set for this PMD entry.  Change
the return type to bool to make the intention clearer.

Link: https://lkml.kernel.org/r/a668b9a974c0d675e7a41f6973bcbe3336e8b373.1774075004.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    4 ++--
 arch/x86/include/asm/pgtable.h  |    4 ++--
 arch/x86/mm/pgtable.c           |    6 +++---
 include/linux/pgtable.h         |   10 +++++-----
 mm/pgtable-generic.c            |    7 ++++---
 5 files changed, 16 insertions(+), 15 deletions(-)

--- a/arch/s390/include/asm/pgtable.h~mm-change-to-return-bool-for-pmdp_clear_flush_young
+++ a/arch/s390/include/asm/pgtable.h
@@ -1693,8 +1693,8 @@ static inline bool pmdp_test_and_clear_y
 }
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long addr, pmd_t *pmdp)
+static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
 {
 	VM_BUG_ON(addr & ~HPAGE_MASK);
 	return pmdp_test_and_clear_young(vma, addr, pmdp);
--- a/arch/x86/include/asm/pgtable.h~mm-change-to-return-bool-for-pmdp_clear_flush_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -1301,8 +1301,8 @@ extern int pudp_test_and_clear_young(str
 				     unsigned long addr, pud_t *pudp);
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pmd_t *pmdp);
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp);
 
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
--- a/arch/x86/mm/pgtable.c~mm-change-to-return-bool-for-pmdp_clear_flush_young
+++ a/arch/x86/mm/pgtable.c
@@ -503,10 +503,10 @@ bool ptep_clear_flush_young(struct vm_ar
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-int pmdp_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pmd_t *pmdp)
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
-	int young;
+	bool young;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
--- a/include/linux/pgtable.h~mm-change-to-return-bool-for-pmdp_clear_flush_young
+++ a/include/linux/pgtable.h
@@ -536,18 +536,18 @@ bool ptep_clear_flush_young(struct vm_ar
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pmd_t *pmdp);
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp);
 #else
 /*
  * Despite relevant to THP only, this API is called from generic rmap code
  * under PageTransHuge(), hence needs a dummy implementation for !THP
  */
-static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long address, pmd_t *pmdp)
+static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	BUILD_BUG();
-	return 0;
+	return false;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
--- a/mm/pgtable-generic.c~mm-change-to-return-bool-for-pmdp_clear_flush_young
+++ a/mm/pgtable-generic.c
@@ -124,10 +124,11 @@ int pmdp_set_access_flags(struct vm_area
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-int pmdp_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pmd_t *pmdp)
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
-	int young;
+	bool young;
+
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	young = pmdp_test_and_clear_young(vma, address, pmdp);
 	if (young)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

