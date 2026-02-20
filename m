Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF963033DE
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 22:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771627365; cv=none; b=lptUrCua21AHJVudT9j/txAjKXhvgC/HwAG0v9hghnDrhlUjY0WSinmYn+J9zrbzrPz6bJqMkpCB6Kfq6dxc9RR3U7P8JsoSOghKz28I3+R8RXZzw1Lxq7NCNiK0b1pucnq7F6qPXxoSxoRuHE+KniEma58eMQoiBBO83ibvy4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771627365; c=relaxed/simple;
	bh=GEuZyHdA9ejn7wZYD3P13geSZ3AD+flQ5Y9LyYmO4FU=;
	h=Date:To:From:Subject:Message-Id; b=cj4UHS+m+0Jm4ThQ2SX9vDyBzFIf0mhQnX9fTDql43Ty/KZi4lAU0+cBymxgstIn23dW4tPOKL7s+6vT4HFvCI/0tf5KmrwjYOtjz3VaHUiLIxv1T7lZgc8RceLKG3QOjliLpTNvVNrtrgq7oR6qQEVgP+To3zv7pZdJVaJZhq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pEawtnqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pEawtnqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7532C116C6;
	Fri, 20 Feb 2026 22:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771627364;
	bh=GEuZyHdA9ejn7wZYD3P13geSZ3AD+flQ5Y9LyYmO4FU=;
	h=Date:To:From:Subject:From;
	b=pEawtnqc56+1zV6DoaxIHs531xe/kGEDcHG8pmV3CHN2yFRpNY1Da97c5Z1K/VRzr
	 DYxMiMPy0hBBfHo2PwVPuDmfuDUj7N7kzJV8PZlnz3KIKATRUBxLztxy1spX+Z0B3j
	 m9EpiZ4Z+fc6TRA3Gno4B1KnGeyPLYPFoBZ4r0to=
Date: Fri, 20 Feb 2026 14:42:43 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,vbabka@suse.cz,surenb@google.com,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,linmag7@gmail.com,Liam.Howlett@oracle.com,johannes@sipsolutions.net,jcmvbkbc@gmail.com,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,david@kernel.org,davem@davemloft.net,dave.hansen@linux.intel.com,chleroy@kernel.org,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,andreas@gaisler.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-my_zero_pfn-to-zero_pfn.patch added to mm-new branch
Message-Id: <20260220224244.A7532C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename my_zero_pfn() to zero_pfn()
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-my_zero_pfn-to-zero_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-my_zero_pfn-to-zero_pfn.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm: rename my_zero_pfn() to zero_pfn()
Date: Wed, 11 Feb 2026 12:31:39 +0200

my_zero_pfn() is a silly name.

Rename zero_pfn variable to zero_page_pfn and my_zero_pfn() function to
zero_pfn().

While on it, move extern declarations of zero_page_pfn outside the
functions that use it and add a comment about what ZERO_PAGE is.

Link: https://lkml.kernel.org/r/20260211103141.3215197-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu/spte.h |    2 +-
 fs/dax.c                |    2 +-
 fs/proc/vmcore.c        |    2 +-
 include/linux/pgtable.h |   28 ++++++++++++++++++++--------
 mm/huge_memory.c        |    2 +-
 mm/memory.c             |    2 +-
 mm/migrate.c            |    2 +-
 mm/mm_init.c            |   10 +++++-----
 mm/userfaultfd.c        |    4 ++--
 9 files changed, 33 insertions(+), 21 deletions(-)

--- a/arch/x86/kvm/mmu/spte.h~mm-rename-my_zero_pfn-to-zero_pfn
+++ a/arch/x86/kvm/mmu/spte.h
@@ -248,7 +248,7 @@ extern u64 __read_mostly shadow_nonprese
 
 static inline hpa_t kvm_mmu_get_dummy_root(void)
 {
-	return my_zero_pfn(0) << PAGE_SHIFT;
+	return zero_pfn(0) << PAGE_SHIFT;
 }
 
 static inline bool kvm_mmu_is_dummy_root(hpa_t shadow_page)
