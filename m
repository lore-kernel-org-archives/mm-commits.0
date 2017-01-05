From: akpm@linux-foundation.org
Subject: + mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch added to
 -mm tree
Date: Thu, 05 Jan 2017 15:46:22 -0800
Message-ID: <586edace.TlC+UZ728rY4RLMY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55364 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162114AbdAEXpJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:45:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: remove unused mm_vmscan_memcg_isolate
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: remove unused mm_vmscan_memcg_isolate

Patch series "vm, vmscan: enahance vmscan tracepoints", v2.

While debugging [2] I've realized that there is some room for improvements
in the tracepoints set we offer currently.  I had hard times to make any
conclusion from the existing ones.  The resulting problem turned out to be
active list aging [3] and we are missing at least two tracepoints to debug
such a problem.

Some existing tracepoints could export more information to see _why_ the
reclaim progress cannot be made not only _how much_ we could reclaim.  The
later could be seen quite reasonably from the vmstat counters already.  It
can be argued that we are showing too many implementation details in those
tracepoints but I consider them way too lowlevel already to be usable by
any kernel independent userspace.  I would be _really_ surprised if
anything but debugging tools have used them.

Any feedback is highly appreciated.

[1] http://lkml.kernel.org/r/20161228153032.10821-1-mhocko@kernel.org
[2] http://lkml.kernel.org/r/20161215225702.GA27944@boerne.fritz.box
[3] http://lkml.kernel.org/r/20161223105157.GB23109@dhcp22.suse.cz


This patch (of 8):

The trace point is not used since 925b7673cce3 ("mm: make per-memcg LRU
lists exclusive") so it can be removed.

Link: http://lkml.kernel.org/r/20170104101942.4860-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   31 +------------------------------
 1 file changed, 1 insertion(+), 30 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-vmscan-remove-unused-mm_vmscan_memcg_isolate include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-remove-unused-mm_vmscan_memcg_isolate
+++ a/include/trace/events/vmscan.h
@@ -269,8 +269,7 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__entry->retval)
 );
 
-DECLARE_EVENT_CLASS(mm_vmscan_lru_isolate_template,
-
+TRACE_EVENT(mm_vmscan_lru_isolate,
 	TP_PROTO(int classzone_idx,
 		int order,
 		unsigned long nr_requested,
@@ -311,34 +310,6 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 		__entry->file)
 );
 
-DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_lru_isolate,
-
-	TP_PROTO(int classzone_idx,
-		int order,
-		unsigned long nr_requested,
-		unsigned long nr_scanned,
-		unsigned long nr_taken,
-		isolate_mode_t isolate_mode,
-		int file),
-
-	TP_ARGS(classzone_idx, order, nr_requested, nr_scanned, nr_taken, isolate_mode, file)
-
-);
-
-DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_memcg_isolate,
-
-	TP_PROTO(int classzone_idx,
-		int order,
-		unsigned long nr_requested,
-		unsigned long nr_scanned,
-		unsigned long nr_taken,
-		isolate_mode_t isolate_mode,
-		int file),
-
-	TP_ARGS(classzone_idx, order, nr_requested, nr_scanned, nr_taken, isolate_mode, file)
-
-);
-
 TRACE_EVENT(mm_vmscan_writepage,
 
 	TP_PROTO(struct page *page),
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch
bpf-do-not-use-kmalloc_shift_max.patch
mm-fix-remote-numa-hits-statistics.patch
mm-get-rid-of-__gfp_other_node.patch
mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch

