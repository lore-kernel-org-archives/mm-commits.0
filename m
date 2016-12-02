From: akpm@linux-foundation.org
Subject: [merged] powerpc-add-support-code-for-kexec_file_load.patch
 removed from -mm tree
Date: Fri, 02 Dec 2016 15:45:41 -0800
Message-ID: <584207a5.tvlOXShDc19GQ7zk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755591AbcLBXpd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 18:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sfr@canb.auug.org.au, sklar@linux.vnet.ibm.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add support code for kexec_file_load()
has been removed from the -mm tree.  Its filename was
     powerpc-add-support-code-for-kexec_file_load.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc: add support code for kexec_file_load()

This patch adds the support code needed for implementing
kexec_file_load() on powerpc.

This consists of functions to load the ELF kernel, either big or little
endian, and setup the purgatory enviroment which switches from the first
kernel to the second kernel.

None of this code is built yet, as it depends on CONFIG_KEXEC_FILE which
we have not yet defined.  Although we could define CONFIG_KEXEC_FILE in
this patch, we'd then have a window in history where the kconfig symbol is
present but the syscall is not, which would be awkward.

Link: http://lkml.kernel.org/r/1480423554-6411-6-git-send-email-mpe@ellerman.id.au
Signed-off-by: Josh Sklar <sklar@linux.vnet.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/kexec.h            |   10 
 arch/powerpc/kernel/Makefile                |    1 
 arch/powerpc/kernel/kexec_elf_64.c          |  663 ++++++++++++++++++
 arch/powerpc/kernel/machine_kexec_file_64.c |  338 +++++++++
 4 files changed, 1012 insertions(+)

diff -puN arch/powerpc/include/asm/kexec.h~powerpc-add-support-code-for-kexec_file_load arch/powerpc/include/asm/kexec.h
--- a/arch/powerpc/include/asm/kexec.h~powerpc-add-support-code-for-kexec_file_load
+++ a/arch/powerpc/include/asm/kexec.h
@@ -91,6 +91,16 @@ static inline bool kdump_in_progress(voi
 	return crashing_cpu >= 0;
 }
 
+#ifdef CONFIG_KEXEC_FILE
+extern struct kexec_file_ops kexec_elf64_ops;
+
+int setup_purgatory(struct kimage *image, const void *slave_code,
+		    const void *fdt, unsigned long kernel_load_addr,
+		    unsigned long fdt_load_addr);
+int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
+		  unsigned long initrd_len, const char *cmdline);
+#endif /* CONFIG_KEXEC_FILE */
+
 #else /* !CONFIG_KEXEC_CORE */
 static inline void crash_kexec_secondary(struct pt_regs *regs) { }
 
diff -puN arch/powerpc/kernel/Makefile~powerpc-add-support-code-for-kexec_file_load arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-add-support-code-for-kexec_file_load
+++ a/arch/powerpc/kernel/Makefile
@@ -111,6 +111,7 @@ obj-$(CONFIG_PCI)		+= pci_$(BITS).o $(pc
 obj-$(CONFIG_PCI_MSI)		+= msi.o
 obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o crash.o \
 				   machine_kexec_$(BITS).o
+obj-$(CONFIG_KEXEC_FILE)	+= machine_kexec_file_$(BITS).o kexec_elf_$(BITS).o
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
diff -puN /dev/null arch/powerpc/kernel/kexec_elf_64.c
--- /dev/null
+++ a/arch/powerpc/kernel/kexec_elf_64.c
@@ -0,0 +1,663 @@
+/*
+ * Load ELF vmlinux file for the kexec_file_load syscall.
+ *
+ * Copyright (C) 2004  Adam Litke (agl@us.ibm.com)
+ * Copyright (C) 2004  IBM Corp.
+ * Copyright (C) 2005  R Sharada (sharada@in.ibm.com)
+ * Copyright (C) 2006  Mohan Kumar M (mohan@in.ibm.com)
+ * Copyright (C) 2016  IBM Corporation
+ *
+ * Based on kexec-tools' kexec-elf-exec.c and kexec-elf-ppc64.c.
+ * Heavily modified for the kernel by
+ * Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt)	"kexec_elf: " fmt
+
+#include <linux/elf.h>
+#include <linux/kexec.h>
+#include <linux/libfdt.h>
+#include <linux/module.h>
+#include <linux/of_fdt.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#define PURGATORY_STACK_SIZE	(16 * 1024)
+
+#define elf_addr_to_cpu	elf64_to_cpu
+
+#ifndef Elf_Rel
+#define Elf_Rel		Elf64_Rel
+#endif /* Elf_Rel */
+
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
+static inline bool elf_is_elf_file(const struct elfhdr *ehdr)
+{
+       return memcmp(ehdr->e_ident, ELFMAG, SELFMAG) == 0;
+}
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
+		return -ENOEXEC;
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
+/**
+ * build_elf_exec_info - read ELF executable and check that we can use it
+ */
+static int build_elf_exec_info(const char *buf, size_t len, struct elfhdr *ehdr,
+			       struct elf_info *elf_info)
+{
+	int i;
+	int ret;
+
+	ret = elf_read_from_buffer(buf, len, ehdr, elf_info);
+	if (ret)
+		return ret;
+
+	/* Big endian vmlinux has type ET_DYN. */
+	if (ehdr->e_type != ET_EXEC && ehdr->e_type != ET_DYN) {
+		pr_err("Not an ELF executable.\n");
+		goto error;
+	} else if (!elf_info->proghdrs) {
+		pr_err("No ELF program header.\n");
+		goto error;
+	}
+
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		/*
+		 * Kexec does not support loading interpreters.
+		 * In addition this check keeps us from attempting
+		 * to kexec ordinay executables.
+		 */
+		if (elf_info->proghdrs[i].p_type == PT_INTERP) {
+			pr_err("Requires an ELF interpreter.\n");
+			goto error;
+		}
+	}
+
+	return 0;
+error:
+	elf_free_info(elf_info);
+	return -ENOEXEC;
+}
+
+static int elf64_probe(const char *buf, unsigned long len)
+{
+	struct elfhdr ehdr;
+	struct elf_info elf_info;
+	int ret;
+
+	ret = build_elf_exec_info(buf, len, &ehdr, &elf_info);
+	if (ret)
+		return ret;
+
+	elf_free_info(&elf_info);
+
+	return elf_check_arch(&ehdr) ? 0 : -ENOEXEC;
+}
+
+/**
+ * elf_exec_load - load ELF executable image
+ * @lowest_load_addr:	On return, will be the address where the first PT_LOAD
+ *			section will be loaded in memory.
+ *
+ * Return:
+ * 0 on success, negative value on failure.
+ */
+static int elf_exec_load(struct kimage *image, struct elfhdr *ehdr,
+			 struct elf_info *elf_info,
+			 unsigned long *lowest_load_addr)
+{
+	unsigned long base = 0, lowest_addr = UINT_MAX;
+	int ret;
+	size_t i;
+	struct kexec_buf kbuf = { .image = image, .buf_max = ppc64_rma_size,
+				  .top_down = false };
+
+	/* Read in the PT_LOAD segments. */
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		unsigned long load_addr;
+		size_t size;
+		const struct elf_phdr *phdr;
+
+		phdr = &elf_info->proghdrs[i];
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		size = phdr->p_filesz;
+		if (size > phdr->p_memsz)
+			size = phdr->p_memsz;
+
+		kbuf.buffer = (void *) elf_info->buffer + phdr->p_offset;
+		kbuf.bufsz = size;
+		kbuf.memsz = phdr->p_memsz;
+		kbuf.buf_align = phdr->p_align;
+		kbuf.buf_min = phdr->p_paddr + base;
+		ret = kexec_add_buffer(&kbuf);
+		if (ret)
+			goto out;
+		load_addr = kbuf.mem;
+
+		if (load_addr < lowest_addr)
+			lowest_addr = load_addr;
+	}
+
+	/* Update entry point to reflect new load address. */
+	ehdr->e_entry += base;
+
+	*lowest_load_addr = lowest_addr;
+	ret = 0;
+ out:
+	return ret;
+}
+
+static void *elf64_load(struct kimage *image, char *kernel_buf,
+			unsigned long kernel_len, char *initrd,
+			unsigned long initrd_len, char *cmdline,
+			unsigned long cmdline_len)
+{
+	int ret;
+	unsigned int fdt_size;
+	unsigned long kernel_load_addr, purgatory_load_addr;
+	unsigned long initrd_load_addr = 0, fdt_load_addr;
+	void *fdt;
+	const void *slave_code;
+	struct elfhdr ehdr;
+	struct elf_info elf_info;
+	struct kexec_buf kbuf = { .image = image, .buf_min = 0,
+				  .buf_max = ppc64_rma_size };
+
+	ret = build_elf_exec_info(kernel_buf, kernel_len, &ehdr, &elf_info);
+	if (ret)
+		goto out;
+
+	ret = elf_exec_load(image, &ehdr, &elf_info, &kernel_load_addr);
+	if (ret)
+		goto out;
+
+	pr_debug("Loaded the kernel at 0x%lx\n", kernel_load_addr);
+
+	ret = kexec_load_purgatory(image, 0, ppc64_rma_size, true,
+				   &purgatory_load_addr);
+	if (ret) {
+		pr_err("Loading purgatory failed.\n");
+		goto out;
+	}
+
+	pr_debug("Loaded purgatory at 0x%lx\n", purgatory_load_addr);
+
+	if (initrd != NULL) {
+		kbuf.buffer = initrd;
+		kbuf.bufsz = kbuf.memsz = initrd_len;
+		kbuf.buf_align = PAGE_SIZE;
+		kbuf.top_down = false;
+		ret = kexec_add_buffer(&kbuf);
+		if (ret)
+			goto out;
+		initrd_load_addr = kbuf.mem;
+
+		pr_debug("Loaded initrd at 0x%lx\n", initrd_load_addr);
+	}
+
+	fdt_size = fdt_totalsize(initial_boot_params) * 2;
+	fdt = kmalloc(fdt_size, GFP_KERNEL);
+	if (!fdt) {
+		pr_err("Not enough memory for the device tree.\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	ret = fdt_open_into(initial_boot_params, fdt, fdt_size);
+	if (ret < 0) {
+		pr_err("Error setting up the new device tree.\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = setup_new_fdt(fdt, initrd_load_addr, initrd_len, cmdline);
+	if (ret)
+		goto out;
+
+	fdt_pack(fdt);
+
+	kbuf.buffer = fdt;
+	kbuf.bufsz = kbuf.memsz = fdt_size;
+	kbuf.buf_align = PAGE_SIZE;
+	kbuf.top_down = true;
+	ret = kexec_add_buffer(&kbuf);
+	if (ret)
+		goto out;
+	fdt_load_addr = kbuf.mem;
+
+	pr_debug("Loaded device tree at 0x%lx\n", fdt_load_addr);
+
+	slave_code = elf_info.buffer + elf_info.proghdrs[0].p_offset;
+	ret = setup_purgatory(image, slave_code, fdt, kernel_load_addr,
+			      fdt_load_addr);
+	if (ret)
+		pr_err("Error setting up the purgatory.\n");
+
+out:
+	elf_free_info(&elf_info);
+
+	/* Make kimage_file_post_load_cleanup free the fdt buffer for us. */
+	return ret ? ERR_PTR(ret) : fdt;
+}
+
+struct kexec_file_ops kexec_elf64_ops = {
+	.probe = elf64_probe,
+	.load = elf64_load,
+};
diff -puN /dev/null arch/powerpc/kernel/machine_kexec_file_64.c
--- /dev/null
+++ a/arch/powerpc/kernel/machine_kexec_file_64.c
@@ -0,0 +1,338 @@
+/*
+ * ppc64 code to implement the kexec_file_load syscall
+ *
+ * Copyright (C) 2004  Adam Litke (agl@us.ibm.com)
+ * Copyright (C) 2004  IBM Corp.
+ * Copyright (C) 2004,2005  Milton D Miller II, IBM Corporation
+ * Copyright (C) 2005  R Sharada (sharada@in.ibm.com)
+ * Copyright (C) 2006  Mohan Kumar M (mohan@in.ibm.com)
+ * Copyright (C) 2016  IBM Corporation
+ *
+ * Based on kexec-tools' kexec-elf-ppc64.c, fs2dt.c.
+ * Heavily modified for the kernel by
+ * Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation (version 2 of the License).
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/slab.h>
+#include <linux/kexec.h>
+#include <linux/memblock.h>
+#include <linux/of_fdt.h>
+#include <linux/libfdt.h>
+
+#define SLAVE_CODE_SIZE		256
+
+static struct kexec_file_ops *kexec_file_loaders[] = {
+	&kexec_elf64_ops,
+};
+
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
+ * arch_kexec_walk_mem - call func(data) for each unreserved memory block
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
+ * setup_purgatory - initialize the purgatory's global variables
+ * @image:		kexec image.
+ * @slave_code:		Slave code for the purgatory.
+ * @fdt:		Flattened device tree for the next kernel.
+ * @kernel_load_addr:	Address where the kernel is loaded.
+ * @fdt_load_addr:	Address where the flattened device tree is loaded.
+ *
+ * Return: 0 on success, or negative errno on error.
+ */
+int setup_purgatory(struct kimage *image, const void *slave_code,
+		    const void *fdt, unsigned long kernel_load_addr,
+		    unsigned long fdt_load_addr)
+{
+	unsigned int *slave_code_buf, master_entry;
+	int ret;
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
+	return 0;
+}
+
+/**
+ * delete_fdt_mem_rsv - delete memory reservation with given address and size
+ *
+ * Return: 0 on success, or negative errno on error.
+ */
+static int delete_fdt_mem_rsv(void *fdt, unsigned long start, unsigned long size)
+{
+	int i, ret, num_rsvs = fdt_num_mem_rsv(fdt);
+
+	for (i = 0; i < num_rsvs; i++) {
+		uint64_t rsv_start, rsv_size;
+
+		ret = fdt_get_mem_rsv(fdt, i, &rsv_start, &rsv_size);
+		if (ret) {
+			pr_err("Malformed device tree.\n");
+			return -EINVAL;
+		}
+
+		if (rsv_start == start && rsv_size == size) {
+			ret = fdt_del_mem_rsv(fdt, i);
+			if (ret) {
+				pr_err("Error deleting device tree reservation.\n");
+				return -EINVAL;
+			}
+
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+/*
+ * setup_new_fdt - modify /chosen and memory reservation for the next kernel
+ * @fdt:		Flattened device tree for the next kernel.
+ * @initrd_load_addr:	Address where the next initrd will be loaded.
+ * @initrd_len:		Size of the next initrd, or 0 if there will be none.
+ * @cmdline:		Command line for the next kernel, or NULL if there will
+ *			be none.
+ *
+ * Return: 0 on success, or negative errno on error.
+ */
+int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
+		  unsigned long initrd_len, const char *cmdline)
+{
+	int ret, chosen_node;
+	const void *prop;
+
+	/* Remove memory reservation for the current device tree. */
+	ret = delete_fdt_mem_rsv(fdt, __pa(initial_boot_params),
+				 fdt_totalsize(initial_boot_params));
+	if (ret == 0)
+		pr_debug("Removed old device tree reservation.\n");
+	else if (ret != -ENOENT)
+		return ret;
+
+	chosen_node = fdt_path_offset(fdt, "/chosen");
+	if (chosen_node == -FDT_ERR_NOTFOUND) {
+		chosen_node = fdt_add_subnode(fdt, fdt_path_offset(fdt, "/"),
+					      "chosen");
+		if (chosen_node < 0) {
+			pr_err("Error creating /chosen.\n");
+			return -EINVAL;
+		}
+	} else if (chosen_node < 0) {
+		pr_err("Malformed device tree: error reading /chosen.\n");
+		return -EINVAL;
+	}
+
+	/* Did we boot using an initrd? */
+	prop = fdt_getprop(fdt, chosen_node, "linux,initrd-start", NULL);
+	if (prop) {
+		uint64_t tmp_start, tmp_end, tmp_size;
+
+		tmp_start = fdt64_to_cpu(*((const fdt64_t *) prop));
+
+		prop = fdt_getprop(fdt, chosen_node, "linux,initrd-end", NULL);
+		if (!prop) {
+			pr_err("Malformed device tree.\n");
+			return -EINVAL;
+		}
+		tmp_end = fdt64_to_cpu(*((const fdt64_t *) prop));
+
+		/*
+		 * kexec reserves exact initrd size, while firmware may
+		 * reserve a multiple of PAGE_SIZE, so check for both.
+		 */
+		tmp_size = tmp_end - tmp_start;
+		ret = delete_fdt_mem_rsv(fdt, tmp_start, tmp_size);
+		if (ret == -ENOENT)
+			ret = delete_fdt_mem_rsv(fdt, tmp_start,
+						 round_up(tmp_size, PAGE_SIZE));
+		if (ret == 0)
+			pr_debug("Removed old initrd reservation.\n");
+		else if (ret != -ENOENT)
+			return ret;
+
+		/* If there's no new initrd, delete the old initrd's info. */
+		if (initrd_len == 0) {
+			ret = fdt_delprop(fdt, chosen_node,
+					  "linux,initrd-start");
+			if (ret) {
+				pr_err("Error deleting linux,initrd-start.\n");
+				return -EINVAL;
+			}
+
+			ret = fdt_delprop(fdt, chosen_node, "linux,initrd-end");
+			if (ret) {
+				pr_err("Error deleting linux,initrd-end.\n");
+				return -EINVAL;
+			}
+		}
+	}
+
+	if (initrd_len) {
+		ret = fdt_setprop_u64(fdt, chosen_node,
+				      "linux,initrd-start",
+				      initrd_load_addr);
+		if (ret < 0) {
+			pr_err("Error setting up the new device tree.\n");
+			return -EINVAL;
+		}
+
+		/* initrd-end is the first address after the initrd image. */
+		ret = fdt_setprop_u64(fdt, chosen_node, "linux,initrd-end",
+				      initrd_load_addr + initrd_len);
+		if (ret < 0) {
+			pr_err("Error setting up the new device tree.\n");
+			return -EINVAL;
+		}
+
+		ret = fdt_add_mem_rsv(fdt, initrd_load_addr, initrd_len);
+		if (ret) {
+			pr_err("Error reserving initrd memory: %s\n",
+			       fdt_strerror(ret));
+			return -EINVAL;
+		}
+	}
+
+	if (cmdline != NULL) {
+		ret = fdt_setprop_string(fdt, chosen_node, "bootargs", cmdline);
+		if (ret < 0) {
+			pr_err("Error setting up the new device tree.\n");
+			return -EINVAL;
+		}
+	} else {
+		ret = fdt_delprop(fdt, chosen_node, "bootargs");
+		if (ret && ret != -FDT_ERR_NOTFOUND) {
+			pr_err("Error deleting bootargs.\n");
+			return -EINVAL;
+		}
+	}
+
+	ret = fdt_setprop(fdt, chosen_node, "linux,booted-from-kexec", NULL, 0);
+	if (ret) {
+		pr_err("Error setting up the new device tree.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-kexec-enable-kexec_file_load-syscall.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch

