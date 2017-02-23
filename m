From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-skip-over-regions-of-invalid-pfns-where-possible.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:15:57 -0800
Message-ID: <58af510d.DqPcNx/VliDJ6sUV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVQA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:16:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.burton@imgtec.com, james.hartley@imgtec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: skip over regions of invalid pfns where possible
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-skip-over-regions-of-invalid-pfns-where-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Burton <paul.burton@imgtec.com>
Subject: mm: page_alloc: skip over regions of invalid pfns where possible

When using a sparse memory model memmap_init_zone() when invoked with the
MEMMAP_EARLY context will skip over pages which aren't valid - ie.  which
aren't in a populated region of the sparse memory map.  However if the
memory map is extremely sparse then it can spend a long time linearly
checking each PFN in a large non-populated region of the memory map &
skipping it in turn.

When CONFIG_HAVE_MEMBLOCK_NODE_MAP is enabled, we have sufficient
information to quickly discover the next valid PFN given an invalid one by
searching through the list of memory regions & skipping forwards to the
first PFN covered by the memory region to the right of the non-populated
region.  Implement this in order to speed up memmap_init_zone() for
systems with extremely sparse memory maps.

James said "I have tested this patch on a virtual model of a Samurai
CPU with a sparse memory map.  The kernel boot time drops from 109 to
62 seconds. " 

Link: http://lkml.kernel.org/r/20161125185518.29885-1-paul.burton@imgtec.com
Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Tested-by: James Hartley <james.hartley@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 +
 mm/memblock.c            |   25 +++++++++++++++++++++++++
 mm/page_alloc.c          |   11 ++++++++++-
 3 files changed, 36 insertions(+), 1 deletion(-)

diff -puN include/linux/memblock.h~mm-page_alloc-skip-over-regions-of-invalid-pfns-where-possible include/linux/memblock.h
--- a/include/linux/memblock.h~mm-page_alloc-skip-over-regions-of-invalid-pfns-where-possible
+++ a/include/linux/memblock.h
@@ -203,6 +203,7 @@ int memblock_search_pfn_nid(unsigned lon
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 			  unsigned long *out_end_pfn, int *out_nid);
+unsigned long memblock_next_valid_pfn(unsigned long pfn, unsigned long max_pfn);
 
 /**
  * for_each_mem_pfn_range - early memory pfn range iterator
diff -puN mm/memblock.c~mm-page_alloc-skip-over-regions-of-invalid-pfns-where-possible mm/memblock.c
--- a/mm/memblock.c~mm-page_alloc-skip-over-regions-of-invalid-pfns-where-possible
+++ a/mm/memblock.c
@@ -1105,6 +1105,31 @@ void __init_memblock __next_mem_pfn_rang
 		*out_nid = r->nid;
 }
 
+unsigned long __init_memblock memblock_next_valid_pfn(unsigned long pfn,
+						      unsigned long max_pfn)
+{
+	struct memblock_type *type = &memblock.memory;
+	unsigned int right = type->cnt;
+	unsigned int mid, left = 0;
+	phys_addr_t addr = PFN_PHYS(pfn + 1);
+
+	do {
+		mid = (right + left) / 2;
+
+		if (addr < type->regions[mid].base)
+			right = mid;
+		else if (addr >= (type->regions[mid].base +
+				  type->regions[mid].size))
+			left = mid + 1;
+		else {
+			/* addr is within the region, so pfn + 1 is valid */
+			return min(pfn + 1, max_pfn);
+		}
+	} while (left < right);
+
+	return min(PHYS_PFN(type->regions[right].base), max_pfn);
+}
+
 /**
  * memblock_set_node - set node ID on memblock regions
  * @base: base of area to set node ID for
diff -puN mm/page_alloc.c~mm-page_alloc-skip-over-regions-of-invalid-pfns-where-possible mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-skip-over-regions-of-invalid-pfns-where-possible
+++ a/mm/page_alloc.c
@@ -5103,8 +5103,17 @@ void __meminit memmap_init_zone(unsigned
 		if (context != MEMMAP_EARLY)
 			goto not_early;
 
-		if (!early_pfn_valid(pfn))
+		if (!early_pfn_valid(pfn)) {
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+			/*
+			 * Skip to the pfn preceding the next valid one (or
+			 * end_pfn), such that we hit a valid pfn (or end_pfn)
+			 * on our next iteration of the loop.
+			 */
+			pfn = memblock_next_valid_pfn(pfn, end_pfn) - 1;
+#endif
 			continue;
+		}
 		if (!early_pfn_in_nid(pfn, nid))
 			continue;
 		if (!update_defer_init(pgdat, pfn, end_pfn, &nr_initialised))
_

Patches currently in -mm which might be from paul.burton@imgtec.com are


