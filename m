From: akpm@linux-foundation.org
Subject: + mm-dax-pmem-introduce-pfn_t-v3.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:16:51 -0800
Message-ID: <5670ad73.AhQJ3SHckcFrv6fv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbbLPAQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, hch@lst.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dax-pmem-introduce-pfn_t-v3
has been added to the -mm tree.  Its filename is
     mm-dax-pmem-introduce-pfn_t-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-pmem-introduce-pfn_t-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-pmem-introduce-pfn_t-v3.patch

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
Subject: mm-dax-pmem-introduce-pfn_t-v3

Moved phys_to_pfn_t() out of line so it can be overridden for new unit
tests in development.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +----
 kernel/memremap.c  |    6 ++++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-dax-pmem-introduce-pfn_t-v3 include/linux/mm.h
--- a/include/linux/mm.h~mm-dax-pmem-introduce-pfn_t-v3
+++ a/include/linux/mm.h
@@ -922,10 +922,7 @@ static inline pfn_t pfn_to_pfn_t(unsigne
 	return __pfn_to_pfn_t(pfn, 0);
 }
 
-static inline pfn_t phys_to_pfn_t(dma_addr_t addr, unsigned long flags)
-{
-	return __pfn_to_pfn_t(addr >> PAGE_SHIFT, flags);
-}
+extern pfn_t phys_to_pfn_t(dma_addr_t addr, unsigned long flags);
 
 static inline bool pfn_t_has_page(pfn_t pfn)
 {
diff -puN kernel/memremap.c~mm-dax-pmem-introduce-pfn_t-v3 kernel/memremap.c
--- a/kernel/memremap.c~mm-dax-pmem-introduce-pfn_t-v3
+++ a/kernel/memremap.c
@@ -147,6 +147,12 @@ void devm_memunmap(struct device *dev, v
 }
 EXPORT_SYMBOL(devm_memunmap);
 
+pfn_t phys_to_pfn_t(dma_addr_t addr, unsigned long flags)
+{
+	return __pfn_to_pfn_t(addr >> PAGE_SHIFT, flags);
+}
+EXPORT_SYMBOL(phys_to_pfn_t);
+
 #ifdef CONFIG_ZONE_DEVICE
 struct page_map {
 	struct resource res;
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

