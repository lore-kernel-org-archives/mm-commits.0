From: akpm@linux-foundation.org
Subject: + mm-free-memblockmemory-in-free_all_bootmem.patch added to -mm
 tree
Date: Tue, 07 Jan 2014 13:43:07 -0800
Message-ID: <52cc74eb.tpIlcV2KRPHtVZqb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaAGVnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 16:43:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toshi.kani@hp.com, tj@kernel.org, tangchen@cn.fujitsu.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, phacht@linux.vnet.ibm.com

Subject: + mm-free-memblockmemory-in-free_all_bootmem.patch added to -mm tree
To: phacht@linux.vnet.ibm.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,tangchen@cn.fujitsu.com,tj@kernel.org,toshi.kani@hp.com
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 13:43:07 -0800


The patch titled
     Subject: mm: free memblock.memory in free_all_bootmem
has been added to the -mm tree.  Its filename is
     mm-free-memblockmemory-in-free_all_bootmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-free-memblockmemory-in-free_all_bootmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-free-memblockmemory-in-free_all_bootmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: mm: free memblock.memory in free_all_bootmem

When calling free_all_bootmem() the free areas under memblock's control
are released to the buddy allocator.  Additionally the reserved list is
freed if it was reallocated by memblock.  The same should apply for the
memory list.

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 +
 mm/memblock.c            |   12 ++++++++++++
 mm/nobootmem.c           |    7 ++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff -puN include/linux/memblock.h~mm-free-memblockmemory-in-free_all_bootmem include/linux/memblock.h
--- a/include/linux/memblock.h~mm-free-memblockmemory-in-free_all_bootmem
+++ a/include/linux/memblock.h
@@ -61,6 +61,7 @@ phys_addr_t memblock_find_in_range_node(
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
 phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
+phys_addr_t get_allocated_memblock_memory_regions_info(phys_addr_t *addr);
 void memblock_allow_resize(void);
 int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_add(phys_addr_t base, phys_addr_t size);
diff -puN mm/memblock.c~mm-free-memblockmemory-in-free_all_bootmem mm/memblock.c
--- a/mm/memblock.c~mm-free-memblockmemory-in-free_all_bootmem
+++ a/mm/memblock.c
@@ -291,6 +291,18 @@ phys_addr_t __init_memblock get_allocate
 			  memblock.reserved.max);
 }
 
+phys_addr_t __init_memblock get_allocated_memblock_memory_regions_info(
+					phys_addr_t *addr)
+{
+	if (memblock.memory.regions == memblock_memory_init_regions)
+		return 0;
+
+	*addr = __pa(memblock.memory.regions);
+
+	return PAGE_ALIGN(sizeof(struct memblock_region) *
+			  memblock.memory.max);
+}
+
 /**
  * memblock_double_array - double the size of the memblock regions array
  * @type: memblock type of the regions array being doubled
diff -puN mm/nobootmem.c~mm-free-memblockmemory-in-free_all_bootmem mm/nobootmem.c
--- a/mm/nobootmem.c~mm-free-memblockmemory-in-free_all_bootmem
+++ a/mm/nobootmem.c
@@ -122,11 +122,16 @@ static unsigned long __init free_low_mem
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
-	/* free range that is used for reserved array if we allocate it */
+	/* Free memblock.reserved array if it was allocated */
 	size = get_allocated_memblock_reserved_regions_info(&start);
 	if (size)
 		count += __free_memory_core(start, start + size);
 
+	/* Free memblock.memory array if it was allocated */
+	size = get_allocated_memblock_memory_regions_info(&start);
+	if (size)
+		count += __free_memory_core(start, start + size);
+
 	return count;
 }
 
_

Patches currently in -mm which might be from phacht@linux.vnet.ibm.com are

mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch

