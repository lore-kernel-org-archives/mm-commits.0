Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AE82DCBFA
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334196; cv=none; b=cHfY/iqX0fXTGqxj3sfGApv40g4rHAzclaIkiPHcC/kXEYU9yMlvFKHP2XqBJYTFFxssALLsmd+R62zttT7P4Fm3JnV464Z7wqv0NruKdhpG6mQXi9gAfF8ZeZaIrvnIgL45HV23XG/GKhcDP3lovHKlRB22lhBNW+YZ5gy5GFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334196; c=relaxed/simple;
	bh=iJXIriIIWl/atDSZ5kFjvkpDxgxJcjolMb1w4NERAZ0=;
	h=Date:To:From:Subject:Message-Id; b=nKQTx5X5YEtIc2P2KOxWUlnb3o9YA7kN0CiHIoFU4oWTs64zYTA2BthL9H+GNlFjGsSv00NYB4N6SGBsP3ri1ND9TH06SstLOGkpe3fQzDCbWsetLa1w68J+YL5XxGoQp/bNF/5kP0CJVkVvlWWigKSwH9zW0fNhwQcGZSFyxgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sTtAEh/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sTtAEh/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD1C1F0089C;
	Wed,  7 Oct 2026 00:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334195;
	bh=IgMbMs1L/+0KAvYgFtEKYWTgM31Uq4QrJ7HfJaFYTPE=;
	h=Date:To:From:Subject;
	b=sTtAEh/dPK4nXp4Nx2DrdlLSDI7MfJc7rAKC7hu1SlWUtAFZVtZNmWUhZUvYf9WFD
	 oVDNWpxgOXTt+x7WbgwQlu+Z4Ukq1D+105grooNTSiRrn6QRP3iUzlVGki9yDRLi+7
	 OdCcgW3sjqglo9xmsfK9DqpsmpT+jGUSbjHQpH04=
Date: Tue, 06 Oct 2026 17:49:54 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,urezki@gmail.com,svens@linux.ibm.com,ryan.roberts@arm.com,rafael@kernel.org,peterz@infradead.org,palmer@dabbelt.com,mingo@redhat.com,luto@kernel.org,lenb@kernel.org,kevin.brodsky@arm.com,kernel@xen0n.name,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dev.jain@arm.com,david@kernel.org,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-arch-introduce-set_direct_map_valid_noflush.patch removed from -mm tree
Message-Id: <20261007004954.DDD1C1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "arch: introduce set_direct_map_valid_noflush()"
has been removed from the -mm tree.  Its filename was
     revert-arch-introduce-set_direct_map_valid_noflush.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: Revert "arch: introduce set_direct_map_valid_noflush()"
Date: Thu, 03 Sep 2026 12:28:32 +0300

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

Link: https://lore.kernel.org/20260903-execmem-set-vm-perms-v0-2-v3-6-949b64a9f755@kernel.org
Link: https://lore.kernel.org/all/DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev [1]
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Brendan Jackman <brendan.jackman@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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
Cc: Dev Jain <dev.jain@arm.com>
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
@@ -2695,14 +2695,6 @@ int set_direct_map_default_noflush(struc
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

mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch
mm-execmem-handle-potential-allocation-errors-in-the-maple-tree.patch
mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch
mm-vmalloc-add-define_free-for-vfree.patch
mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch
docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch
maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch
docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc.patch
docs-mm-describe-set_memory-and-set_direct_map-apis.patch
docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch
arch-mm-promote-debug_wx-to-check_wx.patch
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

