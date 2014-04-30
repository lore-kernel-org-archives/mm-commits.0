From: akpm@linux-foundation.org
Subject: + mm-shrinker-trace-points-fix-negatives.patch added to -mm tree
Date: Wed, 30 Apr 2014 15:26:40 -0700
Message-ID: <536178a0.Ba1vuORNojOkNP3T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759584AbaD3W0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 18:26:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khlebnikov@openvz.org, david@fromorbit.com, dave.hansen@linux.intel.com

Subject: + mm-shrinker-trace-points-fix-negatives.patch added to -mm tree
To: dave.hansen@linux.intel.com,david@fromorbit.com,khlebnikov@openvz.org
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 15:26:40 -0700


The patch titled
     Subject: mm: shrinker trace points: fix negatives
has been added to the -mm tree.  Its filename is
     mm-shrinker-trace-points-fix-negatives.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shrinker-trace-points-fix-negatives.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shrinker-trace-points-fix-negatives.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: shrinker trace points: fix negatives

I was looking at a trace of the slab shrinkers (attachment in this comment):

	https://bugs.freedesktop.org/show_bug.cgi?id=72742#c67

and noticed that "total_scan" can go negative in some cases.  We
used to dump out the "total_scan" variable directly, but some of
the shrinker modifications along the way changed that.

This patch just dumps it out directly, again.  It doesn't make
any sense to derive it from new_nr and nr any more since there
are now other shrinkers that can be running in parallel and
mucking with those values.

Here's an example of the negative numbers in the output:

>          kswapd0-840   [000]   160.869398: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 10 new scan count 39 total_scan 29 last shrinker return val 256
>          kswapd0-840   [000]   160.869618: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 39 new scan count 102 total_scan 63 last shrinker return val 256
>          kswapd0-840   [000]   160.870031: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 102 new scan count 47 total_scan -55 last shrinker return val 768
>          kswapd0-840   [000]   160.870464: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 47 new scan count 45 total_scan -2 last shrinker return val 768
>          kswapd0-840   [000]   163.384144: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 45 new scan count 56 total_scan 11 last shrinker return val 0
>          kswapd0-840   [000]   163.384297: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 56 new scan count 15 total_scan -41 last shrinker return val 256
>          kswapd0-840   [000]   163.384414: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 15 new scan count 117 total_scan 102 last shrinker return val 0
>          kswapd0-840   [000]   163.384657: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 117 new scan count 36 total_scan -81 last shrinker return val 512
>          kswapd0-840   [000]   163.384880: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 36 new scan count 111 total_scan 75 last shrinker return val 256
>          kswapd0-840   [000]   163.385256: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 111 new scan count 34 total_scan -77 last shrinker return val 768
>          kswapd0-840   [000]   163.385598: mm_shrink_slab_end:   i915_gem_inactive_scan+0x0 0xffff8800037cbc68: unused scan count 34 new scan count 122 total_scan 88 last shrinker return val 512

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |    6 +++---
 mm/vmscan.c                   |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-shrinker-trace-points-fix-negatives include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-shrinker-trace-points-fix-negatives
+++ a/include/trace/events/vmscan.h
@@ -226,9 +226,9 @@ TRACE_EVENT(mm_shrink_slab_start,
 
 TRACE_EVENT(mm_shrink_slab_end,
 	TP_PROTO(struct shrinker *shr, int shrinker_retval,
-		long unused_scan_cnt, long new_scan_cnt),
+		long unused_scan_cnt, long new_scan_cnt, long total_scan),
 
-	TP_ARGS(shr, shrinker_retval, unused_scan_cnt, new_scan_cnt),
+	TP_ARGS(shr, shrinker_retval, unused_scan_cnt, new_scan_cnt, total_scan),
 
 	TP_STRUCT__entry(
 		__field(struct shrinker *, shr)
@@ -245,7 +245,7 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__entry->unused_scan = unused_scan_cnt;
 		__entry->new_scan = new_scan_cnt;
 		__entry->retval = shrinker_retval;
-		__entry->total_scan = new_scan_cnt - unused_scan_cnt;
+		__entry->total_scan = total_scan;
 	),
 
 	TP_printk("%pF %p: unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
diff -puN mm/vmscan.c~mm-shrinker-trace-points-fix-negatives mm/vmscan.c
--- a/mm/vmscan.c~mm-shrinker-trace-points-fix-negatives
+++ a/mm/vmscan.c
@@ -327,7 +327,7 @@ shrink_slab_node(struct shrink_control *
 	else
 		new_nr = atomic_long_read(&shrinker->nr_deferred[nid]);
 
-	trace_mm_shrink_slab_end(shrinker, freed, nr, new_nr);
+	trace_mm_shrink_slab_end(shrinker, freed, nr, new_nr, total_scan);
 	return freed;
 }
 
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
mm-debug-make-bad_range-output-more-usable-and-readable.patch
mm-shrinker-trace-points-fix-negatives.patch
mm-shrinker-add-nid-to-tracepoint-output.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

