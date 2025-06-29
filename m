Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C35235046
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 23:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751238376; cv=none; b=FE/ti6cxLldzQHiOvwGGc1vxc1vMdTvPWotZRd/0uv5cMJfA5HdgROI0MH0sG4IO7xD4NGBWRNstb1rwiL9ODfU4VVBDvtbMxcEZjWeYhuy4uVlB3aPCkQlHfrMFbXzDMenjoFYijxZQgE72t0pGC7T+59FRXuGo7EC3nAWREZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751238376; c=relaxed/simple;
	bh=ucrx9I0sV5/ILD3uRrNMtGZiXFdlzWrRjGytR0CGsiU=;
	h=Date:To:From:Subject:Message-Id; b=uSihdDtEYPT3gNlxLetDlGH0J0wdfxpHLPXd9J4E8netcXxI4r5ujXuW0GsCBcy/5kn38EWgEjHFO8XjBdPtxED1vgmt2n5i99tq+4m9aqmX1B+sNr8TpOpq7xxcoyOfhIljLgDdj7sYvgg4YUc6QBTfByXaQh+uboHzk+3AzII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TkcNbhpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TkcNbhpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA31BC4CEEB;
	Sun, 29 Jun 2025 23:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751238375;
	bh=ucrx9I0sV5/ILD3uRrNMtGZiXFdlzWrRjGytR0CGsiU=;
	h=Date:To:From:Subject:From;
	b=TkcNbhpNjP8fDlRFntqKD1b4YH5K2DzybtzAnzVY0QLnPzrBtJijVXY+fl9Tl9kOS
	 5SY1J4PwdHuRWnSECXprcmbnhfUB+TgKT3TQI8Jqn0liYBt/AbZiRf8u9IDt1ygXSA
	 Uxb4u17p2ZYowjXOtn3wSyZdEIUbC4hBblOE8JkY=
Date: Sun, 29 Jun 2025 16:06:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch added to mm-new branch
Message-Id: <20250629230615.AA31BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add batched versions of ptep_modify_prot_start/commit
has been added to the -mm mm-new branch.  Its filename is
     mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch

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
Subject: mm: add batched versions of ptep_modify_prot_start/commit
Date: Sat, 28 Jun 2025 17:04:33 +0530

Batch ptep_modify_prot_start/commit in preparation for optimizing
mprotect.  Architecture can override these helpers; in case not, they are
implemented as a simple loop over the corresponding single pte helpers.

Link: https://lkml.kernel.org/r/20250628113435.46678-3-dev.jain@arm.com
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

 include/linux/pgtable.h |   83 +++++++++++++++++++++++++++++++++++++-
 mm/mprotect.c           |    4 -
 2 files changed, 84 insertions(+), 3 deletions(-)

--- a/include/linux/pgtable.h~mm-add-batched-versions-of-ptep_modify_prot_start-commit
+++ a/include/linux/pgtable.h
@@ -1331,7 +1331,8 @@ static inline pte_t ptep_modify_prot_sta
 
 /*
  * Commit an update to a pte, leaving any hardware-controlled bits in
- * the PTE unmodified.
+ * the PTE unmodified. The pte may have been "upgraded" w.r.t a/d bits compared
+ * to the old_pte, as in, it may have a/d bits on which were off in old_pte.
  */
 static inline void ptep_modify_prot_commit(struct vm_area_struct *vma,
 					   unsigned long addr,
@@ -1340,6 +1341,86 @@ static inline void ptep_modify_prot_comm
 	__ptep_modify_prot_commit(vma, addr, ptep, pte);
 }
 #endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
+
+/**
+ * modify_prot_start_ptes - Start a pte protection read-modify-write transaction
+ * over a batch of ptes, which protects against asynchronous hardware
+ * modifications to the ptes. The intention is not to prevent the hardware from
+ * making pte updates, but to prevent any updates it may make from being lost.
+ * Please see the comment above ptep_modify_prot_start() for full description.
+ *
+ * @vma: The virtual memory area the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries.
+ *
+ * May be overridden by the architecture; otherwise, implemented as a simple
+ * loop over ptep_modify_prot_start(), collecting the a/d bits from each pte
+ * in the batch.
+ *
+ * Note that PTE bits in the PTE batch besides the PFN can differ.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ * Since the batch is determined from folio_pte_batch, the PTEs must differ
+ * only in a/d bits (and the soft dirty bit; see fpb_t flags in
+ * mprotect_folio_pte_batch()).
+ */
+#ifndef modify_prot_start_ptes
+static inline pte_t modify_prot_start_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
+{
+	pte_t pte, tmp_pte;
+
+	pte = ptep_modify_prot_start(vma, addr, ptep);
+	while (--nr) {
+		ptep++;
+		addr += PAGE_SIZE;
+		tmp_pte = ptep_modify_prot_start(vma, addr, ptep);
+		if (pte_dirty(tmp_pte))
+			pte = pte_mkdirty(pte);
+		if (pte_young(tmp_pte))
+			pte = pte_mkyoung(pte);
+	}
+	return pte;
+}
+#endif
+
+/**
+ * modify_prot_commit_ptes - Commit an update to a batch of ptes, leaving any
+ * hardware-controlled bits in the PTE unmodified.
+ *
+ * @vma: The virtual memory area the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @old_pte: Old page table entry (for the first entry) which is now cleared.
+ * @pte: New page table entry to be set.
+ * @nr: Number of entries.
+ *
+ * May be overridden by the architecture; otherwise, implemented as a simple
+ * loop over ptep_modify_prot_commit().
+ *
+ * Context: The caller holds the page table lock. The PTEs are all in the same
+ * PMD. On exit, the set ptes in the batch map the same folio. The pte may have
+ * been "upgraded" w.r.t a/d bits compared to the old_pte, as in, it may have
+ * a/d bits on which were off in old_pte.
+ */
+#ifndef modify_prot_commit_ptes
+static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long addr,
+		pte_t *ptep, pte_t old_pte, pte_t pte, unsigned int nr)
+{
+	int i;
+
+	for (i = 0; i < nr; ++i) {
+		ptep_modify_prot_commit(vma, addr, ptep, old_pte, pte);
+		ptep++;
+		addr += PAGE_SIZE;
+		old_pte = pte_next_pfn(old_pte);
+		pte = pte_next_pfn(pte);
+	}
+}
+#endif
+
 #endif /* CONFIG_MMU */
 
 /*
--- a/mm/mprotect.c~mm-add-batched-versions-of-ptep_modify_prot_start-commit
+++ a/mm/mprotect.c
@@ -206,7 +206,7 @@ static long change_pte_range(struct mmu_
 					continue;
 			}
 
-			oldpte = ptep_modify_prot_start(vma, addr, pte);
+			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
 			ptent = pte_modify(oldpte, newprot);
 
 			if (uffd_wp)
@@ -232,7 +232,7 @@ static long change_pte_range(struct mmu_
 			    can_change_pte_writable(vma, addr, ptent))
 				ptent = pte_mkwrite(ptent, vma);
 
-			ptep_modify_prot_commit(vma, addr, pte, oldpte, ptent);
+			modify_prot_commit_ptes(vma, addr, pte, oldpte, ptent, nr_ptes);
 			if (pte_needs_flush(oldpte, ptent))
 				tlb_flush_pte_range(tlb, addr, PAGE_SIZE);
 			pages++;
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

