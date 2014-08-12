From: akpm@linux-foundation.org
Subject: [merged] kexec-support-kexec-kdump-on-efi-systems.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:44:09 -0700
Message-ID: <53ea6e89.0IakAnUXM5ioPNSO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:42299 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbaHLToK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:44:10 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so2671945pdj.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:44:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, matt@console-pimps.org, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: support kexec/kdump on EFI systems
has been removed from the -mm tree.  Its filename was
     kexec-support-kexec-kdump-on-efi-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: support kexec/kdump on EFI systems

This patch does two things.  It passes EFI run time mappings to second
kernel in bootparams efi_info.  Second kernel parse this info and create
new mappings in second kernel.  That means mappings in first and second
kernel will be same.  This paves the way to enable EFI in kexec kernel.

This patch also prepares and passes EFI setup data through bootparams. 
This contains bunch of information about various tables and their
addresses.

These information gathering and passing has been written along the lines
of what current kexec-tools is doing to make kexec work with UEFI.

[akpm@linux-foundation.org: s/get_efi/efi_get/g, per Matt]
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
Cc: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kexec-bzimage64.c  |  146 ++++++++++++++++++++++++---
 drivers/firmware/efi/runtime-map.c |   21 +++
 include/linux/efi.h                |   19 +++
 3 files changed, 174 insertions(+), 12 deletions(-)

diff -puN arch/x86/kernel/kexec-bzimage64.c~kexec-support-kexec-kdump-on-efi-systems arch/x86/kernel/kexec-bzimage64.c
--- a/arch/x86/kernel/kexec-bzimage64.c~kexec-support-kexec-kdump-on-efi-systems
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -18,10 +18,12 @@
 #include <linux/kexec.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/efi.h>
 
 #include <asm/bootparam.h>
 #include <asm/setup.h>
 #include <asm/crash.h>
+#include <asm/efi.h>
 
 #define MAX_ELFCOREHDR_STR_LEN	30	/* elfcorehdr=0x<64bit-value> */
 
@@ -90,7 +92,7 @@ static int setup_cmdline(struct kimage *
 	return 0;
 }
 
