From: akpm@linux-foundation.org
Subject: [merged] mm-nobootmem-do-memset-after-memblock_reserve.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:24 -0700
Message-ID: <20130430185024.7AF6B5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:49213 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab3D3Su0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:26 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so86118qcr.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, liuj97@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, nobootmem: do memset() after memblock_reserve()
has been removed from the -mm tree.  Its filename was
     mm-nobootmem-do-memset-after-memblock_reserve.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, nobootmem: do memset() after memblock_reserve()

Currently, we do memset() before reserving the area.  This may not cause
any problem, but it is somewhat weird.  So change execution order.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/nobootmem.c~mm-nobootmem-do-memset-after-memblock_reserve mm/nobootmem.c
--- a/mm/nobootmem.c~mm-nobootmem-do-memset-after-memblock_reserve
+++ a/mm/nobootmem.c
@@ -45,9 +45,9 @@ static void * __init __alloc_memory_core
 	if (!addr)
 		return NULL;
 
+	memblock_reserve(addr, size);
 	ptr = phys_to_virt(addr);
 	memset(ptr, 0, size);
-	memblock_reserve(addr, size);
 	/*
 	 * The min_count is set to 0 so that bootmem allocated blocks
 	 * are never reported as leaks.
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
linux-next.patch

