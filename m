Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6590937BE75
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782753771; cv=none; b=W2vmbeSY2iDX844MqjM3/nIWIHDB74nySZtBTHczAmKv9fMxWH5gTFVfqFjvS0BRCe+Gen0htNojv2EP1qClJJKqpYET8GqCRIKxnEBfs9f4zqpOFKm7v1U20IMrkVyau6W9uCUA/c0vm9VfYHKFBftAcGZaLvY1R62DafK7GEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782753771; c=relaxed/simple;
	bh=aiqg3Gu9P8um88x5hGYKNQjoQuUe5b+oPm2kF0BlP08=;
	h=Date:To:From:Subject:Message-Id; b=KhCey8tQ/yqDbdCtMvolZjJYVvpPyhUsIt/hJyyqu9saif8W3LEgcVpuX4/3LxCFXFlUbLevxf1gLz28M4KvzWy/Bd4IZCuFL0bjp4o+Tvno3YZuFs80Bjfy3W47M+2YZgG2qHamIDvjvSlDOjUTo6WIzGEYd3k0LAgrfop+WoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HnwFtJGi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HnwFtJGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACAB1F000E9;
	Mon, 29 Jun 2026 17:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782753770;
	bh=WAYmfbiI66DrVNi24CexTpUaim+DIOAzjVPWd8Ie1Hw=;
	h=Date:To:From:Subject;
	b=HnwFtJGiqFHQKQ8bstn1dC1espORd/U2EZy12tP0pBVQ3p9nKvtl4SH1ouNnKMhdD
	 SQU2caqVHRyBXrfanYwQNc/2UNa8Ptf30w3MBhOo8aKQz6pSaoer5ZKxA92D0P2NG7
	 diQuj1PDXWfnEwQ9EJ442bCXpKQWrj+HMJ5BqOX4=
Date: Mon, 29 Jun 2026 10:22:49 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,davem@davemloft.net,andreas@gaisler.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch added to mm-new branch
Message-Id: <20260629172250.2ACAB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cleanup clear_not_present_full_ptes() and rename to clear_non_present_ptes()
has been added to the -mm mm-new branch.  Its filename is
     mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: cleanup clear_not_present_full_ptes() and rename to clear_non_present_ptes()
Date: Mon, 29 Jun 2026 15:49:49 +0200

Let's clean it up a bit:

(1) There is no need to pass "full" anymore.

(2) No architecture overwrites it, and there isn't really a good reason
    to do so when dealing with non-resent PTEs.

(3) While at it, call it "non-present", similar to copy_nonpresent_pte()
    and zap_nonpresent_ptes().

It's a shame that we have clear_non_present_ptes() correspond to
pte_clear() and clear_ptes() correspond to ptep_get_and_clear*().

Link: https://lore.kernel.org/20260629-clear_not_present_full_ptes-v2-3-96089871a1e7@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
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
@@ -695,7 +695,7 @@ static int madvise_free_pte_range(pmd_t
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

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch

