From: akpm@linux-foundation.org
Subject: [folded-merged]
 libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory-fix.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 16:31:04 -0800
Message-ID: <56998f48.twKDGsDh9FfKrqXB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbcAPAbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:31:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, dan.j.williams@intel.com, david@fromorbit.com, dhowells@redhat.com, hch@lst.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: Declare __pfn_to_phys() to fix build error
has been removed from the -mm tree.  Its filename was
     libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory-fix.patch

This patch was dropped because it was folded into libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: mn10300: Declare __pfn_to_phys() to fix build error

__pfn_to_phys() was introduced with commit 8b79eb6f5b53e ("libnvdimm, pfn,
pmem: allocate memmap array in persistent memory") but not declared for
mn10300. This results in the following build error.

mm/page_alloc.c: In function 'memmap_init_zone':
mm/page_alloc.c:4610:9: error: implicit declaration of function '__pfn_to_phys'

Fixes: 8b79eb6f5b53e ("libnvdimm, pfn, pmem: allocate memmap array in persistent memory")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/page.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mn10300/include/asm/page.h~libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory-fix arch/mn10300/include/asm/page.h
--- a/arch/mn10300/include/asm/page.h~libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory-fix
+++ a/arch/mn10300/include/asm/page.h
@@ -107,6 +107,7 @@ static inline int get_order(unsigned lon
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 #define pfn_to_page(pfn)	(mem_map + ((pfn) - __pfn_disp))
 #define page_to_pfn(page)	((unsigned long)((page) - mem_map) + __pfn_disp)
+#define __pfn_to_phys(pfn)	PFN_PHYS(pfn)
 
 #define pfn_valid(pfn)					\
 ({							\
_

Patches currently in -mm which might be from linux@roeck-us.net are

libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch

