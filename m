From: akpm@linux-foundation.org
Subject: + alpha-fix-two-section-mismatch-warnings.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:36:57 -0700
Message-ID: <200707290736.l6T7avlb013981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759824AbXG2HhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: fix two section mismatch warnings
has been added to the -mm tree.  Its filename is
     alpha-fix-two-section-mismatch-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alpha: fix two section mismatch warnings
From: Sam Ravnborg <sam@ravnborg.org>

Fix the following section mismatch warnings:

WARNING: o-alpha/vmlinux.o(.text+0x1a4d4): Section mismatch: reference to .init.text:free_area_init (between 'paging_init' and 'srm_paging_stop')
WARNING: o-alpha/vmlinux.o(.text+0x1a4dc): Section mismatch: reference to .init.text:free_area_init (between 'paging_init' and 'srm_paging_stop')

One instance of paging_init() was declared __init but not the other one -
used by defconfig.  Fixed by declaring the second instance ___init too.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/alpha/mm/init.c~alpha-fix-two-section-mismatch-warnings arch/alpha/mm/init.c
--- a/arch/alpha/mm/init.c~alpha-fix-two-section-mismatch-warnings
+++ a/arch/alpha/mm/init.c
@@ -267,8 +267,7 @@ callback_init(void * kernel_end)
 /*
  * paging_init() sets up the memory map.
  */
-void
-paging_init(void)
+void __init paging_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES] = {0, };
 	unsigned long dma_pfn, high_pfn;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
alpha-fix-two-section-mismatch-warnings.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
mkmakefile-include-arch-on-o=-builds.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
x86-add-cpu-codenames-for-kconfigcpu.patch
change-order-in-kconfigcpu-i386.patch
whitelist-references-from-__dbe_table-to-init.patch
broken-lilo-check-on-make-install.patch
kconfig-remove-top-level-menu-code-maturity-level-options.patch
