From: akpm@linux-foundation.org
Subject: +
 mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:33:00 -0700
Message-ID: <51a908fc.IdxnPMQ/YB1BD0Op%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab3EaUdB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:33:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wency@cn.fujitsu.com, jiang.liu@huawei.com, davem@davemloft.net, cmetcalf@tilera.com, bhelgaas@google.com, liuj97@gmail.com

Subject: + mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,bhelgaas@google.com,cmetcalf@tilera.com,davem@davemloft.net,jiang.liu@huawei.com,wency@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:33:00 -0700


The patch titled
     Subject: mm/tile: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
Subject: mm/tile: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/setup.c |   16 ++++++++--------
 arch/tile/mm/init.c      |   15 +--------------
 2 files changed, 9 insertions(+), 22 deletions(-)

diff -puN arch/tile/kernel/setup.c~mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/tile/kernel/setup.c
@@ -329,6 +329,7 @@ static void __init setup_memory(void)
 #if defined(CONFIG_HIGHMEM) || defined(__tilegx__)
 	long lowmem_pages;
 #endif
+	unsigned long physpages = 0;
 
 	/* We are using a char to hold the cpu_2_node[] mapping */
 	BUILD_BUG_ON(MAX_NUMNODES > 127);
@@ -388,8 +389,8 @@ static void __init setup_memory(void)
 				continue;
 			}
 		}
-		if (num_physpages + PFN_DOWN(range.size) > maxmem_pfn) {
-			int max_size = maxmem_pfn - num_physpages;
+		if (physpages + PFN_DOWN(range.size) > maxmem_pfn) {
+			int max_size = maxmem_pfn - physpages;
 			if (max_size > 0) {
 				pr_err("Maxmem reduced node %d to %d pages\n",
 				       i, max_size);
@@ -446,7 +447,7 @@ static void __init setup_memory(void)
 		node_start_pfn[i] = start;
 		node_end_pfn[i] = end;
 		node_controller[i] = range.controller;
-		num_physpages += size;
+		physpages += size;
 		max_pfn = end;
 
 		/* Mark node as online */
@@ -465,7 +466,7 @@ static void __init setup_memory(void)
 	 * we're willing to use at 8 million pages (32GB of 4KB pages).
 	 */
 	cap = 8 * 1024 * 1024;  /* 8 million pages */
-	if (num_physpages > cap) {
+	if (physpages > cap) {
 		int num_nodes = num_online_nodes();
 		int cap_each = cap / num_nodes;
 		unsigned long dropped_pages = 0;
@@ -476,10 +477,10 @@ static void __init setup_memory(void)
 				node_end_pfn[i] = node_start_pfn[i] + cap_each;
 			}
 		}
-		num_physpages -= dropped_pages;
+		physpages -= dropped_pages;
 		pr_warning("Only using %ldMB memory;"
 		       " ignoring %ldMB.\n",
-		       num_physpages >> (20 - PAGE_SHIFT),
+		       physpages >> (20 - PAGE_SHIFT),
 		       dropped_pages >> (20 - PAGE_SHIFT));
 		pr_warning("Consider using a larger page size.\n");
 	}
@@ -497,7 +498,7 @@ static void __init setup_memory(void)
 
 	lowmem_pages = (mappable_physpages > MAXMEM_PFN) ?
 		MAXMEM_PFN : mappable_physpages;
-	highmem_pages = (long) (num_physpages - lowmem_pages);
+	highmem_pages = (long) (physpages - lowmem_pages);
 
 	pr_notice("%ldMB HIGHMEM available.\n",
 	       pages_to_mb(highmem_pages > 0 ? highmem_pages : 0));
@@ -514,7 +515,6 @@ static void __init setup_memory(void)
 		pr_warning("Use a HIGHMEM enabled kernel.\n");
 		max_low_pfn = MAXMEM_PFN;
 		max_pfn = MAXMEM_PFN;
-		num_physpages = MAXMEM_PFN;
 		node_end_pfn[0] = MAXMEM_PFN;
 	} else {
 		pr_notice("%ldMB memory available.\n",
diff -puN arch/tile/mm/init.c~mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/tile/mm/init.c
@@ -821,7 +821,6 @@ static void __init set_max_mapnr_init(vo
 
 void __init mem_init(void)
 {
-	int codesize, datasize, initsize;
 	int i;
 #ifndef __tilegx__
 	void *last;
@@ -853,19 +852,7 @@ void __init mem_init(void)
 	set_non_bootmem_pages_init();
 #endif
 
-	codesize =  (unsigned long)&_etext - (unsigned long)&_text;
-	datasize =  (unsigned long)&_end - (unsigned long)&_sdata;
-	initsize =  (unsigned long)&_einittext - (unsigned long)&_sinittext;
-	initsize += (unsigned long)&_einitdata - (unsigned long)&_sinitdata;
-
-	pr_info("Memory: %luk/%luk available (%dk kernel code, %dk data, %dk init, %ldk highmem)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
-		num_physpages << (PAGE_SHIFT-10),
-		codesize >> 10,
-		datasize >> 10,
-		initsize >> 10,
-		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10))
-	       );
+	mem_init_print_info(NULL);
 
 	/*
 	 * In debug mode, dump some interesting memory mappings.
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

