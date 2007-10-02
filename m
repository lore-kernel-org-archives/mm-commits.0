From: akpm@linux-foundation.org
Subject: - x86_64-efi-boot-support-efi-boot-document.patch removed from -mm tree
Date: Tue, 02 Oct 2007 00:09:48 -0700
Message-ID: <200710020709.l9279mpw023364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbXJBHJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 03:09:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, adaplas@pol.net, ak@suse.de, mouli@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     x86_64 EFI boot support: EFI boot document
has been removed from the -mm tree.  Its filename was
     x86_64-efi-boot-support-efi-boot-document.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: x86_64 EFI boot support: EFI boot document
From: "Huang, Ying" <ying.huang@intel.com>

Add a document for EFI x86_64 boot support.  The setup and operation guide of
EFI based system is documented in Documentation/x86_64/uefi.txt.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/uefi.txt |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+)

diff -puN /dev/null Documentation/x86_64/uefi.txt
--- /dev/null
+++ a/Documentation/x86_64/uefi.txt
@@ -0,0 +1,29 @@
+General note on [U]EFI x86_64 support
+-------------------------------------
+
+The nomenclature EFI and UEFI are used interchangeably in this document.
+
+Although the tools below are _not_ needed for building the kernel,
+the needed bootloader support and associated tools for x86_64 platforms
+with EFI firmware and specifications are listed below.
+
+1. UEFI specification:  http://www.uefi.org
+
+2. Booting Linux kernel on UEFI x86_64 platform requires bootloader
+   support. Elilo with x86_64 support can be used.
+
+3. x86_64 platform with EFI/UEFI firmware.
+
+Mechanics:
+---------
+- Build the kernel with the following configuration.
+	CONFIG_FB_EFI=y
+	CONFIG_FRAMEBUFFER_CONSOLE=y
+- Create a VFAT partition on the disk
+- Copy the following to the VFAT partition:
+	elilo bootloader with x86_64 support, elilo configuration file,
+	kernel image built in first step and corresponding
+	initrd. Instructions on building elilo	and its dependencies
+	can be found in the elilo sourceforge project.
+- Boot to EFI shell and invoke elilo choosing the kernel image built
+  in first step.
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-nx-bit-handling-in-change_page_attr.patch
x86_64-efi-boot-support-efi-boot-document.patch
