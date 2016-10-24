From: akpm@linux-foundation.org
Subject: + powerpc-factor-out-relocation-code-in-module_64c.patch added to -mm tree
Date: Mon, 24 Oct 2016 12:42:39 -0700
Message-ID: <580e642f.8q8g9pnjb9Ys416g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56675 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941059AbcJXTmk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 15:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, sklar@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: factor out relocation code in module_64.c
has been added to the -mm tree.  Its filename is
     powerpc-factor-out-relocation-code-in-module_64c.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-factor-out-relocation-code-in-module_64c.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-factor-out-relocation-code-in-module_64c.patch

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
Subject: powerpc: factor out relocation code in module_64.c

The kexec_file_load system call needs to relocate the purgatory, so factor
out the module relocation code so that it can be shared.

This patch's purpose is to move the ELF relocation logic from
apply_relocate_add to the new function elf64_apply_relocate_add_item with
as few changes as possible.  The following changes were needed:

elf64_apply_relocate_add_item takes a my_r2 argument because the kexec
code can't use the my_r2 function since it doesn't have a struct module to
pass to it.  For the same reason, it also takes an obj_name argument to
use in error messages.  It still takes a pointer to struct module
argument, but kexec code can just pass NULL because except for the TOC
symbol, the purgatory doesn't have undefined symbols so the module pointer
isn't used.

Apart from what is described in the paragraph above, the code has no
functional changes.

Link: http://lkml.kernel.org/r/1477017617-8540-6-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andreas Steffen <andreas.steffen@strongswan.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/module_64.c |  344 +++++++++++++++---------------
 1 file changed, 182 insertions(+), 162 deletions(-)

diff -puN arch/powerpc/kernel/module_64.c~powerpc-factor-out-relocation-code-in-module_64c arch/powerpc/kernel/module_64.c
--- a/arch/powerpc/kernel/module_64.c~powerpc-factor-out-relocation-code-in-module_64c
+++ a/arch/powerpc/kernel/module_64.c
@@ -507,6 +507,181 @@ static int restore_r2(u32 *instruction,
 	return 1;
 }
 
