From: akpm@linux-foundation.org
Subject: [merged] memblock-introduce-memblock_alloc_range.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:49:09 -0700
Message-ID: <5390c9b5.Sse8V7U3NhfCnvZY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaFETtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tglx@linutronix.de, mingo@redhat.com, m.szyprowski@samsung.com, konrad.wilk@oracle.com, hpa@zytor.com, dwmw2@infradead.org, ddutile@redhat.com, andi@firstfloor.org, akinobu.mita@gmail.com

Subject: [merged] memblock-introduce-memblock_alloc_range.patch removed from -mm tree
To: akinobu.mita@gmail.com,andi@firstfloor.org,ddutile@redhat.com,dwmw2@infradead.org,hpa@zytor.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mingo@redhat.com,tglx@linutronix.de,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:09 -0700


The patch titled
     Subject: memblock: introduce memblock_alloc_range()
has been removed from the -mm tree.  Its filename was
     memblock-introduce-memblock_alloc_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -272,6 +272,8 @@ static inline bool memblock_bottom_up(vo
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
@@ -1033,22 +1033,35 @@ int __init_memblock memblock_set_node(ph
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

origin.patch
linux-next.patch

