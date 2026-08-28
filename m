Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D923C0A0E
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 05:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895633; cv=none; b=YBGrQ4ujt16THp5T3sEV2SYiDjoShekait5Qw3jt4/sdUPdHj+nqJHXQS6PliuOO7f4czBdYzRBo3n1e+B+yybm5Eqjjgf5jgYJzNjJ4/Q9q35lCAi9LMX5qL8FvkaP7FKar+YUa34JoDwyDgMz/Wqlzjj77jqfPNrBv9qOmk2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895633; c=relaxed/simple;
	bh=jNUAbuZOfhEc7zgdPUzTW3ZbY4QCujcIOCDKrRTNsMA=;
	h=Date:To:From:Subject:Message-Id; b=e/dofgxuxiyCUYchwEIPFy8WTYgz6MR4IAs5QW6YmziEgNkQFK5PD3b2tCQvxlZ3jvfXInOOidAMJ4aWQB0sWCs0e2dtcDPmTVZdCXd9yyrUAgS3OciOTEGWL02vztltq++8L+fgSqTAZcCEru1Sksmc0NlPlV0fSQioXXd93LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e9OhEkfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e9OhEkfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A228D1F000E9;
	Fri, 28 Aug 2026 05:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787895630;
	bh=ymP3aJpzfWw5lZpZDuX3G5H/L2jMPz4Gqwv2t9OLRB8=;
	h=Date:To:From:Subject;
	b=e9OhEkfWAn9TN5eXxIuSslMgltBQBp1YpPnt2kLboH0d5yWKrtJjEqUofwUlh5hcf
	 1c4Tel/fA+cj36qWP53hB8hMF7zL2c1u/SR2+/VC6JTx3s9ZvA2XceoBYqvXkhs9ll
	 za8f1DWwAigphD+X0U4w4QK15+CVBruGNzBvrkLA=
Date: Thu, 27 Aug 2026 22:40:30 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch added to mm-new branch
Message-Id: <20260828054030.A228D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: set_memory: add number of pages parameter to set_direct_map APIs
has been added to the -mm mm-new branch.  Its filename is
     set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: set_memory: add number of pages parameter to set_direct_map APIs
Date: Sun, 23 Aug 2026 14:46:12 +0300

Patch series "arch, mm/execmem: resolve confusion about
set_direct_map_valid_noflush()", v2.

Recent discussion about implementation of execmem's ROX caches on arm64
[1] revealed a confusion about how set_direct_map_valid_noflush()
implemented on different architectures.

On arm64 it sets or clears the PTE_VALID bit marking a PTE as present or
not present.

On other architectures it's a range version of
set_direct_map_invalid_noflush() and set_direct_map_default_noflush()

Unlike arm64::set_direct_map_valid_noflush(),
set_direct_map_default_noflush() not only marks PTE as present, but also
sets its default protection mode.

Other than that, initial design of execmem ROX caches didn't rely on
restoration of large mappings that's now available on x86, but completely
removed the memory allocated for the ROX cache from the direct map to
ensure that large mappings are not split.  This precluded usage of
VM_FLUSH_RESET_PERMS for the ROX cache allocations and required execmem to
implement manipulation of the direct map alias.

Current implementation of ROX caches does not remove the direct map alias
but simply calls set_memory_rox() that updates the permissions in both
vmalloc address space and the direct map and relies on
collapse_large_pages() in x86 CPA to keep large mappings.

This allow using VM_FLUSH_RESET_PERMS for execmem ROX cache allocations
with small adjustments to set_direct_map APIs and vmalloc::reset_perms()
behaviour: adding number of pages parameter to set_direct_map APIs and
making resetting of the direct map permissions in vmalloc VMAP_HUGE
friendly.

Implement these adjustments, make execmem always use VM_FLUSH_RESET_PERMS
and revert set_direct_map_valid_noflush() changes.


This patch (of 6):

When set_direct_map APIs were introduced by the commit d253ca0c3865
("x86/mm/cpa: Add set_direct_map_*() functions") the single page parameter
made sense because the initial callers (vmalloc and hibernation) had sets
of unsorted struct pages that required changes of their mappings in the
direct map.

Since there is an increasing demand for direct map manipulation and it is
also desirable to be able to update larger physically contiguous mappings,
for example an entire large folio, extend set_direct_map APIs to receive
number of pages parameter.

As there is still only a handful of callers, change the existing functions
directly and update all the call sites rather than adding wrappers for
single page case.

