From: akpm@linux-foundation.org
Subject: [merged] avr32-convert-to-asm-generic-memory_modelh.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:32 -0800
Message-ID: <569e98ec.uiYP+0i1LiC6bLCJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbcASUNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32: convert to asm-generic/memory_model.h
has been removed from the -mm tree.  Its filename was
     avr32-convert-to-asm-generic-memory_modelh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: avr32: convert to asm-generic/memory_model.h

Switch avr32/include/asm/page.h to use the common defintions for
pfn_to_page(), page_to_pfn(), and ARCH_PFN_OFFSET.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/page.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/avr32/include/asm/page.h~avr32-convert-to-asm-generic-memory_modelh arch/avr32/include/asm/page.h
--- a/arch/avr32/include/asm/page.h~avr32-convert-to-asm-generic-memory_modelh
+++ a/arch/avr32/include/asm/page.h
@@ -83,11 +83,9 @@ static inline int get_order(unsigned lon
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 
-#define PHYS_PFN_OFFSET		(CONFIG_PHYS_OFFSET >> PAGE_SHIFT)
+#define ARCH_PFN_OFFSET		(CONFIG_PHYS_OFFSET >> PAGE_SHIFT)
 
-#define pfn_to_page(pfn)	(mem_map + ((pfn) - PHYS_PFN_OFFSET))
-#define page_to_pfn(page)	((unsigned long)((page) - mem_map) + PHYS_PFN_OFFSET)
-#define pfn_valid(pfn)		((pfn) >= PHYS_PFN_OFFSET && (pfn) < (PHYS_PFN_OFFSET + max_mapnr))
+#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && (pfn) < (ARCH_PFN_OFFSET + max_mapnr))
 #endif /* CONFIG_NEED_MULTIPLE_NODES */
 
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
@@ -101,4 +99,6 @@ static inline int get_order(unsigned lon
  */
 #define HIGHMEM_START		0x20000000UL
 
+#include <asm-generic/memory_model.h>
+
 #endif /* __ASM_AVR32_PAGE_H */
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch

