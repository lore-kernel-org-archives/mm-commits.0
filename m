From: akpm@linux-foundation.org
Subject: + mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch added
 to -mm tree
Date: Tue, 17 Jan 2017 14:34:52 -0800
Message-ID: <587e9c0c.xCe644AjMOfG6w/C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751262AbdAQWna (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 17:43:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: do not report all nodes in show_mem
has been added to the -mm tree.  Its filename is
     mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch

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
Subject: mm, page_alloc: do not report all nodes in show_mem

Patch series "show_mem updates", v2.

This is a mixture of one bug fix (patch 1), an enhancement (patch 2) and
cleanups (the rest of the series).  First two patches should be really
straightforward.  Patch 3 removes some arch specific show_mem
implementations because I think they are quite outdated and do not really
serve any useful purpose anymore.  I think we should really strive to have
a consistent show_mem output regardless of the architecture.  If some
architecture is really special and wants to dump something additional we
should do that via an arch specific hook.

The last patch adds nodemask parameter so that we do not rely on the
hardcoded mems_allowed of the current task when doing the node filtering. 
I consider this more a cleanup than a fix because basically all users use
a nodemask which is a subset of mems_allowed.  There is only one call path
in the memory hotplug which doesn't comply with this but that is hardly
something to worry about.


This patch (of 4):

599d0c954f91 ("mm, vmscan: move LRU lists to node") has added per numa
node statistics to show_mem but it forgot to add skip_free_areas_node to
fileter out nodes which are outside of the allocating task numa policy. 
Add this check to not pollute the output with the pointless information.

Link: http://lkml.kernel.org/r/20170117091543.25850-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-do-not-report-all-nodes-in-show_mem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-do-not-report-all-nodes-in-show_mem
+++ a/mm/page_alloc.c
@@ -4423,6 +4423,9 @@ void show_free_areas(unsigned int filter
 		global_page_state(NR_FREE_CMA_PAGES));
 
 	for_each_online_pgdat(pgdat) {
+		if (skip_free_areas_node(filter, pgdat->node_id))
+			continue;
+
 		printk("Node %d"
 			" active_anon:%lukB"
 			" inactive_anon:%lukB"
_

Patches currently in -mm which might be from mhocko@suse.com are

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
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
mm-vmscan-cleanup-lru-size-claculations.patch
mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
revert-mm-bail-out-in-shrink_inactive_list.patch
mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch
mm-page_alloc-warn_alloc-print-nodemask.patch
arch-mm-remove-arch-specific-show_mem.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch

