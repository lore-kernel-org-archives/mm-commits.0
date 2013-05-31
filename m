From: akpm@linux-foundation.org
Subject: + mm-kill-global-variable-num_physpages.patch added to -mm tree
Date: Fri, 31 May 2013 13:33:06 -0700
Message-ID: <51a90902.QdbPAOoR39Yk/vIq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab3EaUdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:33:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, viro@zeniv.linux.org.uk, rientjes@google.com, riel@redhat.com, mgorman@suse.de, khlebnikov@openvz.org, jiang.liu@huawei.com, hughd@google.com, liuj97@gmail.com

Subject: + mm-kill-global-variable-num_physpages.patch added to -mm tree
To: liuj97@gmail.com,hughd@google.com,jiang.liu@huawei.com,khlebnikov@openvz.org,mgorman@suse.de,riel@redhat.com,rientjes@google.com,viro@zeniv.linux.org.uk,walken@google.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:33:06 -0700


The patch titled
     Subject: mm: kill global variable num_physpages
has been added to the -mm tree.  Its filename is
     mm-kill-global-variable-num_physpages.patch

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
Subject: mm: kill global variable num_physpages

Now all references to num_physpages have been removed, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/memory.c        |    2 --
 mm/nommu.c         |    2 --
 3 files changed, 5 deletions(-)

diff -puN include/linux/mm.h~mm-kill-global-variable-num_physpages include/linux/mm.h
--- a/include/linux/mm.h~mm-kill-global-variable-num_physpages
+++ a/include/linux/mm.h
@@ -29,7 +29,6 @@ struct writeback_control;
 extern unsigned long max_mapnr;
 #endif
 
-extern unsigned long num_physpages;
 extern unsigned long totalram_pages;
 extern void * high_memory;
 extern int page_cluster;
diff -puN mm/memory.c~mm-kill-global-variable-num_physpages mm/memory.c
--- a/mm/memory.c~mm-kill-global-variable-num_physpages
+++ a/mm/memory.c
@@ -82,7 +82,6 @@ EXPORT_SYMBOL(max_mapnr);
 EXPORT_SYMBOL(mem_map);
 #endif
 
-unsigned long num_physpages;
 /*
  * A number of key systems in x86 including ioremap() rely on the assumption
  * that high_memory defines the upper bound on direct map memory, then end
@@ -92,7 +91,6 @@ unsigned long num_physpages;
  */
 void * high_memory;
 
-EXPORT_SYMBOL(num_physpages);
 EXPORT_SYMBOL(high_memory);
 
 /*
diff -puN mm/nommu.c~mm-kill-global-variable-num_physpages mm/nommu.c
--- a/mm/nommu.c~mm-kill-global-variable-num_physpages
+++ a/mm/nommu.c
@@ -56,7 +56,6 @@
 void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
-unsigned long num_physpages;
 unsigned long highest_memmap_pfn;
 struct percpu_counter vm_committed_as;
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
@@ -85,7 +84,6 @@ unsigned long vm_memory_committed(void)
 EXPORT_SYMBOL_GPL(vm_memory_committed);
 
 EXPORT_SYMBOL(mem_map);
-EXPORT_SYMBOL(num_physpages);
 
 /* list of mapped, potentially shareable regions */
 static struct kmem_cache *vm_region_jar;
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

