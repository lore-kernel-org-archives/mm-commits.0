From: akpm@linux-foundation.org
Subject: + efi-pass-kexec-necessary-efi-data-via-setup_data.patch added to -mm tree
Date: Tue, 10 Dec 2013 15:23:20 -0800
Message-ID: <52a7a268.tPqJ2qONs5lW3qYR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3LJXXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:23:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, toshi.kani@hp.com, tglx@linutronix.de, mjg59@srcf.ucam.org, mingo@elte.hu, matt@console-pimps.org, hpa@zytor.com, horms@verge.net.au, greg@kroah.com, ebiederm@xmission.com, bp@suse.de, James.Bottomley@HansenPartnership.com, dyoung@redhat.com

Subject: + efi-pass-kexec-necessary-efi-data-via-setup_data.patch added to -mm tree
To: dyoung@redhat.com,James.Bottomley@HansenPartnership.com,bp@suse.de,ebiederm@xmission.com,greg@kroah.com,horms@verge.net.au,hpa@zytor.com,matt@console-pimps.org,mingo@elte.hu,mjg59@srcf.ucam.org,tglx@linutronix.de,toshi.kani@hp.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:23:20 -0800


The patch titled
     Subject: efi: pass kexec necessary efi data via setup_data
has been added to the -mm tree.  Its filename is
     efi-pass-kexec-necessary-efi-data-via-setup_data.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-pass-kexec-necessary-efi-data-via-setup_data.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-pass-kexec-necessary-efi-data-via-setup_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: efi: pass kexec necessary efi data via setup_data

Add a new setup_data type SETUP_EFI for kexec use.  Passing the saved
fw_vendor, runtime, config tables and efi runtime mappings.

When entering virtual mode, directly mapping the efi runtime ragions which
we passed in previously.  And skip the step to call SetVirtualAddressMap.

Specially for HP z420 workstation we need save the smbios physical
address.  The kernel boot sequence proceeds in the following order.  Step
2 requires efi.smbios to be the physical address.  However, I found that
on HP z420 EFI system table has a virtual address of SMBIOS in step 1. 
Hence, we need set it back to the physical address with the smbios in
efi_setup_data.  (When it is still the physical address, it simply sets
the same value.)

1. efi_init() - Set efi.smbios from EFI system table
2. dmi_scan_machine() - Temporary map efi.smbios to access SMBIOS table
3. efi_enter_virtual_mode() - Map EFI ranges

Tested on ovmf+qemu, lenovo thinkpad, a dell laptop and an
HP z420 workstation.

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/efi.h            |   11 +
 arch/x86/include/uapi/asm/bootparam.h |    1 
 arch/x86/kernel/setup.c               |    3 
 arch/x86/platform/efi/efi.c           |  195 +++++++++++++++++++++---
 4 files changed, 187 insertions(+), 23 deletions(-)

diff -puN arch/x86/include/asm/efi.h~efi-pass-kexec-necessary-efi-data-via-setup_data arch/x86/include/asm/efi.h
--- a/arch/x86/include/asm/efi.h~efi-pass-kexec-necessary-efi-data-via-setup_data
+++ a/arch/x86/include/asm/efi.h
@@ -133,6 +133,17 @@ extern void efi_sync_low_kernel_mappings
 extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
 
+struct efi_setup_data {
+	u64 fw_vendor;
+	u64 runtime;
+	u64 tables;
+	u64 smbios;
+	u64 reserved[8];
+	efi_memory_desc_t map[0];
+};
+
+extern void parse_efi_setup(u64 phys_addr);
+
 #ifdef CONFIG_EFI
 
 static inline bool efi_is_native(void)
diff -puN arch/x86/include/uapi/asm/bootparam.h~efi-pass-kexec-necessary-efi-data-via-setup_data arch/x86/include/uapi/asm/bootparam.h
--- a/arch/x86/include/uapi/asm/bootparam.h~efi-pass-kexec-necessary-efi-data-via-setup_data
+++ a/arch/x86/include/uapi/asm/bootparam.h
@@ -6,6 +6,7 @@
 #define SETUP_E820_EXT			1
 #define SETUP_DTB			2
 #define SETUP_PCI			3
