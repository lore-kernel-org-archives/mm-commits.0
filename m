From: akpm@linux-foundation.org
Subject: + phys_to_pfn_t-use-phys_addr_t.patch added to -mm tree
Date: Fri, 22 Jan 2016 12:39:11 -0800
Message-ID: <56a2936f.TVDaLgugbgy93sGK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbcAVUjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jan 2016 15:39:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     From: Dan Williams <dan.j.williams@intel.com>
has been added to the -mm tree.  Its filename is
     phys_to_pfn_t-use-phys_addr_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/phys_to_pfn_t-use-phys_addr_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/phys_to_pfn_t-use-phys_addr_t.patch

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

phys_to_pfn_t-use-phys_addr_t.patch
dax-add-support-for-fsync-sync-v6-fix.patch

