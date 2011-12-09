From: akpm@linux-foundation.org
Subject: [wrecked] memblock-add-input-size-checking-to-memblock_find_region.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:06:30 -0800
Message-ID: <201112092006.pB9K6VeO019329@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56158 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab1LIUGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:06:44 -0500
Received: by eekc14 with SMTP id c14so73181eek.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:06:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, akpm@linux-foundation.org, benh@kernel.crashing.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: add input size checking to memblock_find_region()
has been removed from the -mm tree.  Its filename was
     memblock-add-input-size-checking-to-memblock_find_region.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: memblock: add input size checking to memblock_find_region()

Make sure two callers have right inputs.  and add print warning to catch
other offending callers.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memblock.c~memblock-add-input-size-checking-to-memblock_find_region mm/memblock.c
--- a/mm/memblock.c~memblock-add-input-size-checking-to-memblock_find_region
+++ a/mm/memblock.c
@@ -85,7 +85,7 @@ static phys_addr_t __init_memblock membl
 	long j;
 
 	/* In case, huge size is requested */
-	if (end < size)
+	if (WARN_ONCE(end < size, "memblock_find_region: wrong range [%#llx-%#llx] size %#llx", start, end, size))
 		return MEMBLOCK_ERROR;
 
 	base = memblock_align_down((end - size), align);
@@ -129,14 +129,14 @@ static phys_addr_t __init_memblock membl
 		phys_addr_t memblocksize = memblock.memory.regions[i].size;
 		phys_addr_t bottom, top, found;
 
-		if (memblocksize < size)
-			continue;
 		if ((memblockbase + memblocksize) <= start)
 			break;
 		bottom = max(memblockbase, start);
 		top = min(memblockbase + memblocksize, end);
 		if (bottom >= top)
 			continue;
+		if ((top - bottom) < size)
+			continue;
 		found = memblock_find_region(bottom, top, size, align);
 		if (found != MEMBLOCK_ERROR)
 			return found;
@@ -569,7 +569,7 @@ static phys_addr_t __init memblock_alloc
 		int this_nid;
 
 		this_end = memblock_nid_range(start, end, &this_nid);
-		if (this_nid == nid) {
+		if (this_nid == nid && (this_end - start) >= size) {
 			phys_addr_t ret = memblock_find_region(start, this_end, size, align);
 			if (ret != MEMBLOCK_ERROR &&
 			    !memblock_add_region(&memblock.reserved, ret, size))
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

