From: akpm@linux-foundation.org
Subject: +
 powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch added to
 -mm tree
Date: Fri, 16 Sep 2016 16:34:44 -0700
Message-ID: <57dc8194.Y4T+rkEU4PbYXh4b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933409AbcIPXeq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:34:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sam@mendozajonas.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: adapt elf64_apply_relocate_add for kexec_file_load
has been added to the -mm tree.  Its filename is
     powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch

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
Subject: powerpc: adapt elf64_apply_relocate_add for kexec_file_load

Extend elf64_apply_relocate_add to support relative symbols. This is
necessary because there is a difference between how the module loading
mechanism and the kexec purgatory loading code use Elf64_Sym.st_value
at relocation time: the former changes st_value to point to the absolute
memory address before relocating the module, while the latter does that
adjustment during relocation of the purgatory.

Also, add a check_symbols argument so that the kexec code can be stricter
about undefined symbols.

Finally, add relocation types used by the purgatory.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1472579041-26033-8-git-send-email-bauerman@linux.vnet.ibm.com
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

 arch/powerpc/include/asm/elf_util.h |    2 
 arch/powerpc/kernel/elf_util_64.c   |  100 +++++++++++++++++++++++---
 arch/powerpc/kernel/module_64.c     |    6 +
 3 files changed, 99 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/include/asm/elf_util.h~powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load arch/powerpc/include/asm/elf_util.h