-static int setup_memory_map_entries(struct boot_params *params)
+static int setup_e820_entries(struct boot_params *params)
 {
 	unsigned int nr_e820_entries;
 
@@ -107,8 +109,93 @@ static int setup_memory_map_entries(stru
 	return 0;
 }
 
-static int setup_boot_parameters(struct kimage *image,
-				 struct boot_params *params)
+#ifdef CONFIG_EFI
+static int setup_efi_info_memmap(struct boot_params *params,
+				  unsigned long params_load_addr,
+				  unsigned int efi_map_offset,
+				  unsigned int efi_map_sz)
+{
+	void *efi_map = (void *)params + efi_map_offset;
+	unsigned long efi_map_phys_addr = params_load_addr + efi_map_offset;
+	struct efi_info *ei = &params->efi_info;
+
+	if (!efi_map_sz)
+		return 0;
+
+	efi_runtime_map_copy(efi_map, efi_map_sz);
+
+	ei->efi_memmap = efi_map_phys_addr & 0xffffffff;
+	ei->efi_memmap_hi = efi_map_phys_addr >> 32;
+	ei->efi_memmap_size = efi_map_sz;
+
+	return 0;
+}
+
+static int
+prepare_add_efi_setup_data(struct boot_params *params,
+		       unsigned long params_load_addr,
+		       unsigned int efi_setup_data_offset)
+{
+	unsigned long setup_data_phys;
+	struct setup_data *sd = (void *)params + efi_setup_data_offset;
+	struct efi_setup_data *esd = (void *)sd + sizeof(struct setup_data);
+
+	esd->fw_vendor = efi.fw_vendor;
+	esd->runtime = efi.runtime;
+	esd->tables = efi.config_table;
+	esd->smbios = efi.smbios;
+
+	sd->type = SETUP_EFI;
+	sd->len = sizeof(struct efi_setup_data);
+
+	/* Add setup data */
+	setup_data_phys = params_load_addr + efi_setup_data_offset;
+	sd->next = params->hdr.setup_data;
+	params->hdr.setup_data = setup_data_phys;
+
+	return 0;
+}
+
+static int
+setup_efi_state(struct boot_params *params, unsigned long params_load_addr,
+		unsigned int efi_map_offset, unsigned int efi_map_sz,
+		unsigned int efi_setup_data_offset)
+{
+	struct efi_info *current_ei = &boot_params.efi_info;
+	struct efi_info *ei = &params->efi_info;
+
+	if (!current_ei->efi_memmap_size)
+		return 0;
+
+	/*
+	 * If 1:1 mapping is not enabled, second kernel can not setup EFI
+	 * and use EFI run time services. User space will have to pass
+	 * acpi_rsdp=<addr> on kernel command line to make second kernel boot
+	 * without efi.
+	 */
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		return 0;
+
+	ei->efi_loader_signature = current_ei->efi_loader_signature;
+	ei->efi_systab = current_ei->efi_systab;
+	ei->efi_systab_hi = current_ei->efi_systab_hi;
+
+	ei->efi_memdesc_version = current_ei->efi_memdesc_version;
+	ei->efi_memdesc_size = efi_get_runtime_map_desc_size();
+
+	setup_efi_info_memmap(params, params_load_addr, efi_map_offset,
+			      efi_map_sz);
+	prepare_add_efi_setup_data(params, params_load_addr,
+				   efi_setup_data_offset);
+	return 0;
+}
+#endif /* CONFIG_EFI */
+
+static int
+setup_boot_parameters(struct kimage *image, struct boot_params *params,
+		      unsigned long params_load_addr,
+		      unsigned int efi_map_offset, unsigned int efi_map_sz,
+		      unsigned int efi_setup_data_offset)
 {
 	unsigned int nr_e820_entries;
 	unsigned long long mem_k, start, end;
@@ -140,7 +227,7 @@ static int setup_boot_parameters(struct
 		if (ret)
 			return ret;
 	} else
-		setup_memory_map_entries(params);
+		setup_e820_entries(params);
 
 	nr_e820_entries = params->e820_entries;
 
@@ -161,6 +248,12 @@ static int setup_boot_parameters(struct
 		}
 	}
 
+#ifdef CONFIG_EFI
+	/* Setup EFI state */
+	setup_efi_state(params, params_load_addr, efi_map_offset, efi_map_sz,
+			efi_setup_data_offset);
+#endif
+
 	/* Setup EDD info */
 	memcpy(params->eddbuf, boot_params.eddbuf,
 				EDDMAXNR * sizeof(struct edd_info));
@@ -214,6 +307,15 @@ int bzImage64_probe(const char *buf, uns
 		return ret;
 	}
 
+	/*
+	 * Can't handle 32bit EFI as it does not allow loading kernel
+	 * above 4G. This should be handled by 32bit bzImage loader
+	 */
+	if (efi_enabled(EFI_RUNTIME_SERVICES) && !efi_enabled(EFI_64BIT)) {
+		pr_debug("EFI is 32 bit. Can't load kernel above 4G.\n");
+		return ret;
+	}
+
 	/* I've got a bzImage */
 	pr_debug("It's a relocatable bzImage64\n");
 	ret = 0;
@@ -229,7 +331,7 @@ void *bzImage64_load(struct kimage *imag
 
 	struct setup_header *header;
 	int setup_sects, kern16_size, ret = 0;
-	unsigned long setup_header_size, params_cmdline_sz;
+	unsigned long setup_header_size, params_cmdline_sz, params_misc_sz;
 	struct boot_params *params;
 	unsigned long bootparam_load_addr, kernel_load_addr, initrd_load_addr;
 	unsigned long purgatory_load_addr;
@@ -239,6 +341,7 @@ void *bzImage64_load(struct kimage *imag
 	struct kexec_entry64_regs regs64;
 	void *stack;
 	unsigned int setup_hdr_offset = offsetof(struct boot_params, hdr);
+	unsigned int efi_map_offset, efi_map_sz, efi_setup_data_offset;
 
 	header = (struct setup_header *)(kernel + setup_hdr_offset);
 	setup_sects = header->setup_sects;
@@ -285,12 +388,29 @@ void *bzImage64_load(struct kimage *imag
 
 	pr_debug("Loaded purgatory at 0x%lx\n", purgatory_load_addr);
 
-	/* Load Bootparams and cmdline */
+
+	/*
+	 * Load Bootparams and cmdline and space for efi stuff.
+	 *
+	 * Allocate memory together for multiple data structures so
+	 * that they all can go in single area/segment and we don't
+	 * have to create separate segment for each. Keeps things
+	 * little bit simple
+	 */
+	efi_map_sz = efi_get_runtime_map_size();
+	efi_map_sz = ALIGN(efi_map_sz, 16);
 	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len +
 				MAX_ELFCOREHDR_STR_LEN;
-	params = kzalloc(params_cmdline_sz, GFP_KERNEL);
+	params_cmdline_sz = ALIGN(params_cmdline_sz, 16);
+	params_misc_sz = params_cmdline_sz + efi_map_sz +
+				sizeof(struct setup_data) +
+				sizeof(struct efi_setup_data);
+
+	params = kzalloc(params_misc_sz, GFP_KERNEL);
 	if (!params)
 		return ERR_PTR(-ENOMEM);
+	efi_map_offset = params_cmdline_sz;
+	efi_setup_data_offset = efi_map_offset + efi_map_sz;
 
 	/* Copy setup header onto bootparams. Documentation/x86/boot.txt */
 	setup_header_size = 0x0202 + kernel[0x0201] - setup_hdr_offset;
@@ -298,13 +418,13 @@ void *bzImage64_load(struct kimage *imag
 	/* Is there a limit on setup header size? */
 	memcpy(&params->hdr, (kernel + setup_hdr_offset), setup_header_size);
 
-	ret = kexec_add_buffer(image, (char *)params, params_cmdline_sz,
-			       params_cmdline_sz, 16, MIN_BOOTPARAM_ADDR,
+	ret = kexec_add_buffer(image, (char *)params, params_misc_sz,
+			       params_misc_sz, 16, MIN_BOOTPARAM_ADDR,
 			       ULONG_MAX, 1, &bootparam_load_addr);
 	if (ret)
 		goto out_free_params;
-	pr_debug("Loaded boot_param and command line at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-		 bootparam_load_addr, params_cmdline_sz, params_cmdline_sz);
+	pr_debug("Loaded boot_param, command line and misc at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
+		 bootparam_load_addr, params_misc_sz, params_misc_sz);
 
 	/* Load kernel */
 	kernel_buf = kernel + kern16_size;
@@ -365,7 +485,9 @@ void *bzImage64_load(struct kimage *imag
 	if (ret)
 		goto out_free_params;
 
-	ret = setup_boot_parameters(image, params);
+	ret = setup_boot_parameters(image, params, bootparam_load_addr,
+				    efi_map_offset, efi_map_sz,
+				    efi_setup_data_offset);
 	if (ret)
 		goto out_free_params;
 
diff -puN drivers/firmware/efi/runtime-map.c~kexec-support-kexec-kdump-on-efi-systems drivers/firmware/efi/runtime-map.c
--- a/drivers/firmware/efi/runtime-map.c~kexec-support-kexec-kdump-on-efi-systems
+++ a/drivers/firmware/efi/runtime-map.c
@@ -138,6 +138,27 @@ add_sysfs_runtime_map_entry(struct kobje
 	return entry;
 }
 
+int efi_get_runtime_map_size(void)
+{
+	return nr_efi_runtime_map * efi_memdesc_size;
+}
+
+int efi_get_runtime_map_desc_size(void)
+{
+	return efi_memdesc_size;
+}
+
+int efi_runtime_map_copy(void *buf, size_t bufsz)
+{
+	size_t sz = efi_get_runtime_map_size();
+
+	if (sz > bufsz)
+		sz = bufsz;
+
+	memcpy(buf, efi_runtime_map, sz);
+	return 0;
+}
+
 void efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size)
 {
 	efi_runtime_map = map;
diff -puN include/linux/efi.h~kexec-support-kexec-kdump-on-efi-systems include/linux/efi.h
--- a/include/linux/efi.h~kexec-support-kexec-kdump-on-efi-systems
+++ a/include/linux/efi.h
@@ -1156,6 +1156,9 @@ int efivars_sysfs_init(void);
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
 void efi_runtime_map_setup(void *, int, u32);
+int efi_get_runtime_map_size(void);
+int efi_get_runtime_map_desc_size(void);
+int efi_runtime_map_copy(void *buf, size_t bufsz);
 #else
 static inline int efi_runtime_map_init(struct kobject *kobj)
 {
@@ -1164,6 +1167,22 @@ static inline int efi_runtime_map_init(s
 
 static inline void
 efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
+
+static inline int efi_get_runtime_map_size(void)
+{
+	return 0;
+}
+
+static inline int efi_get_runtime_map_desc_size(void)
+{
+	return 0;
+}
+
+static inline int efi_runtime_map_copy(void *buf, size_t bufsz)
+{
+	return 0;
+}
+
 #endif
 
 /* prototypes shared between arch specific and generic stub code */
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch

