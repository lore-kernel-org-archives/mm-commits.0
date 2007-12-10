From: akpm@linux-foundation.org
Subject: - rename-_bss-to-__bss_start.patch removed from -mm tree
Date: Mon, 10 Dec 2007 15:22:19 -0800
Message-ID: <200712102322.lBANMJXX024327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbXLJXWy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 18:22:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: rename _bss to __bss_start
has been removed from the -mm tree.  Its filename was
     rename-_bss-to-__bss_start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: rename _bss to __bss_start
From: Bernhard Walle <bwalle@suse.de>

Rename _bss to __bss_start as on other architectures.  That makes it
possible to use the <linux/sections.h> instead of own declarations.  Also
add __bss_stop because that symbol exists on other architectures.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/sim/boot/bootloader.lds |    3 ++-
 arch/ia64/kernel/setup.c             |    3 +--
 arch/ia64/kernel/vmlinux.lds.S       |    3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/ia64/hp/sim/boot/bootloader.lds~rename-_bss-to-__bss_start arch/ia64/hp/sim/boot/bootloader.lds
--- a/arch/ia64/hp/sim/boot/bootloader.lds~rename-_bss-to-__bss_start
+++ a/arch/ia64/hp/sim/boot/bootloader.lds
@@ -22,10 +22,11 @@ SECTIONS
   .sdata     : { *(.sdata) }
   _edata  =  .;
 
-  _bss = .;
+  __bss_start = .;
   .sbss      : { *(.sbss) *(.scommon) }
   .bss       : { *(.bss) *(COMMON) }
   . = ALIGN(64 / 8);
+  __bss_stop = .;
   _end = . ;
 
   /* Stabs debugging sections.  */
diff -puN arch/ia64/kernel/setup.c~rename-_bss-to-__bss_start arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~rename-_bss-to-__bss_start
+++ a/arch/ia64/kernel/setup.c
@@ -95,7 +95,6 @@ static struct resource bss_resource = {
 	.name	= "Kernel bss",
 	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
 };
-extern char _text[], _end[], _etext[], _edata[], _bss[];
 
 unsigned long ia64_max_cacheline_size;
 
@@ -206,7 +205,7 @@ static int __init register_memory(void)
 	code_resource.end   = ia64_tpa(_etext) - 1;
 	data_resource.start = ia64_tpa(_etext);
 	data_resource.end   = ia64_tpa(_edata) - 1;
-	bss_resource.start  = ia64_tpa(_bss);
+	bss_resource.start  = ia64_tpa(__bss_start);
 	bss_resource.end    = ia64_tpa(_end) - 1;
 	efi_initialize_iomem_resources(&code_resource, &data_resource,
 			&bss_resource);
diff -puN arch/ia64/kernel/vmlinux.lds.S~rename-_bss-to-__bss_start arch/ia64/kernel/vmlinux.lds.S
--- a/arch/ia64/kernel/vmlinux.lds.S~rename-_bss-to-__bss_start
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -240,11 +240,12 @@ SECTIONS
   .sdata : AT(ADDR(.sdata) - LOAD_OFFSET)
 	{ *(.sdata) *(.sdata1) *(.srdata) }
   _edata  =  .;
-  _bss = .;
+  __bss_start = .;
   .sbss : AT(ADDR(.sbss) - LOAD_OFFSET)
 	{ *(.sbss) *(.scommon) }
   .bss : AT(ADDR(.bss) - LOAD_OFFSET)
 	{ *(.bss) *(COMMON) }
+  __bss_stop = .;
 
   _end = .;
 
_

Patches currently in -mm which might be from bwalle@suse.de are

git-ia64.patch
git-x86.patch
introduce-flags-for-reserve_bootmem.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
use-bootmem_exclusive-for-kdump.patch
