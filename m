From: akpm@linux-foundation.org
Subject: + efi-reserve-boot-service-fix.patch added to -mm tree
Date: Tue, 10 Dec 2013 15:23:12 -0800
Message-ID: <52a7a260.6fBwmA2U7h8AbjVW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3LJXXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:23:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, toshi.kani@hp.com, tglx@linutronix.de, mjg59@srcf.ucam.org, mingo@elte.hu, matt@console-pimps.org, hpa@zytor.com, horms@verge.net.au, greg@kroah.com, ebiederm@xmission.com, bp@suse.de, James.Bottomley@HansenPartnership.com, dyoung@redhat.com

Subject: + efi-reserve-boot-service-fix.patch added to -mm tree
To: dyoung@redhat.com,James.Bottomley@HansenPartnership.com,bp@suse.de,ebiederm@xmission.com,greg@kroah.com,horms@verge.net.au,hpa@zytor.com,matt@console-pimps.org,mingo@elte.hu,mjg59@srcf.ucam.org,tglx@linutronix.de,toshi.kani@hp.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:23:12 -0800


The patch titled
     Subject: efi: reserve boot service fix
has been added to the -mm tree.  Its filename is
     efi-reserve-boot-service-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-reserve-boot-service-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-reserve-boot-service-fix.patch

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
Subject: efi: reserve boot service fix

Current code check boot service region with kernel text region by:
start+size >= __pa_symbol(_text) The end of the above region should be
start + size - 1 instead.

I see this problem in ovmf + Fedora 19 grub boot: text start: 1000000 md
start: 800000 md size: 800000

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/efi/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/platform/efi/efi.c~efi-reserve-boot-service-fix arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~efi-reserve-boot-service-fix
+++ a/arch/x86/platform/efi/efi.c
@@ -438,7 +438,7 @@ void __init efi_reserve_boot_services(vo
 		 * - Not within any part of the kernel
 		 * - Not the bios reserved area
 		*/
-		if ((start+size >= __pa_symbol(_text)
+		if ((start + size > __pa_symbol(_text)
 				&& start <= __pa_symbol(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
 			memblock_is_region_reserved(start, size)) {
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

