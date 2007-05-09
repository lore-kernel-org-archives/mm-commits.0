From: akpm@linux-foundation.org
Subject: - efi-warn-only-for-pre-100-system-tables.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:04 -0700
Message-ID: <200705090250.l492o4uk009307@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968683AbXEICu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ak@suse.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     EFI: warn only for pre-1.00 system tables
has been removed from the -mm tree.  Its filename was
     efi-warn-only-for-pre-100-system-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: EFI: warn only for pre-1.00 system tables
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

We used to warn unless the EFI system table major revision was exactly 1. 
But EFI 2.00 firmware is starting to appear, and the 2.00 changes don't
affect anything in Linux.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/efi.c         |   12 +++++-------
 arch/ia64/hp/sim/boot/fw-emu.c |    2 +-
 arch/ia64/kernel/efi.c         |   10 +++++-----
 include/linux/efi.h            |    1 -
 4 files changed, 11 insertions(+), 14 deletions(-)

diff -puN arch/i386/kernel/efi.c~efi-warn-only-for-pre-100-system-tables arch/i386/kernel/efi.c
--- a/arch/i386/kernel/efi.c~efi-warn-only-for-pre-100-system-tables
+++ a/arch/i386/kernel/efi.c
@@ -347,14 +347,12 @@ void __init efi_init(void)
 		printk(KERN_ERR PFX "Woah! Couldn't map the EFI system table.\n");
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		printk(KERN_ERR PFX "Woah! EFI system table signature incorrect\n");
-	if ((efi.systab->hdr.revision ^ EFI_SYSTEM_TABLE_REVISION) >> 16 != 0)
-		printk(KERN_ERR PFX
-		       "Warning: EFI system table major version mismatch: "
-		       "got %d.%02d, expected %d.%02d\n",
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		printk(KERN_ERR PFX "Warning: EFI system table version "
+		       "%d.%02d, expected 1.00 or greater\n",
 		       efi.systab->hdr.revision >> 16,
-		       efi.systab->hdr.revision & 0xffff,
-		       EFI_SYSTEM_TABLE_REVISION >> 16,
-		       EFI_SYSTEM_TABLE_REVISION & 0xffff);
+		       efi.systab->hdr.revision & 0xffff);
+
 	/*
 	 * Grab some details from the system table
 	 */
diff -puN arch/ia64/hp/sim/boot/fw-emu.c~efi-warn-only-for-pre-100-system-tables arch/ia64/hp/sim/boot/fw-emu.c
--- a/arch/ia64/hp/sim/boot/fw-emu.c~efi-warn-only-for-pre-100-system-tables
+++ a/arch/ia64/hp/sim/boot/fw-emu.c
@@ -287,7 +287,7 @@ sys_fw_init (const char *args, int argle
 
 	memset(efi_systab, 0, sizeof(efi_systab));
 	efi_systab->hdr.signature = EFI_SYSTEM_TABLE_SIGNATURE;
-	efi_systab->hdr.revision  = EFI_SYSTEM_TABLE_REVISION;
+	efi_systab->hdr.revision  = ((1 << 16) | 00);
 	efi_systab->hdr.headersize = sizeof(efi_systab->hdr);
 	efi_systab->fw_vendor = __pa("H\0e\0w\0l\0e\0t\0t\0-\0P\0a\0c\0k\0a\0r\0d\0\0");
 	efi_systab->fw_revision = 1;
diff -puN arch/ia64/kernel/efi.c~efi-warn-only-for-pre-100-system-tables arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~efi-warn-only-for-pre-100-system-tables
+++ a/arch/ia64/kernel/efi.c
@@ -445,11 +445,11 @@ efi_init (void)
 		panic("Woah! Can't find EFI system table.\n");
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		panic("Woah! EFI system table signature incorrect\n");
-	if ((efi.systab->hdr.revision ^ EFI_SYSTEM_TABLE_REVISION) >> 16 != 0)
-		printk(KERN_WARNING "Warning: EFI system table major version mismatch: "
-		       "got %d.%02d, expected %d.%02d\n",
-		       efi.systab->hdr.revision >> 16, efi.systab->hdr.revision & 0xffff,
-		       EFI_SYSTEM_TABLE_REVISION >> 16, EFI_SYSTEM_TABLE_REVISION & 0xffff);
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		printk(KERN_WARNING "Warning: EFI system table version "
+		       "%d.%02d, expected 1.00 or greater\n",
+		       efi.systab->hdr.revision >> 16,
+		       efi.systab->hdr.revision & 0xffff);
 
 	config_tables = __va(efi.systab->tables);
 
diff -puN include/linux/efi.h~efi-warn-only-for-pre-100-system-tables include/linux/efi.h
--- a/include/linux/efi.h~efi-warn-only-for-pre-100-system-tables
+++ a/include/linux/efi.h
@@ -213,7 +213,6 @@ typedef struct {
 } efi_config_table_t;
 
 #define EFI_SYSTEM_TABLE_SIGNATURE ((u64)0x5453595320494249ULL)
-#define EFI_SYSTEM_TABLE_REVISION  ((1 << 16) | 00)
 
 typedef struct {
 	efi_table_hdr_t hdr;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
move-free-pages-between-lists-on-steal.patch
use-menuconfig-objects-pnp.patch
