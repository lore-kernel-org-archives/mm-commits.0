From: akpm@linux-foundation.org
Subject: [merged] remove-remaining-bits-of-io_remap_page_range.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:19 -0700
Message-ID: <20120326192819.79CF8A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:49213 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2CZT2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:20 -0400
Received: by ggnd2 with SMTP id d2so830447ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javi.merino@arm.com, a-jacquiot@ti.com, jonas@southpole.se, linux@arm.linux.org.uk, monstr@monstr.eu, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: Remove remaining bits of io_remap_page_range()
has been removed from the -mm tree.  Its filename was
     remove-remaining-bits-of-io_remap_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Javi Merino" <javi.merino@arm.com>
Subject: Remove remaining bits of io_remap_page_range()

33bf561 ("feature removal of io_remap_page_range()") removed
io_remap_page_range(), but it is still included in some arch header files.
It has no in-tree users.

Signed-off-by: Javi Merino <javi.merino@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-nommu.h  |    1 -
 arch/c6x/include/asm/pgtable.h        |    3 ---
 arch/microblaze/include/asm/pgtable.h |    2 --
 arch/openrisc/include/asm/pgtable.h   |    1 -
 4 files changed, 7 deletions(-)

diff -puN arch/arm/include/asm/pgtable-nommu.h~remove-remaining-bits-of-io_remap_page_range arch/arm/include/asm/pgtable-nommu.h
--- a/arch/arm/include/asm/pgtable-nommu.h~remove-remaining-bits-of-io_remap_page_range
+++ a/arch/arm/include/asm/pgtable-nommu.h
@@ -79,7 +79,6 @@ extern unsigned int kobjsize(const void 
  * No page table caches to initialise.
  */
 #define pgtable_cache_init()	do { } while (0)
-#define io_remap_page_range	remap_page_range
 #define io_remap_pfn_range	remap_pfn_range
 
 
diff -puN arch/c6x/include/asm/pgtable.h~remove-remaining-bits-of-io_remap_page_range arch/c6x/include/asm/pgtable.h
--- a/arch/c6x/include/asm/pgtable.h~remove-remaining-bits-of-io_remap_page_range
+++ a/arch/c6x/include/asm/pgtable.h
@@ -73,9 +73,6 @@ extern unsigned long empty_zero_page;
 #define pgtable_cache_init()   do { } while (0)
 #define io_remap_pfn_range      remap_pfn_range
 
-#define io_remap_page_range(vma, vaddr, paddr, size, prot)		\
-		remap_pfn_range(vma, vaddr, (paddr) >> PAGE_SHIFT, size, prot)
-
 #include <asm-generic/pgtable.h>
 
 #endif /* _ASM_C6X_PGTABLE_H */
diff -puN arch/microblaze/include/asm/pgtable.h~remove-remaining-bits-of-io_remap_page_range arch/microblaze/include/asm/pgtable.h
--- a/arch/microblaze/include/asm/pgtable.h~remove-remaining-bits-of-io_remap_page_range
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -543,8 +543,6 @@ extern unsigned long iopa(unsigned long 
 /* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
 #define kern_addr_valid(addr)	(1)
 
-#define io_remap_page_range remap_page_range
