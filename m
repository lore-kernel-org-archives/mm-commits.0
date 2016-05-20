From: akpm@linux-foundation.org
Subject: [patch 004/162] vmscan: consider classzone_idx in
 compaction_ready
Date: Fri, 20 May 2016 16:56:34 -0700
Message-ID: <573fa432.a58SZiMoQ5x0sm0n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETX4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com

From: Michal Hocko <mhocko@suse.com>
Subject: vmscan: consider classzone_idx in compaction_ready

Motivation:
As pointed by Linus [3][4] relying on zone_reclaimable as a way to
communicate the reclaim progress is rater dubious. I tend to agree,
not only it is really obscure, it is not hard to imagine cases where a
single page freed in the loop keeps all the reclaimers looping without
getting any progress because their gfp_mask wouldn't allow to get that
page anyway (e.g. single GFP_ATOMIC alloc and free loop). This is rather
rare so it doesn't happen in the practice but the current logic which we
have is rather obscure and hard to follow a also non-deterministic.

This is an attempt to make the OOM detection more deterministic and
easier to follow because each reclaimer basically tracks its own
progress which is implemented at the page allocator layer rather spread
out between the allocator and the reclaim. The more on the implementation
is described in the first patch.

I have tested several different scenarios but it should be clear that
testing OOM killer is quite hard to be representative. There is usually
a tiny gap between almost OOM and full blown OOM which is often time
sensitive. Anyway, I have tested the following 2 scenarios and I would
appreciate if there are more to test.

Testing environment: a virtual machine with 2G of RAM and 2CPUs without
any swap to make the OOM more deterministic.

1) 2 writers (each doing dd with 4M blocks to an xfs partition with 1G
   file size, removes the files and starts over again) running in
   parallel for 10s to build up a lot of dirty pages when 100 parallel
   mem_eaters (anon private populated mmap which waits until it gets
   signal) with 80M each.

   This causes an OOM flood of course and I have compared both patched
   and unpatched kernels. The test is considered finished after there
   are no OOM conditions detected. This should tell us whether there are
   any excessive kills or some of them premature (e.g. due to dirty pages):

I have performed two runs this time each after a fresh boot.

* base kernel
$ grep "Out of memory:" base-oom-run1.log | wc -l
78
$ grep "Out of memory:" base-oom-run2.log | wc -l
78

$ grep "Kill process" base-oom-run1.log | tail -n1
[   91.391203] Out of memory: Kill process 3061 (mem_eater) score 39 or sacrifice child
$ grep "Kill process" base-oom-run2.log | tail -n1
[   82.141919] Out of memory: Kill process 3086 (mem_eater) score 39 or sacrifice child

$ grep "DMA32 free:" base-oom-run1.log | sed 's@.*free:\([0-9]*\)kB.*@\1@' | calc_min_max.awk 
min: 5376.00 max: 6776.00 avg: 5530.75 std: 166.50 nr: 61
$ grep "DMA32 free:" base-oom-run2.log | sed 's@.*free:\([0-9]*\)kB.*@\1@' | calc_min_max.awk 
min: 5416.00 max: 5608.00 avg: 5514.15 std: 42.94 nr: 52

$ grep "DMA32.*all_unreclaimable? no" base-oom-run1.log | wc -l
1
$ grep "DMA32.*all_unreclaimable? no" base-oom-run2.log | wc -l
3

* patched kernel
$ grep "Out of memory:" patched-oom-run1.log | wc -l
78
miso@tiehlicka /mnt/share/devel/miso/kvm $ grep "Out of memory:" patched-oom-run2.log | wc -l
77

e grep "Kill process" patched-oom-run1.log | tail -n1
[  497.317732] Out of memory: Kill process 3108 (mem_eater) score 39 or sacrifice child
$ grep "Kill process" patched-oom-run2.log | tail -n1
[  316.169920] Out of memory: Kill process 3093 (mem_eater) score 39 or sacrifice child

$ grep "DMA32 free:" patched-oom-run1.log | sed 's@.*free:\([0-9]*\)kB.*@\1@' | calc_min_max.awk 
min: 5420.00 max: 5808.00 avg: 5513.90 std: 60.45 nr: 78
$ grep "DMA32 free:" patched-oom-run2.log | sed 's@.*free:\([0-9]*\)kB.*@\1@' | calc_min_max.awk 
min: 5380.00 max: 6384.00 avg: 5520.94 std: 136.84 nr: 77

e grep "DMA32.*all_unreclaimable? no" patched-oom-run1.log | wc -l
2
$ grep "DMA32.*all_unreclaimable? no" patched-oom-run2.log | wc -l
3

The patched kernel run noticeably longer while invoking OOM killer same
number of times. This means that the original implementation is much
more aggressive and triggers the OOM killer sooner. free pages stats
show that neither kernels went OOM too early most of the time, though. I
guess the difference is in the backoff when retries without any progress
do sleep for a while if there is memory under writeback or dirty which
is highly likely considering the parallel IO.
Both kernels have seen races where zone wasn't marked unreclaimable
and we still hit the OOM killer. This is most likely a race where
a task managed to exit between the last allocation attempt and the oom
killer invocation.

2) 2 writers again with 10s of run and then 10 mem_eaters to consume as much
   memory as possible without triggering the OOM killer. This required a lot
   of tuning but I've considered 3 consecutive runs in three different boots
   without OOM as a success.

* base kernel
size=$(awk '/MemFree/{printf "%dK", ($2/10)-(16*1024)}' /proc/meminfo)

* patched kernel
size=$(awk '/MemFree/{printf "%dK", ($2/10)-(12*1024)}' /proc/meminfo)

That means 40M more memory was usable without triggering OOM killer. The
base kernel sometimes managed to handle the same as patched but it
wasn't consistent and failed in at least on of the 3 runs. This seems
like a minor improvement.

I was testing also GPF_REPEAT costly requests (hughetlb) with fragmented
memory and under memory pressure. The results are in patch 11 where the
logic is implemented. In short I can see huge improvement there.

I am certainly interested in other usecases as well as well as any
feedback. Especially those which require higher order requests.


This patch (of 14):

While playing with the oom detection rework [1] I have noticed that my
heavy order-9 (hugetlb) load close to OOM ended up in an endless loop
where the reclaim hasn't made any progress but did_some_progress didn't
reflect that and compaction_suitable was backing off because no zone is
above low wmark + 1 << order.

It turned out that this is in fact an old standing bug in
compaction_ready which ignores the requested_highidx and did the
watermark check for 0 classzone_idx.  This succeeds for zone DMA most
of the time as the zone is mostly unused because of lowmem protection. 
As a result costly high order allocatios always report a successfull
progress even when there was none.  This wasn't a problem so far
because these allocations usually fail quite early or retry only few
times with __GFP_REPEAT but this will change after later patch in this
series so make sure to not lie about the progress and propagate
requested_highidx down to compaction_ready and use it for both the
watermak check and compaction_suitable to fix this issue.

[1] http://lkml.kernel.org/r/1459855533-4600-1-git-send-email-mhocko@kernel.org

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-consider-classzone_idx-in-compaction_ready mm/vmscan.c
--- a/mm/vmscan.c~vmscan-consider-classzone_idx-in-compaction_ready
+++ a/mm/vmscan.c
@@ -2459,7 +2459,7 @@ static bool shrink_zone(struct zone *zon
  * Returns true if compaction should go ahead for a high-order request, or
  * the high-order allocation would succeed without compaction.
  */
-static inline bool compaction_ready(struct zone *zone, int order)
+static inline bool compaction_ready(struct zone *zone, int order, int classzone_idx)
 {
 	unsigned long balance_gap, watermark;
 	bool watermark_ok;
@@ -2473,7 +2473,7 @@ static inline bool compaction_ready(stru
 	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
 			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
 	watermark = high_wmark_pages(zone) + balance_gap + (2UL << order);
-	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0);
+	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, classzone_idx);
 
 	/*
 	 * If compaction is deferred, reclaim up to a point where
@@ -2486,7 +2486,7 @@ static inline bool compaction_ready(stru
 	 * If compaction is not ready to start and allocation is not likely
 	 * to succeed without it, then keep reclaiming.
 	 */
-	if (compaction_suitable(zone, order, 0, 0) == COMPACT_SKIPPED)
+	if (compaction_suitable(zone, order, 0, classzone_idx) == COMPACT_SKIPPED)
 		return false;
 
 	return watermark_ok;
@@ -2566,7 +2566,7 @@ static bool shrink_zones(struct zonelist
 			if (IS_ENABLED(CONFIG_COMPACTION) &&
 			    sc->order > PAGE_ALLOC_COSTLY_ORDER &&
 			    zonelist_zone_idx(z) <= requested_highidx &&
-			    compaction_ready(zone, sc->order)) {
+			    compaction_ready(zone, sc->order, requested_highidx)) {
 				sc->compaction_ready = true;
 				continue;
 			}
_
