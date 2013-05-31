From: akpm@linux-foundation.org
Subject: + mm-m68k-fix-build-warning-of-unused-variable.patch added to -mm tree
Date: Fri, 31 May 2013 14:03:51 -0700
Message-ID: <51a91037.fiaoQdn3rpSFyXb1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3EaVDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 17:03:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergei.shtylyov@cogentembedded.com, jiang.liu@huawei.com, gerg@uclinux.org, geert@linux-m68k.org, cascardo@holoscopio.com, liuj97@gmail.com

Subject: + mm-m68k-fix-build-warning-of-unused-variable.patch added to -mm tree
To: liuj97@gmail.com,cascardo@holoscopio.com,geert@linux-m68k.org,gerg@uclinux.org,jiang.liu@huawei.com,sergei.shtylyov@cogentembedded.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 14:03:51 -0700


The patch titled
     Subject: mm/m68k: fix build warning of unused variable
has been added to the -mm tree.  Its filename is
     mm-m68k-fix-build-warning-of-unused-variable.patch

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
Subject: mm/m68k: fix build warning of unused variable

Fix build warning of unused variable: arch/m68k/mm/init.c: In function
'mem_init': arch/m68k/mm/init.c:151:6: warning: unused variable 'i'
[-Wunused-variable]

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/init.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN arch/m68k/mm/init.c~mm-m68k-fix-build-warning-of-unused-variable arch/m68k/mm/init.c
--- a/arch/m68k/mm/init.c~mm-m68k-fix-build-warning-of-unused-variable
+++ a/arch/m68k/mm/init.c
@@ -146,14 +146,11 @@ void __init print_memmap(void)
 		MLK_ROUNDUP(__bss_start, __bss_stop));
 }
 
-void __init mem_init(void)
+static inline void init_pointer_tables(void)
 {
+#if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
 	int i;
 
-	/* this will put all memory onto the freelists */
-	free_all_bootmem();
-
-#if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
 	/* insert pointer tables allocated so far into the tablelist */
 	init_pointer_table((unsigned long)kernel_pg_dir);
 	for (i = 0; i < PTRS_PER_PGD; i++) {
@@ -165,7 +162,13 @@ void __init mem_init(void)
 	if (zero_pgtable)
 		init_pointer_table((unsigned long)zero_pgtable);
 #endif
+}
 
+void __init mem_init(void)
+{
+	/* this will put all memory onto the freelists */
+	free_all_bootmem();
+	init_pointer_tables();
 	mem_init_print_info(NULL);
 	print_memmap();
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
mm-introduce-helper-function-set_max_mapnr.patch
mm-avr32-prepare-for-killing-free_all_bootmem_node.patch
mm-ia64-prepare-for-killing-free_all_bootmem_node.patch
mm-m32r-prepare-for-killing-free_all_bootmem_node.patch
mm-m68k-prepare-for-killing-free_all_bootmem_node.patch
mm-metag-prepare-for-killing-free_all_bootmem_node.patch
mm-mips-prepare-for-killing-free_all_bootmem_node.patch
mm-parisc-prepare-for-killing-free_all_bootmem_node.patch
mm-ppc-prepare-for-killing-free_all_bootmem_node.patch
mm-sh-prepare-for-killing-free_all_bootmem_node.patch
mm-kill-free_all_bootmem_node.patch
mm-alpha-unify-mem_init-for-both-uma-and-numa-architectures.patch
mm-m68k-fix-build-warning-of-unused-variable.patch

