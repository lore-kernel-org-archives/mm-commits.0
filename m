From: akpm@linux-foundation.org
Subject: + x86_64-fix-section-mismatch-warning-in-initc.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:52:19 -0700
Message-ID: <200707202152.l6KLqJJ0018377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660AbXGTVw1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:52:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org


The patch titled
     x86_64: fix section mismatch warning in init.c
has been added to the -mm tree.  Its filename is
     x86_64-fix-section-mismatch-warning-in-initc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: fix section mismatch warning in init.c
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.text+0x188ea): Section mismatch: reference to .init.text:__alloc_bootmem_core (between 'alloc_bootmem_high_node' and 'get_gate_vma')

alloc_bootmem_high_node() is only used from __init scope so declare it __init.
And in addition declare the weak variant __init too.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/init.c |    2 +-
 mm/sparse.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/mm/init.c~x86_64-fix-section-mismatch-warning-in-initc arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~x86_64-fix-section-mismatch-warning-in-initc
+++ a/arch/x86_64/mm/init.c
@@ -724,7 +724,7 @@ int in_gate_area_no_task(unsigned long a
 	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
 }
 
-void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+void * __init alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
 {
 	return __alloc_bootmem_core(pgdat->bdata, size,
 			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
diff -puN mm/sparse.c~x86_64-fix-section-mismatch-warning-in-initc mm/sparse.c
--- a/mm/sparse.c~x86_64-fix-section-mismatch-warning-in-initc
+++ a/mm/sparse.c
@@ -214,7 +214,7 @@ static int __meminit sparse_init_one_sec
 	return 1;
 }
 
-__attribute__((weak))
+__attribute__((weak)) __init
 void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
 {
 	return NULL;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
mkmakefile-include-arch-on-o=-builds.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
x86_64-fix-section-mismatch-warning-in-hpetc.patch
x86_64-fix-section-mismatch-warning-in-initc.patch
whitelist-references-from-__dbe_table-to-init.patch
broken-lilo-check-on-make-install.patch
console-fix-section-mismatch-warning-in-vgaconc.patch
