From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 007/166] mm/vma: replace all remaining open
 encodings with is_vm_hugetlb_page()
Date: Mon, 06 Apr 2020 20:03:51 -0700
Message-ID: <20200407030351.n5cRC09Lx%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDDz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:03:55 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, arnd@arndb.de, benh@kernel.crashing.org, dalias@libc.org, dave.hansen@linux.intel.com, geert@linux-m68k.org, guoren@kernel.org, linux-mm@kvack.org, luto@kernel.org, mgorman@suse.de, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, paulburton@kernel.org, paulus@ozlabs.org, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, rostedt@goodmis.org, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, will@kernel.org, ysato@users.sourceforge.jp

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vma: replace all remaining open encodings with is_vm_hugetlb_page()

This replaces all remaining open encodings with is_vm_hugetlb_page().

Link: http://lkml.kernel.org/r/1582520593-30704-4-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Will Deacon <will@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/e500_mmu_host.c |    2 +-
 fs/binfmt_elf.c                  |    3 ++-
 include/asm-generic/tlb.h        |    3 ++-
 kernel/events/core.c             |    3 ++-
 4 files changed, 7 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kvm/e500_mmu_host.c~mm-vma-replace-all-remaining-open-encodings-with-is_vm_hugetlb_page
+++ a/arch/powerpc/kvm/e500_mmu_host.c
@@ -422,7 +422,7 @@ static inline int kvmppc_e500_shadow_map
 				break;
 			}
 		} else if (vma && hva >= vma->vm_start &&
-			   (vma->vm_flags & VM_HUGETLB)) {
+			   is_vm_hugetlb_page(vma)) {
 			unsigned long psize = vma_kernel_pagesize(vma);
 
 			tsize = (gtlbe->mas1 & MAS1_TSIZE_MASK) >>
--- a/fs/binfmt_elf.c~mm-vma-replace-all-remaining-open-encodings-with-is_vm_hugetlb_page
+++ a/fs/binfmt_elf.c
@@ -27,6 +27,7 @@
 #include <linux/highuid.h>
 #include <linux/compiler.h>
 #include <linux/highmem.h>
+#include <linux/hugetlb.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
@@ -1317,7 +1318,7 @@ static unsigned long vma_dump_size(struc
 	}
 
 	/* Hugetlb memory check */
-	if (vma->vm_flags & VM_HUGETLB) {
+	if (is_vm_hugetlb_page(vma)) {
 		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
 			goto whole;
 		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
--- a/include/asm-generic/tlb.h~mm-vma-replace-all-remaining-open-encodings-with-is_vm_hugetlb_page
+++ a/include/asm-generic/tlb.h
@@ -13,6 +13,7 @@
 
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
+#include <linux/hugetlb_inline.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
@@ -398,7 +399,7 @@ tlb_update_vma_flags(struct mmu_gather *
 	 * We rely on tlb_end_vma() to issue a flush, such that when we reset
 	 * these values the batch is empty.
 	 */
-	tlb->vma_huge = !!(vma->vm_flags & VM_HUGETLB);
+	tlb->vma_huge = is_vm_hugetlb_page(vma);
 	tlb->vma_exec = !!(vma->vm_flags & VM_EXEC);
 }
 
--- a/kernel/events/core.c~mm-vma-replace-all-remaining-open-encodings-with-is_vm_hugetlb_page
+++ a/kernel/events/core.c
@@ -28,6 +28,7 @@
 #include <linux/export.h>
 #include <linux/vmalloc.h>
 #include <linux/hardirq.h>
+#include <linux/hugetlb.h>
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
@@ -7973,7 +7974,7 @@ static void perf_event_mmap_event(struct
 		flags |= MAP_EXECUTABLE;
 	if (vma->vm_flags & VM_LOCKED)
 		flags |= MAP_LOCKED;
-	if (vma->vm_flags & VM_HUGETLB)
+	if (is_vm_hugetlb_page(vma))
 		flags |= MAP_HUGETLB;
 
 	if (file) {
_
