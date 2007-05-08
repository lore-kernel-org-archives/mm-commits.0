From: akpm@linux-foundation.org
Subject: - uml-speed-up-page-table-walking.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:01 -0700
Message-ID: <200705080007.l48071Pm009245@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967376AbXEHAH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: speed up page table walking
has been removed from the -mm tree.  Its filename was
     uml-speed-up-page-table-walking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: speed up page table walking
From: Jeff Dike <jdike@addtoit.com>

The previous page table walking code was horribly inefficient.  This patch
replaces it with code taken from elsewhere in the kernel.

Forking from bash is now ~5% faster and page faults are handled ~10% faster.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/tlb.c |  202 ++++++++++++++++++++++++-----------------
 1 file changed, 120 insertions(+), 82 deletions(-)

diff -puN arch/um/kernel/tlb.c~uml-speed-up-page-table-walking arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-speed-up-page-table-walking
+++ a/arch/um/kernel/tlb.c
@@ -6,6 +6,7 @@
 #include "linux/mm.h"
 #include "asm/page.h"
 #include "asm/pgalloc.h"
+#include "asm/pgtable.h"
 #include "asm/tlbflush.h"
 #include "choose-mode.h"
 #include "mode_kern.h"
@@ -123,106 +124,143 @@ static int add_mprotect(unsigned long ad
 
 #define ADD_ROUND(n, inc) (((n) + (inc)) & ~((inc) - 1))
 
+static inline int update_pte_range(pmd_t *pmd, unsigned long addr,
+				   unsigned long end, struct host_vm_op *ops,
+				   int last_op, int *op_index, int force,
+				   union mm_context *mmu, void **flush,
+				   int (*do_ops)(union mm_context *,
+						 struct host_vm_op *, int, int,
+						 void **))
+{
+	pte_t *pte;
+	int r, w, x, ret = 0;
+
+	pte = pte_offset_kernel(pmd, addr);
+	do {
+		r = pte_read(*pte);
+		w = pte_write(*pte);
+		x = pte_exec(*pte);
+		if (!pte_young(*pte)) {
+			r = 0;
+			w = 0;
+		} else if (!pte_dirty(*pte)) {
+			w = 0;
+		}
+		if(force || pte_newpage(*pte)){
+			if(pte_present(*pte))
+				ret = add_mmap(addr, pte_val(*pte) & PAGE_MASK,
+					       PAGE_SIZE, r, w, x, ops,
+					       op_index, last_op, mmu, flush,
+					       do_ops);
+			else ret = add_munmap(addr, PAGE_SIZE, ops, op_index,
+					      last_op, mmu, flush, do_ops);
+		}
+		else if(pte_newprot(*pte))
+			ret = add_mprotect(addr, PAGE_SIZE, r, w, x, ops,
+					   op_index, last_op, mmu, flush,
+					   do_ops);
+		*pte = pte_mkuptodate(*pte);
+	} while (pte++, addr += PAGE_SIZE, ((addr != end) && !ret));
+	return ret;
+}
+
+static inline int update_pmd_range(pud_t *pud, unsigned long addr,
+				   unsigned long end, struct host_vm_op *ops,
+				   int last_op, int *op_index, int force,
+				   union mm_context *mmu, void **flush,
+				   int (*do_ops)(union mm_context *,
+						 struct host_vm_op *, int, int,
+						 void **))
+{
+	pmd_t *pmd;
+	unsigned long next;
+	int ret = 0;
+
+	pmd = pmd_offset(pud, addr);
+	do {
+		next = pmd_addr_end(addr, end);
+		if(!pmd_present(*pmd)){
+			if(force || pmd_newpage(*pmd)){
+				ret = add_munmap(addr, next - addr, ops,
+						 op_index, last_op, mmu,
+						 flush, do_ops);
+				pmd_mkuptodate(*pmd);
+			}
+		}
+		else ret = update_pte_range(pmd, addr, next, ops, last_op,
+					    op_index, force, mmu, flush,
+					    do_ops);
+	} while (pmd++, addr = next, ((addr != end) && !ret));
+	return ret;
+}
+
+static inline int update_pud_range(pgd_t *pgd, unsigned long addr,
+				   unsigned long end, struct host_vm_op *ops,
+				   int last_op, int *op_index, int force,
+				   union mm_context *mmu, void **flush,
+				   int (*do_ops)(union mm_context *,
+						 struct host_vm_op *, int, int,
+						 void **))
+{
+	pud_t *pud;
+	unsigned long next;
+	int ret = 0;
+
+	pud = pud_offset(pgd, addr);
+	do {
+		next = pud_addr_end(addr, end);
+		if(!pud_present(*pud)){
+			if(force || pud_newpage(*pud)){
+				ret = add_munmap(addr, next - addr, ops,
+						 op_index, last_op, mmu,
+						 flush, do_ops);
+				pud_mkuptodate(*pud);
+			}
+		}
+		else ret = update_pmd_range(pud, addr, next, ops, last_op,
+					    op_index, force, mmu, flush,
+					    do_ops);
+	} while (pud++, addr = next, ((addr != end) && !ret));
+	return ret;
+}
+
 void fix_range_common(struct mm_struct *mm, unsigned long start_addr,
 		      unsigned long end_addr, int force,
 		      int (*do_ops)(union mm_context *, struct host_vm_op *,
 				    int, int, void **))
 {
-	pgd_t *npgd;
-	pud_t *npud;
-	pmd_t *npmd;
-	pte_t *npte;
+	pgd_t *pgd;
 	union mm_context *mmu = &mm->context;
-	unsigned long addr, end;
-	int r, w, x;
 	struct host_vm_op ops[1];
+	unsigned long addr = start_addr, next;
+	int ret = 0, last_op = ARRAY_SIZE(ops) - 1, op_index = -1;
 	void *flush = NULL;
-	int op_index = -1, last_op = ARRAY_SIZE(ops) - 1;
-	int ret = 0;
-
-	if(mm == NULL)
-		return;
+	unsigned long long start_time, end_time;
 
+	start_time = os_nsecs();
 	ops[0].type = NONE;
-	for(addr = start_addr; addr < end_addr && !ret;){
-		npgd = pgd_offset(mm, addr);
-		if(!pgd_present(*npgd)){
-			end = ADD_ROUND(addr, PGDIR_SIZE);
-			if(end > end_addr)
-				end = end_addr;
-			if(force || pgd_newpage(*npgd)){
-				ret = add_munmap(addr, end - addr, ops,
-						 &op_index, last_op, mmu,
-						 &flush, do_ops);
-				pgd_mkuptodate(*npgd);
-			}
-			addr = end;
-			continue;
-		}
-
-		npud = pud_offset(npgd, addr);
-		if(!pud_present(*npud)){
-			end = ADD_ROUND(addr, PUD_SIZE);
-			if(end > end_addr)
-				end = end_addr;
-			if(force || pud_newpage(*npud)){
-				ret = add_munmap(addr, end - addr, ops,
-						 &op_index, last_op, mmu,
-						 &flush, do_ops);
-				pud_mkuptodate(*npud);
-			}
-			addr = end;
-			continue;
-		}
-
-		npmd = pmd_offset(npud, addr);
-		if(!pmd_present(*npmd)){
-			end = ADD_ROUND(addr, PMD_SIZE);
-			if(end > end_addr)
-				end = end_addr;
-			if(force || pmd_newpage(*npmd)){
-				ret = add_munmap(addr, end - addr, ops,
+	pgd = pgd_offset(mm, addr);
+	do {
+		next = pgd_addr_end(addr, end_addr);
+		if(!pgd_present(*pgd)){
+			if (force || pgd_newpage(*pgd)){
+				ret = add_munmap(addr, next - addr, ops,
 						 &op_index, last_op, mmu,
 						 &flush, do_ops);
-				pmd_mkuptodate(*npmd);
+				pgd_mkuptodate(*pgd);
 			}
-			addr = end;
-			continue;
 		}
+		else ret = update_pud_range(pgd, addr, next, ops, last_op,
+					    &op_index, force, mmu, &flush,
+					    do_ops);
+	} while (pgd++, addr = next, ((addr != end_addr) && !ret));
+	end_time = os_nsecs();
+	log_info("total flush time - %Ld nsecs\n", end_time - start_time);
 
-		npte = pte_offset_kernel(npmd, addr);
-		r = pte_read(*npte);
-		w = pte_write(*npte);
-		x = pte_exec(*npte);
-		if (!pte_young(*npte)) {
-			r = 0;
-			w = 0;
-		} else if (!pte_dirty(*npte)) {
-			w = 0;
-		}
-		if(force || pte_newpage(*npte)){
-			if(pte_present(*npte))
-				ret = add_mmap(addr,
-					       pte_val(*npte) & PAGE_MASK,
-					       PAGE_SIZE, r, w, x, ops,
-					       &op_index, last_op, mmu,
-					       &flush, do_ops);
-			else ret = add_munmap(addr, PAGE_SIZE, ops,
-					      &op_index, last_op, mmu,
-					      &flush, do_ops);
-		}
-		else if(pte_newprot(*npte))
-			ret = add_mprotect(addr, PAGE_SIZE, r, w, x, ops,
-					   &op_index, last_op, mmu,
-					   &flush, do_ops);
-
-		*npte = pte_mkuptodate(*npte);
-		addr += PAGE_SIZE;
-	}
 	if(!ret)
 		ret = (*do_ops)(mmu, ops, op_index, 1, &flush);
 
-/* This is not an else because ret is modified above */
+	/* This is not an else because ret is modified above */
 	if(ret) {
 		printk("fix_range_common: failed, killing current process\n");
 		force_sig(SIGKILL, current);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
