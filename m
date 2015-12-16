From: akpm@linux-foundation.org
Subject: + avr32-convert-to-asm-generic-memory_modelh.patch added to -mm
 tree
Date: Tue, 15 Dec 2015 16:17:00 -0800
Message-ID: <5670ad7c.zOcmrByxGNqJRJiA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbbLPARB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:17:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32: convert to asm-generic/memory_model.h
has been added to the -mm tree.  Its filename is
     avr32-convert-to-asm-generic-memory_modelh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/avr32-convert-to-asm-generic-memory_modelh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/avr32-convert-to-asm-generic-memory_modelh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: avr32: convert to asm-generic/memory_model.h

Switch avr32/include/asm/page.h to use the common defintions for
pfn_to_page(), page_to_pfn(), and ARCH_PFN_OFFSET.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/page.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/avr32/include/asm/page.h~avr32-convert-to-asm-generic-memory_modelh arch/avr32/include/asm/page.h
--- a/arch/avr32/include/asm/page.h~avr32-convert-to-asm-generic-memory_modelh
+++ a/arch/avr32/include/asm/page.h
@@ -83,11 +83,9 @@ static inline int get_order(unsigned lon
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 
-#define PHYS_PFN_OFFSET		(CONFIG_PHYS_OFFSET >> PAGE_SHIFT)
+#define ARCH_PFN_OFFSET		(CONFIG_PHYS_OFFSET >> PAGE_SHIFT)
 
-#define pfn_to_page(pfn)	(mem_map + ((pfn) - PHYS_PFN_OFFSET))
-#define page_to_pfn(page)	((unsigned long)((page) - mem_map) + PHYS_PFN_OFFSET)
-#define pfn_valid(pfn)		((pfn) >= PHYS_PFN_OFFSET && (pfn) < (PHYS_PFN_OFFSET + max_mapnr))
+#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && (pfn) < (ARCH_PFN_OFFSET + max_mapnr))
 #endif /* CONFIG_NEED_MULTIPLE_NODES */
 
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
@@ -101,4 +99,6 @@ static inline int get_order(unsigned lon
  */
 #define HIGHMEM_START		0x20000000UL
 
+#include <asm-generic/memory_model.h>
+
 #endif /* __ASM_AVR32_PAGE_H */
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

