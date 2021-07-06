Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D89C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD77361C97
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhGFTVx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231770AbhGFTVw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A89F561C99;
        Tue,  6 Jul 2021 19:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599154;
        bh=20ixpZZLC+ka4honEtxc//MG6of+BDsxBTQ9UYdYqjA=;
        h=Date:From:To:Subject:From;
        b=aCVM65FjLFEBzsPrdDE/MQsfRLY/UZyJRVZdrfbq+RM6TQT4kEJxPQoi64AmeGoLA
         +AfvPiIOwqCgLVsZyqJ1LGMtKMfQyzDihzMYOizvLZRWzyV7s5+8gs0tRBamcVNmrQ
         SYo2zui4tkOQ/K8ApKKJ+WLAEIqLIv/PyHHYn37U=
Date:   Tue, 06 Jul 2021 12:19:13 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, ardb@kernel.org,
        catalin.marinas@arm.com, david@redhat.com, mark.rutland@arm.com,
        maz@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        wangkefeng.wang@huawei.com, will@kernel.org
Subject:  [merged]
 memblock-update-initialization-of-reserved-pages.patch removed from -mm
 tree
Message-ID: <20210706191913.GUsCpU6CW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: update initialization of reserved pages
has been removed from the -mm tree.  Its filename was
     memblock-update-initialization-of-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: update initialization of reserved pages

The struct pages representing a reserved memory region are initialized
using reserve_bootmem_range() function.  This function is called for each
reserved region just before the memory is freed from memblock to the buddy
page allocator.

The struct pages for MEMBLOCK_NOMAP regions are kept with the default
values set by the memory map initialization which makes it necessary to
have a special treatment for such pages in pfn_valid() and
pfn_valid_within().

Split out initialization of the reserved pages to a function with a
meaningful name and treat the MEMBLOCK_NOMAP regions the same way as the
reserved regions and mark struct pages for the NOMAP regions as
PageReserved.

Link: https://lkml.kernel.org/r/20210511100550.28178-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 +++-
 mm/memblock.c            |   28 ++++++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 3 deletions(-)

--- a/include/linux/memblock.h~memblock-update-initialization-of-reserved-pages
+++ a/include/linux/memblock.h
@@ -30,7 +30,9 @@ extern unsigned long long max_possible_p
  * @MEMBLOCK_NONE: no special request
  * @MEMBLOCK_HOTPLUG: hotpluggable region
  * @MEMBLOCK_MIRROR: mirrored region
- * @MEMBLOCK_NOMAP: don't add to kernel direct mapping
+ * @MEMBLOCK_NOMAP: don't add to kernel direct mapping and treat as
+ * reserved in the memory map; refer to memblock_mark_nomap() description
+ * for further details
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
--- a/mm/memblock.c~memblock-update-initialization-of-reserved-pages
+++ a/mm/memblock.c
@@ -906,6 +906,11 @@ int __init_memblock memblock_mark_mirror
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
+ * The memory regions marked with %MEMBLOCK_NOMAP will not be added to the
+ * direct mapping of the physical memory. These regions will still be
+ * covered by the memory map. The struct page representing NOMAP memory
+ * frames in the memory map will be PageReserved()
+ *
  * Return: 0 on success, -errno on failure.
  */
 int __init_memblock memblock_mark_nomap(phys_addr_t base, phys_addr_t size)
@@ -2002,6 +2007,26 @@ static unsigned long __init __free_memor
 	return end_pfn - start_pfn;
 }
 
+static void __init memmap_init_reserved_pages(void)
+{
+	struct memblock_region *region;
+	phys_addr_t start, end;
+	u64 i;
+
+	/* initialize struct pages for the reserved regions */
+	for_each_reserved_mem_range(i, &start, &end)
+		reserve_bootmem_region(start, end);
+
+	/* and also treat struct pages for the NOMAP regions as PageReserved */
+	for_each_mem_region(region) {
+		if (memblock_is_nomap(region)) {
+			start = region->base;
+			end = start + region->size;
+			reserve_bootmem_region(start, end);
+		}
+	}
+}
+
 static unsigned long __init free_low_memory_core_early(void)
 {
 	unsigned long count = 0;
@@ -2010,8 +2035,7 @@ static unsigned long __init free_low_mem
 
 	memblock_clear_hotplug(0, -1);
 
-	for_each_reserved_mem_range(i, &start, &end)
-		reserve_bootmem_region(start, end);
+	memmap_init_reserved_pages();
 
 	/*
 	 * We need to use NUMA_NO_NODE instead of NODE_DATA(0)->node_id
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