Link: https://lore.kernel.org/20260823-execmem-set-vm-perms-v0-2-v2-1-b013a37d84b3@kernel.org
Link: https://lore.kernel.org/all/20260611130144.1385343-4-abarnas@google.com [1]
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/set_memory.h     |    4 ++--
 arch/arm64/mm/pageattr.c                |    8 ++++----
 arch/loongarch/include/asm/set_memory.h |    4 ++--
 arch/loongarch/mm/pageattr.c            |    8 ++++----
 arch/riscv/include/asm/set_memory.h     |    4 ++--
 arch/riscv/mm/pageattr.c                |    8 ++++----
 arch/s390/include/asm/set_memory.h      |    4 ++--
 arch/s390/mm/pageattr.c                 |    8 ++++----
 arch/x86/include/asm/set_memory.h       |    4 ++--
 arch/x86/mm/pat/set_memory.c            |    8 ++++----
 include/linux/set_memory.h              |    6 ++++--
 kernel/power/snapshot.c                 |    4 ++--
 mm/secretmem.c                          |    6 +++---
 mm/vmalloc.c                            |    5 +++--
 14 files changed, 42 insertions(+), 39 deletions(-)

--- a/arch/arm64/include/asm/set_memory.h~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/arch/arm64/include/asm/set_memory.h
@@ -11,8 +11,8 @@ bool can_set_direct_map(void);
 
 int set_memory_valid(unsigned long addr, int numpages, int enable);
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
+int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
--- a/arch/arm64/mm/pageattr.c~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/arch/arm64/mm/pageattr.c
@@ -251,7 +251,7 @@ int set_memory_valid(unsigned long addr,
 					__pgprot(PTE_PRESENT_VALID_KERNEL));
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages)
 {
 	pgprot_t clear_mask = __pgprot(PTE_PRESENT_VALID_KERNEL);
 	pgprot_t set_mask = __pgprot(PTE_PRESENT_INVALID);
@@ -260,10 +260,10 @@ int set_direct_map_invalid_noflush(struc
 		return 0;
 
 	return update_range_prot((unsigned long)page_address(page),
-				 PAGE_SIZE, set_mask, clear_mask);
+				 PAGE_SIZE * numpages, set_mask, clear_mask);
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, unsigned int numpages)
 {
 	pgprot_t set_mask = __pgprot(PTE_PRESENT_VALID_KERNEL | PTE_WRITE);
 	pgprot_t clear_mask = __pgprot(PTE_PRESENT_INVALID | PTE_RDONLY);
@@ -272,7 +272,7 @@ int set_direct_map_default_noflush(struc
 		return 0;
 
 	return update_range_prot((unsigned long)page_address(page),
-				 PAGE_SIZE, set_mask, clear_mask);
+				 PAGE_SIZE * numpages, set_mask, clear_mask);
 }
 
 static int __set_memory_enc_dec(unsigned long addr,
--- a/arch/loongarch/include/asm/set_memory.h~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/arch/loongarch/include/asm/set_memory.h
@@ -15,8 +15,8 @@ int set_memory_ro(unsigned long addr, in
 int set_memory_rw(unsigned long addr, int numpages);
 
 bool kernel_page_present(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
-int set_direct_map_invalid_noflush(struct page *page);
+int set_direct_map_default_noflush(struct page *page, unsigned int nr);
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
--- a/arch/loongarch/mm/pageattr.c~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/arch/loongarch/mm/pageattr.c
@@ -198,24 +198,24 @@ bool kernel_page_present(struct page *pa
 	return pte_present(ptep_get(pte));
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
 	if (addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, 1, PAGE_KERNEL, __pgprot(0));
+	return __set_memory(addr, nr, PAGE_KERNEL, __pgprot(0));
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
 	if (addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
+	return __set_memory(addr, nr, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
--- a/arch/riscv/include/asm/set_memory.h~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/arch/riscv/include/asm/set_memory.h
@@ -40,8 +40,8 @@ static inline int set_kernel_memory(char
 }
 #endif
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
+int set_direct_map_default_noflush(struct page *page, unsigned int nr);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
--- a/arch/riscv/mm/pageattr.c~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/arch/riscv/mm/pageattr.c
@@ -374,15 +374,15 @@ int set_memory_nx(unsigned long addr, in
 	return __set_memory(addr, numpages, __pgprot(0), __pgprot(_PAGE_EXEC));
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 {
-	return __set_memory((unsigned long)page_address(page), 1,
+	return __set_memory((unsigned long)page_address(page), nr,
 			    __pgprot(0), __pgprot(_PAGE_PRESENT));
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 {
-	return __set_memory((unsigned long)page_address(page), 1,
+	return __set_memory((unsigned long)page_address(page), nr,
 			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
 }
 
--- a/arch/s390/include/asm/set_memory.h~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/arch/s390/include/asm/set_memory.h
@@ -60,8 +60,8 @@ __SET_MEMORY_FUNC(set_memory_rox, SET_ME
 __SET_MEMORY_FUNC(set_memory_rwnx, SET_MEMORY_RW | SET_MEMORY_NX)
 __SET_MEMORY_FUNC(set_memory_4k, SET_MEMORY_4K)
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
+int set_direct_map_default_noflush(struct page *page, unsigned int nr);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
--- a/arch/s390/mm/pageattr.c~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/arch/s390/mm/pageattr.c
@@ -382,14 +382,14 @@ out:
 	return rc;
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 {
-	return __set_memory((unsigned long)page_to_virt(page), 1, SET_MEMORY_INV);
+	return __set_memory((unsigned long)page_to_virt(page), nr, SET_MEMORY_INV);
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 {
-	return __set_memory((unsigned long)page_to_virt(page), 1, SET_MEMORY_DEF);
+	return __set_memory((unsigned long)page_to_virt(page), nr, SET_MEMORY_DEF);
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
--- a/arch/x86/include/asm/set_memory.h~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/arch/x86/include/asm/set_memory.h
@@ -86,8 +86,8 @@ int set_pages_wb(struct page *page, int
 int set_pages_ro(struct page *page, int numpages);
 int set_pages_rw(struct page *page, int numpages);
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
+int set_direct_map_default_noflush(struct page *page, unsigned int nr);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
--- a/arch/x86/mm/pat/set_memory.c~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/arch/x86/mm/pat/set_memory.c
@@ -2656,14 +2656,14 @@ static int __set_pages_np(struct page *p
 	return __change_page_attr_set_clr(&cpa, 1);
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 {
-	return __set_pages_np(page, 1, 0);
+	return __set_pages_np(page, nr, 0);
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 {
-	return __set_pages_p(page, 1, 0);
+	return __set_pages_p(page, nr, 0);
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
--- a/include/linux/set_memory.h~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/include/linux/set_memory.h
@@ -25,11 +25,13 @@ static inline int set_memory_rox(unsigne
 #endif
 
 #ifndef CONFIG_ARCH_HAS_SET_DIRECT_MAP
-static inline int set_direct_map_invalid_noflush(struct page *page)
+static inline int set_direct_map_invalid_noflush(struct page *page,
+						 unsigned int nr)
 {
 	return 0;
 }
-static inline int set_direct_map_default_noflush(struct page *page)
+static inline int set_direct_map_default_noflush(struct page *page,
+						 unsigned int nr)
 {
 	return 0;
 }
--- a/kernel/power/snapshot.c~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/kernel/power/snapshot.c
@@ -88,7 +88,7 @@ static inline int hibernate_restore_unpr
 static inline void hibernate_map_page(struct page *page)
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		int ret = set_direct_map_default_noflush(page);
+		int ret = set_direct_map_default_noflush(page, 1);
 
 		if (ret)
 			pr_warn_once("Failed to remap page\n");
@@ -101,7 +101,7 @@ static inline void hibernate_unmap_page(
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
 		unsigned long addr = (unsigned long)page_address(page);
-		int ret  = set_direct_map_invalid_noflush(page);
+		int ret  = set_direct_map_invalid_noflush(page, 1);
 
 		if (ret)
 			pr_warn_once("Failed to remap page\n");
--- a/mm/secretmem.c~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/mm/secretmem.c
@@ -139,7 +139,7 @@ retry:
 			goto out;
 		}
 
-		err = set_direct_map_invalid_noflush(folio_page(folio, 0));
+		err = set_direct_map_invalid_noflush(folio_page(folio, 0), 1);
 		if (err) {
 			secretmem_unaccount_folio(state, folio);
 			folio_put(folio);
@@ -156,7 +156,7 @@ retry:
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
-			set_direct_map_default_noflush(folio_page(folio, 0));
+			set_direct_map_default_noflush(folio_page(folio, 0), 1);
 			folio_put(folio);
 			if (err == -EEXIST)
 				goto retry;
@@ -228,7 +228,7 @@ static int secretmem_migrate_folio(struc
 
 static void secretmem_free_folio(struct folio *folio)
 {
-	set_direct_map_default_noflush(folio_page(folio, 0));
+	set_direct_map_default_noflush(folio_page(folio, 0), 1);
 	folio_zero_segment(folio, 0, folio_size(folio));
 }
 
--- a/mm/vmalloc.c~set_memory-add-number-of-pages-parameter-to-set_direct_map-apis
+++ a/mm/vmalloc.c
@@ -3363,14 +3363,15 @@ struct vm_struct *remove_vm_area(const v
 }
 
 static inline void set_area_direct_map(const struct vm_struct *area,
-				       int (*set_direct_map)(struct page *page))
+				       int (*set_direct_map)(struct page *page,
+							     unsigned int nr))
 {
 	unsigned long i;
 
 	/* HUGE_VMALLOC passes small pages to set_direct_map */
 	for (i = 0; i < area->nr_pages; i++)
 		if (page_address(area->pages[i]))
-			set_direct_map(area->pages[i]);
+			set_direct_map(area->pages[i], 1);
 }
 
 /*
_

Patches currently in -mm which might be from rppt@kernel.org are

set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch
mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch
mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch
mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch
mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch
revert-arch-introduce-set_direct_map_valid_noflush.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

