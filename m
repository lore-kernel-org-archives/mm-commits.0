From: akpm@linux-foundation.org
Subject: [merged] zram-use-__gfp_movable-for-memory-allocation.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 12:00:39 -0700
Message-ID: <579904d7.hmvFIIoNy4T0eJ6f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbcG0TAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:00:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use __GFP_MOVABLE for memory allocation
has been removed from the -mm tree.  Its filename was
     zram-use-__gfp_movable-for-memory-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: use __GFP_MOVABLE for memory allocation

Zsmalloc is ready for page migration so zram can use __GFP_MOVABLE
from now on.

I did test to see how it helps to make higher order pages.
Test scenario is as follows.

KVM guest, 1G memory, ext4 formated zram block device,

for i in `seq 1 8`;
do
        dd if=/dev/vda1 of=mnt/test$i.txt bs=128M count=1 &
done

wait `pidof dd`

for i in `seq 1 2 8`;
do
        rm -rf mnt/test$i.txt
done
fstrim -v mnt

echo "init"
cat /proc/buddyinfo

echo "compaction"
echo 1 > /proc/sys/vm/compact_memory
cat /proc/buddyinfo

old:

init
Node 0, zone      DMA    208    120     51     41     11      0      0      0      0      0      0
Node 0, zone    DMA32  16380  13777   9184   3805    789     54      3      0      0      0      0
compaction
Node 0, zone      DMA    132     82     40     39     16      2      1      0      0      0      0
Node 0, zone    DMA32   5219   5526   4969   3455   1831    677    139     15      0      0      0

new:

init
Node 0, zone      DMA    379    115     97     19      2      0      0      0      0      0      0
Node 0, zone    DMA32  18891  16774  10862   3947    637     21      0      0      0      0      0
compaction  1
Node 0, zone      DMA    214     66     87     29     10      3      0      0      0      0      0
Node 0, zone    DMA32   1612   3139   3154   2469   1745    990    384     94      7      0      0

As you can see, compaction made so many high-order pages. Yay!

Link: http://lkml.kernel.org/r/1464736881-24886-13-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-__gfp_movable-for-memory-allocation drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-__gfp_movable-for-memory-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -738,7 +738,8 @@ compress_again:
 		handle = zs_malloc(meta->mem_pool, clen,
 				__GFP_KSWAPD_RECLAIM |
 				__GFP_NOWARN |
-				__GFP_HIGHMEM);
+				__GFP_HIGHMEM |
+				__GFP_MOVABLE);
 	if (!handle) {
 		zcomp_stream_put(zram->comp);
 		zstrm = NULL;
@@ -746,7 +747,8 @@ compress_again:
 		atomic64_inc(&zram->stats.writestall);
 
 		handle = zs_malloc(meta->mem_pool, clen,
-				GFP_NOIO | __GFP_HIGHMEM);
+				GFP_NOIO | __GFP_HIGHMEM |
+				__GFP_MOVABLE);
 		if (handle)
 			goto compress_again;
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-page_alloc-fix-dirtyable-highmem-calculation.patch
mm-show-node_pages_scanned-per-node-not-zone.patch
mm-show-node_pages_scanned-per-node-not-zone-fix.patch
mm-add-per-zone-lru-list-stat.patch
mm-bail-out-in-shrin_inactive_list.patch

