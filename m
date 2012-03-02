From: akpm@linux-foundation.org
Subject: + remove-remaining-bits-of-io_remap_page_range.patch added to -mm tree
Date: Fri, 02 Mar 2012 14:39:39 -0800
Message-ID: <20120302223939.5F049A02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:63428 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965271Ab2CBWjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Mar 2012 17:39:41 -0500
Received: by qcsp5 with SMTP id p5so272874qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 02 Mar 2012 14:39:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: javi.merino@arm.com, a-jacquiot@ti.com, jonas@southpole.se, linux@arm.linux.org.uk, monstr@monstr.eu, rdunlap@xenotime.net


The patch titled
     Subject: Remove remaining bits of io_remap_page_range()
has been added to the -mm tree.  Its filename is
     remove-remaining-bits-of-io_remap_page_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
