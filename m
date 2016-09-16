From: akpm@linux-foundation.org
Subject: + powerpc-implement-kexec_file_load.patch added to -mm tree
Date: Fri, 16 Sep 2016 16:34:51 -0700
Message-ID: <57dc819b.83lUC0nabhxx/VMl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932599AbcIPXex (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sam@mendozajonas.com, sklar@linux.vnet.ibm.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: implement kexec_file_load
has been added to the -mm tree.  Its filename is
     powerpc-implement-kexec_file_load.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-implement-kexec_file_load.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-implement-kexec_file_load.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc: implement kexec_file_load

arch_kexec_walk_mem and arch_kexec_apply_relocations_add are used by
generic kexec code, while setup_purgatory is powerpc-specific and sets
runtime variables needed by the powerpc purgatory implementation.

Link: http://lkml.kernel.org/r/1472579041-26033-10-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Josh Sklar <sklar@linux.vnet.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                   |   13 +
 arch/powerpc/include/asm/kexec.h       |    7 
 arch/powerpc/include/asm/systbl.h      |    1 
 arch/powerpc/include/asm/unistd.h      |    2 
 arch/powerpc/include/uapi/asm/unistd.h |    1 
 arch/powerpc/kernel/Makefile           |    4 
 arch/powerpc/kernel/machine_kexec_64.c |  252 +++++++++++++++++++++++
 7 files changed, 278 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/Kconfig~powerpc-implement-kexec_file_load arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-implement-kexec_file_load
+++ a/arch/powerpc/Kconfig
@@ -459,6 +459,19 @@ config KEXEC
 	  interface is strongly in flux, so no good recommendation can be
 	  made.
 
+config KEXEC_FILE
+	bool "kexec file based system call"
+	select KEXEC_CORE
+	select BUILD_BIN2C
+	depends on PPC64
+	depends on CRYPTO=y
+	depends on CRYPTO_SHA256=y
+	help
+	  This is a new version of the kexec system call. This call is
+	  file based and takes in file descriptors as system call arguments
+	  for kernel and initramfs as opposed to a list of segments as is the
+	  case for the older kexec call.
+
 config RELOCATABLE
 	bool "Build a relocatable kernel"
 	depends on (PPC64 && !COMPILE_TEST) || (FLATMEM && (44x || FSL_BOOKE))
diff -puN arch/powerpc/include/asm/kexec.h~powerpc-implement-kexec_file_load arch/powerpc/include/asm/kexec.h
--- a/arch/powerpc/include/asm/kexec.h~powerpc-implement-kexec_file_load
+++ a/arch/powerpc/include/asm/kexec.h
@@ -91,6 +91,13 @@ static inline bool kdump_in_progress(voi
 	return crashing_cpu >= 0;
 }
 
+#ifdef CONFIG_KEXEC_FILE
+int setup_purgatory(struct kimage *image, const void *slave_code,
+		    const void *fdt, unsigned long kernel_load_addr,
+		    unsigned long fdt_load_addr, unsigned long stack_top,
+		    int debug);
+#endif /* CONFIG_KEXEC_FILE */
+
 #else /* !CONFIG_KEXEC_CORE */
 static inline void crash_kexec_secondary(struct pt_regs *regs) { }
 
diff -puN arch/powerpc/include/asm/systbl.h~powerpc-implement-kexec_file_load arch/powerpc/include/asm/systbl.h
--- a/arch/powerpc/include/asm/systbl.h~powerpc-implement-kexec_file_load
+++ a/arch/powerpc/include/asm/systbl.h
@@ -386,3 +386,4 @@ SYSCALL(mlock2)
 SYSCALL(copy_file_range)
 COMPAT_SYS_SPU(preadv2)
 COMPAT_SYS_SPU(pwritev2)
+SYSCALL(kexec_file_load)
diff -puN arch/powerpc/include/asm/unistd.h~powerpc-implement-kexec_file_load arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~powerpc-implement-kexec_file_load
+++ a/arch/powerpc/include/asm/unistd.h
@@ -12,7 +12,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls		382
+#define NR_syscalls		383
 
 #define __NR__exit __NR_exit
 
diff -puN arch/powerpc/include/uapi/asm/unistd.h~powerpc-implement-kexec_file_load arch/powerpc/include/uapi/asm/unistd.h
--- a/arch/powerpc/include/uapi/asm/unistd.h~powerpc-implement-kexec_file_load
+++ a/arch/powerpc/include/uapi/asm/unistd.h
@@ -392,5 +392,6 @@
 #define __NR_copy_file_range	379
 #define __NR_preadv2		380
 #define __NR_pwritev2		381
+#define __NR_kexec_file_load	382
 
 #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
diff -puN arch/powerpc/kernel/Makefile~powerpc-implement-kexec_file_load arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-implement-kexec_file_load
+++ a/arch/powerpc/kernel/Makefile
@@ -123,9 +123,11 @@ ifneq ($(CONFIG_PPC_INDIRECT_PIO),y)
 obj-y				+= iomap.o
 endif
 
-ifeq ($(CONFIG_MODULES)$(CONFIG_WORD_SIZE),y64)
+ifneq ($(CONFIG_MODULES)$(CONFIG_KEXEC_FILE),)
+ifeq ($(CONFIG_WORD_SIZE),64)
 obj-y				+= elf_util.o elf_util_64.o
 endif
+endif
 
 obj64-$(CONFIG_PPC_TRANSACTIONAL_MEM)	+= tm.o
 
diff -puN arch/powerpc/kernel/machine_kexec_64.c~powerpc-implement-kexec_file_load arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~powerpc-implement-kexec_file_load
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -18,6 +18,8 @@
 #include <linux/kernel.h>
 #include <linux/cpu.h>
 #include <linux/hardirq.h>
+#include <linux/memblock.h>
+#include <linux/libfdt.h>
 
 #include <asm/page.h>
 #include <asm/current.h>
@@ -31,6 +33,12 @@
 #include <asm/hw_breakpoint.h>
 #include <asm/asm-prototypes.h>
 
+#define SLAVE_CODE_SIZE		256
+
+#ifdef CONFIG_KEXEC_FILE
+static struct kexec_file_ops *kexec_file_loaders[] = { };
+#endif
+
 #ifdef CONFIG_PPC_BOOK3E
 int default_machine_kexec_prepare(struct kimage *image)
 {
@@ -432,3 +440,247 @@ static int __init export_htab_values(voi
 }
 late_initcall(export_htab_values);
 #endif /* CONFIG_PPC_STD_MMU_64 */
+
+#ifdef CONFIG_KEXEC_FILE
+int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
+				  unsigned long buf_len)
+{
+	int i, ret = -ENOEXEC;
+	struct kexec_file_ops *fops;
+
+	/* We don't support crash kernels yet. */
+	if (image->type == KEXEC_TYPE_CRASH)
+		return -ENOTSUPP;
+
+	for (i = 0; i < ARRAY_SIZE(kexec_file_loaders); i++) {
+		fops = kexec_file_loaders[i];
+		if (!fops || !fops->probe)
+			continue;
+
+		ret = fops->probe(buf, buf_len);
+		if (!ret) {
+			image->fops = fops;
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+void *arch_kexec_kernel_image_load(struct kimage *image)
+{
+	if (!image->fops || !image->fops->load)
+		return ERR_PTR(-ENOEXEC);
+
+	return image->fops->load(image, image->kernel_buf,
+				 image->kernel_buf_len, image->initrd_buf,
+				 image->initrd_buf_len, image->cmdline_buf,
+				 image->cmdline_buf_len);
+}
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image)
+{
+	if (!image->fops || !image->fops->cleanup)
+		return 0;
+
+	return image->fops->cleanup(image->image_loader_data);
+}
+
+/**
+ * arch_kexec_walk_mem() - call func(data) for each unreserved memory block
+ * @kbuf:	Context info for the search. Also passed to @func.
+ * @func:	Function to call for each memory block.
+ *
+ * This function is used by kexec_add_buffer and kexec_locate_mem_hole
+ * to find unreserved memory to load kexec segments into.
+ *
+ * Return: The memory walk will stop when func returns a non-zero value
+ * and that value will be returned. If all free regions are visited without
+ * func returning non-zero, then zero will be returned.
+ */
+int arch_kexec_walk_mem(struct kexec_buf *kbuf, int (*func)(u64, u64, void *))
+{
+	int ret = 0;
+	u64 i;
+	phys_addr_t mstart, mend;
+
+	if (kbuf->top_down) {
+		for_each_free_mem_range_reverse(i, NUMA_NO_NODE, 0,
+						&mstart, &mend, NULL) {
+			/*
+			 * In memblock, end points to the first byte after the
+			 * range while in kexec, end points to the last byte
+			 * in the range.
+			 */
+			ret = func(mstart, mend - 1, kbuf);
+			if (ret)
+				break;
+		}
+	} else {
+		for_each_free_mem_range(i, NUMA_NO_NODE, 0, &mstart, &mend,
+					NULL) {
+			/*
+			 * In memblock, end points to the first byte after the
+			 * range while in kexec, end points to the last byte
+			 * in the range.
+			 */
+			ret = func(mstart, mend - 1, kbuf);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * arch_kexec_apply_relocations_add() - apply purgatory relocations
+ * @ehdr:	Pointer to ELF headers.
+ * @sechdrs:	Pointer to section headers.
+ * @relsec:	Section index of SHT_RELA section.
+ *
+ * Elf64_Shdr.sh_offset has been modified to keep the pointer to the section
+ * contents, while Elf64_Shdr.sh_addr points to the final address of the
+ * section in memory.
+ */
+int arch_kexec_apply_relocations_add(const Elf64_Ehdr *ehdr,
+				     Elf64_Shdr *sechdrs, unsigned int relsec)
+{
+	/* Section containing the relocation entries. */
+	Elf64_Shdr *rel_section = &sechdrs[relsec];
+	const Elf64_Rela *rela = (const Elf64_Rela *) rel_section->sh_offset;
+	unsigned int num_rela = rel_section->sh_size / sizeof(Elf64_Rela);
+	/* Section to which relocations apply. */
+	Elf64_Shdr *target_section = &sechdrs[rel_section->sh_info];
+	/* Associated symbol table. */
+	Elf64_Shdr *symtabsec = &sechdrs[rel_section->sh_link];
+	void *syms_base = (void *) symtabsec->sh_offset;
+	void *loc_base = (void *) target_section->sh_offset;
+	Elf64_Addr addr_base = target_section->sh_addr;
+	struct elf_info elf_info;
+	const char *strtab;
+
+	if (symtabsec->sh_link >= ehdr->e_shnum) {
+		/* Invalid strtab section number */
+		pr_err("Invalid string table section index %d\n",
+		       symtabsec->sh_link);
+		return -ENOEXEC;
+	}
+	/* String table for the associated symbol table. */
+	strtab = (const char *) sechdrs[symtabsec->sh_link].sh_offset;
+
+	elf_init_elf_info(ehdr, sechdrs, &elf_info);
+
+	return elf64_apply_relocate_add(&elf_info, strtab, rela, num_rela,
+					syms_base, loc_base, addr_base,
+					true, true, "kexec purgatory");
+}
+
+/**
+ * setup_purgatory() - setup the purgatory runtime variables
+ * @image:		kexec image.
+ * @slave_code:		Slave code for the purgatory.
+ * @fdt:		Flattened device tree for the next kernel.
+ * @kernel_load_addr:	Address where the kernel is loaded.
+ * @fdt_load_addr:	Address where the flattened device tree is loaded.
+ * @stack_top:		Address where the purgatory can place its stack.
+ * @debug:		Can the purgatory print messages to the console?
+ *
+ * Return: 0 on success, or negative errno on error.
+ */
+int setup_purgatory(struct kimage *image, const void *slave_code,
+		    const void *fdt, unsigned long kernel_load_addr,
+		    unsigned long fdt_load_addr, unsigned long stack_top,
+		    int debug)
+{
+	int ret, tree_node;
+	const void *prop;
+	unsigned long opal_base, opal_entry;
+	uint64_t toc;
+	unsigned int *slave_code_buf, master_entry;
+	struct elf_info purg_info;
+
+	slave_code_buf = kmalloc(SLAVE_CODE_SIZE, GFP_KERNEL);
+	if (!slave_code_buf)
+		return -ENOMEM;
+
+	/* Get the slave code from the new kernel and put it in purgatory. */
+	ret = kexec_purgatory_get_set_symbol(image, "purgatory_start",
+					     slave_code_buf, SLAVE_CODE_SIZE,
+					     true);
+	if (ret) {
+		kfree(slave_code_buf);
+		return ret;
+	}
+
+	master_entry = slave_code_buf[0];
+	memcpy(slave_code_buf, slave_code, SLAVE_CODE_SIZE);
+	slave_code_buf[0] = master_entry;
+	ret = kexec_purgatory_get_set_symbol(image, "purgatory_start",
+					     slave_code_buf, SLAVE_CODE_SIZE,
+					     false);
+	kfree(slave_code_buf);
+
+	ret = kexec_purgatory_get_set_symbol(image, "kernel", &kernel_load_addr,
+					     sizeof(kernel_load_addr), false);
+	if (ret)
+		return ret;
+	ret = kexec_purgatory_get_set_symbol(image, "dt_offset", &fdt_load_addr,
+					     sizeof(fdt_load_addr), false);
+	if (ret)
+		return ret;
+
+	tree_node = fdt_path_offset(fdt, "/ibm,opal");
+	if (tree_node >= 0) {
+		prop = fdt_getprop(fdt, tree_node, "opal-base-address", NULL);
+		if (!prop) {
+			pr_err("OPAL address not found in the device tree.\n");
+			return -EINVAL;
+		}
+		opal_base = fdt64_to_cpu((const fdt64_t *) prop);
+
+		prop = fdt_getprop(fdt, tree_node, "opal-entry-address", NULL);
+		if (!prop) {
+			pr_err("OPAL address not found in the device tree.\n");
+			return -EINVAL;
+		}
+		opal_entry = fdt64_to_cpu((const fdt64_t *) prop);
+
+		ret = kexec_purgatory_get_set_symbol(image, "opal_base",
+						     &opal_base,
+						     sizeof(opal_base), false);
+		if (ret)
+			return ret;
+		ret = kexec_purgatory_get_set_symbol(image, "opal_entry",
+						     &opal_entry,
+						     sizeof(opal_entry), false);
+		if (ret)
+			return ret;
+	}
+
+	ret = kexec_purgatory_get_set_symbol(image, "stack", &stack_top,
+					     sizeof(stack_top), false);
+	if (ret)
+		return ret;
+
+	elf_init_elf_info(image->purgatory_info.ehdr,
+			  image->purgatory_info.sechdrs, &purg_info);
+	toc = my_r2(&purg_info);
+	ret = kexec_purgatory_get_set_symbol(image, "my_toc", &toc, sizeof(toc),
+					     false);
+	if (ret)
+		return ret;
+
+	pr_debug("Purgatory TOC is at 0x%llx\n", toc);
+
+	ret = kexec_purgatory_get_set_symbol(image, "debug", &debug,
+					     sizeof(debug), false);
+	if (ret)
+		return ret;
+	if (!debug)
+		pr_debug("Disabling purgatory output.\n");
+
+	return 0;
+}
+
+#endif /* CONFIG_KEXEC_FILE */
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch
powerpc-generalize-elf64_apply_relocate_add.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load-fix.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-add-purgatory-for-kexec_file_load-implementation-fix.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-include-the-purgatory-segment-in-the-kexec-image-checksum.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-on-soft-reboot-save-the-measurement-list.patch

