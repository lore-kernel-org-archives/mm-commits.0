From: akpm@linux-foundation.org
Subject: + include-asm-generic-pageh-calculate-virt_to_page-and-page_to_virt-via-predefined-macro.patch added to -mm tree
Date: Wed, 24 Aug 2011 15:52:17 -0700
Message-ID: <201108242252.p7OMqHFa012133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab1HXWxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Aug 2011 18:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.zhang@analog.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@snapgear.com


The patch titled
     include/asm-generic/page.h: calculate virt_to_page and page_to_virt via predefined macro
has been added to the -mm tree.  Its filename is
     include-asm-generic-pageh-calculate-virt_to_page-and-page_to_virt-via-predefined-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/asm-generic/page.h: calculate virt_to_page and page_to_virt via predefined macro
From: Sonic Zhang <sonic.zhang@analog.com>

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

include-asm-generic-pageh-calculate-virt_to_page-and-page_to_virt-via-predefined-macro.patch

