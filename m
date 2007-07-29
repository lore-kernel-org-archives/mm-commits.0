From: akpm@linux-foundation.org
Subject: - x86_64-fix-section-mismatch-warnings-in-tce.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:25 -0700
Message-ID: <200707290612.l6T6CP21011124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759260AbXG2GXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix section mismatch warnings in tce
has been removed from the -mm tree.  Its filename was
     x86_64-fix-section-mismatch-warnings-in-tce.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix section mismatch warnings in tce
From: Sam Ravnborg <sam@ravnborg.org>

Fix the following two section mismatch warnings:

WARNING: vmlinux.o(.text+0x1ce84): Section mismatch: reference to .init.text:free_bootmem (between 'free_tce_table' and 'build_tce_table')
WARNING: vmlinux.o(.text+0x1d04d): Section mismatch: reference to .init.text:__alloc_bootmem_low (between 'alloc_tce_table' and 'kretprobe_trampoline_holder')

In both cases the functions was used only from __init
context so mark them __init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/tce.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/tce.c~x86_64-fix-section-mismatch-warnings-in-tce arch/x86_64/kernel/tce.c
--- a/arch/x86_64/kernel/tce.c~x86_64-fix-section-mismatch-warnings-in-tce
+++ a/arch/x86_64/kernel/tce.c
@@ -165,7 +165,7 @@ done:
 	return ret;
 }
 
-void* alloc_tce_table(void)
+void * __init alloc_tce_table(void)
 {
 	unsigned int size;
 
@@ -175,7 +175,7 @@ void* alloc_tce_table(void)
 	return __alloc_bootmem_low(size, size, 0);
 }
 
-void free_tce_table(void *tbl)
+void __init free_tce_table(void *tbl)
 {
 	unsigned int size;
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
mkmakefile-include-arch-on-o=-builds.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
whitelist-references-from-__dbe_table-to-init.patch
broken-lilo-check-on-make-install.patch
kconfig-remove-top-level-menu-code-maturity-level-options.patch
