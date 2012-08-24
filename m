From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-memblock-rename-get_allocated_memblock_reserved_regions_info.patch removed from -mm tree
Date: Fri, 24 Aug 2012 15:55:08 -0700
Message-ID: <20120824225509.4729F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:35295 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2HXWzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 18:55:11 -0400
Received: by mail-ey0-f202.google.com with SMTP id c1so112045eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 15:55:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwanp@linux.vnet.ibm.com, benh@kernel.crashing.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org, shangw@linux.vnet.ibm.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: rename get_allocated_memblock_reserved_regions_info()
has been removed from the -mm tree.  Its filename was
     mm-memblock-rename-get_allocated_memblock_reserved_regions_info.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/memblock: rename get_allocated_memblock_reserved_regions_info()

Rename get_allocated_memblock_reserved_regions_info() to
memblock_reserved_regions_info() so that the function name looks more
short and has prefix "memblock".

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    2 +-
 mm/memblock.c            |    2 +-
 mm/nobootmem.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-rename-get_allocated_memblock_reserved_regions_info include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-rename-get_allocated_memblock_reserved_regions_info
+++ a/include/linux/memblock.h
@@ -50,7 +50,7 @@ phys_addr_t memblock_find_in_range_node(
 				phys_addr_t size, phys_addr_t align, int nid);
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
-phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
+phys_addr_t memblock_reserved_regions_info(phys_addr_t *addr);
 void memblock_allow_resize(void);
 int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_add(phys_addr_t base, phys_addr_t size);
diff -puN mm/memblock.c~mm-memblock-rename-get_allocated_memblock_reserved_regions_info mm/memblock.c
--- a/mm/memblock.c~mm-memblock-rename-get_allocated_memblock_reserved_regions_info
+++ a/mm/memblock.c
@@ -160,7 +160,7 @@ static void __init_memblock memblock_rem
 	}
 }
 
-phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
+phys_addr_t __init_memblock memblock_reserved_regions_info(
 					phys_addr_t *addr)
 {
 	if (memblock.reserved.regions == memblock_reserved_init_regions)
diff -puN mm/nobootmem.c~mm-memblock-rename-get_allocated_memblock_reserved_regions_info mm/nobootmem.c
--- a/mm/nobootmem.c~mm-memblock-rename-get_allocated_memblock_reserved_regions_info
+++ a/mm/nobootmem.c
@@ -130,7 +130,7 @@ unsigned long __init free_low_memory_cor
 		count += __free_memory_core(start, end);
 
 	/* free range that is used for reserved array if we allocate it */
-	size = get_allocated_memblock_reserved_regions_info(&start);
+	size = memblock_reserved_regions_info(&start);
 	if (size)
 		count += __free_memory_core(start, start + size);
 
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-mmu_notifier-init-notifier-if-necessary.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-vmscan-fix-error-number-for-failed-kthread.patch

