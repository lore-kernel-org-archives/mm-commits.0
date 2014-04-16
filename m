From: akpm@linux-foundation.org
Subject: + memblock-introduce-memblock_alloc_range.patch added to -mm tree
Date: Wed, 16 Apr 2014 12:44:49 -0700
Message-ID: <534eddb1.bDZ2ZwE6D0Gd9oM6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaDPTov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 15:44:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de, mingo@redhat.com, m.szyprowski@samsung.com, konrad.wilk@oracle.com, hpa@zytor.com, dwmw2@infradead.org, ddutile@redhat.com, andi@firstfloor.org, akinobu.mita@gmail.com

Subject: + memblock-introduce-memblock_alloc_range.patch added to -mm tree
To: akinobu.mita@gmail.com,andi@firstfloor.org,ddutile@redhat.com,dwmw2@infradead.org,hpa@zytor.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mingo@redhat.com,tglx@linutronix.de,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 12:44:49 -0700


The patch titled
     Subject: memblock: introduce memblock_alloc_range()
has been added to the -mm tree.  Its filename is
     memblock-introduce-memblock_alloc_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-introduce-memblock_alloc_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-introduce-memblock_alloc_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: memblock: introduce memblock_alloc_range()

This introduces memblock_alloc_range() which allocates memblock from the
specified range of physical address.  I would like to use this function to
specify the location of CMA.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    2 ++
 mm/memblock.c            |   21 +++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff -puN include/linux/memblock.h~memblock-introduce-memblock_alloc_range include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-introduce-memblock_alloc_range
+++ a/include/linux/memblock.h
@@ -221,6 +221,8 @@ static inline bool memblock_bottom_up(vo
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
 #define MEMBLOCK_ALLOC_ACCESSIBLE	0
 
+phys_addr_t __init memblock_alloc_range(phys_addr_t size, phys_addr_t align,
+					phys_addr_t start, phys_addr_t end);
 phys_addr_t memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 				phys_addr_t max_addr);
 phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
diff -puN mm/memblock.c~memblock-introduce-memblock_alloc_range mm/memblock.c
--- a/mm/memblock.c~memblock-introduce-memblock_alloc_range
+++ a/mm/memblock.c
@@ -975,22 +975,35 @@ int __init_memblock memblock_set_node(ph
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
-					phys_addr_t align, phys_addr_t max_addr,
-					int nid)
+static phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
+					phys_addr_t align, phys_addr_t start,
+					phys_addr_t end, int nid)
 {
 	phys_addr_t found;
 
 	if (!align)
 		align = SMP_CACHE_BYTES;
 
-	found = memblock_find_in_range_node(size, align, 0, max_addr, nid);
+	found = memblock_find_in_range_node(size, align, start, end, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
 
 	return 0;
 }
 
+phys_addr_t __init memblock_alloc_range(phys_addr_t size, phys_addr_t align,
+					phys_addr_t start, phys_addr_t end)
+{
+	return memblock_alloc_range_nid(size, align, start, end, NUMA_NO_NODE);
+}
+
+static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
+					phys_addr_t align, phys_addr_t max_addr,
+					int nid)
+{
+	return memblock_alloc_range_nid(size, align, 0, max_addr, nid);
+}
+
 phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
 {
 	return memblock_alloc_base_nid(size, align, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
x86-enable-dma-cma-with-swiotlb.patch
intel-iommu-integrate-dma-cma.patch
memblock-introduce-memblock_alloc_range.patch
cma-add-placement-specifier-for-cma=-kernel-parameter.patch

