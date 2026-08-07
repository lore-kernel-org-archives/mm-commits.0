Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD503B7752
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068137; cv=none; b=V7DVbUk1AigpPRk9ja3MZL+/n1VpF/22HeICwcx3aUrC/jZcvnbBaXrkSF5wd/JE1fBCletstcMa4SzOpwD6HWQ8eLbVbT1jdAKKzFk5GG+mD7XxmgVBYPSAyi5S/CP0+j71cIJtIJLOMtHuABum9pbH+B31wU4GYjq/JL1ByLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068137; c=relaxed/simple;
	bh=VwjKxmEVi8w1QRSlO3DWSGjDkAi8xpPs5DiH2PrJVWs=;
	h=Date:To:From:Subject:Message-Id; b=WYhM6Qs3jI5+yPpFzJvG2kGcxn5YHUcIy5oLOXlZGZQFX8zFL47zt+34YyM8GLCxty5vOnfpGHK8CrsnnjbJ0U0NMMF3j51lWnV1kCwtI/VW/GFRRDhjfhKuhmyJ9GJuEiI+3g9lGkUApNRb/OzRrY1ifY9oYoE1jqA5MXJmn/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qTd/GacX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qTd/GacX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F421F00A3A;
	Fri,  7 Aug 2026 02:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068135;
	bh=zeDCxXmX3kE1E2/sT4tJ2M9uure3PH4UvzS13g54hSU=;
	h=Date:To:From:Subject;
	b=qTd/GacXQ8+Fh/DQVQvgqNsx0yz2ywbN6NJUai3ONLmvTepImakI896eB0Tk1XR32
	 fiM1Qz08ez7znx45cjSO4ZuVPKSL5NJ09SfJGwpYNVojmrEUpoPYZNbLhGTmAiLDCi
	 0oQSBLsoohSCC7Dr7wEjn0r+fHlVg9SdlyEKeclk=
Date: Thu, 06 Aug 2026 19:02:15 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-batch-set-uffd-wp-markers-during-zapping.patch removed from -mm tree
Message-Id: <20260807020215.D1F421F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: batch set uffd-wp markers during zapping
has been removed from the -mm tree.  Its filename was
     mm-memory-batch-set-uffd-wp-markers-during-zapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/memory: batch set uffd-wp markers during zapping
Date: Mon, 20 Jul 2026 06:55:06 +0000

Enable batch setting of uffd-wp PTE markers.

The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
that nr through either folio_pte_batch() or swap_pte_batch(), therefore
batching is correct:

1) All PTEs belong to the same type of VMA: anonymous or non-anonymous,
   wp-armed or non-wp-armed.

2) All PTEs are either marked with uffd-wp or not marked with uffd-wp;
   the same applies to the pte_swp_uffd_any() check.

3) uffd_supports_wp_marker() is independent of the function parameters.

Use set_pte_at() in a loop instead of set_ptes(), because set_ptes()
cannot handle nonpresent to nonpresent conversion for nr_pages > 1.

Rename the helper to cond_install_uffd_wp_ptes().

Link: https://lore.kernel.org/20260720065508.2695106-3-dev.jain@arm.com
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

 mm/internal.h |    5 ++-
 mm/memory.c   |   61 +++++++++++++++++++-----------------------------
 mm/rmap.c     |    2 -
 3 files changed, 29 insertions(+), 39 deletions(-)

--- a/mm/internal.h~mm-memory-batch-set-uffd-wp-markers-during-zapping
+++ a/mm/internal.h
@@ -276,8 +276,9 @@ void unmap_vmas(struct mmu_gather *tlb,
 
 #ifdef CONFIG_MMU
 
-bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t pte);
+bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte,
+		unsigned long nr_ptes);
 
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
--- a/mm/memory.c~mm-memory-batch-set-uffd-wp-markers-during-zapping
+++ a/mm/memory.c
@@ -1620,27 +1620,29 @@ static inline bool zap_drop_markers(stru
 }
 
 /**
- * pte_install_uffd_wp_if_needed - install uffd-wp marker after clearing a PTE
- * @vma: The VMA the page is mapped into.
- * @addr: Address the page is mapped at.
- * @ptep: Page table pointer for this entry.
+ * cond_install_uffd_wp_ptes - install uffd-wp markers after clearing PTEs
+ * @vma: The VMA the pages are mapped into.
+ * @addr: Address the first page of this batch is mapped at.
+ * @ptep: Page table pointer for the first entry of this batch.
  * @pte: Old value of the entry pointed to by @ptep.
+ * @nr_ptes: Number of entries to install.
  *
- * If the PTE was write-protected by uffd-wp in any form, arm a special PTE
- * to replace a none PTE. NOTE! This should only be called when the PTE is
+ * If the PTEs were write-protected by uffd-wp in any form, arm special PTEs
+ * to replace none PTEs. NOTE! This should only be called when the PTEs are
  * already cleared so we will never accidentally replace something valuable.
- * Meanwhile none PTEs also mean we are not demoting the PTE so a TLB flush is
- * not needed. E.g., when the PTE was cleared, the caller should have taken care
- * of the TLB flush.
+ * Meanwhile none PTEs also mean we are not demoting the PTEs so a TLB flush is
+ * not needed. E.g., when the PTEs were cleared, the caller should have taken
+ * care of the TLB flush.
  *
  * Must be called with the page table lock held so that no thread will see the
- * none PTE, and if they see it, they'll fault and serialize at the page table
+ * none PTEs, and if they see them, they'll fault and serialize at the page table
  * lock.
  *
- * Returns true if an uffd-wp PTE was installed, false otherwise.
+ * Returns true if uffd-wp PTEs were installed, false otherwise.
  */
-bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t pte)
+bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte,
+		unsigned long nr_ptes)
 {
 	bool arm_uffd_pte = false;
 
@@ -1670,13 +1672,19 @@ bool pte_install_uffd_wp_if_needed(struc
 	if (unlikely(pte_swp_uffd_any(pte)))
 		arm_uffd_pte = true;
 
-	if (unlikely(arm_uffd_pte)) {
+	if (likely(!arm_uffd_pte))
+		return false;
+
+	for (;;) {
 		set_pte_at(vma->vm_mm, addr, ptep,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		return true;
+		if (--nr_ptes == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
 	}
 
-	return false;
+	return true;
 }
 
 /*
@@ -1690,29 +1698,10 @@ zap_install_uffd_wp_if_needed(struct vm_
 			      unsigned long addr, pte_t *pte, int nr,
 			      struct zap_details *details, pte_t pteval)
 {
-	bool was_installed = false;
-
-	if (!uffd_supports_wp_marker())
-		return false;
-
-	/* Zap on anonymous always means dropping everything */
-	if (vma_is_anonymous(vma))
-		return false;
-
 	if (zap_drop_markers(details))
 		return false;
 
-	for (;;) {
-		/* the PFN in the PTE is irrelevant. */
-		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
-			was_installed = true;
-		if (--nr == 0)
-			break;
-		pte++;
-		addr += PAGE_SIZE;
-	}
-
-	return was_installed;
+	return cond_install_uffd_wp_ptes(vma, addr, pte, pteval, nr);
 }
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
--- a/mm/rmap.c~mm-memory-batch-set-uffd-wp-markers-during-zapping
+++ a/mm/rmap.c
@@ -2345,7 +2345,7 @@ static bool try_to_unmap_one(struct foli
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, 1);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
_

Patches currently in -mm which might be from dev.jain@arm.com are


