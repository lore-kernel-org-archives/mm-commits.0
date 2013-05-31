From: akpm@linux-foundation.org
Subject: +
 mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:32:44 -0700
Message-ID: <51a908ec.2PaL2k4s5+qbX6Ee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab3EaUcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ysato@users.sourceforge.jp, jiang.liu@huawei.com, geert@linux-m68k.org, liuj97@gmail.com

Subject: + mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,geert@linux-m68k.org,jiang.liu@huawei.com,ysato@users.sourceforge.jp
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:44 -0700


The patch titled
     Subject: mm/h8300: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
Subject: mm/h8300: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/mm/init.c |   36 ++++++++----------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff -puN arch/h8300/mm/init.c~mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/h8300/mm/init.c
@@ -121,40 +121,20 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	int codek = 0, datak = 0, initk = 0;
-	/* DAVIDM look at setup memory map generically with reserved area */
-	unsigned long tmp;
-	extern unsigned long  _ramend, _ramstart;
-	unsigned long len = &_ramend - &_ramstart;
-	unsigned long start_mem = memory_start; /* DAVIDM - these must start at end of kernel */
-	unsigned long end_mem   = memory_end; /* DAVIDM - this must not include kernel stack at top */
-
-#ifdef DEBUG
-	printk(KERN_DEBUG "Mem_init: start=%lx, end=%lx\n", start_mem, end_mem);
-#endif
+	unsigned long codesize = _etext - _stext;
 
-	end_mem &= PAGE_MASK;
-	high_memory = (void *) end_mem;
+	pr_devel("Mem_init: start=%lx, end=%lx\n", memory_start, memory_end);
 
-	start_mem = PAGE_ALIGN(start_mem);
-	max_mapnr = num_physpages = MAP_NR(high_memory);
+	high_memory = (void *) (memory_end & PAGE_MASK);
+	max_mapnr = MAP_NR(high_memory);
 
 	/* this will put all low memory onto the freelists */
 	free_all_bootmem();
 
-	codek = (_etext - _stext) >> 10;
-	datak = (__bss_stop - _sdata) >> 10;
-	initk = (__init_begin - __init_end) >> 10;
-
-	tmp = nr_free_pages() << PAGE_SHIFT;
-	printk(KERN_INFO "Memory available: %luk/%luk RAM, %luk/%luk ROM (%dk kernel code, %dk data)\n",
-	       tmp >> 10,
-	       len >> 10,
-	       (rom_length > 0) ? ((rom_length >> 10) - codek) : 0,
-	       rom_length >> 10,
-	       codek,
-	       datak
-	       );
+	mem_init_print_info(NULL);
+	if (rom_length > 0 && rom_length > codesize)
+		pr_info("Memory available: %luK/%luK ROM\n",
+			(rom_length - codesize) >> 10, rom_length >> 10);
 }
 
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

linux-next.patch
mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch
mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch
mm-arm64-kill-poison_init_mem.patch
mm-x86-use-free_reserved_area-to-simplify-code.patch
mm-tile-use-common-help-functions-to-free-reserved-pages.patch
mm-fix-some-trivial-typos-in-comments.patch
mm-use-managed_pages-to-calculate-default-zonelist-order.patch
mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-make-__free_pages_bootmem-only-available-at-boot-time.patch
mm-correctly-update-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch
mm-report-available-pages-as-memtotal-for-each-numa-node.patch
vmlinuxlds-add-comments-for-global-variables-and-clean-up-useless-declarations.patch
avr32-normalize-global-variables-exported-by-vmlinuxlds.patch
c6x-normalize-global-variables-exported-by-vmlinuxlds.patch
h8300-normalize-global-variables-exported-by-vmlinuxlds.patch
score-normalize-global-variables-exported-by-vmlinuxlds.patch
tile-normalize-global-variables-exported-by-vmlinuxlds.patch
uml-normalize-global-variables-exported-by-vmlinuxlds.patch
mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch
mm-use-totalram_pages-instead-of-num_physpages-at-runtime.patch
mm-hotplug-prepare-for-removing-num_physpages.patch
mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arm-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-avr32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-c6x-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-cris-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-hexagon-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-m68k-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-metag-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-mn10300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-openrisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-s390-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-score-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-um-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-unicore32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-xtensa-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-kill-global-variable-num_physpages.patch