+#define SETUP_EFI			4
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff -puN arch/x86/kernel/setup.c~efi-pass-kexec-necessary-efi-data-via-setup_data arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~efi-pass-kexec-necessary-efi-data-via-setup_data
+++ a/arch/x86/kernel/setup.c
@@ -447,6 +447,9 @@ static void __init parse_setup_data(void
 		case SETUP_DTB:
 			add_dtb(pa_data);
 			break;
+		case SETUP_EFI:
+			parse_efi_setup(pa_data);
+			break;
 		default:
 			break;
 		}
diff -puN arch/x86/platform/efi/efi.c~efi-pass-kexec-necessary-efi-data-via-setup_data arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~efi-pass-kexec-necessary-efi-data-via-setup_data
+++ a/arch/x86/platform/efi/efi.c
@@ -78,6 +78,7 @@ static __initdata efi_config_table_type_
 
 void *efi_runtime_map;
 int nr_efi_runtime_map;
+static u64 efi_setup; /* efi setup_data physical address */
 
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
@@ -115,6 +116,25 @@ static int __init setup_storage_paranoia
 }
 early_param("efi_no_storage_paranoia", setup_storage_paranoia);
 
+void __init parse_efi_setup(u64 phys_addr)
+{
+	struct setup_data *sd;
+
+	if (!efi_enabled(EFI_64BIT)) {
+		pr_warn("SETUP_EFI not supported on 32-bit\n");
+		return;
+	}
+
+	sd = early_memremap(phys_addr, sizeof(struct setup_data));
+	if (!sd) {
+		pr_warn("efi: early_memremap setup_data failed\n");
+		return;
+	}
+	efi_setup = phys_addr + sizeof(struct setup_data);
+	nr_efi_runtime_map = (sd->len - sizeof(struct efi_setup_data)) /
+			     sizeof(efi_memory_desc_t);
+	early_memunmap(sd, sizeof(struct setup_data));
+}
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
@@ -494,18 +514,28 @@ static int __init efi_systab_init(void *
 {
 	if (efi_enabled(EFI_64BIT)) {
 		efi_system_table_64_t *systab64;
+		struct efi_setup_data *data = NULL;
 		u64 tmp = 0;
 
+		if (efi_setup) {
+			data = early_memremap(efi_setup, sizeof(*data));
+			if (!data)
+				return -ENOMEM;
+		}
 		systab64 = early_memremap((unsigned long)phys,
 					 sizeof(*systab64));
 		if (systab64 == NULL) {
 			pr_err("Couldn't map the system table!\n");
+			if (data)
+				early_memunmap(data, sizeof(*data));
 			return -ENOMEM;
 		}
 
 		efi_systab.hdr = systab64->hdr;
-		efi_systab.fw_vendor = systab64->fw_vendor;
-		tmp |= systab64->fw_vendor;
+
+		efi_systab.fw_vendor = data ? (unsigned long)data->fw_vendor :
+					      systab64->fw_vendor;
+		tmp |= efi_systab.fw_vendor;
 		efi_systab.fw_revision = systab64->fw_revision;
 		efi_systab.con_in_handle = systab64->con_in_handle;
 		tmp |= systab64->con_in_handle;
@@ -519,15 +549,20 @@ static int __init efi_systab_init(void *
 		tmp |= systab64->stderr_handle;
 		efi_systab.stderr = systab64->stderr;
 		tmp |= systab64->stderr;
-		efi_systab.runtime = (void *)(unsigned long)systab64->runtime;
-		tmp |= systab64->runtime;
+		efi_systab.runtime = data ?
+				     (void *)(unsigned long)data->runtime :
+				     (void *)(unsigned long)systab64->runtime;
+		tmp |= (unsigned long)efi_systab.runtime;
 		efi_systab.boottime = (void *)(unsigned long)systab64->boottime;
 		tmp |= systab64->boottime;
 		efi_systab.nr_tables = systab64->nr_tables;
-		efi_systab.tables = systab64->tables;
-		tmp |= systab64->tables;
+		efi_systab.tables = data ? (unsigned long)data->tables :
+					   systab64->tables;
+		tmp |= efi_systab.tables;
 
 		early_memunmap(systab64, sizeof(*systab64));
+		if (data)
+			early_memunmap(data, sizeof(*data));
 #ifdef CONFIG_X86_32
 		if (tmp >> 32) {
 			pr_err("EFI data located above 4GB, disabling EFI.\n");
@@ -631,6 +666,61 @@ static int __init efi_memmap_init(void)
 	return 0;
 }
 
+/*
+ * For kexec kernel there's some special config table entries which could be
+ * converted to virtual addresses after entering virtual mode. In kexec kernel
+ * we need the physical addresses instead, thus passing them via setup_data
+ * and update the entries to physical addresses in this function.
+ *
+ * Currently only handles smbios which is necessary for HP z420.
+ */
+static int __init efi_reuse_config(u64 tables, int nr_tables)
+{
+	int i, sz, ret = 0;
+	void *p, *tablep;
+	struct efi_setup_data *data;
+
+	if (!efi_setup)
+		return 0;
+
+	if (!efi_enabled(EFI_64BIT))
+		return 0;
+
+	data = early_memremap(efi_setup, sizeof(*data));
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (!data->smbios)
+		goto out_memremap;
+
+	sz = sizeof(efi_config_table_64_t);
+
+	p = tablep = early_memremap(tables, nr_tables * sz);
+	if (!p) {
+		pr_err("Could not map Configuration table!\n");
+		ret = -ENOMEM;
+		goto out_memremap;
+	}
+
+	for (i = 0; i < efi.systab->nr_tables; i++) {
+		efi_guid_t guid;
+
+		guid = ((efi_config_table_64_t *)p)->guid;
+
+		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
+			((efi_config_table_64_t *)p)->table = data->smbios;
+		p += sz;
+	}
+	early_memunmap(tablep, nr_tables * sz);
+
+out_memremap:
+	early_memunmap(data, sizeof(*data));
+out:
+	return ret;
+}
+
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
@@ -676,6 +766,8 @@ void __init efi_init(void)
 		efi.systab->hdr.revision >> 16,
 		efi.systab->hdr.revision & 0xffff, vendor);
 
+	efi_reuse_config(efi.systab->tables, efi.systab->nr_tables);
+
 	if (efi_config_init(arch_tables))
 		return;
 
@@ -886,6 +978,50 @@ out_krealloc:
 }
 
 /*
+ * Map efi regions which was passed via setup_data. The virt_addr is a fixed
+ * addr which was used in first kernel in case kexec boot.
+ */
+static int __init map_regions_fixed(void)
+{
+	int i, s, ret = 0;
+	u64 end, systab;
+	unsigned long size;
+	efi_memory_desc_t *md;
+	struct efi_setup_data *data;
+
+	s = sizeof(*data) + nr_efi_runtime_map * sizeof(data->map[0]);
+	data = early_memremap(efi_setup, s);
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	for (i = 0, md = data->map; i < nr_efi_runtime_map; i++, md++) {
+		efi_map_region_fixed(md); /* FIXME: add error handling */
+		size = md->num_pages << PAGE_SHIFT;
+		end = md->phys_addr + size;
+
+		systab = (u64) (unsigned long) efi_phys.systab;
+		if (md->phys_addr <= systab && systab < end) {
+			systab += md->virt_addr - md->phys_addr;
+			efi.systab = (efi_system_table_t *)(unsigned long)systab;
+		}
+		ret = save_runtime_map(md, i);
+		if (ret)
+			goto out_save_runtime;
+	}
+
+	early_memunmap(data, s);
+	return 0;
+
+out_save_runtime:
+	kfree(efi_runtime_map);
+	nr_efi_runtime_map = 0;
+	early_memunmap(data, s);
+out:
+	return ret;
+}
+
+/*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, we look through the EFI memmap and map every region that
  * has the runtime attribute bit set in its memory descriptor into the
@@ -901,12 +1037,16 @@ out_krealloc:
  * so that we're in a different address space when calling a runtime
  * function. For function arguments passing we do copy the PGDs of the
  * kernel page table into ->trampoline_pgd prior to each call.
+ *
+ * Specially for kexec boot, efi runtime maps in previous kernel should
+ * be passed in via setup_data. In that case runtime ranges will be mapped
+ * to the same virtual addresses exactly same as the ones in previous kernel.
  */
 void __init efi_enter_virtual_mode(void)
 {
 	efi_status_t status;
 	void *new_memmap = NULL;
-	int count = 0;
+	int err, count = 0;
 
 	efi.systab = NULL;
 
@@ -919,12 +1059,19 @@ void __init efi_enter_virtual_mode(void)
 		return;
 	}
 
-	efi_merge_regions();
-
-	new_memmap = efi_map_regions(&count);
-	if (!new_memmap) {
-		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
-		return;
+	if (efi_setup) {
+		err = map_regions_fixed();
+		if (err) {
+			pr_err("Error mapping runtime services, EFI runtime non-functional!\n");
+			return;
+		}
+	} else {
+		efi_merge_regions();
+		new_memmap = efi_map_regions(&count);
+		if (!new_memmap) {
+			pr_err("Error reallocating memory, EFI runtime non-functional!\n");
+			return;
+		}
 	}
 
 	BUG_ON(!efi.systab);
@@ -932,16 +1079,18 @@ void __init efi_enter_virtual_mode(void)
 	efi_setup_page_tables();
 	efi_sync_low_kernel_mappings();
 
-	status = phys_efi_set_virtual_address_map(
-		memmap.desc_size * count,
-		memmap.desc_size,
-		memmap.desc_version,
-		(efi_memory_desc_t *)__pa(new_memmap));
-
-	if (status != EFI_SUCCESS) {
-		pr_alert("Unable to switch EFI into virtual mode "
-			 "(status=%lx)!\n", status);
-		panic("EFI call to SetVirtualAddressMap() failed!");
+	if (!efi_setup) {
+		status = phys_efi_set_virtual_address_map(
+			memmap.desc_size * count,
+			memmap.desc_size,
+			memmap.desc_version,
+			(efi_memory_desc_t *)__pa(new_memmap));
+
+		if (status != EFI_SUCCESS) {
+			pr_alert("Unable to switch EFI into virtual mode (status=%lx)!\n",
+				 status);
+			panic("EFI call to SetVirtualAddressMap() failed!");
+		}
 	}
 
 	/*
_

Patches currently in -mm which might be from dyoung@redhat.com are

kexec-migrate-to-reboot-cpu.patch
x86-mm-sparse-warning-fix-for-early_memremap.patch
efi-use-early_memremap-and-early_memunmap.patch
efi-remove-unused-variables-in-__map_region.patch
efi-add-a-wrapper-function-efi_map_region_fixed.patch
efi-reserve-boot-service-fix.patch
efi-cleanup-efi_enter_virtual_mode-function.patch
efi-export-more-efi-table-variable-to-sysfs.patch
efi-export-efi-runtime-memory-mapping-to-sysfs.patch
efi-pass-kexec-necessary-efi-data-via-setup_data.patch
efi-only-print-saved-efi-runtime-maps-instead-of-all-memmap-ranges-for-kexec.patch
x86-add-xloadflags-bit-for-efi-runtime-support-on-kexec.patch
x86-export-x86-boot_params-to-sysfs.patch
x86-reserve-setup_data-ranges-late-after-parsing-memmap-cmdline.patch
x86-kdebugfs-do-not-use-__va-for-getting-setup_data-virt-addr.patch

