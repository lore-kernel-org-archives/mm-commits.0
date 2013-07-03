From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init-fix.patch removed from -mm tree
Date: Wed, 03 Jul 2013 14:36:38 -0700
Message-ID: <51d49966.o6Nob/VqPTWurp88%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279Ab3GCVgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:36:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [folded-merged] mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init-fix.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:36:38 -0700


The patch titled
     Subject: mm, arch: fix two errors in calling mem_init_print_info()
has been removed from the -mm tree.  Its filename was
     mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init-fix.patch

This patch was dropped because it was folded into mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm, arch: fix two errors in calling mem_init_print_info()

Fix two errors in calling mem_init_print_info() caused by incidents.

All error/warnings:

   arch/microblaze/mm/init.c: In function 'mem_init':
>> arch/microblaze/mm/init.c:249:22: error: 'str' undeclared (first use in this function)
   arch/microblaze/mm/init.c:249:22: note: each undeclared identifier is reported only once for each function it appears in

vim +/str +249 arch/microblaze/mm/init.c

   243		/* this will put all memory onto the freelists */
   244		free_all_bootmem();
   245	#ifdef CONFIG_HIGHMEM
   246		highmem_setup();
   247	#endif
   248
 > 249		mem_init_print_info(str);
   250	#ifdef CONFIG_MMU
   251		pr_info("Kernel virtual memory layout:\n");
   252		pr_info("  * 0x%08lx..0x%08lx  : fixmap\n", FIXADDR_START, FIXADDR_TOP);

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/init.c      |    2 +-
 arch/microblaze/mm/init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm64/mm/init.c~mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init-fix arch/arm64/mm/init.c
--- a/arch/arm64/mm/init.c~mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init-fix
+++ a/arch/arm64/mm/init.c
@@ -282,7 +282,7 @@ void __init mem_init(void)
 	/* this will put all unused low memory onto the freelists */
 	free_all_bootmem();
 
-	mem_init_print_info();
+	mem_init_print_info(NULL);
 
 #define MLK(b, t) b, t, ((t) - (b)) >> 10
 #define MLM(b, t) b, t, ((t) - (b)) >> 20
diff -puN arch/microblaze/mm/init.c~mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init-fix arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init-fix
+++ a/arch/microblaze/mm/init.c
@@ -246,7 +246,7 @@ void __init mem_init(void)
 	highmem_setup();
 #endif
 
-	mem_init_print_info(str);
+	mem_init_print_info(NULL);
 #ifdef CONFIG_MMU
 	pr_info("Kernel virtual memory layout:\n");
 	pr_info("  * 0x%08lx..0x%08lx  : fixmap\n", FIXADDR_START, FIXADDR_TOP);
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
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
mm-alpha-clean-up-unused-valid_page.patch
mm-arm-fix-stale-comment-about-valid_page.patch
mm-cris-clean-up-unused-valid_page.patch
mm-microblaze-clean-up-unused-valid_page.patch
mm-unicore32-fix-stale-comment-about-valid_page.patch
sparsemem-add-build_bug_on-when-sizeof-mem_section-is-non-power-of-2.patch

