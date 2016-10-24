From: akpm@linux-foundation.org
Subject: +
 powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load.patch
 added to -mm tree
Date: Mon, 24 Oct 2016 12:42:42 -0700
Message-ID: <580e6432.npu/VO8RaKXCxdyp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56705 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941038AbcJXTmn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2016 15:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, sklar@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


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

This uses all the infrastructure built up by the previous patches in the
series to load an ELF vmlinux file and an initrd.  It uses the flattened
device tree at initial_boot_params as a base and adjusts memory
reservations and its /chosen node for the next kernel.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1477017617-8540-9-git-send-email-bauerman@linux.vnet.ibm.com
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

 arch/powerpc/include/asm/kexec.h            |   12 
 arch/powerpc/kernel/Makefile                |    3 
 arch/powerpc/kernel/kexec_elf_64.c          |  280 ++++++++++++++
 arch/powerpc/kernel/machine_kexec_file_64.c |  338 +++++++++++++++++-
 4 files changed, 630 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/include/asm/kexec.h~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load arch/powerpc/include/asm/kexec.h
--- a/arch/powerpc/include/asm/kexec.h~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load
+++ a/arch/powerpc/include/asm/kexec.h
@@ -91,6 +91,18 @@ static inline bool kdump_in_progress(voi
 	return crashing_cpu >= 0;
 }
 
+#ifdef CONFIG_KEXEC_FILE
+extern struct kexec_file_ops kexec_elf64_ops;
+
+int setup_purgatory(struct kimage *image, const void *slave_code,
+		    const void *fdt, unsigned long kernel_load_addr,
+		    unsigned long fdt_load_addr, unsigned long stack_top,
+		    int debug);
+int setup_new_fdt(void *fdt, unsigned long initrd_load_addr,
+		  unsigned long initrd_len, const char *cmdline);
+bool find_debug_console(const void *fdt);
+#endif /* CONFIG_KEXEC_FILE */
+
 #else /* !CONFIG_KEXEC_CORE */
 static inline void crash_kexec_secondary(struct pt_regs *regs) { }
 
diff -puN arch/powerpc/kernel/Makefile~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load
+++ a/arch/powerpc/kernel/Makefile
@@ -109,7 +109,8 @@ obj-$(CONFIG_PCI)		+= pci_$(BITS).o $(pc
 obj-$(CONFIG_PCI_MSI)		+= msi.o
 obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o crash.o \
 				   machine_kexec_$(BITS).o
-obj-$(CONFIG_KEXEC_FILE)	+= machine_kexec_file_$(BITS).o elf_util.o
+obj-$(CONFIG_KEXEC_FILE)	+= machine_kexec_file_$(BITS).o elf_util.o \
+				   kexec_elf_$(BITS).o
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
diff -puN /dev/null arch/powerpc/kernel/kexec_elf_64.c
--- /dev/null
+++ a/arch/powerpc/kernel/kexec_elf_64.c
@@ -0,0 +1,280 @@
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
+#include <linux/elf.h>
+#include <linux/kexec.h>
+#include <linux/of_fdt.h>
+#include <linux/libfdt.h>
+#include <asm/elf_util.h>
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
+static void *elf64_load(struct kimage *image, char *kernel_buf,
+			unsigned long kernel_len, char *initrd,
+			unsigned long initrd_len, char *cmdline,
+			unsigned long cmdline_len)
+{
+	int i, ret;
+	unsigned int fdt_size;
+	unsigned long kernel_load_addr, purgatory_load_addr;
+	unsigned long initrd_load_addr = 0, fdt_load_addr, stack_top;
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
diff -puN arch/powerpc/kernel/machine_kexec_file_64.c~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load arch/powerpc/kernel/machine_kexec_file_64.c
--- a/arch/powerpc/kernel/machine_kexec_file_64.c~powerpc-add-support-for-loading-elf-kernels-with-kexec_file_load
+++ a/arch/powerpc/kernel/machine_kexec_file_64.c
@@ -3,11 +3,12 @@
  *
  * Copyright (C) 2004  Adam Litke (agl@us.ibm.com)
  * Copyright (C) 2004  IBM Corp.
+ * Copyright (C) 2004,2005  Milton D Miller II, IBM Corporation
  * Copyright (C) 2005  R Sharada (sharada@in.ibm.com)
  * Copyright (C) 2006  Mohan Kumar M (mohan@in.ibm.com)
  * Copyright (C) 2016  IBM Corporation
  *
- * Based on kexec-tools' kexec-elf-ppc64.c.
+ * Based on kexec-tools' kexec-elf-ppc64.c, fs2dt.c.
  * Heavily modified for the kernel by
  * Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>.
  *
@@ -24,12 +25,15 @@
 #include <linux/slab.h>
 #include <linux/kexec.h>
 #include <linux/memblock.h>
+#include <linux/of_fdt.h>
 #include <linux/libfdt.h>
 #include <asm/elf_util.h>
 
 #define SLAVE_CODE_SIZE		256
 
-static struct kexec_file_ops *kexec_file_loaders[] = { };
+static struct kexec_file_ops *kexec_file_loaders[] = {
+	&kexec_elf64_ops,
+};
 
 int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
 				  unsigned long buf_len)
@@ -243,3 +247,333 @@ int arch_kexec_apply_relocations_add(con
 
 	return 0;
 }
+
+/**
+ * setup_purgatory - initialize the purgatory's global variables
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
+	unsigned int toc_section;
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
+	toc_section = elf_toc_section(image->purgatory_info.ehdr,
+				      image->purgatory_info.sechdrs);
+	if (!toc_section)
+		return -ENOEXEC;
+
+	toc = elf_my_r2(image->purgatory_info.sechdrs, toc_section);
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
+
+/**
+ * find_debug_console - find out whether there is a console for the purgatory
+ * @fdt:		Flattened device tree to search.
+ */
+bool find_debug_console(const void *fdt)
+{
+	int len;
+	int console_node, chosen_node;
+	const void *prop, *colon;
+
+	chosen_node = fdt_path_offset(fdt, "/chosen");
+	if (chosen_node < 0) {
+		pr_err("Malformed device tree: /chosen not found.\n");
+		return false;
+	}
+
+	prop = fdt_getprop(fdt, chosen_node, "stdout-path", &len);
+	if (prop == NULL) {
+		if (len == -FDT_ERR_NOTFOUND) {
+			prop = fdt_getprop(fdt, chosen_node,
+					   "linux,stdout-path", &len);
+			if (prop == NULL) {
+				pr_debug("Unable to find [linux,]stdout-path.\n");
+				return false;
+			}
+		} else {
+			pr_debug("Error finding console: %s\n",
+				 fdt_strerror(len));
+			return false;
+		}
+	}
+
+	/*
+	 * stdout-path can have a ':' separating the path from device-specific
+	 * information, so we should only consider what's before it.
+	 */
+	colon = strchr(prop, ':');
+	if (colon != NULL)
+		len = colon - prop;
+	else
+		len -= 1;	/* Ignore the terminating NUL. */
+
+	console_node = fdt_path_offset_namelen(fdt, prop, len);
+	if (console_node < 0) {
+		pr_debug("Error finding console: %s\n",
+			 fdt_strerror(console_node));
+		return false;
+	}
+
+	if (fdt_node_check_compatible(fdt, console_node, "hvterm1") == 0)
+		return true;
+	else if (fdt_node_check_compatible(fdt, console_node,
+					   "hvterm-protocol") == 0)
+		return true;
+
+	return false;
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

