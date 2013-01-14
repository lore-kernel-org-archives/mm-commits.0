From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-fix-wrong-memmove-size-in-memblock_merge_regions.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:38:22 -0800
Message-ID: <20130114203822.ACB00820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:54633 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab3ANUiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:38:23 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so264951ghb.3
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:38:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linfeng@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memblock: fix wrong memmove size in memblock_merge_regions()
has been removed from the -mm tree.  Its filename was
     mm-memblock-fix-wrong-memmove-size-in-memblock_merge_regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lin Feng <linfeng@cn.fujitsu.com>
Subject: mm: memblock: fix wrong memmove size in memblock_merge_regions()

The memmove span covers from (next+1) to the end of the array, and the
index of next is (i+1), so the index of (next+1) is (i+2).  So the size of
remaining array elements is (type->cnt - (i + 2)).

Since the remaining elements of the memblock array are move forward by one
element and there is only one additional element caused by this bug.  So
there won't be any write overflow here but read overflow.  It may read one
more element out of the array address if the array happens to be full. 
Commonly it doesn't matter at all but if the array happens to be located
at the end a memblock, it may cause a invalid read operation for the
physical address doesn't exist.  

There are 2 *happens to be* here, so I think the probability is quite low,
I don't know if any guy is haunted by this bug before.  

Mostly I think it's user-invisible.

Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblock-fix-wrong-memmove-size-in-memblock_merge_regions mm/memblock.c
--- a/mm/memblock.c~mm-memblock-fix-wrong-memmove-size-in-memblock_merge_regions
+++ a/mm/memblock.c
@@ -314,7 +314,8 @@ static void __init_memblock memblock_mer
 		}
 
 		this->size += next->size;
-		memmove(next, next + 1, (type->cnt - (i + 1)) * sizeof(*next));
+		/* move forward from next + 1, index of which is i + 2 */
+		memmove(next, next + 1, (type->cnt - (i + 2)) * sizeof(*next));
 		type->cnt--;
 	}
 }
_

Patches currently in -mm which might be from linfeng@cn.fujitsu.com are

origin.patch
mmots-memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch

