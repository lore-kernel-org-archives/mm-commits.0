From: akpm@linux-foundation.org
Subject: [alternative-merged] x86-dmi_scan_machine-uses-uninitialized-address-on-x86-efi.patch removed from -mm tree
Date: Wed, 04 Mar 2009 23:31:37 -0800
Message-ID: <200903050731.n257VcHQ024913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335AbZCEHcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 02:32:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tjourdan@interfaceconcept.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: dmi_scan_machine uses uninitialized address on x86/EFI
has been removed from the -mm tree.  Its filename was
     x86-dmi_scan_machine-uses-uninitialized-address-on-x86-efi.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: dmi_scan_machine uses uninitialized address on x86/EFI
From: "Thomas Jourdan" <tjourdan@interfaceconcept.com>

On x86/EFI platforms, if efi_enabled is true, the dmi_scan_machine
function fails, even if valid DMI table is present.  In the setup_arch
function, efi_init is called after dmi_scan_machine.  But this is efi_init
which will initialize the smbios address, needed by dmi_scan_machine.

This leads to dmi_scan_machine ioremapping physical address 0, instead of
the address provided by the EFI system table.  The following patch fixes
the problem.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/setup.c~x86-dmi_scan_machine-uses-uninitialized-address-on-x86-efi arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-dmi_scan_machine-uses-uninitialized-address-on-x86-efi
+++ a/arch/x86/kernel/setup.c
@@ -783,6 +783,9 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
+	if (efi_enabled)
+		efi_init();
+
 	dmi_scan_machine();
 
 	dmi_check_system(bad_bios_dmi_table);
@@ -802,9 +805,6 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-	if (efi_enabled)
-		efi_init();
