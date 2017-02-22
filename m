From: akpm@linux-foundation.org
Subject: [patch 127/142] mm, page_alloc: do not report all nodes in
 show_mem
Date: Wed, 22 Feb 2017 15:46:07 -0800
Message-ID: <58ae22bf.4CBUv2p5CqfZ+THN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934311AbdBVXqI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:46:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz

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
node statistics to show_mem but it forgot to add skip_free_areas_node
to filter out nodes which are outside of the allocating task numa
policy.  Add this check to not pollute the output with the pointless
information.

Link: http://lkml.kernel.org/r/20170117091543.25850-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-do-not-report-all-nodes-in-show_mem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-do-not-report-all-nodes-in-show_mem
+++ a/mm/page_alloc.c
@@ -4368,6 +4368,9 @@ void show_free_areas(unsigned int filter
 		global_page_state(NR_FREE_CMA_PAGES));
 
 	for_each_online_pgdat(pgdat) {
+		if (skip_free_areas_node(filter, pgdat->node_id))
+			continue;
+
 		printk("Node %d"
 			" active_anon:%lukB"
 			" inactive_anon:%lukB"
_
