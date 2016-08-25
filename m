From: akpm@linux-foundation.org
Subject: +
 powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
 added to -mm tree
Date: Thu, 25 Aug 2016 14:13:31 -0700
Message-ID: <57bf5f7b.gvylEXl/OARwg5+m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58417 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754666AbcHYVN6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:13:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sam@mendozajonas.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add support for loading ELF kernels with kexec_file_load
has been added to the -mm tree.  Its filename is
     powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch

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
Subject: powerpc: add support for loading ELF kernels with kexec_file_load

This uses all the infrastructure built up by the previous patches
in the series to load an ELF vmlinux file and an initrd. It uses the
flattened device tree at initial_boot_params as a base and adjusts memory
reservations and its /chosen node for the next kernel.

Link: http://lkml.kernel.org/r/1471652242-14436-11-git-send-email-bauerman@linux.vnet.ibm.com
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

 arch/powerpc/include/asm/kexec_elf_64.h |   10 
 arch/powerpc/kernel/Makefile            |    1 
 arch/powerpc/kernel/kexec_elf_64.c      |  283 ++++++++++++++++++++++
 arch/powerpc/kernel/machine_kexec_64.c  |    5 
 4 files changed, 298 insertions(+), 1 deletion(-)

diff -puN /dev/null arch/powerpc/include/asm/kexec_elf_64.h
--- /dev/null
+++ a/arch/powerpc/include/asm/kexec_elf_64.h
@@ -0,0 +1,10 @@
+#ifndef __POWERPC_KEXEC_ELF_64_H__
+#define __POWERPC_KEXEC_ELF_64_H__
+
+#ifdef CONFIG_KEXEC_FILE
+
+extern struct kexec_file_ops kexec_elf64_ops;
+
+#endif /* CONFIG_KEXEC_FILE */
+
+#endif /* __POWERPC_KEXEC_ELF_64_H__ */
diff -puN arch/powerpc/kernel/Makefile~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load
+++ a/arch/powerpc/kernel/Makefile
@@ -109,6 +109,7 @@ obj-$(CONFIG_PCI)		+= pci_$(CONFIG_WORD_
 obj-$(CONFIG_PCI_MSI)		+= msi.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o crash.o \
 				   machine_kexec_$(CONFIG_WORD_SIZE).o
+obj-$(CONFIG_KEXEC_FILE)	+= kexec_elf_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
diff -puN /dev/null arch/powerpc/kernel/kexec_elf_64.c
--- /dev/null
+++ a/arch/powerpc/kernel/kexec_elf_64.c
@@ -0,0 +1,283 @@
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
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/kexec.h>
+#include <linux/elf.h>
+#include <linux/kexec.h>
+#include <linux/of_fdt.h>
+#include <linux/libfdt.h>
+#include <asm/elf_util.h>
+
+extern size_t kexec_purgatory_size;
+
+#define PURGATORY_STACK_SIZE	(16 * 1024)
+
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
+void *elf64_load(struct kimage *image, char *kernel_buf,
+		 unsigned long kernel_len, char *initrd,
+		 unsigned long initrd_len, char *cmdline,
+		 unsigned long cmdline_len)
+{
+	int i, ret;
+	unsigned int fdt_size;
+	unsigned long kernel_load_addr, purgatory_load_addr;
+	unsigned long initrd_load_addr, fdt_load_addr, stack_top;
+	void *fdt;
+	const void *slave_code;
+	struct elfhdr ehdr;
+	struct elf_info elf_info;
+	struct fdt_reserve_entry *rsvmap;
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
+	/*
+	 * Documentation/devicetree/booting-without-of.txt says we need to
+	 * add a reservation entry for the device tree block, but
+	 * early_init_fdt_reserve_self reserves the memory even if there's no
+	 * such entry. We'll add a reservation entry anyway, to be safe and
+	 * compliant.
+	 *
+	 * Use dummy values, we will correct them in a moment.
+	 */
+	ret = fdt_add_mem_rsv(fdt, 1, 1);
+	if (ret) {
+		pr_err("Error reserving device tree memory: %s\n",
+		       fdt_strerror(ret));
+		ret = -EINVAL;
+		goto out;
+	}
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
+	/*
+	 * Fix fdt reservation, now that we now where it will be loaded
+	 * and how big it is.
+	 */
+	rsvmap = fdt + fdt_off_mem_rsvmap(fdt);
+	i = fdt_num_mem_rsv(fdt) - 1;
+	rsvmap[i].address = cpu_to_fdt64(fdt_load_addr);
+	rsvmap[i].size = cpu_to_fdt64(fdt_totalsize(fdt));
+
+	pr_debug("Loaded device tree at 0x%lx\n", fdt_load_addr);
+
+	kbuf.memsz = PURGATORY_STACK_SIZE;
+	kbuf.buf_align = PAGE_SIZE;
+	kbuf.top_down = true;
+	ret = kexec_locate_mem_hole(&kbuf);
+	if (ret) {
+		pr_err("Couldn't find free memory for the purgatory stack.\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	stack_top = kbuf.mem + PURGATORY_STACK_SIZE - 1;
+	pr_debug("Purgatory stack is at 0x%lx\n", stack_top);
+
+	slave_code = elf_info.buffer + elf_info.proghdrs[0].p_offset;
+	ret = setup_purgatory(image, slave_code, fdt, kernel_load_addr,
+			      fdt_load_addr, stack_top,
+			      find_debug_console(fdt));
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
diff -puN arch/powerpc/kernel/machine_kexec_64.c~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -32,11 +32,14 @@
 #include <asm/smp.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/asm-prototypes.h>
+#include <asm/kexec_elf_64.h>
 
 #define SLAVE_CODE_SIZE		256
 
 #ifdef CONFIG_KEXEC_FILE
-static struct kexec_file_ops *kexec_file_loaders[] = { };
+static struct kexec_file_ops *kexec_file_loaders[] = {
+	&kexec_elf64_ops,
+};
 #endif
 
 #ifdef CONFIG_PPC_BOOK3E
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

kexec_file-allow-arch-specific-memory-walking-for-kexec_add_buffer.patch
kexec_file-change-kexec_add_buffer-to-take-kexec_buf-as-argument.patch
kexec_file-factor-out-kexec_locate_mem_hole-from-kexec_add_buffer.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch
powerpc-generalize-elf64_apply_relocate_add.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load.patch
powerpc-add-functions-to-read-elf-files-of-any-endianness.patch
powerpc-implement-kexec_file_load.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch
powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
powerpc-add-purgatory-for-kexec_file_load-implementation.patch
powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
powerpc-kexec_file-add-buffer-hand-over-support-for-the-next-kernel.patch
kexec_file-allow-skipping-checksum-calculation-for-some-segments.patch
kexec_file-add-mechanism-to-update-kexec-segments.patch
ima-demonstration-code-for-kexec-buffer-passing.patch

