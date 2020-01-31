From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 117/118] include/linux/io-mapping.h-mapping: use
 PHYS_PFN() macro in io_mapping_map_atomic_wc()
Date: Thu, 30 Jan 2020 22:17:32 -0800
Message-ID: <20200131061732.qQUnhMZdT%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAaGRd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:17:33 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/io-mapping.h-mapping: use PHYS_PFN() macro in io_mapping_map_atomic_wc()

Use PHYS_PFN() macro in io_mapping_map_atomic_wc() instead of open coded
variant.

Link: http://lkml.kernel.org/r/20191209165624.56351-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io-mapping.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/io-mapping.h~io-mapping-use-phys_pfn-macro-in-io_mapping_map_atomic_wc
+++ a/include/linux/io-mapping.h
@@ -28,6 +28,7 @@ struct io_mapping {
 
 #ifdef CONFIG_HAVE_ATOMIC_IOMAP
 
+#include <linux/pfn.h>
 #include <asm/iomap.h>
 /*
  * For small address space machines, mapping large objects
@@ -64,12 +65,10 @@ io_mapping_map_atomic_wc(struct io_mappi
 			 unsigned long offset)
 {
 	resource_size_t phys_addr;
-	unsigned long pfn;
 
 	BUG_ON(offset >= mapping->size);
 	phys_addr = mapping->base + offset;
-	pfn = (unsigned long) (phys_addr >> PAGE_SHIFT);
-	return iomap_atomic_prot_pfn(pfn, mapping->prot);
+	return iomap_atomic_prot_pfn(PHYS_PFN(phys_addr), mapping->prot);
 }
 
 static inline void
_
