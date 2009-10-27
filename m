From: akpm@linux-foundation.org
Subject: [to-be-updated] sparc-use-bitmap_find_next_zero_area.patch removed from -mm tree
Date: Tue, 27 Oct 2009 01:19:54 -0700
Message-ID: <200910270819.n9R8Jsqc014783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932124AbZJ0IUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Oct 2009 04:20:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     sparc: use bitmap_find_next_zero_area()
has been removed from the -mm tree.  Its filename was
     sparc-use-bitmap_find_next_zero_area.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc: use bitmap_find_next_zero_area()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/sparc/kernel/ldc.c~sparc-use-bitmap_find_next_zero_area arch/sparc/kernel/ldc.c
--- a/arch/sparc/kernel/ldc.c~sparc-use-bitmap_find_next_zero_area
+++ a/arch/sparc/kernel/ldc.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/init.h>
+#include <linux/bitmap.h>
 
 #include <asm/hypervisor.h>
 #include <asm/iommu.h>
@@ -1875,7 +1876,7 @@ EXPORT_SYMBOL(ldc_read);
 static long arena_alloc(struct ldc_iommu *iommu, unsigned long npages)
 {
 	struct iommu_arena *arena = &iommu->arena;
-	unsigned long n, i, start, end, limit;
+	unsigned long n, start, end, limit;
 	int pass;
 
 	limit = arena->limit;
@@ -1883,7 +1884,7 @@ static long arena_alloc(struct ldc_iommu
 	pass = 0;
 
 again:
-	n = find_next_zero_bit(arena->map, limit, start);
+	n = bitmap_find_next_zero_area(arena->map, limit, start, npages, 0);
 	end = n + npages;
 	if (unlikely(end >= limit)) {
 		if (likely(pass < 1)) {
@@ -1896,16 +1897,7 @@ again:
 			return -1;
 		}
 	}
-
-	for (i = n; i < end; i++) {
-		if (test_bit(i, arena->map)) {
-			start = i + 1;
-			goto again;
-		}
-	}
-
-	for (i = n; i < end; i++)
-		__set_bit(i, arena->map);
+	bitmap_set(arena->map, n, npages);
 
 	arena->hint = end;
 
diff -puN arch/sparc/mm/sun4c.c~sparc-use-bitmap_find_next_zero_area arch/sparc/mm/sun4c.c
--- a/arch/sparc/mm/sun4c.c~sparc-use-bitmap_find_next_zero_area
+++ a/arch/sparc/mm/sun4c.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/scatterlist.h>
+#include <linux/bitmap.h>
 
 #include <asm/sections.h>
 #include <asm/page.h>
@@ -1021,20 +1022,12 @@ static char *sun4c_lockarea(char *vaddr,
 	npages = (((unsigned long)vaddr & ~PAGE_MASK) +
 		  size + (PAGE_SIZE-1)) >> PAGE_SHIFT;
 
-	scan = 0;
 	local_irq_save(flags);
-	for (;;) {
-		scan = find_next_zero_bit(sun4c_iobuffer_map,
-					  iobuffer_map_size, scan);
-		if ((base = scan) + npages > iobuffer_map_size) goto abend;
-		for (;;) {
-			if (scan >= base + npages) goto found;
-			if (test_bit(scan, sun4c_iobuffer_map)) break;
-			scan++;
-		}
-	}
+	base = bitmap_find_next_zero_area(sun4c_iobuffer_map, iobuffer_map_size,
+						0, npages, 0);
+	if (base >= iobuffer_map_size)
+		goto abend;
 
-found:
 	high = ((base + npages) << PAGE_SHIFT) + sun4c_iobuffer_start;
 	high = SUN4C_REAL_PGDIR_ALIGN(high);
 	while (high > sun4c_iobuffer_high) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

