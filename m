From: akpm@linux-foundation.org
Subject: [merged]
 kexec-load-and-relocate-purgatory-at-kernel-load-time.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:44:03 -0700
Message-ID: <53ea6e83.73ubBxhQvnHoz5NE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:50195 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbaHLToE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:44:04 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2668697pab.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:44:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: load and relocate purgatory at kernel load time
has been removed from the -mm tree.  Its filename was
     kexec-load-and-relocate-purgatory-at-kernel-load-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: load and relocate purgatory at kernel load time

Load purgatory code in RAM and relocate it based on the location. 
Relocation code has been inspired by module relocation code and purgatory
relocation code in kexec-tools.

Also compute the checksums of loaded kexec segments and store them in
purgatory.

Arch independent code provides this functionality so that arch dependent
bootloaders can make use of it.

Helper functions are provided to get/set symbol values in purgatory which
are used by bootloaders later to set things like stack and entry point of
second kernel etc.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                   |    2 
 arch/ia64/Kconfig                  |    2 
 arch/m68k/Kconfig                  |    2 
 arch/mips/Kconfig                  |    2 
 arch/powerpc/Kconfig               |    2 
 arch/s390/Kconfig                  |    2 
 arch/sh/Kconfig                    |    2 
 arch/tile/Kconfig                  |    2 
 arch/x86/Kconfig                   |    2 
 arch/x86/kernel/machine_kexec_64.c |  142 +++++++
 include/linux/kexec.h              |   33 +
 kernel/kexec.c                     |  544 ++++++++++++++++++++++++++-
 12 files changed, 736 insertions(+), 1 deletion(-)

diff -puN arch/arm/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time arch/arm/Kconfig
--- a/arch/arm/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/arch/arm/Kconfig
@@ -2065,6 +2065,8 @@ config XIP_PHYS_ADDR
 config KEXEC
 	bool "Kexec system call (EXPERIMENTAL)"
 	depends on (!SMP || PM_SLEEP_SMP)
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/ia64/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/arch/ia64/Kconfig
@@ -549,6 +549,8 @@ source "drivers/sn/Kconfig"
 config KEXEC
 	bool "kexec system call"
 	depends on !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/m68k/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/arch/m68k/Kconfig
@@ -91,6 +91,8 @@ config MMU_SUN3
 config KEXEC
 	bool "kexec system call"
 	depends on M68KCLASSIC
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/mips/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time arch/mips/Kconfig
--- a/arch/mips/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/arch/mips/Kconfig
@@ -2396,6 +2396,8 @@ source "kernel/Kconfig.preempt"
 
 config KEXEC
 	bool "Kexec system call"
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/powerpc/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/arch/powerpc/Kconfig
@@ -399,6 +399,8 @@ config PPC64_SUPPORTS_MEMORY_FAILURE
 config KEXEC
 	bool "kexec system call"
 	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP))
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/s390/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time arch/s390/Kconfig
--- a/arch/s390/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/arch/s390/Kconfig
@@ -48,6 +48,8 @@ config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 
 config KEXEC
 	def_bool y
+	select CRYPTO
+	select CRYPTO_SHA256
 
 config AUDIT_ARCH
 	def_bool y
diff -puN arch/sh/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time arch/sh/Kconfig
--- a/arch/sh/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/arch/sh/Kconfig
@@ -595,6 +595,8 @@ source kernel/Kconfig.hz
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
 	depends on SUPERH32 && MMU
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/tile/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time arch/tile/Kconfig
--- a/arch/tile/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/arch/tile/Kconfig
@@ -191,6 +191,8 @@ source "kernel/Kconfig.hz"
 
 config KEXEC
 	bool "kexec system call"
+	select CRYPTO
+	select CRYPTO_SHA256
 	---help---
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/x86/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time arch/x86/Kconfig
--- a/arch/x86/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/arch/x86/Kconfig
@@ -1583,6 +1583,8 @@ source kernel/Kconfig.hz
 config KEXEC
 	bool "kexec system call"
 	select BUILD_BIN2C