--- a/fs/dax.c~mm-rename-my_zero_pfn-to-zero_pfn
+++ a/fs/dax.c
@@ -1360,7 +1360,7 @@ static vm_fault_t dax_load_hole(struct x
 {
 	struct inode *inode = iter->inode;
 	unsigned long vaddr = vmf->address;
-	unsigned long pfn = my_zero_pfn(vaddr);
+	unsigned long pfn = zero_pfn(vaddr);
 	vm_fault_t ret;
 
 	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, DAX_ZERO_PAGE);
--- a/fs/proc/vmcore.c~mm-rename-my_zero_pfn-to-zero_pfn
+++ a/fs/proc/vmcore.c
@@ -525,7 +525,7 @@ static int remap_oldmem_pfn_checked(stru
 {
 	unsigned long map_size;
 	unsigned long pos_start, pos_end, pos;
-	unsigned long zeropage_pfn = my_zero_pfn(0);
+	unsigned long zeropage_pfn = zero_pfn(0);
 	size_t len = 0;
 
 	pos_start = pfn;
--- a/include/linux/pgtable.h~mm-rename-my_zero_pfn-to-zero_pfn
+++ a/include/linux/pgtable.h
@@ -1917,27 +1917,39 @@ static inline void pfnmap_setup_cachemod
 	pfnmap_setup_cachemode(pfn, PAGE_SIZE, prot);
 }
 
+/*
+ * ZERO_PAGE() is global shared page(s) that is always zero. It is used for
+ * zero-mapped memory areas, CoW etc.
+ *
+ * On architectures that __HAVE_COLOR_ZERO_PAGE there are several such pages
+ * for different ranges in the virtual address space.
+ *
+ * zero_page_pfn identifies the first (or the only) pfn for these pages.
+ */
 #ifdef __HAVE_COLOR_ZERO_PAGE
 static inline int is_zero_pfn(unsigned long pfn)
 {
-	extern unsigned long zero_pfn;
-	unsigned long offset_from_zero_pfn = pfn - zero_pfn;
+	extern unsigned long zero_page_pfn;
+	unsigned long offset_from_zero_pfn = pfn - zero_page_pfn;
+
 	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
 }
 
-#define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
+#define zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
 
 #else
 static inline int is_zero_pfn(unsigned long pfn)
 {
-	extern unsigned long zero_pfn;
-	return pfn == zero_pfn;
+	extern unsigned long zero_page_pfn;
+
+	return pfn == zero_page_pfn;
 }
 
-static inline unsigned long my_zero_pfn(unsigned long addr)
+static inline unsigned long zero_pfn(unsigned long addr)
 {
-	extern unsigned long zero_pfn;
-	return zero_pfn;
+	extern unsigned long zero_page_pfn;
+
+	return zero_page_pfn;
 }
 #endif /* __HAVE_COLOR_ZERO_PAGE */
 
--- a/mm/huge_memory.c~mm-rename-my_zero_pfn-to-zero_pfn
+++ a/mm/huge_memory.c
@@ -2971,7 +2971,7 @@ static void __split_huge_zero_page_pmd(s
 	for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
 		pte_t entry;
 
-		entry = pfn_pte(my_zero_pfn(addr), vma->vm_page_prot);
+		entry = pfn_pte(zero_pfn(addr), vma->vm_page_prot);
 		entry = pte_mkspecial(entry);
 		if (pmd_uffd_wp(old_pmd))
 			entry = pte_mkuffd_wp(entry);
--- a/mm/memory.c~mm-rename-my_zero_pfn-to-zero_pfn
+++ a/mm/memory.c
@@ -5223,7 +5223,7 @@ static vm_fault_t do_anonymous_page(stru
 	/* Use the zero-page for reads */
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm)) {
-		entry = pte_mkspecial(pfn_pte(my_zero_pfn(vmf->address),
+		entry = pte_mkspecial(pfn_pte(zero_pfn(vmf->address),
 						vma->vm_page_prot));
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				vmf->address, &vmf->ptl);
--- a/mm/migrate.c~mm-rename-my_zero_pfn-to-zero_pfn
+++ a/mm/migrate.c
@@ -321,7 +321,7 @@ static bool try_to_map_unused_to_zeropag
 	if (!pages_identical(page, ZERO_PAGE(0)))
 		return false;
 
-	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
+	newpte = pte_mkspecial(pfn_pte(zero_pfn(pvmw->address),
 					pvmw->vma->vm_page_prot));
 
 	if (pte_swp_soft_dirty(old_pte))
--- a/mm/mm_init.c~mm-rename-my_zero_pfn-to-zero_pfn
+++ a/mm/mm_init.c
@@ -53,8 +53,8 @@ EXPORT_SYMBOL(mem_map);
 void *high_memory;
 EXPORT_SYMBOL(high_memory);
 
-unsigned long zero_pfn __ro_after_init;
-EXPORT_SYMBOL(zero_pfn);
+unsigned long zero_page_pfn __ro_after_init;
+EXPORT_SYMBOL(zero_page_pfn);
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
@@ -2671,12 +2671,12 @@ static void __init mem_init_print_info(v
 		);
 }
 
-static int __init init_zero_pfn(void)
+static int __init init_zero_page_pfn(void)
 {
-	zero_pfn = page_to_pfn(ZERO_PAGE(0));
+	zero_page_pfn = page_to_pfn(ZERO_PAGE(0));
 	return 0;
 }
-early_initcall(init_zero_pfn);
+early_initcall(init_zero_page_pfn);
 
 void __init __weak arch_mm_preinit(void)
 {
--- a/mm/userfaultfd.c~mm-rename-my_zero_pfn-to-zero_pfn
+++ a/mm/userfaultfd.c
@@ -357,7 +357,7 @@ static int mfill_atomic_pte_zeropage(pmd
 	if (mm_forbids_zeropage(dst_vma->vm_mm))
 		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
 
-	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
+	_dst_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
 	ret = -EAGAIN;
 	dst_pte = pte_offset_map_lock(dst_vma->vm_mm, dst_pmd, dst_addr, &ptl);
@@ -1229,7 +1229,7 @@ static int move_zeropage_pte(struct mm_s
 		return -EAGAIN;
 	}
 
-	zero_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
+	zero_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
 	ptep_clear_flush(src_vma, src_addr, src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-dont-special-case-mmu-for-is_zero_pfn-and-my_zero_pfn.patch
mm-rename-my_zero_pfn-to-zero_pfn.patch
arch-mm-consolidate-empty_zero_page.patch
mm-cache-struct-page-for-empty_zero_page-and-return-it-from-zero_page.patch

