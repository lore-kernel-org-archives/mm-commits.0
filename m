Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD4C29A32D
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298533; cv=none; b=m/7EnOVJbEIJ/byNzAoQ2qVrXbTSrhP9rTCXgUnbPDyTkz6j8jaZf99uQfe/uKTxJ9cRCW3L7bx6szTy7pTpipCDXGYLpVfwtDxUl6BG4siyR1vBm4nYmJabpzXLQrM8xsiw2U/yVu4wyoHXjTbPcVwK0cvQ5ljQXICKXrc+ByY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298533; c=relaxed/simple;
	bh=LEyWUEBjrmLG1iN/Xf6IZxLowx0/CczQrJ6fI26t1mo=;
	h=Date:To:From:Subject:Message-Id; b=kRErGnPTxZzlfpMTc+5HjQVibHjRSG/SGmIEy6/aCzfTt/ch64s6zVL2aTBjlN4eBtSkOmDy6PwTCyfabhjEGQS4IG32llWgpywsNCB1Grs0lNk2MenB3RUVSn8T/f6QnKnPKBW1kTjGpY05K94QnjJOYUv0An4vMZQKCFf9Wwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hD/Uv1F/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hD/Uv1F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CC81F000E9;
	Wed, 29 Jul 2026 04:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298531;
	bh=bfHyP/X3KlGXF4GAR5oWRNheBDzvBfN4Wns9+NGfTDM=;
	h=Date:To:From:Subject;
	b=hD/Uv1F/0ioPmfAsouG+pAO9k1mhVLK+N8bEzlVqernHSyhN8Yi6SQ7yzVaCc+uiS
	 YnAaSdbfJ1khTWqRl9PgGxwOpgHoCZKzjo11ieDRQXjmHqleH8hR4UNK5iMoSyEd6G
	 i7R/quR7Qoyug5iJVdoumZvTHq9weXe664eFu0s8=
Date: Tue, 28 Jul 2026 21:15:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,davem@davemloft.net,andreas@gaisler.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch removed from -mm tree
Message-Id: <20260729041531.31CC81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cleanup clear_not_present_full_ptes() and rename to clear_non_present_ptes()
has been removed from the -mm tree.  Its filename was
     mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: cleanup clear_not_present_full_ptes() and rename to clear_non_present_ptes()
Date: Mon, 29 Jun 2026 15:49:49 +0200

Let's clean it up a bit:

(1) There is no need to pass "full" anymore.

(2) No architecture overwrites it, and there isn't really a good reason
    to do so when dealing with non-present PTEs.

(3) While at it, call it "non-present", similar to copy_nonpresent_pte()
    and zap_nonpresent_ptes().

It's a shame that we have clear_non_present_ptes() correspond to
pte_clear() and clear_ptes() correspond to ptep_get_and_clear*().

Link: https://lore.kernel.org/20260629-clear_not_present_full_ptes-v2-3-96089871a1e7@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   14 ++++----------
 mm/madvise.c            |    2 +-
 mm/memory.c             |    2 +-
 3 files changed, 6 insertions(+), 12 deletions(-)

--- a/include/linux/pgtable.h~mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes
+++ a/include/linux/pgtable.h
@@ -988,24 +988,19 @@ static inline void update_mmu_tlb(struct
 	update_mmu_tlb_range(vma, address, ptep, 1);
 }
 
-#ifndef clear_not_present_full_ptes
 /**
- * clear_not_present_full_ptes - Clear multiple not present PTEs which are
- *				 consecutive in the pgtable.
+ * clear_nonpresent_ptes - Clear multiple non-present PTEs which are
+ *			    consecutive in the pgtable.
  * @mm: Address space the ptes represent.
  * @addr: Address of the first pte.
  * @ptep: Page table pointer for the first entry.
  * @nr: Number of entries to clear.
- * @full: Whether we are clearing a full mm.
- *
- * May be overridden by the architecture; otherwise, implemented as a simple
- * loop over pte_clear().
  *
  * Context: The caller holds the page table lock.  The PTEs are all not present.
  * The PTEs are all in the same PMD.
  */
-static inline void clear_not_present_full_ptes(struct mm_struct *mm,
-		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
+static inline void clear_nonpresent_ptes(struct mm_struct *mm,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	(void)addr;
 
@@ -1017,7 +1012,6 @@ static inline void clear_not_present_ful
 		addr += PAGE_SIZE;
 	}
 }
-#endif
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_FLUSH
 extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
--- a/mm/madvise.c~mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes
+++ a/mm/madvise.c
@@ -694,7 +694,7 @@ static int madvise_free_pte_range(pmd_t
 				nr = swap_pte_batch(pte, max_nr, ptent);
 				nr_swap -= nr;
 				swap_put_entries_direct(entry, nr);
-				clear_not_present_full_ptes(mm, addr, pte, nr, tlb->fullmm);
+				clear_nonpresent_ptes(mm, addr, pte, nr);
 			} else if (softleaf_is_hwpoison(entry) ||
 				   softleaf_is_poison_marker(entry)) {
 				pte_clear(mm, addr, pte);
--- a/mm/memory.c~mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes
+++ a/mm/memory.c
@@ -1797,7 +1797,7 @@ static inline int zap_nonpresent_ptes(st
 		pr_alert("unrecognized swap entry 0x%lx\n", entry.val);
 		WARN_ON_ONCE(1);
 	}
-	clear_not_present_full_ptes(vma->vm_mm, addr, pte, nr, tlb->fullmm);
+	clear_nonpresent_ptes(vma->vm_mm, addr, pte, nr);
 	*any_skipped = zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details, ptent);
 
 	return nr;
_

Patches currently in -mm which might be from david@kernel.org are

x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

