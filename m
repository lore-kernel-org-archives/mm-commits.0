From: akpm@linux-foundation.org
Subject: +
 efi-only-print-saved-efi-runtime-maps-instead-of-all-memmap-ranges-for-kexec.patch added to -mm tree
Date: Tue, 10 Dec 2013 15:23:22 -0800
Message-ID: <52a7a26a.xiItp9xBpkYtEEC/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3LJXXX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:23:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, toshi.kani@hp.com, tglx@linutronix.de, mjg59@srcf.ucam.org, mingo@elte.hu, matt@console-pimps.org, hpa@zytor.com, horms@verge.net.au, greg@kroah.com, ebiederm@xmission.com, bp@suse.de, James.Bottomley@HansenPartnership.com, dyoung@redhat.com

Subject: + efi-only-print-saved-efi-runtime-maps-instead-of-all-memmap-ranges-for-kexec.patch added to -mm tree
To: dyoung@redhat.com,James.Bottomley@HansenPartnership.com,bp@suse.de,ebiederm@xmission.com,greg@kroah.com,horms@verge.net.au,hpa@zytor.com,matt@console-pimps.org,mingo@elte.hu,mjg59@srcf.ucam.org,tglx@linutronix.de,toshi.kani@hp.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:23:22 -0800


The patch titled
     Subject: efi: only print saved efi runtime maps instead of all memmap ranges for kexec
has been added to the -mm tree.  Its filename is
     efi-only-print-saved-efi-runtime-maps-instead-of-all-memmap-ranges-for-kexec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-only-print-saved-efi-runtime-maps-instead-of-all-memmap-ranges-for-kexec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-only-print-saved-efi-runtime-maps-instead-of-all-memmap-ranges-for-kexec.patch

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
Subject: efi: only print saved efi runtime maps instead of all memmap ranges for kexec

For kexec/kdump kernel efi runtime mappings are saved, printing original
whole memmap ranges does not make sense anymore.  So introduce a new
function to only print runtime maps in case kexec/kdump kernel is used.

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

 arch/x86/platform/efi/efi.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff -puN arch/x86/platform/efi/efi.c~efi-only-print-saved-efi-runtime-maps-instead-of-all-memmap-ranges-for-kexec arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~efi-only-print-saved-efi-runtime-maps-instead-of-all-memmap-ranges-for-kexec
+++ a/arch/x86/platform/efi/efi.c
@@ -423,19 +423,16 @@ int __init efi_memblock_x86_reserve_rang
 	return 0;
 }
 
-static void __init print_efi_memmap(void)
+static void __init print_efi_memmap(void *map, int nr_map, int md_size)
 {
 #ifdef EFI_DEBUG
 	efi_memory_desc_t *md;
 	void *p;
 	int i;
 
-	for (p = memmap.map, i = 0;
-	     p < memmap.map_end;
-	     p += memmap.desc_size, i++) {
+	for (p = map, i = 0; i < nr_map; p += md_size, i++) {
 		md = p;
-		pr_info("mem%02u: type=%u, attr=0x%llx, "
-			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
+		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
@@ -797,7 +794,20 @@ void __init efi_init(void)
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
 #endif
-	print_efi_memmap();
+	if (efi_setup) {
+		int s;
+		struct efi_setup_data *data;
+
+		s = sizeof(*data) + nr_efi_runtime_map * sizeof(data->map[0]);
+		data = early_memremap(efi_setup, s);
+		if (!data)
+			return;
+		print_efi_memmap(data->map, nr_efi_runtime_map,
+				 sizeof(data->map[0]));
+		early_memunmap(data, s);
+	} else {
+		print_efi_memmap(memmap.map, memmap.nr_map, memmap.desc_size);
+	}
 }
 
 void __init efi_late_init(void)
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

