From: akpm@linux-foundation.org
Subject: + include-asm-generic-pgtableh-fix-mips-build.patch added to -mm tree
Date: Mon, 14 Jan 2013 13:38:37 -0800
Message-ID: <20130114213838.1B3F820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f73.google.com ([209.85.214.73]:52378 "EHLO
	mail-bk0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab3ANVik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 16:38:40 -0500
Received: by mail-bk0-f73.google.com with SMTP id jf3so292871bkc.4
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 13:38:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aaro.koskinen@iki.fi, kirill@shutemov.name, ralf@linux-mips.org


The patch titled
     Subject: include/asm-generic/pgtable.h: fix MIPS build
has been added to the -mm tree.  Its filename is
     include-asm-generic-pgtableh-fix-mips-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-asm-generic-pgtableh-fix-mips-build.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
mm-huge_memory-use-new-hashtable-implementation.patch

