Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7198322A4CC
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 23:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749511138; cv=none; b=s+jPLLM/GV2nXAp3OYRmAkM81cAHFmRU2Ny432LTVDrWioVZH3dmUEAnRLb1I0tz7Xm4EA1tJTeFU+2ODj+cp55fdT+uccJeM59j2VazPDqBeC16KrGIWFwhyDKQfatjzk2QAkXf6CKai5CFQ4zVBXTx7Nv37eYz3AurXtqN2qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749511138; c=relaxed/simple;
	bh=NdTA7oH1NfEVNuOlMD3pBsvRbc4LkSmlyhmg+faq6yk=;
	h=Date:To:From:Subject:Message-Id; b=XAnR9Ul4J3/sWw+/9O6mgrx9oTjLfs5bVWPYvOlOWq/APWUStTzAMxEqboDcsSLRKgFT+tR6kzC3xiOEQ8AreyFFnXn9ro7EY4246uamhKcYkvIeIHY+VZVllVSHTmPHJwqtJOC4MrK6BozxrelVqzXwKR2E6HJy2Ta4jl7mhlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NE50vVGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NE50vVGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FE6C4CEEB;
	Mon,  9 Jun 2025 23:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749511135;
	bh=NdTA7oH1NfEVNuOlMD3pBsvRbc4LkSmlyhmg+faq6yk=;
	h=Date:To:From:Subject:From;
	b=NE50vVGMdq0ktW6jCi94Iluf6z5X53Z+Te5Kcs128Dds4gvJJGM/+yqUQcjwvQPtT
	 avdg99qG4oS04yjm0JquzdoBMoMoWK7bYuKLfvdNqHXNZq/jfcKVYNK/g/9CpaEHqt
	 y7oh5epTr/jJ89lCe47QeRtPQkhuonTK7UVsb0Pk=
Date: Mon, 09 Jun 2025 16:18:55 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tglx@linutronix.de,riel@surriel.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hpa@zytor.com,david@redhat.com,catalin.marinas@arm.com,bp@alien8.de,aou@eecs.berkeley.edu,alex@ghiti.fr,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch added to mm-new branch
Message-Id: <20250609231855.C5FE6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove arch_flush_tlb_batched_pending() arch helper
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: remove arch_flush_tlb_batched_pending() arch helper
Date: Mon, 9 Jun 2025 11:31:30 +0100

Since commit 4b634918384c ("arm64/mm: Close theoretical race where stale
TLB entry remains valid"), all arches that use tlbbatch for reclaim
(arm64, riscv, x86) implement arch_flush_tlb_batched_pending() with a
flush_tlb_mm().

So let's simplify by removing the unnecessary abstraction and doing the
flush_tlb_mm() directly in flush_tlb_batched_pending().  This effectively
reverts commit db6c1f6f236d ("mm/tlbbatch: introduce
arch_flush_tlb_batched_pending()").

Link: https://lkml.kernel.org/r/20250609103132.447370-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Suggested-by: Will Deacon <will@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/tlbflush.h |   11 -----------
 arch/riscv/include/asm/tlbflush.h |    1 -
 arch/riscv/mm/tlbflush.c          |    5 -----
 arch/x86/include/asm/tlbflush.h   |    5 -----
 mm/rmap.c                         |    2 +-
 5 files changed, 1 insertion(+), 23 deletions(-)

--- a/arch/arm64/include/asm/tlbflush.h~mm-remove-arch_flush_tlb_batched_pending-arch-helper
+++ a/arch/arm64/include/asm/tlbflush.h
@@ -323,17 +323,6 @@ static inline bool arch_tlbbatch_should_
 }
 
 /*
- * If mprotect/munmap/etc occurs during TLB batched flushing, we need to ensure
- * all the previously issued TLBIs targeting mm have completed. But since we
- * can be executing on a remote CPU, a DSB cannot guarantee this like it can
- * for arch_tlbbatch_flush(). Our only option is to flush the entire mm.
- */
-static inline void arch_flush_tlb_batched_pending(struct mm_struct *mm)
-{
-	flush_tlb_mm(mm);
-}
-
-/*
  * To support TLB batched flush for multiple pages unmapping, we only send
  * the TLBI for each page in arch_tlbbatch_add_pending() and wait for the
  * completion at the end in arch_tlbbatch_flush(). Since we've already issued
--- a/arch/riscv/include/asm/tlbflush.h~mm-remove-arch_flush_tlb_batched_pending-arch-helper
+++ a/arch/riscv/include/asm/tlbflush.h
@@ -63,7 +63,6 @@ void flush_pud_tlb_range(struct vm_area_
 bool arch_tlbbatch_should_defer(struct mm_struct *mm);
 void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
 		struct mm_struct *mm, unsigned long start, unsigned long end);
-void arch_flush_tlb_batched_pending(struct mm_struct *mm);
 void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 
 extern unsigned long tlb_flush_all_threshold;
--- a/arch/riscv/mm/tlbflush.c~mm-remove-arch_flush_tlb_batched_pending-arch-helper
+++ a/arch/riscv/mm/tlbflush.c
@@ -234,11 +234,6 @@ void arch_tlbbatch_add_pending(struct ar
 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, start, end);
 }
 
-void arch_flush_tlb_batched_pending(struct mm_struct *mm)
-{
-	flush_tlb_mm(mm);
-}
-
 void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
 	__flush_tlb_range(NULL, &batch->cpumask,
--- a/arch/x86/include/asm/tlbflush.h~mm-remove-arch_flush_tlb_batched_pending-arch-helper
+++ a/arch/x86/include/asm/tlbflush.h
@@ -356,11 +356,6 @@ static inline void arch_tlbbatch_add_pen
 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
 }
 
-static inline void arch_flush_tlb_batched_pending(struct mm_struct *mm)
-{
-	flush_tlb_mm(mm);
-}
-
 extern void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 
 static inline bool pte_flags_need_flush(unsigned long oldflags,
--- a/mm/rmap.c~mm-remove-arch_flush_tlb_batched_pending-arch-helper
+++ a/mm/rmap.c
@@ -746,7 +746,7 @@ void flush_tlb_batched_pending(struct mm
 	int flushed = batch >> TLB_FLUSH_BATCH_FLUSHED_SHIFT;
 
 	if (pending != flushed) {
-		arch_flush_tlb_batched_pending(mm);
+		flush_tlb_mm(mm);
 		/*
 		 * If the new TLB flushing is pending during flushing, leave
 		 * mm->tlb_flush_batched as is, to avoid losing flushing.
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-close-theoretical-race-where-stale-tlb-entries-could-linger.patch
mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

