Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A0B1DA36
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 20:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435767; cv=none; b=oOyT7QFveaYuizN1mo14eCBVSi7G2nX4e/+KFQc/Ho6a9juth8DuLLzY/N/R9HNUikVvP7cOm0U/wRj1mrN6rEey4li7HFFvJwmNq+JaISybhkrcJA0Zg+XFISqAxQ98m6F+eNdA6W1gP1kf2XK0dW6CfgqwLzxYzUSRtxBu5Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435767; c=relaxed/simple;
	bh=G2HTKHvgpGComiFf8wIKtSRPp90Ep8KVXZKLte5GLF4=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=pmiQmf9sRWkgRk5Dt6uYTcxd0o8drN/xC6r2LP+bp3Lz63m7oyBI7QmCD+jnC6Q6crs3HOA/xqRQpuKukGBGXQk5ivkkR2mFwABKLsGqGtatTg1iqm1G8mSY1vUu2V0zI6wuuNwdOrufc5jdSEexEVR/KJm3oiJms3COcEjuKqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qB2qeicq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qB2qeicq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6748AC433F1;
	Tue, 16 Jan 2024 20:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435766;
	bh=G2HTKHvgpGComiFf8wIKtSRPp90Ep8KVXZKLte5GLF4=;
	h=Date:To:From:Subject:From;
	b=qB2qeicqNpkB+ACo6276iykrnVu7dbQsmDqkOhWYlZUlgnoJ6IbttB3jE5+GyU4r1
	 u/jSo93eN5GGir3b2r1RsHOdW9OYHXc6t/KwHgQixI29T6hlk89RbSrxNEqvuGg0EB
	 KWAQ1ZGqU2ytaZqMDKAzsKpiRdU2PrSSu23Pvzzk=
Date: Tue, 16 Jan 2024 12:09:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,mike.kravetz@oracle.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,sunnanyong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely.patch added to mm-unstable branch
Message-Id: <20240116200926.6748AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: HVO: support BBM of vmemmap pgtable safely
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely.patch

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
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: arm64: mm: HVO: support BBM of vmemmap pgtable safely
Date: Sat, 13 Jan 2024 17:44:35 +0800

Implement vmemmap_update_pmd and vmemmap_update_pte on arm64 to do
BBM(break-before-make) logic when change the page table of vmemmap
address, they will under the init_mm.page_table_lock.  If a translation
fault of vmemmap address concurrently happened after pte/pmd cleared,
vmemmap page fault handler will acquire the init_mm.page_table_lock to
wait for vmemmap update to complete, by then the virtual address is valid
again, so PF can return and access can continue.  In other case, do the
traditional kernel fault.

Implement vmemmap_flush_tlb_all/range on arm64 with nothing to do because
tlb already flushed in every single BBM.

Link: https://lkml.kernel.org/r/20240113094436.2506396-3-sunnanyong@huawei.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/esr.h      |    4 +
 arch/arm64/include/asm/pgtable.h  |    8 ++
 arch/arm64/include/asm/tlbflush.h |   16 +++++
 arch/arm64/mm/fault.c             |   78 ++++++++++++++++++++++++++--
 arch/arm64/mm/mmu.c               |   28 ++++++++++
 5 files changed, 131 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/esr.h~arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely
+++ a/arch/arm64/include/asm/esr.h
@@ -116,6 +116,10 @@
 #define ESR_ELx_FSC_SERROR	(0x11)
 #define ESR_ELx_FSC_ACCESS	(0x08)
 #define ESR_ELx_FSC_FAULT	(0x04)
+#define ESR_ELx_FSC_FAULT_L0    (0x04)
+#define ESR_ELx_FSC_FAULT_L1    (0x05)
+#define ESR_ELx_FSC_FAULT_L2    (0x06)
+#define ESR_ELx_FSC_FAULT_L3    (0x07)
 #define ESR_ELx_FSC_PERM	(0x0C)
 #define ESR_ELx_FSC_SEA_TTW0	(0x14)
 #define ESR_ELx_FSC_SEA_TTW1	(0x15)
--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1124,6 +1124,14 @@ extern pte_t ptep_modify_prot_start(stru
 extern void ptep_modify_prot_commit(struct vm_area_struct *vma,
 				    unsigned long addr, pte_t *ptep,
 				    pte_t old_pte, pte_t new_pte);
+
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+void vmemmap_update_pmd(unsigned long addr, pmd_t *pmdp, pte_t *ptep);
+#define vmemmap_update_pmd vmemmap_update_pmd
+void vmemmap_update_pte(unsigned long addr, pte_t *ptep, pte_t pte);
+#define vmemmap_update_pte vmemmap_update_pte
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_PGTABLE_H */
--- a/arch/arm64/include/asm/tlbflush.h~arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely
+++ a/arch/arm64/include/asm/tlbflush.h
@@ -504,6 +504,22 @@ static inline void __flush_tlb_kernel_pg
 	dsb(ish);
 	isb();
 }
