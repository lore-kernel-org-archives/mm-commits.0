Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B45449B13
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 23:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784591211; cv=none; b=OauCCWXQ4t1rpWxBzFTnhV9BgOhHou25ZgnWgWUVitav6iS4m5/5mfsYhSFtEcvoKkyFSqlCNPYCV1AQP55sDuBLe3hDiuefGdMhKNQrha3b3+WvKiHbKSw+qAJXZRqyw8c3kCfocJ57DZ0F0nu5H9qbaIECwCLxi5THNP+TB34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784591211; c=relaxed/simple;
	bh=fmUc0UkOcS+2nBstsfFI36+SmGF42SD1dGGGvhLCUc8=;
	h=Date:To:From:Subject:Message-Id; b=Ntd4Nkj/KukpeN/CRfw+gLfkMgN200xkiX1YiJkzm8Mqb0EdewnV7z8QoaTHeZlShCIuMF7kVCs6n3Y0aJDsC5phsZwsUx43kvd31QSA92Dp/RpOD5CDzmLMXLTXd4NnW9Vj2xHLIKrKxseI5zDa96u6aOsFMlyTZLQ0kb2njcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nHIfMEKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nHIfMEKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2181F000E9;
	Mon, 20 Jul 2026 23:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784591209;
	bh=tef0YJjCJrz5uA7h3TSyZohujgWJcS6MO+xN9WXreNk=;
	h=Date:To:From:Subject;
	b=nHIfMEKB86ZT/D2r/T7C9XeGUqIrE7sYDDHa/EDBX+/iK/QJTyNQ8eFmxjPZV2JoT
	 K9fO158t0FaaVvAdoxiO3W68ZwqRp9q4qY2U5y9WUO8gK6t9Lg3sDEDwjgzDuBpWMp
	 kEl/5QjbOKjRXiGnHOFUEnA4gv7MoeqPLyPRIbPA=
Date: Mon, 20 Jul 2026 16:46:49 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch added to mm-new branch
Message-Id: <20260720234649.BB2181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: move pte_install_uffd_wp_if_needed() into memory.c
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/memory: move pte_install_uffd_wp_if_needed() into memory.c
Date: Mon, 20 Jul 2026 06:55:05 +0000

Patch series "Batch unmap of uffd-wp file folios", v2.

Currently, batched unmapping is supported if:

1) folio is a file folio, not belonging to uffd-wp VMA
2) folio is anonymous and not swapbacked (lazyfree), not belonging to
   uffd-wp VMA

So the cases which are not supported are

1) folio belonging to uffd-wp VMA
2) folio is anonymous and swapbacked

It is easy to see that this adds a lot of cognitive load while reading
try_to_unmap_one - we need to remember throughout whether nr_pages == 1 or
> 1.

The uffd-wp handling in try_to_unmap_one is regarding preserving the
uffd-wp state for file folios via pte_install_uffd_wp_if_needed (for anon
folio, we handle that while constructing the swap pte).

Stop special casing on uffd-wp VMAs by simply adding batching support to
pte_install_uffd_wp_if_needed.


This patch (of 3):

pte_install_uffd_wp_if_needed() has grown too large for mm_inline.h.  Move
it to memory.c.

This helper is only used inside mm/, so declare it in mm/internal.h
instead of a public header.

While at it, convert the comment to kerneldoc and rename the local
arguments from pte/pteval to ptep/pte so the pointer and PTE value are
easier to distinguish.

Link: https://lore.kernel.org/20260720065508.2695106-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260720065508.2695106-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   53 -------------------------------
 mm/internal.h             |    3 +
 mm/memory.c               |   60 ++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 53 deletions(-)

--- a/include/linux/mm_inline.h~mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc
+++ a/include/linux/mm_inline.h
@@ -566,59 +566,6 @@ static inline pte_marker copy_pte_marker
 	return dstm;
 }
 
