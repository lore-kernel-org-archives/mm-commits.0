From: akpm@linux-foundation.org
Subject: + mm-ppc-prepare-for-killing-free_all_bootmem_node.patch added to -mm tree
Date: Fri, 31 May 2013 14:03:47 -0700
Message-ID: <51a91033.SSRz7mTJOAcCeYRc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3EaVDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, suzuki@in.ibm.com, paulus@samba.org, jiang.liu@huawei.com, benh@kernel.crashing.org, agraf@suse.de, liuj97@gmail.com

Subject: + mm-ppc-prepare-for-killing-free_all_bootmem_node.patch added to -mm tree
To: liuj97@gmail.com,agraf@suse.de,benh@kernel.crashing.org,jiang.liu@huawei.com,paulus@samba.org,suzuki@in.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 14:03:47 -0700


The patch titled
     Subject: mm/PPC: prepare for killing free_all_bootmem_node()
has been added to the -mm tree.  Its filename is
     mm-ppc-prepare-for-killing-free_all_bootmem_node.patch

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
Subject: mm/PPC: prepare for killing free_all_bootmem_node()

Prepare for killing free_all_bootmem_node() by using free_all_bootmem().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN arch/powerpc/mm/mem.c~mm-ppc-prepare-for-killing-free_all_bootmem_node arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-ppc-prepare-for-killing-free_all_bootmem_node
+++ a/arch/powerpc/mm/mem.c
@@ -304,22 +304,8 @@ void __init mem_init(void)
 #endif
 
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
-
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-	{
-		pg_data_t *pgdat;
-
-		for_each_online_pgdat(pgdat)
-			if (pgdat->node_spanned_pages != 0) {
-				printk("freeing bootmem node %d\n",
-					pgdat->node_id);
-				free_all_bootmem_node(pgdat);
-			}
-	}
-#else
-	max_mapnr = max_pfn;
+	set_max_mapnr(max_pfn);
 	free_all_bootmem();
-#endif
 
 #ifdef CONFIG_HIGHMEM
 	{
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

