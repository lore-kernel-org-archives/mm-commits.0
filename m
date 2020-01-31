From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-define-memblock_physmem_add.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:18:46 -0800
Message-ID: <20200131231846.vE4TFa3lx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXSs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, borntraeger@de.ibm.com, gerald.schaefer@de.ibm.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org, prudo@linux.ibm.com, rppt@linux.ibm.com, schwidefsky@de.ibm.com, walling@linux.ibm.com


The patch titled
     Subject: mm/memblock: define memblock_physmem_add()
has been removed from the -mm tree.  Its filename was
     mm-memblock-define-memblock_physmem_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/memblock: define memblock_physmem_add()

On s390 platform memblock.physmem array is being built by directly calling
into memblock_add_range() which is a low level function not intended to be
used outside of memblock.  Hence lets conditionally add helper functions
for physmem array when HAVE_MEMBLOCK_PHYS_MAP is enabled.  Also use
MAX_NUMNODES instead of 0 as node ID similar to memblock_add() and
memblock_reserve().  Make memblock_add_range() a static function as it is
no longer getting used outside of memblock.

Link: http://lkml.kernel.org/r/1578283835-21969-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Collin Walling <walling@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Philipp Rudo <prudo@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/setup.c |   12 +++---------
 include/linux/memblock.h |    7 +++----
 mm/memblock.c            |   14 +++++++++++++-
 3 files changed, 19 insertions(+), 14 deletions(-)

--- a/arch/s390/kernel/setup.c~mm-memblock-define-memblock_physmem_add
+++ a/arch/s390/kernel/setup.c
@@ -759,14 +759,6 @@ static void __init free_mem_detect_info(
 		memblock_free(start, size);
 }
 
-static void __init memblock_physmem_add(phys_addr_t start, phys_addr_t size)
-{
-	memblock_dbg("memblock_physmem_add: [%#016llx-%#016llx]\n",
-		     start, start + size - 1);
-	memblock_add_range(&memblock.memory, start, size, 0, 0);
-	memblock_add_range(&memblock.physmem, start, size, 0, 0);
-}
-
 static const char * __init get_mem_info_source(void)
 {
 	switch (mem_detect.info_source) {
@@ -791,8 +783,10 @@ static void __init memblock_add_mem_dete
 		     get_mem_info_source(), mem_detect.info_source);
 	/* keep memblock lists close to the kernel */
 	memblock_set_bottom_up(true);
-	for_each_mem_detect_block(i, &start, &end)
+	for_each_mem_detect_block(i, &start, &end) {
+		memblock_add(start, end - start);
 		memblock_physmem_add(start, end - start);
+	}
 	memblock_set_bottom_up(false);
 	memblock_dump_all();
 }
--- a/include/linux/memblock.h~mm-memblock-define-memblock_physmem_add
+++ a/include/linux/memblock.h
@@ -113,6 +113,9 @@ int memblock_add(phys_addr_t base, phys_
 int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
+#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
+int memblock_physmem_add(phys_addr_t base, phys_addr_t size);
+#endif
 void memblock_trim_memory(phys_addr_t align);
 bool memblock_overlaps_region(struct memblock_type *type,
 			      phys_addr_t base, phys_addr_t size);
@@ -127,10 +130,6 @@ void reset_node_managed_pages(pg_data_t
 void reset_all_zones_managed_pages(void);
 
 /* Low level functions */
-int memblock_add_range(struct memblock_type *type,
-		       phys_addr_t base, phys_addr_t size,
-		       int nid, enum memblock_flags flags);
-
 void __next_mem_range(u64 *idx, int nid, enum memblock_flags flags,
 		      struct memblock_type *type_a,
 		      struct memblock_type *type_b, phys_addr_t *out_start,
--- a/mm/memblock.c~mm-memblock-define-memblock_physmem_add
+++ a/mm/memblock.c
@@ -575,7 +575,7 @@ static void __init_memblock memblock_ins
  * Return:
  * 0 on success, -errno on failure.
  */
-int __init_memblock memblock_add_range(struct memblock_type *type,
+static int __init_memblock memblock_add_range(struct memblock_type *type,
 				phys_addr_t base, phys_addr_t size,
 				int nid, enum memblock_flags flags)
 {
@@ -830,6 +830,18 @@ int __init_memblock memblock_reserve(phy
 	return memblock_add_range(&memblock.reserved, base, size, MAX_NUMNODES, 0);
 }
 
+#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
+int __init_memblock memblock_physmem_add(phys_addr_t base, phys_addr_t size)
+{
+	phys_addr_t end = base + size - 1;
+
+	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
+		     &base, &end, (void *)_RET_IP_);
+
+	return memblock_add_range(&memblock.physmem, base, size, MAX_NUMNODES, 0);
+}
+#endif
+
 /**
  * memblock_setclr_flag - set or clear flag for a memory region
  * @base: base address of the region
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are
