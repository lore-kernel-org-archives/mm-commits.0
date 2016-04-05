From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zram-use-__gfp_movable-for-memory-allocation.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:14:27 -0700
Message-ID: <57042ab3.DRA5n0jHbHEwC61+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760146AbcDEVO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:14:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use __GFP_MOVABLE for memory allocation
has been removed from the -mm tree.  Its filename was
     zram-use-__gfp_movable-for-memory-allocation.patch

This patch was dropped because an updated version will be merged

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

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Russ Knize <rknize@motorola.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Chan Gyun Jeong <chan.jeong@lge.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: YiPing Xu <xuyiping@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 ++-
 mm/zsmalloc.c                 |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-__gfp_movable-for-memory-allocation drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-__gfp_movable-for-memory-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -514,7 +514,8 @@ static struct zram_meta *zram_meta_alloc
 		goto out_error;
 	}
 
-	meta->mem_pool = zs_create_pool(pool_name, GFP_NOIO | __GFP_HIGHMEM);
+	meta->mem_pool = zs_create_pool(pool_name, GFP_NOIO|__GFP_HIGHMEM
+						|__GFP_MOVABLE);
 	if (!meta->mem_pool) {
 		pr_err("Error creating memory pool\n");
 		goto out_error;
diff -puN mm/zsmalloc.c~zram-use-__gfp_movable-for-memory-allocation mm/zsmalloc.c
--- a/mm/zsmalloc.c~zram-use-__gfp_movable-for-memory-allocation
+++ a/mm/zsmalloc.c
@@ -308,7 +308,7 @@ static void destroy_handle_cache(struct
 static unsigned long alloc_handle(struct zs_pool *pool)
 {
 	return (unsigned long)kmem_cache_alloc(pool->handle_cachep,
-		pool->flags & ~__GFP_HIGHMEM);
+		pool->flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
 }
 
 static void free_handle(struct zs_pool *pool, unsigned long handle)
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch

