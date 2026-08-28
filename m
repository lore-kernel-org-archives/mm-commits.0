Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAB83C3F50
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 05:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895650; cv=none; b=i8XoTCXqOQAJavN1OS+l8/vXvbYthBEXJHBuegipYb9d0KD97Fi4sWOPumx2p2rfWt/0KDCvoFTJAI1mhgOSTmYAj0RZI0q4qDigrpLO6IeViHdGpiOfsIFuP/ykDd3gjq6VI5t2H+ZNfYAhL6qVOb4nkJq2bHYZ9JtIHRvhWDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895650; c=relaxed/simple;
	bh=q7iW4on4i6Fsgm88+WEdFHbrmXYHsViOqjmrIXNzhOs=;
	h=Date:To:From:Subject:Message-Id; b=g6fxWaOwOsS0vefYPCsE4K+AxpnpuaQfybg1UJfVH7ppVK8FxHCB3YJioC48xBeW9oTodZE4BMfRYHOuCgc17B8gJdgMhQOzjZKUAsh84OrLReRDlalWKMl0mU/YKyS2RFbdaCQ9BbVMjysRZ7rPbwkr7CTCqzVtv5rM0xDj/B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pktMd37Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pktMd37Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A371F000E9;
	Fri, 28 Aug 2026 05:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787895648;
	bh=QKTpRHOp2dDU7+0mKGAu0X9Nf9UqqlEYHghUMvvAXbk=;
	h=Date:To:From:Subject;
	b=pktMd37QDEiW3G4S4OHppF6xue5/xedlISmjEGKXyrr0EpXisY+We97tFTdodh76r
	 otWzgLRREMAq0hTPk1YbRoeAoCv1tvA7wqNq2+UJzbRPqAIc8GavtCAbVBEtv082Eg
	 YF6xROSMeLLdCz7lg7K2gmel0UxPHk2PUVEgJVo8=
Date: Thu, 27 Aug 2026 22:40:48 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-arch-introduce-set_direct_map_valid_noflush.patch added to mm-new branch
Message-Id: <20260828054048.80A371F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "arch: introduce set_direct_map_valid_noflush()"
has been added to the -mm mm-new branch.  Its filename is
     revert-arch-introduce-set_direct_map_valid_noflush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-arch-introduce-set_direct_map_valid_noflush.patch

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
Subject: Revert "arch: introduce set_direct_map_valid_noflush()"
Date: Sun, 23 Aug 2026 14:46:17 +0300

Commit 0c6378a71574 ("arch: introduce set_direct_map_valid_noflush()")
added set_direct_map_valid_noflush() to allow updating the direct map for
a physically contiguous range in execmem.

As Brendan recently pointed out [1], this API is confusing because on
arm64 it means that is sets VALID bit in ptes, while on other
architectures it is an analog of set_direct_map_default_noflush().

The only user of set_direct_map_valid_noflush() was execmem's ROX cache
freeing path and it was switched to utilize VM_FLUSH_RESET_PERMS for
resetting permissions of the direct map alias.

With the last user gone and with
set_direct_map_{invalid,default}_noflush() accepting number of pages as a
parameter, set_direct_map_valid_noflush() become a copy of
set_memory_valid() on arm64 and a duplicate of
set_direct_map_{invalid,default}_noflush() on other architecture, it is
safe to remove set_direct_map_valid_noflush().

Also drop a stale comment in arm64::__kernel_map_pages() that Linus
bothered to add when merging changes containing
set_direct_map_valid_noflush() to his tree.

This reverts commit 0c6378a71574daa6cd1534ad42a956e3262756c7.

Link: https://lore.kernel.org/20260823-execmem-set-vm-perms-v0-2-v2-6-b013a37d84b3@kernel.org
Link: https://lore.kernel.org/all/DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev [1]
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
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

 arch/arm64/include/asm/set_memory.h     |    1 -
 arch/arm64/mm/pageattr.c                |   16 ----------------
 arch/loongarch/include/asm/set_memory.h |    1 -
 arch/loongarch/mm/pageattr.c            |   19 -------------------
 arch/riscv/include/asm/set_memory.h     |    1 -
 arch/riscv/mm/pageattr.c                |   15 ---------------
 arch/s390/include/asm/set_memory.h      |    1 -
 arch/s390/mm/pageattr.c                 |   12 ------------
 arch/x86/include/asm/set_memory.h       |    1 -
 arch/x86/mm/pat/set_memory.c            |    8 --------
 include/linux/set_memory.h              |    6 ------
 11 files changed, 81 deletions(-)

