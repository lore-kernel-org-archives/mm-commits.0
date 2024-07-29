Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CFE12FB37
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 23:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722295905; cv=none; b=pNHYFhriMZ2ttIP9aid5t5xvGc81FTL2I06YzcK/qAF9feeWaN548zp6wdfHciwBOdEUF8xsRE/5fBxFVZIoVLI5LMBPeK5Mp+kW4GBkVLUoL2eduFZLwysxR0XzhBGinXck3Fu/va6sGU8dr75gJnVw7Nf9x55sGhgfmu4DteY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722295905; c=relaxed/simple;
	bh=T+lY9PzNiuGj8Gk2zaeg5mlCGCSGdhV9kqnnZmTro5s=;
	h=Date:To:From:Subject:Message-Id; b=fMQI6oLOOYuoC+SEuB5tDd+GbJJ+f3TJWFrd9EDh2cbj+pS/gnYMOWYt3ODpDCisNqfZwlrgiFPfHjrvwOktY5QTrc3puPFpOmDGnV4+B+++vhu6L/5elphUweZ/Nl9od2PUWzk4asl1imRIENCbxEsGrSyWZf3YQtFj+l3sUxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ykSzYuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ykSzYuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE9EC32786;
	Mon, 29 Jul 2024 23:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722295905;
	bh=T+lY9PzNiuGj8Gk2zaeg5mlCGCSGdhV9kqnnZmTro5s=;
	h=Date:To:From:Subject:From;
	b=0ykSzYuuoJGxQJ5zoN+R0uO6b1O+Azd+t9USH9aEVhDiRJZN75A0Eh1Hcn4IYfUzm
	 DXwT838J0PpdYYVmgk3pBUcz1sEQOOPhKGF9Dx1ecamso2jbPkFecoPHUamR+Gl6E9
	 3708MEFODqCzSEQcGpemxf0iWj2fxl5R7uZuDl9Q=
Date: Mon, 29 Jul 2024 16:31:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-s390-clean-up-hugetlb-definitions.patch added to mm-unstable branch
Message-Id: <20240729233145.8DE9EC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/s390: clean up hugetlb definitions
has been added to the -mm mm-unstable branch.  Its filename is
     arch-s390-clean-up-hugetlb-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-s390-clean-up-hugetlb-definitions.patch

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
Subject: arch/s390: clean up hugetlb definitions
Date: Mon, 29 Jul 2024 11:10:17 +0200

s390 redefines functions that are already defined (and the same)
in include/asm-generic/hugetlb.h.
Do as the other architectures: 1) include include/asm-generic/hugetlb.h
2) drop the already defined functions in the generic hugetlb.h and
3) use the __HAVE_ARCH_HUGE_* macros to define our own.

This gets rid of quite some code.

Link: https://lkml.kernel.org/r/20240729091018.2152-9-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/hugetlb.h |   58 ++++++++----------------------
 include/asm-generic/hugetlb.h   |    8 ++++
 2 files changed, 24 insertions(+), 42 deletions(-)

--- a/arch/s390/include/asm/hugetlb.h~arch-s390-clean-up-hugetlb-definitions
+++ a/arch/s390/include/asm/hugetlb.h
@@ -12,21 +12,24 @@
 #include <linux/pgtable.h>
 #include <asm/page.h>
 
-#define hugetlb_free_pgd_range			free_pgd_range
 #define hugepages_supported()			(MACHINE_HAS_EDAT1)
 
+#define __HAVE_ARCH_HUGE_SET_HUGE_PTE_AT
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t pte, unsigned long sz);
 void __set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t pte);
-pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
-pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
+#define __HAVE_ARCH_HUGE_PTEP_GET
+extern pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+#define __HAVE_ARCH_HUGE_PTEP_GET_AND_CLEAR
+extern pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 			      unsigned long addr, pte_t *ptep);
 
 /*
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
  */
+#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
 static inline int prepare_hugepage_range(struct file *file,
 			unsigned long addr, unsigned long len)
 {
@@ -45,6 +48,7 @@ static inline void arch_clear_hugetlb_fl
 }
 #define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 
+#define __HAVE_ARCH_HUGE_PTE_CLEAR
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
 				  pte_t *ptep, unsigned long sz)
 {
@@ -54,12 +58,14 @@ static inline void huge_pte_clear(struct
 		set_pte(ptep, __pte(_SEGMENT_ENTRY_EMPTY));
 }
 
+#define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long address, pte_t *ptep)
 {
 	return huge_ptep_get_and_clear(vma->vm_mm, address, ptep);
 }
 
+#define  __HAVE_ARCH_HUGE_PTEP_SET_ACCESS_FLAGS
 static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 					     unsigned long addr, pte_t *ptep,
 					     pte_t pte, int dirty)
