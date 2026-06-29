Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E31379C26
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 17:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782753769; cv=none; b=i8NeVQ66sxxbKTZ8swEiu9Q1ZKX9HtZV8FnBVl9ABx/U0Doj5a3GeRaotaRDnqGOddGizZtCSRMxIoegnMerHF7yemlSJ7Ce/LykE5RixYlhtW1yzNpdtpBCCEzenJmV6RMU30Tf1KWOclferV62TRKrMYj4C+pISMqYKa63QkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782753769; c=relaxed/simple;
	bh=Yu/cmF1kOP3/1i1OixOCIuV3q8a7rtr1v1OxAXR2/O0=;
	h=Date:To:From:Subject:Message-Id; b=CGSWalkx4BxB7Hlz8vPHyPyFF38fenUBpXbhRxQYSSlXzjlLY5O1zggYtgooxnnY6y66IWi729onoQ8Fkt9KOS2z9UpY9yLKfByBjDkxJ3vRNnQjlxITnF1Ajxc26wpgAEK2jxlGJOh86Guz3RUo13XZFI0aP1NIqkKMvm80l58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1z8RbC8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1z8RbC8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2CC1F000E9;
	Mon, 29 Jun 2026 17:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782753767;
	bh=t8SnObeHSJozUo06K11YsvIQwA6VS7eWyWwdT854Pes=;
	h=Date:To:From:Subject;
	b=1z8RbC8DKaB/7GJgcd2DxblfqJTy+2cGD2n0U4Tdg4BwoNJY2nluMKyJdUEz34Xt2
	 v9+9KsL4s0pzenlx55XMLJyqEZplfb/l2P1ZY1qzD6QIC6hdglsEFptnLfuLXw9ZhY
	 MyTn636rS/TosQYKVuXlYwkN2JweJJ1OB4mDJ1YQ=
Date: Mon, 29 Jun 2026 10:22:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,davem@davemloft.net,andreas@gaisler.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-pte_clear_not_present_full.patch added to mm-new branch
Message-Id: <20260629172247.9A2CC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop pte_clear_not_present_full()
has been added to the -mm mm-new branch.  Its filename is
     mm-drop-pte_clear_not_present_full.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-pte_clear_not_present_full.patch

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
Subject: mm: drop pte_clear_not_present_full()
Date: Mon, 29 Jun 2026 15:49:48 +0200

In general, there is no good reason to do anything special when clearing
non-present PTEs.

In theory, HW that does have to invalidate TLBs for non-present PTEs could
benefit from a "full" parameter, but fortunately
pte_clear_not_present_full() is not wired up anymore ...  and there would
have to be something very convincing for us to care about that to re-add
it.

So, let's just use pte_clear() directly now.  To avoid the compiler
complaining on some configs about unused "addr" parameter, silence that
here.

Link: https://lore.kernel.org/20260629-clear_not_present_full_ptes-v2-2-96089871a1e7@kernel.org
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

 include/linux/pgtable.h |   21 ++++-----------------
 mm/madvise.c            |    4 ++--
 2 files changed, 6 insertions(+), 19 deletions(-)

--- a/include/linux/pgtable.h~mm-drop-pte_clear_not_present_full
+++ a/include/linux/pgtable.h
@@ -988,21 +988,6 @@ static inline void update_mmu_tlb(struct
 	update_mmu_tlb_range(vma, address, ptep, 1);
 }
 
-/*
- * Some architectures may be able to avoid expensive synchronization
- * primitives when modifications are made to PTE's which are already
- * not present, or in the process of an address space destruction.
- */
-#ifndef __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
-static inline void pte_clear_not_present_full(struct mm_struct *mm,
-					      unsigned long address,
-					      pte_t *ptep,
-					      int full)
-{
-	pte_clear(mm, address, ptep);
-}
-#endif
-
 #ifndef clear_not_present_full_ptes
 /**
  * clear_not_present_full_ptes - Clear multiple not present PTEs which are
@@ -1014,7 +999,7 @@ static inline void pte_clear_not_present
  * @full: Whether we are clearing a full mm.
  *
  * May be overridden by the architecture; otherwise, implemented as a simple
- * loop over pte_clear_not_present_full().
+ * loop over pte_clear().
  *
  * Context: The caller holds the page table lock.  The PTEs are all not present.
  * The PTEs are all in the same PMD.
@@ -1022,8 +1007,10 @@ static inline void pte_clear_not_present
 static inline void clear_not_present_full_ptes(struct mm_struct *mm,
 		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
 {
+	(void)addr;
+
 	for (;;) {
-		pte_clear_not_present_full(mm, addr, ptep, full);
+		pte_clear(mm, addr, ptep);
 		if (--nr == 0)
 			break;
 		ptep++;
--- a/mm/madvise.c~mm-drop-pte_clear_not_present_full
+++ a/mm/madvise.c
@@ -698,7 +698,7 @@ static int madvise_free_pte_range(pmd_t
 				clear_not_present_full_ptes(mm, addr, pte, nr, tlb->fullmm);
 			} else if (softleaf_is_hwpoison(entry) ||
 				   softleaf_is_poison_marker(entry)) {
-				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+				pte_clear(mm, addr, pte);
 			}
 			continue;
 		}
@@ -1234,7 +1234,7 @@ static int guard_remove_pte_entry(pte_t
 
 	if (is_guard_pte_marker(ptent)) {
 		/* Simply clear the PTE marker. */
-		pte_clear_not_present_full(walk->mm, addr, pte, false);
+		pte_clear(walk->mm, addr, pte);
 		update_mmu_cache(walk->vma, addr, pte);
 	}
 
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch

