From: akpm@linux-foundation.org
Subject: [merged]
 kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:44:05 -0700
Message-ID: <53ea6e85.1hq+c+tVh1GatN6P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:41433 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbaHLToG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:44:06 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2671286pab.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:44:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-bzImage64: support for loading bzImage using 64bit entry
has been removed from the -mm tree.  Its filename was
     kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec-bzImage64: support for loading bzImage using 64bit entry

This is loader specific code which can load bzImage and set it up for
64bit entry.  This does not take care of 32bit entry or real mode entry.

32bit mode entry can be implemented if somebody needs it.

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

 arch/x86/include/asm/kexec-bzimage64.h |    6 
 arch/x86/include/asm/kexec.h           |   21 +
 arch/x86/kernel/Makefile               |    1 
 arch/x86/kernel/kexec-bzimage64.c      |  375 +++++++++++++++++++++++
 arch/x86/kernel/machine_kexec_64.c     |    5 
 include/linux/kexec.h                  |    2 
 kernel/kexec.c                         |   11 
 7 files changed, 415 insertions(+), 6 deletions(-)

diff -puN /dev/null arch/x86/include/asm/kexec-bzimage64.h
--- /dev/null
+++ a/arch/x86/include/asm/kexec-bzimage64.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_KEXEC_BZIMAGE64_H
+#define _ASM_KEXEC_BZIMAGE64_H
+
+extern struct kexec_file_ops kexec_bzImage64_ops;
+
+#endif  /* _ASM_KEXE_BZIMAGE64_H */
diff -puN arch/x86/include/asm/kexec.h~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry arch/x86/include/asm/kexec.h
--- a/arch/x86/include/asm/kexec.h~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry
+++ a/arch/x86/include/asm/kexec.h
@@ -23,6 +23,7 @@
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
+#include <asm/bootparam.h>
 
 /*
  * KEXEC_SOURCE_MEMORY_LIMIT maximum page get_free_page can return.
@@ -161,6 +162,26 @@ struct kimage_arch {
 	pmd_t *pmd;
 	pte_t *pte;
 };
+
+struct kexec_entry64_regs {
+	uint64_t rax;
+	uint64_t rbx;
+	uint64_t rcx;
+	uint64_t rdx;
+	uint64_t rsi;
+	uint64_t rdi;
+	uint64_t rsp;
+	uint64_t rbp;
+	uint64_t r8;
+	uint64_t r9;
+	uint64_t r10;
+	uint64_t r11;
+	uint64_t r12;
+	uint64_t r13;
+	uint64_t r14;
+	uint64_t r15;
+	uint64_t rip;
+};
 #endif
 
 typedef void crash_vmclear_fn(void);
diff -puN arch/x86/kernel/Makefile~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry
+++ a/arch/x86/kernel/Makefile
@@ -118,4 +118,5 @@ ifeq ($(CONFIG_X86_64),y)
 
 	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 	obj-y				+= vsmp_64.o
+	obj-$(CONFIG_KEXEC)		+= kexec-bzimage64.o
 endif
diff -puN /dev/null arch/x86/kernel/kexec-bzimage64.c
--- /dev/null
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -0,0 +1,375 @@
+/*
+ * Kexec bzImage loader
+ *
+ * Copyright (C) 2014 Red Hat Inc.
+ * Authors:
+ *      Vivek Goyal <vgoyal@redhat.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#define pr_fmt(fmt)	"kexec-bzImage64: " fmt
+
+#include <linux/string.h>
+#include <linux/printk.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/kexec.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+
+#include <asm/bootparam.h>
+#include <asm/setup.h>
+
+/*
+ * Defines lowest physical address for various segments. Not sure where
+ * exactly these limits came from. Current bzimage64 loader in kexec-tools
+ * uses these so I am retaining it. It can be changed over time as we gain
+ * more insight.
+ */
+#define MIN_PURGATORY_ADDR	0x3000
+#define MIN_BOOTPARAM_ADDR	0x3000
+#define MIN_KERNEL_LOAD_ADDR	0x100000
+#define MIN_INITRD_LOAD_ADDR	0x1000000
+
+/*
+ * This is a place holder for all boot loader specific data structure which
+ * gets allocated in one call but gets freed much later during cleanup
+ * time. Right now there is only one field but it can grow as need be.
+ */
+struct bzimage64_data {
+	/*
+	 * Temporary buffer to hold bootparams buffer. This should be
+	 * freed once the bootparam segment has been loaded.
+	 */
+	void *bootparams_buf;
+};
+
+static int setup_initrd(struct boot_params *params,
+		unsigned long initrd_load_addr, unsigned long initrd_len)
+{
+	params->hdr.ramdisk_image = initrd_load_addr & 0xffffffffUL;
+	params->hdr.ramdisk_size = initrd_len & 0xffffffffUL;
+
+	params->ext_ramdisk_image = initrd_load_addr >> 32;
+	params->ext_ramdisk_size = initrd_len >> 32;
+
+	return 0;
+}
+
+static int setup_cmdline(struct boot_params *params,
+			 unsigned long bootparams_load_addr,
+			 unsigned long cmdline_offset, char *cmdline,
+			 unsigned long cmdline_len)
+{
+	char *cmdline_ptr = ((char *)params) + cmdline_offset;
+	unsigned long cmdline_ptr_phys;
+	uint32_t cmdline_low_32, cmdline_ext_32;
+
+	memcpy(cmdline_ptr, cmdline, cmdline_len);
+	cmdline_ptr[cmdline_len - 1] = '\0';
+
+	cmdline_ptr_phys = bootparams_load_addr + cmdline_offset;
+	cmdline_low_32 = cmdline_ptr_phys & 0xffffffffUL;
+	cmdline_ext_32 = cmdline_ptr_phys >> 32;
+
+	params->hdr.cmd_line_ptr = cmdline_low_32;
+	if (cmdline_ext_32)
+		params->ext_cmd_line_ptr = cmdline_ext_32;
+
+	return 0;
+}
+
+static int setup_memory_map_entries(struct boot_params *params)
+{
+	unsigned int nr_e820_entries;
+
+	nr_e820_entries = e820_saved.nr_map;
+
+	/* TODO: Pass entries more than E820MAX in bootparams setup data */
+	if (nr_e820_entries > E820MAX)
+		nr_e820_entries = E820MAX;
+
+	params->e820_entries = nr_e820_entries;
+	memcpy(&params->e820_map, &e820_saved.map,
+	       nr_e820_entries * sizeof(struct e820entry));
+
+	return 0;
+}
+
+static int setup_boot_parameters(struct boot_params *params)
+{
+	unsigned int nr_e820_entries;
+	unsigned long long mem_k, start, end;
+	int i;
+
+	/* Get subarch from existing bootparams */
+	params->hdr.hardware_subarch = boot_params.hdr.hardware_subarch;
+
+	/* Copying screen_info will do? */
+	memcpy(&params->screen_info, &boot_params.screen_info,
+				sizeof(struct screen_info));
+
+	/* Fill in memsize later */
+	params->screen_info.ext_mem_k = 0;
+	params->alt_mem_k = 0;
+
+	/* Default APM info */
+	memset(&params->apm_bios_info, 0, sizeof(params->apm_bios_info));
+
+	/* Default drive info */
+	memset(&params->hd0_info, 0, sizeof(params->hd0_info));
+	memset(&params->hd1_info, 0, sizeof(params->hd1_info));
+
+	/* Default sysdesc table */
+	params->sys_desc_table.length = 0;
+
+	setup_memory_map_entries(params);
+	nr_e820_entries = params->e820_entries;
+
+	for (i = 0; i < nr_e820_entries; i++) {
+		if (params->e820_map[i].type != E820_RAM)
+			continue;
+		start = params->e820_map[i].addr;
+		end = params->e820_map[i].addr + params->e820_map[i].size - 1;
+
+		if ((start <= 0x100000) && end > 0x100000) {
+			mem_k = (end >> 10) - (0x100000 >> 10);
+			params->screen_info.ext_mem_k = mem_k;
+			params->alt_mem_k = mem_k;
+			if (mem_k > 0xfc00)
+				params->screen_info.ext_mem_k = 0xfc00; /* 64M*/
+			if (mem_k > 0xffffffff)
+				params->alt_mem_k = 0xffffffff;
+		}
+	}
+
+	/* Setup EDD info */
+	memcpy(params->eddbuf, boot_params.eddbuf,
+				EDDMAXNR * sizeof(struct edd_info));
+	params->eddbuf_entries = boot_params.eddbuf_entries;
+
+	memcpy(params->edd_mbr_sig_buffer, boot_params.edd_mbr_sig_buffer,
+	       EDD_MBR_SIG_MAX * sizeof(unsigned int));
+
+	return 0;
+}
+
+int bzImage64_probe(const char *buf, unsigned long len)
+{
+	int ret = -ENOEXEC;
+	struct setup_header *header;
+
+	/* kernel should be atleast two sectors long */
+	if (len < 2 * 512) {
+		pr_err("File is too short to be a bzImage\n");
+		return ret;
+	}
+
+	header = (struct setup_header *)(buf + offsetof(struct boot_params, hdr));
+	if (memcmp((char *)&header->header, "HdrS", 4) != 0) {
+		pr_err("Not a bzImage\n");
+		return ret;
+	}
+
+	if (header->boot_flag != 0xAA55) {
+		pr_err("No x86 boot sector present\n");
+		return ret;
+	}
+
+	if (header->version < 0x020C) {
+		pr_err("Must be at least protocol version 2.12\n");
+		return ret;
+	}
+
+	if (!(header->loadflags & LOADED_HIGH)) {
+		pr_err("zImage not a bzImage\n");
+		return ret;
+	}
+
+	if (!(header->xloadflags & XLF_KERNEL_64)) {
+		pr_err("Not a bzImage64. XLF_KERNEL_64 is not set.\n");
+		return ret;
+	}
+
+	if (!(header->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)) {
+		pr_err("XLF_CAN_BE_LOADED_ABOVE_4G is not set.\n");
+		return ret;
+	}
+
+	/* I've got a bzImage */
+	pr_debug("It's a relocatable bzImage64\n");
+	ret = 0;
+
+	return ret;
+}
+
+void *bzImage64_load(struct kimage *image, char *kernel,
+		     unsigned long kernel_len, char *initrd,
+		     unsigned long initrd_len, char *cmdline,
+		     unsigned long cmdline_len)
+{
+
+	struct setup_header *header;
+	int setup_sects, kern16_size, ret = 0;
+	unsigned long setup_header_size, params_cmdline_sz;
+	struct boot_params *params;
+	unsigned long bootparam_load_addr, kernel_load_addr, initrd_load_addr;
+	unsigned long purgatory_load_addr;
+	unsigned long kernel_bufsz, kernel_memsz, kernel_align;
+	char *kernel_buf;
+	struct bzimage64_data *ldata;
+	struct kexec_entry64_regs regs64;
+	void *stack;
+	unsigned int setup_hdr_offset = offsetof(struct boot_params, hdr);
+
+	header = (struct setup_header *)(kernel + setup_hdr_offset);
+	setup_sects = header->setup_sects;
+	if (setup_sects == 0)
+		setup_sects = 4;
+
+	kern16_size = (setup_sects + 1) * 512;
+	if (kernel_len < kern16_size) {
+		pr_err("bzImage truncated\n");
+		return ERR_PTR(-ENOEXEC);
+	}
+
+	if (cmdline_len > header->cmdline_size) {
+		pr_err("Kernel command line too long\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	/*
+	 * Load purgatory. For 64bit entry point, purgatory  code can be
+	 * anywhere.
+	 */
+	ret = kexec_load_purgatory(image, MIN_PURGATORY_ADDR, ULONG_MAX, 1,
+				   &purgatory_load_addr);
+	if (ret) {
+		pr_err("Loading purgatory failed\n");
+		return ERR_PTR(ret);
+	}
+
+	pr_debug("Loaded purgatory at 0x%lx\n", purgatory_load_addr);
+
+	/* Load Bootparams and cmdline */
+	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len;
+	params = kzalloc(params_cmdline_sz, GFP_KERNEL);
+	if (!params)
+		return ERR_PTR(-ENOMEM);
+
+	/* Copy setup header onto bootparams. Documentation/x86/boot.txt */
+	setup_header_size = 0x0202 + kernel[0x0201] - setup_hdr_offset;
+
+	/* Is there a limit on setup header size? */
+	memcpy(&params->hdr, (kernel + setup_hdr_offset), setup_header_size);
+
+	ret = kexec_add_buffer(image, (char *)params, params_cmdline_sz,
+			       params_cmdline_sz, 16, MIN_BOOTPARAM_ADDR,
+			       ULONG_MAX, 1, &bootparam_load_addr);
+	if (ret)
+		goto out_free_params;
+	pr_debug("Loaded boot_param and command line at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		 bootparam_load_addr, params_cmdline_sz, params_cmdline_sz);
+
+	/* Load kernel */
+	kernel_buf = kernel + kern16_size;
+	kernel_bufsz =  kernel_len - kern16_size;
+	kernel_memsz = PAGE_ALIGN(header->init_size);
+	kernel_align = header->kernel_alignment;
+
+	ret = kexec_add_buffer(image, kernel_buf,
+			       kernel_bufsz, kernel_memsz, kernel_align,
+			       MIN_KERNEL_LOAD_ADDR, ULONG_MAX, 1,
+			       &kernel_load_addr);
+	if (ret)
+		goto out_free_params;
+
+	pr_debug("Loaded 64bit kernel at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		 kernel_load_addr, kernel_memsz, kernel_memsz);
+
+	/* Load initrd high */
+	if (initrd) {
+		ret = kexec_add_buffer(image, initrd, initrd_len, initrd_len,
+				       PAGE_SIZE, MIN_INITRD_LOAD_ADDR,
+				       ULONG_MAX, 1, &initrd_load_addr);
+		if (ret)
+			goto out_free_params;
+
+		pr_debug("Loaded initrd at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+				initrd_load_addr, initrd_len, initrd_len);
+
+		setup_initrd(params, initrd_load_addr, initrd_len);
+	}
+
+	setup_cmdline(params, bootparam_load_addr, sizeof(struct boot_params),
+		      cmdline, cmdline_len);
+
+	/* bootloader info. Do we need a separate ID for kexec kernel loader? */
+	params->hdr.type_of_loader = 0x0D << 4;
+	params->hdr.loadflags = 0;
+
+	/* Setup purgatory regs for entry */
+	ret = kexec_purgatory_get_set_symbol(image, "entry64_regs", &regs64,
+					     sizeof(regs64), 1);
+	if (ret)
+		goto out_free_params;
+
+	regs64.rbx = 0; /* Bootstrap Processor */
+	regs64.rsi = bootparam_load_addr;
+	regs64.rip = kernel_load_addr + 0x200;
+	stack = kexec_purgatory_get_symbol_addr(image, "stack_end");
+	if (IS_ERR(stack)) {
+		pr_err("Could not find address of symbol stack_end\n");
+		ret = -EINVAL;
+		goto out_free_params;
+	}
+
+	regs64.rsp = (unsigned long)stack;
+	ret = kexec_purgatory_get_set_symbol(image, "entry64_regs", &regs64,
+					     sizeof(regs64), 0);
+	if (ret)
+		goto out_free_params;
+
+	setup_boot_parameters(params);
+
+	/* Allocate loader specific data */
+	ldata = kzalloc(sizeof(struct bzimage64_data), GFP_KERNEL);
+	if (!ldata) {
+		ret = -ENOMEM;
+		goto out_free_params;
+	}
+
+	/*
+	 * Store pointer to params so that it could be freed after loading
+	 * params segment has been loaded and contents have been copied
+	 * somewhere else.
+	 */
+	ldata->bootparams_buf = params;
+	return ldata;
+
+out_free_params:
+	kfree(params);
+	return ERR_PTR(ret);
+}
+
+/* This cleanup function is called after various segments have been loaded */
+int bzImage64_cleanup(void *loader_data)
+{
+	struct bzimage64_data *ldata = loader_data;
+
+	if (!ldata)
+		return 0;
+
+	kfree(ldata->bootparams_buf);
+	ldata->bootparams_buf = NULL;
+
+	return 0;
+}
+
+struct kexec_file_ops kexec_bzImage64_ops = {
+	.probe = bzImage64_probe,
+	.load = bzImage64_load,
+	.cleanup = bzImage64_cleanup,
+};
diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -23,9 +23,10 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/debugreg.h>
+#include <asm/kexec-bzimage64.h>
 
 static struct kexec_file_ops *kexec_file_loaders[] = {
-		NULL,
+		&kexec_bzImage64_ops,
 };
 
 static void free_transition_pgtable(struct kimage *image)
@@ -328,7 +329,7 @@ int arch_kimage_file_post_load_cleanup(s
 	if (!image->fops || !image->fops->cleanup)
 		return 0;
 
-	return image->fops->cleanup(image);
+	return image->fops->cleanup(image->image_loader_data);
 }
 
 /*
diff -puN include/linux/kexec.h~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry
+++ a/include/linux/kexec.h
@@ -190,7 +190,7 @@ typedef void *(kexec_load_t)(struct kima
 			     unsigned long kernel_len, char *initrd,
 			     unsigned long initrd_len, char *cmdline,
 			     unsigned long cmdline_len);
-typedef int (kexec_cleanup_t)(struct kimage *image);
+typedef int (kexec_cleanup_t)(void *loader_data);
 
 struct kexec_file_ops {
 	kexec_probe_t *probe;
diff -puN kernel/kexec.c~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry kernel/kexec.c
--- a/kernel/kexec.c~kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry
+++ a/kernel/kexec.c
@@ -460,6 +460,14 @@ static void kimage_file_post_load_cleanu
 
 	/* See if architecture has anything to cleanup post load */
 	arch_kimage_file_post_load_cleanup(image);
+
+	/*
+	 * Above call should have called into bootloader to free up
+	 * any data stored in kimage->image_loader_data. It should
+	 * be ok now to free it up.
+	 */
+	kfree(image->image_loader_data);
+	image->image_loader_data = NULL;
 }
 
 /*
@@ -576,7 +584,6 @@ out_free_control_pages:
 	kimage_free_page_list(&image->control_pages);
 out_free_post_load_bufs:
 	kimage_file_post_load_cleanup(image);
-	kfree(image->image_loader_data);
 out_free_image:
 	kfree(image);
 	return ret;
@@ -900,8 +907,6 @@ static void kimage_free(struct kimage *i
 	/* Free the kexec control pages... */
 	kimage_free_page_list(&image->control_pages);
 
-	kfree(image->image_loader_data);
