From: akpm@linux-foundation.org
Subject: + uml-clean-up-tlb-flush-path.patch added to -mm tree
Date: Mon, 20 Aug 2007 12:43:43 -0700
Message-ID: <200708201943.l7KJhhSZ019641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758977AbXHTTn5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:43:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: clean up tlb flush path
has been added to the -mm tree.  Its filename is
     uml-clean-up-tlb-flush-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: clean up tlb flush path
From: Jeff Dike <jdike@addtoit.com>

Tidy the tlb flushing code.

With tt mode gone, there is no reason to have the capability to have
called directly from do_mmap, do_mprotect, and do_munmap, rather than
calling a function pointer that it is given.

There was a large amount of data that was passed from function to
function, being used at the lowest level, without being changed.  This
stuff is now encapsulated in a structure which is initialized at the
top layer and passed down.  This simplifies the code, reduces the
amount of code needed to pass the parameters around, and saves on
stack space.

A somewhat more subtle change is the meaning of the current operation
index.  It used to start at -1, being pre-incremented when adding an
operation.  It now starts at 0, being post-incremented, with
associated adjustments of +/- 1 on comparisons.

In addition, tlb.h contained a couple of declarations which had no
users outside of tlb.c, so they could be moved or deleted.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/tlb.h |   27 ----
 arch/um/kernel/tlb.c  |  258 +++++++++++++++++++---------------------
 2 files changed, 127 insertions(+), 158 deletions(-)

diff -puN arch/um/include/tlb.h~uml-clean-up-tlb-flush-path arch/um/include/tlb.h
--- a/arch/um/include/tlb.h~uml-clean-up-tlb-flush-path
+++ a/arch/um/include/tlb.h
@@ -8,34 +8,7 @@
 
 #include "um_mmu.h"
 
-struct host_vm_op {
-	enum { NONE, MMAP, MUNMAP, MPROTECT } type;
-	union {
-		struct {
-			unsigned long addr;
-			unsigned long len;
-			unsigned int prot;
-			int fd;
-			__u64 offset;
-		} mmap;
-		struct {
-			unsigned long addr;
-			unsigned long len;
-		} munmap;
-		struct {
-			unsigned long addr;
-			unsigned long len;
-			unsigned int prot;
-		} mprotect;
-	} u;
-};
-
 extern void force_flush_all(void);
-extern void fix_range_common(struct mm_struct *mm, unsigned long start_addr,
-                             unsigned long end_addr, int force,
-			     int (*do_ops)(struct mm_context *,
-					   struct host_vm_op *, int, int,
-					   void **));
 extern int flush_tlb_kernel_range_common(unsigned long start,
 					 unsigned long end);
 
diff -puN arch/um/kernel/tlb.c~uml-clean-up-tlb-flush-path arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-clean-up-tlb-flush-path
+++ a/arch/um/kernel/tlb.c
@@ -12,19 +12,85 @@
 #include "skas.h"
 #include "tlb.h"
 
