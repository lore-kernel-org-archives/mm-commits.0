From: akpm@linux-foundation.org
Subject: [merged] mm-nobootmem-clean-up-of-free_low_memory_core_early.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:21 -0700
Message-ID: <20130430185021.760155A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:36461 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab3D3SuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:22 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so86213qea.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, liuj97@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, nobootmem: clean-up of free_low_memory_core_early()
has been removed from the -mm tree.  Its filename was
     mm-nobootmem-clean-up-of-free_low_memory_core_early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, nobootmem: clean-up of free_low_memory_core_early()

Remove unused argument and make function static, because there is no user
outside of nobootmem.c

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    1 -
 mm/nobootmem.c          |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/bootmem.h~mm-nobootmem-clean-up-of-free_low_memory_core_early include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-nobootmem-clean-up-of-free_low_memory_core_early
+++ a/include/linux/bootmem.h
@@ -44,7 +44,6 @@ extern unsigned long init_bootmem_node(p
 				       unsigned long endpfn);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 
-extern unsigned long free_low_memory_core_early(int nodeid);
 extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
 extern unsigned long free_all_bootmem(void);
 
diff -puN mm/nobootmem.c~mm-nobootmem-clean-up-of-free_low_memory_core_early mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-clean-up-of-free_low_memory_core_early
+++ a/mm/nobootmem.c
@@ -120,7 +120,7 @@ static unsigned long __init __free_memor
 	return end_pfn - start_pfn;
 }
 
-unsigned long __init free_low_memory_core_early(int nodeid)
+static unsigned long __init free_low_memory_core_early(void)
 {
 	unsigned long count = 0;
 	phys_addr_t start, end, size;
@@ -170,7 +170,7 @@ unsigned long __init free_all_bootmem(vo
 	 *  because in some case like Node0 doesn't have RAM installed
 	 *  low ram will be on Node1
 	 */
-	return free_low_memory_core_early(MAX_NUMNODES);
+	return free_low_memory_core_early();
 }
 
 /**
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
linux-next.patch