+	select CRYPTO
+	select CRYPTO_SHA256
 	---help---
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-load-and-relocate-purgatory-at-kernel-load-time arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -6,6 +6,8 @@
  * Version 2.  See the file COPYING for more details.
  */
 
+#define pr_fmt(fmt)	"kexec: " fmt
+
 #include <linux/mm.h>
 #include <linux/kexec.h>
 #include <linux/string.h>
@@ -328,3 +330,143 @@ int arch_kimage_file_post_load_cleanup(s
 
 	return image->fops->cleanup(image);
 }
+
+/*
+ * Apply purgatory relocations.
+ *
+ * ehdr: Pointer to elf headers
+ * sechdrs: Pointer to section headers.
+ * relsec: section index of SHT_RELA section.
+ *
+ * TODO: Some of the code belongs to generic code. Move that in kexec.c.
+ */
+int arch_kexec_apply_relocations_add(const Elf64_Ehdr *ehdr,
+				     Elf64_Shdr *sechdrs, unsigned int relsec)
+{
+	unsigned int i;
+	Elf64_Rela *rel;
+	Elf64_Sym *sym;
+	void *location;
+	Elf64_Shdr *section, *symtabsec;
+	unsigned long address, sec_base, value;
+	const char *strtab, *name, *shstrtab;
+
+	/*
+	 * ->sh_offset has been modified to keep the pointer to section
+	 * contents in memory
+	 */
+	rel = (void *)sechdrs[relsec].sh_offset;
+
+	/* Section to which relocations apply */
+	section = &sechdrs[sechdrs[relsec].sh_info];
+
+	pr_debug("Applying relocate section %u to %u\n", relsec,
+		 sechdrs[relsec].sh_info);
+
+	/* Associated symbol table */
+	symtabsec = &sechdrs[sechdrs[relsec].sh_link];
+
+	/* String table */
+	if (symtabsec->sh_link >= ehdr->e_shnum) {
+		/* Invalid strtab section number */
+		pr_err("Invalid string table section index %d\n",
+		       symtabsec->sh_link);
+		return -ENOEXEC;
+	}
+
+	strtab = (char *)sechdrs[symtabsec->sh_link].sh_offset;
+
+	/* section header string table */
+	shstrtab = (char *)sechdrs[ehdr->e_shstrndx].sh_offset;
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+
+		/*
+		 * rel[i].r_offset contains byte offset from beginning
+		 * of section to the storage unit affected.
+		 *
+		 * This is location to update (->sh_offset). This is temporary
+		 * buffer where section is currently loaded. This will finally
+		 * be loaded to a different address later, pointed to by
+		 * ->sh_addr. kexec takes care of moving it
+		 *  (kexec_load_segment()).
+		 */
+		location = (void *)(section->sh_offset + rel[i].r_offset);
+
+		/* Final address of the location */
+		address = section->sh_addr + rel[i].r_offset;
+
+		/*
+		 * rel[i].r_info contains information about symbol table index
+		 * w.r.t which relocation must be made and type of relocation
+		 * to apply. ELF64_R_SYM() and ELF64_R_TYPE() macros get
+		 * these respectively.
+		 */
+		sym = (Elf64_Sym *)symtabsec->sh_offset +
+				ELF64_R_SYM(rel[i].r_info);
+
+		if (sym->st_name)
+			name = strtab + sym->st_name;
+		else
+			name = shstrtab + sechdrs[sym->st_shndx].sh_name;
+
+		pr_debug("Symbol: %s info: %02x shndx: %02x value=%llx size: %llx\n",
+			 name, sym->st_info, sym->st_shndx, sym->st_value,
+			 sym->st_size);
+
+		if (sym->st_shndx == SHN_UNDEF) {
+			pr_err("Undefined symbol: %s\n", name);
+			return -ENOEXEC;
+		}
+
+		if (sym->st_shndx == SHN_COMMON) {
+			pr_err("symbol '%s' in common section\n", name);
+			return -ENOEXEC;
+		}
+
+		if (sym->st_shndx == SHN_ABS)
+			sec_base = 0;
+		else if (sym->st_shndx >= ehdr->e_shnum) {
+			pr_err("Invalid section %d for symbol %s\n",
+			       sym->st_shndx, name);
+			return -ENOEXEC;
+		} else
+			sec_base = sechdrs[sym->st_shndx].sh_addr;
+
+		value = sym->st_value;
+		value += sec_base;
+		value += rel[i].r_addend;
+
+		switch (ELF64_R_TYPE(rel[i].r_info)) {
+		case R_X86_64_NONE:
+			break;
+		case R_X86_64_64:
+			*(u64 *)location = value;
+			break;
+		case R_X86_64_32:
+			*(u32 *)location = value;
+			if (value != *(u32 *)location)
+				goto overflow;
+			break;
+		case R_X86_64_32S:
+			*(s32 *)location = value;
+			if ((s64)value != *(s32 *)location)
+				goto overflow;
+			break;
+		case R_X86_64_PC32:
+			value -= (u64)address;
+			*(u32 *)location = value;
+			break;
+		default:
+			pr_err("Unknown rela relocation: %llu\n",
+			       ELF64_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+
+overflow:
+	pr_err("Overflow in relocation type %d value 0x%lx\n",
+	       (int)ELF64_R_TYPE(rel[i].r_info), value);
+	return -ENOEXEC;
+}
diff -puN include/linux/kexec.h~kexec-load-and-relocate-purgatory-at-kernel-load-time include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/include/linux/kexec.h
@@ -10,6 +10,7 @@
 #include <linux/ioport.h>
 #include <linux/elfcore.h>
 #include <linux/elf.h>
+#include <linux/module.h>
 #include <asm/kexec.h>
 
 /* Verify architecture specific macros are defined */
@@ -95,6 +96,27 @@ struct compat_kexec_segment {
 };
 #endif
 
+struct kexec_sha_region {
+	unsigned long start;
+	unsigned long len;
+};
+
+struct purgatory_info {
+	/* Pointer to elf header of read only purgatory */
+	Elf_Ehdr *ehdr;
+
+	/* Pointer to purgatory sechdrs which are modifiable */
+	Elf_Shdr *sechdrs;
+	/*
+	 * Temporary buffer location where purgatory is loaded and relocated
+	 * This memory can be freed post image load
+	 */
+	void *purgatory_buf;
+
+	/* Address where purgatory is finally loaded and is executed from */
+	unsigned long purgatory_load_addr;
+};
+
 struct kimage {
 	kimage_entry_t head;
 	kimage_entry_t *entry;
@@ -143,6 +165,9 @@ struct kimage {
 
 	/* Image loader handling the kernel can store a pointer here */
 	void *image_loader_data;
+
+	/* Information for loading purgatory */
+	struct purgatory_info purgatory_info;
 };
 
 /*
@@ -189,6 +214,14 @@ extern int kexec_add_buffer(struct kimag
 			    unsigned long *load_addr);
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
+extern int kexec_load_purgatory(struct kimage *image, unsigned long min,
+				unsigned long max, int top_down,
+				unsigned long *load_addr);
+extern int kexec_purgatory_get_set_symbol(struct kimage *image,
+					  const char *name, void *buf,
+					  unsigned int size, bool get_value);
+extern void *kexec_purgatory_get_symbol_addr(struct kimage *image,
+					     const char *name);
 extern void crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
diff -puN kernel/kexec.c~kexec-load-and-relocate-purgatory-at-kernel-load-time kernel/kexec.c
--- a/kernel/kexec.c~kexec-load-and-relocate-purgatory-at-kernel-load-time
+++ a/kernel/kexec.c
@@ -42,6 +42,9 @@
 #include <asm/io.h>
 #include <asm/sections.h>
 
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
 
@@ -54,6 +57,15 @@ size_t vmcoreinfo_max_size = sizeof(vmco
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
 
+/*
+ * Declare these symbols weak so that if architecture provides a purgatory,
+ * these will be overridden.
+ */
+char __weak kexec_purgatory[0];
+size_t __weak kexec_purgatory_size = 0;
+
+static int kexec_calculate_store_digests(struct kimage *image);
+
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
 	.name  = "Crash kernel",
@@ -404,6 +416,24 @@ void __weak arch_kimage_file_post_load_c
 {
 }
 
+/* Apply relocations of type RELA */
+int __weak
+arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
+				 unsigned int relsec)
+{
+	pr_err("RELA relocation unsupported.\n");
+	return -ENOEXEC;
+}
+
+/* Apply relocations of type REL */
+int __weak
+arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
+			     unsigned int relsec)
+{
+	pr_err("REL relocation unsupported.\n");
+	return -ENOEXEC;
+}
+
 /*
  * Free up memory used by kernel, initrd, and comand line. This is temporary
  * memory allocation which is not needed any more after these buffers have
@@ -411,6 +441,8 @@ void __weak arch_kimage_file_post_load_c
  */
 static void kimage_file_post_load_cleanup(struct kimage *image)
 {
+	struct purgatory_info *pi = &image->purgatory_info;
+
 	vfree(image->kernel_buf);
 	image->kernel_buf = NULL;
 
@@ -420,6 +452,12 @@ static void kimage_file_post_load_cleanu
 	kfree(image->cmdline_buf);
 	image->cmdline_buf = NULL;
 
+	vfree(pi->purgatory_buf);
+	pi->purgatory_buf = NULL;
+
+	vfree(pi->sechdrs);
+	pi->sechdrs = NULL;
+
 	/* See if architecture has anything to cleanup post load */
 	arch_kimage_file_post_load_cleanup(image);
 }
@@ -1105,7 +1143,7 @@ static int kimage_load_crash_segment(str
 		}
 		ubytes -= uchunk;
 		maddr  += mchunk;
-		buf    += mchunk;
+		buf += mchunk;
 		mbytes -= mchunk;
 	}
 out:
