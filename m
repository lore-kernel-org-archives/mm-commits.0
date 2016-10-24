From: akpm@linux-foundation.org
Subject: + powerpc-add-functions-to-read-elf-files-of-any-endianness.patch added to -mm tree
Date: Mon, 24 Oct 2016 12:42:41 -0700
Message-ID: <580e6431.ME8yaHkHFszFKoue%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940767AbcJXTmm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 15:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, sklar@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add functions to read ELF files of any endianness
has been added to the -mm tree.  Its filename is
     powerpc-add-functions-to-read-elf-files-of-any-endianness.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-functions-to-read-elf-files-of-any-endianness.patch

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
Subject: powerpc: add functions to read ELF files of any endianness

A little endian kernel might need to kexec a big endian kernel (the
opposite is less likely but could happen as well), so we can't just cast
the buffer with the binary to ELF structs and use them as is done
elsewhere.

This patch adds functions which do byte-swapping as necessary when
populating the ELF structs.  These functions will be used in the next
patch in the series.

Link: http://lkml.kernel.org/r/1477017617-8540-8-git-send-email-bauerman@linux.vnet.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andreas Steffen <andreas.steffen@strongswan.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/elf_util.h |   21 +
 arch/powerpc/kernel/elf_util.c      |  418 ++++++++++++++++++++++++++
 2 files changed, 439 insertions(+)

diff -puN arch/powerpc/include/asm/elf_util.h~powerpc-add-functions-to-read-elf-files-of-any-endianness arch/powerpc/include/asm/elf_util.h
--- a/arch/powerpc/include/asm/elf_util.h~powerpc-add-functions-to-read-elf-files-of-any-endianness
+++ a/arch/powerpc/include/asm/elf_util.h
@@ -19,6 +19,18 @@
 
 #include <linux/elf.h>
 
+struct elf_info {
+	/*
+	 * Where the ELF binary contents are kept.
+	 * Memory managed by the user of the struct.
+	 */
+	const char *buffer;
+
+	const struct elfhdr *ehdr;
+	const struct elf_phdr *proghdrs;
+	struct elf_shdr *sechdrs;
+};
+
 /*
  * r2 is the TOC pointer: it actually points 0x8000 into the TOC (this
  * gives the value maximum span in an instruction which uses a signed
@@ -40,4 +52,13 @@ int elf64_apply_relocate_add_item(const
 				  unsigned long my_r2, const char *obj_name,
 				  struct module *me);
 
+static inline bool elf_is_elf_file(const struct elfhdr *ehdr)
+{
+	return memcmp(ehdr->e_ident, ELFMAG, SELFMAG) == 0;
+}
+
+int elf_read_from_buffer(const char *buf, size_t len, struct elfhdr *ehdr,
+			 struct elf_info *elf_info);
+void elf_free_info(struct elf_info *elf_info);
+
 #endif /* _ASM_POWERPC_ELF_UTIL_H */
diff -puN arch/powerpc/kernel/elf_util.c~powerpc-add-functions-to-read-elf-files-of-any-endianness arch/powerpc/kernel/elf_util.c
--- a/arch/powerpc/kernel/elf_util.c~powerpc-add-functions-to-read-elf-files-of-any-endianness
+++ a/arch/powerpc/kernel/elf_util.c
@@ -16,7 +16,24 @@
  * GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/slab.h>
 #include <asm/elf_util.h>