-/*
- * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
- * replace a none pte.  NOTE!  This should only be called when *pte is already
- * cleared so we will never accidentally replace something valuable.  Meanwhile
- * none pte also means we are not demoting the pte so tlb flushed is not needed.
- * E.g., when pte cleared the caller should have taken care of the tlb flush.
- *
- * Must be called with pgtable lock held so that no thread will see the none
- * pte, and if they see it, they'll fault and serialize at the pgtable lock.
- *
- * Returns true if an uffd-wp pte was installed, false otherwise.
- */
-static inline bool
-pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
-			      pte_t *pte, pte_t pteval)
-{
-	bool arm_uffd_pte = false;
-
-	if (!uffd_supports_wp_marker())
-		return false;
-
-	/* The current status of the pte should be "cleared" before calling */
-	WARN_ON_ONCE(!pte_none(ptep_get(pte)));
-
-	/*
-	 * NOTE: userfaultfd_wp_unpopulated() doesn't need this whole
-	 * thing, because when zapping either it means it's dropping the
-	 * page, or in TTU where the present pte will be quickly replaced
-	 * with a swap pte.  There's no way of leaking the bit.
-	 */
-	if (vma_is_anonymous(vma) || !userfaultfd_wp(vma))
-		return false;
-
-	/* A uffd-wp wr-protected normal pte */
-	if (unlikely(pte_present(pteval) && pte_uffd(pteval)))
-		arm_uffd_pte = true;
-
-	/*
-	 * A uffd-wp wr-protected swap pte.  Note: this should even cover an
-	 * existing pte marker with uffd-wp bit set.
-	 */
-	if (unlikely(pte_swp_uffd_any(pteval)))
-		arm_uffd_pte = true;
-
-	if (unlikely(arm_uffd_pte)) {
-		set_pte_at(vma->vm_mm, addr, pte,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		return true;
-	}
-
-	return false;
-}
-
 static inline bool vma_has_recency(const struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
--- a/mm/internal.h~mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc
+++ a/mm/internal.h
@@ -280,6 +280,9 @@ void unmap_vmas(struct mmu_gather *tlb,
 
 #ifdef CONFIG_MMU
 
+bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte);
+
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
 	atomic_inc(&anon_vma->refcount);
--- a/mm/memory.c~mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc
+++ a/mm/memory.c
@@ -1677,6 +1677,66 @@ static inline bool zap_drop_markers(stru
 	return details->zap_flags & ZAP_FLAG_DROP_MARKER;
 }
 
+/**
+ * pte_install_uffd_wp_if_needed - install uffd-wp marker after clearing a PTE
+ * @vma: The VMA the page is mapped into.
+ * @addr: Address the page is mapped at.
+ * @ptep: Page table pointer for this entry.
+ * @pte: Old value of the entry pointed to by @ptep.
+ *
+ * If the PTE was write-protected by uffd-wp in any form, arm a special PTE
+ * to replace a none PTE. NOTE! This should only be called when the PTE is
+ * already cleared so we will never accidentally replace something valuable.
+ * Meanwhile none PTEs also mean we are not demoting the PTE so a TLB flush is
+ * not needed. E.g., when the PTE was cleared, the caller should have taken care
+ * of the TLB flush.
+ *
+ * Must be called with the page table lock held so that no thread will see the
+ * none PTE, and if they see it, they'll fault and serialize at the page table
+ * lock.
+ *
+ * Returns true if an uffd-wp PTE was installed, false otherwise.
+ */
+bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte)
+{
+	bool arm_uffd_pte = false;
+
+	if (!uffd_supports_wp_marker())
+		return false;
+
+	/* The current status of the pte should be "cleared" before calling */
+	WARN_ON_ONCE(!pte_none(ptep_get(ptep)));
+
+	/*
+	 * NOTE: userfaultfd_wp_unpopulated() doesn't need this whole
+	 * thing, because when zapping either it means it's dropping the
+	 * page, or in TTU where the present pte will be quickly replaced
+	 * with a swap pte.  There's no way of leaking the bit.
+	 */
+	if (vma_is_anonymous(vma) || !userfaultfd_wp(vma))
+		return false;
+
+	/* A uffd-wp wr-protected normal pte */
+	if (unlikely(pte_present(pte) && pte_uffd(pte)))
+		arm_uffd_pte = true;
+
+	/*
+	 * A uffd-wp wr-protected swap pte.  Note: this should even cover an
+	 * existing pte marker with uffd-wp bit set.
+	 */
+	if (unlikely(pte_swp_uffd_any(pte)))
+		arm_uffd_pte = true;
+
+	if (unlikely(arm_uffd_pte)) {
+		set_pte_at(vma->vm_mm, addr, ptep,
+			   make_pte_marker(PTE_MARKER_UFFD_WP));
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * This function makes sure that we'll replace the none pte with an uffd-wp
  * swap special pte marker when necessary. Must be with the pgtable lock held.
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch
mm-mprotect-drop-sub-from-batching-context.patch
arm64-make-huge_ptep_get-handled-unaligned-addresses.patch
mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-rmap-convert-page-folio-for-hwpoison-checks.patch
mm-rmap-add-try_to_unmap_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

