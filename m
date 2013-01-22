From: akpm@linux-foundation.org
Subject: [merged] include-asm-generic-pgtableh-fix-mips-build.patch removed from -mm tree
Date: Tue, 22 Jan 2013 13:23:14 -0800
Message-ID: <20130122212314.AEEE531C1BF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:46629 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3AVVXQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 16:23:16 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so228556qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 13:23:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aaro.koskinen@iki.fi, david.daney@cavium.com, kirill@shutemov.name, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/asm-generic/pgtable.h: fix MIPS build
has been removed from the -mm tree.  Its filename was
     include-asm-generic-pgtableh-fix-mips-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: include/asm-generic/pgtable.h: fix MIPS build

In file included from arch/mips/include/asm/pgtable.h:552,
                 from include/linux/mm.h:44,
                 from arch/mips/kernel/asm-offsets.c:14:
include/asm-generic/pgtable.h: In function `my_zero_pfn':
include/asm-generic/pgtable.h:466: error: implicit declaration of function page_to_section

Due header files inter-dependencies, the only way I see to fix it is
convert my_zero_pfn() for __HAVE_COLOR_ZERO_PAGE to macros.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/pgtable.h~include-asm-generic-pgtableh-fix-mips-build include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~include-asm-generic-pgtableh-fix-mips-build
+++ a/include/asm-generic/pgtable.h
@@ -461,10 +461,8 @@ static inline int is_zero_pfn(unsigned l
 	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
 }
 
-static inline unsigned long my_zero_pfn(unsigned long addr)
-{
-	return page_to_pfn(ZERO_PAGE(addr));
-}
+#define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
+
 #else
 static inline int is_zero_pfn(unsigned long pfn)
 {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-avoid-dumping-huge-zero-page.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
mm-huge_memory-use-new-hashtable-implementation.patch

