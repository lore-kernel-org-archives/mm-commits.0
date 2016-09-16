From: akpm@linux-foundation.org
Subject: + powerpc-generalize-elf64_apply_relocate_add.patch added to -mm
 tree
Date: Fri, 16 Sep 2016 16:34:41 -0700
Message-ID: <57dc8191.qIpG4IlSrtm7WD5Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59772 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757874AbcIPXen (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:34:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sam@mendozajonas.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: generalize elf64_apply_relocate_add
has been added to the -mm tree.  Its filename is
     powerpc-generalize-elf64_apply_relocate_add.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-generalize-elf64_apply_relocate_add.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-generalize-elf64_apply_relocate_add.patch

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
Subject: powerpc: generalize elf64_apply_relocate_add

When apply_relocate_add is called, modules are already loaded at their
final location in memory so Elf64_Shdr.sh_addr can be used for accessing
the section contents as well as the base address for relocations.

This is not the case for kexec's purgatory, because it will only be
copied to its final location right before being executed. Therefore,
it needs to be relocated while it is still in a temporary buffer. In
this case, Elf64_Shdr.sh_addr can't be used to access the sections'
contents.

This patch allows elf64_apply_relocate_add to be used when the ELF
binary is not yet at its final location by adding an addr_base argument
to specify the address at which the section will be loaded, and rela,
loc_base and syms_base to point to the sections' contents.

Link: http://lkml.kernel.org/r/1472579041-26033-7-git-send-email-bauerman@linux.vnet.ibm.com
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

 arch/powerpc/include/asm/elf_util.h |    6 +-
 arch/powerpc/kernel/elf_util_64.c   |   65 +++++++++++++++++---------
 arch/powerpc/kernel/module_64.c     |   17 +++++-
 3 files changed, 62 insertions(+), 26 deletions(-)

diff -puN arch/powerpc/include/asm/elf_util.h~powerpc-generalize-elf64_apply_relocate_add arch/powerpc/include/asm/elf_util.h
--- a/arch/powerpc/include/asm/elf_util.h~powerpc-generalize-elf64_apply_relocate_add
+++ a/arch/powerpc/include/asm/elf_util.h
@@ -64,7 +64,9 @@ static inline unsigned long my_r2(const
 }
 
 int elf64_apply_relocate_add(const struct elf_info *elf_info,
-			     const char *strtab, unsigned int symindex,
-			     unsigned int relsec, const char *obj_name);
+			     const char *strtab, const Elf64_Rela *rela,
+			     unsigned int num_rela, void *syms_base,
+			     void *loc_base, Elf64_Addr addr_base,
+			     const char *obj_name);
 
 #endif /* _ASM_POWERPC_ELF_UTIL_H */
diff -puN arch/powerpc/kernel/elf_util_64.c~powerpc-generalize-elf64_apply_relocate_add arch/powerpc/kernel/elf_util_64.c
--- a/arch/powerpc/kernel/elf_util_64.c~powerpc-generalize-elf64_apply_relocate_add
+++ a/arch/powerpc/kernel/elf_util_64.c
@@ -69,33 +69,56 @@ static void squash_toc_save_inst(const c
  * elf64_apply_relocate_add - apply 64 bit RELA relocations
  * @elf_info:		Support information for the ELF binary being relocated.
  * @strtab:		String table for the associated symbol table.
- * @symindex:		Section header index for the associated symbol table.
- * @relsec:		Section header index for the relocations to apply.
+ * @rela:		Contents of the section with the relocations to apply.
+ * @num_rela:		Number of relocation entries in the section.
+ * @syms_base:		Contents of the associated symbol table.
+ * @loc_base:		Contents of the section to which relocations apply.
+ * @addr_base:		The address where the section will be loaded in memory.
  * @obj_name:		The name of the ELF binary, for information messages.
+ *
+ * Applies RELA relocations to an ELF file already at its final location
+ * in memory (in which case loc_base == addr_base), or still in a temporary
+ * buffer.
  */
 int elf64_apply_relocate_add(const struct elf_info *elf_info,
-			     const char *strtab, unsigned int symindex,
-			     unsigned int relsec, const char *obj_name)
+			     const char *strtab, const Elf64_Rela *rela,
+			     unsigned int num_rela, void *syms_base,
+			     void *loc_base, Elf64_Addr addr_base,
+			     const char *obj_name)
 {
 	unsigned int i;
-	Elf64_Shdr *sechdrs = elf_info->sechdrs;
-	Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
-	Elf64_Sym *sym;
 	unsigned long *location;
+	unsigned long address;
 	unsigned long value;
+	const char *name;
+	Elf64_Sym *sym;
 
-
-	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
-		/* This is where to make the change */
-		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
-			+ rela[i].r_offset;
-		/* This is the symbol it is referring to */
-		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
-			+ ELF64_R_SYM(rela[i].r_info);
+	for (i = 0; i < num_rela; i++) {
+		/*
+		 * rels[i].r_offset contains the byte offset from the beginning
+		 * of section to the storage unit affected.
+		 *
+		 * This is the location to update in the temporary buffer where
+		 * the section is currently loaded. The section will finally
+		 * be loaded to a different address later, pointed to by
+		 * addr_base.
+		 */
+		location = loc_base + rela[i].r_offset;
+
+		/* Final address of the location. */
+		address = addr_base + rela[i].r_offset;
+
+		/* This is the symbol the relocation is referring to. */
+		sym = (Elf64_Sym *) syms_base + ELF64_R_SYM(rela[i].r_info);
+
+		if (sym->st_name)
+			name = strtab + sym->st_name;
+		else
+			name = "<unnamed symbol>";
 
 		pr_debug("RELOC at %p: %li-type as %s (0x%lx) + %li\n",
 		       location, (long)ELF64_R_TYPE(rela[i].r_info),
-		       strtab + sym->st_name, (unsigned long)sym->st_value,
+		       name, (unsigned long)sym->st_value,
 		       (long)rela[i].r_addend);
 
 		/* `Everything is relative'. */
@@ -187,7 +210,7 @@ int elf64_apply_relocate_add(const struc
 				value += local_entry_offset(sym);
 
 			/* Convert value to relative */
-			value -= (unsigned long)location;
+			value -= address;
 			if (value + 0x2000000 > 0x3ffffff || (value & 3) != 0){
 				pr_err("%s: REL24 %li out of range!\n",
 				       obj_name, (long int)value);
@@ -202,7 +225,7 @@ int elf64_apply_relocate_add(const struc
 
 		case R_PPC64_REL64:
 			/* 64 bits relative (used by features fixups) */
-			*location = value - (unsigned long)location;
+			*location = value - address;
 			break;
 
 		case R_PPC64_TOCSAVE:
@@ -218,7 +241,7 @@ int elf64_apply_relocate_add(const struc
 			 * Optimize ELFv2 large code model entry point if
 			 * the TOC is within 2GB range of current location.
 			 */
-			value = my_r2(elf_info) - (unsigned long)location;
+			value = my_r2(elf_info) - address;
 			if (value + 0x80008000 > 0xffffffff)
 				break;
 			/*
@@ -242,7 +265,7 @@ int elf64_apply_relocate_add(const struc
 
 		case R_PPC64_REL16_HA:
 			/* Subtract location pointer */
-			value -= (unsigned long)location;
+			value -= address;
 			value = ((value + 0x8000) >> 16);
 			*((uint16_t *) location)
 				= (*((uint16_t *) location) & ~0xffff)
@@ -251,7 +274,7 @@ int elf64_apply_relocate_add(const struc
 
 		case R_PPC64_REL16_LO:
 			/* Subtract location pointer */
-			value -= (unsigned long)location;
+			value -= address;
 			*((uint16_t *) location)
 				= (*((uint16_t *) location) & ~0xffff)
 				| (value & 0xffff);
diff -puN arch/powerpc/kernel/module_64.c~powerpc-generalize-elf64_apply_relocate_add arch/powerpc/kernel/module_64.c
--- a/arch/powerpc/kernel/module_64.c~powerpc-generalize-elf64_apply_relocate_add
+++ a/arch/powerpc/kernel/module_64.c
@@ -439,16 +439,26 @@ int restore_r2(u32 *instruction, const c
 	return 1;
 }
 
+/*
+ * When this function is called, the module is already at its final location in
+ * memory, so Elf64_Shdr.sh_addr can be used for accessing the section
+ * contents as well as the base address for relocations.
+ */
 int apply_relocate_add(Elf64_Shdr *sechdrs,
 		       const char *strtab,
 		       unsigned int symindex,
 		       unsigned int relsec,
 		       struct module *me)
 {
+	Elf64_Shdr *rel_section = &sechdrs[relsec];
+	void *syms_base = (void *) sechdrs[symindex].sh_addr;
+	Elf64_Addr addr_base = sechdrs[rel_section->sh_info].sh_addr;
+	const Elf64_Rela *rela = (const Elf64_Rela *) rel_section->sh_addr;
+	unsigned int num_rela = rel_section->sh_size / sizeof(Elf64_Rela);
 	Elf64_Sym *sym;
 
 	pr_debug("Applying ADD relocate section %u to %u\n", relsec,
-	       sechdrs[relsec].sh_info);
+		 rel_section->sh_info);
 
 	/* First time we're called, we can fix up .TOC. */
 	if (!me->arch.toc_fixed) {
@@ -460,8 +470,9 @@ int apply_relocate_add(Elf64_Shdr *sechd
 		me->arch.toc_fixed = true;
 	}
 
-	return elf64_apply_relocate_add(&me->arch.elf_info, strtab, symindex,
-					relsec, me->name);
+	return elf64_apply_relocate_add(&me->arch.elf_info, strtab, rela,
+					num_rela, syms_base, (void *) addr_base,
+					addr_base, me->name);
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