@@ -1340,6 +1378,10 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 	if (ret)
 		goto out;
 
+	ret = kexec_calculate_store_digests(image);
+	if (ret)
+		goto out;
+
 	for (i = 0; i < image->nr_segments; i++) {
 		struct kexec_segment *ksegment;
 
@@ -2092,6 +2134,506 @@ int kexec_add_buffer(struct kimage *imag
 	return 0;
 }
 
+/* Calculate and store the digest of segments */
+static int kexec_calculate_store_digests(struct kimage *image)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	int ret = 0, i, j, zero_buf_sz, sha_region_sz;
+	size_t desc_size, nullsz;
+	char *digest;
+	void *zero_buf;
+	struct kexec_sha_region *sha_regions;
+	struct purgatory_info *pi = &image->purgatory_info;
+
+	zero_buf = __va(page_to_pfn(ZERO_PAGE(0)) << PAGE_SHIFT);
+	zero_buf_sz = PAGE_SIZE;
+
+	tfm = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		goto out;
+	}
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto out_free_tfm;
+	}
+
+	sha_region_sz = KEXEC_SEGMENT_MAX * sizeof(struct kexec_sha_region);
+	sha_regions = vzalloc(sha_region_sz);
+	if (!sha_regions)
+		goto out_free_desc;
+
+	desc->tfm   = tfm;
+	desc->flags = 0;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto out_free_sha_regions;
+
+	digest = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
+	if (!digest) {
+		ret = -ENOMEM;
+		goto out_free_sha_regions;
+	}
+
+	for (j = i = 0; i < image->nr_segments; i++) {
+		struct kexec_segment *ksegment;
+
+		ksegment = &image->segment[i];
+		/*
+		 * Skip purgatory as it will be modified once we put digest
+		 * info in purgatory.
+		 */
+		if (ksegment->kbuf == pi->purgatory_buf)
+			continue;
+
+		ret = crypto_shash_update(desc, ksegment->kbuf,
+					  ksegment->bufsz);
+		if (ret)
+			break;
+
+		/*
+		 * Assume rest of the buffer is filled with zero and
+		 * update digest accordingly.
+		 */
+		nullsz = ksegment->memsz - ksegment->bufsz;
+		while (nullsz) {
+			unsigned long bytes = nullsz;
+
+			if (bytes > zero_buf_sz)
+				bytes = zero_buf_sz;
+			ret = crypto_shash_update(desc, zero_buf, bytes);
+			if (ret)
+				break;
+			nullsz -= bytes;
+		}
+
+		if (ret)
+			break;
+
+		sha_regions[j].start = ksegment->mem;
+		sha_regions[j].len = ksegment->memsz;
+		j++;
+	}
+
+	if (!ret) {
+		ret = crypto_shash_final(desc, digest);
+		if (ret)
+			goto out_free_digest;
+		ret = kexec_purgatory_get_set_symbol(image, "sha_regions",
+						sha_regions, sha_region_sz, 0);
+		if (ret)
+			goto out_free_digest;
+
+		ret = kexec_purgatory_get_set_symbol(image, "sha256_digest",
+						digest, SHA256_DIGEST_SIZE, 0);
+		if (ret)
+			goto out_free_digest;
+	}
+
+out_free_digest:
+	kfree(digest);
+out_free_sha_regions:
+	vfree(sha_regions);
+out_free_desc:
+	kfree(desc);
+out_free_tfm:
+	kfree(tfm);
+out:
+	return ret;
+}
+
+/* Actually load purgatory. Lot of code taken from kexec-tools */
+static int __kexec_load_purgatory(struct kimage *image, unsigned long min,
+				  unsigned long max, int top_down)
+{
+	struct purgatory_info *pi = &image->purgatory_info;
+	unsigned long align, buf_align, bss_align, buf_sz, bss_sz, bss_pad;
+	unsigned long memsz, entry, load_addr, curr_load_addr, bss_addr, offset;
+	unsigned char *buf_addr, *src;
+	int i, ret = 0, entry_sidx = -1;
+	const Elf_Shdr *sechdrs_c;
+	Elf_Shdr *sechdrs = NULL;
+	void *purgatory_buf = NULL;
+
+	/*
+	 * sechdrs_c points to section headers in purgatory and are read
+	 * only. No modifications allowed.
+	 */
+	sechdrs_c = (void *)pi->ehdr + pi->ehdr->e_shoff;
+
+	/*
+	 * We can not modify sechdrs_c[] and its fields. It is read only.
+	 * Copy it over to a local copy where one can store some temporary
+	 * data and free it at the end. We need to modify ->sh_addr and
+	 * ->sh_offset fields to keep track of permanent and temporary
+	 * locations of sections.
+	 */
+	sechdrs = vzalloc(pi->ehdr->e_shnum * sizeof(Elf_Shdr));
+	if (!sechdrs)
+		return -ENOMEM;
+
+	memcpy(sechdrs, sechdrs_c, pi->ehdr->e_shnum * sizeof(Elf_Shdr));
+
+	/*
+	 * We seem to have multiple copies of sections. First copy is which
+	 * is embedded in kernel in read only section. Some of these sections
+	 * will be copied to a temporary buffer and relocated. And these
+	 * sections will finally be copied to their final destination at
+	 * segment load time.
+	 *
+	 * Use ->sh_offset to reflect section address in memory. It will
+	 * point to original read only copy if section is not allocatable.
+	 * Otherwise it will point to temporary copy which will be relocated.
+	 *
+	 * Use ->sh_addr to contain final address of the section where it
+	 * will go during execution time.
+	 */
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (sechdrs[i].sh_type == SHT_NOBITS)
+			continue;
+
+		sechdrs[i].sh_offset = (unsigned long)pi->ehdr +
+						sechdrs[i].sh_offset;
+	}
+
+	/*
+	 * Identify entry point section and make entry relative to section
+	 * start.
+	 */
+	entry = pi->ehdr->e_entry;
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		if (!(sechdrs[i].sh_flags & SHF_EXECINSTR))
+			continue;
+
+		/* Make entry section relative */
+		if (sechdrs[i].sh_addr <= pi->ehdr->e_entry &&
+		    ((sechdrs[i].sh_addr + sechdrs[i].sh_size) >
+		     pi->ehdr->e_entry)) {
+			entry_sidx = i;
+			entry -= sechdrs[i].sh_addr;
+			break;
+		}
+	}
+
+	/* Determine how much memory is needed to load relocatable object. */
+	buf_align = 1;
+	bss_align = 1;
+	buf_sz = 0;
+	bss_sz = 0;
+
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		align = sechdrs[i].sh_addralign;
+		if (sechdrs[i].sh_type != SHT_NOBITS) {
+			if (buf_align < align)
+				buf_align = align;
+			buf_sz = ALIGN(buf_sz, align);
+			buf_sz += sechdrs[i].sh_size;
+		} else {
+			/* bss section */
+			if (bss_align < align)
+				bss_align = align;
+			bss_sz = ALIGN(bss_sz, align);
+			bss_sz += sechdrs[i].sh_size;
+		}
+	}
+
+	/* Determine the bss padding required to align bss properly */
+	bss_pad = 0;
+	if (buf_sz & (bss_align - 1))
+		bss_pad = bss_align - (buf_sz & (bss_align - 1));
+
+	memsz = buf_sz + bss_pad + bss_sz;
+
+	/* Allocate buffer for purgatory */
+	purgatory_buf = vzalloc(buf_sz);
+	if (!purgatory_buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (buf_align < bss_align)
+		buf_align = bss_align;
+
+	/* Add buffer to segment list */
+	ret = kexec_add_buffer(image, purgatory_buf, buf_sz, memsz,
+				buf_align, min, max, top_down,
+				&pi->purgatory_load_addr);
+	if (ret)
+		goto out;
+
+	/* Load SHF_ALLOC sections */
+	buf_addr = purgatory_buf;
+	load_addr = curr_load_addr = pi->purgatory_load_addr;
+	bss_addr = load_addr + buf_sz + bss_pad;
+
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		align = sechdrs[i].sh_addralign;
+		if (sechdrs[i].sh_type != SHT_NOBITS) {
+			curr_load_addr = ALIGN(curr_load_addr, align);
+			offset = curr_load_addr - load_addr;
+			/* We already modifed ->sh_offset to keep src addr */
+			src = (char *) sechdrs[i].sh_offset;
+			memcpy(buf_addr + offset, src, sechdrs[i].sh_size);
+
+			/* Store load address and source address of section */
+			sechdrs[i].sh_addr = curr_load_addr;
+
+			/*
+			 * This section got copied to temporary buffer. Update
+			 * ->sh_offset accordingly.
+			 */
+			sechdrs[i].sh_offset = (unsigned long)(buf_addr + offset);
+
+			/* Advance to the next address */
+			curr_load_addr += sechdrs[i].sh_size;
+		} else {
+			bss_addr = ALIGN(bss_addr, align);
+			sechdrs[i].sh_addr = bss_addr;
+			bss_addr += sechdrs[i].sh_size;
+		}
+	}
+
+	/* Update entry point based on load address of text section */
+	if (entry_sidx >= 0)
+		entry += sechdrs[entry_sidx].sh_addr;
+
+	/* Make kernel jump to purgatory after shutdown */
+	image->start = entry;
+
+	/* Used later to get/set symbol values */
+	pi->sechdrs = sechdrs;
+
+	/*
+	 * Used later to identify which section is purgatory and skip it
+	 * from checksumming.
+	 */
+	pi->purgatory_buf = purgatory_buf;
+	return ret;
+out:
+	vfree(sechdrs);
+	vfree(purgatory_buf);
+	return ret;
+}
+
+static int kexec_apply_relocations(struct kimage *image)
+{
+	int i, ret;
+	struct purgatory_info *pi = &image->purgatory_info;
+	Elf_Shdr *sechdrs = pi->sechdrs;
+
+	/* Apply relocations */
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		Elf_Shdr *section, *symtab;
+
+		if (sechdrs[i].sh_type != SHT_RELA &&
+		    sechdrs[i].sh_type != SHT_REL)
+			continue;
+
+		/*
+		 * For section of type SHT_RELA/SHT_REL,
+		 * ->sh_link contains section header index of associated
+		 * symbol table. And ->sh_info contains section header
+		 * index of section to which relocations apply.
+		 */
+		if (sechdrs[i].sh_info >= pi->ehdr->e_shnum ||
+		    sechdrs[i].sh_link >= pi->ehdr->e_shnum)
+			return -ENOEXEC;
+
+		section = &sechdrs[sechdrs[i].sh_info];
+		symtab = &sechdrs[sechdrs[i].sh_link];
+
+		if (!(section->sh_flags & SHF_ALLOC))
+			continue;
+
+		/*
+		 * symtab->sh_link contain section header index of associated
+		 * string table.
+		 */
+		if (symtab->sh_link >= pi->ehdr->e_shnum)
+			/* Invalid section number? */
+			continue;
+
+		/*
+		 * Respective archicture needs to provide support for applying
+		 * relocations of type SHT_RELA/SHT_REL.
+		 */
+		if (sechdrs[i].sh_type == SHT_RELA)
+			ret = arch_kexec_apply_relocations_add(pi->ehdr,
+							       sechdrs, i);
+		else if (sechdrs[i].sh_type == SHT_REL)
+			ret = arch_kexec_apply_relocations(pi->ehdr,
+							   sechdrs, i);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* Load relocatable purgatory object and relocate it appropriately */
+int kexec_load_purgatory(struct kimage *image, unsigned long min,
+			 unsigned long max, int top_down,
+			 unsigned long *load_addr)
+{
+	struct purgatory_info *pi = &image->purgatory_info;
+	int ret;
+
+	if (kexec_purgatory_size <= 0)
+		return -EINVAL;
+
+	if (kexec_purgatory_size < sizeof(Elf_Ehdr))
+		return -ENOEXEC;
+
+	pi->ehdr = (Elf_Ehdr *)kexec_purgatory;
+
+	if (memcmp(pi->ehdr->e_ident, ELFMAG, SELFMAG) != 0
+	    || pi->ehdr->e_type != ET_REL
+	    || !elf_check_arch(pi->ehdr)
+	    || pi->ehdr->e_shentsize != sizeof(Elf_Shdr))
+		return -ENOEXEC;
+
+	if (pi->ehdr->e_shoff >= kexec_purgatory_size
+	    || (pi->ehdr->e_shnum * sizeof(Elf_Shdr) >
+	    kexec_purgatory_size - pi->ehdr->e_shoff))
+		return -ENOEXEC;
+
+	ret = __kexec_load_purgatory(image, min, max, top_down);
+	if (ret)
+		return ret;
+
+	ret = kexec_apply_relocations(image);
+	if (ret)
+		goto out;
+
+	*load_addr = pi->purgatory_load_addr;
+	return 0;
+out:
+	vfree(pi->sechdrs);
+	vfree(pi->purgatory_buf);
+	return ret;
+}
+
+static Elf_Sym *kexec_purgatory_find_symbol(struct purgatory_info *pi,
+					    const char *name)
+{
+	Elf_Sym *syms;
+	Elf_Shdr *sechdrs;
+	Elf_Ehdr *ehdr;
+	int i, k;
+	const char *strtab;
+
+	if (!pi->sechdrs || !pi->ehdr)
+		return NULL;
+
+	sechdrs = pi->sechdrs;
+	ehdr = pi->ehdr;
+
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		if (sechdrs[i].sh_type != SHT_SYMTAB)
+			continue;
+
+		if (sechdrs[i].sh_link >= ehdr->e_shnum)
+			/* Invalid strtab section number */
+			continue;
+		strtab = (char *)sechdrs[sechdrs[i].sh_link].sh_offset;
+		syms = (Elf_Sym *)sechdrs[i].sh_offset;
+
+		/* Go through symbols for a match */
+		for (k = 0; k < sechdrs[i].sh_size/sizeof(Elf_Sym); k++) {
+			if (ELF_ST_BIND(syms[k].st_info) != STB_GLOBAL)
+				continue;
+
+			if (strcmp(strtab + syms[k].st_name, name) != 0)
+				continue;
+
+			if (syms[k].st_shndx == SHN_UNDEF ||
+			    syms[k].st_shndx >= ehdr->e_shnum) {
+				pr_debug("Symbol: %s has bad section index %d.\n",
+						name, syms[k].st_shndx);
+				return NULL;
+			}
+
+			/* Found the symbol we are looking for */
+			return &syms[k];
+		}
+	}
+
+	return NULL;
+}
+
+void *kexec_purgatory_get_symbol_addr(struct kimage *image, const char *name)
+{
+	struct purgatory_info *pi = &image->purgatory_info;
+	Elf_Sym *sym;
+	Elf_Shdr *sechdr;
+
+	sym = kexec_purgatory_find_symbol(pi, name);
+	if (!sym)
+		return ERR_PTR(-EINVAL);
+
+	sechdr = &pi->sechdrs[sym->st_shndx];
+
+	/*
+	 * Returns the address where symbol will finally be loaded after
+	 * kexec_load_segment()
+	 */
+	return (void *)(sechdr->sh_addr + sym->st_value);
+}
+
+/*
+ * Get or set value of a symbol. If "get_value" is true, symbol value is
+ * returned in buf otherwise symbol value is set based on value in buf.
+ */
+int kexec_purgatory_get_set_symbol(struct kimage *image, const char *name,
+				   void *buf, unsigned int size, bool get_value)
+{
+	Elf_Sym *sym;
+	Elf_Shdr *sechdrs;
+	struct purgatory_info *pi = &image->purgatory_info;
+	char *sym_buf;
+
+	sym = kexec_purgatory_find_symbol(pi, name);
+	if (!sym)
+		return -EINVAL;
+
+	if (sym->st_size != size) {
+		pr_err("symbol %s size mismatch: expected %lu actual %u\n",
+		       name, (unsigned long)sym->st_size, size);
+		return -EINVAL;
+	}
+
+	sechdrs = pi->sechdrs;
+
+	if (sechdrs[sym->st_shndx].sh_type == SHT_NOBITS) {
+		pr_err("symbol %s is in a bss section. Cannot %s\n", name,
+		       get_value ? "get" : "set");
+		return -EINVAL;
+	}
+
+	sym_buf = (unsigned char *)sechdrs[sym->st_shndx].sh_offset +
+					sym->st_value;
+
+	if (get_value)
+		memcpy((void *)buf, sym_buf, size);
+	else
+		memcpy((void *)sym_buf, buf, size);
+
+	return 0;
+}
 
 /*
  * Move into place and start executing a preloaded standalone
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch

