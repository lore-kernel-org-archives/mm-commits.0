Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F89F241CB2
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 23:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751238396; cv=none; b=sGUElobfLNaLSZhhWYcLI0wNYJGwOAurwj197kQ5PSfVK9SIAuGQIx+FhQkYDu3frtpGF/ZCDRIQtrSzQXrBld8/TK0a9hkFlYcSxhZxid40zrCUbZDtqHBO2eulQpwTSQxEPrc1tI6/s8/YrvTqCb6dnPYFuaSKRRdj5fyKC38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751238396; c=relaxed/simple;
	bh=Ebc+yL5U8VcNxi1vE1nDFYpUCPZI/uOTkLdgF5VAv5k=;
	h=Date:To:From:Subject:Message-Id; b=Ev8zvQT9jOVOQX3oEq+qmcQgM2FOhM1WLm0qbwBVcVMfrwfyP6VU7uTSEq49W5FekUTCz2b0TKO74jzdmBBcwiVDFTEIBYbHrMGr0Hc7q5pFj6s0BnJitO/CE2jyh0XbePC+9XkPvQjVXAem5eF43HJ2CBqcHt+WP07fRItin4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qD6SQZEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qD6SQZEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCCDC4CEEB;
	Sun, 29 Jun 2025 23:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751238396;
	bh=Ebc+yL5U8VcNxi1vE1nDFYpUCPZI/uOTkLdgF5VAv5k=;
	h=Date:To:From:Subject:From;
	b=qD6SQZEmApoCDOvZHgDjxi98MskP4brIBQAqa+D2o5/tsLStcWdSGGCeXetuRuHVE
	 P1EFv+JFUbKgfa9gci6o4GiZmWWSD1nm3B4Qehq72I/JdXxXU2e3nbK6aI8hzrdyLc
	 M6NdJfOpBntv0/UCHPvy4azE+IaiLEgQD0movGhY=
Date: Sun, 29 Jun 2025 16:06:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch added to mm-new branch
Message-Id: <20250629230636.0FCCDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: add batched versions of ptep_modify_prot_start/commit
has been added to the -mm mm-new branch.  Its filename is
     arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Dev Jain <dev.jain@arm.com>
Subject: arm64: add batched versions of ptep_modify_prot_start/commit
Date: Sat, 28 Jun 2025 17:04:35 +0530

Override the generic definition of modify_prot_start_ptes() to use
get_and_clear_full_ptes().  This helper does a TLBI only for the starting
and ending contpte block of the range, whereas the current implementation
will call ptep_get_and_clear() for every contpte block, thus doing a TLBI
on every contpte block.  Therefore, we have a performance win.

The arm64 definition of pte_accessible() allows us to batch in the errata
specific case:

#define pte_accessible(mm, pte)	\
	(mm_tlb_flush_pending(mm) ? pte_present(pte) : pte_valid(pte))

All ptes are obviously present in the folio batch, and they are also valid.

Override the generic definition of modify_prot_commit_ptes() to simply use
set_ptes() to map the new ptes into the pagetable.

Link: https://lkml.kernel.org/r/20250628113435.46678-5-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   10 ++++++++++
 arch/arm64/mm/mmu.c              |   28 +++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-add-batched-versions-of-ptep_modify_prot_start-commit
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1643,6 +1643,16 @@ extern void ptep_modify_prot_commit(stru
 				    unsigned long addr, pte_t *ptep,
 				    pte_t old_pte, pte_t new_pte);
 
+#define modify_prot_start_ptes modify_prot_start_ptes
+extern pte_t modify_prot_start_ptes(struct vm_area_struct *vma,
+				    unsigned long addr, pte_t *ptep,
+				    unsigned int nr);
+
+#define modify_prot_commit_ptes modify_prot_commit_ptes
+extern void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long addr,
+				    pte_t *ptep, pte_t old_pte, pte_t pte,
+				    unsigned int nr);
+
 #ifdef CONFIG_ARM64_CONTPTE
 
 /*
--- a/arch/arm64/mm/mmu.c~arm64-add-batched-versions-of-ptep_modify_prot_start-commit
+++ a/arch/arm64/mm/mmu.c
@@ -26,6 +26,7 @@
 #include <linux/set_memory.h>
 #include <linux/kfence.h>
 #include <linux/pkeys.h>
+#include <linux/mm_inline.h>
 
 #include <asm/barrier.h>
 #include <asm/cputype.h>
@@ -1524,24 +1525,41 @@ static int __init prevent_bootmem_remove
 early_initcall(prevent_bootmem_remove_init);
 #endif
 
-pte_t ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+pte_t modify_prot_start_ptes(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t *ptep, unsigned int nr)
 {
+	pte_t pte = get_and_clear_full_ptes(vma->vm_mm, addr, ptep, nr, 0);
+
 	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_2645198)) {
 		/*
 		 * Break-before-make (BBM) is required for all user space mappings
 		 * when the permission changes from executable to non-executable
 		 * in cases where cpu is affected with errata #2645198.
 		 */
-		if (pte_user_exec(ptep_get(ptep)))
-			return ptep_clear_flush(vma, addr, ptep);
+		if (pte_accessible(vma->vm_mm, pte) && pte_user_exec(pte))
+			__flush_tlb_range(vma, addr, nr * PAGE_SIZE,
+					  PAGE_SIZE, true, 3);
 	}
-	return ptep_get_and_clear(vma->vm_mm, addr, ptep);
+
+	return pte;
+}
+
+pte_t ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+{
+	return modify_prot_start_ptes(vma, addr, ptep, 1);
+}
+
+void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t *ptep, pte_t old_pte, pte_t pte,
+			     unsigned int nr)
+{
+	set_ptes(vma->vm_mm, addr, ptep, pte, nr);
 }
 
 void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
 			     pte_t old_pte, pte_t pte)
 {
-	set_pte_at(vma->vm_mm, addr, ptep, pte);
+	modify_prot_commit_ptes(vma, addr, ptep, old_pte, pte, 1);
 }
 
 /*
_

Patches currently in -mm which might be from dev.jain@arm.com are

xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch
maple-tree-use-goto-label-to-simplify-code.patch
mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch
mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch
mm-optimize-mprotect-by-pte-batching.patch
arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch

