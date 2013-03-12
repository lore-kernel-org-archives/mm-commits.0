From: akpm@linux-foundation.org
Subject: + mm-alpha-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:16 -0700
Message-ID: <20130312212216.D160C5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:50220 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab3CLVWS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:18 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so38334ves.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, ink@jurassic.park.msu.ru, jiang.liu@huawei.com, mattst88@gmail.com, rth@twiddle.net


The patch titled
     Subject: mm/alpha: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-alpha-use-common-help-functions-to-free-reserved-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/alpha: use common help functions to free reserved pages

Use common help functions to free reserved pages.  Also include
<asm/sections.h> to avoid local declarations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/sys_nautilus.c |    5 ++---
 arch/alpha/mm/init.c             |   24 +++---------------------
 arch/alpha/mm/numa.c             |    3 +--
 3 files changed, 6 insertions(+), 26 deletions(-)

diff -puN arch/alpha/kernel/sys_nautilus.c~mm-alpha-use-common-help-functions-to-free-reserved-pages arch/alpha/kernel/sys_nautilus.c
--- a/arch/alpha/kernel/sys_nautilus.c~mm-alpha-use-common-help-functions-to-free-reserved-pages
+++ a/arch/alpha/kernel/sys_nautilus.c
@@ -185,7 +185,6 @@ nautilus_machine_check(unsigned long vec
 	mb();
 }
 
-extern void free_reserved_mem(void *, void *);
 extern void pcibios_claim_one_bus(struct pci_bus *);
 
 static struct resource irongate_mem = {
@@ -234,8 +233,8 @@ nautilus_init_pci(void)
 	if (pci_mem < memtop)
 		memtop = pci_mem;
 	if (memtop > alpha_mv.min_mem_address) {
-		free_reserved_mem(__va(alpha_mv.min_mem_address),
-				  __va(memtop));
+		free_reserved_area((unsigned long)__va(alpha_mv.min_mem_address),
+				   (unsigned long)__va(memtop), 0, NULL);
 		printk("nautilus_init_pci: %ldk freed\n",
 			(memtop - alpha_mv.min_mem_address) >> 10);
 	}
diff -puN arch/alpha/mm/init.c~mm-alpha-use-common-help-functions-to-free-reserved-pages arch/alpha/mm/init.c
--- a/arch/alpha/mm/init.c~mm-alpha-use-common-help-functions-to-free-reserved-pages
+++ a/arch/alpha/mm/init.c
@@ -31,6 +31,7 @@
 #include <asm/console.h>
 #include <asm/tlb.h>
 #include <asm/setup.h>
+#include <asm/sections.h>
 
 extern void die_if_kernel(char *,struct pt_regs *,long);
 
@@ -281,8 +282,6 @@ printk_memory_info(void)
 {
 	unsigned long codesize, reservedpages, datasize, initsize, tmp;
 	extern int page_is_ram(unsigned long) __init;
-	extern char _text, _etext, _data, _edata;
-	extern char __init_begin, __init_end;
 
 	/* printk all informations */
 	reservedpages = 0;
@@ -318,32 +317,15 @@ mem_init(void)
 #endif /* CONFIG_DISCONTIGMEM */
 
 void
-free_reserved_mem(void *start, void *end)
-{
-	void *__start = start;
-	for (; __start < end; __start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(__start));
-		init_page_count(virt_to_page(__start));
-		free_page((long)__start);
-		totalram_pages++;
-	}
-}
-
-void
 free_initmem(void)
 {
-	extern char __init_begin, __init_end;
-
-	free_reserved_mem(&__init_begin, &__init_end);
-	printk ("Freeing unused kernel memory: %ldk freed\n",
-		(&__init_end - &__init_begin) >> 10);
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void
 free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_mem((void *)start, (void *)end);
-	printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
diff -puN arch/alpha/mm/numa.c~mm-alpha-use-common-help-functions-to-free-reserved-pages arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c~mm-alpha-use-common-help-functions-to-free-reserved-pages
+++ a/arch/alpha/mm/numa.c
@@ -17,6 +17,7 @@
 
 #include <asm/hwrpb.h>
 #include <asm/pgalloc.h>
+#include <asm/sections.h>
 
 pg_data_t node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
@@ -325,8 +326,6 @@ void __init mem_init(void)
 {
 	unsigned long codesize, reservedpages, datasize, initsize, pfn;
 	extern int page_is_ram(unsigned long) __init;
-	extern char _text, _etext, _data, _edata;
-	extern char __init_begin, __init_end;
 	unsigned long nid, i;
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-alpha-use-common-help-functions-to-free-reserved-pages.patch
mm-arm-use-common-help-functions-to-free-reserved-pages.patch
mm-avr32-use-common-help-functions-to-free-reserved-pages.patch
mm-blackfin-use-common-help-functions-to-free-reserved-pages.patch
mm-c6x-use-common-help-functions-to-free-reserved-pages.patch
mm-cris-use-common-help-functions-to-free-reserved-pages.patch
mm-frv-use-common-help-functions-to-free-reserved-pages.patch
mm-h8300-use-common-help-functions-to-free-reserved-pages.patch
mm-ia64-use-common-help-functions-to-free-reserved-pages.patch
mm-m32r-use-common-help-functions-to-free-reserved-pages.patch
mm-m68k-use-common-help-functions-to-free-reserved-pages.patch
mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch
mm-mips-use-common-help-functions-to-free-reserved-pages.patch
mm-mn10300-use-common-help-functions-to-free-reserved-pages.patch
mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch
mm-parisc-use-common-help-functions-to-free-reserved-pages.patch
mm-ppc-use-common-help-functions-to-free-reserved-pages.patch
mm-s390-use-common-help-functions-to-free-reserved-pages.patch
mm-score-use-common-help-functions-to-free-reserved-pages.patch
mm-sh-use-common-help-functions-to-free-reserved-pages.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch
mm-um-use-common-help-functions-to-free-reserved-pages.patch
mm-unicore32-use-common-help-functions-to-free-reserved-pages.patch
mm-x86-use-common-help-functions-to-free-reserved-pages.patch
mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch
mm-arc-use-common-help-functions-to-free-reserved-pages.patch
mm-metag-use-common-help-functions-to-free-reserved-pages.patch
mmkexec-use-common-help-functions-to-free-reserved-pages.patch

