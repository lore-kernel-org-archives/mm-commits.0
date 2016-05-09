From: akpm@linux-foundation.org
Subject: [patch 2/3] zsmalloc: fix zs_can_compact() integer overflow
Date: Mon, 09 May 2016 16:28:49 -0700
Message-ID: <57311d31.sZRb6GnY06xtxjTf%akpm__26026.7784972259$1462836544$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbcEIX2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 19:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sergey.senozhatsky@gmail.com, minchan@kernel.org, stable@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: fix zs_can_compact() integer overflow

zs_can_compact() has two race conditions in its core calculation:

unsigned long obj_wasted = zs_stat_get(class, OBJ_ALLOCATED) -
				zs_stat_get(class, OBJ_USED);

1) classes are not locked, so the numbers of allocated and used
   objects can change by the concurrent ops happening on other CPUs
2) shrinker invokes it from preemptible context

Depending on the circumstances, thus, OBJ_ALLOCATED can become
less than OBJ_USED, which can result in either very high or
negative `total_scan' value calculated later in do_shrink_slab().

do_shrink_slab() has some logic to prevent those cases:

 vmscan: shrink_slab: zs_shrinker_scan+0x0/0x28 [zsmalloc] negative objects to delete nr=-62
 vmscan: shrink_slab: zs_shrinker_scan+0x0/0x28 [zsmalloc] negative objects to delete nr=-62
 vmscan: shrink_slab: zs_shrinker_scan+0x0/0x28 [zsmalloc] negative objects to delete nr=-64
 vmscan: shrink_slab: zs_shrinker_scan+0x0/0x28 [zsmalloc] negative objects to delete nr=-62
 vmscan: shrink_slab: zs_shrinker_scan+0x0/0x28 [zsmalloc] negative objects to delete nr=-62
 vmscan: shrink_slab: zs_shrinker_scan+0x0/0x28 [zsmalloc] negative objects to delete nr=-62

However, due to the way `total_scan' is calculated, not every
shrinker->count_objects() overflow can be spotted and handled.
To demonstrate the latter, I added some debugging code to do_shrink_slab()
(x86_64) and the results were:

 vmscan: OVERFLOW: shrinker->count_objects() == -1 [18446744073709551615]
 vmscan: but total_scan > 0: 92679974445502
 vmscan: resulting total_scan: 92679974445502
[..]
 vmscan: OVERFLOW: shrinker->count_objects() == -1 [18446744073709551615]
 vmscan: but total_scan > 0: 22634041808232578
 vmscan: resulting total_scan: 22634041808232578

Even though shrinker->count_objects() has returned an overflowed value,
the resulting `total_scan' is positive, and, what is more worrisome, it
is insanely huge. This value is getting used later on in
shrinker->scan_objects() loop:

        while (total_scan >= batch_size ||
               total_scan >= freeable) {
                unsigned long ret;
                unsigned long nr_to_scan = min(batch_size, total_scan);

                shrinkctl->nr_to_scan = nr_to_scan;
                ret = shrinker->scan_objects(shrinker, shrinkctl);
                if (ret == SHRINK_STOP)
                        break;
                freed += ret;

                count_vm_events(SLABS_SCANNED, nr_to_scan);
                total_scan -= nr_to_scan;

                cond_resched();
        }

`total_scan >= batch_size' is true for a very-very long time and
'total_scan >= freeable' is also true for quite some time, because
`freeable < 0' and `total_scan' is large enough, for example,
22634041808232578. The only break condition, in the given scheme of
things, is shrinker->scan_objects() == SHRINK_STOP test, which is a
bit too weak to rely on, especially in heavy zsmalloc-usage scenarios.

To fix the issue, take a pool stat snapshot and use it instead of
racy zs_stat_get() calls.

Link: http://lkml.kernel.org/r/20160509140052.3389-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>        [4.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-fix-zs_can_compact-integer-overflow mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fix-zs_can_compact-integer-overflow
+++ a/mm/zsmalloc.c
@@ -1735,10 +1735,13 @@ static struct page *isolate_source_page(
 static unsigned long zs_can_compact(struct size_class *class)
 {
 	unsigned long obj_wasted;
+	unsigned long obj_allocated = zs_stat_get(class, OBJ_ALLOCATED);
+	unsigned long obj_used = zs_stat_get(class, OBJ_USED);
 
-	obj_wasted = zs_stat_get(class, OBJ_ALLOCATED) -
-		zs_stat_get(class, OBJ_USED);
+	if (obj_allocated <= obj_used)
+		return 0;
 
+	obj_wasted = obj_allocated - obj_used;
 	obj_wasted /= get_maxobj_per_zspage(class->size,
 			class->pages_per_zspage);
 
_
