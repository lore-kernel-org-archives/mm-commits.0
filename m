From: akpm@linux-foundation.org
Subject: [withdrawn] mm-use-memblock_alloc_range.patch removed from -mm
 tree
Date: Wed, 03 Sep 2014 16:11:33 -0700
Message-ID: <5407a025./JjPDrCFLubJVR6t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673AbaICXLe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 19:11:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use memblock_alloc_range()
has been removed from the -mm tree.  Its filename was
     mm-use-memblock_alloc_range.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm: use memblock_alloc_range()

Replace memblock_find_in_range() and memblock_reserve() with
the equivalent memblock_alloc_range().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN mm/memblock.c~mm-use-memblock_alloc_range mm/memblock.c
--- a/mm/memblock.c~mm-use-memblock_alloc_range
+++ a/mm/memblock.c
@@ -1154,21 +1154,16 @@ static void * __init memblock_virt_alloc
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, nid);
 
-	if (!align)
-		align = SMP_CACHE_BYTES;
-
 	if (max_addr > memblock.current_limit)
 		max_addr = memblock.current_limit;
 
 again:
-	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
-					    nid);
+	alloc = memblock_alloc_range_nid(size, align, min_addr, max_addr, nid);
 	if (alloc)
 		goto done;
 
 	if (nid != NUMA_NO_NODE) {
-		alloc = memblock_find_in_range_node(size, align, min_addr,
-						    max_addr,  NUMA_NO_NODE);
+		alloc = memblock_alloc_range(size, align, min_addr, max_addr);
 		if (alloc)
 			goto done;
 	}
@@ -1181,7 +1176,6 @@ again:
 	}
 
 done:
-	memblock_reserve(alloc, size);
 	ptr = phys_to_virt(alloc);
 	memset(ptr, 0, size);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

vfs-make-guard_bh_eod-more-generic.patch
vfs-guard-end-of-device-for-mpage-interface.patch
block_dev-implement-readpages-to-optimize-sequential-read.patch
linux-next.patch