+static int elf64_apply_relocate_add_item(const Elf64_Shdr *sechdrs,
+					 const char *strtab,
+					 const Elf64_Rela *rela,
+					 const Elf64_Sym *sym,
+					 unsigned long *location,
+					 unsigned long value,
+					 unsigned long my_r2,
+					 const char *obj_name,
+					 struct module *me)
+{
+	switch (ELF64_R_TYPE(rela->r_info)) {
+	case R_PPC64_ADDR32:
+		/* Simply set it */
+		*(u32 *)location = value;
+		break;
+
+	case R_PPC64_ADDR64:
+		/* Simply set it */
+		*(unsigned long *)location = value;
+		break;
+
+	case R_PPC64_TOC:
+		*(unsigned long *)location = my_r2;
+		break;
+
+	case R_PPC64_TOC16:
+		/* Subtract TOC pointer */
+		value -= my_r2;
+		if (value + 0x8000 > 0xffff) {
+			pr_err("%s: bad TOC16 relocation (0x%lx)\n",
+			       obj_name, value);
+			return -ENOEXEC;
+		}
+		*((uint16_t *) location)
+			= (*((uint16_t *) location) & ~0xffff)
+			| (value & 0xffff);
+		break;
+
+	case R_PPC64_TOC16_LO:
+		/* Subtract TOC pointer */
+		value -= my_r2;
+		*((uint16_t *) location)
+			= (*((uint16_t *) location) & ~0xffff)
+			| (value & 0xffff);
+		break;
+
+	case R_PPC64_TOC16_DS:
+		/* Subtract TOC pointer */
+		value -= my_r2;
+		if ((value & 3) != 0 || value + 0x8000 > 0xffff) {
+			pr_err("%s: bad TOC16_DS relocation (0x%lx)\n",
+			       obj_name, value);
+			return -ENOEXEC;
+		}
+		*((uint16_t *) location)
+			= (*((uint16_t *) location) & ~0xfffc)
+			| (value & 0xfffc);
+		break;
+
+	case R_PPC64_TOC16_LO_DS:
+		/* Subtract TOC pointer */
+		value -= my_r2;
+		if ((value & 3) != 0) {
+			pr_err("%s: bad TOC16_LO_DS relocation (0x%lx)\n",
+			       obj_name, value);
+			return -ENOEXEC;
+		}
+		*((uint16_t *) location)
+			= (*((uint16_t *) location) & ~0xfffc)
+			| (value & 0xfffc);
+		break;
+
+	case R_PPC64_TOC16_HA:
+		/* Subtract TOC pointer */
+		value -= my_r2;
+		value = ((value + 0x8000) >> 16);
+		*((uint16_t *) location)
+			= (*((uint16_t *) location) & ~0xffff)
+			| (value & 0xffff);
+		break;
+
+	case R_PPC_REL24:
+		/* FIXME: Handle weak symbols here --RR */
+		if (sym->st_shndx == SHN_UNDEF) {
+			/* External: go via stub */
+			value = stub_for_addr(sechdrs, value, me);
+			if (!value)
+				return -ENOENT;
+			if (!restore_r2((u32 *)location + 1, me))
+				return -ENOEXEC;
+
+			squash_toc_save_inst(strtab + sym->st_name, value);
+		} else
+			value += local_entry_offset(sym);
+
+		/* Convert value to relative */
+		value -= (unsigned long)location;
+		if (value + 0x2000000 > 0x3ffffff || (value & 3) != 0) {
+			pr_err("%s: REL24 %li out of range!\n",
+			       obj_name, (long int)value);
+			return -ENOEXEC;
+		}
+
+		/* Only replace bits 2 through 26 */
+		*(uint32_t *)location
+			= (*(uint32_t *)location & ~0x03fffffc)
+			| (value & 0x03fffffc);
+		break;
+
+	case R_PPC64_REL64:
+		/* 64 bits relative (used by features fixups) */
+		*location = value - (unsigned long)location;
+		break;
+
+	case R_PPC64_TOCSAVE:
+		/*
+		 * Marker reloc indicates we don't have to save r2.
+		 * That would only save us one instruction, so ignore
+		 * it.
+		 */
+		break;
+
+	case R_PPC64_ENTRY:
+		/*
+		 * Optimize ELFv2 large code model entry point if
+		 * the TOC is within 2GB range of current location.
+		 */
+		value = my_r2 - (unsigned long)location;
+		if (value + 0x80008000 > 0xffffffff)
+			break;
+		/*
+		 * Check for the large code model prolog sequence:
+		 *	ld r2, ...(r12)
+		 *	add r2, r2, r12
+		 */
+		if ((((uint32_t *)location)[0] & ~0xfffc)
+		    != 0xe84c0000)
+			break;
+		if (((uint32_t *)location)[1] != 0x7c426214)
+			break;
+		/*
+		 * If found, replace it with:
+		 *	addis r2, r12, (.TOC.-func)@ha
+		 *	addi r2, r12, (.TOC.-func)@l
+		 */
+		((uint32_t *)location)[0] = 0x3c4c0000 + PPC_HA(value);
+		((uint32_t *)location)[1] = 0x38420000 + PPC_LO(value);
+		break;
+
+	case R_PPC64_REL16_HA:
+		/* Subtract location pointer */
+		value -= (unsigned long)location;
+		value = ((value + 0x8000) >> 16);
+		*((uint16_t *) location)
+			= (*((uint16_t *) location) & ~0xffff)
+			| (value & 0xffff);
+		break;
+
+	case R_PPC64_REL16_LO:
+		/* Subtract location pointer */
+		value -= (unsigned long)location;
+		*((uint16_t *) location)
+			= (*((uint16_t *) location) & ~0xffff)
+			| (value & 0xffff);
+		break;
+
+	default:
+		pr_err("%s: Unknown ADD relocation: %lu\n", obj_name,
+		       (unsigned long)ELF64_R_TYPE(rela->r_info));
+		return -ENOEXEC;
+	}
+
+	return 0;
+}
+
 int apply_relocate_add(Elf64_Shdr *sechdrs,
 		       const char *strtab,
 		       unsigned int symindex,
@@ -514,6 +689,7 @@ int apply_relocate_add(Elf64_Shdr *sechd
 		       struct module *me)
 {
 	unsigned int i;
+	int ret;
 	Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
 	Elf64_Sym *sym;
 	unsigned long *location;
@@ -548,168 +724,12 @@ int apply_relocate_add(Elf64_Shdr *sechd
 		/* `Everything is relative'. */
 		value = sym->st_value + rela[i].r_addend;
 
-		switch (ELF64_R_TYPE(rela[i].r_info)) {
-		case R_PPC64_ADDR32:
-			/* Simply set it */
-			*(u32 *)location = value;
-			break;
-
-		case R_PPC64_ADDR64:
-			/* Simply set it */
-			*(unsigned long *)location = value;
-			break;
-
-		case R_PPC64_TOC:
-			*(unsigned long *)location = my_r2(sechdrs, me);
-			break;
-
-		case R_PPC64_TOC16:
-			/* Subtract TOC pointer */
-			value -= my_r2(sechdrs, me);
-			if (value + 0x8000 > 0xffff) {
-				pr_err("%s: bad TOC16 relocation (0x%lx)\n",
-				       me->name, value);
-				return -ENOEXEC;
-			}
-			*((uint16_t *) location)
-				= (*((uint16_t *) location) & ~0xffff)
-				| (value & 0xffff);
-			break;
-
-		case R_PPC64_TOC16_LO:
-			/* Subtract TOC pointer */
-			value -= my_r2(sechdrs, me);
-			*((uint16_t *) location)
-				= (*((uint16_t *) location) & ~0xffff)
-				| (value & 0xffff);
-			break;
-
-		case R_PPC64_TOC16_DS:
-			/* Subtract TOC pointer */
-			value -= my_r2(sechdrs, me);
-			if ((value & 3) != 0 || value + 0x8000 > 0xffff) {
-				pr_err("%s: bad TOC16_DS relocation (0x%lx)\n",
-				       me->name, value);
-				return -ENOEXEC;
-			}
-			*((uint16_t *) location)
-				= (*((uint16_t *) location) & ~0xfffc)
-				| (value & 0xfffc);
-			break;
-
-		case R_PPC64_TOC16_LO_DS:
-			/* Subtract TOC pointer */
-			value -= my_r2(sechdrs, me);
-			if ((value & 3) != 0) {
-				pr_err("%s: bad TOC16_LO_DS relocation (0x%lx)\n",
-				       me->name, value);
-				return -ENOEXEC;
-			}
-			*((uint16_t *) location)
-				= (*((uint16_t *) location) & ~0xfffc)
-				| (value & 0xfffc);
-			break;
-
-		case R_PPC64_TOC16_HA:
-			/* Subtract TOC pointer */
-			value -= my_r2(sechdrs, me);
-			value = ((value + 0x8000) >> 16);
-			*((uint16_t *) location)
-				= (*((uint16_t *) location) & ~0xffff)
-				| (value & 0xffff);
-			break;
-
-		case R_PPC_REL24:
-			/* FIXME: Handle weak symbols here --RR */
-			if (sym->st_shndx == SHN_UNDEF) {
-				/* External: go via stub */
-				value = stub_for_addr(sechdrs, value, me);
-				if (!value)
-					return -ENOENT;
-				if (!restore_r2((u32 *)location + 1, me))
-					return -ENOEXEC;
-
-				squash_toc_save_inst(strtab + sym->st_name, value);
-			} else
-				value += local_entry_offset(sym);
-
-			/* Convert value to relative */
-			value -= (unsigned long)location;
-			if (value + 0x2000000 > 0x3ffffff || (value & 3) != 0){
-				pr_err("%s: REL24 %li out of range!\n",
-				       me->name, (long int)value);
-				return -ENOEXEC;
-			}
-
-			/* Only replace bits 2 through 26 */
-			*(uint32_t *)location
-				= (*(uint32_t *)location & ~0x03fffffc)
-				| (value & 0x03fffffc);
-			break;
-
-		case R_PPC64_REL64:
-			/* 64 bits relative (used by features fixups) */
-			*location = value - (unsigned long)location;
-			break;
-
-		case R_PPC64_TOCSAVE:
-			/*
-			 * Marker reloc indicates we don't have to save r2.
-			 * That would only save us one instruction, so ignore
-			 * it.
-			 */
-			break;
-
-		case R_PPC64_ENTRY:
-			/*
-			 * Optimize ELFv2 large code model entry point if
-			 * the TOC is within 2GB range of current location.
-			 */
-			value = my_r2(sechdrs, me) - (unsigned long)location;
-			if (value + 0x80008000 > 0xffffffff)
-				break;
-			/*
-			 * Check for the large code model prolog sequence:
-		         *	ld r2, ...(r12)
-			 *	add r2, r2, r12
-			 */
-			if ((((uint32_t *)location)[0] & ~0xfffc)
-			    != 0xe84c0000)
-				break;
-			if (((uint32_t *)location)[1] != 0x7c426214)
-				break;
-			/*
-			 * If found, replace it with:
-			 *	addis r2, r12, (.TOC.-func)@ha
-			 *	addi r2, r12, (.TOC.-func)@l
-			 */
-			((uint32_t *)location)[0] = 0x3c4c0000 + PPC_HA(value);
-			((uint32_t *)location)[1] = 0x38420000 + PPC_LO(value);
-			break;
-
-		case R_PPC64_REL16_HA:
-			/* Subtract location pointer */
-			value -= (unsigned long)location;
-			value = ((value + 0x8000) >> 16);
-			*((uint16_t *) location)
-				= (*((uint16_t *) location) & ~0xffff)
-				| (value & 0xffff);
-			break;
-
-		case R_PPC64_REL16_LO:
-			/* Subtract location pointer */
-			value -= (unsigned long)location;
-			*((uint16_t *) location)
-				= (*((uint16_t *) location) & ~0xffff)
-				| (value & 0xffff);
-			break;
-
-		default:
-			pr_err("%s: Unknown ADD relocation: %lu\n",
-			       me->name,
-			       (unsigned long)ELF64_R_TYPE(rela[i].r_info));
-			return -ENOEXEC;
-		}
+		ret = elf64_apply_relocate_add_item(sechdrs, strtab, &rela[i],
+						    sym, location, value,
+						    my_r2(sechdrs, me),
+						    me->name, me);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-change-places-using-config_kexec-to-use-config_kexec_core-instead.patch
powerpc-factor-out-relocation-code-in-module_64c.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

