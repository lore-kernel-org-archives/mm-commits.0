Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4649513AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744960; cv=none; b=PWsIZJKJQ3I9SZgSoSxz4OXhDQgA0ZHU1w7LgQps4IOheDhL5+r+5/O89HvrPC3/1yC3bkOMsUF05uv0OEdG8Fct7qrs4PK6vbQ53cezDdu5Q0IBvMcOYYmsEdUHOYLbhu6Rx/N2iktJxsF7lbi7j/fqfiSgYPGZ0AkCr0+jHLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744960; c=relaxed/simple;
	bh=ZCos2a5ikWLbv0FqFuGpiwSV+I2nVUHejSnPjctO8+4=;
	h=Date:To:From:Subject:Message-Id; b=YOZVisGiq30oT9ju+KmdbWygEh3y9cZdvfIVPQwkVkV7oEQ6ulYX9axUPjaG/qst6ZrqgZGWefZI4RdlbhxUBC6sA2drjgiKNRdTLOpe3E1zmU4ALtj2le0WEFbsAgZbZfv86HZ8flD+QjSE7pWgv9qOuOUoE+uNjpWZOyqGbds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ictcdzp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ictcdzp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D95FC4CEF7;
	Sun, 29 Mar 2026 00:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744960;
	bh=ZCos2a5ikWLbv0FqFuGpiwSV+I2nVUHejSnPjctO8+4=;
	h=Date:To:From:Subject:From;
	b=ictcdzp+2ANJRXcocWeNSDbqgNP1c7Aoki83UPK2Fd1GTkAhpUkt3GSu1qyeEBMAg
	 1hAYgqy5htGEnrYf9bOBuSeZu6vOVeWbc7IbFLgZD2w1xJutg6wrQlUIcwIu9dzjYa
	 MGi1prW8LFt0UqArTICZdrJYF6fr9hF8+RfSrXfk=
Date: Sat, 28 Mar 2026 17:42:39 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes.patch removed from -mm tree
Message-Id: <20260329004240.1D95FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change to return bool for ptep_clear_flush_young()/clear_flush_young_ptes()
has been removed from the -mm tree.  Its filename was
     mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: change to return bool for ptep_clear_flush_young()/clear_flush_young_ptes()
Date: Sat, 21 Mar 2026 14:42:50 +0800

The ptep_clear_flush_young() and clear_flush_young_ptes() are used to
clear the young flag and flush the TLB, returning whether the young flag
was set.  Change the return type to bool to make the intention clearer.

Link: https://lkml.kernel.org/r/24af5144b96103631594501f77d4525f2475c1be.1774075004.git.baolin.wang@linux.alibaba.com
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

 arch/arm64/include/asm/pgtable.h             |   17 ++++++++---------
 arch/arm64/mm/contpte.c                      |    7 +++----
 arch/parisc/include/asm/pgtable.h            |    2 +-
 arch/parisc/kernel/cache.c                   |    8 ++++----
 arch/powerpc/include/asm/nohash/64/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h             |    4 ++--
 arch/s390/include/asm/pgtable.h              |    4 ++--
 arch/x86/include/asm/pgtable.h               |    4 ++--
 arch/x86/mm/pgtable.c                        |    4 ++--
 include/linux/pgtable.h                      |    8 ++++----
 mm/pgtable-generic.c                         |    7 ++++---
 11 files changed, 33 insertions(+), 34 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1298,10 +1298,10 @@ static inline bool __ptep_test_and_clear
 	return pte_young(pte);
 }
 
