From: akpm@linux-foundation.org
Subject: [merged] include-asm-generic-pageh-calculate-virt_to_page-and-page_to_virt-via-predefined-macro.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:25 -0700
Message-ID: <201111012110.pA1LAPCT017216@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15708 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1KAVKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sonic.zhang@analog.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/asm-generic/page.h: calculate virt_to_page and page_to_virt via predefined macro
has been removed from the -mm tree.  Its filename was
     include-asm-generic-pageh-calculate-virt_to_page-and-page_to_virt-via-predefined-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sonic Zhang <sonic.zhang@analog.com>
Subject: include/asm-generic/page.h: calculate virt_to_page and page_to_virt via predefined macro

On NOMMU architectures, if physical memory doesn't start from 0,
ARCH_PFN_OFFSET is defined to generate page index in mem_map array. 
Because virtual address is equal to physical address, PAGE_OFFSET is
always 0.  virt_to_page and page_to_virt should not index page by
PAGE_OFFSET directly.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/page.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/page.h~include-asm-generic-pageh-calculate-virt_to_page-and-page_to_virt-via-predefined-macro include/asm-generic/page.h
--- a/include/asm-generic/page.h~include-asm-generic-pageh-calculate-virt_to_page-and-page_to_virt-via-predefined-macro
+++ a/include/asm-generic/page.h
@@ -79,8 +79,8 @@ extern unsigned long memory_end;
 #define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_virt(pfn)	__va((pfn) << PAGE_SHIFT)
 
-#define virt_to_page(addr)	(mem_map + (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT))
-#define page_to_virt(page)	((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET)
+#define virt_to_page(addr)	pfn_to_page(virt_to_pfn(addr))
+#define page_to_virt(page)	pfn_to_virt(page_to_pfn(page))
 
 #ifndef page_to_phys
 #define page_to_phys(page)      ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch
linux-next.patch

