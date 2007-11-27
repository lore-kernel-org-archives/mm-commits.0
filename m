From: akpm@linux-foundation.org
Subject: + x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch added to -mm tree
Date: Tue, 27 Nov 2007 02:03:15 -0800
Message-ID: <200711271003.lARA3FGN006001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757900AbXK0KEf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 05:04:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@suse.de, mingo@elte.hu, mouli@linux.intel.com, tglx@linutronix.de


The patch titled
     x86_64 EFI runtime service support: document for EFI runtime services
has been added to the -mm tree.  Its filename is
     x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 EFI runtime service support: document for EFI runtime services
From: "Huang, Ying" <ying.huang@intel.com>

This patch adds document for EFI x86_64 runtime services support.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    9 ++++++++-
 Documentation/x86_64/uefi.txt         |    9 +++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff -puN Documentation/x86_64/boot-options.txt~x86_64-efi-runtime-service-support-document-for-efi-runtime-services Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86_64-efi-runtime-service-support-document-for-efi-runtime-services
+++ a/Documentation/x86_64/boot-options.txt
@@ -110,7 +110,7 @@ Idle loop
 
 Rebooting
 
-   reboot=b[ios] | t[riple] | k[bd] | a[cpi] [, [w]arm | [c]old]
+   reboot=b[ios] | t[riple] | k[bd] | a[cpi] | e[fi] [, [w]arm | [c]old]
    bios	  Use the CPU reboot vector for warm reset
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
@@ -119,6 +119,9 @@ Rebooting
    acpi   Use the ACPI RESET_REG in the FADT. If ACPI is not configured or the
           ACPI reset does not work, the reboot path attempts the reset using
           the keyboard controller.
+   efi    Use efi reset_system runtime service. If EFI is not configured or the
+          EFI reset does not work, the reboot path attempts the reset using
+          the keyboard controller.
 
    Using warm reset will be much faster especially on big memory
    systems because the BIOS will not go through the memory check.
@@ -303,4 +306,8 @@ Debugging
 		newfallback: use new unwinder but fall back to old if it gets
 			stuck (default)
 
+EFI
+
+  noefi		Disable EFI support
+
 Miscellaneous
diff -puN Documentation/x86_64/uefi.txt~x86_64-efi-runtime-service-support-document-for-efi-runtime-services Documentation/x86_64/uefi.txt
--- a/Documentation/x86_64/uefi.txt~x86_64-efi-runtime-service-support-document-for-efi-runtime-services
+++ a/Documentation/x86_64/uefi.txt
@@ -19,6 +19,10 @@ Mechanics:
 - Build the kernel with the following configuration.
 	CONFIG_FB_EFI=y
 	CONFIG_FRAMEBUFFER_CONSOLE=y
+  If EFI runtime services are expected, the following configuration should
+  be selected.
+	CONFIG_EFI=y
+	CONFIG_EFI_VARS=y or m		# optional
 - Create a VFAT partition on the disk
 - Copy the following to the VFAT partition:
 	elilo bootloader with x86_64 support, elilo configuration file,
@@ -27,3 +31,8 @@ Mechanics:
 	can be found in the elilo sourceforge project.
 - Boot to EFI shell and invoke elilo choosing the kernel image built
   in first step.
+- If some or all EFI runtime services don't work, you can try following
+  kernel command line parameters to turn off some or all EFI runtime
+  services.
+	noefi		turn off all EFI runtime services
+	reboot_type=k	turn off EFI reboot runtime service
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-boot-document.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
