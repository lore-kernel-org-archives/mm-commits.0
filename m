From: akpm@linux-foundation.org
Subject: - uml-more-page-fault-path-trimming.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:37 -0700
Message-ID: <200705080007.l4807bLA009302@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967415AbXEHAIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: more page fault path trimming
has been removed from the -mm tree.  Its filename was
     uml-more-page-fault-path-trimming.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: more page fault path trimming
From: Jeff Dike <jdike@addtoit.com>

More trimming of the page fault path.

Permissions are passed around in a single int rather than one bit per
int.  The permission values are copied from libc so that they can be
passed to mmap and mprotect without any further conversion.

The register sets used by do_syscall_stub and copy_context_skas0 are
initialized once, at boot time, rather than once per call.

wait_stub_done checks whether it is getting the signals it expects by
comparing the wait status to a mask containing bits for the signals of
interest rather than comparing individually to the signal numbers.  It
also has one check for a wait failure instead of two.  The caller is
expected to do the initial continue of the stub.  This gets rid of an
argument and some logic.  The fname argument is gone, as that can be
had from a stack trace.

user_signal() is collapsed into userspace() as it is basically one or
two lines of code afterwards.

The physical memory remapping stuff is gone, as it is unused.

flush_tlb_page is inlined.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h              |    6 
 arch/um/include/tlb.h             |    8 
 arch/um/kernel/physmem.c          |  228 ----------------------------
 arch/um/kernel/skas/tlb.c         |   21 +-
 arch/um/kernel/tlb.c              |   42 +----
 arch/um/os-Linux/skas/mem.c       |   51 +++---
 arch/um/os-Linux/skas/process.c   |  122 +++++++++-----
 arch/um/os-Linux/skas/trap.c      |   17 --
 arch/um/sys-i386/user-offsets.c   |    9 -
 arch/um/sys-x86_64/user-offsets.c |    5 
 include/asm-um/page.h             |    3 
 include/asm-um/tlbflush.h         |   24 +-
 12 files changed, 158 insertions(+), 378 deletions(-)

diff -puN arch/um/include/os.h~uml-more-page-fault-path-trimming arch/um/include/os.h
--- a/arch/um/include/os.h~uml-more-page-fault-path-trimming
+++ a/arch/um/include/os.h
@@ -300,13 +300,12 @@ extern long syscall_stub_data(struct mm_
 			      unsigned long *data, int data_count,
 			      void **addr, void **stub_addr);
 extern int map(struct mm_id * mm_idp, unsigned long virt,
-	       unsigned long len, int r, int w, int x, int phys_fd,
+	       unsigned long len, int prot, int phys_fd,
 	       unsigned long long offset, int done, void **data);
 extern int unmap(struct mm_id * mm_idp, unsigned long addr, unsigned long len,
 		 int done, void **data);
 extern int protect(struct mm_id * mm_idp, unsigned long addr,
-		   unsigned long len, int r, int w, int x, int done,
-		   void **data);
+		   unsigned long len, unsigned int prot, int done, void **data);
 
 /* skas/process.c */
 extern int is_skas_winch(int pid, int fd, void *data);