@@ -72,6 +78,7 @@ static inline int huge_ptep_set_access_f
 	return changed;
 }
 
+#define __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 					   unsigned long addr, pte_t *ptep)
 {
@@ -79,69 +86,36 @@ static inline void huge_ptep_set_wrprote
 	__set_huge_pte_at(mm, addr, ptep, pte_wrprotect(pte));
 }
 
-static inline pte_t mk_huge_pte(struct page *page, pgprot_t pgprot)
-{
-	return mk_pte(page, pgprot);
-}
-
+#define __HAVE_ARCH_HUGE_PTE_NONE
 static inline int huge_pte_none(pte_t pte)
 {
 	return pte_none(pte);
 }
 
+#define __HAVE_ARCH_HUGE_PTE_NONE_MOSTLY
 static inline int huge_pte_none_mostly(pte_t pte)
 {
 	return huge_pte_none(pte);
 }
 
-static inline int huge_pte_write(pte_t pte)
-{
-	return pte_write(pte);
-}
-
-static inline int huge_pte_dirty(pte_t pte)
-{
-	return pte_dirty(pte);
-}
-
-static inline pte_t huge_pte_mkwrite(pte_t pte)
-{
-	return pte_mkwrite_novma(pte);
-}
-
-static inline pte_t huge_pte_mkdirty(pte_t pte)
-{
-	return pte_mkdirty(pte);
-}
-
-static inline pte_t huge_pte_wrprotect(pte_t pte)
-{
-	return pte_wrprotect(pte);
-}
-
-static inline pte_t huge_pte_modify(pte_t pte, pgprot_t newprot)
-{
-	return pte_modify(pte, newprot);
-}
-
+#define __HAVE_ARCH_HUGE_PTE_MKUFFD_WP
 static inline pte_t huge_pte_mkuffd_wp(pte_t pte)
 {
 	return pte;
 }
 
+#define __HAVE_ARCH_HUGE_PTE_CLEAR_UFFD_WP
 static inline pte_t huge_pte_clear_uffd_wp(pte_t pte)
 {
 	return pte;
 }
 
+#define __HAVE_ARCH_HUGE_PTE_UFFD_WP
 static inline int huge_pte_uffd_wp(pte_t pte)
 {
 	return 0;
 }
 
-static inline bool gigantic_page_runtime_supported(void)
-{
-	return true;
-}
+#include <asm-generic/hugetlb.h>
 
 #endif /* _ASM_S390_HUGETLB_H */
--- a/include/asm-generic/hugetlb.h~arch-s390-clean-up-hugetlb-definitions
+++ a/include/asm-generic/hugetlb.h
@@ -42,20 +42,26 @@ static inline pte_t huge_pte_modify(pte_
 	return pte_modify(pte, newprot);
 }
 
+#ifndef __HAVE_ARCH_HUGE_PTE_MKUFFD_WP
 static inline pte_t huge_pte_mkuffd_wp(pte_t pte)
 {
 	return huge_pte_wrprotect(pte_mkuffd_wp(pte));
 }
+#endif
 
+#ifndef __HAVE_ARCH_HUGE_PTE_CLEAR_UFFD_WP
 static inline pte_t huge_pte_clear_uffd_wp(pte_t pte)
 {
 	return pte_clear_uffd_wp(pte);
 }
+#endif
 
+#ifndef __HAVE_ARCH_HUGE_PTE_UFFD_WP
 static inline int huge_pte_uffd_wp(pte_t pte)
 {
 	return pte_uffd_wp(pte);
 }
+#endif
 
 #ifndef __HAVE_ARCH_HUGE_PTE_CLEAR
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
@@ -106,10 +112,12 @@ static inline int huge_pte_none(pte_t pt
 #endif
 
 /* Please refer to comments above pte_none_mostly() for the usage */
+#ifndef __HAVE_ARCH_HUGE_PTE_NONE_MOSTLY
 static inline int huge_pte_none_mostly(pte_t pte)
 {
 	return huge_pte_none(pte) || is_pte_marker(pte);
 }
+#endif
 
 #ifndef __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
 static inline int prepare_hugepage_range(struct file *file,
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
mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align.patch

