From: akpm@linux-foundation.org
Subject: + mm-avoid-tlb-gather-restarts.patch added to -mm tree
Date: Thu, 05 Jul 2007 11:44:08 -0700
Message-ID: <200707051844.l65Ii8u7012292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759063AbXGESov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 14:44:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwidefsky@de.ibm.com, hugh@veritas.com


The patch titled
     mm: avoid tlb gather restarts
has been added to the -mm tree.  Its filename is
     mm-avoid-tlb-gather-restarts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: avoid tlb gather restarts
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

If need_resched() is false in the inner loop of unmap_vmas it is unnecessary
to do a full blown tlb_finish_mmu / tlb_gather_mmu for each ZAP_BLOCK_SIZE
ptes.  Do a tlb_flush_mmu() instead.  That gives architectures with a
non-generic tlb flush implementation room for optimization.  The tlb_flush_mmu
primitive is a available with the generic tlb flush code, the
ia64_tlb_flush_mm needs to be renamed and a dummy function is added to arm and
arm26.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/tlb.h   |    5 +++++
 include/asm-arm26/tlb.h |    5 +++++
 include/asm-ia64/tlb.h  |    6 +++---
 mm/memory.c             |   16 ++++++----------
 4 files changed, 19 insertions(+), 13 deletions(-)

diff -puN include/asm-arm/tlb.h~mm-avoid-tlb-gather-restarts include/asm-arm/tlb.h
--- a/include/asm-arm/tlb.h~mm-avoid-tlb-gather-restarts
+++ a/include/asm-arm/tlb.h
@@ -52,6 +52,11 @@ tlb_gather_mmu(struct mm_struct *mm, uns
 }
 
 static inline void
+tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
+{
+}
+
+static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
 	if (tlb->fullmm)
diff -puN include/asm-arm26/tlb.h~mm-avoid-tlb-gather-restarts include/asm-arm26/tlb.h
--- a/include/asm-arm26/tlb.h~mm-avoid-tlb-gather-restarts
+++ a/include/asm-arm26/tlb.h
@@ -29,6 +29,11 @@ tlb_gather_mmu(struct mm_struct *mm, uns
 }
 
 static inline void
+tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
+{
+}
+
+static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
         if (tlb->need_flush)
diff -puN include/asm-ia64/tlb.h~mm-avoid-tlb-gather-restarts include/asm-ia64/tlb.h
--- a/include/asm-ia64/tlb.h~mm-avoid-tlb-gather-restarts
+++ a/include/asm-ia64/tlb.h
@@ -72,7 +72,7 @@ DECLARE_PER_CPU(struct mmu_gather, mmu_g
  * freed pages that where gathered up to this point.
  */
 static inline void
-ia64_tlb_flush_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
+tlb_flush_mmu (struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
 	unsigned int nr;
 
@@ -160,7 +160,7 @@ tlb_finish_mmu (struct mmu_gather *tlb, 
 	 * Note: tlb->nr may be 0 at this point, so we can't rely on tlb->start_addr and
 	 * tlb->end_addr.
 	 */
-	ia64_tlb_flush_mmu(tlb, start, end);
+	tlb_flush_mmu(tlb, start, end);
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
@@ -184,7 +184,7 @@ tlb_remove_page (struct mmu_gather *tlb,
 	}
 	tlb->pages[tlb->nr++] = page;
 	if (tlb->nr >= FREE_PTE_NR)
-		ia64_tlb_flush_mmu(tlb, tlb->start_addr, tlb->end_addr);
+		tlb_flush_mmu(tlb, tlb->start_addr, tlb->end_addr);
 }
 
 /*
diff -puN mm/memory.c~mm-avoid-tlb-gather-restarts mm/memory.c
--- a/mm/memory.c~mm-avoid-tlb-gather-restarts
+++ a/mm/memory.c
@@ -851,18 +851,15 @@ unsigned long unmap_vmas(struct mmu_gath
 				break;
 			}
 
-			tlb_finish_mmu(*tlbp, tlb_start, start);
-
 			if (need_resched() ||
 				(i_mmap_lock && need_lockbreak(i_mmap_lock))) {
-				if (i_mmap_lock) {
-					*tlbp = NULL;
+				if (i_mmap_lock)
 					goto out;
-				}
+				tlb_finish_mmu(*tlbp, tlb_start, start);
 				cond_resched();
-			}
-
-			*tlbp = tlb_gather_mmu(vma->vm_mm, fullmm);
+				*tlbp = tlb_gather_mmu(vma->vm_mm, fullmm);
+			} else
+				tlb_flush_mmu(*tlbp, tlb_start, start);
 			tlb_start_valid = 0;
 			zap_work = ZAP_BLOCK_SIZE;
 		}
@@ -890,8 +887,7 @@ unsigned long zap_page_range(struct vm_a
 	tlb = tlb_gather_mmu(mm, 0);
 	update_hiwater_rss(mm);
 	end = unmap_vmas(&tlb, vma, address, end, &nr_accounted, details);
-	if (tlb)
-		tlb_finish_mmu(tlb, address, end);
+	tlb_finish_mmu(tlb, address, end);
 	return end;
 }
 
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-acpi-s390-struct-bin_attribute-changes.patch
git-s390.patch
s390-rename-cpu_idle-to-s390_cpu_idle.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
mm-avoid-tlb-gather-restarts.patch
mm-remove-ptep_establish.patch
mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty.patch
mm-move-mm_struct-and-vm_area_struct.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
generic-bug-use-show_regs-instead-of-dump_stack.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
fallocate-on-s390.patch