+#include <asm-generic/module.h>
+
+#if ELF_CLASS == ELFCLASS32
+#define elf_addr_to_cpu	elf32_to_cpu
+
+#ifndef Elf_Rel
+#define Elf_Rel		Elf32_Rel
+#endif /* Elf_Rel */
+#else /* ELF_CLASS == ELFCLASS32 */
+#define elf_addr_to_cpu	elf64_to_cpu
+
+#ifndef Elf_Rel
+#define Elf_Rel		Elf64_Rel
+#endif /* Elf_Rel */
 
 /**
  * elf_toc_section - find the toc section in the file with the given ELF headers
@@ -44,3 +61,404 @@ unsigned int elf_toc_section(const struc
 
 	return 0;
 }
+
+static uint64_t elf64_to_cpu(const struct elfhdr *ehdr, uint64_t value)
+{
+	if (ehdr->e_ident[EI_DATA] == ELFDATA2LSB)
+		value = le64_to_cpu(value);
+	else if (ehdr->e_ident[EI_DATA] == ELFDATA2MSB)
+		value = be64_to_cpu(value);
+
+	return value;
+}
+#endif /* ELF_CLASS == ELFCLASS32 */
+
+static uint16_t elf16_to_cpu(const struct elfhdr *ehdr, uint16_t value)
+{
+	if (ehdr->e_ident[EI_DATA] == ELFDATA2LSB)
+		value = le16_to_cpu(value);
+	else if (ehdr->e_ident[EI_DATA] == ELFDATA2MSB)
+		value = be16_to_cpu(value);
+
+	return value;
+}
+
+static uint32_t elf32_to_cpu(const struct elfhdr *ehdr, uint32_t value)
+{
+	if (ehdr->e_ident[EI_DATA] == ELFDATA2LSB)
+		value = le32_to_cpu(value);
+	else if (ehdr->e_ident[EI_DATA] == ELFDATA2MSB)
+		value = be32_to_cpu(value);
+
+	return value;
+}
+
+/**
+ * elf_is_ehdr_sane - check that it is safe to use the ELF header
+ * @buf_len:	size of the buffer in which the ELF file is loaded.
+ */
+static bool elf_is_ehdr_sane(const struct elfhdr *ehdr, size_t buf_len)
+{
+	if (ehdr->e_phnum > 0 && ehdr->e_phentsize != sizeof(struct elf_phdr)) {
+		pr_debug("Bad program header size.\n");
+		return false;
+	} else if (ehdr->e_shnum > 0 &&
+		   ehdr->e_shentsize != sizeof(struct elf_shdr)) {
+		pr_debug("Bad section header size.\n");
+		return false;
+	} else if (ehdr->e_ident[EI_VERSION] != EV_CURRENT ||
+		   ehdr->e_version != EV_CURRENT) {
+		pr_debug("Unknown ELF version.\n");
+		return false;
+	}
+
+	if (ehdr->e_phoff > 0 && ehdr->e_phnum > 0) {
+		size_t phdr_size;
+
+		/*
+		 * e_phnum is at most 65535 so calculating the size of the
+		 * program header cannot overflow.
+		 */
+		phdr_size = sizeof(struct elf_phdr) * ehdr->e_phnum;
+
+		/* Sanity check the program header table location. */
+		if (ehdr->e_phoff + phdr_size < ehdr->e_phoff) {
+			pr_debug("Program headers at invalid location.\n");
+			return false;
+		} else if (ehdr->e_phoff + phdr_size > buf_len) {
+			pr_debug("Program headers truncated.\n");
+			return false;
+		}
+	}
+
+	if (ehdr->e_shoff > 0 && ehdr->e_shnum > 0) {
+		size_t shdr_size;
+
+		/*
+		 * e_shnum is at most 65536 so calculating
+		 * the size of the section header cannot overflow.
+		 */
+		shdr_size = sizeof(struct elf_shdr) * ehdr->e_shnum;
+
+		/* Sanity check the section header table location. */
+		if (ehdr->e_shoff + shdr_size < ehdr->e_shoff) {
+			pr_debug("Section headers at invalid location.\n");
+			return false;
+		} else if (ehdr->e_shoff + shdr_size > buf_len) {
+			pr_debug("Section headers truncated.\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static int elf_read_ehdr(const char *buf, size_t len, struct elfhdr *ehdr)
+{
+	struct elfhdr *buf_ehdr;
+
+	if (len < sizeof(*buf_ehdr)) {
+		pr_debug("Buffer is too small to hold ELF header.\n");
+		return -ENOEXEC;
+	}
+
+	memset(ehdr, 0, sizeof(*ehdr));
+	memcpy(ehdr->e_ident, buf, sizeof(ehdr->e_ident));
+	if (!elf_is_elf_file(ehdr)) {
+		pr_debug("No ELF header magic.\n");
+		return -ENOEXEC;
+	}
+
+	if (ehdr->e_ident[EI_CLASS] != ELF_CLASS) {
+		pr_debug("Not a supported ELF class.\n");
+		return -1;
+	} else  if (ehdr->e_ident[EI_DATA] != ELFDATA2LSB &&
+		ehdr->e_ident[EI_DATA] != ELFDATA2MSB) {
+		pr_debug("Not a supported ELF data format.\n");
+		return -ENOEXEC;
+	}
+
+	buf_ehdr = (struct elfhdr *) buf;
+	if (elf16_to_cpu(ehdr, buf_ehdr->e_ehsize) != sizeof(*buf_ehdr)) {
+		pr_debug("Bad ELF header size.\n");
+		return -ENOEXEC;
+	}
+
+	ehdr->e_type      = elf16_to_cpu(ehdr, buf_ehdr->e_type);
+	ehdr->e_machine   = elf16_to_cpu(ehdr, buf_ehdr->e_machine);
+	ehdr->e_version   = elf32_to_cpu(ehdr, buf_ehdr->e_version);
+	ehdr->e_entry     = elf_addr_to_cpu(ehdr, buf_ehdr->e_entry);
+	ehdr->e_phoff     = elf_addr_to_cpu(ehdr, buf_ehdr->e_phoff);
+	ehdr->e_shoff     = elf_addr_to_cpu(ehdr, buf_ehdr->e_shoff);
+	ehdr->e_flags     = elf32_to_cpu(ehdr, buf_ehdr->e_flags);
+	ehdr->e_phentsize = elf16_to_cpu(ehdr, buf_ehdr->e_phentsize);
+	ehdr->e_phnum     = elf16_to_cpu(ehdr, buf_ehdr->e_phnum);
+	ehdr->e_shentsize = elf16_to_cpu(ehdr, buf_ehdr->e_shentsize);
+	ehdr->e_shnum     = elf16_to_cpu(ehdr, buf_ehdr->e_shnum);
+	ehdr->e_shstrndx  = elf16_to_cpu(ehdr, buf_ehdr->e_shstrndx);
+
+	return elf_is_ehdr_sane(ehdr, len) ? 0 : -ENOEXEC;
+}
+
+/**
+ * elf_is_phdr_sane - check that it is safe to use the program header
+ * @buf_len:	size of the buffer in which the ELF file is loaded.
+ */
+static bool elf_is_phdr_sane(const struct elf_phdr *phdr, size_t buf_len)
+{
+
+	if (phdr->p_offset + phdr->p_filesz < phdr->p_offset) {
+		pr_debug("ELF segment location wraps around.\n");
+		return false;
+	} else if (phdr->p_offset + phdr->p_filesz > buf_len) {
+		pr_debug("ELF segment not in file.\n");
+		return false;
+	} else if (phdr->p_paddr + phdr->p_memsz < phdr->p_paddr) {
+		pr_debug("ELF segment address wraps around.\n");
+		return false;
+	}
+
+	return true;
+}
+
+static int elf_read_phdr(const char *buf, size_t len, struct elf_info *elf_info,
+			 int idx)
+{
+	/* Override the const in proghdrs, we are the ones doing the loading. */
+	struct elf_phdr *phdr = (struct elf_phdr *) &elf_info->proghdrs[idx];
+	const char *pbuf;
+	struct elf_phdr *buf_phdr;
+
+	pbuf = buf + elf_info->ehdr->e_phoff + (idx * sizeof(*buf_phdr));
+	buf_phdr = (struct elf_phdr *) pbuf;
+
+	phdr->p_type   = elf32_to_cpu(elf_info->ehdr, buf_phdr->p_type);
+	phdr->p_offset = elf_addr_to_cpu(elf_info->ehdr, buf_phdr->p_offset);
+	phdr->p_paddr  = elf_addr_to_cpu(elf_info->ehdr, buf_phdr->p_paddr);
+	phdr->p_vaddr  = elf_addr_to_cpu(elf_info->ehdr, buf_phdr->p_vaddr);
+	phdr->p_flags  = elf32_to_cpu(elf_info->ehdr, buf_phdr->p_flags);
+
+	/*
+	 * The following fields have a type equivalent to Elf_Addr
+	 * both in 32 bit and 64 bit ELF.
+	 */
+	phdr->p_filesz = elf_addr_to_cpu(elf_info->ehdr, buf_phdr->p_filesz);
+	phdr->p_memsz  = elf_addr_to_cpu(elf_info->ehdr, buf_phdr->p_memsz);
+	phdr->p_align  = elf_addr_to_cpu(elf_info->ehdr, buf_phdr->p_align);
+
+	return elf_is_phdr_sane(phdr, len) ? 0 : -ENOEXEC;
+}
+
+/**
+ * elf_read_phdrs - read the program headers from the buffer
+ *
+ * This function assumes that the program header table was checked for sanity.
+ * Use elf_is_ehdr_sane() if it wasn't.
+ */
+static int elf_read_phdrs(const char *buf, size_t len,
+			  struct elf_info *elf_info)
+{
+	size_t phdr_size, i;
+	const struct elfhdr *ehdr = elf_info->ehdr;
+
+	/*
+	 * e_phnum is at most 65535 so calculating the size of the
+	 * program header cannot overflow.
+	 */
+	phdr_size = sizeof(struct elf_phdr) * ehdr->e_phnum;
+
+	elf_info->proghdrs = kzalloc(phdr_size, GFP_KERNEL);
+	if (!elf_info->proghdrs)
+		return -ENOMEM;
+
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		int ret;
+
+		ret = elf_read_phdr(buf, len, elf_info, i);
+		if (ret) {
+			kfree(elf_info->proghdrs);
+			elf_info->proghdrs = NULL;
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * elf_is_shdr_sane - check that it is safe to use the section header
+ * @buf_len:	size of the buffer in which the ELF file is loaded.
+ */
+static bool elf_is_shdr_sane(const struct elf_shdr *shdr, size_t buf_len)
+{
+	bool size_ok;
+
+	/* SHT_NULL headers have undefined values, so we can't check them. */
+	if (shdr->sh_type == SHT_NULL)
+		return true;
+
+	/* Now verify sh_entsize */
+	switch (shdr->sh_type) {
+	case SHT_SYMTAB:
+		size_ok = shdr->sh_entsize == sizeof(Elf_Sym);
+		break;
+	case SHT_RELA:
+		size_ok = shdr->sh_entsize == sizeof(Elf_Rela);
+		break;
+	case SHT_DYNAMIC:
+		size_ok = shdr->sh_entsize == sizeof(Elf_Dyn);
+		break;
+	case SHT_REL:
+		size_ok = shdr->sh_entsize == sizeof(Elf_Rel);
+		break;
+	case SHT_NOTE:
+	case SHT_PROGBITS:
+	case SHT_HASH:
+	case SHT_NOBITS:
+	default:
+		/*
+		 * This is a section whose entsize requirements
+		 * I don't care about.  If I don't know about
+		 * the section I can't care about it's entsize
+		 * requirements.
+		 */
+		size_ok = true;
+		break;
+	}
+
+	if (!size_ok) {
+		pr_debug("ELF section with wrong entry size.\n");
+		return false;
+	} else if (shdr->sh_addr + shdr->sh_size < shdr->sh_addr) {
+		pr_debug("ELF section address wraps around.\n");
+		return false;
+	}
+
+	if (shdr->sh_type != SHT_NOBITS) {
+		if (shdr->sh_offset + shdr->sh_size < shdr->sh_offset) {
+			pr_debug("ELF section location wraps around.\n");
+			return false;
+		} else if (shdr->sh_offset + shdr->sh_size > buf_len) {
+			pr_debug("ELF section not in file.\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static int elf_read_shdr(const char *buf, size_t len, struct elf_info *elf_info,
+			 int idx)
+{
+	struct elf_shdr *shdr = &elf_info->sechdrs[idx];
+	const struct elfhdr *ehdr = elf_info->ehdr;
+	const char *sbuf;
+	struct elf_shdr *buf_shdr;
+
+	sbuf = buf + ehdr->e_shoff + idx * sizeof(*buf_shdr);
+	buf_shdr = (struct elf_shdr *) sbuf;
+
+	shdr->sh_name      = elf32_to_cpu(ehdr, buf_shdr->sh_name);
+	shdr->sh_type      = elf32_to_cpu(ehdr, buf_shdr->sh_type);
+	shdr->sh_addr      = elf_addr_to_cpu(ehdr, buf_shdr->sh_addr);
+	shdr->sh_offset    = elf_addr_to_cpu(ehdr, buf_shdr->sh_offset);
+	shdr->sh_link      = elf32_to_cpu(ehdr, buf_shdr->sh_link);
+	shdr->sh_info      = elf32_to_cpu(ehdr, buf_shdr->sh_info);
+
+	/*
+	 * The following fields have a type equivalent to Elf_Addr
+	 * both in 32 bit and 64 bit ELF.
+	 */
+	shdr->sh_flags     = elf_addr_to_cpu(ehdr, buf_shdr->sh_flags);
+	shdr->sh_size      = elf_addr_to_cpu(ehdr, buf_shdr->sh_size);
+	shdr->sh_addralign = elf_addr_to_cpu(ehdr, buf_shdr->sh_addralign);
+	shdr->sh_entsize   = elf_addr_to_cpu(ehdr, buf_shdr->sh_entsize);
+
+	return elf_is_shdr_sane(shdr, len) ? 0 : -ENOEXEC;
+}
+
+/**
+ * elf_read_shdrs - read the section headers from the buffer
+ *
+ * This function assumes that the section header table was checked for sanity.
+ * Use elf_is_ehdr_sane() if it wasn't.
+ */
+static int elf_read_shdrs(const char *buf, size_t len,
+			  struct elf_info *elf_info)
+{
+	size_t shdr_size, i;
+
+	/*
+	 * e_shnum is at most 65536 so calculating
+	 * the size of the section header cannot overflow.
+	 */
+	shdr_size = sizeof(struct elf_shdr) * elf_info->ehdr->e_shnum;
+
+	elf_info->sechdrs = kzalloc(shdr_size, GFP_KERNEL);
+	if (!elf_info->sechdrs)
+		return -ENOMEM;
+
+	for (i = 0; i < elf_info->ehdr->e_shnum; i++) {
+		int ret;
+
+		ret = elf_read_shdr(buf, len, elf_info, i);
+		if (ret) {
+			kfree(elf_info->sechdrs);
+			elf_info->sechdrs = NULL;
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * elf_read_from_buffer - read ELF file and sets up ELF header and ELF info
+ * @buf:	Buffer to read ELF file from.
+ * @len:	Size of @buf.
+ * @ehdr:	Pointer to existing struct which will be populated.
+ * @elf_info:	Pointer to existing struct which will be populated.
+ *
+ * This function allows reading ELF files with different byte order than
+ * the kernel, byte-swapping the fields as needed.
+ *
+ * Return:
+ * On success returns 0, and the caller should call elf_free_info(elf_info) to
+ * free the memory allocated for the section and program headers.
+ */
+int elf_read_from_buffer(const char *buf, size_t len, struct elfhdr *ehdr,
+			 struct elf_info *elf_info)
+{
+	int ret;
+
+	ret = elf_read_ehdr(buf, len, ehdr);
+	if (ret)
+		return ret;
+
+	elf_info->buffer = buf;
+	elf_info->ehdr = ehdr;
+	if (ehdr->e_phoff > 0 && ehdr->e_phnum > 0) {
+		ret = elf_read_phdrs(buf, len, elf_info);
+		if (ret)
+			return ret;
+	}
+	if (ehdr->e_shoff > 0 && ehdr->e_shnum > 0) {
+		ret = elf_read_shdrs(buf, len, elf_info);
+		if (ret) {
+			kfree(elf_info->proghdrs);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * elf_free_info - free memory allocated by elf_read_from_buffer
+ */
+void elf_free_info(struct elf_info *elf_info)
+{
+	kfree(elf_info->proghdrs);
+	kfree(elf_info->sechdrs);
+	memset(elf_info, 0, sizeof(*elf_info));
+}
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

