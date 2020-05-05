From: akpm@linux-foundation.org
Subject: +
 binfmt_elf-remove-the-set_fskernel_ds-in-elf_core_dump.patch added to -mm
 tree
Date: Tue, 05 May 2020 12:29:58 -0700
Message-ID: <20200505192958.70Uf6Db9U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgEET37 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 15:29:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, benh@kernel.crashing.org, ebiederm@xmission.com, hch@lst.de, jk@ozlabs.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, oleg@redhat.com, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: binfmt_elf: remove the set_fs(KERNEL_DS) in elf_core_dump
has been added to the -mm tree.  Its filename is
     binfmt_elf-remove-the-set_fskernel_ds-in-elf_core_dump.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_elf-remove-the-set_fskernel_ds-in-elf_core_dump.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elf-remove-the-set_fskernel_ds-in-elf_core_dump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: binfmt_elf: remove the set_fs(KERNEL_DS) in elf_core_dump

There is no logic in elf_core_dump itself or in the various arch helpers
called from it which use uaccess routines on kernel pointers except for
the file writes thate are nicely encapsulated by using __kernel_write in
dump_emit.

Link: http://lkml.kernel.org/r/20200505101256.3121270-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/fs/binfmt_elf.c~binfmt_elf-remove-the-set_fskernel_ds-in-elf_core_dump
+++ a/fs/binfmt_elf.c
@@ -1351,7 +1351,6 @@ static unsigned long vma_dump_size(struc
 	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
 		u32 __user *header = (u32 __user *) vma->vm_start;
 		u32 word;
-		mm_segment_t fs = get_fs();
 		/*
 		 * Doing it this way gets the constant folded by GCC.
 		 */
@@ -1364,14 +1363,8 @@ static unsigned long vma_dump_size(struc
 		magic.elfmag[EI_MAG1] = ELFMAG1;
 		magic.elfmag[EI_MAG2] = ELFMAG2;
 		magic.elfmag[EI_MAG3] = ELFMAG3;
-		/*
-		 * Switch to the user "segment" for get_user(),
-		 * then put back what elf_core_dump() had in place.
-		 */
-		set_fs(USER_DS);
 		if (unlikely(get_user(word, header)))
 			word = 0;
-		set_fs(fs);
 		if (word == magic.cmp)
 			return PAGE_SIZE;
 	}
@@ -2179,7 +2172,6 @@ static void fill_extnum_info(struct elfh
 static int elf_core_dump(struct coredump_params *cprm)
 {
 	int has_dumped = 0;
-	mm_segment_t fs;
 	int segs, i;
 	size_t vma_data_size = 0;
 	struct vm_area_struct *vma, *gate_vma;
@@ -2228,13 +2220,10 @@ static int elf_core_dump(struct coredump
 	 * notes.  This also sets up the file header.
 	 */
 	if (!fill_note_info(&elf, e_phnum, &info, cprm->siginfo, cprm->regs))
-		goto cleanup;
+		goto end_coredump;
 
 	has_dumped = 1;
 
-	fs = get_fs();
-	set_fs(KERNEL_DS);
-
 	offset += sizeof(elf);				/* Elf header */
 	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
 
@@ -2362,9 +2351,6 @@ static int elf_core_dump(struct coredump
 	}
 
 end_coredump:
-	set_fs(fs);
-
-cleanup:
 	free_note_info(&info);
 	kfree(shdr4extnum);
 	kvfree(vma_filesz);
_

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
powerpc-spufs-stop-using-access_ok.patch
powerpc-spufs-simplify-spufs-core-dumping.patch
signal-refactor-copy_siginfo_to_user32.patch
binfmt_elf-remove-the-set_fskernel_ds-in-elf_core_dump.patch
binfmt_elf_fdpic-remove-the-set_fskernel_ds-in-elf_fdpic_core_dump.patch
exec-simplify-the-copy_strings_kernel-calling-convention.patch
exec-open-code-copy_string_kernel.patch
amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
