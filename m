From: akpm@linux-foundation.org
Subject: + arches-drop-superfluous-casts-in-nr_free_pages-callers.patch added to -mm tree
Date: Tue, 04 Aug 2009 16:30:05 -0700
Message-ID: <200908042330.n74NU68Y000311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbZHDXhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 19:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, cl@linux-foundation.org, davem@davemloft.net, dhowells@redhat.com, hskinnemoen@atmel.com, ink@jurassic.park.msu.ru, kyle@mcmartin.ca, lethal@linux-sh.org, mingo@elte.hu, monstr@monstr.eu, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, rth@twiddle.net, schwidefsky@de.ibm.com, starvik@axis.com, takata@linux-m32r.org, tony.luck@intel.com, xiyou.wangcong@gmail.com, zankel@tensilica.com


The patch titled
     arches: drop superfluous casts in nr_free_pages() callers
has been added to the -mm tree.  Its filename is
     arches-drop-superfluous-casts-in-nr_free_pages-callers.patch

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
Subject: arches: drop superfluous casts in nr_free_pages() callers
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Commit 96177299416dbccb73b54e6b344260154a445375 ("Drop free_pages()")
modified nr_free_pages() to return 'unsigned long' instead of 'unsigned
int'.  This made the casts to 'unsigned long' in most callers superfluous,
so remove them.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Chris Zankel <zankel@tensilica.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/init.c      |    2 +-
 arch/alpha/mm/numa.c      |    2 +-
 arch/arm/mm/init.c        |    4 ++--
 arch/avr32/mm/init.c      |    2 +-
 arch/cris/mm/init.c       |    2 +-
 arch/ia64/mm/init.c       |    2 +-
 arch/m32r/mm/init.c       |    2 +-
 arch/m68k/mm/init.c       |    2 +-
 arch/microblaze/mm/init.c |    2 +-
 arch/mips/mm/init.c       |    2 +-
 arch/mn10300/mm/init.c    |    2 +-
 arch/parisc/mm/init.c     |    2 +-
 arch/powerpc/mm/mem.c     |    2 +-
 arch/s390/mm/init.c       |    2 +-
 arch/sh/mm/init.c         |    2 +-
 arch/sparc/mm/init_32.c   |    2 +-
 arch/um/kernel/mem.c      |    2 +-
 arch/x86/mm/init_32.c     |    2 +-
 arch/x86/mm/init_64.c     |    2 +-
 arch/xtensa/mm/init.c     |    2 +-
 20 files changed, 21 insertions(+), 21 deletions(-)

