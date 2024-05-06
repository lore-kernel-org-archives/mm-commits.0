Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1B225757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957075; cv=none; b=SGJu77lf02XQR41AnDBq8Zp2XForvB/VY32L+nQi4Q5gjZbC21ZDuMISLm71XRPHFwmN3PrxwGXQ1gHl92b1c6U/R4WwNUbl2RzOPtxp4eHs00tBoutqLHBkKhkFpf8/vf4/QZMxWfQgGdKFRQ4IapVkTF4zRqhAxHxdXufdgWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957075; c=relaxed/simple;
	bh=pUWIzmTZtd3vQIKoAf4WWpoAcF9qmehym7UOdFq5GSw=;
	h=Date:To:From:Subject:Message-Id; b=KL34526UXmuKGiqK/Dq9WHuuGyLr47idzcdXYkhSEvFzVCX8WhxFcc/+NnTF+fdThRSCP83NiaqoCpvp2hAYZ5z+9LtwFUMN/lZYq1FSCHtiqyR82PghDV7Y3Qlz4BN0YM/I78NF/M0O1nn3mWRXfVgxpPYQojk1A0iUWjhK3FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FrgE1k8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FrgE1k8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25062C113CC;
	Mon,  6 May 2024 00:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957075;
	bh=pUWIzmTZtd3vQIKoAf4WWpoAcF9qmehym7UOdFq5GSw=;
	h=Date:To:From:Subject:From;
	b=FrgE1k8dZYZ00bZC6FWiojEENPshH/2H+FBAa5EJA2asRQzWSG0STWbekF+1VCeJs
	 unRV8RpEKD0jyQAHJfsVVrYcU88GOs9AqEBU6arbwanjqIFTV6DVekQgSjNuu8vuqO
	 6m4aEUBVRB9hF8lKrlP/vy+VaYMFFU41o/sGF/6o=
Date: Sun, 05 May 2024 17:57:54 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,xiehuan09@gmail.com,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,fengwei.yin@intel.com,david@redhat.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-arm64-override-clear_young_dirty_ptes-batch-helper.patch removed from -mm tree
Message-Id: <20240506005755.25062C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/arm64: override clear_young_dirty_ptes() batch helper
has been removed from the -mm tree.  Its filename was
     mm-arm64-override-clear_young_dirty_ptes-batch-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/arm64: override clear_young_dirty_ptes() batch helper
Date: Thu, 18 Apr 2024 21:44:33 +0800

The per-pte get_and_clear/modify/set approach would result in
unfolding/refolding for contpte mappings on arm64.  So we need to override
clear_young_dirty_ptes() for arm64 to avoid it.

Link: https://lkml.kernel.org/r/20240418134435.6092-3-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: Barry Song <21cnbao@gmail.com>
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   55 +++++++++++++++++++++++++++++
 arch/arm64/mm/contpte.c          |   29 +++++++++++++++
 2 files changed, 84 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~mm-arm64-override-clear_young_dirty_ptes-batch-helper
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1223,6 +1223,46 @@ static inline void __wrprotect_ptes(stru
 		__ptep_set_wrprotect(mm, address, ptep);
 }
 
+static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
+					   unsigned long addr, pte_t *ptep,
+					   pte_t pte, cydp_t flags)
+{
+	pte_t old_pte;
+
+	do {
+		old_pte = pte;
+
+		if (flags & CYDP_CLEAR_YOUNG)
+			pte = pte_mkold(pte);
+		if (flags & CYDP_CLEAR_DIRTY)
+			pte = pte_mkclean(pte);
+
+		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+					       pte_val(old_pte), pte_val(pte));
+	} while (pte_val(pte) != pte_val(old_pte));
+}
+
+static inline void __clear_young_dirty_ptes(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep,
+					    unsigned int nr, cydp_t flags)
+{
+	pte_t pte;
+
+	for (;;) {
+		pte = __ptep_get(ptep);
+
+		if (flags == (CYDP_CLEAR_YOUNG | CYDP_CLEAR_DIRTY))
+			__set_pte(ptep, pte_mkclean(pte_mkold(pte)));
+		else
+			__clear_young_dirty_pte(vma, addr, ptep, pte, flags);
+
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_PMDP_SET_WRPROTECT
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
@@ -1379,6 +1419,9 @@ extern void contpte_wrprotect_ptes(struc
 extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 				unsigned long addr, pte_t *ptep,
 				pte_t entry, int dirty);
+extern void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep,
+				unsigned int nr, cydp_t flags);
 
 static __always_inline void contpte_try_fold(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep, pte_t pte)
@@ -1603,6 +1646,17 @@ static inline int ptep_set_access_flags(
 	return contpte_ptep_set_access_flags(vma, addr, ptep, entry, dirty);
 }
 
+#define clear_young_dirty_ptes clear_young_dirty_ptes
+static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep,
+					  unsigned int nr, cydp_t flags)
+{
+	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
+		__clear_young_dirty_ptes(vma, addr, ptep, nr, flags);
+	else
+		contpte_clear_young_dirty_ptes(vma, addr, ptep, nr, flags);
+}
+
 #else /* CONFIG_ARM64_CONTPTE */
 
 #define ptep_get				__ptep_get
@@ -1622,6 +1676,7 @@ static inline int ptep_set_access_flags(
 #define wrprotect_ptes				__wrprotect_ptes
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags			__ptep_set_access_flags
+#define clear_young_dirty_ptes			__clear_young_dirty_ptes
 
 #endif /* CONFIG_ARM64_CONTPTE */
 
--- a/arch/arm64/mm/contpte.c~mm-arm64-override-clear_young_dirty_ptes-batch-helper
+++ a/arch/arm64/mm/contpte.c
@@ -361,6 +361,35 @@ void contpte_wrprotect_ptes(struct mm_st
 }
 EXPORT_SYMBOL_GPL(contpte_wrprotect_ptes);
 
+void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
+				    unsigned long addr, pte_t *ptep,
+				    unsigned int nr, cydp_t flags)
+{
+	/*
+	 * We can safely clear access/dirty without needing to unfold from
+	 * the architectures perspective, even when contpte is set. If the
+	 * range starts or ends midway through a contpte block, we can just
+	 * expand to include the full contpte block. While this is not
+	 * exactly what the core-mm asked for, it tracks access/dirty per
+	 * folio, not per page. And since we only create a contpte block
+	 * when it is covered by a single folio, we can get away with
+	 * clearing access/dirty for the whole block.
+	 */
+	unsigned long start = addr;
+	unsigned long end = start + nr;
+
+	if (pte_cont(__ptep_get(ptep + nr - 1)))
+		end = ALIGN(end, CONT_PTE_SIZE);
+
+	if (pte_cont(__ptep_get(ptep))) {
+		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
+		ptep = contpte_align_down(ptep);
+	}
+
+	__clear_young_dirty_ptes(vma, start, ptep, end - start, flags);
+}
+EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
+
 int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep,
 					pte_t entry, int dirty)
_

Patches currently in -mm which might be from ioworker0@gmail.com are