--- a/arch/arm64/include/asm/set_memory.h~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/arch/arm64/include/asm/set_memory.h
@@ -13,7 +13,6 @@ int set_memory_valid(unsigned long addr,
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
 int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
--- a/arch/arm64/mm/pageattr.c~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/arch/arm64/mm/pageattr.c
@@ -355,23 +355,7 @@ int realm_register_memory_enc_ops(void)
 	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-
-	if (!can_set_direct_map())
-		return 0;
-
-	return set_memory_valid(addr, nr, valid);
-}
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
-/*
- * This is - apart from the return value - doing the same
- * thing as the new set_direct_map_valid_noflush() function.
- *
- * Unify? Explain the conceptual differences?
- */
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (!can_set_direct_map())
--- a/arch/loongarch/include/asm/set_memory.h~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/arch/loongarch/include/asm/set_memory.h
@@ -17,6 +17,5 @@ int set_memory_rw(unsigned long addr, in
 bool kernel_page_present(struct page *page);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
--- a/arch/loongarch/mm/pageattr.c~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/arch/loongarch/mm/pageattr.c
@@ -217,22 +217,3 @@ int set_direct_map_invalid_noflush(struc
 
 	return __set_memory(addr, nr, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
 }
-
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-	pgprot_t set, clear;
-
-	if (addr < vm_map_base)
-		return 0;
-
-	if (valid) {
-		set = PAGE_KERNEL;
-		clear = __pgprot(0);
-	} else {
-		set = __pgprot(0);
-		clear = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
-	}
-
-	return __set_memory(addr, nr, set, clear);
-}
--- a/arch/riscv/include/asm/set_memory.h~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/arch/riscv/include/asm/set_memory.h
@@ -42,7 +42,6 @@ static inline int set_kernel_memory(char
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 #endif /* __ASSEMBLER__ */
--- a/arch/riscv/mm/pageattr.c~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/arch/riscv/mm/pageattr.c
@@ -386,21 +386,6 @@ int set_direct_map_default_noflush(struc
 			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	pgprot_t set, clear;
-
-	if (valid) {
-		set = PAGE_KERNEL;
-		clear = __pgprot(_PAGE_EXEC);
-	} else {
-		set = __pgprot(0);
-		clear = __pgprot(_PAGE_PRESENT);
-	}
-
-	return __set_memory((unsigned long)page_address(page), nr, set, clear);
-}
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *data)
 {
--- a/arch/s390/include/asm/set_memory.h~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/arch/s390/include/asm/set_memory.h
@@ -62,7 +62,6 @@ __SET_MEMORY_FUNC(set_memory_4k, SET_MEM
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 #endif
--- a/arch/s390/mm/pageattr.c~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/arch/s390/mm/pageattr.c
@@ -392,18 +392,6 @@ int set_direct_map_default_noflush(struc
 	return __set_memory((unsigned long)page_to_virt(page), nr, SET_MEMORY_DEF);
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	unsigned long flags;
-
-	if (valid)
-		flags = SET_MEMORY_DEF;
-	else
-		flags = SET_MEMORY_INV;
-
-	return __set_memory((unsigned long)page_to_virt(page), nr, flags);
-}
-
 bool kernel_page_present(struct page *page)
 {
 	unsigned long addr;
--- a/arch/x86/include/asm/set_memory.h~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/arch/x86/include/asm/set_memory.h
@@ -88,7 +88,6 @@ int set_pages_rw(struct page *page, int
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
--- a/arch/x86/mm/pat/set_memory.c~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/arch/x86/mm/pat/set_memory.c
@@ -2666,14 +2666,6 @@ int set_direct_map_default_noflush(struc
 	return __set_pages_p(page, nr, 0);
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	if (valid)
-		return __set_pages_p(page, nr, 0);
-
-	return __set_pages_np(page, nr, 0);
-}
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
--- a/include/linux/set_memory.h~revert-arch-introduce-set_direct_map_valid_noflush
+++ a/include/linux/set_memory.h
@@ -36,12 +36,6 @@ static inline int set_direct_map_default
 	return 0;
 }
 
-static inline int set_direct_map_valid_noflush(struct page *page,
-					       unsigned nr, bool valid)
-{
-	return 0;
-}
-
 static inline bool kernel_page_present(struct page *page)
 {
 	return true;
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