@@ -342,7 +341,6 @@ extern void maybe_sigio_broken(int fd, i
 
 /* skas/trap */
 extern void sig_handler_common_skas(int sig, void *sc_ptr);
-extern void user_signal(int sig, union uml_pt_regs *regs, int pid);
 
 /* sys-x86_64/prctl.c */
 extern int os_arch_prctl(int pid, int code, unsigned long *addr);
diff -puN arch/um/include/tlb.h~uml-more-page-fault-path-trimming arch/um/include/tlb.h
--- a/arch/um/include/tlb.h~uml-more-page-fault-path-trimming
+++ a/arch/um/include/tlb.h
@@ -14,9 +14,7 @@ struct host_vm_op {
 		struct {
 			unsigned long addr;
 			unsigned long len;
-			unsigned int r:1;
-			unsigned int w:1;
-			unsigned int x:1;
+			unsigned int prot;
 			int fd;
 			__u64 offset;
 		} mmap;
@@ -27,9 +25,7 @@ struct host_vm_op {
 		struct {
 			unsigned long addr;
 			unsigned long len;
-			unsigned int r:1;
-			unsigned int w:1;
-			unsigned int x:1;
+			unsigned int prot;
 		} mprotect;
 	} u;
 };
diff -puN arch/um/kernel/physmem.c~uml-more-page-fault-path-trimming arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-more-page-fault-path-trimming
+++ a/arch/um/kernel/physmem.c
@@ -21,229 +21,8 @@
 #include "kern.h"
 #include "init.h"
 
-struct phys_desc {
-	struct rb_node rb;
-	int fd;
-	__u64 offset;
-	void *virt;
-	unsigned long phys;
-	struct list_head list;
-};
-
-static struct rb_root phys_mappings = RB_ROOT;
-
-static struct rb_node **find_rb(void *virt)
-{
-	struct rb_node **n = &phys_mappings.rb_node;
-	struct phys_desc *d;
-
-	while(*n != NULL){
-		d = rb_entry(*n, struct phys_desc, rb);
-		if(d->virt == virt)
-			return n;
-
-		if(d->virt > virt)
-			n = &(*n)->rb_left;
-		else
-			n = &(*n)->rb_right;
-	}
-
-	return n;
-}
-
-static struct phys_desc *find_phys_mapping(void *virt)
-{
-	struct rb_node **n = find_rb(virt);
-
-	if(*n == NULL)
-		return NULL;
-
-	return rb_entry(*n, struct phys_desc, rb);
-}
-
-static void insert_phys_mapping(struct phys_desc *desc)
-{
-	struct rb_node **n = find_rb(desc->virt);
-
-	if(*n != NULL)
-		panic("Physical remapping for %p already present",
-		      desc->virt);
-
-	rb_link_node(&desc->rb, rb_parent(*n), n);
-	rb_insert_color(&desc->rb, &phys_mappings);
-}
-
-LIST_HEAD(descriptor_mappings);
-
-struct desc_mapping {
-	int fd;
-	struct list_head list;
-	struct list_head pages;
-};
-
-static struct desc_mapping *find_mapping(int fd)
-{
-	struct desc_mapping *desc;
-	struct list_head *ele;
-
-	list_for_each(ele, &descriptor_mappings){
-		desc = list_entry(ele, struct desc_mapping, list);
-		if(desc->fd == fd)
-			return desc;
-	}
-
-	return NULL;
-}
-
-static struct desc_mapping *descriptor_mapping(int fd)
-{
-	struct desc_mapping *desc;
-
-	desc = find_mapping(fd);
-	if(desc != NULL)
-		return desc;
-
-	desc = kmalloc(sizeof(*desc), GFP_ATOMIC);
-	if(desc == NULL)
-		return NULL;
-
-	*desc = ((struct desc_mapping)
-		{ .fd =		fd,
-		  .list =	LIST_HEAD_INIT(desc->list),
-		  .pages =	LIST_HEAD_INIT(desc->pages) });
-	list_add(&desc->list, &descriptor_mappings);
-
-	return desc;
-}
-
-int physmem_subst_mapping(void *virt, int fd, __u64 offset, int w)
-{
-	struct desc_mapping *fd_maps;
-	struct phys_desc *desc;
-	unsigned long phys;
-	int err;
-
-	fd_maps = descriptor_mapping(fd);
-	if(fd_maps == NULL)
-		return -ENOMEM;
-
-	phys = __pa(virt);
-	desc = find_phys_mapping(virt);
-	if(desc != NULL)
-		panic("Address 0x%p is already substituted\n", virt);
-
-	err = -ENOMEM;
-	desc = kmalloc(sizeof(*desc), GFP_ATOMIC);
-	if(desc == NULL)
-		goto out;
-
-	*desc = ((struct phys_desc)
-		{ .fd =			fd,
-		  .offset =		offset,
-		  .virt =		virt,
-		  .phys =		__pa(virt),
-		  .list = 		LIST_HEAD_INIT(desc->list) });
-	insert_phys_mapping(desc);
-
-	list_add(&desc->list, &fd_maps->pages);
-
-	virt = (void *) ((unsigned long) virt & PAGE_MASK);
-	err = os_map_memory(virt, fd, offset, PAGE_SIZE, 1, w, 0);
-	if(!err)
-		goto out;
-
-	rb_erase(&desc->rb, &phys_mappings);
-	kfree(desc);
- out:
-	return err;
-}
-
 static int physmem_fd = -1;
 
-static void remove_mapping(struct phys_desc *desc)
-{
-	void *virt = desc->virt;
-	int err;
-
-	rb_erase(&desc->rb, &phys_mappings);
-	list_del(&desc->list);
-	kfree(desc);
-
-	err = os_map_memory(virt, physmem_fd, __pa(virt), PAGE_SIZE, 1, 1, 0);
-	if(err)
-		panic("Failed to unmap block device page from physical memory, "
-		      "errno = %d", -err);
-}
-
-int physmem_remove_mapping(void *virt)
-{
-	struct phys_desc *desc;
-
-	virt = (void *) ((unsigned long) virt & PAGE_MASK);
-	desc = find_phys_mapping(virt);
-	if(desc == NULL)
-		return 0;
-
-	remove_mapping(desc);
-	return 1;
-}
-
-void physmem_forget_descriptor(int fd)
-{
-	struct desc_mapping *desc;
-	struct phys_desc *page;
-	struct list_head *ele, *next;
-	__u64 offset;
-	void *addr;
-	int err;
-
-	desc = find_mapping(fd);
-	if(desc == NULL)
-		return;
-
-	list_for_each_safe(ele, next, &desc->pages){
-		page = list_entry(ele, struct phys_desc, list);
-		offset = page->offset;
-		addr = page->virt;
-		remove_mapping(page);
-		err = os_seek_file(fd, offset);
-		if(err)
-			panic("physmem_forget_descriptor - failed to seek "
-			      "to %lld in fd %d, error = %d\n",
-			      offset, fd, -err);
-		err = os_read_file(fd, addr, PAGE_SIZE);
-		if(err < 0)
-			panic("physmem_forget_descriptor - failed to read "
-			      "from fd %d to 0x%p, error = %d\n",
-			      fd, addr, -err);
-	}
-
-	list_del(&desc->list);
-	kfree(desc);
-}
-
-EXPORT_SYMBOL(physmem_forget_descriptor);
-EXPORT_SYMBOL(physmem_remove_mapping);
-EXPORT_SYMBOL(physmem_subst_mapping);
-
-void arch_free_page(struct page *page, int order)
-{
-	void *virt;
-	int i;
-
-	for(i = 0; i < (1 << order); i++){
-		virt = __va(page_to_phys(page + i));
-		physmem_remove_mapping(virt);
-	}
-}
-
-int is_remapped(void *virt)
-{
- 	struct phys_desc *desc = find_phys_mapping(virt);
-
-	return desc != NULL;
-}
-
 /* Changed during early boot */
 unsigned long high_physmem;
 
@@ -350,14 +129,9 @@ void setup_physmem(unsigned long start, 
 
 int phys_mapping(unsigned long phys, __u64 *offset_out)
 {
-	struct phys_desc *desc = find_phys_mapping(__va(phys & PAGE_MASK));
 	int fd = -1;
 
-	if(desc != NULL){
-		fd = desc->fd;
-		*offset_out = desc->offset;
-	}
-	else if(phys < physmem_size){
+	if(phys < physmem_size){
 		fd = physmem_fd;
 		*offset_out = phys;
 	}
diff -puN arch/um/kernel/skas/tlb.c~uml-more-page-fault-path-trimming arch/um/kernel/skas/tlb.c
--- a/arch/um/kernel/skas/tlb.c~uml-more-page-fault-path-trimming
+++ a/arch/um/kernel/skas/tlb.c
@@ -27,9 +27,9 @@ static int do_ops(union mm_context *mmu,
 		switch(op->type){
 		case MMAP:
 			ret = map(&mmu->skas.id, op->u.mmap.addr,
-				  op->u.mmap.len, op->u.mmap.r, op->u.mmap.w,
-				  op->u.mmap.x, op->u.mmap.fd,
-				  op->u.mmap.offset, finished, flush);
+				  op->u.mmap.len, op->u.mmap.prot,
+				  op->u.mmap.fd, op->u.mmap.offset, finished,
+				  flush);
 			break;
 		case MUNMAP:
 			ret = unmap(&mmu->skas.id, op->u.munmap.addr,
@@ -37,8 +37,7 @@ static int do_ops(union mm_context *mmu,
 			break;
 		case MPROTECT:
 			ret = protect(&mmu->skas.id, op->u.mprotect.addr,
-				      op->u.mprotect.len, op->u.mprotect.r,
-				      op->u.mprotect.w, op->u.mprotect.x,
+				      op->u.mprotect.len, op->u.mprotect.prot,
 				      finished, flush);
 			break;
 		default:
@@ -102,10 +101,10 @@ void flush_tlb_page_skas(struct vm_area_
 	pte_t *pte;
 	struct mm_struct *mm = vma->vm_mm;
 	void *flush = NULL;
-	int r, w, x, err = 0;
+	int r, w, x, prot, err = 0;
 	struct mm_id *mm_id;
 
-	pgd = pgd_offset(vma->vm_mm, address);
+	pgd = pgd_offset(mm, address);
 	if(!pgd_present(*pgd))
 		goto kill;
 
@@ -130,19 +129,21 @@ void flush_tlb_page_skas(struct vm_area_
 	}
 
 	mm_id = &mm->context.skas.id;
+	prot = ((r ? UM_PROT_READ : 0) | (w ? UM_PROT_WRITE : 0) |
+		(x ? UM_PROT_EXEC : 0));
 	if(pte_newpage(*pte)){
 		if(pte_present(*pte)){
 			unsigned long long offset;
 			int fd;
 
 			fd = phys_mapping(pte_val(*pte) & PAGE_MASK, &offset);
-			err = map(mm_id, address, PAGE_SIZE, r, w, x, fd,
-				  offset, 1, &flush);
+			err = map(mm_id, address, PAGE_SIZE, prot, fd, offset,
+				  1, &flush);
 		}
 		else err = unmap(mm_id, address, PAGE_SIZE, 1, &flush);
 	}
 	else if(pte_newprot(*pte))
-		err = protect(mm_id, address, PAGE_SIZE, r, w, x, 1, &flush);
+		err = protect(mm_id, address, PAGE_SIZE, prot, 1, &flush);
 
 	if(err)
 		goto kill;
diff -puN arch/um/kernel/tlb.c~uml-more-page-fault-path-trimming arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-more-page-fault-path-trimming
+++ a/arch/um/kernel/tlb.c
@@ -17,7 +17,7 @@
 #include "os.h"
 
 static int add_mmap(unsigned long virt, unsigned long phys, unsigned long len,
-		    int r, int w, int x, struct host_vm_op *ops, int *index,
+		    unsigned int prot, struct host_vm_op *ops, int *index,
 		    int last_filled, union mm_context *mmu, void **flush,
 		    int (*do_ops)(union mm_context *, struct host_vm_op *,
 				  int, int, void **))
@@ -31,8 +31,7 @@ static int add_mmap(unsigned long virt, 
 		last = &ops[*index];
 		if((last->type == MMAP) &&
 		   (last->u.mmap.addr + last->u.mmap.len == virt) &&
-		   (last->u.mmap.r == r) && (last->u.mmap.w == w) &&
-		   (last->u.mmap.x == x) && (last->u.mmap.fd == fd) &&
+		   (last->u.mmap.prot == prot) && (last->u.mmap.fd == fd) &&
 		   (last->u.mmap.offset + last->u.mmap.len == offset)){
 			last->u.mmap.len += len;
 			return 0;
@@ -48,9 +47,7 @@ static int add_mmap(unsigned long virt, 
 			     			.u = { .mmap = {
 						       .addr	= virt,
 						       .len	= len,
-						       .r	= r,
-						       .w	= w,
-						       .x	= x,
+						       .prot	= prot,
 						       .fd	= fd,
 						       .offset	= offset }
 			   } });
@@ -87,8 +84,8 @@ static int add_munmap(unsigned long addr
 	return ret;
 }
 
-static int add_mprotect(unsigned long addr, unsigned long len, int r, int w,
-			int x, struct host_vm_op *ops, int *index,
+static int add_mprotect(unsigned long addr, unsigned long len,
+			unsigned int prot, struct host_vm_op *ops, int *index,
 			int last_filled, union mm_context *mmu, void **flush,
 			int (*do_ops)(union mm_context *, struct host_vm_op *,
 				      int, int, void **))
@@ -100,8 +97,7 @@ static int add_mprotect(unsigned long ad
 		last = &ops[*index];
 		if((last->type == MPROTECT) &&
 		   (last->u.mprotect.addr + last->u.mprotect.len == addr) &&
-		   (last->u.mprotect.r == r) && (last->u.mprotect.w == w) &&
-		   (last->u.mprotect.x == x)){
+		   (last->u.mprotect.prot == prot)){
 			last->u.mprotect.len += len;
 			return 0;
 		}
@@ -116,9 +112,7 @@ static int add_mprotect(unsigned long ad
 			     		       .u = { .mprotect = {
 						       .addr	= addr,
 						       .len	= len,
-						       .r	= r,
-						       .w	= w,
-						       .x	= x } } });
+						       .prot	= prot } } });
 	return ret;
 }
 
@@ -133,7 +127,7 @@ static inline int update_pte_range(pmd_t
 						 void **))
 {
 	pte_t *pte;
-	int r, w, x, ret = 0;
+	int r, w, x, prot, ret = 0;
 
 	pte = pte_offset_kernel(pmd, addr);
 	do {
@@ -146,19 +140,19 @@ static inline int update_pte_range(pmd_t
 		} else if (!pte_dirty(*pte)) {
 			w = 0;
 		}
+		prot = ((r ? UM_PROT_READ : 0) | (w ? UM_PROT_WRITE : 0) |
+			(x ? UM_PROT_EXEC : 0));
 		if(force || pte_newpage(*pte)){
 			if(pte_present(*pte))
 				ret = add_mmap(addr, pte_val(*pte) & PAGE_MASK,
-					       PAGE_SIZE, r, w, x, ops,
-					       op_index, last_op, mmu, flush,
-					       do_ops);
+					       PAGE_SIZE, prot, ops, op_index,
+					       last_op, mmu, flush, do_ops);
 			else ret = add_munmap(addr, PAGE_SIZE, ops, op_index,
 					      last_op, mmu, flush, do_ops);
 		}
 		else if(pte_newprot(*pte))
-			ret = add_mprotect(addr, PAGE_SIZE, r, w, x, ops,
-					   op_index, last_op, mmu, flush,
-					   do_ops);
+			ret = add_mprotect(addr, PAGE_SIZE, prot, ops, op_index,
+					   last_op, mmu, flush, do_ops);
 		*pte = pte_mkuptodate(*pte);
 	} while (pte++, addr += PAGE_SIZE, ((addr != end) && !ret));
 	return ret;
@@ -377,14 +371,6 @@ pte_t *addr_pte(struct task_struct *task
 	return(pte_offset_map(pmd, addr));
 }
 
-void flush_tlb_page(struct vm_area_struct *vma, unsigned long address)
-{
-	address &= PAGE_MASK;
-
-	CHOOSE_MODE(flush_tlb_range(vma, address, address + PAGE_SIZE),
-		    flush_tlb_page_skas(vma, address));
-}
-
 void flush_tlb_all(void)
 {
 	flush_tlb_mm(current->mm);
diff -puN arch/um/os-Linux/skas/mem.c~uml-more-page-fault-path-trimming arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-more-page-fault-path-trimming
+++ a/arch/um/os-Linux/skas/mem.c
@@ -24,10 +24,11 @@
 #include "uml-config.h"
 #include "sysdep/ptrace.h"
 #include "sysdep/stub.h"
+#include "init.h"
 
 extern unsigned long batch_syscall_stub, __syscall_stub_start;
 
-extern void wait_stub_done(int pid, int sig, char * fname);
+extern void wait_stub_done(int pid);
 
 static inline unsigned long *check_init_stack(struct mm_id * mm_idp,
 					      unsigned long *stack)
@@ -39,6 +40,19 @@ static inline unsigned long *check_init_
 	return stack;
 }
 
+static unsigned long syscall_regs[MAX_REG_NR];
+
+static int __init init_syscall_regs(void)
+{
+	get_safe_registers(syscall_regs, NULL);
+	syscall_regs[REGS_IP_INDEX] = UML_CONFIG_STUB_CODE +
+		((unsigned long) &batch_syscall_stub -
+		 (unsigned long) &__syscall_stub_start);
+	return 0;
+}
+
+__initcall(init_syscall_regs);
+
 extern int proc_mm;
 
 int single_count = 0;
@@ -47,12 +61,11 @@ int multi_op_count = 0;
 
 static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 {
-	unsigned long regs[MAX_REG_NR];
 	int n, i;
 	long ret, offset;
 	unsigned long * data;
 	unsigned long * syscall;
-	int pid = mm_idp->u.pid;
+	int err, pid = mm_idp->u.pid;
 
 	if(proc_mm)
 #warning Need to look up userspace_pid by cpu
@@ -60,21 +73,21 @@ static inline long do_syscall_stub(struc
 
 	multi_count++;
 
-	get_safe_registers(regs, NULL);
-	regs[REGS_IP_INDEX] = UML_CONFIG_STUB_CODE +
-		((unsigned long) &batch_syscall_stub -
-		 (unsigned long) &__syscall_stub_start);
-
-	n = ptrace_setregs(pid, regs);
+	n = ptrace_setregs(pid, syscall_regs);
 	if(n < 0){
 		printk("Registers - \n");
 		for(i = 0; i < MAX_REG_NR; i++)
-			printk("\t%d\t0x%lx\n", i, regs[i]);
+			printk("\t%d\t0x%lx\n", i, syscall_regs[i]);
 		panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
 		      -n);
 	}
 
-	wait_stub_done(pid, 0, "do_syscall_stub");
+	err = ptrace(PTRACE_CONT, pid, 0, 0);
+	if(err)
+		panic("Failed to continue stub, pid = %d, errno = %d\n", pid,
+		      errno);
+
+	wait_stub_done(pid);
 
 	/* When the stub stops, we find the following values on the
 	 * beginning of the stack:
@@ -176,14 +189,10 @@ long syscall_stub_data(struct mm_id * mm
 	return 0;
 }
 
-int map(struct mm_id * mm_idp, unsigned long virt, unsigned long len,
-	int r, int w, int x, int phys_fd, unsigned long long offset,
-	int done, void **data)
+int map(struct mm_id * mm_idp, unsigned long virt, unsigned long len, int prot,
+	int phys_fd, unsigned long long offset, int done, void **data)
 {
-	int prot, ret;
-
-	prot = (r ? PROT_READ : 0) | (w ? PROT_WRITE : 0) |
-		(x ? PROT_EXEC : 0);
+	int ret;
 
 	if(proc_mm){
 		struct proc_mm_op map;
@@ -253,13 +262,11 @@ int unmap(struct mm_id * mm_idp, unsigne
 }
 
 int protect(struct mm_id * mm_idp, unsigned long addr, unsigned long len,
-	    int r, int w, int x, int done, void **data)
+	    unsigned int prot, int done, void **data)
 {
 	struct proc_mm_op protect;
-	int prot, ret;
+	int ret;
 
-	prot = (r ? PROT_READ : 0) | (w ? PROT_WRITE : 0) |
-		(x ? PROT_EXEC : 0);
 	if(proc_mm){
 		int fd = mm_idp->u.mm_fd;
 
diff -puN arch/um/os-Linux/skas/process.c~uml-more-page-fault-path-trimming arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-more-page-fault-path-trimming
+++ a/arch/um/os-Linux/skas/process.c
@@ -34,6 +34,7 @@
 #include "process.h"
 #include "longjmp.h"
 #include "kern_constants.h"
+#include "as-layout.h"
 
 int is_skas_winch(int pid, int fd, void *data)
 {
@@ -60,37 +61,42 @@ static int ptrace_dump_regs(int pid)
         return 0;
 }
 
-void wait_stub_done(int pid, int sig, char * fname)
+/*
+ * Signals that are OK to receive in the stub - we'll just continue it.
+ * SIGWINCH will happen when UML is inside a detached screen.
+ */
+#define STUB_SIG_MASK ((1 << SIGVTALRM) | (1 << SIGWINCH))
+
+/* Signals that the stub will finish with - anything else is an error */
+#define STUB_DONE_MASK ((1 << SIGUSR1) | (1 << SIGTRAP))
+
+void wait_stub_done(int pid)
 {
 	int n, status, err;
 
-	do {
-		if ( sig != -1 ) {
-			err = ptrace(PTRACE_CONT, pid, 0, sig);
-			if(err)
-				panic("%s : continue failed, errno = %d\n",
-				      fname, errno);
-		}
-		sig = 0;
-
+	while(1){
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
-	} while((n >= 0) && WIFSTOPPED(status) &&
-	        ((WSTOPSIG(status) == SIGVTALRM) ||
-		 /* running UML inside a detached screen can cause
-		  * SIGWINCHes
-		  */
-		 (WSTOPSIG(status) == SIGWINCH)));
-
-	if((n < 0) || !WIFSTOPPED(status) ||
-	   (WSTOPSIG(status) != SIGUSR1 && WSTOPSIG(status) != SIGTRAP)){
-		err = ptrace_dump_regs(pid);
+		if((n < 0) || !WIFSTOPPED(status))
+			goto bad_wait;
+
+		if(((1 << WSTOPSIG(status)) & STUB_SIG_MASK) == 0)
+			break;
+
+		err = ptrace(PTRACE_CONT, pid, 0, 0);
 		if(err)
-			printk("Failed to get registers from stub, "
-			       "errno = %d\n", -err);
-		panic("%s : failed to wait for SIGUSR1/SIGTRAP, "
-		      "pid = %d, n = %d, errno = %d, status = 0x%x\n",
-		      fname, pid, n, errno, status);
+			panic("wait_stub_done : continue failed, errno = %d\n",
+			      errno);
 	}
+
+	if(((1 << WSTOPSIG(status)) & STUB_DONE_MASK) != 0)
+		return;
+
+bad_wait:
+	err = ptrace_dump_regs(pid);
+	if(err)
+		printk("Failed to get registers from stub, errno = %d\n", -err);
+	panic("wait_stub_done : failed to wait for SIGUSR1/SIGTRAP, pid = %d, "
+	      "n = %d, errno = %d, status = 0x%x\n", pid, n, errno, status);
 }
 
 extern unsigned long current_stub_stack(void);
@@ -112,7 +118,11 @@ void get_skas_faultinfo(int pid, struct 
 			       sizeof(struct ptrace_faultinfo));
 	}
 	else {
-		wait_stub_done(pid, SIGSEGV, "get_skas_faultinfo");
+		err = ptrace(PTRACE_CONT, pid, 0, SIGSEGV);
+		if(err)
+			panic("Failed to continue stub, pid = %d, errno = %d\n",
+			      pid, errno);
+		wait_stub_done(pid);
 
 		/* faultinfo is prepared by the stub-segv-handler at start of
 		 * the stub stack page. We just have to copy it.
@@ -304,10 +314,13 @@ void userspace(union uml_pt_regs *regs)
 		UPT_SYSCALL_NR(regs) = -1; /* Assume: It's not a syscall */
 
 		if(WIFSTOPPED(status)){
-		  	switch(WSTOPSIG(status)){
+			int sig = WSTOPSIG(status);
+		  	switch(sig){
 			case SIGSEGV:
-				if(PTRACE_FULL_FAULTINFO || !ptrace_faultinfo)
-					user_signal(SIGSEGV, regs, pid);
+				if(PTRACE_FULL_FAULTINFO || !ptrace_faultinfo){
+					get_skas_faultinfo(pid, &regs->skas.faultinfo);
+					(*sig_info[SIGSEGV])(SIGSEGV, regs);
+				}
 				else handle_segv(pid, regs);
 				break;
 			case SIGTRAP + 0x80:
@@ -322,11 +335,13 @@ void userspace(union uml_pt_regs *regs)
 			case SIGBUS:
 			case SIGFPE:
 			case SIGWINCH:
-				user_signal(WSTOPSIG(status), regs, pid);
+				block_signals();
+				(*sig_info[sig])(sig, regs);
+				unblock_signals();
 				break;
 			default:
 			        printk("userspace - child stopped with signal "
-				       "%d\n", WSTOPSIG(status));
+				       "%d\n", sig);
 			}
 			pid = userspace_pid[0];
 			interrupt_end();
@@ -338,11 +353,29 @@ void userspace(union uml_pt_regs *regs)
 	}
 }
 
+static unsigned long thread_regs[MAX_REG_NR];
+static unsigned long thread_fp_regs[HOST_FP_SIZE];
+
+static int __init init_thread_regs(void)
+{
+	get_safe_registers(thread_regs, thread_fp_regs);
+	/* Set parent's instruction pointer to start of clone-stub */
+	thread_regs[REGS_IP_INDEX] = UML_CONFIG_STUB_CODE +
+				(unsigned long) stub_clone_handler -
+				(unsigned long) &__syscall_stub_start;
+	thread_regs[REGS_SP_INDEX] = UML_CONFIG_STUB_DATA + PAGE_SIZE -
+		sizeof(void *);
+#ifdef __SIGNAL_FRAMESIZE
+	thread_regs[REGS_SP_INDEX] -= __SIGNAL_FRAMESIZE;
+#endif
+	return 0;
+}
+
+__initcall(init_thread_regs);
+
 int copy_context_skas0(unsigned long new_stack, int pid)
 {
 	int err;
-	unsigned long regs[MAX_REG_NR];
-	unsigned long fp_regs[HOST_FP_SIZE];
 	unsigned long current_stack = current_stub_stack();
 	struct stub_data *data = (struct stub_data *) current_stack;
 	struct stub_data *child_data = (struct stub_data *) new_stack;
@@ -357,23 +390,12 @@ int copy_context_skas0(unsigned long new
 				      .timer    = ((struct itimerval)
 					            { { 0, 1000000 / hz() },
 						      { 0, 1000000 / hz() }})});
-	get_safe_registers(regs, fp_regs);
-
-	/* Set parent's instruction pointer to start of clone-stub */
-	regs[REGS_IP_INDEX] = UML_CONFIG_STUB_CODE +
-				(unsigned long) stub_clone_handler -
-				(unsigned long) &__syscall_stub_start;
-	regs[REGS_SP_INDEX] = UML_CONFIG_STUB_DATA + PAGE_SIZE -
-		sizeof(void *);
-#ifdef __SIGNAL_FRAMESIZE
-	regs[REGS_SP_INDEX] -= __SIGNAL_FRAMESIZE;
-#endif
-	err = ptrace_setregs(pid, regs);
+	err = ptrace_setregs(pid, thread_regs);
 	if(err < 0)
 		panic("copy_context_skas0 : PTRACE_SETREGS failed, "
 		      "pid = %d, errno = %d\n", pid, -err);
 
-	err = ptrace_setfpregs(pid, fp_regs);
+	err = ptrace_setfpregs(pid, thread_fp_regs);
 	if(err < 0)
 		panic("copy_context_skas0 : PTRACE_SETFPREGS failed, "
 		      "pid = %d, errno = %d\n", pid, -err);
@@ -384,7 +406,11 @@ int copy_context_skas0(unsigned long new
 	/* Wait, until parent has finished its work: read child's pid from
 	 * parent's stack, and check, if bad result.
 	 */
-	wait_stub_done(pid, 0, "copy_context_skas0");
+	err = ptrace(PTRACE_CONT, pid, 0, 0);
+	if(err)
+		panic("Failed to continue new process, pid = %d, "
+		      "errno = %d\n", pid, errno);
+	wait_stub_done(pid);
 
 	pid = data->err;
 	if(pid < 0)
@@ -394,7 +420,7 @@ int copy_context_skas0(unsigned long new
 	/* Wait, until child has finished too: read child's result from
 	 * child's stack and check it.
 	 */
-	wait_stub_done(pid, -1, "copy_context_skas0");
+	wait_stub_done(pid);
 	if (child_data->err != UML_CONFIG_STUB_DATA)
 		panic("copy_context_skas0 - stub-child reports error %ld\n",
 		      child_data->err);
diff -puN arch/um/os-Linux/skas/trap.c~uml-more-page-fault-path-trimming arch/um/os-Linux/skas/trap.c
--- a/arch/um/os-Linux/skas/trap.c~uml-more-page-fault-path-trimming
+++ a/arch/um/os-Linux/skas/trap.c
@@ -64,20 +64,3 @@ void sig_handler_common_skas(int sig, vo
 	errno = save_errno;
 	r->skas.is_user = save_user;
 }
-
-extern int ptrace_faultinfo;
-
-void user_signal(int sig, union uml_pt_regs *regs, int pid)
-{
-	void (*handler)(int, union uml_pt_regs *);
-	int segv = ((sig == SIGFPE) || (sig == SIGSEGV) || (sig == SIGBUS) ||
-		    (sig == SIGILL) || (sig == SIGTRAP));
-
-	if (segv)
-		get_skas_faultinfo(pid, &regs->skas.faultinfo);
-
-	handler = sig_info[sig];
-	handler(sig, (union uml_pt_regs *) regs);
-
-	unblock_signals();
-}
diff -puN arch/um/sys-i386/user-offsets.c~uml-more-page-fault-path-trimming arch/um/sys-i386/user-offsets.c
--- a/arch/um/sys-i386/user-offsets.c~uml-more-page-fault-path-trimming
+++ a/arch/um/sys-i386/user-offsets.c
@@ -1,9 +1,10 @@
 #include <stdio.h>
+#include <stddef.h>
 #include <signal.h>
+#include <sys/poll.h>
+#include <sys/mman.h>
 #include <asm/ptrace.h>
 #include <asm/user.h>
-#include <stddef.h>
-#include <sys/poll.h>
 
 #define DEFINE(sym, val) \
 	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -72,4 +73,8 @@ void foo(void)
 	DEFINE(UM_POLLIN, POLLIN);
 	DEFINE(UM_POLLPRI, POLLPRI);
 	DEFINE(UM_POLLOUT, POLLOUT);
+
+	DEFINE(UM_PROT_READ, PROT_READ);
+	DEFINE(UM_PROT_WRITE, PROT_WRITE);
+	DEFINE(UM_PROT_EXEC, PROT_EXEC);
 }
diff -puN arch/um/sys-x86_64/user-offsets.c~uml-more-page-fault-path-trimming arch/um/sys-x86_64/user-offsets.c
--- a/arch/um/sys-x86_64/user-offsets.c~uml-more-page-fault-path-trimming
+++ a/arch/um/sys-x86_64/user-offsets.c
@@ -2,6 +2,7 @@
 #include <stddef.h>
 #include <signal.h>
 #include <sys/poll.h>
+#include <sys/mman.h>
 #define __FRAME_OFFSETS
 #include <asm/ptrace.h>
 #include <asm/types.h>
@@ -93,4 +94,8 @@ void foo(void)
 	DEFINE(UM_POLLIN, POLLIN);
 	DEFINE(UM_POLLPRI, POLLPRI);
 	DEFINE(UM_POLLOUT, POLLOUT);
+
+	DEFINE(UM_PROT_READ, PROT_READ);
+	DEFINE(UM_PROT_WRITE, PROT_WRITE);
+	DEFINE(UM_PROT_EXEC, PROT_EXEC);
 }
diff -puN include/asm-um/page.h~uml-more-page-fault-path-trimming include/asm-um/page.h
--- a/include/asm-um/page.h~uml-more-page-fault-path-trimming
+++ a/include/asm-um/page.h
@@ -114,9 +114,6 @@ extern unsigned long uml_physmem;
 extern struct page *arch_validate(struct page *page, gfp_t mask, int order);
 #define HAVE_ARCH_VALIDATE
 
-extern void arch_free_page(struct page *page, int order);
-#define HAVE_ARCH_FREE_PAGE
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
diff -puN include/asm-um/tlbflush.h~uml-more-page-fault-path-trimming include/asm-um/tlbflush.h
--- a/include/asm-um/tlbflush.h~uml-more-page-fault-path-trimming
+++ a/include/asm-um/tlbflush.h
@@ -7,6 +7,7 @@
 #define __UM_TLBFLUSH_H
 
 #include <linux/mm.h>
+#include "choose-mode.h"
 
 /*
  * TLB flushing:
@@ -24,6 +25,18 @@ extern void flush_tlb_all(void);
 extern void flush_tlb_mm(struct mm_struct *mm);
 extern void flush_tlb_range(struct vm_area_struct *vma, unsigned long start, 
 			    unsigned long end);
+extern void flush_tlb_page_skas(struct vm_area_struct *vma,
+				unsigned long address);
+
+static inline void flush_tlb_page(struct vm_area_struct *vma,
+				  unsigned long address)
+{
+	address &= PAGE_MASK;
+
+	CHOOSE_MODE(flush_tlb_range(vma, address, address + PAGE_SIZE),
+		    flush_tlb_page_skas(vma, address));
+}
+
 extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr);
 extern void flush_tlb_kernel_vm(void);
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
@@ -35,14 +48,3 @@ static inline void flush_tlb_pgtables(st
 }
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