+
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static inline void vmemmap_flush_tlb_all(void)
+{
+	/* do nothing, already flushed tlb in every single BBM */
+}
+#define vmemmap_flush_tlb_all vmemmap_flush_tlb_all
+
+static inline void vmemmap_flush_tlb_range(unsigned long start,
+					   unsigned long end)
+{
+	/* do nothing, already flushed tlb in every single BBM */
+}
+#define vmemmap_flush_tlb_range vmemmap_flush_tlb_range
+#endif
+
 #endif
 
 #endif
--- a/arch/arm64/mm/fault.c~arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely
+++ a/arch/arm64/mm/fault.c
@@ -368,6 +368,75 @@ static bool is_el1_mte_sync_tag_check_fa
 	return false;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static inline bool vmemmap_fault_may_fixup(unsigned long addr,
+					   unsigned long esr)
+{
+	if (addr < VMEMMAP_START || addr >= VMEMMAP_END)
+		return false;
+
+	/*
+	 * Only try to handle translation fault level 2 or level 3,
+	 * because hugetlb vmemmap optimize only clear pmd or pte.
+	 */
+	switch (esr & ESR_ELx_FSC) {
+	case ESR_ELx_FSC_FAULT_L2:
+	case ESR_ELx_FSC_FAULT_L3:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * PMD mapped vmemmap should has been split as PTE mapped
+ * by HVO now, here we only check this case, other cases
+ * should fail.
+ * Also should check the addr is healthy enough that will not cause
+ * a level2 or level3 translation fault again after page fault
+ * handled with success, so we need check both bits[1:0] of PMD and
+ * PTE as ARM Spec mentioned below:
+ * A Translation fault is generated if bits[1:0] of a translation
+ * table descriptor identify the descriptor as either a Fault
+ * encoding or a reserved encoding.
+ */
+static inline bool vmemmap_addr_healthy(unsigned long addr)
+{
+	pmd_t *pmdp, pmd;
+	pte_t *ptep, pte;
+
+	pmdp = pmd_off_k(addr);
+	pmd = pmdp_get(pmdp);
+	if (!pmd_table(pmd))
+		return false;
+
+	ptep = pte_offset_kernel(pmdp, addr);
+	pte = ptep_get(ptep);
+	return (pte_val(pte) & PTE_TYPE_MASK) == PTE_TYPE_PAGE;
+}
+
+static bool vmemmap_handle_page_fault(unsigned long addr,
+				      unsigned long esr)
+{
+	bool ret;
+
+	if (likely(!vmemmap_fault_may_fixup(addr, esr)))
+		return false;
+
+	spin_lock(&init_mm.page_table_lock);
+	ret = vmemmap_addr_healthy(addr);
+	spin_unlock(&init_mm.page_table_lock);
+
+	return ret;
+}
+#else
+static inline bool vmemmap_handle_page_fault(unsigned long addr,
+					     unsigned long esr)
+{
+	return false;
+}
+#endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
+
 static bool is_translation_fault(unsigned long esr)
 {
 	return (esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_FAULT;
@@ -405,9 +474,12 @@ static void __do_kernel_fault(unsigned l
 	} else if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
 	} else {
-		if (is_translation_fault(esr) &&
-		    kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
-			return;
+		if (is_translation_fault(esr)) {
+			if (kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
+				return;
+			if (vmemmap_handle_page_fault(addr, esr))
+				return;
+		}
 
 		msg = "paging request";
 	}
--- a/arch/arm64/mm/mmu.c~arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely
+++ a/arch/arm64/mm/mmu.c
@@ -1146,6 +1146,34 @@ int __meminit vmemmap_check_pmd(pmd_t *p
 	return 1;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+/*
+ * In the window between the page table entry is cleared and filled
+ * with a new value, other threads have the opportunity to concurrently
+ * access the vmemmap area then page translation fault occur.
+ * Therefore, we need to ensure that the init_mm.page_table_lock is held
+ * to synchronize the vmemmap page fault handling which will wait for
+ * this lock to be released to ensure that the page table entry has been
+ * refreshed with a new valid value.
+ */
+void vmemmap_update_pmd(unsigned long addr, pmd_t *pmdp, pte_t *ptep)
+{
+	lockdep_assert_held(&init_mm.page_table_lock);
+	pmd_clear(pmdp);
+	flush_tlb_kernel_range(addr, addr + PMD_SIZE);
+	pmd_populate_kernel(&init_mm, pmdp, ptep);
+}
+
+void vmemmap_update_pte(unsigned long addr, pte_t *ptep, pte_t pte)
+{
+	spin_lock(&init_mm.page_table_lock);
+	pte_clear(&init_mm, addr, ptep);
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+	set_pte_at(&init_mm, addr, ptep, pte);
+	spin_unlock(&init_mm.page_table_lock);
+}
+#endif
+
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
_

Patches currently in -mm which might be from sunnanyong@huawei.com are

mm-hvo-introduce-helper-function-to-update-and-flush-pgtable.patch
arm64-mm-hvo-support-bbm-of-vmemmap-pgtable-safely.patch
arm64-mm-re-enable-optimize_hugetlb_vmemmap.patch

