From: akpm@linux-foundation.org
Subject: - x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch removed from -mm tree
Date: Wed, 15 Aug 2007 16:17:53 -0700
Message-ID: <200708152317.l7FNHriH020123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46058 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933974AbXHOXSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:18:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, adurbin@google.com, ak@suse.de, mouli@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     x86_64 EFI runtime service support: document for EFI runtime services
has been removed from the -mm tree.  Its filename was
     x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: x86_64 EFI runtime service support: document for EFI runtime services
From: "Huang, Ying" <ying.huang@intel.com>

Add documentation for EFI x86_64 runtime services support.  The boot
parameters added are documented in

Documentation/i386/zero-page.txt. The boot options added are
documented in Documentation/x86_64/boot-options.txt.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Aaron Durbin <adurbin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/i386/zero-page.txt      |   21 ++++++++++++++++-----
 Documentation/x86_64/boot-options.txt |   10 +++++++++-
 2 files changed, 25 insertions(+), 6 deletions(-)

diff -puN Documentation/i386/zero-page.txt~x86_64-efi-runtime-service-support-document-for-efi-runtime-services Documentation/i386/zero-page.txt
--- a/Documentation/i386/zero-page.txt~x86_64-efi-runtime-service-support-document-for-efi-runtime-services
+++ a/Documentation/i386/zero-page.txt
@@ -41,11 +41,11 @@ Offset	Type		Description
  0xb0 - 0x13f		Free. Add more parameters here if you really need them.
  0x140- 0x1be		EDID_INFO Video mode setup
 
-0x1c4	unsigned long	EFI system table pointer
-0x1c8	unsigned long	EFI memory descriptor size
-0x1cc	unsigned long	EFI memory descriptor version
-0x1d0	unsigned long	EFI memory descriptor map pointer
-0x1d4	unsigned long	EFI memory descriptor map size
+0x1c4	unsigned long	EFI system table pointer*
+0x1c8	unsigned long	EFI memory descriptor size*
+0x1cc	unsigned long	EFI memory descriptor version*
+0x1d0	unsigned long	EFI memory descriptor map pointer*
+0x1d4	unsigned long	EFI memory descriptor map size*
 0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
 0x1e4	unsigned long	Scratch field for the kernel setup code
 0x1e8	char		number of entries in E820MAP (below)
@@ -97,3 +97,14 @@ Offset	Type		Description
 0x2d0 - 0xd00		E820MAP
 0xd00 - 0xeff		EDDBUF (edd.S) for disk signature read sector
 0xd00 - 0xeeb		EDDBUF (edd.S) for edd data
+
+Changes for x86_64 implementation:
+---------------------------------
+For alignment purposes, the following parameters are rearranged.
+
+0x1c0	4 bytes		EFI Loader signature, ="EFIL"
+0x1c4	unsigned long	EFI memory descriptor size
+0x1c8	unsigned long	EFI memory descriptor version
+0x1cc	unsigned long	EFI memory descriptor map size
+0x1d0	8 bytes		EFI memory descriptor map pointer
+0x1d8	8 bytes		EFI system table pointer
diff -puN Documentation/x86_64/boot-options.txt~x86_64-efi-runtime-service-support-document-for-efi-runtime-services Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86_64-efi-runtime-service-support-document-for-efi-runtime-services
+++ a/Documentation/x86_64/boot-options.txt
@@ -110,12 +110,13 @@ Idle loop
 
 Rebooting
 
-   reboot=b[ios] | t[riple] | k[bd] | a[cpi] [, [w]arm | [c]old]
+   reboot=b[ios] | t[riple] | k[bd] | e[fi] | a[cpi] [, [w]arm | [c]old]
    bios	  Use the CPU reboot vector for warm reset
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
+   efi	  Use efi reset_system runtime service. cold reset (default)
    acpi   Use the ACPI RESET_REG in the FADT. If ACPI is not configured or the
           ACPI reset does not work, the reboot path attempts the reset using
           the keyboard controller.
@@ -303,4 +304,11 @@ Debugging
 		newfallback: use new unwinder but fall back to old if it gets
 			stuck (default)
 
+EFI
+
+  noefi		Disable EFI support
+
+  noefi_time	Disable EFI time runtime service, programming CMOS
+  		hardware directly
+
 Miscellaneous
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-boot-support-efi-frame-buffer-driver.patch
x86_64-efi-boot-support-efi-boot-document.patch