--- a/arch/powerpc/include/asm/elf_util.h~powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load
+++ a/arch/powerpc/include/asm/elf_util.h
@@ -20,6 +20,7 @@
 #include <linux/elf.h>
 
 struct elf_info {
+	const struct elfhdr *ehdr;
 	struct elf_shdr *sechdrs;
 
 	/* Index of stubs section. */
@@ -67,6 +68,7 @@ int elf64_apply_relocate_add(const struc
 			     const char *strtab, const Elf64_Rela *rela,
 			     unsigned int num_rela, void *syms_base,
 			     void *loc_base, Elf64_Addr addr_base,
+			     bool relative_symbols, bool check_symbols,
 			     const char *obj_name);
 
 #endif /* _ASM_POWERPC_ELF_UTIL_H */
diff -puN arch/powerpc/kernel/elf_util_64.c~powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load arch/powerpc/kernel/elf_util_64.c
--- a/arch/powerpc/kernel/elf_util_64.c~powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load
+++ a/arch/powerpc/kernel/elf_util_64.c
@@ -74,6 +74,8 @@ static void squash_toc_save_inst(const c
  * @syms_base:		Contents of the associated symbol table.
  * @loc_base:		Contents of the section to which relocations apply.
  * @addr_base:		The address where the section will be loaded in memory.
+ * @relative_symbols:	Are the symbols' st_value members relative?
+ * @check_symbols:	Fail if an unexpected symbol is found?
  * @obj_name:		The name of the ELF binary, for information messages.
  *
  * Applies RELA relocations to an ELF file already at its final location
@@ -84,12 +86,15 @@ int elf64_apply_relocate_add(const struc
 			     const char *strtab, const Elf64_Rela *rela,
 			     unsigned int num_rela, void *syms_base,
 			     void *loc_base, Elf64_Addr addr_base,
+			     bool relative_symbols, bool check_symbols,
 			     const char *obj_name)
 {
 	unsigned int i;
 	unsigned long *location;
 	unsigned long address;
+	unsigned long sec_base;
 	unsigned long value;
+	int reloc_type;
 	const char *name;
 	Elf64_Sym *sym;
 
@@ -116,15 +121,44 @@ int elf64_apply_relocate_add(const struc
 		else
 			name = "<unnamed symbol>";
 
-		pr_debug("RELOC at %p: %li-type as %s (0x%lx) + %li\n",
-		       location, (long)ELF64_R_TYPE(rela[i].r_info),
-		       name, (unsigned long)sym->st_value,
+		reloc_type = ELF64_R_TYPE(rela[i].r_info);
+
+		pr_debug("RELOC at %p: %i-type as %s (0x%lx) + %li\n",
+		       location, reloc_type, name, (unsigned long)sym->st_value,
 		       (long)rela[i].r_addend);
 
+		if (check_symbols) {
+			/*
+			 * TOC symbols appear as undefined but should be
+			 * resolved as well, so allow them to be processed.
+			 */
+			if (sym->st_shndx == SHN_UNDEF &&
+					strcmp(name, ".TOC.") != 0 &&
+					reloc_type != R_PPC64_TOC) {
+				pr_err("Undefined symbol: %s\n", name);
+				return -ENOEXEC;
+			} else if (sym->st_shndx == SHN_COMMON) {
+				pr_err("Symbol '%s' in common section.\n",
+				       name);
+				return -ENOEXEC;
+			}
+		}
+
+		if (relative_symbols && sym->st_shndx != SHN_ABS) {
+			if (sym->st_shndx >= elf_info->ehdr->e_shnum) {
+				pr_err("Invalid section %d for symbol %s\n",
+				       sym->st_shndx, name);
+				return -ENOEXEC;
+			}
+
+			sec_base = elf_info->sechdrs[sym->st_shndx].sh_addr;
+		} else
+			sec_base = 0;
+
 		/* `Everything is relative'. */
-		value = sym->st_value + rela[i].r_addend;
+		value = sym->st_value + sec_base + rela[i].r_addend;
 
-		switch (ELF64_R_TYPE(rela[i].r_info)) {
+		switch (reloc_type) {
 		case R_PPC64_ADDR32:
 			/* Simply set it */
 			*(u32 *)location = value;
@@ -135,6 +169,11 @@ int elf64_apply_relocate_add(const struc
 			*(unsigned long *)location = value;
 			break;
 
+		case R_PPC64_REL32:
+			*(uint32_t *) location =
+				value - (uint32_t)(uint64_t) location;
+			break;
+
 		case R_PPC64_TOC:
 			*(unsigned long *)location = my_r2(elf_info);
 			break;
@@ -186,6 +225,14 @@ int elf64_apply_relocate_add(const struc
 				| (value & 0xfffc);
 			break;
 
+		case R_PPC64_TOC16_HI:
+			/* Subtract TOC pointer */
+			value -= my_r2(elf_info);
+			value = value >> 16;
+			*((uint16_t *) location)
+				= (*((uint16_t *) location) & ~0xffff)
+				| (value & 0xffff);
+
 		case R_PPC64_TOC16_HA:
 			/* Subtract TOC pointer */
 			value -= my_r2(elf_info);
@@ -195,6 +242,21 @@ int elf64_apply_relocate_add(const struc
 				| (value & 0xffff);
 			break;
 
+		case R_PPC64_REL14:
+			/* Convert value to relative */
+			value -= address;
+			if (value + 0x8000 > 0xffff || (value & 3) != 0) {
+				pr_err("%s: REL14 %li out of range!\n",
+				       obj_name, (long int) value);
+				return -ENOEXEC;
+			}
+
+			/* Only replace bits 2 through 16 */
+			*(uint32_t *)location
+				= (*(uint32_t *)location & ~0xfffc)
+				| (value & 0xfffc);
+			break;
+
 		case R_PPC_REL24:
 			/* FIXME: Handle weak symbols here --RR */
 			if (sym->st_shndx == SHN_UNDEF) {
@@ -263,6 +325,29 @@ int elf64_apply_relocate_add(const struc
 			((uint32_t *)location)[1] = 0x38420000 + PPC_LO(value);
 			break;
 
+		case R_PPC64_ADDR16_LO:
+			*(uint16_t *)location = value & 0xffff;
+			break;
+
+		case R_PPC64_ADDR16_HI:
+			*(uint16_t *)location = (value >> 16) & 0xffff;
+			break;
+
+		case R_PPC64_ADDR16_HA:
+			*(uint16_t *)location = (((value + 0x8000) >> 16) &
+							0xffff);
+			break;
+
+		case R_PPC64_ADDR16_HIGHER:
+			*(uint16_t *)location = (((uint64_t)value >> 32) &
+							0xffff);
+			break;
+
+		case R_PPC64_ADDR16_HIGHEST:
+			*(uint16_t *)location = (((uint64_t)value >> 48) &
+							0xffff);
+			break;
+
 		case R_PPC64_REL16_HA:
 			/* Subtract location pointer */
 			value -= address;
@@ -281,9 +366,8 @@ int elf64_apply_relocate_add(const struc
 			break;
 
 		default:
-			pr_err("%s: Unknown ADD relocation: %lu\n",
-			       obj_name,
-			       (unsigned long)ELF64_R_TYPE(rela[i].r_info));
+			pr_err("%s: Unknown ADD relocation: %d\n", obj_name,
+			       reloc_type);
 			return -ENOEXEC;
 		}
 	}
diff -puN arch/powerpc/kernel/module_64.c~powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load arch/powerpc/kernel/module_64.c
--- a/arch/powerpc/kernel/module_64.c~powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load
+++ a/arch/powerpc/kernel/module_64.c
@@ -341,6 +341,7 @@ int module_frob_arch_sections(Elf64_Ehdr
 	sechdrs[me->arch.elf_info.stubs_section].sh_size = get_stubs_size(hdr, sechdrs);
 
 	/* For the elf_util functions. */
+	me->arch.elf_info.ehdr = hdr;
 	me->arch.elf_info.sechdrs = sechdrs;
 
 	return 0;
@@ -443,6 +444,9 @@ int restore_r2(u32 *instruction, const c
  * When this function is called, the module is already at its final location in
  * memory, so Elf64_Shdr.sh_addr can be used for accessing the section
  * contents as well as the base address for relocations.
+ *
+ * Also, simplify_symbols already changed all symbols' st_value members
+ * to absolute addresses.
  */
 int apply_relocate_add(Elf64_Shdr *sechdrs,
 		       const char *strtab,
@@ -472,7 +476,7 @@ int apply_relocate_add(Elf64_Shdr *sechd
 
 	return elf64_apply_relocate_add(&me->arch.elf_info, strtab, rela,
 					num_rela, syms_base, (void *) addr_base,
-					addr_base, me->name);
+					addr_base, false, false, me->name);
 }
 
 #ifdef CONFIG_DYNAMIC_FTRACE
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

