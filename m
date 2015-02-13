From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:20:41 -0800
Message-ID: <54de5c99.k63WefKqpAn4tHG1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbbBMUUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: stop the isolation when we isolate enough freepage
has been removed from the -mm tree.  Its filename was
     mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: stop the isolation when we isolate enough freepage

Currently, freepage isolation in one pageblock doesn't consider how many
freepages we isolate. When I traced flow of compaction, compaction
sometimes isolates more than 256 freepages to migrate just 32 pages.

In this patch, freepage isolation is stopped at the point that we
have more isolated freepage than isolated page for migration. This
results in slowing down free page scanner and make compaction success
rate higher.

stress-highalloc test in mmtests with non movable order 7 allocation shows
increase of compaction success rate.

Compaction success rate (Compaction success * 100 / Compaction stalls, %)
27.13 : 31.82

pfn where both scanners meets on compaction complete
(separate test due to enormous tracepoint buffer)
(zone_start=4096, zone_end=1048576)
586034 : 654378

In fact, I didn't fully understand why this patch results in such good
result. There was a guess that not used freepages are released to pcp list
and on next compaction trial we won't isolate them again so compaction
success rate would decrease. To prevent this effect, I tested with adding
pcp drain code on release_freepages(), but, it has no good effect.

Anyway, this patch reduces waste time to isolate unneeded freepages so
seems reasonable.

Vlastimil said:

: I briefly tried it on top of the pivot-changing series and with order-9
: allocations it reduced free page scanned counter by almost 10%.  No effect
: on success rates (maybe because pivot changing already took care of the
: scanners meeting problem) but the scanning reduction is good on its own.
: 
: It also explains why e14c720efdd7 ("mm, compaction: remember position
: within pageblock in free pages scanner") had less than expected
: improvements.  It would only actually stop within pageblock in case of
: async compaction detecting contention.  I guess that's also why the
: infinite loop problem fixed by 1d5bfe1ffb5b affected so relatively few
: people.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN mm/compaction.c~mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage mm/compaction.c
--- a/mm/compaction.c~mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage
+++ a/mm/compaction.c
@@ -490,6 +490,13 @@ static unsigned long isolate_freepages_b
 
 		/* If a page was split, advance to the end of it */
 		if (isolated) {
+			cc->nr_freepages += isolated;
+			if (!strict &&
+				cc->nr_migratepages <= cc->nr_freepages) {
+				blockpfn += isolated;
+				break;
+			}
+
 			blockpfn += isolated - 1;
 			cursor += isolated - 1;
 			continue;
@@ -899,7 +906,6 @@ static void isolate_freepages(struct com
 	unsigned long isolate_start_pfn; /* exact pfn we start at */
 	unsigned long block_end_pfn;	/* end of current pageblock */
 	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
-	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
 	/*
@@ -924,11 +930,11 @@ static void isolate_freepages(struct com
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
 	 */
-	for (; block_start_pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
+	for (; block_start_pfn >= low_pfn &&
+			cc->nr_migratepages > cc->nr_freepages;
 				block_end_pfn = block_start_pfn,
 				block_start_pfn -= pageblock_nr_pages,
 				isolate_start_pfn = block_start_pfn) {
-		unsigned long isolated;
 
 		/*
 		 * This can iterate a massively long zone without finding any
@@ -953,9 +959,8 @@ static void isolate_freepages(struct com
 			continue;
 
 		/* Found a block suitable for isolating free pages from. */
-		isolated = isolate_freepages_block(cc, &isolate_start_pfn,
+		isolate_freepages_block(cc, &isolate_start_pfn,
 					block_end_pfn, freelist, false);
-		nr_freepages += isolated;
 
 		/*
 		 * Remember where the free scanner should restart next time,
@@ -987,8 +992,6 @@ static void isolate_freepages(struct com
 	 */
 	if (block_start_pfn < low_pfn)
 		cc->free_pfn = cc->migrate_pfn;
-
-	cc->nr_freepages = nr_freepages;
 }
 
 /*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
mm-slub-introduce-virt_to_obj-function.patch
mm-slub-share-object_err-function.patch
mm-slub-introduce-metadata_access_enable-metadata_access_disable.patch
mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
kmemleak-disable-kasan-instrumentation-for-kmemleak.patch
lib-add-kasan-test-module.patch
x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
kasan-enable-stack-instrumentation.patch
mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch
mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
kernel-add-support-for-init_array-constructors.patch
module-fix-types-of-device-tables-aliases.patch
kasan-enable-instrumentation-of-global-variables.patch