+struct host_vm_change {
+	struct host_vm_op {
+		enum { NONE, MMAP, MUNMAP, MPROTECT } type;
+		union {
+			struct {
+				unsigned long addr;
+				unsigned long len;
+				unsigned int prot;
+				int fd;
+				__u64 offset;
+			} mmap;
+			struct {
+				unsigned long addr;
+				unsigned long len;
+			} munmap;
+			struct {
+				unsigned long addr;
+				unsigned long len;
+				unsigned int prot;
+			} mprotect;
+		} u;
+	} ops[1];
+	int index;
+	struct mm_id *id;
+	void *data;
+	int force;
+};
+
+#define INIT_HVC(mm, force) \
+	((struct host_vm_change) \
+	 { .ops		= { { .type = NONE } },	\
+	   .id		= &mm->context.id, \
+       	   .data	= NULL, \
+	   .index	= 0, \
+	   .force	= force })
+
+static int do_ops(struct host_vm_change *hvc, int end,
+		  int finished)
+{
+	struct host_vm_op *op;
+	int i, ret = 0;
+
+	for (i = 0; i < end && !ret; i++) {
+		op = &hvc->ops[i];
+		switch(op->type) {
+		case MMAP:
+			ret = map(hvc->id, op->u.mmap.addr, op->u.mmap.len,
+				  op->u.mmap.prot, op->u.mmap.fd,
+				  op->u.mmap.offset, finished, &hvc->data);
+			break;
+		case MUNMAP:
+			ret = unmap(hvc->id, op->u.munmap.addr,
+				    op->u.munmap.len, finished, &hvc->data);
+			break;
+		case MPROTECT:
+			ret = protect(hvc->id, op->u.mprotect.addr,
+				      op->u.mprotect.len, op->u.mprotect.prot,
+				      finished, &hvc->data);
+			break;
+		default:
+			printk(KERN_ERR "Unknown op type %d in do_ops\n",
+			       op->type);
+			break;
+		}
+	}
+
+	return ret;
+}
+
 static int add_mmap(unsigned long virt, unsigned long phys, unsigned long len,
-		    unsigned int prot, struct host_vm_op *ops, int *index,
-		    int last_filled, struct mm_context *mmu, void **flush,
-		    int (*do_ops)(struct mm_context *, struct host_vm_op *,
-				  int, int, void **))
+		    unsigned int prot, struct host_vm_change *hvc)
 {
 	__u64 offset;
 	struct host_vm_op *last;
 	int fd, ret = 0;
 
 	fd = phys_mapping(phys, &offset);
-	if (*index != -1) {
-		last = &ops[*index];
+	if (hvc->index != 0) {
+		last = &hvc->ops[hvc->index - 1];
 		if ((last->type == MMAP) &&
 		   (last->u.mmap.addr + last->u.mmap.len == virt) &&
 		   (last->u.mmap.prot == prot) && (last->u.mmap.fd == fd) &&
@@ -34,33 +100,30 @@ static int add_mmap(unsigned long virt, 
 		}
 	}
 
-	if (*index == last_filled) {
-		ret = (*do_ops)(mmu, ops, last_filled, 0, flush);
-		*index = -1;
+	if (hvc->index == ARRAY_SIZE(hvc->ops)) {
+		ret = do_ops(hvc, ARRAY_SIZE(hvc->ops), 0);
+		hvc->index = 0;
 	}
 
-	ops[++*index] = ((struct host_vm_op) { .type	= MMAP,
-			     			.u = { .mmap = {
-						       .addr	= virt,
-						       .len	= len,
-						       .prot	= prot,
-						       .fd	= fd,
-						       .offset	= offset }
+	hvc->ops[hvc->index++] = ((struct host_vm_op)
+				  { .type	= MMAP,
+				    .u = { .mmap = { .addr	= virt,
+						     .len	= len,
+						     .prot	= prot,
+						     .fd	= fd,
+						     .offset	= offset }
 			   } });
 	return ret;
 }
 
 static int add_munmap(unsigned long addr, unsigned long len,
-		      struct host_vm_op *ops, int *index, int last_filled,
-		      struct mm_context *mmu, void **flush,
-		      int (*do_ops)(struct mm_context *, struct host_vm_op *,
-				    int, int, void **))
+		      struct host_vm_change *hvc)
 {
 	struct host_vm_op *last;
 	int ret = 0;
 
-	if (*index != -1) {
-		last = &ops[*index];
+	if (hvc->index != 0) {
+		last = &hvc->ops[hvc->index - 1];
 		if ((last->type == MUNMAP) &&
 		   (last->u.munmap.addr + last->u.mmap.len == addr)) {
 			last->u.munmap.len += len;
@@ -68,29 +131,26 @@ static int add_munmap(unsigned long addr
 		}
 	}
 
-	if (*index == last_filled) {
-		ret = (*do_ops)(mmu, ops, last_filled, 0, flush);
-		*index = -1;
+	if (hvc->index == ARRAY_SIZE(hvc->ops)) {
+		ret = do_ops(hvc, ARRAY_SIZE(hvc->ops), 0);
+		hvc->index = 0;
 	}
 
-	ops[++*index] = ((struct host_vm_op) { .type	= MUNMAP,
-			     		       .u = { .munmap = {
-						        .addr	= addr,
-							.len	= len } } });
+	hvc->ops[hvc->index++] = ((struct host_vm_op)
+				  { .type	= MUNMAP,
+			     	    .u = { .munmap = { .addr	= addr,
+						       .len	= len } } });
 	return ret;
 }
 
 static int add_mprotect(unsigned long addr, unsigned long len,
-			unsigned int prot, struct host_vm_op *ops, int *index,
-			int last_filled, struct mm_context *mmu, void **flush,
-			int (*do_ops)(struct mm_context *, struct host_vm_op *,
-				      int, int, void **))
+			unsigned int prot, struct host_vm_change *hvc)
 {
 	struct host_vm_op *last;
 	int ret = 0;
 
-	if (*index != -1) {
-		last = &ops[*index];
+	if (hvc->index != 0) {
+		last = &hvc->ops[hvc->index - 1];
 		if ((last->type == MPROTECT) &&
 		   (last->u.mprotect.addr + last->u.mprotect.len == addr) &&
 		   (last->u.mprotect.prot == prot)) {
@@ -99,28 +159,24 @@ static int add_mprotect(unsigned long ad
 		}
 	}
 
-	if (*index == last_filled) {
-		ret = (*do_ops)(mmu, ops, last_filled, 0, flush);
-		*index = -1;
+	if (hvc->index == ARRAY_SIZE(hvc->ops)) {
+		ret = do_ops(hvc, ARRAY_SIZE(hvc->ops), 0);
+		hvc->index = 0;
 	}
 
-	ops[++*index] = ((struct host_vm_op) { .type	= MPROTECT,
-			     		       .u = { .mprotect = {
-						       .addr	= addr,
-						       .len	= len,
-						       .prot	= prot } } });
+	hvc->ops[hvc->index++] = ((struct host_vm_op)
+				  { .type	= MPROTECT,
+			     	    .u = { .mprotect = { .addr	= addr,
+							 .len	= len,
+							 .prot	= prot } } });
 	return ret;
 }
 
 #define ADD_ROUND(n, inc) (((n) + (inc)) & ~((inc) - 1))
 
 static inline int update_pte_range(pmd_t *pmd, unsigned long addr,
-				   unsigned long end, struct host_vm_op *ops,
-				   int last_op, int *op_index, int force,
-				   struct mm_context *mmu, void **flush,
-				   int (*do_ops)(struct mm_context *,
-						 struct host_vm_op *, int, int,
-						 void **))
+				   unsigned long end,
+				   struct host_vm_change *hvc)
 {
 	pte_t *pte;
 	int r, w, x, prot, ret = 0;
@@ -138,29 +194,22 @@ static inline int update_pte_range(pmd_t
 		}
 		prot = ((r ? UM_PROT_READ : 0) | (w ? UM_PROT_WRITE : 0) |
 			(x ? UM_PROT_EXEC : 0));
-		if (force || pte_newpage(*pte)) {
+		if (hvc->force || pte_newpage(*pte)) {
 			if (pte_present(*pte))
 				ret = add_mmap(addr, pte_val(*pte) & PAGE_MASK,
-					       PAGE_SIZE, prot, ops, op_index,
-					       last_op, mmu, flush, do_ops);
-			else ret = add_munmap(addr, PAGE_SIZE, ops, op_index,
-					      last_op, mmu, flush, do_ops);
+					       PAGE_SIZE, prot, hvc);
+			else ret = add_munmap(addr, PAGE_SIZE, hvc);
 		}
 		else if (pte_newprot(*pte))
-			ret = add_mprotect(addr, PAGE_SIZE, prot, ops, op_index,
-					   last_op, mmu, flush, do_ops);
+			ret = add_mprotect(addr, PAGE_SIZE, prot, hvc);
 		*pte = pte_mkuptodate(*pte);
 	} while (pte++, addr += PAGE_SIZE, ((addr != end) && !ret));
 	return ret;
 }
 
 static inline int update_pmd_range(pud_t *pud, unsigned long addr,
-				   unsigned long end, struct host_vm_op *ops,
-				   int last_op, int *op_index, int force,
-				   struct mm_context *mmu, void **flush,
-				   int (*do_ops)(struct mm_context *,
-						 struct host_vm_op *, int, int,
-						 void **))
+				   unsigned long end,
+				   struct host_vm_change *hvc)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -170,27 +219,19 @@ static inline int update_pmd_range(pud_t
 	do {
 		next = pmd_addr_end(addr, end);
 		if (!pmd_present(*pmd)) {
-			if (force || pmd_newpage(*pmd)) {
-				ret = add_munmap(addr, next - addr, ops,
-						 op_index, last_op, mmu,
-						 flush, do_ops);
+			if (hvc->force || pmd_newpage(*pmd)) {
+				ret = add_munmap(addr, next - addr, hvc);
 				pmd_mkuptodate(*pmd);
 			}
 		}
-		else ret = update_pte_range(pmd, addr, next, ops, last_op,
-					    op_index, force, mmu, flush,
-					    do_ops);
+		else ret = update_pte_range(pmd, addr, next, hvc);
 	} while (pmd++, addr = next, ((addr != end) && !ret));
 	return ret;
 }
 
 static inline int update_pud_range(pgd_t *pgd, unsigned long addr,
-				   unsigned long end, struct host_vm_op *ops,
-				   int last_op, int *op_index, int force,
-				   struct mm_context *mmu, void **flush,
-				   int (*do_ops)(struct mm_context *,
-						 struct host_vm_op *, int, int,
-						 void **))
+				   unsigned long end,
+				   struct host_vm_change *hvc)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -200,51 +241,39 @@ static inline int update_pud_range(pgd_t
 	do {
 		next = pud_addr_end(addr, end);
 		if (!pud_present(*pud)) {
-			if (force || pud_newpage(*pud)) {
-				ret = add_munmap(addr, next - addr, ops,
-						 op_index, last_op, mmu,
-						 flush, do_ops);
+			if (hvc->force || pud_newpage(*pud)) {
+				ret = add_munmap(addr, next - addr, hvc);
 				pud_mkuptodate(*pud);
 			}
 		}
-		else ret = update_pmd_range(pud, addr, next, ops, last_op,
-					    op_index, force, mmu, flush,
-					    do_ops);
+		else ret = update_pmd_range(pud, addr, next, hvc);
 	} while (pud++, addr = next, ((addr != end) && !ret));
 	return ret;
 }
 
 void fix_range_common(struct mm_struct *mm, unsigned long start_addr,
-		      unsigned long end_addr, int force,
-		      int (*do_ops)(struct mm_context *, struct host_vm_op *,
-				    int, int, void **))
+		      unsigned long end_addr, int force)
 {
 	pgd_t *pgd;
-	struct mm_context *mmu = &mm->context;
-	struct host_vm_op ops[1];
+	struct host_vm_change hvc;
 	unsigned long addr = start_addr, next;
-	int ret = 0, last_op = ARRAY_SIZE(ops) - 1, op_index = -1;
-	void *flush = NULL;
+	int ret = 0;
 
-	ops[0].type = NONE;
+	hvc = INIT_HVC(mm, force);
 	pgd = pgd_offset(mm, addr);
 	do {
 		next = pgd_addr_end(addr, end_addr);
 		if (!pgd_present(*pgd)) {
 			if (force || pgd_newpage(*pgd)) {
-				ret = add_munmap(addr, next - addr, ops,
-						 &op_index, last_op, mmu,
-						 &flush, do_ops);
+				ret = add_munmap(addr, next - addr, &hvc);
 				pgd_mkuptodate(*pgd);
 			}
 		}
-		else ret = update_pud_range(pgd, addr, next, ops, last_op,
-					    &op_index, force, mmu, &flush,
-					    do_ops);
+		else ret = update_pud_range(pgd, addr, next, &hvc);
 	} while (pgd++, addr = next, ((addr != end_addr) && !ret));
 
 	if (!ret)
-		ret = (*do_ops)(mmu, ops, op_index, 1, &flush);
+		ret = do_ops(&hvc, hvc.index, 1);
 
 	/* This is not an else because ret is modified above */
 	if (ret) {
@@ -453,46 +482,13 @@ void __flush_tlb_one(unsigned long addr)
 	flush_tlb_kernel_range_common(addr, addr + PAGE_SIZE);
 }
 
-static int do_ops(struct mm_context *mmu, struct host_vm_op *ops, int last,
-		  int finished, void **flush)
-{
-	struct host_vm_op *op;
-	int i, ret = 0;
-
-	for (i = 0; i <= last && !ret; i++) {
-	op = &ops[i];
-		switch(op->type) {
-		case MMAP:
-			ret = map(&mmu->id, op->u.mmap.addr, op->u.mmap.len,
-				  op->u.mmap.prot, op->u.mmap.fd,
-				  op->u.mmap.offset, finished, flush);
-			break;
-		case MUNMAP:
-			ret = unmap(&mmu->id, op->u.munmap.addr,
-				    op->u.munmap.len, finished, flush);
-			break;
-		case MPROTECT:
-			ret = protect(&mmu->id, op->u.mprotect.addr,
-				      op->u.mprotect.len, op->u.mprotect.prot,
-				      finished, flush);
-			break;
-		default:
-			printk(KERN_ERR "Unknown op type %d in do_ops\n",
-			       op->type);
-			break;
-		}
-	}
-
-	return ret;
-}
-
 static void fix_range(struct mm_struct *mm, unsigned long start_addr,
 		      unsigned long end_addr, int force)
 {
 	if (!proc_mm && (end_addr > CONFIG_STUB_START))
 		end_addr = CONFIG_STUB_START;
 
-	fix_range_common(mm, start_addr, end_addr, force, do_ops);
+	fix_range_common(mm, start_addr, end_addr, force);
 }
 
 void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
uml-fix-previous-request-size-limit-fix.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-use-64-bits-for-block-size-on-x86_64.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
