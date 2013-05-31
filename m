From: akpm@linux-foundation.org
Subject: +
 mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:32:35 -0700
Message-ID: <51a908e3.qDZ52IYHdfgWZXga%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3EaUcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rth@twiddle.net, mattst88@gmail.com, jiang.liu@huawei.com, ink@jurassic.park.msu.ru, dhowells@redhat.com, liuj97@gmail.com

Subject: + mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,dhowells@redhat.com,ink@jurassic.park.msu.ru,jiang.liu@huawei.com,mattst88@gmail.com,rth@twiddle.net
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:35 -0700


The patch titled
     Subject: mm/alpha: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
Subject: mm/alpha: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/init.c |   32 ++------------------------------
 arch/alpha/mm/numa.c |   34 ++--------------------------------
 2 files changed, 4 insertions(+), 62 deletions(-)

diff -puN arch/alpha/mm/init.c~mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init arch/alpha/mm/init.c
--- a/arch/alpha/mm/init.c~mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/alpha/mm/init.c
@@ -277,42 +277,14 @@ srm_paging_stop (void)
 #endif
 
 #ifndef CONFIG_DISCONTIGMEM
-static void __init
-printk_memory_info(void)
-{
-	unsigned long codesize, reservedpages, datasize, initsize, tmp;
-	extern int page_is_ram(unsigned long) __init;
-
-	/* printk all informations */
-	reservedpages = 0;
-	for (tmp = 0; tmp < max_low_pfn; tmp++)
-		/*
-		 * Only count reserved RAM pages
-		 */
-		if (page_is_ram(tmp) && PageReserved(mem_map+tmp))
-			reservedpages++;
-
-	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_data;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
-
-	printk("Memory: %luk/%luk available (%luk kernel code, %luk reserved, %luk data, %luk init)\n",
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       max_mapnr << (PAGE_SHIFT-10),
-	       codesize >> 10,
-	       reservedpages << (PAGE_SHIFT-10),
-	       datasize >> 10,
-	       initsize >> 10);
-}
-
 void __init
 mem_init(void)
 {
-	max_mapnr = num_physpages = max_low_pfn;
+	max_mapnr = max_low_pfn;
 	free_all_bootmem();
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
 
-	printk_memory_info();
+	mem_init_print_info(NULL);
 }
 #endif /* CONFIG_DISCONTIGMEM */
 
diff -puN arch/alpha/mm/numa.c~mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c~mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/alpha/mm/numa.c
@@ -129,8 +129,6 @@ setup_memory_node(int nid, void *kernel_
 	if (node_max_pfn > max_low_pfn)
 		max_pfn = max_low_pfn = node_max_pfn;
 
-	num_physpages += node_max_pfn - node_min_pfn;
-
 #if 0 /* we'll try this one again in a little while */
 	/* Cute trick to make sure our local node data is on local memory */
 	node_data[nid] = (pg_data_t *)(__va(node_min_pfn << PAGE_SHIFT));
@@ -324,37 +322,9 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	unsigned long codesize, reservedpages, datasize, initsize, pfn;
-	extern int page_is_ram(unsigned long) __init;
-	unsigned long nid, i;
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
-
-	reservedpages = 0;
-	for_each_online_node(nid) {
-		/*
-		 * This will free up the bootmem, ie, slot 0 memory
-		 */
-		free_all_bootmem_node(NODE_DATA(nid));
-
-		pfn = NODE_DATA(nid)->node_start_pfn;
-		for (i = 0; i < node_spanned_pages(nid); i++, pfn++)
-			if (page_is_ram(pfn) &&
-			    PageReserved(nid_page_nr(nid, i)))
-				reservedpages++;
-	}
-
-	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_data;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
-
-	printk("Memory: %luk/%luk available (%luk kernel code, %luk reserved, "
-	       "%luk data, %luk init)\n",
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       num_physpages << (PAGE_SHIFT-10),
-	       codesize >> 10,
-	       reservedpages << (PAGE_SHIFT-10),
-	       datasize >> 10,
-	       initsize >> 10);
+	free_all_bootmem();
+	mem_init_print_info(NULL);
 #if 0
 	mem_stress();
 #endif
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