-static inline int __ptep_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long address, pte_t *ptep)
+static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
-	int young = __ptep_test_and_clear_young(vma, address, ptep);
+	bool young = __ptep_test_and_clear_young(vma, address, ptep);
 
 	if (young) {
 		/*
@@ -1647,7 +1647,7 @@ extern pte_t contpte_get_and_clear_full_
 				unsigned int nr, int full);
 bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep, unsigned int nr);
-int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
+bool contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep, unsigned int nr);
 extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr);
@@ -1829,8 +1829,8 @@ static inline bool ptep_test_and_clear_y
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep)
+static inline bool ptep_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	pte_t orig_pte = __ptep_get(ptep);
 
@@ -1841,9 +1841,8 @@ static inline int ptep_clear_flush_young
 }
 
 #define clear_flush_young_ptes clear_flush_young_ptes
-static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
-					 unsigned long addr, pte_t *ptep,
-					 unsigned int nr)
+static inline bool clear_flush_young_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
 		return __ptep_clear_flush_young(vma, addr, ptep);
--- a/arch/arm64/mm/contpte.c~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/arch/arm64/mm/contpte.c
@@ -534,11 +534,10 @@ bool contpte_test_and_clear_young_ptes(s
 }
 EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
 
-int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep,
-				unsigned int nr)
+bool contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
-	int young;
+	bool young;
 
 	young = contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
 
--- a/arch/parisc/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/arch/parisc/include/asm/pgtable.h
@@ -451,7 +451,7 @@ static inline bool ptep_test_and_clear_y
 	return true;
 }
 
-int ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
+bool ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
 pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
 
 struct mm_struct;
--- a/arch/parisc/kernel/cache.c~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/arch/parisc/kernel/cache.c
@@ -781,18 +781,18 @@ void flush_anon_page(struct vm_area_stru
 	__flush_cache_page(vma, vmaddr, PFN_PHYS(page_to_pfn(page)));
 }
 
-int ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr,
-			   pte_t *ptep)
+bool ptep_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = ptep_get(ptep);
 
 	if (!pte_young(pte))
-		return 0;
+		return false;
 	set_pte(ptep, pte_mkold(pte));
 #if CONFIG_FLUSH_PAGE_ACCESSED
 	__flush_cache_page(vma, addr, PFN_PHYS(pte_pfn(pte)));
 #endif
-	return 1;
+	return true;
 }
 
 /*
--- a/arch/powerpc/include/asm/nohash/64/pgtable.h~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/arch/powerpc/include/asm/nohash/64/pgtable.h
@@ -155,7 +155,7 @@ static inline void huge_ptep_set_wrprote
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 #define ptep_clear_flush_young(__vma, __address, __ptep)		\
 ({									\
-	int __young = ptep_test_and_clear_young(__vma, __address, __ptep);\
+	bool __young = ptep_test_and_clear_young(__vma, __address, __ptep);\
 	__young;							\
 })
 
--- a/arch/riscv/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/arch/riscv/include/asm/pgtable.h
@@ -695,8 +695,8 @@ static inline void ptep_set_wrprotect(st
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long address, pte_t *ptep)
+static inline bool ptep_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
 	/*
 	 * This comment is borrowed from x86, but applies equally to RISC-V:
--- a/arch/s390/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/arch/s390/include/asm/pgtable.h
@@ -1174,8 +1174,8 @@ static inline bool ptep_test_and_clear_y
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long address, pte_t *ptep)
+static inline bool ptep_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
 	return ptep_test_and_clear_young(vma, address, ptep);
 }
--- a/arch/x86/include/asm/pgtable.h~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/arch/x86/include/asm/pgtable.h
@@ -1236,8 +1236,8 @@ bool ptep_test_and_clear_young(struct vm
 		unsigned long addr, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-extern int ptep_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pte_t *ptep);
+bool ptep_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
--- a/arch/x86/mm/pgtable.c~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/arch/x86/mm/pgtable.c
@@ -483,8 +483,8 @@ int pudp_test_and_clear_young(struct vm_
 }
 #endif
 
-int ptep_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pte_t *ptep)
+bool ptep_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
 	/*
 	 * On x86 CPUs, clearing the accessed bit without a TLB flush
--- a/include/linux/pgtable.h~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/include/linux/pgtable.h
@@ -531,8 +531,8 @@ static inline int pmdp_test_and_clear_yo
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-int ptep_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pte_t *ptep);
+bool ptep_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep);
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
@@ -1086,10 +1086,10 @@ static inline void wrprotect_ptes(struct
  * Context: The caller holds the page table lock.  The PTEs map consecutive
  * pages that belong to the same folio.  The PTEs are all in the same PMD.
  */
-static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+static inline bool clear_flush_young_ptes(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
-	int young = 0;
+	bool young = false;
 
 	for (;;) {
 		young |= ptep_clear_flush_young(vma, addr, ptep);
--- a/mm/pgtable-generic.c~mm-change-to-return-bool-for-ptep_clear_flush_young-clear_flush_young_ptes
+++ a/mm/pgtable-generic.c
@@ -81,10 +81,11 @@ int ptep_set_access_flags(struct vm_area
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-int ptep_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pte_t *ptep)
+bool ptep_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep)
 {
-	int young;
+	bool young;
+
 	young = ptep_test_and_clear_young(vma, address, ptep);
 	if (young)
 		flush_tlb_page(vma, address);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

