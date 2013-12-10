From: akpm@linux-foundation.org
Subject: + efi-use-early_memremap-and-early_memunmap.patch added to -mm
 tree
Date: Tue, 10 Dec 2013 15:23:06 -0800
Message-ID: <52a7a25a.99WizaWhXGH62EiI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3LJXXI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:23:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, toshi.kani@hp.com, tglx@linutronix.de, mjg59@srcf.ucam.org, mingo@elte.hu, matt@console-pimps.org, hpa@zytor.com, horms@verge.net.au, greg@kroah.com, ebiederm@xmission.com, bp@suse.de, James.Bottomley@HansenPartnership.com, dyoung@redhat.com

Subject: + efi-use-early_memremap-and-early_memunmap.patch added to -mm tree
To: dyoung@redhat.com,James.Bottomley@HansenPartnership.com,bp@suse.de,ebiederm@xmission.com,greg@kroah.com,horms@verge.net.au,hpa@zytor.com,matt@console-pimps.org,mingo@elte.hu,mjg59@srcf.ucam.org,tglx@linutronix.de,toshi.kani@hp.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:23:06 -0800


The patch titled
     Subject: efi: use early_memremap and early_memunmap
has been added to the -mm tree.  Its filename is
     efi-use-early_memremap-and-early_memunmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-use-early_memremap-and-early_memunmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-use-early_memremap-and-early_memunmap.patch

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
Subject: efi: use early_memremap and early_memunmap

In arch/x86/platform/efi/efi.c and drivers/firmware/efi/efi.c turn to use
early_memremap/early_memunmap instead of early_ioremap/early_iounmap so
sparse will be happy.

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

 arch/x86/platform/efi/efi.c |   20 ++++++++++----------
 drivers/firmware/efi/efi.c  |    4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN arch/x86/platform/efi/efi.c~efi-use-early_memremap-and-early_memunmap arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~efi-use-early_memremap-and-early_memunmap
+++ a/arch/x86/platform/efi/efi.c
@@ -456,7 +456,7 @@ void __init efi_unmap_memmap(void)
 {
 	clear_bit(EFI_MEMMAP, &x86_efi_facility);
 	if (memmap.map) {
-		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
+		early_memunmap(memmap.map, memmap.nr_map * memmap.desc_size);
 		memmap.map = NULL;
 	}
 }
@@ -493,7 +493,7 @@ static int __init efi_systab_init(void *
 		efi_system_table_64_t *systab64;
 		u64 tmp = 0;
 
-		systab64 = early_ioremap((unsigned long)phys,
+		systab64 = early_memremap((unsigned long)phys,
 					 sizeof(*systab64));
 		if (systab64 == NULL) {
 			pr_err("Couldn't map the system table!\n");
@@ -524,7 +524,7 @@ static int __init efi_systab_init(void *
 		efi_systab.tables = systab64->tables;
 		tmp |= systab64->tables;
 
-		early_iounmap(systab64, sizeof(*systab64));
+		early_memunmap(systab64, sizeof(*systab64));
 #ifdef CONFIG_X86_32
 		if (tmp >> 32) {
 			pr_err("EFI data located above 4GB, disabling EFI.\n");
@@ -534,7 +534,7 @@ static int __init efi_systab_init(void *
 	} else {
 		efi_system_table_32_t *systab32;
 
-		systab32 = early_ioremap((unsigned long)phys,
+		systab32 = early_memremap((unsigned long)phys,
 					 sizeof(*systab32));
 		if (systab32 == NULL) {
 			pr_err("Couldn't map the system table!\n");
@@ -555,7 +555,7 @@ static int __init efi_systab_init(void *
 		efi_systab.nr_tables = systab32->nr_tables;
 		efi_systab.tables = systab32->tables;
 
-		early_iounmap(systab32, sizeof(*systab32));
+		early_memunmap(systab32, sizeof(*systab32));
 	}
 
 	efi.systab = &efi_systab;
@@ -586,7 +586,7 @@ static int __init efi_runtime_init(void)
 	 * address of several of the EFI runtime functions, needed to
 	 * set the firmware into virtual mode.
 	 */
-	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+	runtime = early_memremap((unsigned long)efi.systab->runtime,
 				sizeof(efi_runtime_services_t));
 	if (!runtime) {
 		pr_err("Could not map the runtime service table!\n");
@@ -606,7 +606,7 @@ static int __init efi_runtime_init(void)
 	 * virtual mode.
 	 */
 	efi.get_time = phys_efi_get_time;
-	early_iounmap(runtime, sizeof(efi_runtime_services_t));
+	early_memunmap(runtime, sizeof(efi_runtime_services_t));
 
 	return 0;
 }
@@ -614,7 +614,7 @@ static int __init efi_runtime_init(void)
 static int __init efi_memmap_init(void)
 {
 	/* Map the EFI memory map */
-	memmap.map = early_ioremap((unsigned long)memmap.phys_map,
+	memmap.map = early_memremap((unsigned long)memmap.phys_map,
 				   memmap.nr_map * memmap.desc_size);
 	if (memmap.map == NULL) {
 		pr_err("Could not map the memory map!\n");
@@ -656,14 +656,14 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
-	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
+	c16 = tmp = early_memremap(efi.systab->fw_vendor, 2);
 	if (c16) {
 		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
 		pr_err("Could not map the firmware vendor!\n");
-	early_iounmap(tmp, 2);
+	early_memunmap(tmp, 2);
 
 	pr_info("EFI v%u.%.02u by %s\n",
 		efi.systab->hdr.revision >> 16,
diff -puN drivers/firmware/efi/efi.c~efi-use-early_memremap-and-early_memunmap drivers/firmware/efi/efi.c
--- a/drivers/firmware/efi/efi.c~efi-use-early_memremap-and-early_memunmap
+++ a/drivers/firmware/efi/efi.c
@@ -253,7 +253,7 @@ int __init efi_config_init(efi_config_ta
 			if (table64 >> 32) {
 				pr_cont("\n");
 				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_iounmap(config_tables,
+				early_memunmap(config_tables,
 					       efi.systab->nr_tables * sz);
 				return -EINVAL;
 			}
@@ -269,6 +269,6 @@ int __init efi_config_init(efi_config_ta
 		tablep += sz;
 	}
 	pr_cont("\n");
-	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+	early_memunmap(config_tables, efi.systab->nr_tables * sz);
 	return 0;
 }
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

