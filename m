From: akpm@linux-foundation.org
Subject: - revert-pie-randomization.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:33:55 -0700
Message-ID: <200707230933.l6N9Xt45016334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33613 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401AbXGWJfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:35:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, honza@jikos.cz, hpa@zytor.com, jakub@redhat.com, jkosina@suse.cz, kune@deine-taler.de, magnade@gmail.com, mingo@elte.hu, roland@redhat.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     revert "PIE randomization"
has been removed from the -mm tree.  Its filename was
     revert-pie-randomization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert "PIE randomization"
From: Andrew Morton <akpm@linux-foundation.org>

There are reports of this causing userspace failures
(http://lkml.org/lkml/2007/7/20/421).

Revert.

Cc: Jan Kratochvil <honza@jikos.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Bret Towe" <magnade@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/binfmt_elf32.c |    2 
 fs/binfmt_elf.c               |  109 ++++++--------------------------
 2 files changed, 24 insertions(+), 87 deletions(-)

diff -puN arch/ia64/ia32/binfmt_elf32.c~revert-pie-randomization arch/ia64/ia32/binfmt_elf32.c
--- a/arch/ia64/ia32/binfmt_elf32.c~revert-pie-randomization
+++ a/arch/ia64/ia32/binfmt_elf32.c
@@ -226,7 +226,7 @@ elf32_set_personality (void)
 }
 
 static unsigned long
-elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type, unsigned long unused)
+elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type)
 {
 	unsigned long pgoff = (eppnt->p_vaddr) & ~IA32_PAGE_MASK;
 
diff -puN fs/binfmt_elf.c~revert-pie-randomization fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~revert-pie-randomization
+++ a/fs/binfmt_elf.c
@@ -45,7 +45,7 @@
 
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
-static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);
+static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int);
 
 /*
  * If we don't support core dumping, then supply a NULL so we
@@ -80,7 +80,7 @@ static struct linux_binfmt elf_format = 
 		.hasvdso	= 1
 };
 
-#define BAD_ADDR(x) IS_ERR_VALUE(x)
+#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
 
 static int set_brk(unsigned long start, unsigned long end)
 {
@@ -295,70 +295,33 @@ create_elf_tables(struct linux_binprm *b
 #ifndef elf_map
 
 static unsigned long elf_map(struct file *filep, unsigned long addr,
-		struct elf_phdr *eppnt, int prot, int type,
-		unsigned long total_size)
+		struct elf_phdr *eppnt, int prot, int type)
 {
 	unsigned long map_addr;
-	unsigned long size = eppnt->p_filesz + ELF_PAGEOFFSET(eppnt->p_vaddr);
-	unsigned long off = eppnt->p_offset - ELF_PAGEOFFSET(eppnt->p_vaddr);
-	addr = ELF_PAGESTART(addr);
-	size = ELF_PAGEALIGN(size);
+	unsigned long pageoffset = ELF_PAGEOFFSET(eppnt->p_vaddr);
 
+	down_write(&current->mm->mmap_sem);
 	/* mmap() will return -EINVAL if given a zero size, but a
 	 * segment with zero filesize is perfectly valid */
-	if (!size)
-		return addr;
-
-	down_write(&current->mm->mmap_sem);
-	/*
-	* total_size is the size of the ELF (interpreter) image.
-	* The _first_ mmap needs to know the full size, otherwise
-	* randomization might put this image into an overlapping
-	* position with the ELF binary image. (since size < total_size)
-	* So we first map the 'big' image - and unmap the remainder at
-	* the end. (which unmap is needed for ELF images with holes.)
-	*/
-	if (total_size) {
-		total_size = ELF_PAGEALIGN(total_size);
-		map_addr = do_mmap(filep, addr, total_size, prot, type, off);
-		if (!BAD_ADDR(map_addr))
-			do_munmap(current->mm, map_addr+size, total_size-size);
-	} else
-		map_addr = do_mmap(filep, addr, size, prot, type, off);
-
+	if (eppnt->p_filesz + pageoffset)
+		map_addr = do_mmap(filep, ELF_PAGESTART(addr),
+				   eppnt->p_filesz + pageoffset, prot, type,
+				   eppnt->p_offset - pageoffset);
+	else
+		map_addr = ELF_PAGESTART(addr);
 	up_write(&current->mm->mmap_sem);
 	return(map_addr);
 }
 
 #endif /* !elf_map */
 
-static unsigned long total_mapping_size(struct elf_phdr *cmds, int nr)
-{
-	int i, first_idx = -1, last_idx = -1;
-
-	for (i = 0; i < nr; i++) {
-		if (cmds[i].p_type == PT_LOAD) {
-			last_idx = i;
-			if (first_idx == -1)
-				first_idx = i;
-		}
-	}
-	if (first_idx == -1)
-		return 0;
-
-	return cmds[last_idx].p_vaddr + cmds[last_idx].p_memsz -
-				ELF_PAGESTART(cmds[first_idx].p_vaddr);
-}
-
-
 /* This is much more generalized than the library routine read function,
    so we keep this separate.  Technically the library read function
    is only provided so that we can read a.out libraries that have
    an ELF header */
 
 static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
-		struct file *interpreter, unsigned long *interp_map_addr,
-		unsigned long no_base)
+		struct file *interpreter, unsigned long *interp_load_addr)
 {
 	struct elf_phdr *elf_phdata;
 	struct elf_phdr *eppnt;
@@ -366,7 +329,6 @@ static unsigned long load_elf_interp(str
 	int load_addr_set = 0;
 	unsigned long last_bss = 0, elf_bss = 0;
 	unsigned long error = ~0UL;
-	unsigned long total_size;
 	int retval, i, size;
 
 	/* First of all, some simple consistency checks */
@@ -405,12 +367,6 @@ static unsigned long load_elf_interp(str
 		goto out_close;
 	}
 
-	total_size = total_mapping_size(elf_phdata, interp_elf_ex->e_phnum);
-	if (!total_size) {
-		error = -EINVAL;
-		goto out_close;
-	}
-
 	eppnt = elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
 		if (eppnt->p_type == PT_LOAD) {
@@ -428,14 +384,9 @@ static unsigned long load_elf_interp(str
 			vaddr = eppnt->p_vaddr;
 			if (interp_elf_ex->e_type == ET_EXEC || load_addr_set)
 				elf_type |= MAP_FIXED;
-			else if (no_base && interp_elf_ex->e_type == ET_DYN)
-				load_addr = -vaddr;
 
 			map_addr = elf_map(interpreter, load_addr + vaddr,
-					   eppnt, elf_prot, elf_type, total_size);
-			total_size = 0;
-			if (!*interp_map_addr)
-				*interp_map_addr = map_addr;
+					   eppnt, elf_prot, elf_type);
 			error = map_addr;
 			if (BAD_ADDR(map_addr))
 				goto out_close;
@@ -501,7 +452,8 @@ static unsigned long load_elf_interp(str
 			goto out_close;
 	}
 
-	error = load_addr;
+	*interp_load_addr = load_addr;
+	error = ((unsigned long)interp_elf_ex->e_entry) + load_addr;
 
 out_close:
 	kfree(elf_phdata);
@@ -598,8 +550,7 @@ static int load_elf_binary(struct linux_
 	int elf_exec_fileno;
 	int retval, i;
 	unsigned int size;
-	unsigned long elf_entry;
-	unsigned long interp_load_addr = 0;
+	unsigned long elf_entry, interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc = 0;
 	char passed_fileno[6];
@@ -863,7 +814,9 @@ static int load_elf_binary(struct linux_
 	current->mm->start_stack = bprm->p;
 
 	/* Now we do a little grungy work by mmaping the ELF image into
-	   the correct location in memory. */
+	   the correct location in memory.  At this point, we assume that
+	   the image should be loaded at fixed address, not at a variable
+	   address. */
 	for(i = 0, elf_ppnt = elf_phdata;
 	    i < loc->elf_ex.e_phnum; i++, elf_ppnt++) {
 		int elf_prot = 0, elf_flags;
@@ -917,15 +870,11 @@ static int load_elf_binary(struct linux_
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
-#ifdef CONFIG_X86
-			load_bias = 0;
-#else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
-#endif
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
-				elf_prot, elf_flags,0);
+				elf_prot, elf_flags);
 		if (BAD_ADDR(error)) {
 			send_sig(SIGKILL, current, 0);
 			retval = IS_ERR((void *)error) ?
@@ -1001,25 +950,13 @@ static int load_elf_binary(struct linux_
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT) {
+		if (interpreter_type == INTERPRETER_AOUT)
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
-		} else {
-			unsigned long uninitialized_var(interp_map_addr);
-
+		else
 			elf_entry = load_elf_interp(&loc->interp_elf_ex,
 						    interpreter,
-						    &interp_map_addr,
-						    load_bias);
-			if (!BAD_ADDR(elf_entry)) {
-				/*
-				 * load_elf_interp() returns relocation
-				 * adjustment
-				 */
-				interp_load_addr = elf_entry;
-				elf_entry += loc->interp_elf_ex.e_entry;
-			}
-		}
+						    &interp_load_addr);
 		if (BAD_ADDR(elf_entry)) {
 			force_sig(SIGSEGV, current);
 			retval = IS_ERR((void *)elf_entry) ?
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
mtd-potential-leak-in-rfd_ftl_add_mtd-fix.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
ip_auto_config-fix-fix.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-xfs-fixup.patch
git-kgdb-fixup-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