diff -puN arch/alpha/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/alpha/mm/init.c
--- a/arch/alpha/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/alpha/mm/init.c
@@ -299,7 +299,7 @@ printk_memory_info(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	printk("Memory: %luk/%luk available (%luk kernel code, %luk reserved, %luk data, %luk init)\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       max_mapnr << (PAGE_SHIFT-10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT-10),
diff -puN arch/alpha/mm/numa.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/alpha/mm/numa.c
@@ -349,7 +349,7 @@ void __init mem_init(void)
 
 	printk("Memory: %luk/%luk available (%luk kernel code, %luk reserved, "
 	       "%luk data, %luk init)\n",
-	       (unsigned long)nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       num_physpages << (PAGE_SHIFT-10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT-10),
diff -puN arch/arm/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/arm/mm/init.c
@@ -536,8 +536,8 @@ void __init mem_init(void)
 
 	printk(KERN_NOTICE "Memory: %luKB available (%dK code, "
 		"%dK data, %dK init, %luK highmem)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
-		codesize >> 10, datasize >> 10, initsize >> 10,
+		nr_free_pages() << (PAGE_SHIFT-10), codesize >> 10,
+		datasize >> 10, initsize >> 10,
 		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
 
 	if (PAGE_SIZE >= 16384 && num_physpages <= 128) {
diff -puN arch/avr32/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/avr32/mm/init.c
--- a/arch/avr32/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/avr32/mm/init.c
@@ -141,7 +141,7 @@ void __init mem_init(void)
 
 	printk ("Memory: %luk/%luk available (%dk kernel code, "
 		"%dk reserved, %dk data, %dk init)\n",
-		(unsigned long)nr_free_pages() << (PAGE_SHIFT - 10),
+		nr_free_pages() << (PAGE_SHIFT - 10),
 		totalram_pages << (PAGE_SHIFT - 10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT - 10),
diff -puN arch/cris/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/cris/mm/init.c
--- a/arch/cris/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/cris/mm/init.c
@@ -54,7 +54,7 @@ mem_init(void)
         printk(KERN_INFO
                "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, "
 	       "%dk init)\n" ,
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       max_mapnr << (PAGE_SHIFT-10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT-10),
diff -puN arch/ia64/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/ia64/mm/init.c
@@ -655,7 +655,7 @@ mem_init (void)
 	initsize =  (unsigned long) __init_end - (unsigned long) __init_begin;
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%luk code, %luk reserved, "
-	       "%luk data, %luk init)\n", (unsigned long) nr_free_pages() << (PAGE_SHIFT - 10),
+	       "%luk data, %luk init)\n", nr_free_pages() << (PAGE_SHIFT - 10),
 	       num_physpages << (PAGE_SHIFT - 10), codesize >> 10,
 	       reserved_pages << (PAGE_SHIFT - 10), datasize >> 10, initsize >> 10);
 
diff -puN arch/m32r/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/m32r/mm/init.c
@@ -171,7 +171,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 		"%dk reserved, %dk data, %dk init)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT-10),
diff -puN arch/m68k/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/m68k/mm/init.c
--- a/arch/m68k/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/m68k/mm/init.c
@@ -126,7 +126,7 @@ void __init mem_init(void)
 #endif
 
 	printk("Memory: %luk/%luk available (%dk kernel code, %dk data, %dk init)\n",
-	       (unsigned long)nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       totalram_pages << (PAGE_SHIFT-10),
 	       codepages << (PAGE_SHIFT-10),
 	       datapages << (PAGE_SHIFT-10),
diff -puN arch/microblaze/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/microblaze/mm/init.c
@@ -204,7 +204,7 @@ void __init mem_init(void)
 	totalram_pages += free_all_bootmem();
 
 	printk(KERN_INFO "Memory: %luk/%luk available\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       num_physpages << (PAGE_SHIFT-10));
 #ifdef CONFIG_MMU
 	mem_init_done = 1;
diff -puN arch/mips/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/mips/mm/init.c
@@ -417,7 +417,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 	       "%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       ram << (PAGE_SHIFT-10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT-10),
diff -puN arch/mn10300/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/mn10300/mm/init.c
--- a/arch/mn10300/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/mn10300/mm/init.c
@@ -112,7 +112,7 @@ void __init mem_init(void)
 	       "Memory: %luk/%luk available"
 	       " (%dk kernel code, %dk reserved, %dk data, %dk init,"
 	       " %ldk highmem)\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT - 10),
+	       nr_free_pages() << (PAGE_SHIFT - 10),
 	       max_mapnr << (PAGE_SHIFT - 10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT - 10),
diff -puN arch/parisc/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/parisc/mm/init.c
@@ -506,7 +506,7 @@ void __init mem_init(void)
 #endif
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init)\n",
-		(unsigned long)nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT-10),
diff -puN arch/powerpc/mm/mem.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/powerpc/mm/mem.c
@@ -372,7 +372,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%luk kernel code, "
 	       "%luk reserved, %luk data, %luk bss, %luk init)\n",
-		(unsigned long)nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT-10),
diff -puN arch/s390/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/s390/mm/init.c
@@ -105,7 +105,7 @@ void __init mem_init(void)
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
         printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, %ldk data, %ldk init)\n",
-                (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+                nr_free_pages() << (PAGE_SHIFT-10),
                 max_mapnr << (PAGE_SHIFT-10),
                 codesize >> 10,
                 reservedpages << (PAGE_SHIFT-10),
diff -puN arch/sh/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/sh/mm/init.c
@@ -224,7 +224,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 	       "%dk data, %dk init)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		datasize >> 10,
diff -puN arch/sparc/mm/init_32.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/sparc/mm/init_32.c
@@ -468,7 +468,7 @@ void __init mem_init(void)
 			reservedpages++;
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init, %ldk highmem)\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       num_physpages << (PAGE_SHIFT - 10),
 	       codepages << (PAGE_SHIFT-10),
 	       reservedpages << (PAGE_SHIFT - 10),
diff -puN arch/um/kernel/mem.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/um/kernel/mem.c
@@ -77,7 +77,7 @@ void __init mem_init(void)
 	num_physpages = totalram_pages;
 	max_pfn = totalram_pages;
 	printk(KERN_INFO "Memory: %luk available\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10));
+	       nr_free_pages() << (PAGE_SHIFT-10));
 	kmalloc_ok = 1;
 
 #ifdef CONFIG_HIGHMEM
diff -puN arch/x86/mm/init_32.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/x86/mm/init_32.c
@@ -892,7 +892,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
 			"%dk reserved, %dk data, %dk init, %ldk highmem)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
 		reservedpages << (PAGE_SHIFT-10),
diff -puN arch/x86/mm/init_64.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/x86/mm/init_64.c
@@ -687,7 +687,7 @@ void __init mem_init(void)
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
 			 "%ldk absent, %ldk reserved, %ldk data, %ldk init)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+		nr_free_pages() << (PAGE_SHIFT-10),
 		max_pfn << (PAGE_SHIFT-10),
 		codesize >> 10,
 		absent_pages << (PAGE_SHIFT-10),
diff -puN arch/xtensa/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~arches-drop-superfluous-casts-in-nr_free_pages-callers
+++ a/arch/xtensa/mm/init.c
@@ -203,7 +203,7 @@ void __init mem_init(void)
 
 	printk("Memory: %luk/%luk available (%ldk kernel code, %ldk reserved, "
 	       "%ldk data, %ldk init %ldk highmem)\n",
-	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       nr_free_pages() << (PAGE_SHIFT-10),
 	       ram << (PAGE_SHIFT-10),
 	       codesize >> 10,
 	       reservedpages << (PAGE_SHIFT-10),
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

arches-drop-superfluous-casts-in-nr_free_pages-callers.patch

