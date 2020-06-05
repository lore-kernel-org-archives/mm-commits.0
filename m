From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Fri, 05 Jun 2020 12:54:20 -0700
Message-ID: <20200605195420._Gw5acJnG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbgFETyW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 15:54:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/kasan/kasan_init_32.c |   54 +++++++++---------------
 fs/binfmt_misc.c                      |   36 ++--------------
 fs/binfmt_script.c                    |    2 
 include/linux/binfmts.h               |    1 
 4 files changed, 28 insertions(+), 65 deletions(-)

--- a/fs/binfmt_misc.c~linux-next-rejects
+++ a/fs/binfmt_misc.c
@@ -159,51 +159,25 @@ static int load_misc_binary(struct linux
 			goto ret;
 	}
 
-	if (fmt->flags & MISC_FMT_OPEN_BINARY) {
+	if (fmt->flags & MISC_FMT_OPEN_BINARY)
+		bprm->have_execfd = 1;
 
-		/* if the binary should be opened on behalf of the
-		 * interpreter than keep it open and assign descriptor
-		 * to it
-		 */
-		fd_binary = get_unused_fd_flags(0);
-		if (fd_binary < 0) {
-			retval = fd_binary;
-			goto ret;
-		}
-		fd_install(fd_binary, bprm->file);
-
-		/* if the binary is not readable than enforce mm->dumpable=0
-		   regardless of the interpreter's permissions */
-		would_dump(bprm, bprm->file);
-
-		allow_write_access(bprm->file);
-		bprm->file = NULL;
-
-		/* mark the bprm that fd should be passed to interp */
-		bprm->interp_flags |= BINPRM_FLAGS_EXECFD;
-		bprm->interp_data = fd_binary;
-
-	} else {
-		allow_write_access(bprm->file);
-		fput(bprm->file);
-		bprm->file = NULL;
-	}
 	/* make argv[1] be the path to the binary */
 	retval = copy_string_kernel(bprm->interp, bprm);
 	if (retval < 0)
-		goto error;
+		goto ret;
 	bprm->argc++;
 
 	/* add the interp as argv[0] */
 	retval = copy_string_kernel(fmt->interpreter, bprm);
 	if (retval < 0)
-		goto error;
+		goto ret;
 	bprm->argc++;
 
 	/* Update interp in case binfmt_script needs it. */
 	retval = bprm_change_interp(fmt->interpreter, bprm);
 	if (retval < 0)
