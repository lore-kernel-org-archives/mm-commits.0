From: akpm@linux-foundation.org
Subject: [merged] phys_to_pfn_t-use-phys_addr_t.patch removed from -mm
 tree
Date: Tue, 02 Feb 2016 12:28:30 -0800
Message-ID: <56b1116e.WWPG9HwtLLQ47Chz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbcBBU2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 15:28:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: phys_to_pfn_t: use phys_addr_t
has been removed from the -mm tree.  Its filename was
     phys_to_pfn_t-use-phys_addr_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: phys_to_pfn_t: use phys_addr_t

A dma_addr_t is potentially smaller than a phys_addr_t on some archs. 
Don't truncate the address when doing the pfn conversion.

[willy@linux.intel.com: fix pfn_t_to_phys as well]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pfn_t.h             |    4 ++--
 kernel/memremap.c                 |    2 +-
 tools/testing/nvdimm/test/iomap.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/pfn_t.h~phys_to_pfn_t-use-phys_addr_t include/linux/pfn_t.h
--- a/include/linux/pfn_t.h~phys_to_pfn_t-use-phys_addr_t
+++ a/include/linux/pfn_t.h
@@ -29,7 +29,7 @@ static inline pfn_t pfn_to_pfn_t(unsigne
 	return __pfn_to_pfn_t(pfn, 0);
 }
 
-extern pfn_t phys_to_pfn_t(dma_addr_t addr, unsigned long flags);
+extern pfn_t phys_to_pfn_t(phys_addr_t addr, unsigned long flags);
 
 static inline bool pfn_t_has_page(pfn_t pfn)
 {
@@ -48,7 +48,7 @@ static inline struct page *pfn_t_to_page
 	return NULL;
 }
 
-static inline dma_addr_t pfn_t_to_phys(pfn_t pfn)
+static inline phys_addr_t pfn_t_to_phys(pfn_t pfn)
 {
 	return PFN_PHYS(pfn_t_to_pfn(pfn));
 }
diff -puN kernel/memremap.c~phys_to_pfn_t-use-phys_addr_t kernel/memremap.c
--- a/kernel/memremap.c~phys_to_pfn_t-use-phys_addr_t
+++ a/kernel/memremap.c
@@ -150,7 +150,7 @@ void devm_memunmap(struct device *dev, v
 }
 EXPORT_SYMBOL(devm_memunmap);
 
-pfn_t phys_to_pfn_t(dma_addr_t addr, unsigned long flags)
+pfn_t phys_to_pfn_t(phys_addr_t addr, unsigned long flags)
 {
 	return __pfn_to_pfn_t(addr >> PAGE_SHIFT, flags);
 }
diff -puN tools/testing/nvdimm/test/iomap.c~phys_to_pfn_t-use-phys_addr_t tools/testing/nvdimm/test/iomap.c
--- a/tools/testing/nvdimm/test/iomap.c~phys_to_pfn_t-use-phys_addr_t
+++ a/tools/testing/nvdimm/test/iomap.c
@@ -113,7 +113,7 @@ void *__wrap_devm_memremap_pages(struct
 }
 EXPORT_SYMBOL(__wrap_devm_memremap_pages);
 
-pfn_t __wrap_phys_to_pfn_t(dma_addr_t addr, unsigned long flags)
+pfn_t __wrap_phys_to_pfn_t(phys_addr_t addr, unsigned long flags)
 {
 	struct nfit_test_resource *nfit_res = get_nfit_res(addr);
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