-		goto error;
+		goto ret;
 
 	if (fmt->flags & MISC_FMT_OPEN_FILE) {
 		interp_file = file_clone_open(fmt->interp_file);
--- a/fs/binfmt_script.c~linux-next-rejects
+++ a/fs/binfmt_script.c
@@ -110,7 +110,9 @@ static int load_script(struct linux_binp
 	if (retval < 0)
 		return retval;
 	bprm->argc++;
+	*((char *)i_end) = '\0';
 	if (i_arg) {
+		*((char *)i_sep) = '\0';
 		retval = copy_string_kernel(i_arg, bprm);
 		if (retval < 0)
 			return retval;
--- a/include/linux/binfmts.h~linux-next-rejects
+++ a/include/linux/binfmts.h
@@ -131,7 +131,6 @@ extern int transfer_args_to_stack(struct
 				  unsigned long *sp_location);
 extern int bprm_change_interp(const char *interp, struct linux_binprm *bprm);
 int copy_string_kernel(const char *arg, struct linux_binprm *bprm);
-extern void install_exec_creds(struct linux_binprm *bprm);
 extern void set_binfmt(struct linux_binfmt *new);
 extern ssize_t read_code(struct file *, unsigned long, loff_t, size_t);
 
--- a/arch/powerpc/mm/kasan/kasan_init_32.c~linux-next-rejects
+++ a/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -65,75 +65,63 @@ int __init __weak kasan_init_region(void
 		return ret;
 
 	block = memblock_alloc(k_end - k_start, PAGE_SIZE);
+	if (!block)
+		return -ENOMEM;
 
 	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
 		pmd_t *pmd = pmd_ptr_k(k_cur);
 		void *va = block + k_cur - k_start;
 		pte_t pte = pfn_pte(PHYS_PFN(__pa(va)), PAGE_KERNEL);
 
-		if (!va)
-			return -ENOMEM;
-
 		__set_pte_at(&init_mm, k_cur, pte_offset_kernel(pmd, k_cur), pte, 0);
 	}
 	flush_tlb_kernel_range(k_start, k_end);
 	return 0;
 }
 
-static void __init kasan_remap_early_shadow_ro(void)
+void __init
+kasan_update_early_region(unsigned long k_start, unsigned long k_end, pte_t pte)
 {
-	pgprot_t prot = kasan_prot_ro();
-	unsigned long k_start = KASAN_SHADOW_START;
-	unsigned long k_end = KASAN_SHADOW_END;
 	unsigned long k_cur;
 	phys_addr_t pa = __pa(kasan_early_shadow_page);
 
-	kasan_populate_pte(kasan_early_shadow_pte, prot);
-
-	for (k_cur = k_start & PAGE_MASK; k_cur != k_end; k_cur += PAGE_SIZE) {
+	for (k_cur = k_start; k_cur != k_end; k_cur += PAGE_SIZE) {
 		pmd_t *pmd = pmd_ptr_k(k_cur);
 		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
 
 		if ((pte_val(*ptep) & PTE_RPN_MASK) != pa)
 			continue;
 
-		__set_pte_at(&init_mm, k_cur, ptep, pfn_pte(PHYS_PFN(pa), prot), 0);
+		__set_pte_at(&init_mm, k_cur, ptep, pte, 0);
 	}
-	flush_tlb_kernel_range(KASAN_SHADOW_START, KASAN_SHADOW_END);
+
+	flush_tlb_kernel_range(k_start, k_end);
 }
 
-static void __init kasan_unmap_early_shadow_vmalloc(void)
+static void __init kasan_remap_early_shadow_ro(void)
 {
-	unsigned long k_start = (unsigned long)kasan_mem_to_shadow((void *)VMALLOC_START);
-	unsigned long k_end = (unsigned long)kasan_mem_to_shadow((void *)VMALLOC_END);
-	unsigned long k_cur;
+	pgprot_t prot = kasan_prot_ro();
 	phys_addr_t pa = __pa(kasan_early_shadow_page);
 
-	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
-		pmd_t *pmd = pmd_ptr_k(k_cur);
-		pte_t *ptep = pte_offset_kernel(pmd, k_cur);
+	kasan_populate_pte(kasan_early_shadow_pte, prot);
 
-		if ((pte_val(*ptep) & PTE_RPN_MASK) != pa)
-			continue;
+	kasan_update_early_region(KASAN_SHADOW_START, KASAN_SHADOW_END,
+				  pfn_pte(PHYS_PFN(pa), prot));
+}
 
-		__set_pte_at(&init_mm, k_cur, ptep, __pte(0), 0);
-	}
-	flush_tlb_kernel_range(k_start, k_end);
+static void __init kasan_unmap_early_shadow_vmalloc(void)
+{
+	unsigned long k_start = (unsigned long)kasan_mem_to_shadow((void *)VMALLOC_START);
+	unsigned long k_end = (unsigned long)kasan_mem_to_shadow((void *)VMALLOC_END);
+
+	kasan_update_early_region(k_start, k_end, __pte(0));
 }
 
-void __init kasan_mmu_init(void)
+static void __init kasan_mmu_init(void)
 {
 	int ret;
 	struct memblock_region *reg;
 
-	if (early_mmu_has_feature(MMU_FTR_HPTE_TABLE) ||
-	    IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
-		ret = kasan_init_shadow_page_tables(KASAN_SHADOW_START, KASAN_SHADOW_END);
-
-		if (ret)
-			panic("kasan: kasan_init_shadow_page_tables() failed");
-	}
-
 	for_each_memblock(memory, reg) {
 		phys_addr_t base = reg->base;
 		phys_addr_t top = min(base + reg->size, total_lowmem);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
